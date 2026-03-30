## Why
The project lacks a centralized version control repository and automated deployment for its documentation. To ensure code safety, team collaboration, and scalable knowledge management, we must initialize a Git repository and establish a CI/CD pipeline for the new Documentation Center.

## What Changes
- [NEW] Comprehensive `.gitignore` covering Flutter and Astro (Starlight).
- [NEW] GitHub Action (`docs.yml`) for automated Starlight deployment to GitHub Pages.
- [MODIFY] Initial commit of all existing workspace files.

## Capabilities

### New Capabilities
- `git-infrastructure`: Root-level version control for the entire project.
- `automated-docs-hosting`: Continuous deployment of the Starlight portal to GitHub Pages.

## Impact
- **Security**: Ensures no secrets (Firebase keys, etc.) are accidentally committed.
- **Organization**: Provides a historical log of all OpenSpec changes and feature implementations.
