const asyncHandler = require("express-async-handler");

const Screen = require("../models/screenModel");
const { uploadImage } = require("../utils/files/google/gcs");

exports.getScreens = asyncHandler(async (req, res, next) => {
  try {
    const screen = await Screen.findOne({});
    res.status(200).json(screen);
  } catch (e) {
    console.log(e);
  }
});

exports.updateScreens = asyncHandler(async (req, res, next) => {
  try {
    const { vimeoId, description } = req.body;
    let thumbnail;

    if (req.files && req.files[0]?.buffer) {
      thumbnail = await uploadImage(req.files[0].buffer);
    }

    await Screen.findOneAndUpdate(
      {},
      { vimeoId: vimeoId, imgUrl: thumbnail, description: description },
      { upsert: true, new: true }
    )
      .then((doc) => {
        console.log("Document updated successfully:", doc);
        res.status(200).json({ result: true });
      })
      .catch((error) => {
        console.error("Error updating document:", error);
        res.status(200).json({ result: false, message: error });
      });
  } catch (e) {
    console.log(e);
  }
});

