## 1. Feature Flags Setup

- [x] 1.1 Create `lib/utils/feature_flags.dart` with `enableUsernameOnlyLogin = true`
- [x] 1.2 Refactor `FeatureFlags` to be dynamic and read/write from `SharedPreferences`

## 2. Dependencies

- [x] 2.1 Add `shared_preferences` package to pubspec.yaml and get dependencies

## 3. Auth Service Updates

- [x] 3.1 Update `lib/services/auth_service.dart` to add `registerWithEmailAndPassword(String email, String password)`
- [x] 3.2 Update `lib/services/auth_service.dart` to add username storage using `SharedPreferences`

## 4. UI Adjustments

- [x] 4.1 Update `lib/screens/login_screen.dart` to display the Username input form or Email/Password registration form based on the feature flag
- [x] 4.2 Update `lib/main.dart` (`AuthWrapper`) to prioritize checking SharedPreferences for the local username bypass if the feature flag is enabled
- [x] 4.3 Create `lib/screens/dev_mode_screen.dart` to list and toggle feature flags
- [x] 4.4 Add a button on the initial startup screen (LoginScreen) to navigate to the Dev Mode screen
