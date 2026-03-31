## Context

The Plan screen has mock paychecks and categories but no person mapping or custom category support. Household members (from `Person` model) should be assignable to paychecks and expenses, displayed as tags. Categories should be user-definable.

## Decisions

- **Person Tags**: Small `Chip` widgets with person initials/name displayed on paycheck cards and expense items
- **Custom Categories**: FAB opens a bottom sheet with category list + add/edit/delete actions
- **Mock People**: Use hardcoded sample `Person` objects until real household data is wired up
- **Persistence**: Not yet — mock data only. Persistence comes in a future phase
- **Category Icons**: Use Material `Icons` with a simple icon picker in the add/edit dialog

## Risks / Trade-offs

- **Risk: Too many tags clutter the UI** → Limit to 2-3 visible tags, overflow indicator for more
- **Risk: Category management is complex** → Start with a simple bottom sheet list + add/edit/delete, not a full settings page
