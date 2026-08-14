# Contributing to ADYUTA

Thank you for investing your time in contributing to ADYUTA! 

## Branch Naming Convention

Please create your branches using the following format:
- `feature/<issue-number>-<short-description>` (e.g., `feature/12-user-auth`)
- `bugfix/<issue-number>-<short-description>` (e.g., `bugfix/34-login-crash`)
- `chore/<short-description>` (e.g., `chore/update-deps`)
- `docs/<short-description>` (e.g., `docs/add-api-spec`)

## Commit Messages

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:
- `feat:` A new feature
- `fix:` A bug fix
- `docs:` Documentation only changes
- `chore:` Changes to the build process or auxiliary tools/libraries

**Example:**
`feat(auth): implement JWT token generation`

## Pull Request Process

1. Ensure any install or build dependencies are removed before the end of the layer when doing a build.
2. Update the README.md with details of changes to the interface, if applicable.
3. Your PR must pass all CI checks before it can be merged.
4. You may merge the Pull Request in once you have the sign-off of at least one other developer.
