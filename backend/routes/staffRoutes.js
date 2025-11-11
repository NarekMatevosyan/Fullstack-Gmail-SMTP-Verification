const express = require("express");
const router = express.Router();
const {requiresAuth} = require('../middleware/authMiddleware.js');

const {
  getStaffsAdmin,
  addStaffAdmin,
  updateStaffAdmin,
  deleteStaffAdmin,
  getStaffAdmin,
  getStaffTitlesAdmin,
} = require("../controllers/staffController.js");

router.get("/admin/get", getStaffsAdmin);
router.get("/admin/get/:id", requiresAuth, getStaffAdmin);
router.post("/admin", requiresAuth, addStaffAdmin);
router.put("/admin", requiresAuth, updateStaffAdmin);
router.delete("/admin/:id", requiresAuth, deleteStaffAdmin);
router.get("/admin/titlefilter", requiresAuth, getStaffTitlesAdmin);

module.exports = router;
