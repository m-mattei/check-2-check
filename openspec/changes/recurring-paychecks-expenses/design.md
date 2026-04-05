# Design: Recurring Paychecks and Expenses

## Data Model Changes

### Paycheck Model
Add recurring fields:
- `isRecurring`: boolean
- `recurrencePattern`: enum (daily, weekly, biweekly, monthly, quarterly, annually)
- `recurrenceDayOfWeek`: int (1-7, for weekly patterns)
- `recurrenceDayOfMonth`: int (1-31, for monthly/quarterly/annual patterns)
- `recurrenceEndDate`: DateTime (optional, null for infinite)

### Expense Model
Add same recurring fields as Paycheck.

## API Changes

### New Endpoints
- `POST /api/households/{householdId}/paychecks/{id}/generate-instances` - Generate upcoming instances
- `POST /api/households/{householdId}/expenses/{id}/generate-instances` - Generate upcoming instances

### Modified Endpoints
- `POST /api/households/{householdId}/paychecks` - Accept recurring fields
- `PUT /api/households/{householdId}/paychecks/{id}` - Accept recurring fields
- `POST /api/households/{householdId}/paychecks/{paycheckId}/expenses` - Accept recurring fields
- `PUT /api/households/{householdId}/paychecks/{paycheckId}/expenses/{id}` - Accept recurring fields

## UI Changes

### Plan Screen
- Add toggle for "Recurring" in add/edit paycheck and expense dialogs
- Show recurrence pattern selector when enabled
- Display recurrence indicator on recurring transaction cards

### Calendar Screen
- Generate and display future instances of recurring transactions
- Visual distinction between one-time and recurring instances

## Firestore Indexes
Add composite indexes for querying recurring transactions and their instances.
