const express = require("express");
const router = express.Router();
const { requiresAuth } = require("../middleware/authMiddleware.js");

const {
  getScreens,
  updateScreens,
} = require("../controllers/screenController.js");

router.get("/", requiresAuth, getScreens);
router.put("/", requiresAuth, updateScreens);

router.get("/get_screens", getScreens);

module.exports = router;
