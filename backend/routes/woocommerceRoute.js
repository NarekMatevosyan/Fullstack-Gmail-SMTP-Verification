const express = require("express");
const router = express.Router();

const { 
    handleWebhook,
} = require("../controllers/woocommerceController.js");

router.post("/webhook", handleWebhook);

module.exports = router;
