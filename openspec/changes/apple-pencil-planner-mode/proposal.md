## Why

Users on iOS/iPadOS with Apple Pencil prefer a traditional paper planner experience for budget planning. The current digital UI doesn't support handwriting-friendly layouts. A dedicated planner mode provides a full-screen, paper-like interface optimized for pencil input.

## What Changes

- **Platform Detection**: Detect iOS/iPadOS to show the planner mode toggle
- **Planner View**: Full-screen traditional planner layout with ruled lines and date headers
- **Exit Mechanism**: Prominent exit button in the top corner to return to digital view
- **Feature Flag**: Gated behind `enableApplePencilPlanner` toggle

## Capabilities

### New Capabilities
- `apple-pencil-planner`: Full-screen traditional planner layout for iOS/iPadOS with Apple Pencil support

### Modified Capabilities
- `budget-planning`: Plan screen now offers a planner mode alternative on supported platforms

## Impact

- `lib/screens/plan_screen.dart`: Add conditional planner mode view and toggle
- `lib/utils/feature_flags.dart`: Add `enableApplePencilPlanner` flag
- `lib/screens/dev_mode_screen.dart`: Add toggle for the new flag
