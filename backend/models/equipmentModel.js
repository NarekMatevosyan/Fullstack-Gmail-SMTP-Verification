const mongoose = require("mongoose");

const equipmentSchema = mongoose.Schema(
  {
    title: {
      type: String,
    },
    thumbnail: {
      type: String,
    },
    description: {
      type: String,
    },
    link: {
      type: String,
    },
  },
  {
    timestamps: true,
    toJSON: { getters: true },
  }
);

module.exports = mongoose.model("Equipment", equipmentSchema);
