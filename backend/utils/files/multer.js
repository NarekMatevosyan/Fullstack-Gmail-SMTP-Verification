const multer = require('multer');

// Configuration for image uploads
const imageStorage = multer.memoryStorage(); // You can change the storage destination as needed
const imageFileFilter = (req, file, cb) => {
  // Check the file format (only allow JPG and PNG)
  if (file.mimetype === 'image/jpeg' || file.mimetype === 'image/png') {
    cb(null, true); // Accept the file
  } else {
    cb(new Error('Only JPG and PNG files are allowed'), false); // Reject the file
  }
};
const imageUpload = multer({
  storage: imageStorage,
  fileFilter: imageFileFilter,
  // You can define any other specific configurations for image uploads here
});

module.exports = {
  imageUpload,
};