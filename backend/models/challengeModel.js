const mongoose = require("mongoose");

const ChallengeSchema = mongoose.Schema(
  {
    title: {
      type: String,
    },
    description: {
      type: String,
    },
    buttonText: {
      type: String,
    },
    photo: {
      type: String,
    },
    link: {
      type: String,
    },
    isFeatured: {
      type: Boolean,
    },
    joinedUsers: {
        type: [mongoose.Schema.Types.ObjectId],
        ref: "User",
      }
  },
  {
    timestamps: true,
    toJSON: { getters: true },
  }
);

module.exports = mongoose.model("Challenge", ChallengeSchema);
