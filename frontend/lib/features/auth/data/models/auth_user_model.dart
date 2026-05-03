class AuthUserModel {
  final int id;
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

  factory AuthUserModel.fromJson(Map<String, dynamic> json) => AuthUserModel(
        id: json['id'] as int,
        email: json['email'] as String,
        name: json['name'] as String,
        avatarUrl: json['avatar_url'] as String?,
        isNew: json['is_new'] as bool,
      );
}
