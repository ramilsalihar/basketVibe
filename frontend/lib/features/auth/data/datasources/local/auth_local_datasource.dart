import 'package:basketvibe/core/services/secure_token_storage.dart';

class AuthLocalDataSource {
  const AuthLocalDataSource(this._tokenStorage);

  final SecureTokenStorage _tokenStorage;

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) =>
      _tokenStorage.saveTokens(access: accessToken, refresh: refreshToken);

  Future<String?> getAccessToken() => _tokenStorage.getAccessToken();

  Future<String?> getRefreshToken() => _tokenStorage.getRefreshToken();

  Future<void> clearTokens() => _tokenStorage.clearTokens();

  /// Returns true if both access and refresh tokens are present.
  Future<bool> isUserLoggedIn() async {
    final access = await _tokenStorage.getAccessToken();
    final refresh = await _tokenStorage.getRefreshToken();
    return (access != null && access.isNotEmpty) &&
        (refresh != null && refresh.isNotEmpty);
  }

  /// Returns true if a refresh token exists (access may be expired).
  Future<bool> hasRefreshToken() async {
    final refresh = await _tokenStorage.getRefreshToken();
    return refresh != null && refresh.isNotEmpty;
  }
}
