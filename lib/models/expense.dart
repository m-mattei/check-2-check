import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  final String id;
  final String name;
  final double amount;
  final String categoryId;
  final String account;
  final List<String> assignedPeopleIds;
  final DateTime date;
  final DateTime? createdAt;
  final bool isRecurring;
  final String? recurrencePattern;
  final int? recurrenceDayOfWeek;
  final int? recurrenceDayOfMonth;
  final DateTime? recurrenceEndDate;
  final String? parentExpenseId;
  final String? paycheckId;

  const Expense({
    required this.id,
    required this.name,
    required this.amount,
    required this.categoryId,
    required this.account,
    required this.assignedPeopleIds,
    required this.date,
    this.createdAt,
    this.isRecurring = false,
    this.recurrencePattern,
    this.recurrenceDayOfWeek,
    this.recurrenceDayOfMonth,
    this.recurrenceEndDate,
    this.parentExpenseId,
    this.paycheckId,
  });

  factory Expense.fromFirestore(String id, Map<String, dynamic> data) {
    return Expense(
      id: id,
      name: data['name'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      categoryId: data['categoryId'] ?? '',
      account: data['account'] ?? '',
      assignedPeopleIds: List<String>.from(data['assignedPeople'] ?? []),
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdAt: data['createdAt']?.toDate(),
      isRecurring: data['isRecurring'] ?? false,
      recurrencePattern: data['recurrencePattern'],
      recurrenceDayOfWeek: data['recurrenceDayOfWeek'],
      recurrenceDayOfMonth: data['recurrenceDayOfMonth'],
      recurrenceEndDate: data['recurrenceEndDate']?.toDate(),
      parentExpenseId: data['parentExpenseId'],
      paycheckId: data['paycheckId'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'amount': amount,
      'categoryId': categoryId,
      'account': account,
      'assignedPeople': assignedPeopleIds,
      'date': Timestamp.fromDate(date),
      'createdAt': createdAt,
      if (isRecurring) 'isRecurring': isRecurring,
      if (recurrencePattern != null) 'recurrencePattern': recurrencePattern,
      if (recurrenceDayOfWeek != null)
        'recurrenceDayOfWeek': recurrenceDayOfWeek,
      if (recurrenceDayOfMonth != null)
        'recurrenceDayOfMonth': recurrenceDayOfMonth,
      if (recurrenceEndDate != null)
        'recurrenceEndDate': Timestamp.fromDate(recurrenceEndDate!),
      if (parentExpenseId != null) 'parentExpenseId': parentExpenseId,
      if (paycheckId != null) 'paycheckId': paycheckId,
    };
  }

  Expense copyWith({
    String? id,
    String? name,
    double? amount,
    String? categoryId,
    String? account,
    List<String>? assignedPeopleIds,
    DateTime? date,
    DateTime? createdAt,
    bool? isRecurring,
    String? recurrencePattern,
    int? recurrenceDayOfWeek,
    int? recurrenceDayOfMonth,
    DateTime? recurrenceEndDate,
    String? parentExpenseId,
    String? paycheckId,
  }) {
    return Expense(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      categoryId: categoryId ?? this.categoryId,
      account: account ?? this.account,
      assignedPeopleIds: assignedPeopleIds ?? this.assignedPeopleIds,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrencePattern: recurrencePattern ?? this.recurrencePattern,
      recurrenceDayOfWeek: recurrenceDayOfWeek ?? this.recurrenceDayOfWeek,
      recurrenceDayOfMonth: recurrenceDayOfMonth ?? this.recurrenceDayOfMonth,
      recurrenceEndDate: recurrenceEndDate ?? this.recurrenceEndDate,
      parentExpenseId: parentExpenseId ?? this.parentExpenseId,
      paycheckId: paycheckId ?? this.paycheckId,
    );
  }
}
