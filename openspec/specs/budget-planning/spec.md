# budget-planning Specification

## Purpose
Defines the Plan screen capabilities for paycheck-based budget planning with person mapping, custom categories, and Firestore data persistence.

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

### Requirement: Expense View
The system SHALL display a dedicated expenses view showing all expenses with person assignments.

#### Scenario: Viewing Expenses
- **WHEN** the user opens the Plan screen and selects the Expenses view
- **THEN** the system SHALL display a list of expense cards with name, amount, date, and assigned people

### Requirement: View Toggle
The system SHALL provide a segmented button to switch between Paychecks, Expenses, and Categories planning views.

#### Scenario: Switching Views
- **WHEN** the user taps a segment in the view toggle
- **THEN** the system SHALL switch between the selected view

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
- **WHEN** a user views an expense card
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

### Requirement: Firestore Data Persistence
The system SHALL store all budget data (categories, paychecks, expenses) in Firestore with real-time synchronization.

#### Scenario: Data Loading
- **WHEN** the user opens the Plan screen
- **THEN** the system SHALL initialize Firestore connection and display a loading indicator

#### Scenario: Real-time Updates
- **WHEN** budget data changes in Firestore
- **THEN** the system SHALL automatically update the UI via Firestore stream listeners

#### Scenario: Offline Support
- **WHEN** the device loses connectivity
- **THEN** the system SHALL handle gracefully and sync when connectivity is restored

### Requirement: Recurring Transactions
The system SHALL support creating paychecks and expenses with recurring patterns.

#### Scenario: Creating Recurring Paycheck
- **WHEN** the user creates a paycheck with "Recurring" enabled
- **AND** selects a frequency pattern (weekly, biweekly, monthly, quarterly, annually)
- **AND** specifies the day of week or day of month
- **THEN** the paycheck SHALL be marked as recurring with the specified pattern

#### Scenario: Creating Recurring Expense
- **WHEN** the user creates an expense with "Recurring" enabled
- **AND** selects a frequency pattern
- **AND** specifies the day of week or day of month
- **THEN** the expense SHALL be marked as recurring with the specified pattern

#### Scenario: Viewing Recurring Transactions
- **WHEN** the user views paychecks or expenses with recurring enabled
- **THEN** the transaction SHALL display a "Recurring" badge with repeat icon

#### Scenario: Recurring Option Visibility
- **WHEN** the `enableRecurringTransactions` feature flag is disabled
- **THEN** the recurring options SHALL NOT be visible in add/edit dialogs

### Requirement: Recurrence Pattern Selection
The system SHALL provide appropriate day selectors based on the selected frequency.

#### Scenario: Weekly/Biweekly Frequency
- **WHEN** the user selects "Weekly" or "Biweekly" recurrence
- **THEN** the system SHALL display a day-of-week selector (Mon-Sun)

#### Scenario: Monthly/Quarterly/Annual Frequency
- **WHEN** the user selects "Monthly", "Quarterly", or "Annual" recurrence
- **THEN** the system SHALL display a day-of-month selector (1-31)

#### Scenario: Optional End Date
- **WHEN** the user enables recurring transactions
- **THEN** the system SHALL optionally allow specifying an end date
