## Context

The Plan screen needs a mode for users who prefer writing their budget by hand with Apple Pencil on iPad. This mode replaces the digital card-based UI with a full-screen paper planner layout.

## Decisions

- **Platform Gate**: Only shown on iOS/iPadOS (checked via `Platform.isIOS`)
- **Toggle Location**: Button in the Plan screen header to switch between digital and planner mode
- **Planner Layout**: Full-screen with ruled lines, date headers, and a notebook aesthetic
- **Exit**: Prominent "Exit Planner Mode" button in the top-left corner
- **No Drawing Engine**: This phase provides the paper-like layout only. Actual handwriting capture comes later.

## Risks / Trade-offs

- **Risk: No actual pencil input yet** → This is the scaffold. Pencil integration is a future phase.
- **Risk: Full-screen hides navigation** → Intentional for immersion. Exit button always visible.
