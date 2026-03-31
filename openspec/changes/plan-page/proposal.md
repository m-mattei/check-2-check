## Why

The Plan screen is currently a placeholder ("Construction Zone"). The core value proposition of Check-2-Check is mapping budget planning around future paychecks. Users need a way to see upcoming paychecks, assign expenses and categories to them, and understand how their money will be allocated before it arrives.

## What Changes

- **Plan Screen Redesign**: Replace the placeholder with a functional UI skeleton
- **Paycheck View**: Display upcoming paychecks as planning anchors
- **Expense/Category View**: Show budget categories with planned amounts
- **Toggle Between Views**: Users can switch between paycheck-centric and category-centric planning
- **Feature Flag**: Gated behind `enablePlanPage` toggle in Dev Mode

## Capabilities

### New Capabilities
- `budget-planning`: Users can view upcoming paychecks and plan expense allocation against them
- `expense-categories`: Users can see and manage budget categories with planned amounts

### Modified Capabilities
- `navigation`: Plan tab transitions from placeholder to functional screen

## Impact

- `lib/screens/plan_screen.dart`: Full redesign from placeholder to functional UI
- `lib/utils/feature_flags.dart`: Add `enablePlanPage` toggle
- `lib/screens/dev_mode_screen.dart`: Add toggle UI for the new flag
- `lib/models/`: Potential new models for paycheck, expense category, budget item (future phases)
