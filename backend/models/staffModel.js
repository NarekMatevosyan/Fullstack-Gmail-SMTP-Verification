const mongoose = require("mongoose");

const StaffSchema = mongoose.Schema(
  {
    title: {
      type: String,
    },
    type: {
      type: Number,
    },
    bio: {
      type: String,
    },
    photo: {
      type: String,
    },
  },
  {
    timestamps: true,
    toJSON: { getters: true },
  }
);

module.exports = mongoose.model("Staff", StaffSchema);
