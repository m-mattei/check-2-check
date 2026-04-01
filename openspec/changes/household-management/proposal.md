## Why

Users need to manage household members so they can assign paychecks and expenses to specific people. The Person model and Firestore CRUD already exist, but there is no UI for creating, editing, or deleting household members.

## What Changes

- **Household Management Screen**: New screen listing all household members with add/edit/delete capabilities
- **Settings Integration**: "Household" tile in Settings screen navigates to Household Management
- **Person CRUD UI**: Dialogs for adding and editing members (first name, last name, nickname, role, color)
- **Swipe to Delete**: Dismissible cards for removing members with confirmation

## Capabilities

### New Capabilities
- `household-management`: Users can manage household members via dedicated screen

## Impact

- `lib/screens/household_screen.dart`: New screen for household member management
- `lib/screens/settings_screen.dart`: Add Household navigation tile
- `lib/models/person.dart`: Already supports all needed fields
