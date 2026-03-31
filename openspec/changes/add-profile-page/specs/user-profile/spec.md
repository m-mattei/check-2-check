## ADDED Requirements

### Requirement: Profile Information Display
The system SHALL display the authenticated user's profile information, including their display name, email address, and profile picture.

#### Scenario: Displaying Google Profile
- **WHEN** a user signed in via Google visits the Profile screen
- **THEN** the system SHALL show their Google display name, email, and profile avatar

#### Scenario: Displaying Local Profile
- **WHEN** a user signed in locally visits the Profile screen
- **THEN** the system SHALL show their local username and a default avatar

### Requirement: Account Sign Out
The system SHALL provide a mechanism for users to sign out from their current session.

#### Scenario: Successful Sign Out
- **WHEN** the user taps the "Sign Out" button
- **THEN** the system SHALL terminate the session and redirect the user to the Login screen

### Requirement: Account Deletion Placeholder
The system SHALL display a placeholder or option for account deletion to comply with application store requirements.

#### Scenario: Requesting Account Deletion
- **WHEN** the user taps the "Delete Account" option
- **THEN** the system SHALL display a confirmation dialog or a message stating the feature is "Coming Soon"
