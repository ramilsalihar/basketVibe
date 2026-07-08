import 'package:equatable/equatable.dart';
import 'package:basketvibe/features/games/domain/entities/game_entity.dart';
import 'package:basketvibe/features/games/domain/entities/game_player_entity.dart';

sealed class GameState extends Equatable {
  const GameState();

  @override
  List<Object?> get props => [];
}

class GameInitial extends GameState {
  const GameInitial();
}

class GameLoading extends GameState {
  const GameLoading();
}

class GameLoaded extends GameState {
  const GameLoaded({
    required this.games,
    this.hasMore = false,
    this.nextCursor,
  });

  final List<GameEntity> games;

  /// Whether another page is available (pagination support).
  final bool hasMore;

  /// Cursor for the next page (last game's `startTime`), or `null`.
  final DateTime? nextCursor;

  @override
  List<Object?> get props => [games, hasMore, nextCursor];
}

class GameCreated extends GameState {
  const GameCreated({required this.game});

  final GameEntity game;

  @override
  List<Object?> get props => [game];
}

class GameCancelled extends GameState {
  const GameCancelled({required this.game});

  final GameEntity game;

  @override
  List<Object?> get props => [game];
}

class GamePlayersLoaded extends GameState {
  const GamePlayersLoaded({required this.players});

  final List<GamePlayer> players;

  @override
  List<Object?> get props => [players];
}

class GameError extends GameState {
  const GameError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Transient success feedback for actions like join/leave/cancel.
/// Carries the latest games list so the UI doesn't flicker to empty
/// before the realtime stream re-emits.
class GameActionSuccess extends GameState {
  const GameActionSuccess({
    required this.message,
    required this.games,
  });

  final String message;
  final List<GameEntity> games;

  @override
  List<Object?> get props => [message, games];
}
