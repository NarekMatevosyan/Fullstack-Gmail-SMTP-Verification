const WOOCOMMERCE_WEBHOOK_EVENTS = {
  SubscriptionCreated: "subscription.created",
  SubscriptionUpdated: "subscription.updated",
  SubscriptionDeleted: "subscription.deleted",
  CustomerCreated: "customer.created",
  CustomerUpdated: "customer.updated",
  CustomerDeleted: "customer.deleted",
};

const SUBSCRIPTION_STATUS = {
  Active: 'active',
  OnHold: 'on-hold',
  Cancelled: 'cancelled',
  PendingCancel: 'pending-cancel',
  Expired: 'expired',
  Suspended: 'suspended',
}

module.exports = {
  WOOCOMMERCE_WEBHOOK_EVENTS,
  SUBSCRIPTION_STATUS,
};
