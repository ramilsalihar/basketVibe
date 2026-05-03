import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:basketvibe/core/local_storage/local_storage_keys.dart';
import 'package:basketvibe/core/local_storage/local_storage_service.dart';
import 'package:basketvibe/core/services/secure_token_storage.dart';
import 'package:basketvibe/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:basketvibe/features/auth/presentation/cubit/auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._localStorage, this._tokenStorage, this._remoteDataSource)
      : super(const AuthInitial()) {
    Future.microtask(() => checkAuthStatus());
  }

  final LocalStorageService _localStorage;
  final SecureTokenStorage _tokenStorage;
  final AuthRemoteDataSource _remoteDataSource;

  final _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  Future<void> checkAuthStatus() async {
    final isLoggedIn = await _localStorage.getBool(
      LocalStorageKeys.isLoggedIn,
      defaultValue: false,
    );
    if (isLoggedIn) {
      emit(const AuthAuthenticated(isNewUser: false));
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> googleSignIn() async {
    try {
      emit(const AuthLoading());

      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User cancelled the sign-in dialog
        emit(const AuthUnauthenticated());
        return;
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null) {
        emit(const AuthError('Failed to get Google ID token'));
        return;
      }

      final result = await _remoteDataSource.googleLogin(idToken);

      await _tokenStorage.saveTokens(
        access: result.access,
        refresh: result.refresh,
      );
      await _localStorage.setBool(LocalStorageKeys.isLoggedIn, true);
      await _localStorage.setString(
        LocalStorageKeys.userId,
        result.user.id.toString(),
      );

      emit(AuthAuthenticated(isNewUser: result.user.isNew));
    } on PlatformException catch (e) {
      final code = e.code;
      if (code == 'sign_in_canceled' || code == 'sign_in_cancelled') {
        emit(const AuthUnauthenticated());
      } else if (code == 'network_error') {
        emit(const AuthError('No internet connection'));
      } else {
        emit(AuthError(e.message ?? 'Google sign-in failed'));
      }
    } on Exception catch (e) {
      emit(AuthError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> logout() async {
    await _googleSignIn.signOut();
    await _tokenStorage.clearTokens();
    await _localStorage.setBool(LocalStorageKeys.isLoggedIn, false);
    emit(const AuthUnauthenticated());
  }
}
