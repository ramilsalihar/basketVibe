import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:basketvibe/core/local_storage/local_storage_keys.dart';
import 'package:basketvibe/core/local_storage/local_storage_service.dart';
import 'package:basketvibe/features/auth/presentation/cubit/auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._localStorage) : super(const AuthInitial()) {
    Future.microtask(() => checkAuthStatus());
  }

  final LocalStorageService _localStorage;

  Future<void> checkAuthStatus() async {
    final isLoggedIn = await _localStorage.getBool(
      LocalStorageKeys.isLoggedIn,
      defaultValue: false,
    );
    if (isLoggedIn) {
      emit(const AuthAuthenticated());
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> login() async {
    await _localStorage.setBool(LocalStorageKeys.isLoggedIn, true);
    emit(const AuthAuthenticated());
  }

  Future<void> logout() async {
    await _localStorage.setBool(LocalStorageKeys.isLoggedIn, false);
    emit(const AuthUnauthenticated());
  }
}
