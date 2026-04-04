import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:check_2_check/models/category.dart';
import 'package:check_2_check/models/person.dart';
import 'package:check_2_check/models/paycheck.dart';
import 'package:check_2_check/models/expense.dart';
import 'package:check_2_check/models/goal.dart';
import 'package:check_2_check/models/person_category_budget.dart';

class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;
  FirestoreService._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _householdId;
  String? get householdId => _householdId;

  Future<String> getOrCreateHousehold() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final userDoc = _db.collection('users').doc(user.uid);
    final doc = await userDoc.get();

    if (doc.exists && doc.data()?['householdId'] != null) {
      _householdId = doc.data()!['householdId'];
      return _householdId!;
    }

    final householdRef = _db.collection('households').doc();
    await householdRef.set({
      'createdAt': FieldValue.serverTimestamp(),
      'name': 'My Household',
    });

    await userDoc.set({
      'householdId': householdRef.id,
      'email': user.email,
      'createdAt': FieldValue.serverTimestamp(),
    });

    _householdId = householdRef.id;
    return _householdId!;
  }

  // --- Collections ---

  CollectionReference _categories() =>
      _db.collection('households').doc(_householdId).collection('categories');

  CollectionReference _people() =>
      _db.collection('households').doc(_householdId).collection('people');

  CollectionReference _paychecks() =>
      _db.collection('households').doc(_householdId).collection('paychecks');

  CollectionReference _expenses() =>
      _db.collection('households').doc(_householdId).collection('expenses');

  CollectionReference _goals() =>
      _db.collection('households').doc(_householdId).collection('goals');

  CollectionReference _notes() =>
      _db.collection('households').doc(_householdId).collection('notes');

  CollectionReference _personCategoryBudgets() => _db
      .collection('households')
      .doc(_householdId)
      .collection('personCategoryBudgets');

  // --- Documents ---

  DocumentReference _category(String id) => _categories().doc(id);
  DocumentReference _person(String id) => _people().doc(id);
  DocumentReference _paycheck(String id) => _paychecks().doc(id);
  DocumentReference _expense(String id) => _expenses().doc(id);
  DocumentReference _goal(String id) => _goals().doc(id);
  DocumentReference _note(String id) => _notes().doc(id);
  DocumentReference _personCategoryBudget(String id) =>
      _personCategoryBudgets().doc(id);

  // --- Streams ---

  Stream<List<Category>> streamCategories() {
    return _categories().orderBy('createdAt', descending: true).snapshots().map(
      (snapshot) {
        return snapshot.docs
            .map(
              (doc) => Category.fromFirestore(
                doc.id,
                doc.data() as Map<String, dynamic>,
              ),
            )
            .toList();
      },
    );
  }

  Stream<List<Person>> streamPeople() {
    return _people().orderBy('firstName', descending: false).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs
          .map(
            (doc) => Person.fromFirestore(
              doc.id,
              doc.data() as Map<String, dynamic>,
            ),
          )
          .toList();
    });
  }

  Stream<List<Paycheck>> streamPaychecks() {
    return _paychecks().orderBy('date', descending: true).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs
          .map(
            (doc) => Paycheck.fromFirestore(
              doc.id,
              doc.data() as Map<String, dynamic>,
            ),
          )
          .toList();
    });
  }

  Stream<List<Expense>> streamExpenses() {
    return _expenses().orderBy('date', descending: true).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs
          .map(
            (doc) => Expense.fromFirestore(
              doc.id,
              doc.data() as Map<String, dynamic>,
            ),
          )
          .toList();
    });
  }

  Stream<List<Goal>> streamGoals() {
    return _goals().orderBy('createdAt', descending: true).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs
          .map(
            (doc) =>
                Goal.fromFirestore(doc.id, doc.data() as Map<String, dynamic>),
          )
          .toList();
    });
  }

  Stream<Note?> streamNote(String dateKey) {
    final docId = dateKey.replaceAll('-', '');
    return _note(docId).snapshots().map((snapshot) {
      if (!snapshot.exists) return null;
      return Note.fromFirestore(
        snapshot.id,
        snapshot.data() as Map<String, dynamic>,
      );
    });
  }

  Stream<List<PersonCategoryBudget>> streamPersonCategoryBudgets() {
    return _personCategoryBudgets().snapshots().map((snapshot) {
      return snapshot.docs
          .map(
            (doc) => PersonCategoryBudget.fromFirestore(
              doc.id,
              doc.data() as Map<String, dynamic>,
            ),
          )
          .toList();
    });
  }

  // --- CRUD Category ---

  Future<void> addCategory(Category category) async {
    final data = category.toFirestore();
    data['createdAt'] = FieldValue.serverTimestamp();
    await _categories().add(data);
  }

  Future<void> updateCategory(Category category) async {
    await _category(category.id).update(category.toFirestore());
  }

  Future<void> deleteCategory(String id) => _category(id).delete();

  // --- CRUD Person ---

  Future<void> addPerson(Person person) async {
    final data = person.toFirestore();
    data['createdAt'] = FieldValue.serverTimestamp();
    await _people().add(data);
  }

  Future<void> updatePerson(Person person) async {
    await _person(person.id).update(person.toFirestore());
  }

  Future<void> deletePerson(String id) => _person(id).delete();

  // --- CRUD Paycheck ---

  Future<void> addPaycheck(Paycheck paycheck) async {
    final data = paycheck.toFirestore();
    data['createdAt'] = FieldValue.serverTimestamp();
    await _paychecks().add(data);
  }

  Future<void> updatePaycheck(Paycheck paycheck) async {
    await _paycheck(paycheck.id).update(paycheck.toFirestore());
  }

  Future<void> deletePaycheck(String id) => _paycheck(id).delete();

  // --- CRUD Expense ---

  Future<void> addExpense(Expense expense) async {
    final data = expense.toFirestore();
    data['createdAt'] = FieldValue.serverTimestamp();
    await _expenses().add(data);
  }

  Future<void> updateExpense(Expense expense) async {
    await _expense(expense.id).update(expense.toFirestore());
  }

  Future<void> deleteExpense(String id) => _expense(id).delete();

  // --- CRUD Goal ---

  Future<void> addGoal(Goal goal) async {
    final data = goal.toFirestore();
    data['createdAt'] = FieldValue.serverTimestamp();
    await _goals().add(data);
  }

  Future<void> updateGoal(Goal goal) async {
    await _goal(goal.id).update(goal.toFirestore());
  }

  Future<void> deleteGoal(String id) => _goal(id).delete();

  // --- CRUD Note ---

  Future<void> saveNote(Note note) async {
    final docId = note.dateKey.replaceAll('-', '');
    final data = note.toFirestore();
    data['updatedAt'] = FieldValue.serverTimestamp();
    await _notes().doc(docId).set(data, SetOptions(merge: true));
  }

  Future<void> deleteNote(String id) => _note(id).delete();

  // --- CRUD PersonCategoryBudget ---

  Future<void> addPersonCategoryBudget(PersonCategoryBudget budget) async {
    final data = budget.toFirestore();
    data['createdAt'] = FieldValue.serverTimestamp();
    await _personCategoryBudgets().add(data);
  }

  Future<void> updatePersonCategoryBudget(PersonCategoryBudget budget) async {
    await _personCategoryBudget(budget.id).update(budget.toFirestore());
  }

  Future<void> deletePersonCategoryBudget(String id) =>
      _personCategoryBudget(id).delete();

  Future<void> deletePersonCategoryBudgetsByPerson(String personId) async {
    final snapshot = await _personCategoryBudgets()
        .where('personId', isEqualTo: personId)
        .get();
    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> deletePersonCategoryBudgetsByCategory(String categoryId) async {
    final snapshot = await _personCategoryBudgets()
        .where('categoryId', isEqualTo: categoryId)
        .get();
    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}
