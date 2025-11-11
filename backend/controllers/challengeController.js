const asyncHandler = require('express-async-handler');
const Challenge = require('../models/challengeModel');
const { uploadImage } = require('../utils/files/google/gcs');

exports.getChallengesAdmin = asyncHandler(async (req, res, next) => {
  try {
    var { page = 1, perPage = 10, search, sortBy } = req.query;
    const pipeline = [];

    if (search) {
      pipeline.push({
        $match: {
          $or: [{ title: { $regex: new RegExp(search, 'i') } }],
        },
      });
    }

    const totalCount = [
      {
        $count: 'totalMatchingDocuments',
      },
    ];

    const pipelineChallenges = [];

    if (sortBy) {
      var order = getSortInfo(sortBy);

      pipelineChallenges.push({
        $sort: order,
      });
    }

    // Pagination
    if (perPage && page) {
      const skip = (page - 1) * perPage;
      pipelineChallenges.push({ $skip: skip });
      pipelineChallenges.push({ $limit: parseInt(perPage) });
    }

    const facet = {
      $facet: {
        populatedChallenges: pipelineChallenges,
        totalCount: totalCount,
      },
    };
    pipeline.push(facet);

    const results = await Challenge.aggregate(pipeline);

    var challenges = [];
    var count = 0;

    if (results.length != 0) {
      challenges = results[0].populatedChallenges;

      if (results[0].totalCount.length != 0)
        count = results[0].totalCount[0].totalMatchingDocuments;

      // Populate user details for each challenge
      challenges = await Challenge.populate(challenges, {
        path: 'joinedUsers',
        select: 'name email', // Select specific fields to populate (adjust as necessary)
      });
    }

    res.status(200).json({ count: count, challenges: challenges });
  } catch (error) {
    console.log(error);
  }
});

exports.getChallengeAdmin = asyncHandler(async (req, res, next) => {
  try {
    const challenge = await Challenge.findOne({ _id: req.params.id });
    res.status(200).json(challenge);
  } catch (error) {
    console.log(error);
  }
});

exports.getChallengeTitlesAdmin = asyncHandler(async (req, res, next) => {
  try {
    const filterString = req.query.filterString || '';

    const filteredChallenges = await Challenge.find(
      { title: { $regex: filterString, $options: 'i' } },
      { title: 1, _id: 1 }
    );

    res.status(200).json(filteredChallenges);
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: error.message });
  }
});

exports.addChallengeAdmin = asyncHandler(async (req, res, next) => {
  try {
    const { title, description, isFeatured: isFeaturedText, buttonText, link } = req.body; // Extract title from body
    const isFeatured = isFeaturedText === 'true'
    const documentToInsert = {
      title,
      description,
      isFeatured,
      buttonText,
      link
    };
    if (req.files[0]?.buffer) {
      const imageUrl = await uploadImage(req.files[0].buffer);
      documentToInsert.photo = imageUrl;
    }
    if (isFeatured) {
      await Challenge.updateMany({
        $set: {
          isFeatured: false,
        },
      });
    }
    // Prepare document to insert
    var challenge = await Challenge.create(documentToInsert);
    if (challenge) res.status(200).json({ result: true });
    else res.status(200).json({ result: false });
  } catch (error) {
    console.log(error);
  }
});

exports.updateChallengeAdmin = asyncHandler(async (req, res, next) => {
  try {
    const { _id, title, description, isFeatured: isFeaturedText, link, buttonText } = req.body;
    const isFeatured = isFeaturedText === 'true'
    let photo;

    // Upload image if it exists
    if (req.files && req.files[0]?.buffer) {
      photo = await uploadImage(req.files[0].buffer);
    }

    // Update category with new title and thumbnail if provided
    const result = await Challenge.findOneAndUpdate(
      { _id: _id },
      {
        $set: {
          title: title,
          description: description,
          photo: photo,
          isFeatured: isFeatured,
          buttonText: buttonText,
          link: link
        },
      },
      { new: true } // Return the updated document
    );

    if (isFeatured) {
      await Challenge.updateMany(
        { _id: { $ne: _id } },
        {
          $set: {
            isFeatured: false,
          },
        }
      );
    }

    console.log('Document updated successfully:', result);
    res.status(200).json({ result: true });
  } catch (error) {
    console.error('Error updating document:', error);
    res.status(500).json({ result: false, message: error.message });
  }
});

exports.deleteChallengeAdmin = asyncHandler(async (req, res, next) => {
  try {
    await Challenge.findOneAndDelete({ _id: req.params.id })
      .then((result) => {
        console.log('Document deleted successfully:', result);
        res.status(200).json({ result: true });
      })
      .catch((error) => {
        console.error('Error deleting document:', error);
        res.status(200).json({ result: false, message: error });
      });
  } catch (error) {
    console.log(error);
  }
});

exports.joinChallenge = asyncHandler(async (req, res, next) => {
  try {
    const { _id, joinedUserId } = req.body;

    // Update category with new title and thumbnail if provided
    const result = await Challenge.findOneAndUpdate(
      { _id: _id },
      {
        $addToSet: {
          // This adds joinedUserId to the joinedUsers array if it's not already present
          joinedUsers: joinedUserId,
        },
      },
      { new: true } // Return the updated document
    );

    console.log('Document updated successfully:', result);
    res.status(200).json({ result: true });
  } catch (error) {
    console.error('Error updating document:', error);
    res.status(500).json({ result: false, message: error.message });
  }
});

exports.getFeaturedChallenge = asyncHandler(async (req, res, next) => {
  try {
    const challenge = await Challenge.findOne({ isFeatured: true });
    res.status(200).json(challenge);
  } catch (error) {
    console.log(error);
  }
});

const getSortInfo = (sortBy) => {
  let orderBy, orderDir;

  switch (sortBy) {
    case 'Popularity':
      orderBy = 'popularity';
      orderDir = -1;
      break;
    case 'NameAtoZ':
      orderBy = 'title';
      orderDir = 1;
      break;
    case 'NameZtoA':
      orderBy = 'title';
      orderDir = -1;
      break;
    case 'NewestAdded':
      orderBy = 'createdAt';
      orderDir = -1;
      break;
    case 'OldestAdded':
      orderBy = 'createdAt';
      orderDir = 1;
      break;
    case 'LastViewed':
      orderBy = 'lastview';
      orderDir = -1;
      break;
    default:
      orderBy = 'title';
      orderDir = 1;
      break;
  }

  return { [orderBy]: orderDir };
};

