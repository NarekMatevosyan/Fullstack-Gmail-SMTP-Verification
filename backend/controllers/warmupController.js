const asyncHandler = require("express-async-handler");
const mongoose = require("mongoose");

const Warmup = require("../models/warmupModel");

exports.getWarmupsAdmin = asyncHandler(async (req, res, next) => {
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

    const pipelineWarmups = [];

    if (sortBy) {
      var order = getSortInfo(sortBy);

      pipelineWarmups.push({
        $sort: order,
      });
    }

    // Pagination
    if (perPage && page) {
      const skip = (page - 1) * perPage;
      pipelineWarmups.push({ $skip: skip });
      pipelineWarmups.push({ $limit: parseInt(perPage) });
    }

    const facet = {
      $facet: {
        populatedWarmups: pipelineWarmups,
        totalCount: totalCount,
      },
    };
    pipeline.push(facet);

    const results = await Warmup.aggregate(pipeline);

    var warmups = [];
    var count = 0;

    if (results.length != 0) {
      warmups = results[0].populatedWarmups;

      if (results[0].totalCount.length != 0)
        count = results[0].totalCount[0].totalMatchingDocuments;
    }

    res.status(200).json({ count: count, warmups: warmups });
  } catch (error) {
    console.log(error);
  }
});

exports.getWarmupAdmin = asyncHandler(async (req, res, next) => {
  try {
    const warmup = await Warmup.findOne({ _id: req.params.id });
    res.status(200).json(warmup);
  } catch (error) {
    console.log(error);
  }
});

exports.getWarmupTitlesAdmin = asyncHandler(async (req, res, next) => {
  try {
    const filterString = req.query.filterString || "";
    
    const filteredWarmups = await Warmup.find(
      { title: { $regex: filterString, $options: "i" } },
      { title: 1, _id: 1 }
    );

    res.status(200).json(filteredWarmups);
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: error.message });
  }
});

exports.addWarmupAdmin = asyncHandler(async (req, res, next) => {
  try {
    const { title, vimeoId, description, equipments } = req.body;

    const documentToInsert = {
      title,
      vimeoId,
      description,
      equipments,
    };
    var warmup = await Warmup.create(documentToInsert);
    if (warmup) res.status(200).json({ result: true });
    else res.status(200).json({ result: false });
  } catch (error) {
    console.log(error);
  }
});

exports.updateWarmupAdmin = asyncHandler(async (req, res, next) => {
  try {
    const { _id, title, vimeoId, description, equipments } = req.body;
    
    await Warmup.findOneAndUpdate(
      { _id: _id },
      {
        title: title,
        vimeoId: vimeoId,
        description: description,
        equipments: equipments,
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

exports.deleteWarmupAdmin = asyncHandler(async (req, res, next) => {
  try {
    await Warmup.findOneAndDelete({ _id: req.params.id })
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

