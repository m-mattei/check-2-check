---
title: Plan Page
---

## Overview
The Plan screen is the second tab in the bottom navigation bar. It provides paycheck-based budget planning — users map their expenses and savings around future paychecks rather than traditional monthly budgets.

## Views

### Paychecks View
- Expandable cards showing date, amount, and assigned expenses
- **Person tags** on each paycheck showing who it's assigned to
- **Person tags** on each expense showing who is responsible
- Remaining balance per paycheck (green if positive, red if over)
- Past vs upcoming visual distinction (checkmark vs upcoming icon)

### Categories View
- Budget categories with icons, progress bars, and spent/planned amounts
- **Custom categories** marked with a "Custom" badge
- **Add category** via FAB → bottom sheet with name, icon picker, and planned amount
- **Edit category** via edit button (custom categories only)
- **Delete category** via swipe-to-dismiss with confirmation (custom categories only)
- 16 icon options available for custom categories

## Person Tags
- Displayed as colored chips with the person's display name
- Each person has an assigned color for visual distinction
- Smaller variant on expense items, full size on paycheck cards

## Recurring Transactions
The Plan screen supports creating recurring paychecks and expenses to automate your budget planning.

### Creating Recurring Transactions
1. Tap the **+** button to add a paycheck or expense
2. Enable the **Recurring** toggle
3. Select a frequency pattern:
   - **Weekly**: Repeats every week on a specific day
   - **Biweekly**: Repeats every 2 weeks
   - **Monthly**: Repeats every month on a specific day
   - **Quarterly**: Repeats every 3 months
   - **Annually**: Repeats every year
4. Choose the day (day of week for weekly/biweekly, day of month for others)
5. Optionally set an end date

### Visual Indicators
Recurring transactions display a **"Recurring"** badge with a repeat icon, styled with the primary theme color.

### Feature Flags
- **`enablePlanPage`**: Toggles Plan screen visibility (defaults to `true`)
- **`enableRecurringTransactions`**: Toggles recurring transaction options (defaults to `false`)
