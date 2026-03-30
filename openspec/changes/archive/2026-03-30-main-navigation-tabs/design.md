## Context
We need to give users the ability to jump between at least 3 distinct views (Calendar, Plan, and Settings/Profile) directly after logging in.

## Goals / Non-Goals

**Goals:**
- Provide a responsive `BottomNavigationBar` indicating the current active route.
- Implement an `IndexedStack` so that users do not lose their current scroll/view position on the Calendar when they briefly switch to Settings and swap back.
- Create placeholder skeleton screens for `PlanScreen` and `ProfileScreen` so they can be fleshed out progressively.
- Obey the `enableMainNavigationTabs` feature flag constraint.

**Non-Goals:**
- We are not fully building out the logic for the `PlanScreen` or `ProfileScreen` right now, just establishing the structural navigation points.

## Decisions

- **Why IndexedStack vs PageView**: `IndexedStack` renders all children but only displays one, perfectly preserving the state of the Calendar while swapping tabs. A `PageView` inherently focuses on swiping, which can feel clunky for root app navigation and often redraws widgets unless explicitly kept alive.
- **Why BottomNavigationBar**: It is standard Material 3 design and the easiest recognizable native app navigation.

## Risks / Trade-offs
- **Trade-off**: The `IndexedStack` builds all its children sequentially. If `CalendarScreen`, `PlanScreen`, and `ProfileScreen` all aggressively fetch databases `initState()`, this could cause a heavy startup.
  *Mitigation*: We will ensure heavy loads inside those screens are deferred or lazily fired only when that screen is visible for the first time if this becomes a performance hit.
