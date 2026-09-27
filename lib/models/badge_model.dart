import 'package:flutter/material.dart';

class BadgeModel {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final int requiredXp;
  final bool isUnlocked;

  const BadgeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.requiredXp,
    this.isUnlocked = false,
  });

  BadgeModel copyWith({bool? isUnlocked}) {
    return BadgeModel(
      id: id,
      title: title,
      description: description,
      icon: icon,
      iconColor: iconColor,
      requiredXp: requiredXp,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }
}
