---
title: Settings & Theming
---

## Overview
The Settings screen provides user identity display, appearance customization, and account management. It replaces the original Profile screen placeholder.

## User Identity
- Displays avatar (Google photo or initials fallback)
- Shows display name and email (for Firebase users) or "Local User" label
- User type badge: "Firebase User" or "Local User"

## Appearance

### Theme Mode
- System default, Light, or Dark
- Persisted via `SharedPreferences`
- Applied globally via `ThemeService.themeMode` `ValueNotifier`

### Primary Color
- Seed color for `ColorScheme.fromSeed()`
- 10 presets available (blue, red, green, orange, purple, teal, pink, indigo, amber, cyan)
- Custom color picker with RGB sliders for arbitrary selection
- Persisted as ARGB32 integer in `SharedPreferences`

### Secondary Color
- Drives tab bar icons (selected and unselected states)
- Drives body text color (`bodyLarge`, `bodyMedium`, `bodySmall`)
- Same preset + custom picker as primary color
- Persisted as ARGB32 integer in `SharedPreferences`

## Account
- **Sign Out**: Confirmation dialog, then clears Firebase auth and local username, navigates back to `AuthWrapper`
- **Delete Account**: Placeholder dialog ("Coming Soon") for future compliance

## Architecture
- `ThemeService` in `main.dart` manages all theme state via `ValueNotifier`s
- `ListenableBuilder` in `Check2CheckApp` rebuilds `MaterialApp` on any theme change
- `SettingsScreen` listens to all three `ValueNotifier`s (themeMode, primaryColor, secondaryColor)
