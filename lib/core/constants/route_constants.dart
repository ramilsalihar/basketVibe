class RouteConstants {
  RouteConstants._();

  // Auth routes
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Home routes
  static const String home = '/';
  static const String games = '/games';
  static const String courts = '/courts';
  static const String profile = '/profile';

  // Game routes
  static const String gameDetail = '/game/:id';
  static const String createGame = '/create-game';

  // Court routes
  static const String courtDetail = '/court/:id';

  // Profile routes
  static const String editProfile = '/edit-profile';
  static const String myGames = '/my-games';
}
