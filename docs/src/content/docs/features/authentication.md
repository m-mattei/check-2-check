# Authentication Feature Spec

## Overview
Check-2-Check uses a hybrid authentication model. For development and testing, a local bypass is available. For production, **Firebase Google Sign-In** is the standard.

## Primary Flow: Firebase Google Sign-In
1.  User enters `LoginScreen`.
2.  User triggers `signInWithGoogle`.
3.  Successful authentication persists a session via `FirebaseAuth`.

## Development Flow: Username-Only Bypass
When the `enableUsernameOnlyLogin` feature flag is set to **true**:
1.  User enters a simple username.
2.  `AuthService` saves this in `SharedPreferences` locally.
3.  The application environment skips all Firebase validation.

## Feature Flags
- **`enableUsernameOnlyLogin`**: Toggles between real Firebase Auth and the local bypass.
