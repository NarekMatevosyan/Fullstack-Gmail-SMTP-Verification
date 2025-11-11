/* global process */
/* eslint-disable no-unused-vars */

const axios = require("axios");

const getSubscriptionStatus = async (uid) => {
  try {
    const response = await axios.get(
      `${process.env.WOOCOMMERCE_API_URL}/wp-json/wc/v3/subscriptions?customer=${uid}&status=active`,
      {
        auth: {
          username: process.env.WOOCOMMERCE_CONSUMER_KEY,
          password: process.env.WOOCOMMERCE_CONSUMER_SECRET,
        },
      }
    );

    let isPT = false;
    let isPTA = false;

    for (const subscription of response.data) {
      const items = subscription.line_items;
      for (const item of items) {
        if (item.product_id.toString() === process.env.PT_SUBSCRIPTION_ID)
          isPT = true;
        if (item.product_id.toString() === process.env.PTA_SUBSCRIPTION_ID)
          isPTA = true;
      }
    }

    return { isPT: isPT, isPTA: isPTA };
  } catch (error) {
    console.error(error);
    throw new Error("Failed to get subscription status");
  }
};

module.exports = {
  getSubscriptionStatus,
};
