# user-auth Specification

## Purpose
TBD - created by archiving change user-auth-and-feature-flag. Update Purpose after archive.
## Requirements
### Requirement: Email and Password Registration
The system SHALL allow users to create an account using an email address and a password.

#### Scenario: User registers via Email
- **WHEN** the user submits their email and password on the login screen
- **THEN** the system creates a new Firebase Auth user account

### Requirement: Username-only Bypassed Login
The system SHALL allow users to bypass Firebase authentication completely by providing just a username, IF the `enableUsernameOnlyLogin` feature flag is enabled.

#### Scenario: Bypassing authentication
- **WHEN** the feature flag is true and the user enters a username
- **THEN** the system saves the username to `SharedPreferences` and routes to the main app screen

