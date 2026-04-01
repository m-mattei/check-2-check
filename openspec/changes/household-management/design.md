## Design Decisions

### Location
Household management is accessed from the Settings screen as a dedicated tile, consistent with how other management features are surfaced.

### Person Form
- Required: first name, last name
- Optional: middle name, nickname, date of birth
- Role: dropdown with HouseholdRole enum values (owner, spouse, child, dependent, guest)
- Color: color picker for visual identification in calendar/paycheck/expense views

### List Display
Each member shown as a Card with:
- CircleAvatar with first initial and person's chosen color
- Full name as title
- Role as subtitle
- Trailing edit icon
- Swipe-to-delete with confirmation dialog
