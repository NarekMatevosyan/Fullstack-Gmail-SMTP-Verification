const mongoose = require("mongoose");

const tutorialSchema = mongoose.Schema(
  {
    vimeoId: {
      type: String,
    },
    imgUrl: {
      type: String,
    },
    description: {
      type: String,
    },
  },
  {
    timestamps: true,
    toJSON: { getters: true },
  }
);

module.exports = mongoose.model("Tutorial", tutorialSchema);
