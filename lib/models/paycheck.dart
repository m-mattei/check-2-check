import 'package:cloud_firestore/cloud_firestore.dart';

class Paycheck {
  final String id;
  final DateTime date;
  final double amount;
  final List<String> assignedPeopleIds;
  final DateTime? createdAt;
  final bool isRecurring;
  final String? recurrencePattern;
  final int? recurrenceDayOfWeek;
  final int? recurrenceDayOfMonth;
  final DateTime? recurrenceEndDate;
  final String? parentPaycheckId;

  const Paycheck({
    required this.id,
    required this.date,
    required this.amount,
    required this.assignedPeopleIds,
    this.createdAt,
    this.isRecurring = false,
    this.recurrencePattern,
    this.recurrenceDayOfWeek,
    this.recurrenceDayOfMonth,
    this.recurrenceEndDate,
    this.parentPaycheckId,
  });

  factory Paycheck.fromFirestore(String id, Map<String, dynamic> data) {
    return Paycheck(
      id: id,
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      amount: (data['amount'] ?? 0).toDouble(),
      assignedPeopleIds: List<String>.from(data['assignedPeople'] ?? []),
      createdAt: data['createdAt']?.toDate(),
      isRecurring: data['isRecurring'] ?? false,
      recurrencePattern: data['recurrencePattern'],
      recurrenceDayOfWeek: data['recurrenceDayOfWeek'],
      recurrenceDayOfMonth: data['recurrenceDayOfMonth'],
      recurrenceEndDate: data['recurrenceEndDate']?.toDate(),
      parentPaycheckId: data['parentPaycheckId'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'date': Timestamp.fromDate(date),
      'amount': amount,
      'assignedPeople': assignedPeopleIds,
      'createdAt': createdAt,
      if (isRecurring) 'isRecurring': isRecurring,
      if (recurrencePattern != null) 'recurrencePattern': recurrencePattern,
      if (recurrenceDayOfWeek != null)
        'recurrenceDayOfWeek': recurrenceDayOfWeek,
      if (recurrenceDayOfMonth != null)
        'recurrenceDayOfMonth': recurrenceDayOfMonth,
      if (recurrenceEndDate != null)
        'recurrenceEndDate': Timestamp.fromDate(recurrenceEndDate!),
      if (parentPaycheckId != null) 'parentPaycheckId': parentPaycheckId,
    };
  }

  Paycheck copyWith({
    String? id,
    DateTime? date,
    double? amount,
    List<String>? assignedPeopleIds,
    DateTime? createdAt,
    bool? isRecurring,
    String? recurrencePattern,
    int? recurrenceDayOfWeek,
    int? recurrenceDayOfMonth,
    DateTime? recurrenceEndDate,
    String? parentPaycheckId,
  }) {
    return Paycheck(
      id: id ?? this.id,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      assignedPeopleIds: assignedPeopleIds ?? this.assignedPeopleIds,
      createdAt: createdAt ?? this.createdAt,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrencePattern: recurrencePattern ?? this.recurrencePattern,
      recurrenceDayOfWeek: recurrenceDayOfWeek ?? this.recurrenceDayOfWeek,
      recurrenceDayOfMonth: recurrenceDayOfMonth ?? this.recurrenceDayOfMonth,
      recurrenceEndDate: recurrenceEndDate ?? this.recurrenceEndDate,
      parentPaycheckId: parentPaycheckId ?? this.parentPaycheckId,
    );
  }
}
