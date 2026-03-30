## Design Overview
Initialize a Git repository, refine the exclusion list to prevent sensitive metadata leaks, and create a GitHub Action build-and-deploy pipeline for the `docs/` subdirectory.

## Goals

- [x] Secure first commit with all current feature logic.
- [x] Automated GitHub Pages deployment for Starlight documentation.

## Decisions

- **Why GitHub Pages**: Free static hosting that integrates with the source repository without requiring external authentication keys.
- **Workflow**: Pushes to `main` trigger the documentation build.

## Risks / Trade-offs

- **Exposure**: We must ensure `firebase_options.dart` and other keys are correctly managed (ignored if sensitive, or committed if they are public client keys).
- **Build Errors**: Astro build requires a Node.js environment in the CI runner.
