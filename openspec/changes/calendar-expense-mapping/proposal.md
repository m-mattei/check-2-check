## Why

The Calendar screen only displays paychecks. Users need to see expenses on the calendar alongside paychecks to get a complete view of their financial schedule. Additionally, both paychecks and expenses already support `assignedPeopleIds` for person mapping, but this information is only shown for paychecks in the calendar day detail.

## What Changes

- **Expense Stream**: CalendarScreen subscribes to `streamExpenses()` in addition to `streamPaychecks()`
- **Combined Events**: Calendar events map includes both paychecks and expenses, keyed by date
- **Visual Differentiation**: Calendar day markers use different colors/shapes for paychecks (green circle) vs expenses (red circle)
- **Day Detail Panel**: Shows both paychecks and expenses for a selected day, each with their assigned people displayed as chips
- **Feature Flag**: `enableCalendarExpenses` toggle in Dev Mode to enable/disable expense display on calendar

## Capabilities

### Modified Capabilities
- `calendar-view`: Calendar now displays both paychecks and expenses with person assignments

## Impact

- `lib/utils/feature_flags.dart`: Add `enableCalendarExpenses` flag
- `lib/screens/calendar_screen.dart`: Add expense streaming, combined events, differentiated markers, updated day detail
- `lib/screens/dev_mode_screen.dart`: Add toggle for `enableCalendarExpenses`
