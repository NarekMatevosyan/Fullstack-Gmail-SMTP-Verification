const express = require("express");
const router = express.Router();
const {requiresAuth} = require('../middleware/authMiddleware.js');

const {
  getCategoriesAdmin,
  addCategoryAdmin,
  updateCategoryAdmin,
  deleteCategoryAdmin,
  getCategoryAdmin,
  getCategoryTitlesAdmin,
} = require("../controllers/categoryController.js");

router.get("/admin/get", getCategoriesAdmin);
router.get("/admin/get/:id", requiresAuth, getCategoryAdmin);
router.post("/admin", requiresAuth, addCategoryAdmin);
router.put("/admin", requiresAuth, updateCategoryAdmin);
router.delete("/admin/:id", requiresAuth, deleteCategoryAdmin);
router.get("/admin/titlefilter", requiresAuth, getCategoryTitlesAdmin);

module.exports = router;
