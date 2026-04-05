# Specification: Recurring Transactions

## Overview
Support for recurring paychecks and expenses with configurable frequency patterns.

## Recurrence Patterns

### Supported Frequencies
- **Weekly**: Repeats every week on a specified day of week
- **Bi-weekly**: Repeats every 2 weeks on a specified day of week
- **Monthly**: Repeats every month on a specified day of month (1-31)
- **Quarterly**: Repeats every 3 months on a specified day of month (1-31)
- **Annually**: Repeats every 12 months on a specified day of month (1-31)

### Data Model

#### Paycheck
```
isRecurring: boolean
recurrencePattern: enum (weekly, biweekly, monthly, quarterly, annually)
recurrenceDayOfWeek: int (1-7, Monday-Sunday)
recurrenceDayOfMonth: int (1-31)
recurrenceEndDate: DateTime (optional)
parentPaycheckId: String (for generated instances)
```

#### Expense
```
isRecurring: boolean
recurrencePattern: enum (weekly, biweekly, monthly, quarterly, annually)
recurrenceDayOfWeek: int (1-7, Monday-Sunday)
recurrenceDayOfMonth: int (1-31)
recurrenceEndDate: DateTime (optional)
parentExpenseId: String (for generated instances)
```

## UI Components

### Add/Edit Dialog
- Toggle switch to enable/disable recurring
- Dropdown for frequency selection
- Conditional day of week selector (for weekly/biweekly)
- Conditional day of month selector (for monthly/quarterly/annually)
- Optional end date picker

### Visual Indicators
- "Recurring" badge with repeat icon on transaction cards
- Badge styled with primaryContainer color scheme

## Feature Flag
- `enableRecurringTransactions`: Controls visibility of recurring options

## Future Enhancements (Not Implemented)
- Automatic instance generation for upcoming 90 days
- Edit recurring series vs single instance
- Skip next occurrence
- Calendar view showing future recurring instances
