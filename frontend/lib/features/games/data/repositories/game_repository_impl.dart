import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';
import 'package:basketvibe/core/errors/failures.dart';
import 'package:basketvibe/features/games/domain/entities/game_entity.dart';
import 'package:basketvibe/features/games/domain/repositories/game_repository.dart';

/// In-memory implementation of GameRepository.
/// TODO: Replace with Firestore implementation when backend is ready.
class GameRepositoryImpl implements GameRepository {
  GameRepositoryImpl() : _games = [] {
    // Initialize with some mock data
    _games.addAll([
      GameEntity(
        id: const Uuid().v4(),
        courtId: 'court_1',
        courtName: 'Восток-5',
        city: 'Бишкек',
        address: 'ул. Восток-5',
        hostId: 'host_1',
        hostName: 'Алмаз К.',
        startTime: DateTime.now().add(const Duration(hours: 2)),
        duration: const Duration(hours: 2),
        maxPlayers: 10,
        currentPlayers: 3,
        visibility: GameVisibility.public,
        level: GameLevel.balanced,
        status: GameStatus.open,
        description: '3x3, intermediate',
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      GameEntity(
        id: const Uuid().v4(),
        courtId: 'court_2',
        courtName: 'Бишкек Арена',
        city: 'Бишкек',
        address: 'ул. Бишкек Арена',
        hostId: 'host_2',
        hostName: 'Бектур М.',
        startTime: DateTime.now().add(const Duration(hours: 3)),
        duration: const Duration(hours: 2),
        maxPlayers: 10,
        currentPlayers: 5,
        visibility: GameVisibility.public,
        level: GameLevel.competitive,
        status: GameStatus.open,
        description: '5v5 full court',
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
      GameEntity(
        id: const Uuid().v4(),
        courtId: 'court_3',
        courtName: 'Спартак',
        city: 'Бишкек',
        address: 'ул. Спартак',
        hostId: 'host_3',
        hostName: 'Нурлан С.',
        startTime: DateTime.now().add(const Duration(hours: 4)),
        duration: const Duration(hours: 2),
        maxPlayers: 10,
        currentPlayers: 7,
        visibility: GameVisibility.public,
        level: GameLevel.casual,
        status: GameStatus.open,
        createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
      ),
    ]);
  }

  final List<GameEntity> _games;

  @override
  Future<Either<Failure, List<GameEntity>>> getActiveGames() async {
    try {
      // Return only open games that haven't started yet
      final now = DateTime.now();
      final activeGames = _games
          .where((game) =>
              game.status == GameStatus.open &&
              game.startTime.isAfter(now))
          .toList()
        ..sort((a, b) => a.startTime.compareTo(b.startTime));
      return Right(activeGames);
    } catch (e) {
      return Left(ServerFailure('Failed to load active games: $e'));
    }
  }

  @override
  Future<Either<Failure, GameEntity>> createGame(GameEntity game) async {
    try {
      final newGame = game.copyWith(
        id: const Uuid().v4(),
        createdAt: DateTime.now(),
        status: GameStatus.open,
        currentPlayers: 1, // Host is automatically included
      );
      _games.add(newGame);
      return Right(newGame);
    } catch (e) {
      return Left(ServerFailure('Failed to create game: $e'));
    }
  }

  @override
  Future<Either<Failure, GameEntity>> joinGame(
    String gameId,
    String playerId,
  ) async {
    try {
      final index = _games.indexWhere((g) => g.id == gameId);
      if (index == -1) {
        return Left(NotFoundFailure('Game not found'));
      }

      final game = _games[index];
      if (game.isFull) {
        return Left(ValidationFailure('Game is full'));
      }

      if (game.status != GameStatus.open) {
        return Left(ValidationFailure('Game is not open for joining'));
      }

      final updatedGame = game.copyWith(
        currentPlayers: game.currentPlayers + 1,
        status: (game.currentPlayers + 1 >= game.maxPlayers)
            ? GameStatus.full
            : game.status,
      );
      _games[index] = updatedGame;
      return Right(updatedGame);
    } catch (e) {
      return Left(ServerFailure('Failed to join game: $e'));
    }
  }

  @override
  Future<Either<Failure, GameEntity>> leaveGame(
    String gameId,
    String playerId,
  ) async {
    try {
      final index = _games.indexWhere((g) => g.id == gameId);
      if (index == -1) {
        return Left(NotFoundFailure('Game not found'));
      }

      final game = _games[index];
      if (game.currentPlayers <= 1) {
        return Left(ValidationFailure('Cannot leave: host must remain'));
      }

      final updatedGame = game.copyWith(
        currentPlayers: game.currentPlayers - 1,
        status: GameStatus.open, // Reopen if it was full
      );
      _games[index] = updatedGame;
      return Right(updatedGame);
    } catch (e) {
      return Left(ServerFailure('Failed to leave game: $e'));
    }
  }

  @override
  Future<Either<Failure, GameEntity>> getGameById(String gameId) async {
    try {
      final game = _games.firstWhere(
        (g) => g.id == gameId,
        orElse: () => throw Exception('Game not found'),
      );
      return Right(game);
    } catch (e) {
      return Left(NotFoundFailure('Game not found'));
    }
  }
}
