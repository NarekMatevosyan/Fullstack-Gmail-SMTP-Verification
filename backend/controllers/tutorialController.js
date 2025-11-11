const asyncHandler = require("express-async-handler");

const Tutorial = require("../models/tutorialModel");
const { uploadImage } = require("../utils/files/google/gcs");

exports.getTutorials = asyncHandler(async (req, res, next) => {
  try {
    const tutorial = await Tutorial.findOne({});
    res.status(200).json(tutorial);
  } catch (e) {
    console.log(e);
  }
});

exports.updateTutorials = asyncHandler(async (req, res, next) => {
  try {
    const { vimeoId, description } = req.body;
    console.log(description);
    let thumbnail;

    // Upload image if it exists
    if (req.files && req.files[0]?.buffer) {
      thumbnail = await uploadImage(req.files[0].buffer);
    }

    await Tutorial.findOneAndUpdate(
      {},
      { vimeoId: vimeoId, imgUrl: thumbnail, description: description },
      { upsert: true, new: true }
    )
      .then((doc) => {
        res.status(200).json({ result: true });
      })
      .catch((error) => {
        res.status(200).json({ result: false, message: error });
      });
  } catch (e) {
    console.log(e);
  }
});

