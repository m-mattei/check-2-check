## 1. Settings Tab Rename

- [x] 1.1 Rename `ProfileScreen` class to `SettingsScreen` in `lib/screens/settings_screen.dart`
- [x] 1.2 Update `MainNavigationScreen` to import and use `SettingsScreen`
- [x] 1.3 Change tab label from "Profile" to "Settings"
- [x] 1.4 Change tab icon from `Icons.person` to `Icons.settings`

## 2. Custom Color Picker

- [x] 2.1 Add "Custom Color..." option to the color picker dialog
- [x] 2.2 Implement RGB sliders for custom color selection
- [x] 2.3 Persist custom colors via `ThemeService.setPrimaryColor` / `setSecondaryColor`
- [x] 2.4 Display color name ("Blue", "Red", etc.) or "Custom" for non-preset colors

## 3. Secondary Color Theming

- [x] 3.1 Apply secondary color to `bottomNavigationBarTheme.selectedItemColor`
- [x] 3.2 Apply secondary color to `bottomNavigationBarTheme.unselectedItemColor`
- [x] 3.3 Apply secondary color to `textTheme.bodyLarge`, `bodyMedium`, `bodySmall`

## 4. Calendar Today Indicator

- [x] 4.1 Change today decoration from `Colors.blueAccent` to semi-transparent gray

## 5. Verification

- [x] 5.1 Verify Settings tab renders correctly
- [x] 5.2 Verify custom color picker saves and applies colors
- [x] 5.3 Verify tab icons and text follow secondary color changes
- [x] 5.4 Verify today indicator appears semi-transparent gray
- [x] 5.5 Run `flutter analyze` with no issues
