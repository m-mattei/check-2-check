## Context

The user wants a calendar-based UI to facilitate paycheck-based budgeting. We've just scaffolded the project and now need to implement the first core visual element.

## Goals / Non-Goals

**Goals:**
- Provide a responsive monthly calendar.
- Support date selection.
- Integrate with the existing Flutter Material 3 theme.

**Non-Goals:**
- Implement the "Apple Pencil focused mode" yet.
- Link the calendar to any backend or data models in this stage.

## Decisions

- **Dependency**: Use `table_calendar: ^3.1.2` for the calendar widget.
- **Architecture**: `CalendarScreen` will be a `StatefulWidget` in `lib/screens/calendar_screen.dart` to manage the selected date state.

## Risks / Trade-offs

- **Risk**: Choosing a calendar library too early might limit customization for the "notebook/planner" look later.
  - **Mitigation**: `table_calendar` provides extensive builders for every day cell, allowing us to swap the look entirely without changing the underlying logic.
