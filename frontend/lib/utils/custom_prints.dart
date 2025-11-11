bool debugMode = true; // Set this flag to `false` for release mode

/// Custom print function for red text with error handling in debug mode
void customPrintR(String? message) {
  try {
    if (debugMode) {
      // Check if the message is null or empty
      if (message == null || message.isEmpty) {
        print('\x1B[31m[Error]: Message is null or empty\x1B[0m');
      } else {
        print('\x1B[31m$message\x1B[0m'); // Red
      }
    }
  } catch (e) {
    print('\x1B[31m[Error]: Failed to print message in red. Exception: $e\x1B[0m');
  }
}

/// Custom print function for blue text with error handling in debug mode
void customPrintB(String? message) {
  try {
    if (debugMode) {
      // Check if the message is null or empty
      if (message == null || message.isEmpty) {
        print('\x1B[34m[Error]: Message is null or empty\x1B[0m');
      } else {
        print('\x1B[34m$message\x1B[0m'); // Blue
      }
    }
  } catch (e) {
    print('\x1B[34m[Error]: Failed to print message in blue. Exception: $e\x1B[0m');
  }
}
