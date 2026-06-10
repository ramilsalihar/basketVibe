import 'package:equatable/equatable.dart';

/// Domain entity for user profile data shown in Profile feature.
class ProfileEntity extends Equatable {
  const ProfileEntity({
    required this.id,
    required this.displayName,
    required this.city,
    required this.skillLevel,
    required this.gamesPlayed,
    this.avatarUrl,
  });

  final String id;
  final String displayName;
  final String city;
  final String skillLevel;
  final int gamesPlayed;
  final String? avatarUrl;

  @override
  List<Object?> get props =>
      [id, displayName, city, skillLevel, gamesPlayed, avatarUrl];
}

