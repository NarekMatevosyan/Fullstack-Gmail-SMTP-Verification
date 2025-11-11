const mongoose = require("mongoose");

const warmupSchema = mongoose.Schema(
  {
    title: {
      type: String,
    },
    vimeoId: {
      type: String,
    },
    description: {
      type: String,
    },
    equipments: {
      type: [mongoose.Schema.Types.ObjectId],
      ref: "Equipment",
    },
  },
  {
    timestamps: true,
    toJSON: { getters: true },
  }
);

module.exports = mongoose.model("Warmup", warmupSchema);
