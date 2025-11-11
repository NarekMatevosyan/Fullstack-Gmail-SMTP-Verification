const { Storage } = require("@google-cloud/storage");

const sharp = require("sharp");
const imageSize = require("image-size");

const {
  ALLOWED_IMAGE_FORMATS,
  MAX_IMAGE_SIZE_BYTES,
  MAX_IMAGE_WIDTH,
} = require("../../enum/image");

const projectId = process.env.GOOGLE_CLOUD_PROJECT_ID;
const bucketName = process.env.GOOGLE_CLOUD_BUCKET_NAME;

// Initialize GCS client with your service account credentials
const storage = new Storage({
  keyFilename: "./utils/files/google/bbb-app-d4b41-8bb202309cf1.json", // Replace with the path to your JSON key file
  projectId, // Replace with your Google Cloud project ID
});

/**
 * Uploads an image to Google Cloud Storage (GCS) after resizing and optimization.
 *
 * @param {Buffer} imageBuffer - The image data as a Node.js Buffer.
 * @throws {Error} If there's an issue during image upload or if the image format or size is invalid.
 * @returns {Promise<string>} The public URL of the uploaded image.
 */
const uploadImage = async (imageBuffer) => {
  try {
    // Create a Sharp instance to process the image
    const image = sharp(imageBuffer);

    // Get the original image's metadata, including width and height
    const metadata = await image.metadata();

    // Calculate the new height while maintaining the aspect ratio
    const newHeight = Math.floor(
      (MAX_IMAGE_WIDTH / metadata.width) * metadata.height
    );

    // Resize the image and optimize it
    const optimizedImageBuffer = await image
      .resize({ width: MAX_IMAGE_WIDTH, height: newHeight })
      .jpeg({ quality: 80 }) // Optimize and compress to JPEG with quality
      .toBuffer(); // Get the image buffer after processing

    // Get the dimensions of the optimized image
    const dimensions = imageSize(optimizedImageBuffer);
    const imgFormat = dimensions.type.toLowerCase(); // Convert to lowercase for consistency

    if (!ALLOWED_IMAGE_FORMATS.includes(imgFormat)) {
      throw new Error("Invalid image format");
    }

    // Check if the image size exceeds the maximum allowed size
    if (optimizedImageBuffer.length > MAX_IMAGE_SIZE_BYTES) {
      throw new Error("Image size exceeds the maximum allowed size");
    }

    const uniqueFilename = `${Date.now()}_${Math.floor(
      Math.random() * 1000
    )}.${imgFormat}`; // Adjust the file extension as needed

    // Specify the GCS file path where the image will be stored
    const gcsFilePath = `${uniqueFilename}`; // Change the path as needed

    // Upload the image to GCS
    await storage
      .bucket(bucketName)
      .file(gcsFilePath)
      .save(optimizedImageBuffer);

    // Generate and return the public URL for the uploaded image
    const imageUrl = `https://storage.cloud.google.com/${bucketName}/${gcsFilePath}`;
    return imageUrl;
  } catch (error) {
    console.log("Error uploading image:", error);
    throw error;
  }
};


/**
 * Deletes an image from Google Cloud Storage (GCS) using its URL.
 *
 * @param {string} url - The URL of the image to be deleted.
 * @throws {Error} If there's an issue during image deletion.
 */
const deleteImage = async (url) => {
  try {
    const gcsFilePath = getImageFilenameFromUrl(url);
    
    // Delete the image from GCS
    await storage.bucket(bucketName).file(gcsFilePath).delete();

    console.log(`Image ${gcsFilePath} has been deleted successfully.`);
  } catch (error) {
    console.log("Error deleting image:", error);
    throw error;
  }
};

/**
 * Extracts the filename from a given URL.
 *
 * @param {string} url - The URL from which to extract the filename.
 * @returns {string} The extracted filename.
 */
const getImageFilenameFromUrl = (url) => {
  const parts = url.split("/");

  return parts[parts.length - 1];
};

module.exports = {
  uploadImage,
  deleteImage,
};
