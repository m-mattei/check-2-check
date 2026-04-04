# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.0] - 2026-04-04

### Added
- Recurring paychecks and expenses with configurable frequency patterns
- Support for weekly, bi-weekly, monthly, quarterly, and annual recurrence
- Day of week selection for weekly/bi-weekly patterns
- Day of month selection for monthly/quarterly/annual patterns
- Optional end date for recurring transactions
- Visual indicators for recurring transactions with repeat icon
- Feature flag `enableRecurringTransactions` to control visibility
- Recurrence fields in Paycheck and Expense models

### Changed
- Updated Paycheck model with isRecurring, recurrencePattern, recurrenceDayOfWeek, recurrenceDayOfMonth, recurrenceEndDate, and parentPaycheckId fields
- Updated Expense model with isRecurring, recurrencePattern, recurrenceDayOfWeek, recurrenceDayOfMonth, recurrenceEndDate, and parentExpenseId fields
- Enhanced add paycheck and expense dialogs with recurring options

## [1.1.0] - 2026-03-30

### Added
- Settings screen with user profile, appearance, and account management
- Configurable primary and secondary theme colors with preset palette
- Custom color picker with RGB sliders for arbitrary color selection
- Secondary color applied to tab bar icons and body text
- Plan screen with paycheck-based budget planning
- Paycheck view with expandable cards showing date, amount, and expenses
- Category view with progress bars and spent/planned tracking
- Person mapping tags on paychecks and expenses
- Custom budget category creation, editing, and deletion
- Feature flag `enablePlanPage` for Plan screen visibility
- Agent rules (AGENTS.md) and OpenSpec sync workflow
- Developer Options toggle for Plan page

### Changed
- Renamed Profile tab to Settings with `Icons.settings` icon
- Calendar today indicator styled with semi-transparent gray
- Profile screen refactored into Settings screen

### Fixed
- FeatureFlags resilient initialization to prevent white screen on launch

## [1.0.0] - 2026-03-30

### Added
- Initial project setup with Flutter
- Firebase authentication with Google Sign-In
- Local username login bypass for development
- Calendar screen with `table_calendar`
- Bottom navigation with Calendar, Plan, and Profile tabs
- Feature flags system with Dev Mode screen
- Project documentation site with Astro + Starlight
