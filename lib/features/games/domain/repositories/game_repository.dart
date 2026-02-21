import 'package:dartz/dartz.dart';
import 'package:basketvibe/core/errors/failures.dart';
import 'package:basketvibe/features/games/domain/entities/game_entity.dart';

/// Repository interface for game lobby operations.
abstract class GameRepository {
  /// Get all active/open game lobbies.
  Future<Either<Failure, List<GameEntity>>> getActiveGames();

  /// Create a new game lobby.
  Future<Either<Failure, GameEntity>> createGame(GameEntity game);

  /// Join a game lobby (increment currentPlayers).
  Future<Either<Failure, GameEntity>> joinGame(String gameId, String playerId);

  /// Leave a game lobby (decrement currentPlayers).
  Future<Either<Failure, GameEntity>> leaveGame(String gameId, String playerId);

  /// Get a specific game by ID.
  Future<Either<Failure, GameEntity>> getGameById(String gameId);
}
