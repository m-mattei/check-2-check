## Context

The Plan screen is the second tab in the bottom navigation bar. It currently shows a "Construction Zone" placeholder. The app's unique value is paycheck-based budget planning — users map their expenses and savings around future paychecks rather than traditional monthly budgets.

## Goals / Non-Goals

**Goals:**
- Provide a functional UI skeleton for the Plan screen
- Support two planning views: Paycheck-centric and Category-centric
- Gate behind a feature flag for incremental rollout
- Use Material 3 styling consistent with the rest of the app

**Non-Goals:**
- Data persistence (mock data for now)
- Drag-and-drop expense assignment to paychecks
- Actual paycheck scheduling or income tracking
- Budget calculations or variance analysis

## Decisions

- **View Toggle**: A `SegmentedButton` or `TabBar` at the top to switch between "Paychecks" and "Categories" views
- **Paycheck View**: `ListView` of upcoming paycheck cards showing date, amount, and assigned expenses
- **Category View**: `ListView` of budget categories (Rent, Groceries, Savings, etc.) with planned amounts
- **Mock Data**: Use hardcoded sample data until data models and persistence are built
- **Feature Flag**: `enablePlanPage` in `FeatureFlags` to control visibility

## Risks / Trade-offs

- **Risk: Mock data feels incomplete** → Acceptable for skeleton phase. Real data models come next.
- **Risk: View toggle adds complexity** → Minimal — just a `SegmentedButton` controlling which widget renders
- **Risk: Feature flag adds boilerplate** → Required by project rules; minimal overhead
