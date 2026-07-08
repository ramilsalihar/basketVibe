import 'package:basketvibe/features/profile/data/models/profile_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Reads profile data from the `users/{userId}` Firestore document
/// (created by UserRemoteDataSource on first sign-in).
class ProfileRemoteDataSource {
  const ProfileRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  Future<ProfileModel> getProfile(String userId) async {
    final doc = _firestore.collection('users').doc(userId);
    final snapshot = await doc.get();
    if (snapshot.data() != null) {
      return ProfileModel.fromFirestore(snapshot.id, snapshot.data()!);
    }

    // Lazily create the profile document if it is missing (e.g. after a
    // project switch, or a deleted/never-created account) so the app
    // never gets stuck on "Profile not found".
    final defaults = <String, dynamic>{
      'email': null,
      'username': 'player_${userId.length >= 6 ? userId.substring(0, 6) : userId}',
      'displayName': null,
      'avatarUrl': null,
      'skillLevel': 'beginner',
      'positions': <String>[],
      'city': null,
      'lat': null,
      'lng': null,
      'gamesPlayed': 0,
      'gamesCreated': 0,
      'rating': 0.0,
      'isVerified': false,
      'createdAt': FieldValue.serverTimestamp(),
      'lastLoginAt': FieldValue.serverTimestamp(),
    };
    await doc.set(defaults);
    return ProfileModel.fromFirestore(userId, defaults);
  }

  Future<void> updateProfile(
    String userId, {
    required String displayName,
    required String city,
    required String skillLevel,
  }) {
    return _firestore.collection('users').doc(userId).update({
      'displayName': displayName,
      'city': city,
      'skillLevel': skillLevel,
    });
  }

  /// Re-syncs the cached `hostName` on every game the user hosts after
  /// they rename themselves in their profile.
  Future<void> updateGamesHostName(String userId, String displayName) async {
    final games = await _firestore
        .collection('games')
        .where('hostId', isEqualTo: userId)
        .get();
    if (games.docs.isEmpty) return;

    final batch = _firestore.batch();
    for (final doc in games.docs) {
      batch.update(doc.reference, {'hostName': displayName});
    }
    await batch.commit();
  }
}
