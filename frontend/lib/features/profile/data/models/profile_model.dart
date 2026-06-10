import 'package:basketvibe/features/profile/domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    required super.displayName,
    required super.city,
    required super.skillLevel,
    required super.gamesPlayed,
    super.avatarUrl,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      city: json['city'] as String,
      skillLevel: json['skillLevel'] as String,
      gamesPlayed: json['gamesPlayed'] as int,
    );
  }

  /// Maps the `users/{userId}` Firestore document; nullable profile
  /// fields fall back to sensible display defaults.
  factory ProfileModel.fromFirestore(String id, Map<String, dynamic> data) {
    final email = data['email'] as String?;
    return ProfileModel(
      id: id,
      displayName: data['displayName'] as String? ??
          data['username'] as String? ??
          email?.split('@').first ??
          'Player',
      city: data['city'] as String? ?? '—',
      skillLevel: data['skillLevel'] as String? ?? 'beginner',
      gamesPlayed: (data['gamesPlayed'] as num?)?.toInt() ?? 0,
      avatarUrl: data['avatarUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'city': city,
      'skillLevel': skillLevel,
      'gamesPlayed': gamesPlayed,
    };
  }
}

