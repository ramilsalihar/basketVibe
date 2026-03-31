import 'package:go_router/go_router.dart';

/// Route guard to check authentication
class AuthGuard {
  /// Check if user is authenticated
  /// Returns true if authenticated, false otherwise
  static bool isAuthenticated() {
    // TODO: Implement actual auth check
    // This should check if user is logged in via auth repository/use case
    return false;
  }

  /// Redirect to login if not authenticated
  static void requireAuth(GoRouterState state) {
    if (!isAuthenticated()) {
      // TODO: Redirect to login page
      // state.go('/login');
    }
  }
}
