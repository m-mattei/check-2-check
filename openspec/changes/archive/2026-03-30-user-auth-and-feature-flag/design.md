## Context

The current `Check-2-Check` app only supports Google Sign-In, which is currently malfunctioning locally due to missing Firebase API keys. We need to implement typical Email/Password user creation, but we also want to add a feature flag system to build a bypass that allows developers or users to instantly login with a simple "Username", bypassing all real auth.

## Goals / Non-Goals

**Goals:**
- Implement a `FeatureFlags` utility class to toggle features globally.
- Update `LoginScreen` to dynamically render either a robust auth form (Google + Email/Password) or a dummy username-only form based on the feature flag.
- Update `AuthService` and `AuthWrapper` to fallback on `SharedPreferences` for a local user session when the bypass flag is fully enabled.

**Non-Goals:**
- Do not build a backend profile synchronization for the "username-only" mode. It is purely local.

## Decisions

- **Store local session in SharedPreferences**: We chose SharedPreferences over attempting Firebase Anonymous Sign-in because Firebase is completely broken without real API keys, so `signInAnonymously()` would fail. SharedPreferences is completely offline and resilient to network/auth outages.
- **Dynamic Feature Flags System**: Instead of static constants, `FeatureFlags` will be an initialized class that loads toggles from `SharedPreferences` so they can be securely toggled at runtime.
- **Dev Mode Screen**: A new screen `lib/screens/dev_mode_screen.dart` will be introduced to allow toggling these flags. A hidden or dev mode button will be rendered on startup (e.g., above the Login form or in an AppBar) to access it.

## Risks / Trade-offs

- **Risk**: Local session state diverges from Firebase Auth state.
  - *Mitigation*: The `AuthWrapper` will prioritize the local SharedPreferences username check if the feature flag is `true`. If `false`, it clears the local username and strictly uses Firebase.
- **Risk**: `shared_preferences` requires a `flutter pub get`.
  - *Mitigation*: Add it to `pubspec.yaml` and document it in the build tasks.
