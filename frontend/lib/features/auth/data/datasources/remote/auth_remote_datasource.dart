import 'package:basketvibe/features/auth/data/models/auth_user_model.dart';
import 'package:dio/dio.dart';

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

class RefreshTokenResponse {
  final String access;

  const RefreshTokenResponse({required this.access});
}

class AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSource(this._dio);

  Future<GoogleLoginResponse> googleSignIn(String idToken) async {
    try {
      final response = await _dio.post(
        '/auth/google/',
        data: {'id_token': idToken},
      );
      final data = response.data as Map<String, dynamic>;
      return GoogleLoginResponse(
        access: data['access'] as String,
        refresh: data['refresh'] as String,
        user: AuthUserModel.fromJson(data['user'] as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Invalid or expired Google token');
      }
      throw Exception(
        'Login failed (${e.response?.statusCode ?? 'no response'})',
      );
    }
  }

  Future<RefreshTokenResponse> refreshToken(String refreshToken) async {
    try {
      final response = await _dio.post(
        '/auth/token/refresh/',
        data: {'refresh': refreshToken},
      );
      final data = response.data as Map<String, dynamic>;
      return RefreshTokenResponse(access: data['access'] as String);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Refresh token expired');
      }
      throw Exception(
        'Token refresh failed (${e.response?.statusCode ?? 'no response'})',
      );
    }
  }
}
