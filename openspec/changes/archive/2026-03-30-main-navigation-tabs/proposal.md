## Why
Currently, the Check-2-Check application logs the user directly into a full-screen `CalendarScreen`. As the application grows to encompass different planning phases and user profiling, we need a root-level navigation infrastructure that allows the user to intuitively switch between isolated workspaces (like Calendar, Planning, and Profile interfaces).

## What Changes
- Build a generic `MainNavigationScreen` to act as the root Scaffold inside the `AuthWrapper`.
- Implement a `BottomNavigationBar` on mobile to switch between three separate feature routes.
- Introduce two new scaffolding screens: `PlanScreen` and `ProfileScreen`.
- Wrap the entire new navigation layout in a feature flag per the global developer rule (`enableMainNavigationTabs`).

## Capabilities

### New Capabilities
- `navigation`: Root-level routing for the entire authenticated app session. Introduces multi-tab tracking and seamless screen swapping without losing state.

### Modified Capabilities
None.

## Impact
- **UI Architecture**: `CalendarScreen` will no longer be the absolute root of the authenticated area; it will be pushed down one level into an `IndexedStack` managed by the new navigation screen.
- **State**: We'll introduce a simple state tracking index `_currentIndex` for the active tab.
