import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:basketvibe/core/local_storage/local_storage_keys.dart';
import 'package:basketvibe/core/local_storage/local_storage_service.dart';
import 'package:basketvibe/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:basketvibe/features/auth/data/datasources/remote/google_sign_in_datasource.dart';
import 'package:basketvibe/features/auth/data/datasources/remote/user_remote_datasource.dart';
import 'package:basketvibe/features/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(
    this._localStorage,
    this._remoteDataSource,
    this._userDataSource,
    this._googleSignIn,
  ) : super(const AuthInitial()) {
    Future.microtask(() => checkAuthStatus());
  }

  final LocalStorageService _localStorage;
  final AuthRemoteDataSource _remoteDataSource;
  final UserRemoteDataSource _userDataSource;
  final GoogleSignInDatasource _googleSignIn;

  /// Firebase persists the session and refreshes tokens itself —
  /// a non-null currentUser means we are logged in.
  Future<void> checkAuthStatus() async {
    if (_remoteDataSource.currentUser != null) {
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

      await _userDataSource.ensureUserDocument(
        _remoteDataSource.currentUser!,
        isNew: result.user.isNew,
      );

      await _localStorage.setBool(LocalStorageKeys.isLoggedIn, true);
      await _localStorage.setString(LocalStorageKeys.userId, result.user.id);

      emit(AuthAuthenticated(isNewUser: result.user.isNew));
    } on Exception catch (e) {
      emit(AuthError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> logout() async {
    await Future.wait([
      _remoteDataSource.signOut(),
      _googleSignIn.signOut(),
      _localStorage.setBool(LocalStorageKeys.isLoggedIn, false),
      _localStorage.remove(LocalStorageKeys.userId),
    ]);
    emit(const AuthUnauthenticated());
  }
}
