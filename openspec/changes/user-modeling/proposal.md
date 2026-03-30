## Why

To support common financial management scenarios (e.g., families, couples, roommates), the application needs to handle "Households". This allows multiple users to share a budget while maintaining individual identities and specific permission levels (Roles).

## What Changes

- Create `User` data model (registered system users).
- Create `Person` data model (representing individuals who may or may not be users).
- Create `Household` data model.
- Define `HouseholdRole` enum (e.g., Admin, Member, Viewer).
- Establish the relationship between People and Households through a `HouseholdMember` entity.

## Capabilities

### New Capabilities
- `user-and-household-modeling`: Data models for users, people, and shared households with roles.

### Modified Capabilities
- (None)

## Impact

- Adds new core domain models to `lib/models/`.
- Forms the foundation for future authentication and data sharing features.
