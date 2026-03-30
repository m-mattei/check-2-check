## ADDED Requirements

### Requirement: User Entity
The system SHALL support a User entity to identify individual participants.

#### Scenario: Creating a User
- **WHEN** a new user is created
- **THEN** it must include a unique ID, a name, and an email address

### Requirement: Household Entity
The system SHALL support a Household entity to group users for shared budgeting.

#### Scenario: Creating a Household
- **WHEN** a new household is created
- **THEN** it must include a unique ID and a descriptive name

### Requirement: Household Roles
The system SHALL support different roles for users within a household.

#### Scenario: Assigning roles
- **WHEN** a user is added to a household
- **THEN** they must be assigned a role of Admin, Member, or Viewer
- **AND** an Admin SHALL have full permissions, a Member SHALL have add/edit permissions, and a Viewer SHALL have read-only permissions
