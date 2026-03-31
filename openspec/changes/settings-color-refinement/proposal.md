## Why

The Profile tab was renamed to Settings to better reflect its expanded role (appearance, colors, account). The color picker needed a "Custom Color" option for full user control. The secondary color should drive tab icons and body text to create a cohesive two-tone theme system.

## What Changes

- **Tab Rename**: `ProfileScreen` → `SettingsScreen`, tab label "Profile" → "Settings", icon `Icons.person` → `Icons.settings`
- **Custom Color Picker**: Added RGB sliders for arbitrary color selection alongside the 10 presets
- **Secondary Color Theming**: Tab bar icons and body text now use the configurable secondary color
- **Today Indicator**: Calendar today marker changed from blue accent to semi-transparent gray

## Capabilities

### New Capabilities
- `custom-color-selection`: Users can pick any RGB color via sliders, not just presets
- `secondary-color-theming`: Tab icons and body text follow the secondary color setting

### Modified Capabilities
- `app-configuration`: Settings screen replaces Profile screen; color picker expanded with custom option

## Impact

- `lib/screens/settings_screen.dart`: New file (renamed from profile_screen.dart), class renamed, custom color picker added
- `lib/screens/main_navigation_screen.dart`: Tab renamed to Settings, icon changed
- `lib/main.dart`: Secondary color applied to textTheme and bottomNavigationBarTheme
- `lib/screens/calendar_screen.dart`: Today indicator styled with semi-transparent gray
