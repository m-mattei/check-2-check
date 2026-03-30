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

  const Person({
    required this.id,
    required this.userId,
    required this.firstName,
    this.middleName,
    required this.lastName,
    this.nickname,
    this.dateOfBirth,
    this.role,
  });

  String get fullName {
    final parts = <String>[firstName];
    if (middleName != null) parts.add(middleName!);
    parts.add(lastName);
    return parts.join(' ');
  }

  String? get displayName => nickname ?? fullName;
}
