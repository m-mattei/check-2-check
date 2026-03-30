## Why
The current authentication flow strictly uses Google Sign-In, which is currently blocked by placeholder API keys. We need a way for users to create traditional accounts (Email/Password), and we also need a fast pathway to completely bypass authentication using just a username during development or for anonymous users.

## What Changes
- Introduce a feature flag system to manage app features.
- Build an Email/Password user creation form.
- Implement a username-only login bypass when the `enableUsernameOnlyLogin` feature flag is enabled.

## Capabilities

### New Capabilities
- `user-auth`: Expanding authentication beyond OAuth to include traditional Email/Password and SharedPreferences-based username-only flows.
- `feature-flags`: Implementing a system to toggle features globally across the app, specifically to disable full sign-in.

### Modified Capabilities
None.

## Impact
- **UI**: The LoginScreen will be completely redesigned based on state.
- **State**: The `AuthWrapper` in `main.dart` will adapt to use a local username check.
- **Dependencies**: `shared_preferences` package will be introduced for the username bypass.
