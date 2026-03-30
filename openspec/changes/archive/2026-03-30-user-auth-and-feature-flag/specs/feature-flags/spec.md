## ADDED Requirements

### Requirement: Global Feature Flags
The system SHALL provide a centralized mechanism to toggle active features in the application before build time.

#### Scenario: Reading a feature flag
- **WHEN** the application requires a decision logic based on feature availability
- **THEN** it reads a static boolean from `FeatureFlags` to determine behavior
