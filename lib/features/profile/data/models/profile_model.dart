import 'package:basketvibe/features/profile/domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    required super.displayName,
    required super.city,
    required super.skillLevel,
    required super.gamesPlayed,
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

