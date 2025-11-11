const asyncHandler = require("express-async-handler");
const User = require("../models/userModel");
const crypto = require("crypto");
const { WOOCOMMERCE_WEBHOOK_EVENTS } = require("../utils/enum/woocommerce");

const generateWebhookSignature = (payload, webhookSecret) => {
  const hmac = crypto.createHmac("sha256", webhookSecret);
  hmac.update(payload, "utf8");
  const signature = hmac.digest("base64");
  return signature;
};

exports.handleWebhook = asyncHandler(async (req, res, next) => {
  const webhookSecret = req.headers["x-wc-webhook-signature"];
  const webhookEvent = req.headers["x-wc-webhook-topic"];

  try {
    if (
      !(
        webhookEvent === WOOCOMMERCE_WEBHOOK_EVENTS.CustomerCreated ||
        webhookEvent === WOOCOMMERCE_WEBHOOK_EVENTS.CustomerUpdated ||
        webhookEvent === WOOCOMMERCE_WEBHOOK_EVENTS.CustomerDeleted
      )
    )
      return res.status(200).send("incorrect webhook received");

    const generatedSignature = generateWebhookSignature(
      req.rawBody,
      process.env.WOOCOMMERCE_WEBHOOK_SECRET
    );

    if (webhookSecret !== generatedSignature) {
      return res.status(200).send("webhook is unauthorized");
    }

    const webhookData = req.body;

    console.log("-----------------------webhook received------------------");
    console.log(webhookData);

    await processWebhook(res, webhookData, webhookEvent);
  } catch (error) {
    console.error("Error processing webhook:", error);
    res.status(500).send("Internal Server Error");
  }
});

async function processWebhook(res, webhookData, webhookEvent) {
  if (webhookData && webhookEvent) {
    switch (webhookEvent) {
      case WOOCOMMERCE_WEBHOOK_EVENTS.CustomerCreated:
        await createCustomer(res, webhookData);
        break;
      case WOOCOMMERCE_WEBHOOK_EVENTS.CustomerUpdated:
        await updateCustomer(res, webhookData);
        break;
      case WOOCOMMERCE_WEBHOOK_EVENTS.CustomerDeleted:
        await deleteCustomer(res, webhookData);
        break;
      default:
        console.warn("Unknown webhook event:", webhookEvent);
    }
  } else {
    console.warn("Unsupported webhook event:", webhookEvent);
  }
}


async function createCustomer(res, webhookData) {
  try {
    const documentToInsert = {
      uid: webhookData.id,
      name: webhookData.first_name,
      firstName: webhookData.first_name,
      lastName: webhookData.last_name,
      email: webhookData.email
    };
    const result = await User.create(documentToInsert);
    console.log("Customer created successfully", result);
    return res.status(200).json({ result: true });
  } catch (error) {
    console.error("Failed to create the customer", error);
    return res.status(200).json({ result: false, message: error.message });
  }
}

async function updateCustomer(res, webhookData) {
  try {
    console.log("Customer info updated successfully");
    res.status(200).json({ result: true });
  } catch (error) {
    console.error("Failed to update customer info:", error);
    res.status(500).json({ result: false, message: error.message });
  }
}

async function deleteCustomer(res, webhookData) {
  try {
    const result = await User.deleteOne({ uid: webhookData.id });

    if (result.deletedCount === 0)
      return res.status(404).json({ result: false, message: "Customer not found" });

    console.log("Customer deleted successfully");
    res.status(200).json({ result: true });
  } catch (error) {
    console.error("Failed to delete customer:", error);
    res.status(500).json({ result: false, message: error.message });
  }
}

