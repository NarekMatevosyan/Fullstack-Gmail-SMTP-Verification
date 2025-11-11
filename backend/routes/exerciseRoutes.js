const express = require("express");
const router = express.Router();
const { requiresAuth } = require("../middleware/authMiddleware.js");

const {
  addExerciseAdmin,
  updateExerciseAdmin,
  deleteExerciseAdmin,
  getExercisesAdmin,
  getExerciseAdmin,
  getExerciseTitlesAdmin,
} = require("../controllers/exerciseController");

router.get("/admin/get", requiresAuth, getExercisesAdmin);
router.get("/admin/get/:id", requiresAuth, getExerciseAdmin);
router.post("/admin", requiresAuth, addExerciseAdmin);
router.put("/admin", requiresAuth, updateExerciseAdmin);
router.delete("/admin/:id", requiresAuth, deleteExerciseAdmin);
router.get("/admin/titlefilter", requiresAuth, getExerciseTitlesAdmin);

router.get("/get", getExercisesAdmin);
router.get("/get/:id", requiresAuth, getExerciseAdmin);

module.exports = router;
