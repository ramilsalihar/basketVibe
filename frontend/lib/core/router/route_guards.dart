import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

/// Route guard to check authentication
class AuthGuard {
  /// Check if user is authenticated
  /// Returns true if authenticated, false otherwise
  static bool isAuthenticated() {
    return FirebaseAuth.instance.currentUser != null;
  }

  /// Redirect to login if not authenticated
  static void requireAuth(GoRouterState state) {
    if (!isAuthenticated()) {
      // TODO: Redirect to login page
      // state.go('/login');
    }
  }
}
