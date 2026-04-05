# Tasks: Recurring Paychecks and Expenses

## Backend (Java API)
- [x] Update Paycheck.java model with recurring fields
- [x] Update Expense.java model with recurring fields
- [x] Add RecurrencePattern enum
- [ ] Update PaychecksResource to handle recurring fields
- [ ] Update ExpensesResource to handle recurring fields
- [ ] Add logic to generate recurring instances
- [ ] Update OpenAPI documentation

## Frontend (Flutter)
- [x] Update Paycheck model with recurring fields
- [x] Update Expense model with recurring fields
- [x] Add RecurrencePattern enum
- [x] Update feature_flags.dart with enableRecurringTransactions flag
- [x] Update PlanScreen add/edit dialogs to include recurring options
- [x] Update FirestoreService to handle recurring fields
- [ ] Update CalendarScreen to generate and display recurring instances
- [x] Add visual indicators for recurring transactions

## Documentation
- [x] Update OpenSpec specs
- [ ] Update user documentation in docs/src/content/docs/
- [ ] Update CHANGELOG.md

## Testing
- [ ] Test recurring paycheck creation
- [ ] Test recurring expense creation
- [ ] Test instance generation
- [ ] Test calendar display of recurring transactions
- [ ] Test edit/delete of recurring transactions
