## ADDED Requirements

### Requirement: Custom Color Selection
The system SHALL allow users to select any custom color using RGB sliders in addition to preset color options.

#### Scenario: Selecting a Custom Color
- **WHEN** the user taps "Custom Color..." in the color picker
- **THEN** the system SHALL display RGB sliders and an "Apply" button to set an arbitrary color

#### Scenario: Persisting Custom Colors
- **WHEN** a custom color is applied
- **THEN** the system SHALL save the ARGB32 value to `SharedPreferences` and restore it on next launch

### Requirement: Secondary Color Theming
The system SHALL apply the configured secondary color to tab bar icons and body text throughout the application.

#### Scenario: Tab Bar Icons
- **WHEN** the user changes the secondary color
- **THEN** the bottom navigation bar icons and labels SHALL update to reflect the new secondary color

#### Scenario: Body Text
- **WHEN** the user changes the secondary color
- **THEN** body text throughout the application SHALL update to reflect the new secondary color
