const asyncHandler = require("express-async-handler");
const Staff = require("../models/staffModel");
const { uploadImage } = require("../utils/files/google/gcs");

exports.getStaffsAdmin = asyncHandler(async (req, res, next) => {
  try {
    var { page = 1, perPage = 10, search, sortBy } = req.query;
    const pipeline = [];

    if (search) {
      pipeline.push({
        $match: {
          $or: [
            { title: { $regex: new RegExp(search, "i") } },
          ],
        },
      });
    }

    const totalCount = [
      {
        $count: "totalMatchingDocuments",
      },
    ];

    const pipelineStaffs = [];

    if (sortBy) {
      var order = getSortInfo(sortBy);

      pipelineStaffs.push({
        $sort: order,
      });
    }

    // Pagination
    if (perPage && page) {
      const skip = (page - 1) * perPage;
      pipelineStaffs.push({ $skip: skip });
      pipelineStaffs.push({ $limit: parseInt(perPage) });
    }

    const facet = {
      $facet: {
        populatedStaffs: pipelineStaffs,
        totalCount: totalCount,
      },
    };
    pipeline.push(facet);

    const results = await Staff.aggregate(pipeline);

    var staffs = [];
    var count = 0;

    if (results.length != 0) {
      staffs = results[0].populatedStaffs;

      if (results[0].totalCount.length != 0)
        count = results[0].totalCount[0].totalMatchingDocuments;
    }
    console.log("staffs", staffs)

    res.status(200).json({ count: count, staffs: staffs });
  } catch (error) {
    console.log(error);
  }
});

exports.getStaffAdmin = asyncHandler(async (req, res, next) => {
  try {
    const staff = await Staff.findOne({ _id: req.params.id });
    res.status(200).json(staff);
  } catch (error) {
    console.log(error);
  }
});

exports.getStaffTitlesAdmin = asyncHandler(async (req, res, next) => {
  try {
    const filterString = req.query.filterString || "";
    
    const filteredStaffs = await Staff.find(
      { title: { $regex: filterString, $options: "i" } },
      { title: 1, _id: 1 }
    );

    res.status(200).json(filteredStaffs);
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: error.message });
  }
});

exports.addStaffAdmin = asyncHandler(async (req, res, next) => {
  try {
    const {title, type, bio} = req.body; // Extract title from body
    const documentToInsert = {
      title,
      type,
      bio
    };
   if (req.files[0]?.buffer)
   {
    const imageUrl = await uploadImage(req.files[0].buffer);
    documentToInsert.photo = imageUrl;
   }
    // Prepare document to insert
    var staff = await Staff.create(documentToInsert);
    if (staff) res.status(200).json({ result: true });
    else res.status(200).json({ result: false });
  } catch (error) {
    console.log(error);
  }
});

exports.updateStaffAdmin = asyncHandler(async (req, res, next) => {
  try {
    const { _id, title, type, bio } = req.body;
    let photo;

    // Upload image if it exists
    if (req.files && req.files[0]?.buffer) {
        photo = await uploadImage(req.files[0].buffer);
    }

    // Update category with new title and thumbnail if provided
    const result = await Staff.findOneAndUpdate(
      { _id: _id },
      {
        title: title,
        type: type,
        bio: bio,
        photo: photo,
      }
    );

    console.log("Document updated successfully:", result);
    res.status(200).json({ result: true });
  } catch (error) {
    console.error("Error updating document:", error);
    res.status(500).json({ result: false, message: error.message });
  }
});


exports.deleteStaffAdmin = asyncHandler(async (req, res, next) => {
  try {
    await Staff.findOneAndDelete({ _id: req.params.id })
      .then((result) => {
        console.log("Document deleted successfully:", result);
        res.status(200).json({ result: true });
      })
      .catch((error) => {
        console.error("Error deleting document:", error);
        res.status(200).json({ result: false, message: error });
      });
  } catch (error) {
    console.log(error);
  }
});

const getSortInfo = (sortBy) => {
  let orderBy, orderDir;

  switch (sortBy) {
    case "Popularity":
      orderBy = "popularity";
      orderDir = -1;
      break;
    case "NameAtoZ":
      orderBy = "title";
      orderDir = 1;
      break;
    case "NameZtoA":
      orderBy = "title";
      orderDir = -1;
      break;
    case "NewestAdded":
      orderBy = "createdAt";
      orderDir = -1;
      break;
    case "OldestAdded":
      orderBy = "createdAt";
      orderDir = 1;
      break;
    case "LastViewed":
      orderBy = "lastview";
      orderDir = -1;
      break;
    default:
      orderBy = "title";
      orderDir = 1;
      break;
  }

  return { [orderBy]: orderDir };
};

