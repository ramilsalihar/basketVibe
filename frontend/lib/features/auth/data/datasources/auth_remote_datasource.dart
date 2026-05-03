import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:basketvibe/core/constants/app_constants.dart';
import 'package:basketvibe/features/auth/data/models/auth_user_model.dart';

class GoogleLoginResponse {
  final String access;
  final String refresh;
  final AuthUserModel user;

  const GoogleLoginResponse({
    required this.access,
    required this.refresh,
    required this.user,
  });
}

@lazySingleton
class AuthRemoteDataSource {
  Future<GoogleLoginResponse> googleLogin(String idToken) async {
    final response = await http
        .post(
          Uri.parse('${AppConstants.apiBaseUrl}/auth/google/'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'id_token': idToken}),
        )
        .timeout(AppConstants.networkTimeout);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return GoogleLoginResponse(
        access: data['access'] as String,
        refresh: data['refresh'] as String,
        user: AuthUserModel.fromJson(data['user'] as Map<String, dynamic>),
      );
    } else if (response.statusCode == 401) {
      throw Exception('Invalid or expired Google token');
    } else {
      throw Exception('Login failed (${response.statusCode})');
    }
  }
}
