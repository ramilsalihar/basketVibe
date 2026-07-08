import 'package:dartz/dartz.dart';
import 'package:basketvibe/core/errors/failures.dart';
import 'package:basketvibe/features/games/domain/entities/game_entity.dart';
import 'package:basketvibe/features/games/domain/entities/game_player_entity.dart';

/// Repository interface for game lobby operations.
abstract class GameRepository {
  /// Get all active/open game lobbies.
  Future<Either<Failure, List<GameEntity>>> getActiveGames();

  /// Realtime stream of open, public, upcoming games.
  Stream<List<GameEntity>> watchActiveGames();

  /// Realtime stream of games the user hosts or has joined.
  Stream<List<GameEntity>> watchMyGames(String uid);

  /// Paginated, one-shot list of active games.
  ///
  /// [startAfter] is the cursor from the previous page's `nextCursor`.
  Future<Either<Failure,
      ({List<GameEntity> games, bool hasMore, DateTime? nextCursor})>>
      getActiveGamesPage({
    GameStatus? status,
    String? city,
    GameLevel? level,
    DateTime? date,
    DateTime? startAfter,
    int pageSize = 20,
  });

  /// One-shot list of the current user's games, optionally filtered.
  Future<Either<Failure, List<GameEntity>>> getMyGames(
    String uid, {
    String? role,
    String? status,
  });

  /// Create a new game lobby.
  Future<Either<Failure, GameEntity>> createGame(GameEntity game);

  /// Join a game lobby (increment currentPlayers).
  Future<Either<Failure, GameEntity>> joinGame(String gameId, String playerId);

  /// Leave a game lobby (decrement currentPlayers).
  Future<Either<Failure, GameEntity>> leaveGame(String gameId, String playerId);

  /// Host-only: cancel a game (status = cancelled).
  Future<Either<Failure, GameEntity>> cancelGame(
    String gameId,
    String requestingUid,
  );

  /// Get the players of a game with their profiles.
  Future<Either<Failure, List<GamePlayer>>> getPlayers(String gameId);

  /// Get a specific game by ID.
  Future<Either<Failure, GameEntity>> getGameById(String gameId);
}
