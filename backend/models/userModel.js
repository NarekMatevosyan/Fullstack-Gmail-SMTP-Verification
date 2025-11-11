const mongoose = require("mongoose");

const userSchema = mongoose.Schema(
  {
    uid: {
      type:Number,
    },
    email: {
      type: String,
      required: [true, "Please add an email"],
      unique: true,
    },
    name: {
      type: String,
    },
    firstName: {
      type: String,
    },
    lastName: {
      type: String,
    },
    role: {
      type: Number,
      default: 0,
    },
    detail: {
      sex: {
        type: Boolean,
      },
      dob: {
        type: Date,
      },
      weight: {
        type: Number,
      },
      height: {
        type: Number,
      },
      location: {
        type: String,
      },
      mygoal: {
        type: String,
      },
      avatarUrl: {
        type: String,
      },
    },
    experience: {
      type: String,
    },
    level: {
      type: Number,
    },
    note: {
      type: String,
    },
    favorites: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Exercise",
      },
    ],
    workoutsHistory: [
      {
        monthIndex: {
          type: Number,
        },
        weekIndex: {
          type: Number,
        },
        dayId: {
          type: mongoose.Schema.Types.ObjectId,
        },
        daySplit: {
          type: Number,
        },
        dayIndex: {
          type: Number,
        },
        day: {
          type: String,
        },
        exercises: [
          {
            // id: mongoose.Schema.Types.ObjectId,
            index: Number,
            exerciseId: String,
            status: String,
            sets: [
              {
                reps: Number,
                weight: Number,
                rest: Number,
              }
            ],
          }
        ],
        exerciseId: {
          type: mongoose.Schema.Types.ObjectId,
        },
        sets: {
          type: Number,
        },
        reps: {
          type: Number,
        },
        weight: {
          type: Number,
        },
        rest: {
          type: Number,
        },
      }
    ],
    dayHistory: [
      {
        monthIndex: {
          type: Number,
        },
        weekIndex: {
          type: Number,
        },
        daySplit: {
          type: Number,
        },
        dayIndex: {
          type: Number,
        },
        state: {
          type: String
        },
        streak: {
          type: Number
        }
      }
    ],
    deviceTokens: [String]
  },
  {
    timestamps: true,
    toJSON: { getters: true },
  }
);

module.exports = mongoose.model("User", userSchema);
