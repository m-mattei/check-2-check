# feature-flags Specification

## Purpose
Defines the centralized feature flag system for toggling features without code changes.

## Requirements

### Requirement: Global Feature Flags
The system SHALL provide a centralized mechanism to toggle active features in the application before build time.

#### Scenario: Reading a feature flag
- **WHEN** the application requires a decision logic based on feature availability
- **THEN** it reads a static boolean from `FeatureFlags` to determine behavior

### Requirement: Available Feature Flags
The system SHALL support the following feature flags, configurable via Dev Mode:

- `enableUsernameOnlyLogin`: Bypasses Firebase auth for local username-only login
- `enableMainNavigationTabs`: Enables the bottom navigation bar with multiple tabs
- `enablePlanPage`: Enables the Plan screen with paycheck-based budget planning
- `enableApplePencilPlanner`: Enables the Apple Pencil planner mode on iOS/iPadOS
- `enableCalendarExpenses`: Enables expense display on the calendar alongside paychecks

#### Scenario: Toggling a Feature Flag
- **WHEN** a developer toggles a feature flag in Dev Mode
- **THEN** the system SHALL persist the change to `SharedPreferences` and apply it immediately

