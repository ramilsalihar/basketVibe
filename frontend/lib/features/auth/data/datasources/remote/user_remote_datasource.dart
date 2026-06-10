import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Manages the `users/{uid}` document in Firestore.
///
/// Schema follows commands/DOMAIN_MODELS.md (UserEntity).
class UserRemoteDataSource {
  final FirebaseFirestore _firestore;

  UserRemoteDataSource(this._firestore);

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  /// Creates the user document on first sign-in, otherwise updates
  /// last-login. Document id is the Firebase Auth uid.
  Future<void> ensureUserDocument(User user, {required bool isNew}) async {
    final doc = _users.doc(user.uid);

    if (!isNew && (await doc.get()).exists) {
      await doc.update({'lastLoginAt': FieldValue.serverTimestamp()});
      return;
    }

    await doc.set({
      'email': user.email,
      'username': _defaultUsername(user),
      'displayName': user.displayName,
      'avatarUrl': user.photoURL,
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
    });
  }

  Future<Map<String, dynamic>?> getUser(String uid) async {
    final snapshot = await _users.doc(uid).get();
    return snapshot.data();
  }

  /// Username defaults to the email local part; user can edit it in profile.
  String _defaultUsername(User user) {
    final email = user.email;
    if (email != null && email.contains('@')) {
      return email.split('@').first;
    }
    return 'player_${user.uid.substring(0, 6)}';
  }
}
