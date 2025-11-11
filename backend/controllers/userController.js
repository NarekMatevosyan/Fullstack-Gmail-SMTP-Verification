const asyncHandler = require("express-async-handler");
const User = require("../models/userModel");
const UpdatedMonth = require("../models/updatedWorkoutModel");
const Exercise = require("../models/exerciseModel");
const { getEstTime } = require("../utils/date");

const { generateRandomPassword } = require("../utils/randomPasswordGenerator");
const { default: mongoose } = require("mongoose");
const { getAuth, createUserWithEmailAndPassword, sendPasswordResetEmail } = require("firebase/auth");

exports.registerUser = asyncHandler(async (req, res, next) => {
  const { email, username } = req.body;
  let newUserObject = {};
  let credentials;

  if (!email) {
    res.status(400);
    throw new Error("Please add email");
  }

  const auth = getAuth();

  //check if user exists
  const userExists = await User.findOne({ email });

  if (userExists) {
    res.status(400);
    throw new Error("A user with that email already exists");
  }

  newUserObject = {
    ...newUserObject,
    email,
    username,
    experience: "",
    level: 0,
    role: 0,
    note: "",
    avatarUrl: "",
    favorites: [],
    histories: [],
  };

  try {
    const randomPassword = generateRandomPassword().toString();
    console.log(">>>>>", randomPassword);
    credentials = await createUserWithEmailAndPassword(
      auth,
      email,
      randomPassword
    );

    sendPasswordResetEmail(auth, email);
  } catch (error) {
    res.status(500);
    throw new Error(`Error creating user: ${error.message}`);
  }

  let user = await User.create(newUserObject);

  try {
    user = await user.save();
  } catch (error) {
    console.log(error);
  }

  if (user) {
    res.status(200).json({ message: "User registered" });
  } else {
    res.status(500);
    throw new Error("Invalid user data");
  }
});

exports.getUser = asyncHandler(async (req, res, next) => {
  try {
    const user = await User.findOne({_id: req.params.id});
    const userWorkout = await getWorkoutForCurrentMonthHistory(user.uid);
    user.workout = userWorkout;
    const userResponse = {  
      _id: user._id,  
      email: user.email,  
      uid: user.uid,  
      role: user.role,  
      experience: user.experience,  
      level: user.level,  
      note: user.note,  
      avatarUrl: user.avatarUrl,  
      favorites: user.favorites,  
      createdAt: user.createdAt,  
      updatedAt: user.updatedAt,  
      __v: user.__v,  
      name: user.name,  
      workoutsHistory: user.workoutsHistory,  
      dayHistory: user.dayHistory,  
      workout: userWorkout 
    }
    console.log(userResponse);
    res.status(200).json(userResponse);

  } catch (error) {
    console.log(error);
  }
});
const getWorkoutForCurrentMonthHistory = async (id) => {
  try {
    const estNow = getEstTime();

    const workout = await UpdatedMonth.findOne({
      uid: id,
      $and: [
        { $or: [{ startDate: { $lte: estNow } }, { startDate: null }] },
        { $or: [{ endDate: { $gte: estNow } }, { endDate: null }] }
      ]
    });

    if (!workout) {
      return false;
    }
  
    let exerciseIds = [];
    workout.weeks.forEach((week) => {
      week.days.forEach((day) => {
        day.exercises.forEach((exercise) => {
          if (exercise.exerciseId) {
            exerciseIds.push(exercise.exerciseId);
          }
        });
      });
    });

    const exercises = await Exercise.find({ _id: { $in: exerciseIds } });

    const exerciseMap = {};
    exercises.forEach((exercise) => {
      exerciseMap[exercise._id] = exercise.title;
    });

    workout.weeks = workout.weeks.map((week) => {
      week.days = week.days.map((day) => {
        day.exercises = day.exercises.map((exercise) => {
          return {
            ...exercise,
            name: exerciseMap[exercise.exerciseId] || "",
          };
        });
        return day;
      });
      return week;
    });

    return workout;
  }
  catch (error) {
    console.error('Error updating workouts:', error);
  }
};
exports.getUsers = asyncHandler(async (req, res, next) => {
  try {
    const { search, page = 1, perPage = 10, sortBy} = req.query;

    const pipeline = [];

    const skip = (page - 1) * perPage;

    if (search) {
      pipeline.push({
        $match: {
          $or: [
            { email: { $regex: search, $options: "i" } },
            { firstname: { $regex: search, $options: "i" } },
            { lastname: { $regex: search, $options: "i" } },
            { name: { $regex: search, $options: "i" } },
          ],
        },
      });
    }

    const pipelineUsers = [];

    if (sortBy) {
      var order = getSortInfo(sortBy);

      pipelineUsers.push({
        $sort: order,
      });
    }

    if (perPage && page) {
      const skip = (page - 1) * perPage;
      pipelineUsers.push({ $skip: skip });
      pipelineUsers.push({ $limit: parseInt(perPage) });
    }

    //const totalCount = await User.countDocuments(query);

    const facet = {
      $facet: {
        pipelineUsers: pipelineUsers,
        //totalCount: totalCount,
      },
    };
    pipeline.push(facet);
    
    const results = await User.aggregate(pipeline);

    var users = [];
    var count = 0;

    if (results.length != 0) {
      users = results[0].pipelineUsers;

    //   if (results[0].totalCount.length != 0)
    //     count = results[0].totalCount[0].totalMatchingDocuments;
    // }
    }
    res.status(200).json({ users: users });
  } catch (error) {
    console.log(error);
  }
});

exports.updateUser = asyncHandler(async (req, res, next) => {
  try {
    const { detail, deviceToken } = req.body;
    console.log({detail});
    await User.findOneAndUpdate(
      { _id: req.params.id },
      {
        detail,
        $push: { deviceTokens: deviceToken }
      },
      { new: true }
    )
      .then((result) => {
        console.log("Document updated successfully:", result);
        res.status(200).json({ result });
      })
      .catch((error) => {
        console.error("Error updating document:", error);
        res.status(200).json({ result: false, message: error });
      });
  } catch (error) {
    console.log(error);
  }
});

exports.deleteUser = asyncHandler(async (req, res, next) => {
  try {
    await User.findOneAndDelete({ _id: req.params.id })
      .then((result) => {
        console.log("Document deleted successfully:", result);
        res.status(200).json({ result: true });
      })
      .catch((error) => {
        console.error("Error deleting document:", error);
        res.status(200).json({ result: false, message: error });
      });
  } catch (error) {
    console.log(error);
  }
});

exports.signInAdmin = asyncHandler(async (req, res, next) => {
  try {
    const { email } = req.body;
    const user = await User.findOne({ email: email }).select(["role"]);

    if (!user) {
      res.status(200).json({ result: false });
    } else {
      if (user.role >= 1) res.status(200).json({ result: true });
      // else res.status(200).json({ result: false });
      else console.log(user.role);
    }
  } catch (error) {
    console.log(error);
  }
});

exports.getMe = asyncHandler(async (req, res, next) => {
  try {
    console.log('get_user', req);
    console.log('get_user/user', req.user);

    const user = req.user;
    res.status(200).json(user);
  } catch (error) {
    console.log(error);
  }
});

exports.exerciseDone = asyncHandler(async (req, res, next) => {
  try {
    const { monthIndex, weekIndex, dayId, exerciseId, sets, reps, weight, rest } = req.body;
    const user = req.user;

    if (!user.workoutsHistory) user.workoutsHistory = new Array();

    user.workoutsHistory.push({
      monthIndex : monthIndex,
      weekIndex : weekIndex,
      dayId : new mongoose.Types.ObjectId(dayId),
      exerciseId : new mongoose.Types.ObjectId(exerciseId),
      sets: sets,
      reps: reps,
      weight: weight,
      rest: rest,
    })
    await user.save().then((result) => {
      console.log("history saved successfully:", result);
      res.status(200).json({ result: true });
    }).catch((error) => {
      console.error("Error occurs while saving history:", error);
      res.status(200).json({ result: false, message: error });
    });
  } catch (error) {
    console.log(error);
  }
});

// const dayDone = asyncHandler(async (req, res) => {
//   try {
//     const { monthIndex, weekIndex, daySplit, dayIndex, state, streak } = req.body;
//     const user = req.user;

//     console.log(monthIndex, weekIndex, daySplit, dayIndex, state, streak);
//     console.log(user);
//     if (!user.dayHistory) user.dayHistory = new Array();

//     user.dayHistory.push({
//       monthIndex : parseInt(monthIndex),
//       weekIndex : parseInt(weekIndex),
//       daySplit : parseInt(daySplit),
//       dayIndex : parseInt(dayIndex),
//       state : state,
//       streak: parseInt(streak)
//     })

//     await user.save().then((result) => {
//       console.log("history saved successfully:", result);
//       res.status(200).json({ result: true });
//     }).catch((error) => {
//       console.error("Error occurs while saving history:", error);
//       res.status(200).json({ result: false, message: error });
//     });
//   } catch (error) {
//     console.log(error);
//   }
// });
exports.dayDone = asyncHandler(async (req, res, next) => {
  try {
    const { monthIndex, weekIndex, daySplit, dayIndex, state, streak } = req.body;
    const user = req.user;

    if (!user) {
      return res.status(401).json({ result: false, message: "User not authenticated" });
    }

    if (!user.dayHistory) user.dayHistory = [];

    // Check for duplicate entries
    const existingEntry = user.dayHistory.find(
      (entry) =>
        entry.monthIndex === parseInt(monthIndex, 10) &&
        entry.weekIndex === parseInt(weekIndex, 10) &&
        entry.dayIndex === parseInt(dayIndex, 10) &&
        entry.daySplit === parseInt(daySplit, 10)
    );

    if (existingEntry) {
      return res.status(400).json({ result: false, message: "Entry already exists" });
    }

    // Add a new entry
    user.dayHistory.push({
      monthIndex: parseInt(monthIndex, 10),
      weekIndex: parseInt(weekIndex, 10),
      daySplit: parseInt(daySplit, 10),
      dayIndex: parseInt(dayIndex, 10),
      state: state,
      streak: parseInt(streak, 10),
    });

    // Save to database
    await user.save().then((result) => {
      console.log("History saved successfully:", result);
      res.status(200).json({ result: true });
    }).catch((error) => {
      console.error("Error occurs while saving history:", error);
      res.status(500).json({ result: false, message: "Database save error", error });
    });
  } catch (error) {
    console.error("Error processing request:", error);
    res.status(500).json({ result: false, message: "Internal server error", error });
  }
});


exports.getWorkoutsHistory = asyncHandler(async (req, res, next) => {
  try {
    const { monthIndex, weekIndex, dayIndex, day, daySplit, exercises } = req.body;
    const userId = req.user;
    const user = await User.findOne({id: userId});

    if (!user.workoutsHistory) user.workoutsHistory = new Array();
    if (!user.workoutsHistory.exercises) user.workoutsHistory.exercises = new Array();
    if (!user.workoutsHistory.exercises.sets) user.workoutsHistory.exercises.sets = new Array();

    user.workoutsHistory.push({
      monthIndex : monthIndex,
      weekIndex : weekIndex,
      daySplit : daySplit,
      dayIndex : dayIndex,
      day : day,
    })
    exercises.map(exercise => {
      user.workoutsHistory.exercises.push(
        {
        exerciseId: exercise.exerciseId,
        status: exercise.status,
        }
      )
    });
    await user.save().then((result) => {
      console.log("history saved successfully:", result);
      res.status(200).json({ result: true });
    }).catch((error) => {
      console.error("Error occurs while saving history:", error);
      res.status(200).json({ result: false, message: error });
    });
  } catch (error) {
    console.log(error);
  }
});

const getSortInfo = (sortBy) => {
  let orderBy, orderDir;

  switch (sortBy) {
    case "Popularity":
      orderBy = "popularity";
      orderDir = -1;
      break;
    case "NameAtoZ":
      orderBy = "name";
      orderDir = 1;
      break;
    case "NameZtoA":
      orderBy = "name";
      orderDir = -1;
      break;
    case "NewestAdded":
      orderBy = "createdAt";
      orderDir = -1;
      break;
    case "OldestAdded":
      orderBy = "createdAt";
      orderDir = 1;
      break;
    case "LastViewed":
      orderBy = "lastview";
      orderDir = -1;
      break;
    default:
      orderBy = "name";
      orderDir = 1;
      break;
  }

  return { [orderBy]: orderDir };
};

