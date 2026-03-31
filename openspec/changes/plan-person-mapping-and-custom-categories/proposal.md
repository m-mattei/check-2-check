## Why

The Plan page currently uses hardcoded mock data with no person mapping or custom categories. Users need to:
- Assign paychecks and expenses to specific people in their household
- See who is responsible for each expense via visual tags
- Create, edit, and delete custom budget categories beyond presets

## What Changes

- **Person Mapping**: Paychecks and expenses display person tags showing who they're assigned to
- **Custom Categories**: Users can add, edit, and delete budget categories with custom name, icon, and planned amount
- **Category Management UI**: A floating action button opens a dialog/form for category CRUD
- **Mock Data Update**: Sample data includes person assignments

## Capabilities

### New Capabilities
- `person-mapping`: Paychecks and expenses can be tagged with assigned household members
- `custom-categories`: Users can create, edit, and delete budget categories

### Modified Capabilities
- `budget-planning`: Expenses and categories now support person assignments and custom definitions

## Impact

- `lib/screens/plan_screen.dart`: Add person tags, category CRUD, custom category management
- `lib/models/person.dart`: Already exists, will be used for person references
- `lib/models/household.dart`: Already exists, will be used for household member lookup
