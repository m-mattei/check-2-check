---
title: Firestore Integration
---

## Overview

All budget data is now persisted to Firebase Firestore with real-time synchronization and household-scoped access control.

## Data Model

```
users/{userId}
  └── households/{householdId}
        ├── info          { name, createdAt }
        ├── people/      { id, name, color, createdAt }
        ├── categories/  { id, name, icon, planned, isCustom, createdAt }
        ├── paychecks/   { id, date, amount, assignedPeople[], createdAt }
        ├── expenses/    { id, name, amount, categoryId, account, assignedPeople[], date, createdAt }
        ├── goals/       { id, name, targetAmount, savedAmount, deadline, createdAt }
        └── notes/      { id, content, updatedAt }
```

## Firestore Service

Centralized singleton service (`lib/services/firestore_service.dart`) provides:

- `getOrCreateHousehold()` — auto-creates household on first login
- `streamCategories()`, `streamPeople()`, `streamPaychecks()`, `streamExpenses()` — real-time listeners
- `add`, `update`, `delete` methods for each collection type

## Security

Firestore security rules enforce household-scoped access:
- Users can only read/write data within their own household
- Storage rules follow the same pattern

## Offline Support

Firestore handles offline scenarios automatically:
- Changes made offline are queued and synced when connectivity is restored
- Loading states are shown during initial connection

## Feature Flags

No feature flags control Firestore integration — it is always active when the user is authenticated.
