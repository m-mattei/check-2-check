---
title: Navigation Feature Spec
---

## Overview
The application uses a **MainNavigationScreen** to manage the top-level app state after the authentication phase (either via Firebase or bypass).

## Layout Structure
- **Body**: Uses an `IndexedStack` to wrap:
    - `CalendarScreen` (Index 0)
    - `PlanScreen` (Index 1)
    - `ProfileScreen` (Index 2)
- **Bar**: A `BottomNavigationBar` is used for mobile-first tab switching.

## Feature Flags
- **`enableMainNavigationTabs`**: Toggles between a multi-tab layout and a direct fallback to `CalendarScreen`.
