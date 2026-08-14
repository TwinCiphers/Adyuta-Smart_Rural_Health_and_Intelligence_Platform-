# Versioning Strategy

The ADYUTA project uses [Semantic Versioning](https://semver.org/).

Version numbers follow the format: **MAJOR.MINOR.PATCH** (e.g., `1.2.4`)

- **MAJOR** version increments when we make incompatible API changes.
- **MINOR** version increments when we add functionality in a backward compatible manner.
- **PATCH** version increments when we make backward compatible bug fixes.

## Release Process
1. Releases are tagged in Git with a `v` prefix (e.g., `v1.0.0`).
2. Release notes are generated from the `CHANGELOG.md` file.
3. Pre-releases can use suffixes like `-alpha`, `-beta`, or `-rc` (e.g., `v1.0.0-rc.1`).
