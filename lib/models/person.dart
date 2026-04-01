import 'package:check_2_check/models/household_role.dart';

class Person {
  final String id;
  final String userId;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String? nickname;
  final DateTime? dateOfBirth;
  final HouseholdRole? role;
  final String? color;

  const Person({
    required this.id,
    required this.userId,
    required this.firstName,
    this.middleName,
    required this.lastName,
    this.nickname,
    this.dateOfBirth,
    this.role,
    this.color,
  });

  String get fullName {
    final parts = <String>[firstName];
    if (middleName != null) parts.add(middleName!);
    parts.add(lastName);
    return parts.join(' ');
  }

  String? get displayName => nickname ?? fullName;

  factory Person.fromFirestore(String id, Map<String, dynamic> data) {
    return Person(
      id: id,
      userId: data['userId'] ?? '',
      firstName: data['firstName'] ?? data['name'] ?? 'Unknown',
      middleName: data['middleName'],
      lastName: data['lastName'] ?? '',
      nickname: data['nickname'],
      dateOfBirth: data['dateOfBirth']?.toDate(),
      role: data['role'] != null ? HouseholdRole.values[data['role']] : null,
      color: data['color']?.toString(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'nickname': nickname,
      'dateOfBirth': dateOfBirth,
      'role': role?.index,
      'color': color,
    };
  }

  Person copyWith({
    String? id,
    String? userId,
    String? firstName,
    String? middleName,
    String? lastName,
    String? nickname,
    DateTime? dateOfBirth,
    HouseholdRole? role,
    String? color,
  }) {
    return Person(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      nickname: nickname ?? this.nickname,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      role: role ?? this.role,
      color: color ?? this.color,
    );
  }
}
