## Why

The core functionality of Check-2-Check involves mapping financial planning around future paychecks. A calendar-based UI is essential for users to visualize their income and expenses over time, providing a clear intuitive interface for budgeting.

## What Changes

- Add `table_calendar` dependency.
- Create a new `CalendarScreen` in `lib/screens/calendar_screen.dart`.
- Update `lib/main.dart` to navigate to the `CalendarScreen`.
- Implement a basic interactive calendar view allowing users to select dates.

## Capabilities

### New Capabilities
- `calendar-view`: An interactive calendar interface for displaying dates and eventually financial events.

### Modified Capabilities
- (None)

## Impact

- Introduces a new dependency on `table_calendar`.
- Modifies the application's root screen to show the calendar.
