## Why

The application currently has hardcoded colors for selected items, specifically in the `CalendarScreen`. To ensure visual consistency and a premium feel, we should leverage the Material 3 `ColorScheme` (specifically the `secondary` color) for all selected active states.

## What Changes

- **Calendar Refinement**: Update the `TableCalendar`'s `selectedDecoration` to use the theme's secondary color.
- **Theme Sync**: Ensure that the `ThemeData` defined in `main.dart` has a well-defined secondary color that works in both light and dark modes.
- **Global Selected Item Logic**: Establish a pattern for using the `secondary` color for selected states in any future components.

## Capabilities

### Modified Capabilities
- `app-configuration`: This capability already handles theme mode; it will now also specify color mapping for selected states.

## Impact

- `lib/screens/calendar_screen.dart`: Remove hardcoded blue and use the theme's secondary color.
- `lib/main.dart`: Refine the `ThemeData` to include a strong secondary color.
