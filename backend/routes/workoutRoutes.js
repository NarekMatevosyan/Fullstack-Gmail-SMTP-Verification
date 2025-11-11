const express = require("express");
const router = express.Router();
const { requiresAuth } = require("../middleware/authMiddleware.js");
const {
  getWorkouts,
  getWorkoutById,
  updateWorkouts,
  getWorkoutForCurrentMonth,
  checkSubscription,
  imageUrlGenerator,
  updateMonths,
} = require("../controllers/workoutsController");

router.get("/", requiresAuth, getWorkouts);
router.get("/:id", requiresAuth, getWorkoutById);
router.put("/update", requiresAuth, updateWorkouts);
router.post("/customize", requiresAuth, updateMonths);
router.post("/current", getWorkoutForCurrentMonth);
router.post("/checkSubscription",requiresAuth, checkSubscription);
router.post("/upload",requiresAuth, imageUrlGenerator);
module.exports = router;
