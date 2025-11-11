const mongoose = require("mongoose");

const dayExerciseSchema = mongoose.Schema({
  typeId: { type: Number },
  exerciseId: { type: mongoose.Schema.Types.ObjectId, ref: 'Exercise' },
  name: {type: String},
  guide: { type: String },
  sets: { type: Number },
  reps: { type: Number },
  weight: { type: Number },
  rest: { type: Number },
  formats: { type: [String] },
});

const dayWarmupSchema = mongoose.Schema({
  typeId: { type: Number },
  warmupId: { type: mongoose.Schema.Types.ObjectId, ref: 'Warmup' },
  title: { type: String },
  guide: { type: String },
  formats: { type: [String] },
});

const daySchema = mongoose.Schema({
  typeId: { type: Number },
  title: { type: String },
  description: { type: String },
  vimeoId: { type: String },
  thumbnail: { type: String },
  formats: { type: [String] },
  warmups: [dayWarmupSchema],
  exercises: [dayExerciseSchema],
});

const weekSchema = mongoose.Schema({
  index: { type: Number },
  title: { type: String },
  description: { type: String },
  vimeoId: { type: String },
  thumbnail: { type: String },
  restdayId: { type: String},
  days: [daySchema],
});

const monthSchema = mongoose.Schema({
  uid: { type: Number },
  index: { type: Number },
  title: { type: String },
  description: { type: String },
  vimeoId: { type: String },
  thumbnail: { type: String },
  startDate: { type: Date },
  endDate: { type: Date },
  weeks: [weekSchema],
});

const UpdatedMonth = mongoose.model("UpdatedMonth", monthSchema);

module.exports = UpdatedMonth;
