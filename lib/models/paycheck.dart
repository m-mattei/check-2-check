import 'package:cloud_firestore/cloud_firestore.dart';

class Paycheck {
  final String id;
  final DateTime date;
  final double amount;
  final List<String> assignedPeopleIds;
  final DateTime? createdAt;

  const Paycheck({
    required this.id,
    required this.date,
    required this.amount,
    required this.assignedPeopleIds,
    this.createdAt,
  });

  factory Paycheck.fromFirestore(String id, Map<String, dynamic> data) {
    return Paycheck(
      id: id,
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      amount: (data['amount'] ?? 0).toDouble(),
      assignedPeopleIds: List<String>.from(data['assignedPeople'] ?? []),
      createdAt: data['createdAt']?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'date': Timestamp.fromDate(date),
      'amount': amount,
      'assignedPeople': assignedPeopleIds,
      'createdAt': createdAt,
    };
  }

  Paycheck copyWith({
    String? id,
    DateTime? date,
    double? amount,
    List<String>? assignedPeopleIds,
    DateTime? createdAt,
  }) {
    return Paycheck(
      id: id ?? this.id,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      assignedPeopleIds: assignedPeopleIds ?? this.assignedPeopleIds,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
