import 'package:equatable/equatable.dart';

/// Base sealed class for all failures in the app
sealed class Failure extends Equatable {
  final String message;
  
  const Failure(this.message);
  
  @override
  List<Object?> get props => [message];
}

/// Server/API related failures
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error occurred']);
}

/// Network connectivity failures
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

/// Cache/local storage failures
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error occurred']);
}

/// Authentication failures
class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed']);
}

/// Resource not found failures
class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Resource not found']);
}

/// Validation failures
class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Validation failed']);
}

/// Permission failures (e.g., location, camera)
class PermissionFailure extends Failure {
  const PermissionFailure([super.message = 'Permission denied']);
}

/// Extension to get user-friendly messages
extension FailureMessage on Failure {
  String get userMessage => switch (this) {
    NetworkFailure() => 'No internet connection. Please try again.',
    ServerFailure(:final message) => message.isNotEmpty ? message : 'Something went wrong. Please try again.',
    AuthFailure(:final message) => message.isNotEmpty ? message : 'Authentication failed. Please try again.',
    NotFoundFailure(:final message) => message.isNotEmpty ? message : 'Resource not found.',
    ValidationFailure(:final message) => message.isNotEmpty ? message : 'Please check your input and try again.',
    PermissionFailure(:final message) => message.isNotEmpty ? message : 'Permission denied. Please enable in settings.',
    CacheFailure(:final message) => message.isNotEmpty ? message : 'Storage error occurred.',
    _ => 'An unexpected error occurred.',
  };
}
