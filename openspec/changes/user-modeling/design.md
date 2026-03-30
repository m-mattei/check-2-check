## Context

The user wants a data model for households, users, and roles to enable shared budgeting features. We need to define the core Dart classes and enums.

## Goals / Non-Goals

**Goals:**
- Define `User`, `Person`, `Household`, and `HouseholdMember` data classes.
- Define a `HouseholdRole` enum.
- Ensure data models support the defined spec requirements.

**Non-Goals:**
- Implement any UI or logic for creating/deleting users or households.
- Set up a database or cloud integration.

## Decisions

- **Immutability**: Use `final` fields in the data classes to ensure immutability and predictable state management.
- **Roles**: Use centered enum `HouseholdRole` { admin, member, viewer }.
- **Person vs User**: A `Person` is the core entity that belongs to a household. A `User` represents a registered account. A `Person` may optionally link to a `User`.

## Risks / Trade-offs

- **Risk**: A user can belong to multiple households, which increases data complexity.
  - **Mitigation**: The current design handles this by using a `HouseholdMember` relation.
