import 'package:firebase_auth/firebase_auth.dart';

class AuthUserModel {
  final String id;
  final String email;
  final String name;
  final String? avatarUrl;
  final bool isNew;

  const AuthUserModel({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl,
    required this.isNew,
  });

  factory AuthUserModel.fromFirebaseUser(User user, {required bool isNew}) =>
      AuthUserModel(
        id: user.uid,
        email: user.email ?? '',
        name: user.displayName ?? '',
        avatarUrl: user.photoURL,
        isNew: isNew,
      );
}
