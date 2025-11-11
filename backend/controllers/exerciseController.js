const asyncHandler = require("express-async-handler");
const mongoose = require("mongoose");
const { uploadImage } = require("../utils/files/google/gcs");
const Exercise = require("../models/exerciseModel");
const Equipment = require("../models/equipmentModel");
const Category = require("../models/categoryModel");
exports.getExercisesAdmin = asyncHandler(async (req, res, next) => {
  try {
    var { page = 1, perPage = 10, search, sortBy } = req.query;

    const filterCategoriesString = req.query.filterCategoriesString || "";

    const filteredCategorys = await Category.find(
      { title: { $regex: filterCategoriesString, $options: "i" } },
      { title: 1, _id: 1 }
    );

    const filterEquipmentString = req.query.filterEquipmentString || "";
    
    const filteredEquipments = await Equipment.find(
      { title: { $regex: filterEquipmentString, $options: "i" } },
      { title: 1, _id: 1 }
    );

    const pipeline = [];

    if (search) {
      pipeline.push({
        $match: {
          $or: [
            { title: { $regex: new RegExp(search, "i") } },
            { description: { $regex: new RegExp(search, "i") } },
            { vimeoId: { $regex: new RegExp(search, "i") } },
          ],
        },
      });
    }

    const totalCount = [
      {
        $count: "totalMatchingDocuments",
      },
    ];

    const pipelineExercises = [];

    if (sortBy) {
      var order = getSortInfo(sortBy);

      pipelineExercises.push({
        $sort: order,
      });
    }

    // Pagination
    if (perPage && page) {
      const skip = (page - 1) * perPage;
      pipelineExercises.push({ $skip: skip });
      pipelineExercises.push({ $limit: parseInt(perPage) });
    }

    const facet = {
      $facet: {
        populatedExercises: pipelineExercises,
        totalCount: totalCount,
      },
    };
    pipeline.push(facet);

    const results = await Exercise.aggregate(pipeline);

    var exercises = [];

    if (results.length != 0) {
      exercises = results[0].populatedExercises;

      if (results[0].totalCount.length != 0)
        count = results[0].totalCount[0].totalMatchingDocuments;
    }

    res.status(200).json({ exercises: exercises, categories: filteredCategorys, equipments: filteredEquipments });
  } catch (error) {
    console.log(error);
  }
});

exports.getExerciseAdmin = asyncHandler(async (req, res, next) => {
  try {
    const exercise = await Exercise.findOne({ _id: req.params.id })
    .populate("relatedExercises")
    .populate("usedEquipments");

    res.status(200).json(exercise);
  } catch (error) {
    console.log(error);
  }
});

exports.getExerciseTitlesAdmin = asyncHandler(async (req, res, next) => {
  try {
    const filterString = req.query.filterString || '';
    const filteredExercises = await Exercise.find(
      { title: { $regex: filterString, $options: 'i' } },
      { title : 1 , _id : 1},
    );

    res.status(200).json(filteredExercises);
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: error.message });
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


exports.addExerciseAdmin = asyncHandler(async (req, res, next) => {
  try {
    const { title, description, vimeoId } = req.body;
    const categories = JSON.parse(req.body.categories);
    const usedEquipments = JSON.parse(req.body.usedEquipments);
    const relatedExercises = JSON.parse(req.body.relatedExercises);
    const documentToInsert = {
      title,
      description,
      categories,
      vimeoId,
      usedEquipments,
      relatedExercises,
    };
    let thumbnail;

    // Upload image if it exists
    if (req.files && req.files[0]?.buffer) {
      thumbnail = await uploadImage(req.files[0].buffer);
      documentToInsert.thumbnail = thumbnail;
    }

    var exercise = await Exercise.create(documentToInsert);
    if (exercise) res.status(200).json({ result: true });
    else res.status(200).json({ result: false });
  } catch (error) {
    console.log(error);
  }
});

exports.updateExerciseAdmin = asyncHandler(async (req, res, next) => {
  try {
    const { _id, title, description, vimeoId} = req.body;
    const categories = JSON.parse(req.body.categories);
    const usedEquipments = JSON.parse(req.body.usedEquipments);
    const relatedExercises = JSON.parse(req.body.relatedExercises);
    let thumbnail;
    const documentToInsert = {
      title,
      description,
      categories,
      vimeoId,
      usedEquipments,
      relatedExercises,
    };
    // Upload image if it exists
    if (req.files && req.files[0]?.buffer) {
      thumbnail = await uploadImage(req.files[0].buffer);
      documentToInsert.thumbnail = thumbnail;
    }    
    await Exercise.findOneAndUpdate(
      { _id: _id },
      {
        title: title,
        description: description,
        categories: categories,
        vimeoId: vimeoId,
        thumbnail: thumbnail,
        usedEquipments: usedEquipments,
        relatedExercises: relatedExercises,
      }
    )
      .then((result) => {
        console.log("Document updated successfully:", result);
        res.status(200).json({ result: true });
      })
      .catch((error) => {
        console.error("Error updating document:", error);
        res.status(200).json({ result: false, message: error });
      });
  } catch (error) {
    console.log(error);
  }
});

exports.deleteExerciseAdmin = asyncHandler(async (req, res, next) => {
  try {
    await Exercise.findOneAndDelete({ _id: req.params.id })
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


