## ADDED Requirements

### Requirement: Paycheck-Based Planning View
The system SHALL display upcoming paychecks as planning anchors, showing the date, expected amount, and any expenses assigned to each paycheck.

#### Scenario: Viewing Upcoming Paychecks
- **WHEN** the user opens the Plan screen and selects the Paychecks view
- **THEN** the system SHALL display a list of upcoming paycheck cards with date, amount, and assigned expenses

### Requirement: Category-Based Planning View
The system SHALL display budget categories with planned amounts, allowing users to see how their money is allocated.

#### Scenario: Viewing Budget Categories
- **WHEN** the user opens the Plan screen and selects the Categories view
- **THEN** the system SHALL display a list of budget categories with names and planned amounts

### Requirement: View Toggle
The system SHALL provide a mechanism to switch between Paycheck and Category planning views.

#### Scenario: Switching Views
- **WHEN** the user taps the view toggle
- **THEN** the system SHALL switch between the Paycheck and Category views

### Requirement: Feature Flag Control
The system SHALL only display the Plan screen content when the `enablePlanPage` feature flag is enabled.

#### Scenario: Feature Disabled
- **WHEN** the `enablePlanPage` flag is set to false
- **THEN** the system SHALL display a placeholder or fallback message
