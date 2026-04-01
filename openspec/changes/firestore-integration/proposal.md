## Why

The app currently uses mock data for paychecks, categories, and expenses. To provide a real, persistent budgeting experience, all data must be stored in Firestore with proper authentication and security rules.

## What Changes

- **Firestore Database**: All budget data (categories, paychecks, expenses, goals, notes) stored in Firestore
- **Firestore Service**: Centralized service for CRUD operations with real-time listeners
- **Data Models**: Updated to Firestore-compatible structure with timestamps and IDs
- **Auth Integration**: All Firestore operations scoped to authenticated user's household
- **Security Rules**: Household-scoped access control

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

## Implementation Order

1. Categories (proof of concept)
2. People
3. Paychecks
4. Expenses
5. Goals
6. Notes

## Capabilities

### New Capabilities
- `data-persistence`: All budget data persisted to Firestore with real-time sync

### Modified Capabilities
- `budget-planning`: Mock data replaced with real Firestore reads

## Impact

- `pubspec.yaml`: Add `cloud_firestore` dependency
- `lib/firebase_options.dart`: Ensure Firestore configured
- `lib/services/firestore_service.dart`: New centralized Firestore service
- `lib/models/`: Updated with Firestore-compatible fields
- `firestore.rules`: Security rules for household-scoped access
