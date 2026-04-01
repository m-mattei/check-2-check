## Design Decisions

### Combined Event Model

Rather than creating a new union type, the calendar maintains two separate maps:
- `_paycheckEvents: Map<DateTime, List<Paycheck>>`
- `_expenseEvents: Map<DateTime, List<Expense>>`

The `eventLoader` returns a combined `List<dynamic>` so the `markerBuilder` can differentiate by type. This avoids creating a wrapper class and keeps the existing paycheck logic intact.

### Visual Differentiation

- **Paychecks**: Green circle markers (using `colorScheme.primary`)
- **Expenses**: Red/orange circle markers (using `colorScheme.error`)

This gives users an at-a-glance understanding of income vs outflow on any given day.

### Day Detail Layout

The day detail panel groups items by type:
1. Paychecks section (if any) - shows amount, date, assigned people
2. Expenses section (if any) - shows name, amount, category placeholder, assigned people

Each item is a Card with an ExpansionTile showing assigned people as Chips.

### Feature Flag

The `enableCalendarExpenses` flag defaults to `false` so existing users don't see unexpected changes. Can be enabled in Dev Mode for testing.
