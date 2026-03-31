# app-configuration Specification

## Purpose
Defines persistent application configuration including theme mode and color customization.

## Requirements

### Requirement: Persistent Theme Selection
The system SHALL allow users to select between Light, Dark, and System theme modes, and persist this choice across app sessions.

#### Scenario: Persistent Theme Choice
- **WHEN** the user toggles the theme mode setting from Light to Dark
- **THEN** the system SHALL update the application theme immediately and save the choice to local storage

#### Scenario: Restoring Theme Selection
- **WHEN** the application starts
- **THEN** it SHALL load the previously stored theme choice and apply it to the user interface

### Requirement: Primary Color Customization
The system SHALL allow users to select a primary color from a set of presets or define a custom color using RGB sliders.

#### Scenario: Selecting a Preset Color
- **WHEN** the user taps a preset color swatch
- **THEN** the system SHALL update the primary color and regenerate the `ColorScheme.fromSeed()`

#### Scenario: Selecting a Custom Color
- **WHEN** the user taps "Custom Color..." and adjusts RGB sliders
- **THEN** the system SHALL apply the selected color and persist it as an ARGB32 integer

### Requirement: Secondary Color Customization
The system SHALL allow users to select a secondary color that drives tab bar icons and body text.

#### Scenario: Secondary Color Applied to Navigation
- **WHEN** the user changes the secondary color
- **THEN** the bottom navigation bar icons and labels SHALL update to reflect the new color

#### Scenario: Secondary Color Applied to Text
- **WHEN** the user changes the secondary color
- **THEN** body text (`bodyLarge`, `bodyMedium`, `bodySmall`) SHALL update to reflect the new color

### Requirement: Color Persistence
The system SHALL persist primary and secondary color selections across app restarts.

#### Scenario: Restoring Colors on Launch
- **WHEN** the application starts
- **THEN** it SHALL load the stored primary and secondary colors from `SharedPreferences` and apply them
