const express = require("express");
const router = express.Router();
const { requiresAuth } = require("../middleware/authMiddleware.js");

const {
  addRestdayAdmin,
  updateRestdayAdmin,
  deleteRestdayAdmin,
  getRestdaysAdmin,
  getRestdayAdmin,
  getRestdaysTitleAdmin,
} = require("../controllers/restdayController");

router.get("/admin/get", requiresAuth, getRestdaysAdmin);
router.get("/admin/get/:id", requiresAuth, getRestdayAdmin);
router.post("/admin", requiresAuth, addRestdayAdmin);
router.put("/admin", requiresAuth, updateRestdayAdmin);
router.delete("/admin/:id", requiresAuth, deleteRestdayAdmin);
router.get("/admin/titlefilter", requiresAuth, getRestdaysTitleAdmin);

router.get("/get/:id", requiresAuth, getRestdayAdmin);

module.exports = router;