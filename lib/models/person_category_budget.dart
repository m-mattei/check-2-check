class PersonCategoryBudget {
  final String id;
  final String personId;
  final String categoryId;
  final double budgetAmount;
  final DateTime? createdAt;

  const PersonCategoryBudget({
    required this.id,
    required this.personId,
    required this.categoryId,
    required this.budgetAmount,
    this.createdAt,
  });

  factory PersonCategoryBudget.fromFirestore(
    String id,
    Map<String, dynamic> data,
  ) {
    return PersonCategoryBudget(
      id: id,
      personId: data['personId'] ?? '',
      categoryId: data['categoryId'] ?? '',
      budgetAmount: (data['budgetAmount'] ?? 0).toDouble(),
      createdAt: data['createdAt']?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'personId': personId,
      'categoryId': categoryId,
      'budgetAmount': budgetAmount,
      'createdAt': createdAt,
    };
  }

  PersonCategoryBudget copyWith({
    String? id,
    String? personId,
    String? categoryId,
    double? budgetAmount,
    DateTime? createdAt,
  }) {
    return PersonCategoryBudget(
      id: id ?? this.id,
      personId: personId ?? this.personId,
      categoryId: categoryId ?? this.categoryId,
      budgetAmount: budgetAmount ?? this.budgetAmount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
