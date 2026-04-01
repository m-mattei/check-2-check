## MODIFIED Requirements

### Requirement: Calendar Expense Display
The Calendar screen SHALL display expenses alongside paychecks to provide a complete financial view.

#### Scenario: Viewing Combined Calendar Events
- **WHEN** the user opens the Calendar screen
- **THEN** the system SHALL display both paychecks and expenses on their respective dates

#### Scenario: Visual Differentiation
- **WHEN** the calendar renders day markers
- **THEN** paychecks SHALL be shown with green circle markers and expenses with red circle markers

#### Scenario: Day Detail Panel
- **WHEN** the user selects a day on the calendar
- **THEN** the system SHALL display both paychecks and expenses for that day, each with their assigned people shown as chips

### Requirement: Expense Person Mapping on Calendar
The system SHALL display assigned people for expenses in the calendar day detail view.

#### Scenario: Viewing Expense Assignments
- **WHEN** a user views the day detail panel
- **THEN** each expense SHALL display person tags showing who is responsible

### Requirement: Feature Flag Control
The system SHALL only display expenses on the calendar when the `enableCalendarExpenses` feature flag is enabled.

#### Scenario: Feature Disabled
- **WHEN** the `enableCalendarExpenses` flag is set to false
- **THEN** the calendar SHALL display only paychecks
