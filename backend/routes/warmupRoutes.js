const express = require("express");
const router = express.Router();
const { requiresAuth } = require("../middleware/authMiddleware.js");

const {
  addWarmupAdmin,
  updateWarmupAdmin,
  deleteWarmupAdmin,
  getWarmupsAdmin,
  getWarmupAdmin,
  getWarmupTitlesAdmin,
} = require("../controllers/warmupController");

router.get("/admin/get", requiresAuth, getWarmupsAdmin);
router.get("/admin/get/:id", requiresAuth, getWarmupAdmin);
router.post("/admin", requiresAuth, addWarmupAdmin);
router.put("/admin", requiresAuth, updateWarmupAdmin);
router.delete("/admin/:id", requiresAuth, deleteWarmupAdmin);
router.get("/admin/titlefilter", requiresAuth, getWarmupTitlesAdmin);

router.get("/get/:id", requiresAuth, getWarmupAdmin);

module.exports = router;