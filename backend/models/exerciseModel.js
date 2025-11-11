const mongoose = require("mongoose");

const exerciseSchema = mongoose.Schema(
  {
    title: {
      type: String,
    },
    vimeoId: {
      type: String,
    },
    thumbnail: {
      type: String,
    },
    description: {
      type: String,
    },
    guide: {
      type: String,
    },
    categories: {
      type: [mongoose.Schema.Types.ObjectId],
      ref: "Category",
    },
    usedEquipments: {
      type: [mongoose.Schema.Types.ObjectId],
      ref: "Equipment",
    },
    relatedExercises: {
      type: [mongoose.Schema.Types.ObjectId],
      ref: "Exercise",
    },
  },
  {
    timestamps: true,
    toJSON: { getters: true },
  }
);

module.exports = mongoose.model("Exercise", exerciseSchema);
