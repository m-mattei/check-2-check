# user-profile Specification

## Purpose
Defines the Settings screen (formerly Profile) for user identity display, account management, and basic app configuration.

## Requirements

### Requirement: User Identity Display
The system SHALL display the authenticated user's profile information, including their display name, email address, and profile picture.

#### Scenario: Displaying Google Profile
- **WHEN** a user signed in via Google visits the Settings screen
- **THEN** the system SHALL show their Google display name, email, and profile avatar

#### Scenario: Displaying Local Profile
- **WHEN** a user signed in locally visits the Settings screen
- **THEN** the system SHALL show their local username and a default avatar with initials fallback

### Requirement: Account Sign Out
The system SHALL provide a mechanism for users to sign out from their current session.

#### Scenario: Successful Sign Out
- **WHEN** the user taps the "Sign Out" button
- **THEN** the system SHALL show a confirmation dialog, terminate the session (Firebase and local), and redirect the user to the Login screen

### Requirement: Account Deletion Placeholder
The system SHALL display a placeholder or option for account deletion to comply with application store requirements.

#### Scenario: Requesting Account Deletion
- **WHEN** the user taps the "Delete Account" option
- **THEN** the system SHALL display a message stating the feature is "Coming Soon"

### Requirement: App Version Display
The system SHALL display the current app version in the Settings screen footer.

#### Scenario: Viewing App Version
- **WHEN** the user scrolls to the bottom of the Settings screen
- **THEN** the system SHALL display the version string from `pubspec.yaml`
