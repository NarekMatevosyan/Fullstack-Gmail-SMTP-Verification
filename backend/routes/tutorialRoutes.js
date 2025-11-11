const express = require("express");
const router = express.Router();
const { requiresAuth } = require("../middleware/authMiddleware.js");

const {
  getTutorials,
  updateTutorials,
} = require("../controllers/tutorialController.js");

router.get("/", requiresAuth, getTutorials);
router.put("/", requiresAuth, updateTutorials);

router.get("/get_screens", getTutorials);

module.exports = router;
