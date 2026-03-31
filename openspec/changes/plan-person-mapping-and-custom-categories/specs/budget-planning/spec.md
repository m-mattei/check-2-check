## ADDED Requirements

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

#### Scenario: Deleting a Category
- **WHEN** the user deletes a custom category
- **THEN** the system SHALL show a confirmation dialog and remove the category upon confirmation
