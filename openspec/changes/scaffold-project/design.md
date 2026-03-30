## Context

The Check-2-Check application is currently a blank slate. As per `AGENTS.md`, the goal is to build a modern, cross-platform app (iOS, Android, Web) using Flutter, backed by Java/AWS/DynamoDB. We need to scaffold the core structural foundation of the Flutter app to prepare for UI and feature development.

## Goals / Non-Goals

**Goals:**
- Initialize a standard Flutter project.
- Establish the directory architecture (`lib/models`, `lib/services`, `lib/screens`, `lib/widgets`, `lib/utils`).
- Provide a clean entry point (`main.dart`).

**Non-Goals:**
- Implement any active screens, UI, or features.
- Connect to AWS or a Java backend.
- Finalize state management integration.

## Decisions

- **Framework**: Flutter (as specified in `AGENTS.md`).
- **Platform Support**: iOS, Android, Web.
- **Directory Structure**: Layer-based structure (`models`, `services`, `screens`, `widgets`, `utils`) based on the provided spec.

## Risks / Trade-offs

- **Risk**: Layer-based structure might become bloated as features increase.
  - **Mitigation**: We can transition to a feature-based modular structure later if the application complexity demands it.
