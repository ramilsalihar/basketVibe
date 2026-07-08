import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:basketvibe/core/local_storage/local_storage_keys.dart';
import 'package:basketvibe/core/local_storage/local_storage_service.dart';
import 'package:basketvibe/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:basketvibe/features/auth/data/datasources/remote/google_sign_in_datasource.dart';
import 'package:basketvibe/features/auth/data/datasources/remote/user_remote_datasource.dart';
import 'package:basketvibe/features/auth/presentation/cubit/auth_state.dart';
import 'package:basketvibe/features/games/data/datasources/game_remote_datasource.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(
    this._localStorage,
    this._remoteDataSource,
    this._userDataSource,
    this._googleSignIn,
    this._gameDataSource,
  ) : super(const AuthInitial()) {
    Future.microtask(() => checkAuthStatus());
  }

  final LocalStorageService _localStorage;
  final AuthRemoteDataSource _remoteDataSource;
  final UserRemoteDataSource _userDataSource;
  final GoogleSignInDatasource _googleSignIn;
  final GameRemoteDataSource _gameDataSource;

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

  /// Deletes the user's account: re-authenticates (recent-login
  /// requirement), cleans up Firestore data (games + user doc) while
  /// still authenticated, then deletes the Firebase Auth user and clears
  /// the local session. Emits [AuthUnauthenticated] on success.
  Future<void> deleteAccount() async {
    final user = _remoteDataSource.currentUser;
    if (user == null) {
      emit(const AuthUnauthenticated());
      return;
    }

    emit(const AuthLoading());
    try {
      // 1. Get a fresh Google token; if the user cancels, abort before
      //    touching any data.
      final idToken = await _googleSignIn.signInAndGetIdToken();
      if (idToken == null) {
        emit(const AuthError('Sign-in cancelled'));
        return;
      }

      // 2. Clean up Firestore data while still authenticated.
      await _gameDataSource.deleteUserGames(user.uid);
      await _userDataSource.deleteUser(user.uid);

      // 3. Re-authenticate (recent-login) and delete the auth user.
      await _remoteDataSource.deleteAccount(idToken);

      // 4. Clear local session.
      await Future.wait([
        _localStorage.setBool(LocalStorageKeys.isLoggedIn, false),
        _localStorage.remove(LocalStorageKeys.userId),
        _googleSignIn.signOut(),
      ]);
      emit(const AuthUnauthenticated());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(_authErrorMessage(e)));
    } on Exception catch (e) {
      emit(AuthError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  String _authErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'requires-recent-login':
        return 'Please sign in again and retry deleting your account';
      case 'network-request-failed':
        return 'No internet connection';
      default:
        return e.message ?? 'Failed to delete account (${e.code})';
    }
  }
}
