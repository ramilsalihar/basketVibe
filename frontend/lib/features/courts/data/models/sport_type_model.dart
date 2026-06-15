import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// A sport played at a court, stored in the `sportTypes` collection.
///
/// Document shape:
/// ```
/// name: string   — display name, e.g. "Баскетбол"
/// icon: string   — icon key (see [iconData]), e.g. "basketball"
/// ```
/// Document id is a slug like `basketball`, referenced by
/// `courts/{id}.sportTypeId`.
class SportTypeModel {
  const SportTypeModel({
    required this.id,
    required this.name,
    required this.icon,
  });

  final String id;
  final String name;

  /// Icon key, mapped to a Material icon by [iconData].
  final String icon;

  factory SportTypeModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return SportTypeModel(
      id: doc.id,
      name: data['name'] as String? ?? doc.id,
      icon: data['icon'] as String? ?? 'sports',
    );
  }

  IconData get iconData => switch (icon) {
        'basketball' => Icons.sports_basketball_rounded,
        'football' => Icons.sports_soccer_rounded,
        'volleyball' => Icons.sports_volleyball_rounded,
        'tennis' => Icons.sports_tennis_rounded,
        'handball' => Icons.sports_handball_rounded,
        _ => Icons.sports_rounded,
      };
}
