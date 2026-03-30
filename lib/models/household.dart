import 'package:check_2_check/models/household_role.dart';
import 'package:check_2_check/models/person.dart';

class Household {
  final String id;
  final String name;
  final List<HouseholdMember> members;

  const Household({
    required this.id,
    required this.name,
    required this.members,
  });
}

class HouseholdMember {
  final String id;
  final String householdId;
  final String personId;
  final Person? person;
  final HouseholdRole role;
  final DateTime joinedAt;

  const HouseholdMember({
    required this.id,
    required this.householdId,
    required this.personId,
    this.person,
    required this.role,
    required this.joinedAt,
  });
}
