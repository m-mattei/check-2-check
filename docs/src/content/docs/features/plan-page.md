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

## Feature Flags
- **`enablePlanPage`**: Toggles Plan screen visibility (defaults to `true`)
