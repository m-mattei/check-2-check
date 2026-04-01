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

  const Expense({
    required this.id,
    required this.name,
    required this.amount,
    required this.categoryId,
    required this.account,
    required this.assignedPeopleIds,
    required this.date,
    this.createdAt,
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
    );
  }
}
