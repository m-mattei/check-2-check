# Paycheck Expense Planning - Proposal

## Problem
Currently, the Plan screen allows users to add paychecks and expenses separately, but there's no way to:
1. Assign expenses to specific paychecks
2. Track how much of each paycheck is "allocated" to expenses
3. See remaining budget per paycheck

## Solution
Add paycheck-based expense planning that allows:
- Assigning expenses to specific paychecks
- Visual tracking of paycheck usage (allocated vs remaining)
- Better budget visibility

## Benefits
- Clearer picture of which paycheck pays for which expenses
- Prevent overspending by showing remaining per paycheck
- Better financial planning workflow

## Scope
- Update Expense model to add paycheckId
- Update Firestore service
- Add paycheck assignment dropdown in expense dialog
- Show allocation tracking in paycheck view
- Add feature flag for this feature

## Timeline
- Phase 1: Data model and Firestore updates
- Phase 2: UI updates (paycheck view, expense dialog)
- Phase 3: Polish and testing