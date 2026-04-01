import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final IconData icon;
  final double planned;
  final double spent;
  final bool isCustom;
  final DateTime? createdAt;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.planned,
    required this.spent,
    this.isCustom = false,
    this.createdAt,
  });

  double get remaining => planned - spent;

  factory Category.fromFirestore(String id, Map<String, dynamic> data) {
    return Category(
      id: id,
      name: data['name'] ?? '',
      icon: IconData(
        data['iconCodePoint'] ?? Icons.label.codePoint,
        fontFamily: data['iconFontFamily'],
      ),
      planned: (data['planned'] ?? 0).toDouble(),
      spent: (data['spent'] ?? 0).toDouble(),
      isCustom: data['isCustom'] ?? false,
      createdAt: data['createdAt']?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'iconCodePoint': icon.codePoint,
      'iconFontFamily': icon.fontFamily,
      'planned': planned,
      'spent': spent,
      'isCustom': isCustom,
      'createdAt': createdAt,
    };
  }

  Category copyWith({
    String? id,
    String? name,
    IconData? icon,
    double? planned,
    double? spent,
    bool? isCustom,
    DateTime? createdAt,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      planned: planned ?? this.planned,
      spent: spent ?? this.spent,
      isCustom: isCustom ?? this.isCustom,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
