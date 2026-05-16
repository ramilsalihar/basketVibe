import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  AppConstants._();

  // App info
  static const String appName = 'LineUp';
  static const String appVersion = '1.0.0';

  // API
  static String get apiBaseUrl => dotenv.env['API_BASE_URL']!;

  // Google Sign-In
  static String? get googleServerClientId {
    final v = dotenv.env['GOOGLE_SERVER_CLIENT_ID'];
    return (v == null || v.startsWith('your-')) ? null : v;
  }

  static String? get googleIosClientId {
    final v = dotenv.env['GOOGLE_IOS_CLIENT_ID'];
    return (v == null || v.startsWith('your-')) ? null : v;
  }

  static String? get googleAndroidClientId {
    final v = dotenv.env['GOOGLE_ANDROID_CLIENT_ID'];
    return (v == null || v.startsWith('your-')) ? null : v;
  }

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
