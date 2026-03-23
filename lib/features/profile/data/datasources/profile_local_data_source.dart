import 'package:basketvibe/features/profile/data/models/profile_model.dart';

class ProfileLocalDataSource {
  const ProfileLocalDataSource();

  Future<ProfileModel> getProfile(String userId) async {
    // Mock/local profile for MVP.
    return ProfileModel(
      id: userId,
      displayName: 'Player One',
      city: 'Bishkek',
      skillLevel: 'Intermediate',
      gamesPlayed: 12,
    );
  }
}

