const express = require("express");
const {
  registerUser,
  sendVerificationMail,
  verifyEmail,
  checkUserEmailVerified,
  signInAdmin,
  getUser,
  getUsers,
  updateUser,
  deleteUser,
  getMe,
  exerciseDone,
  dayDone,
  getWorkoutsHistory,
} = require("../controllers/userController");
const { requiresAuth } = require("../middleware/authMiddleware");
const router = express.Router();

router.post("/register_user", registerUser);
router.post("/send_verification_mail", requiresAuth, sendVerificationMail);
router.post("/signin_admin", signInAdmin);

router.get("/admin/:id", requiresAuth, getUser);
router.get("/admin", requiresAuth, getUsers);
router.put("/admin/:id", requiresAuth, updateUser);
router.delete("/admin/:id", requiresAuth, deleteUser);

router.get("/get_user",requiresAuth, getMe);
router.get("/verify_email", verifyEmail);
router.get("/check_user_email_verified", checkUserEmailVerified);
router.put("/:id", updateUser);
router.post("/exercise_done", requiresAuth, exerciseDone);
router.post("/day_done", requiresAuth, dayDone);
router.post("/workouts_history", getWorkoutsHistory);

module.exports = router;