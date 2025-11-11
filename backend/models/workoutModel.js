const mongoose = require("mongoose");

const dayExtraExerciseSchema = mongoose.Schema({
  sets: { type: Number },
  reps: { type: Number },
  weight: { type: Number },
  rest: { type: Number },
  load: { type: Number },
  type: { type: Number },
});

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
  extra: [dayExtraExerciseSchema]
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
  index: { type: Number },
  title: { type: String },
  description: { type: String },
  vimeoId: { type: String },
  thumbnail: { type: String },
  startDate: { type: Date },
  endDate: { type: Date },
  weeks: [weekSchema],
});

const Month = mongoose.model("Month", monthSchema);

module.exports = Month;
