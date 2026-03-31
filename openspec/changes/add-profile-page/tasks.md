## 1. Persistent Theme Infrastructure

- [x] 1.1 In `main.dart`, initialize `SharedPreferences` at the start of `main()`.
- [x] 1.2 Implement a `ValueNotifier<ThemeMode>` to hold the current theme state.
- [x] 1.3 Add logic to load and save the theme mode from `SharedPreferences`.
- [x] 1.4 Update the `MaterialApp` in `main.dart` to listen to the `ValueNotifier`.

## 2. AuthService Helpers

- [x] 2.1 Add an `isFirebaseUser` getter to `AuthService`.
- [x] 2.2 Add a helper to return a consistent profile data object (name, email, photoURL) regardless of the auth method.

## 3. Profile Screen UI Redesign

- [x] 3.1 Replace the existing placeholder in `lib/screens/settings_screen.dart` with a `Scaffold` containing a `ListView`.
- [x] 3.2 Implement the **User Header** section (Photo/Avatar, Name, Email).
- [x] 3.3 Implement the **Appearance** section with a theme toggle switch.
- [x] 3.4 Implement the **Account** section with a functional "Sign Out" button.
- [x] 3.5 Implement the "Delete Account" placeholder with a confirmation dialog.
- [x] 3.6 Display the app version (1.0.0+1) in a footer section.

## 4. Verification

- [x] 4.1 Verify theme persists after hot restart and full app restart.
- [x] 4.2 Verify Sign Out correctly returns the user to the Login screen.
- [x] 4.3 Verify profile data displays correctly for both Google and Local users.
