import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:basketvibe/core/local_storage/local_storage_keys.dart';
import 'package:basketvibe/core/local_storage/local_storage_service.dart';
import 'package:basketvibe/core/services/secure_token_storage.dart';
import 'package:basketvibe/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:basketvibe/features/auth/data/datasources/google_sign_in_datasource.dart';
import 'package:basketvibe/features/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(
    this._localStorage,
    this._tokenStorage,
    this._remoteDataSource,
    this._googleSignIn,
  ) : super(const AuthInitial()) {
    Future.microtask(() => checkAuthStatus());
  }

  final LocalStorageService _localStorage;
  final SecureTokenStorage _tokenStorage;
  final AuthRemoteDataSource _remoteDataSource;
  final GoogleSignInDatasource _googleSignIn;

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

      final idToken = await _googleSignIn.signInAndGetIdToken();
      if (idToken == null) {
        emit(const AuthUnauthenticated());
        return;
      }

      final result = await _remoteDataSource.googleSignIn(idToken);

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
