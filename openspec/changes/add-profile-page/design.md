## Context

The current `ProfileScreen` is a basic placeholder containing only a "Construction Zone" message. The application lacks a centralized location for account status, identity verification (email/photo), and basic app settings (Light/Dark mode). The root navigation is already in place via `BottomNavigationBar`, but the third tab needs a full implementation.

## Goals / Non-Goals

**Goals:**
- Provide a clear, Material 3-compliant UX for the Profile section.
- Enable and persist theme selection (Light vs. Dark mode) using `SharedPreferences`.
- Display accurate User Identity from both Firebase and "Local Auth" sessions.
- Provide a functional Sign Out mechanism.

**Non-Goals:**
- Profile editing (changing name/email/photo).
- Advanced data management (exporting, clear data).
- Notifications or more complex configuration settings (beyond theme).

## Decisions

- **Global Theme State**: We will use a `ValueNotifier<ThemeMode>` in the `main.dart`'s entry point. This is a lightweight, built-in Flutter mechanism that avoids the overhead of a full state management library for just one global setting.
- **Persistence Layer**: `SharedPreferences` will be used as the source of truth for the theme setting. It will be loaded asynchronously during app initialization.
- **Adaptive UI**: The `ProfileScreen` will utilize `CircleAvatar` for user photos with a fallback icon/initials logic. `ListTile` widgets with Material 3 styling will handle the settings and actions.

## Risks / Trade-offs

- **Risk: Late Initialization of Preferences** → Mitigation: `SharedPreferences` is already initialized in `main.dart` and `AuthWrapper`. We will ensure the theme mode is loaded before the first build by awaiting the init in `main()`.
- **Risk: Broken Image URLs** → Mitigation: The `CircleAvatar` will use an `Image.network` within a child, or a `backgroundImage` with an `onBackgroundImageError` handler to fallback to initials.
