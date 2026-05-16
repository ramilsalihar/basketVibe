import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:basketvibe/core/constants/app_constants.dart';

class GoogleSignInDatasource {
  late final GoogleSignIn _client;

  GoogleSignInDatasource() {
    _client = GoogleSignIn(
      scopes: ['email', 'profile'],
      clientId: AppConstants.googleIosClientId,
      serverClientId: AppConstants.googleServerClientId,
    );
  }

  /// Returns null if user cancels sign-in.
  Future<String?> signInAndGetIdToken() async {
    try {
      final googleUser = await _client.signIn();
      if (googleUser == null) return null;

      final auth = await googleUser.authentication;
      final idToken = auth.idToken;
      if (idToken == null) throw Exception('Failed to get Google ID token');
      return idToken;
    } on PlatformException catch (e) {
      final code = e.code;
      if (code == 'sign_in_canceled' || code == 'sign_in_cancelled') {
        return null;
      }
      if (code == 'network_error') throw Exception('No internet connection');
      throw Exception(e.message ?? 'Google sign-in failed');
    }
  }

  Future<void> signOut() => _client.signOut();
}
