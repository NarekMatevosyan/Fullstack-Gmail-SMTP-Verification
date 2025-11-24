# Booty Flutter Test repo

This repository contains the Booty fitness application codebase, split into a Flutter frontend and a Node.js/Express backend. Use this README as the entry point for local development and deployment.

## Project Structure

- `frontend` – Flutter application targeting mobile, desktop, and web.
- `backend` – REST API, authentication, and WooCommerce integrations built on Node.js, Express, and MongoDB.

Each subdirectory includes its own README with additional details once the project is bootstrapped.


## Prerequisites

- Flutter SDK (3.x recommended) with platform toolchains for your target devices.
- Node.js 18+ and npm.
- MongoDB instance (local or hosted).
- WooCommerce store credentials (for production features that rely on the Woo integration).

Optional but recommended:

- Android Studio and Xcode for native builds.
- Firebase project credentials if you plan to use push notifications and analytics.

## Quick Start

Clone the repo and install dependencies for both apps:

```bash
git clone <repo-url>
cd Booty-Flutter

# Backend dependencies
cd backend
npm install
cp .env.example .env  # populate with real values

# Flutter app dependencies
cd ../frontend
flutter pub get
```

### Environment Configuration

Backend expects an `.env` file based on `backend/.env.example`. Typical variables include:

- `PORT` – API port.
- `MONGODB_URI` – MongoDB connection string.
- WooCommerce API keys.
- Firebase service account paths for cloud messaging (if used).

Frontend configuration is handled via `lib` constants and Firebase options in `frontend/lib/firebase_options.dart`. Update these files with your environment-specific values.

## Running Locally

1. Start the backend:

    ```bash
    cd backend
    npm run dev
    ```

2. In a separate terminal, run the Flutter app on your chosen device/emulator:

    ```bash
    cd frontend
    flutter run
    ```

## Testing

- Backend: `npm test` (add tests under `backend/tests`).
- Frontend: `flutter test` (widget and integration tests live under `frontend/test`).


## Additional Resources

- Backend specifics: `backend/README.md`
- Flutter-specific docs: `frontend/README.md`
- Flutter documentation: <https://docs.flutter.dev>
- Node.js documentation: <https://nodejs.org/en/docs>

## Assessment Task

Implement an email address verification workflow in the current registration process using Gmail SMTP.

<img src="https://github.com/user-attachments/assets/88ec20d1-d553-47e8-bc1f-44e9cf05eb08" alt="photo_2025-11-24 23 25 53" height="444" width="auto"/>
