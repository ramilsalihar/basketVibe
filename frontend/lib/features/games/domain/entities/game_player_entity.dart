import 'package:equatable/equatable.dart';

/// A player participating in a game lobby.
///
/// Maps the backend `GET /games/{id}/players/` response: a resolved user
/// profile plus the moment they joined the lobby.
class GamePlayer extends Equatable {
  const GamePlayer({
    required this.userId,
    this.displayName,
    this.avatarUrl,
    this.skillLevel,
    this.joinedAt,
  });

  /// Firebase Auth uid, mapped from backend `user_id`.
  final String userId;

  /// Mapped from backend `display_name`.
  final String? displayName;

  /// Mapped from backend `avatar_url`.
  final String? avatarUrl;

  /// Mapped from backend `skill_level` (e.g. `beginner`, `intermediate`).
  final String? skillLevel;

  /// Mapped from backend `joined_at`.
  final DateTime? joinedAt;

  @override
  List<Object?> get props => [
        userId,
        displayName,
        avatarUrl,
        skillLevel,
        joinedAt,
      ];
}
