# Adyuta - Smart Rural Health & Intelligence Platform
## Complete Development Log & Architecture History (Deep Dive)

This document serves as the absolute "pin-to-pin" architectural blueprint and development log of the Adyuta platform, mapping the data structures, endpoints, machine learning pipelines, and synchronization scripts across all services.

---

### 1. Project Purpose & Scope
Adyuta is an offline-first, voice-enabled multi-domain rural services application. It brings health, agriculture, governance, safety, and educational resources to rural communities with low connectivity. The platform degrades gracefully without internet, relying on local TFLite models and SQLite (Drift) databases, and syncs intelligently when back online.

---

### 2. Phase 1: Core Backend & Auth System (Node.js/Fastify)
The backend acts as the source of truth, handling user authentication, session state, and the central PostgreSQL database via Prisma.

#### 2.1. Authentication Architecture (`src/routes/auth.ts` & `passkey.ts`)
*   **Core Stack:** Fastify, Argon2 (hashing), JWT (JSON Web Tokens), Redis (challenge caching).
*   **Guest Access (`/anonymous`):** Generates a unique guest ID (`guest-<hex>@guest.adyuta.local`), assigns a random Argon2 hash, and issues a 15-minute `accessToken` and a 40-byte hex `refreshToken`. Role defaults to `CITIZEN`.
*   **Standard Auth (`/signup`, `/login`):** 
    *   Uses Zod schemas (`SignupSchema`, `LoginSchema`).
    *   `/login` is rate-limited (5 requests per 15 minutes) and features intentional 1-second delays on failure to prevent timing attacks and brute-forcing.
*   **Token Rotation (`/refresh`):** Validates device-specific sessions via `deviceId` and `x-refresh-token`. Employs refresh token rotation to mitigate token theft.
*   **Biometric Passkeys (`passkey.ts`):** 
    *   Powered by `@simplewebauthn/server`.
    *   `/generate-registration-options`: Fetches user passkeys and generates WebAuthn options. Caches the cryptographic challenge in Redis with a 300-second TTL (`passkey-challenge:<userId>`).
    *   `/verify-registration`: Verifies the challenge, storing `credentialID`, `publicKey` (Buffer), and `counter` (BigInt) in the Prisma `Passkey` table.
    *   `/generate-authentication-options` & `/verify-authentication`: Handles biometric sign-in, verifying against the stored `publicKey` and updating the `counter`.

#### 2.2. Database Schema (Prisma PostgreSQL)
The central App Data schema is mapped explicitly across 5 modules:

*   **Users & State:** `User` (email, phone, Google/Apple IDs, token version, role), `Session` (device tracking, revocation), `Passkey`, `ActivityLog` (auditing per domain), `DomainProfile`.
*   **Health:** `Hospital` (type: PHC, CHC, District), `Pharmacy` (inventory string for live stock).
*   **Agriculture:** `MandiPrice` (commodity, state, market, min/max/modal price), `CropAdvisory` (weather dependencies).
*   **Governance:** `GovernmentScheme` (title, eligibility, verification links).
*   **Education:** `Course` (videoUrl, thumbnail).
*   **Safety:** `SosAlert` (Lat/Lon coordinates, `ACTIVE` status).
*   **Marketplace:** `Product`, `CartItem` (E-commerce extensions).

#### 2.3. Background Sync Jobs (`src/jobs`)
The backend is responsible for pulling authoritative real-world data to serve to the mobile clients.
*   **`agriSync.ts`:** Queries the Government of India Open Data platform (Agmarknet via `data.gov.in`).
    *   *Endpoint:* `https://api.data.gov.in/resource/9ef84268-d588-465a-a308-a864a43d0070`
    *   *Mechanism:* Fetches the latest 100 entries, parses `state`, `market`, `commodity`, `min_price`, `max_price`, and `modal_price`, and upserts them into the `MandiPrice` Postgres table.

---

### 3. Phase 2: Cloud AI & ML Pipeline
The intelligence layer guarantees offline functionality while offering deep cloud-based insights for intent routing and classification.

#### 3.1. Machine Learning Pipeline (`ml_pipeline/health_classifier/train.py`)
*   **Data Preparation:** Ingests CSV data (`symptoms.csv`) using `pandas` and encodes labels with `scikit-learn`'s `LabelEncoder` (saving mappings to `label_mapping.json`).
*   **TensorFlow Architecture:** 
    *   A `TextVectorization` layer (vocab=1000, sequence_length=20).
    *   `Embedding` layer (16 dimensions).
    *   `GlobalAveragePooling1D` followed by Dense ReLU and Softmax layers.
    *   Training incorporates Early Stopping (patience=3).
*   **TFLite Export & Quantization:** The Keras model is converted using `TFLiteConverter`. It applies Post-Training Quantization (`tf.lite.Optimize.DEFAULT`) and enables `SELECT_TF_OPS` to support the TextVectorization op directly on low-end Android devices, outputting `health_classifier.tflite`.

#### 3.2. Cloud AI Service (Python FastAPI)
*   **`/api/v1/predict`:** Simulates heavy NLP execution (LLM fallback) when the offline TFLite model lacks confidence. Returns detailed clinical guidance (e.g., `Medical_Consultation_Required`).
*   **`/api/v1/feedback`:** A continuous learning endpoint. When an Android user corrects an AI prediction, this endpoint appends the `query` and `corrected_label` to local CSV files (e.g., `symptoms.csv`, `safety_queries.csv`), allowing the ML pipeline to auto-retrain and improve over time.

---

### 4. Phase 3: Modular Flutter Frontend
The user interface is built as a highly modular Flutter monorepo (`adyuta_main`) optimized for low-end 2G hardware up to 5G flagships.

#### 4.1. Core Application Shell (`adyuta_main`)
*   **Architecture:** Clean Architecture (Domain, Data, Application, Presentation layers) utilizing Riverpod for state management and GoRouter for deep linking and navigation.
*   **Offline Data (Assets):** Relies heavily on pre-packaged SQLite databases embedded in the APK. 
    *   *Location:* `assets/offline/health/` contains specific databases: `directory.db` (hospitals), `firstaid.db`, `mch.db` (Maternal/Child Health), `medicines.db`, `nutrition.db`, and `phr.db` (Personal Health Records).

#### 4.2. Adyuta Chat Client (`adyuta-chat`)
*   A standalone Flutter Web application used exclusively as a developer tool to test the ADYUTA API, voice pipelines, and LLM honesty metadata.
*   **Dependencies (`pubspec.yaml`):** Integrates `record` (audio capture), `flutter_tts` (text-to-speech output), and `flutter_markdown`. It tests local edge cases by embedding models like `plant_disease.tflite` directly in its web assets.

---

### 5. Current Production Audit & Transition State
The system is currently undergoing a massive transition from a static offline prototype to a fully real-time production platform.
1.  **Resolved:** 106 compilation errors caused by stray duplicated files in the core Flutter shell were permanently purged.
2.  **Health Module Transition:** Moving away from static Python ETL scripts (which generated local JSONs and `ayurvedic_data.json`) toward dynamic syncing via the backend `HealthService`.
3.  **Governance & Education Transition:** The app currently contains hardcoded `gov_data.dart` and placeholder dummy image URLs. These are being mapped directly to the Prisma `GovernmentScheme` and `Course` models.
4.  **Safety Infrastructure:** The SOS background service UI is complete but requires the backend to implement `Fastify-Websocket` or `Socket.io` to transmit live distress signals.
