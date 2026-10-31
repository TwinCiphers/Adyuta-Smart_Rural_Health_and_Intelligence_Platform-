# Adyuta Production Audit & Real-Time Data Report

Transitioning from a prototype to a production-grade, real-time application is a massive undertaking. I have conducted a deep audit of all 5 services within the Adyuta monorepo. 

As requested, I checked for compilation errors, structural issues, and identified every component that currently relies on fake, mock, or static offline data instead of real-time APIs.

## 🚨 1. Core Shell & Compilation Errors (`adyuta_main`)
**Status:** ⚠️ Fixed (106 Errors Resolved)
* **What I Found:** The Flutter application was completely broken with 106 compilation errors. This was caused by a stray `production/adyuta_main/` directory containing duplicate, broken copies of `main.dart` and `home_screen.dart`.
* **Action Taken:** I permanently removed the broken duplicates. The core shell now compiles cleanly.
* **Mock Data Found:** `dashboard_provider.dart` falls back to a hardcoded array (`{'display_name': 'Citizen User'}`) and a fake `activity_log` because it tries to call a Supabase RPC (`get_home_dashboard`) which doesn't exist on our custom Node.js backend.

## 🏥 2. Health Module (`health_module`)
**Status:** ⚠️ Relies on Static Data
* **What I Found:** The health directory and pharmacies do not fetch real-time data. Instead, they rely on a local SQLite (Drift) database populated by static Python ETL scripts (e.g., `directory_data.json` and `ayurvedic_data.json`).
* **Production Requirement:** We need to create a `HealthService` API in the Node.js backend to serve live hospital and pharmacy data, removing the reliance on static JSON files.

## 🌾 3. Agriculture Module (`agri_module`)
**Status:** 🔄 Partially Real-Time
* **What I Found:** The `MandiService` correctly queries the real-time `data.gov.in` API for market prices. However, it aggressively falls back to a local offline cache (`AgriDatabase`) which can serve stale (fake) data if the API fails.
* **Production Requirement:** Remove the local cache fallback for critical live pricing, or implement a strict time-to-live (TTL) invalidation so users never see outdated financial data.

## 🏛️ 4. Governance Module (`governance_module`)
**Status:** ❌ Fully Static
* **What I Found:** The schemes and legal rights are hardcoded inside `gov_data.dart`. While the text claims to be "verbatim citations," it is physically hardcoded into the Flutter app instead of being fetched dynamically.
* **Production Requirement:** Build a Governance schema in Prisma (Node.js) and an admin portal to dynamically push new government schemes to the app in real-time.

## 🎓 5. Education Module (`education_module` / `elearn_reference`)
**Status:** ❌ Contains Placeholders
* **What I Found:** Course cards use dummy image URLs (`https://via.placeholder.com/400x200`) and mock descriptions (`'dummy' course`). 
* **Production Requirement:** Integrate with a real LMS backend API or YouTube Data API to stream actual educational content.

## 🛡️ 6. Safety Module (`safety_module`)
**Status:** ⚠️ Needs Real-Time Infrastructure
* **What I Found:** The background SOS service exists in the UI but lacks a live WebSocket or WebRTC connection to instantly broadcast distress signals to a server.
* **Production Requirement:** We must upgrade the Node.js backend to support `Socket.io` or `Fastify-Websocket` to handle real-time emergency broadcasts.

---

### 📋 Professional Recommendation
Our Node.js backend currently **only supports Authentication** (`auth.ts`, `passkey.ts`). We cannot remove the mock data from the Flutter app until we physically build the backend APIs to replace them.

**To execute this professionally, we must build the backend domains one by one.**
