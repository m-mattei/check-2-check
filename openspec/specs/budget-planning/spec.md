# budget-planning Specification

## Purpose
Defines the Plan screen capabilities for paycheck-based budget planning with person mapping and custom categories.

## Requirements

### Requirement: Paycheck-Based Planning View
The system SHALL display upcoming paychecks as planning anchors, showing the date, expected amount, and any expenses assigned to each paycheck.

#### Scenario: Viewing Upcoming Paychecks
- **WHEN** the user opens the Plan screen and selects the Paychecks view
- **THEN** the system SHALL display a list of upcoming paycheck cards with date, amount, and assigned expenses

### Requirement: Category-Based Planning View
The system SHALL display budget categories with planned amounts, allowing users to see how their money is allocated.

#### Scenario: Viewing Budget Categories
- **WHEN** the user opens the Plan screen and selects the Categories view
- **THEN** the system SHALL display a list of budget categories with names, planned amounts, and progress indicators

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

### Requirement: Person Mapping on Paychecks
The system SHALL allow assigning household members to paychecks and display them as visual tags.

#### Scenario: Viewing Paycheck Assignments
- **WHEN** a user views a paycheck card
- **THEN** the system SHALL display person tags showing who the paycheck is assigned to

### Requirement: Person Mapping on Expenses
The system SHALL allow assigning household members to individual expenses and display them as visual tags.

#### Scenario: Viewing Expense Assignments
- **WHEN** a user expands a paycheck to view its expenses
- **THEN** each expense SHALL display person tags showing who is responsible

### Requirement: Custom Categories
The system SHALL allow users to create, edit, and delete budget categories with custom name, icon, and planned amount.

#### Scenario: Adding a Custom Category
- **WHEN** the user taps "Add Category" and fills in name, icon, and planned amount
- **THEN** the system SHALL add the new category to the Categories view

#### Scenario: Editing a Custom Category
- **WHEN** the user taps edit on a custom category
- **THEN** the system SHALL open a dialog to modify name, icon, and planned amount

  #### Scenario: Deleting a Category
- **WHEN** the user swipes to delete a custom category
- **THEN** the system SHALL show a confirmation dialog and remove the category upon confirmation

### Requirement: Apple Pencil Planner Mode
The system SHALL provide a full-screen traditional planner layout on iOS/iPadOS for users who prefer handwriting their budget.

#### Scenario: Entering Planner Mode
- **WHEN** the user taps the planner mode toggle on an iOS device
- **THEN** the system SHALL switch to a full-screen paper planner layout with ruled lines

#### Scenario: Exiting Planner Mode
- **WHEN** the user taps the exit button
- **THEN** the system SHALL return to the digital Plan view

### Requirement: Platform Gating
The system SHALL only offer planner mode on iOS/iPadOS devices.

#### Scenario: Non-iOS Platform
- **WHEN** the user is on Android or Web
- **THEN** the planner mode toggle SHALL NOT be visible
