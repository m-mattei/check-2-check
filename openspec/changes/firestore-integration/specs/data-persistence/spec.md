## ADDED Requirements

### Requirement: Data Persistence
The system SHALL store all budget data (categories, paychecks, expenses, goals, notes) in Firestore.

#### Scenario: Saving a Category
- **WHEN** a user creates or edits a category
- **THEN** the system SHALL persist it to Firestore under the user's household

#### Scenario: Real-time Updates
- **WHEN** data changes in Firestore
- **THEN** the system SHALL update the UI automatically via Firestore listeners

### Requirement: Household-Scoped Access
The system SHALL ensure users can only access their own household's data.

#### Scenario: Unauthorized Access
- **WHEN** a user attempts to read or write another user's household data
- **THEN** Firestore security rules SHALL deny the request

### Requirement: Offline Support
The system SHALL handle offline scenarios gracefully.

#### Scenario: Offline Editing
- **WHEN** the device is offline and a user makes changes
- **THEN** Firestore SHALL sync automatically when connectivity is restored
