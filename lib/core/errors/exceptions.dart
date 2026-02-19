/// Base exception class
class AppException implements Exception {
  final String message;
  const AppException(this.message);
  
  @override
  String toString() => message;
}

/// Server exceptions
class ServerException extends AppException {
  const ServerException([super.message = 'Server error occurred']);
}

/// Network exceptions
class NetworkException extends AppException {
  const NetworkException([super.message = 'Network error occurred']);
}

/// Cache exceptions
class CacheException extends AppException {
  const CacheException([super.message = 'Cache error occurred']);
}

/// Authentication exceptions
class AuthException extends AppException {
  const AuthException([super.message = 'Authentication error occurred']);
}

/// Validation exceptions
class ValidationException extends AppException {
  const ValidationException([super.message = 'Validation error occurred']);
}
