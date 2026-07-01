# ADYUTA Platform

![Backend CI](https://github.com/TwinCiphers/Adyuta-Smart_Rural_Health_and_Intelligence_Platform-/actions/workflows/backend-ci.yml/badge.svg)
![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)

Welcome to the ADYUTA platform repository. This is the central monorepo containing the backend services, Android client, and comprehensive documentation for the project.

## 🏗️ Project Structure

- `/apps/backend` - Core backend services and APIs (Fastify, Prisma, PostgreSQL, Redis)
- `/apps/android` - Android client application (Phase 3 - Coming Soon)
- `/docs` - Project documentation (Architecture, APIs, ADRs, Release Notes)
- `/.github` - GitHub templates and workflows (CI/CD)

## 🚀 Getting Started

### Backend Setup
To run the authentication and core backend services locally:

1. Ensure you have Node.js (v20+) installed.
2. Ensure you have Docker running (for PostgreSQL and Redis).
3. Navigate to the backend app:
   ```bash
   cd apps/backend
   ```
4. Install dependencies:
   ```bash
   npm install
   ```
5. Start the database and sync the schema:
   ```bash
   docker compose up -d
   npx prisma db push
   ```
6. Run the development server:
   ```bash
   npm run dev
   ```

*(Instructions for the Android application will be added here once initialized.)*

## 📚 Documentation

For more detailed information, please refer to our documentation:
- [Initial Setup Status Report](./docs/releases/initial_setup_report.md)
- [Architecture Details](./docs/architecture/README.md)
- [API Documentation](./docs/api/README.md)
- [Roadmap](./ROADMAP.md)

## 🤝 Contributing

We welcome contributions! Please review our [Contributing Guidelines](CONTRIBUTING.md) before submitting pull requests. 
All pull requests to `main` must pass the automated CI pipeline.

## 📜 Versioning

We use Semantic Versioning. See [VERSIONING.md](VERSIONING.md) for details.
