## Why
The project lacks a centralized, searchable knowledge base. Current documentation is fragmented across many ephemeral `openspec/changes` folders. To support scaling and long-term maintenance, we need a "Documentation Center" that synthesizes requirements and designs into a single source of truth.

## What Changes
- [NEW] Initialize a `docs/` repository using **Starlight (Astro)**.
- [NEW] Set up core documentation categories: Features, Architecture, Operations, and Guides.
- [NEW] Create a `scripts/` directory with a `sync-specs.sh` utility to aggregate archived OpenSpec data.

## Capabilities

### New Capabilities
- `documentation-portal`: A static site that renders the Markdown docs with built-in search and navigation.

## Impact
- **Workspace**: Adds a `docs/` subdirectory and a `scripts/` subdirectory.
- **Workflow**: Archiving changes will now include a mandatory step to update the `docs/` portal.
