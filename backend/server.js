// Import required packages and modules
const express = require("express");
const http = require("http");
const connectDB = require("./config/db");
const cors = require("cors");
const mongoSanitize = require("express-mongo-sanitize");
const multer = require("multer");

require("dotenv").config();

// Define the port on which the server will run
const port = process.env.PORT || 5004;

// Connect to the database
connectDB().catch(err => {
  console.error("Database connection error:", err);
  process.exit(1); // Exit the process if the connection fails
});

// Create the Express application
const app = express();

var corsOptions = {
  origin: ["https://bbb-cms-app-i3tt8.ondigitalocean.app", "https://bbb-cms-1cdf289157e2.herokuapp.com"],
  optionsSuccessStatus: 200, // For legacy browser support
};

if (process.env.NODE_ENV === "development") {
  corsOptions.origin.push("http://localhost:3000");
  corsOptions.origin.push("http://192.168.101.139:5004");
}

const storage = multer.memoryStorage();
const upload = multer({ storage});
// Enable cross-origin resource sharing
app.use(cors(corsOptions));

// Parse incoming JSON data
// app.use(express.json());
app.use(express.json({ verify: (req, res, buf) => { req.rawBody = buf } }));
// Parse incoming URL-encoded data
app.use(express.urlencoded({ extended: true }));

app.use(mongoSanitize());
app.use(upload.any());

// Define routes for the API
app.use("/api/screens", require("./routes/screenRoutes"));
app.use("/api/tutorials", require("./routes/tutorialRoutes"));
app.use("/api/users", require("./routes/userRoutes"));
app.use("/api/workouts", require("./routes/workoutRoutes"));
app.use("/api/exercises", require("./routes/exerciseRoutes"));
app.use("/api/warmups", require("./routes/warmupRoutes"));
app.use("/api/equipments", require("./routes/equipmentRoutes"));
app.use("/api/restdays", require("./routes/restdayRoutes"));
app.use("/api/categories", require("./routes/categoryRoutes"));
app.use("/api/staffs", require("./routes/staffRoutes"));
app.use("/api/challenges", require("./routes/challengeRoutes"));
app.use("/api/woocommerce", require("./routes/woocommerceRoute"));
const server = http.createServer(app);

// Error handling for server startup
server.listen(port, (err) => {
  if (err) {
    console.error("Server startup error:", err);
    return;
  }
  console.log(`Server started on port ${port}`);
});
