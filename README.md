# ADYUTA - Smart Rural Health & Intelligence Platform

![Backend CI](https://github.com/TwinCiphers/Adyuta-Smart_Rural_Health_and_Intelligence_Platform-/actions/workflows/backend-ci.yml/badge.svg)
![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)
![Flutter](https://img.shields.io/badge/Flutter-Mobile-02569B?logo=flutter)

Welcome to the **ADYUTA** platform repository. Adyuta is a voice-first, multi-domain rural services application designed to bring accessible health, agriculture, governance, safety, and educational resources to rural communities. 

This monorepo contains the Node.js/Express backend services, the modular Flutter Android client, the FastAPI Cloud AI service, and comprehensive documentation for the project.

---

## 🏗️ Project Architecture & Phases

Adyuta is built using a highly modular architecture across three distinct phases of development:

### `/phase 1` - Core Backend & Auth System
The robust, secure backend powering the Adyuta ecosystem.
- **Tech Stack:** Node.js, Fastify, Prisma, PostgreSQL, Redis.
- **Auth Stack:** Google Sign-In, Email/Password, Magic Links, Guest Login, TOTP MFA, MPIN, and Biometric Passkeys (powered by `@simplewebauthn/server`).
- **Path:** `/phase 1/apps/backend`

### `/phase 2` - Cloud AI & Voice Services
The intelligent engine providing accessibility and conversational features.
- **AI/Voice Stack:** On-device TFLite classifiers, two-tier RAG (ONNX + Qdrant/ChromaDB), offline STT (Vosk/whisper.cpp), online STT/TTS (Bhashini), and LLM generation (Groq/Gemini).
- **Path:** `/phase 2/cloud_ai_service`

### `/phase 3` - Modular Flutter Frontend
A seamlessly integrated, modular Android application optimized for devices ranging from low-end 2G hardware up to modern 5G flagships.
- **`adyuta_main`**: The core shell and central navigation hub.
- **`health_module`**: Smart health hub, diagnostic integration, and offline directories.
- **`agri_module`**: Farming intelligence and crop tracking.
- **`safety_module`**: Women & Citizen safety features (SOS, background monitoring).
- **`education_module`**: E-Learn rural skills platform.
- **`governance_module`**: SchemeSaathi (Government schemes & legal rights).

---

## 🚀 Getting Started

### 1. Backend Setup
To run the authentication and core backend services locally:

1. Ensure you have Node.js (v20+) installed.
2. Ensure you have Docker running (for PostgreSQL and Redis).
3. Navigate to the backend app:
   ```bash
   cd "phase 1/apps/backend"
   ```
4. Install dependencies:
   ```bash
   npm install
   ```
5. Start the database and sync the Prisma schema:
   ```bash
   docker compose up -d
   npx prisma generate
   npx prisma db push
   ```
6. Run the development server:
   ```bash
   npm run dev
   ```

### 2. Mobile App (Flutter) Setup
To build and run the Android application:

1. Ensure you have the Flutter SDK installed and configured.
2. Navigate to the main Flutter application hub:
   ```bash
   cd "phase 3/adyuta_main"
   ```
3. Fetch dependencies (this will also pull in the local independent modules like `health_module`):
   ```bash
   flutter pub get
   ```
4. Run the app on a connected device (or build the release APK):
   ```bash
   flutter run
   # OR for release
   flutter build apk --release
   ```

---

## 📚 Documentation

For more detailed information, please refer to our documentation directory:
- [Initial Setup Status Report](./phase 1/docs/releases/initial_setup_report.md)
- [Architecture Details](./phase 1/docs/architecture/initial_architecture.jpeg)
- [API Documentation](./phase 1/docs/api/README.md)
- [Roadmap](./phase 1/ROADMAP.md)

## 🤝 Contributing

We welcome contributions! Please review our [Contributing Guidelines](phase 1/CONTRIBUTING.md) before submitting pull requests. 
All pull requests to `main` must pass the automated CI pipeline.

## 🏷️ Versioning

We use Semantic Versioning. See [VERSIONING.md](phase 1/VERSIONING.md) for details.
