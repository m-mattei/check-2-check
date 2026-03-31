---
title: Navigation Feature Spec
---

## Overview
The application uses a **MainNavigationScreen** to manage the top-level app state after the authentication phase (either via Firebase or bypass).

## Layout Structure
- **Body**: Uses an `IndexedStack` to wrap:
    - `CalendarScreen` (Index 0)
    - `PlanScreen` (Index 1)
    - `SettingsScreen` (Index 2)
- **Bar**: A `BottomNavigationBar` is used for mobile-first tab switching. Tab icons and labels follow the configurable secondary color.

## Feature Flags
- **`enableMainNavigationTabs`**: Toggles between a multi-tab layout and a direct fallback to `CalendarScreen`.

## Tabs
| Tab | Icon | Description |
|-----|------|-------------|
| Calendar | `Icons.calendar_month` | Budget calendar view |
| Plan | `Icons.list_alt` | Planning view (construction) |
| Settings | `Icons.settings` | Appearance, colors, account management |
