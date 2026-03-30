## Design Overview
Initialize a static documentation portal in the `docs/` subdirectory using **Starlight (Astro)**. All project requirements and designs will move from `openspec/changes` to this central repository after archival.

## Goals

- [x] Searchable, Sidebar-organized documentation.
- [x] Built-in Mermaid support for architecture diagrams.
- [x] Automatic sync of archived specs.

## Decisions

- **Why Starlight**: It supports "Sidebar Groups" for categorization and comes with built-in full-text search. This addresses the "refactoring at scale" requirement.
- **Organization**: Top-level folders for `features/`, `architecture/`, and `guides/`.

## Risks / Trade-offs

- **Build Time**: Astro is extremely fast, so the dev server won't slow down the Flutter environment significantly.
- **Maintenance**: Requires an additional `npm install` inside the `docs/` folder, but keeps documentation organized.
