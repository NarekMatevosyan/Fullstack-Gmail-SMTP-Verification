const express = require("express");
const router = express.Router();
const { requiresAuth } = require("../middleware/authMiddleware.js");

const {
  addEquipmentAdmin,
  updateEquipmentAdmin,
  deleteEquipmentAdmin,
  getEquipmentsAdmin,
  getEquipmentAdmin,
  getEquipmentTitlesAdmin,
} = require("../controllers/equipmentController");

router.get("/admin/get", requiresAuth, getEquipmentsAdmin);
router.get("/admin/get/:id", requiresAuth, getEquipmentAdmin);
router.post("/admin", requiresAuth, addEquipmentAdmin);
router.put("/admin", requiresAuth, updateEquipmentAdmin);
router.delete("/admin/:id", requiresAuth, deleteEquipmentAdmin);
router.get("/admin/titlefilter", requiresAuth, getEquipmentTitlesAdmin);

module.exports = router;