# Paycheck Expense Planning - Design

## Overview
Allow users to assign planned expenses to specific paychecks and track how much of each paycheck is allocated to expenses and categories.

## Data Model Changes

### Expense
Add optional `paycheckId` field to track which paycheck this expense is planned for:
```dart
final String? paycheckId;
```

### Paycheck
Add computed tracking for allocation:
- Track allocated amount (sum of all expenses assigned to this paycheck)
- Track remaining amount (amount - allocated)

## UI Changes

### Paycheck View
- Show allocated amount vs total amount
- Show remaining balance
- Show list of assigned expenses with their categories

### Expense Dialog
- Add dropdown to select which paycheck this expense is for (optional)
- Allow filtering expenses by paycheck

### Category View
- Show category budget per paycheck (if applicable)

## Interactions
1. User creates/selects a paycheck
2. When adding expense, user can optionally assign to a paycheck
3. Paycheck card shows: total, allocated, remaining, assigned expenses list
4. Expenses view can filter by paycheck
5. Categories can show breakdown by paycheck

## Edge Cases
- Deleting a paycheck with assigned expenses - warn user, unassign expenses
- Expense assigned to paycheck is deleted - keep expense but clear paycheckId
- Paycheck amount changed - recalculate remaining