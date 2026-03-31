## ADDED Requirements

### Requirement: Apple Pencil Planner Mode
The system SHALL provide a full-screen traditional planner layout on iOS/iPadOS for users who prefer handwriting their budget.

#### Scenario: Entering Planner Mode
- **WHEN** the user taps the planner mode toggle on an iOS device
- **THEN** the system SHALL switch to a full-screen paper planner layout

#### Scenario: Exiting Planner Mode
- **WHEN** the user taps the exit button
- **THEN** the system SHALL return to the digital Plan view

### Requirement: Platform Gating
The system SHALL only offer planner mode on iOS/iPadOS devices.

#### Scenario: Non-iOS Platform
- **WHEN** the user is on Android or Web
- **THEN** the planner mode toggle SHALL NOT be visible
