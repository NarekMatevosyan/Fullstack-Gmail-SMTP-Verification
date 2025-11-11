const asyncHandler = require("express-async-handler");
const mongoose = require("mongoose");

const Restday = require("../models/restdayModel");

exports.getRestdaysAdmin = asyncHandler(async (req, res, next) => {
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

    const pipelineRestdays = [];

    if (sortBy) {
      var order = getSortInfo(sortBy);

      pipelineRestdays.push({
        $sort: order,
      });
    }

    // Pagination
    if (perPage && page) {
      const skip = (page - 1) * perPage;
      pipelineRestdays.push({ $skip: skip });
      pipelineRestdays.push({ $limit: parseInt(perPage) });
    }

    const facet = {
      $facet: {
        populatedRestdays: pipelineRestdays,
        totalCount: totalCount,
      },
    };
    pipeline.push(facet);

    const results = await Restday.aggregate(pipeline);

    var restdays = [];
    var count = 0;

    if (results.length != 0) {
      restdays = results[0].populatedRestdays;

      if (results[0].totalCount.length != 0)
        count = results[0].totalCount[0].totalMatchingDocuments;
    }

    res.status(200).json({ count: count, restdays: restdays });
  } catch (error) {
    console.log(error);
  }
});

exports.getRestdayAdmin = asyncHandler(async (req, res, next) => {
  try {
    const restday = await Restday.findOne({ _id: req.params.id });
    res.status(200).json(restday);
  } catch (error) {
    console.log(error);
  }
});

exports.addRestdayAdmin = asyncHandler(async (req, res, next) => {
  try {
    const { title, vimeoId, description, equipments } = req.body;

    const documentToInsert = {
      title,
      vimeoId,
      description,
      equipments,
    };
    var restday = await Restday.create(documentToInsert);
    if (restday) res.status(200).json({ result: true });
    else res.status(200).json({ result: false });
  } catch (error) {
    console.log(error);
  }
});

exports.updateRestdayAdmin = asyncHandler(async (req, res, next) => {
  try {
    const { _id, title, vimeoId, description, equipments } = req.body;

    await Restday.findOneAndUpdate(
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

exports.deleteRestdayAdmin = asyncHandler(async (req, res, next) => {
  try {
    await Restday.findOneAndDelete({ _id: req.params.id })
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

exports.getRestdaysTitleAdmin = asyncHandler(async (req, res, next) => {
  try {
    const filterString = req.query.filterString || "";
    
    const filteredRestdays = await Restday.find(
      { title: { $regex: filterString, $options: "i" } },
      { title: 1, _id: 1 }
    );
    
    res.status(200).json(filteredRestdays);
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

