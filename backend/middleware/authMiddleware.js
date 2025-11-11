const jwt = require('jsonwebtoken');
const User = require("../models/userModel");

exports.requiresAuth = async (req, res, next) => {
  try {
    const token = req.headers['auth_token']; // Assuming token is passed in the authorization header
    if (!token) {
      return res.status(403).send('No token provided');
    }

    let decodedToken;
    try {
      decodedToken = await jwt.verify(token, process.env.WOOCOMMERCE_JWT_AUTH_SECURITY_KEY)
    } catch (error) {
      next(error);
      return;
    }
    const user = await User.findOne({uid: decodedToken.data.user.id});
    if (!user) {
      throw new Error("Invalid token");
    }
    req.user = user;
    next();
  } catch (error) {
    console.log(error);
  }
}