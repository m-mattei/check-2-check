class Goal {
  final String id;
  final String name;
  final double targetAmount;
  final double savedAmount;
  final DateTime? deadline;
  final DateTime? createdAt;

  const Goal({
    required this.id,
    required this.name,
    required this.targetAmount,
    this.savedAmount = 0,
    this.deadline,
    this.createdAt,
  });

  double get remaining => targetAmount - savedAmount;
  double get progress =>
      targetAmount > 0 ? (savedAmount / targetAmount).clamp(0.0, 1.0) : 0.0;

  factory Goal.fromFirestore(String id, Map<String, dynamic> data) {
    return Goal(
      id: id,
      name: data['name'] ?? '',
      targetAmount: (data['targetAmount'] ?? 0).toDouble(),
      savedAmount: (data['savedAmount'] ?? 0).toDouble(),
      deadline: data['deadline']?.toDate(),
      createdAt: data['createdAt']?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'targetAmount': targetAmount,
      'savedAmount': savedAmount,
      'deadline': deadline,
      'createdAt': createdAt,
    };
  }

  Goal copyWith({
    String? id,
    String? name,
    double? targetAmount,
    double? savedAmount,
    DateTime? deadline,
    DateTime? createdAt,
  }) {
    return Goal(
      id: id ?? this.id,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      savedAmount: savedAmount ?? this.savedAmount,
      deadline: deadline ?? this.deadline,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class Note {
  final String id;
  final String dateKey;
  final String content;
  final DateTime? updatedAt;

  const Note({
    required this.id,
    required this.dateKey,
    required this.content,
    this.updatedAt,
  });

  factory Note.fromFirestore(String id, Map<String, dynamic> data) {
    return Note(
      id: id,
      dateKey: data['dateKey'] ?? id,
      content: data['content'] ?? '',
      updatedAt: data['updatedAt']?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'content': content,
      'dateKey': dateKey,
      'updatedAt': updatedAt,
    };
  }
}
