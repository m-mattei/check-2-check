## Context

The current `CalendarScreen` implementation uses hardcoded `Colors.blue` and `Colors.blueAccent` for selected and today's dates. This bypasses the theme's color scheme and leads to visual inconsistency, especially when switching between light and dark modes.

## Goals / Non-Goals

**Goals:**
- Replace hardcoded colors in `CalendarScreen` with dynamic references to the theme's `ColorScheme`.
- Use the `secondary` color for selected items.
- Ensure the contrast is appropriate for both light and dark backgrounds.

**Non-Goals:**
- Changing the layout of the calendar.
- Adding new calendar features beyond styling.

## Decisions

- **Color Mapping**: 
  - `selectedDecoration` color → `Theme.of(context).colorScheme.secondary`.
  - `todayDecoration` color → `Theme.of(context).colorScheme.secondaryContainer` (or a lower opacity variant of secondary) to provide visual differentiation from the user's active selection.
- **Theme Data**: Ensure that `ThemeData` globally defines a consistent secondary color (likely a shade of blue or a contrasting color that fits the brand).

## Risks / Trade-offs

- **Risk: Poor Contrast** → Mitigation: Use `ColorScheme` properties like `onSecondary` for the text color of selected dates to ensure readability.
