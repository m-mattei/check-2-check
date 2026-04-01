## 1. Feature Flag

- [x] 1.1 Add `enableCalendarExpenses` to FeatureFlags
- [x] 1.2 Add toggle in Dev Mode screen

## 2. Calendar Screen Updates

- [x] 2.1 Import Expense model in CalendarScreen
- [x] 2.2 Add `_expenseEvents` state variable
- [x] 2.3 Subscribe to `streamExpenses()` in initState
- [x] 2.4 Update `eventLoader` to return combined paycheck + expense list
- [x] 2.5 Update `markerBuilder` to show different colors for paychecks vs expenses
- [x] 2.6 Update `_buildDayDetail` to show expenses alongside paychecks
- [x] 2.7 Show assigned people for expenses in day detail

## 3. Verification

- [x] 3.1 Run `flutter analyze` with no issues

## 4. Expense CRUD in Plan Screen

- [x] 4.1 Add Expenses segment to SegmentedButton
- [x] 4.2 Create expense list view with Dismissible cards
- [x] 4.3 Create Add Expense dialog with name, amount, account, date, category, and person mapping
- [x] 4.4 Add expense delete functionality with confirmation
