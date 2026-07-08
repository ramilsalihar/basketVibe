import 'package:basketvibe/features/auth/data/models/auth_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoogleLoginResponse {
  final AuthUserModel user;

  const GoogleLoginResponse({required this.user});
}

class AuthRemoteDataSource {
  final FirebaseAuth _auth;

  AuthRemoteDataSource(this._auth);

  /// Currently signed-in Firebase user, or null.
  User? get currentUser => _auth.currentUser;

  /// Emits on sign-in/sign-out.
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  /// Exchanges a Google ID token for a Firebase session.
  Future<GoogleLoginResponse> googleSignIn(String idToken) async {
    try {
      final credential = GoogleAuthProvider.credential(idToken: idToken);
      final userCredential = await _auth.signInWithCredential(credential);

      final user = userCredential.user;
      if (user == null) {
        throw Exception('Firebase sign-in returned no user');
      }

      return GoogleLoginResponse(
        user: AuthUserModel.fromFirebaseUser(
          user,
          isNew: userCredential.additionalUserInfo?.isNewUser ?? false,
        ),
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-credential':
          throw Exception('Invalid or expired Google token');
        case 'user-disabled':
          throw Exception('This account has been disabled');
        case 'network-request-failed':
          throw Exception('No internet connection');
        default:
          throw Exception(e.message ?? 'Login failed (${e.code})');
      }
    }
  }

  Future<void> signOut() => _auth.signOut();

  /// Re-authenticates the current user with a fresh Google ID token (to
  /// satisfy Firebase's recent-login requirement) and then permanently
  /// deletes the Firebase Auth user.
  Future<void> deleteAccount(String idToken) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No authenticated user to delete');
    }
    final credential = GoogleAuthProvider.credential(idToken: idToken);
    await user.reauthenticateWithCredential(credential);
    await user.delete();
  }
}
