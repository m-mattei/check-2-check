## 1. Setup

- [x] 1.1 Add `cloud_firestore` dependency to `pubspec.yaml`
- [x] 1.2 Check Firebase config in `lib/firebase_options.dart` includes Firestore
- [x] 1.3 Initialize Firestore in `main.dart`

## 2. Firestore Service

- [x] 2.1 Create `lib/services/firestore_service.dart` with singleton pattern
- [x] 2.2 Implement `getOrCreateHousehold()` helper (auto-create on first login)
- [x] 2.3 Implement generic `add`, `update`, `delete`, `stream` methods for collections

## 3. Data Models

- [x] 3.1 Create `_FirestoreCategory` model with Firestore fields
- [x] 3.2 Create `_FirestorePerson` model with Firestore fields
- [x] 3.3 Create `_FirestorePaycheck` model with Firestore fields
- [x] 3.4 Create `_FirestoreExpense` model with Firestore fields
- [x] 3.5 Create `Goal` model in `lib/models/goal.dart`
- [x] 3.6 Create `Note` model in `lib/models/goal.dart`

## 4. Categories CRUD

- [x] 4.1 Add category (Firestore)
- [x] 4.2 Edit category (Firestore)
- [x] 4.3 Delete category (Firestore)
- [x] 4.4 Stream categories (real-time listener)

## 5. People CRUD

- [x] 5.1 Create `_FirestorePerson` model (ready for wiring)
- [x] 5.2 Wire People stream to Plan screen UI (used in paycheck/expense dialogs)
- [x] 5.3 Add person (Firestore)
- [x] 5.4 Delete person (Firestore)

## 6. Paychecks CRUD

- [x] 6.1 Create `_FirestorePaycheck` model (ready for wiring)
- [x] 6.2 Stream paychecks from Firestore (basic)
- [x] 6.3 Wire paychecks to full UI with expenses
- [x] 6.4 Add paycheck (Firestore)
- [x] 6.5 Delete paycheck (Firestore)

## 7. Expenses CRUD

- [x] 7.1 Create `_FirestoreExpense` model (ready for wiring)
- [x] 7.2 Wire expenses to paychecks (expense view in Plan screen)
- [x] 7.3 Add expense (Firestore)
- [x] 7.4 Delete expense (Firestore)

## 8. Goals CRUD

- [x] 8.1 Create `Goal` model in `lib/models/goal.dart`
- [ ] 8.2 Add Goal stream to Plan screen (deferred - no UI yet)
- [x] 8.3 Add goal (Firestore)
- [x] 8.4 Update goal progress (Firestore)
- [x] 8.5 Delete goal (Firestore)

## 9. Notes CRUD

- [x] 9.1 Create `Note` model in `lib/models/goal.dart`
- [ ] 9.2 Add Note stream to Plan screen (deferred - no UI yet)
- [x] 9.3 Save/update note for date (Firestore)
- [x] 9.4 Delete note (Firestore)

## 10. Security Rules

- [x] 10.1 Write Firestore security rules for household-scoped access
- [x] 10.2 Write Storage security rules for household-scoped access
- [x] 10.3 Define Firestore indexes for ordered queries
- [x] 10.4 Configure `firebase.json` for CLI deployment

## 11. Integration

- [x] 11.1 Replace mock data in Plan screen with Firestore streams (Categories, Paychecks, Expenses wired)
- [x] 11.2 Handle loading/error states
- [x] 11.3 Run `flutter analyze` with no issues
