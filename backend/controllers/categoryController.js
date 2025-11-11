const asyncHandler = require("express-async-handler");
const Category = require("../models/categoryModel");
const Exercise = require("../models/exerciseModel");
const { uploadImage } = require("../utils/files/google/gcs");

exports.getCategoriesAdmin = asyncHandler(async (req, res, next) => {
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

    const pipelineCategorys = [];

    if (sortBy) {
      var order = getSortInfo(sortBy);

      pipelineCategorys.push({
        $sort: order,
      });
    }

    // Pagination
    if (perPage && page) {
      const skip = (page - 1) * perPage;
      pipelineCategorys.push({ $skip: skip });
      pipelineCategorys.push({ $limit: parseInt(perPage) });
    }

    const facet = {
      $facet: {
        populatedCategorys: pipelineCategorys,
        totalCount: totalCount,
      },
    };
    pipeline.push(facet);

    const results = await Category.aggregate(pipeline);

    var categories = [];
    var count = 0;
    if (results.length != 0) {
      categories = results[0].populatedCategorys;
      for (let i = 0; i < categories.length; i++){
        var count = await Exercise.countDocuments({ categories: {$in: categories[i]._id.toString() }});
        
        categories[i] = {
          ...categories[i],
          exerciseCount: count,
        }
      }
      if (results[0].totalCount.length != 0)
        count = results[0].totalCount[0].totalMatchingDocuments;
    }

    res.status(200).json({ count: count, categories: categories });
  } catch (error) {
    console.log(error);
  }
});

exports.getCategoryAdmin = asyncHandler(async (req, res, next) => {
  try {
    const category = await Category.findOne({ _id: req.params.id });
    res.status(200).json(category);
  } catch (error) {
    console.log(error);
  }
});

exports.getCategoryTitlesAdmin = asyncHandler(async (req, res, next) => {
  try {
    const filterString = req.query.filterString || "";
    
    const filteredCategorys = await Category.find(
      { title: { $regex: filterString, $options: "i" } },
      { title: 1, _id: 1 }
    );

    res.status(200).json(filteredCategorys);
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: error.message });
  }
});

exports.addCategoryAdmin = asyncHandler(async (req, res, next) => {
  try {
    const title = req.body.title; // Extract title from body
    const documentToInsert = {
      title,
    };
   if (req.files[0]?.buffer)
   {
    const imageUrl = await uploadImage(req.files[0].buffer);
    documentToInsert.thumbnail = imageUrl;
   }
    // Prepare document to insert
    var category = await Category.create(documentToInsert);
    if (category) res.status(200).json({ result: true });
    else res.status(200).json({ result: false });
  } catch (error) {
    console.log(error);
  }
});

exports.updateCategoryAdmin = asyncHandler(async (req, res, next) => {
  try {
    const { _id, title } = req.body;
    let thumbnail;

    // Upload image if it exists
    if (req.files && req.files[0]?.buffer) {
      thumbnail = await uploadImage(req.files[0].buffer);
    }

    // Update category with new title and thumbnail if provided
    const result = await Category.findOneAndUpdate(
      { _id: _id },
      {
        title: title,
        thumbnail: thumbnail,
      }
    );

    console.log("Document updated successfully:", result);
    res.status(200).json({ result: true });
  } catch (error) {
    console.error("Error updating document:", error);
    res.status(500).json({ result: false, message: error.message });
  }
});


exports.deleteCategoryAdmin = asyncHandler(async (req, res, next) => {
  try {
    await Category.findOneAndDelete({ _id: req.params.id })
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

