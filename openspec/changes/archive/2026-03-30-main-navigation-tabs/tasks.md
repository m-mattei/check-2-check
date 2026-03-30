## 1. Feature Flag Configuration

- [x] 1.1 Update `lib/utils/feature_flags.dart` with a new `enableMainNavigationTabs` boolean (default true) and save logic.
- [x] 1.2 Update `lib/screens/dev_mode_screen.dart` to add a new `SwitchListTile` to toggle this feature flag.

## 2. Generate New Scaffolding Screens

- [x] 2.1 Create `lib/screens/plan_screen.dart` with a placeholder stub for future planning UI.
- [x] 2.2 Create `lib/screens/profile_screen.dart` with a placeholder stub for future settings/profile details.

## 3. Implement Root Navigation Container

- [x] 3.1 Create `lib/screens/main_navigation_screen.dart` mapping `BottomNavigationBar` clicks to update an `_currentIndex` state.
- [x] 3.2 Build the body of `MainNavigationScreen` to wrap `CalendarScreen`, `PlanScreen`, and `ProfileScreen` inside an `IndexedStack`.

## 4. Hook Up Routing

- [x] 4.1 Update `lib/main.dart`'s `AuthWrapper` line 56: If `enableMainNavigationTabs` is true, route successfully authenticated users to the new `MainNavigationScreen` rather than strictly to `CalendarScreen`.
