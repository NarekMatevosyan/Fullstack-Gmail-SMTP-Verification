const express = require("express");
const router = express.Router();
const {requiresAuth} = require('../middleware/authMiddleware.js');

const {
  getChallengesAdmin,
  addChallengeAdmin,
  updateChallengeAdmin,
  deleteChallengeAdmin,
  getChallengeAdmin,
  getChallengeTitlesAdmin,
  joinChallenge,
  getFeaturedChallenge,
} = require("../controllers/challengeController.js");

router.get("/get", requiresAuth, getChallengesAdmin);
router.get("/get-featured", requiresAuth, getFeaturedChallenge);
router.put("/", requiresAuth, joinChallenge);

router.get("/admin/get", requiresAuth, getChallengesAdmin);
router.get("/admin/get/:id", requiresAuth, getChallengeAdmin);
router.post("/admin", requiresAuth, addChallengeAdmin);
router.put("/admin", requiresAuth, updateChallengeAdmin);
router.delete("/admin/:id", requiresAuth, deleteChallengeAdmin);
router.get("/admin/titlefilter", requiresAuth, getChallengeTitlesAdmin);

module.exports = router;
