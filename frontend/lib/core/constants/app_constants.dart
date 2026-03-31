class AppConstants {
  AppConstants._();

  // App info
  static const String appName = 'BasketVibe';
  static const String appVersion = '1.0.0';

  // Default values
  static const int defaultMaxPlayers = 10;
  static const int defaultMinPlayers = 4;
  static const int defaultGameDurationMinutes = 60;
  static const double defaultSearchRadiusKm = 10.0;

  // Pagination
  static const int defaultPageSize = 20;

  // Timeouts
  static const Duration networkTimeout = Duration(seconds: 30);
  static const Duration cacheTimeout = Duration(hours: 1);
}
