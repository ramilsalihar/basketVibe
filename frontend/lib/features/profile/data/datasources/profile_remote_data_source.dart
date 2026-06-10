import 'package:basketvibe/core/errors/exceptions.dart';
import 'package:basketvibe/features/profile/data/models/profile_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Reads profile data from the `users/{userId}` Firestore document
/// (created by UserRemoteDataSource on first sign-in).
class ProfileRemoteDataSource {
  const ProfileRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  Future<ProfileModel> getProfile(String userId) async {
    final snapshot =
        await _firestore.collection('users').doc(userId).get();
    final data = snapshot.data();
    if (data == null) {
      throw const NotFoundException('Profile not found');
    }
    return ProfileModel.fromFirestore(snapshot.id, data);
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
}
