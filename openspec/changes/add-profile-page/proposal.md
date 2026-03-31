## Why

The `check-2-check` application currently uses a placeholder for its Profile screen. To provide a complete user experience, we need a functional profile screen where users can view their identity, toggle basic app settings like Dark/Light mode, and sign out of their account.

## What Changes

- **Profile Screen Redesign**: Transition the current placeholder `ProfileScreen` into a functional Material 3 layout.
- **User Identity Section**: Integration with `AuthService` to display the user's name, email, and profile avatar (from Google or Firebase).
- **Persistent Theme Toggle**: Implement a theme selection setting that persists between app restarts using `SharedPreferences`.
- **Sign Out & Account Management**: Add a functional "Sign Out" button and a placeholder for "Delete Account" (for future compliance).
- **App Version Info**: Display the current app version from `pubspec.yaml` in the profile footer.

## Capabilities

### New Capabilities
- `user-profile`: Detailed view of the user's profile and basic personal settings (sign-out, account info).
- `app-configuration`: Persistence of global application settings, starting with the Light/Dark theme mode.

### Modified Capabilities
<!-- Existing capabilities whose REQUIREMENTS are changing (not just implementation).
     Only list here if spec-level behavior changes. Each needs a delta spec file.
     Use existing spec names from openspec/specs/. Leave empty if no requirement changes. -->

## Impact

- `lib/screens/profile_screen.dart`: Complete redesign of the UI.
- `lib/services/auth_service.dart`: Possible helper methods for profile data extraction.
- `lib/main.dart`: Global theme mode handling and integration with `SharedPreferences`.
- `pubspec.yaml`: Reference for app version identification.
