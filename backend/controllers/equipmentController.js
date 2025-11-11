const asyncHandler = require("express-async-handler");
const { uploadImage } = require("../utils/files/google/gcs");
const Equipment = require("../models/equipmentModel");

exports.getEquipmentsAdmin = asyncHandler(async (req, res, next) => {
  try {
    var { page = 1, perPage = 10, search, sortBy } = req.query;

    const pipeline = [];

    if (search) {
      pipeline.push({
        $match: {
          $or: [
            { title: { $regex: new RegExp(search, "i") } },
            { description: { $regex: new RegExp(search, "i") } },
          ],
        },
      });
    }

    const totalCount = [
      {
        $count: "totalMatchingDocuments",
      },
    ];

    const pipelineEquipments = [];

    if (sortBy) {
      var order = getSortInfo(sortBy);

      pipelineEquipments.push({
        $sort: order,
      });
    }

    // Pagination
    if (perPage && page) {
      const skip = (page - 1) * perPage;
      pipelineEquipments.push({ $skip: skip });
      pipelineEquipments.push({ $limit: parseInt(perPage) });
    }

    const facet = {
      $facet: {
        populatedEquipments: pipelineEquipments,
        totalCount: totalCount,
      },
    };
    pipeline.push(facet);

    const results = await Equipment.aggregate(pipeline);

    var equipments = [];
    var count = 0;

    if (results.length != 0) {
      equipments = results[0].populatedEquipments;

      if (results[0].totalCount.length != 0)
        count = results[0].totalCount[0].totalMatchingDocuments;
    }

    res.status(200).json({ count: count, equipments: equipments });
  } catch (error) {
    console.log(error);
  }
});

exports.getEquipmentAdmin = asyncHandler(async (req, res, next) => {
  try {
    const equipment = await Equipment.findOne({ _id: req.params.id });
    res.status(200).json(equipment);
  } catch (error) {
    console.log(error);
  }
});

exports.getEquipmentTitlesAdmin = asyncHandler(async (req, res, next) => {
  try {
    const filterString = req.query.filterString || "";
    
    const filteredEquipments = await Equipment.find(
      { title: { $regex: filterString, $options: "i" } },
      { title: 1, _id: 1 }
    );

    res.status(200).json(filteredEquipments);
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: error.message });
  }
});

exports.addEquipmentAdmin = asyncHandler(async (req, res, next) => {
  try {
    const { title, description, link } = req.body;  
    const documentToInsert = {
      title,
      description,
      link,
    };
    if (req.files[0]?.buffer)
      {
       const imageUrl = await uploadImage(req.files[0].buffer);
       documentToInsert.thumbnail = imageUrl;
      }

    var equipment = await Equipment.create(documentToInsert);
    if (equipment) res.status(200).json({ result: true });
    else res.status(200).json({ result: false });
  } catch (error) {
    console.log(error);
  }
});

exports.updateEquipmentAdmin = asyncHandler(async (req, res, next) => {
  try {
    const { _id, title, description, link } = req.body;
    let thumbnail;

    // Upload image if it exists
    if (req.files && req.files[0]?.buffer) {
      thumbnail = await uploadImage(req.files[0].buffer);
    }

    // Update category with new title and thumbnail if provided
    const result = await Equipment.findOneAndUpdate(
      { _id: _id },
      {
        title: title
        ,description: description
        ,link: link
        ,thumbnail: thumbnail,
      }
    );

    console.log("Document updated successfully:", result);
    res.status(200).json({ result: true });
  } catch (error) {
    console.error("Error updating document:", error);
    res.status(500).json({ result: false, message: error.message });
  }
});

exports.deleteEquipmentAdmin = asyncHandler(async (req, res, next) => {
  try {
    await Equipment.findOneAndDelete({ _id: req.params.id })
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

