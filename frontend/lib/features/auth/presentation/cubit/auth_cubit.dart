import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:basketvibe/core/local_storage/local_storage_keys.dart';
import 'package:basketvibe/core/local_storage/local_storage_service.dart';
import 'package:basketvibe/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:basketvibe/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:basketvibe/features/auth/data/datasources/remote/google_sign_in_datasource.dart';
import 'package:basketvibe/features/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(
    this._localStorage,
    this._localDataSource,
    this._remoteDataSource,
    this._googleSignIn,
  ) : super(const AuthInitial()) {
    Future.microtask(() => checkAuthStatus());
  }

  final LocalStorageService _localStorage;
  final AuthLocalDataSource _localDataSource;
  final AuthRemoteDataSource _remoteDataSource;
  final GoogleSignInDatasource _googleSignIn;

  Future<void> checkAuthStatus() async {
    try {
      final loggedIn = await _localDataSource.isUserLoggedIn();

      if (loggedIn) {
        emit(const AuthAuthenticated(isNewUser: false));
        return;
      }

      // Access token missing but refresh token present — try silent refresh
      final hasRefresh = await _localDataSource.hasRefreshToken();
      if (hasRefresh) {
        final refreshToken = await _localDataSource.getRefreshToken();
        final result = await _remoteDataSource.refreshToken(refreshToken!);
        final currentRefresh = await _localDataSource.getRefreshToken();
        await _localDataSource.saveTokens(
          accessToken: result.access,
          refreshToken: currentRefresh!,
        );
        emit(const AuthAuthenticated(isNewUser: false));
        return;
      }

      emit(const AuthUnauthenticated());
    } on Exception {
      await _localDataSource.clearTokens();
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> googleSignIn() async {
    try {
      emit(const AuthLoading());

      final idToken = await _googleSignIn.signInAndGetIdToken();
      if (idToken == null) {
        emit(const AuthUnauthenticated());
        return;
      }

      final result = await _remoteDataSource.googleSignIn(idToken);

      await _localDataSource.saveTokens(
        accessToken: result.access,
        refreshToken: result.refresh,
      );
      await _localStorage.setBool(LocalStorageKeys.isLoggedIn, true);
      await _localStorage.setString(
        LocalStorageKeys.userId,
        result.user.id.toString(),
      );

      emit(AuthAuthenticated(isNewUser: result.user.isNew));
    } on Exception catch (e) {
      emit(AuthError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> logout() async {
    await Future.wait([
      _googleSignIn.signOut(),
      _localDataSource.clearTokens(),
      _localStorage.setBool(LocalStorageKeys.isLoggedIn, false),
      _localStorage.remove(LocalStorageKeys.userId),
    ]);
    emit(const AuthUnauthenticated());
  }
}
