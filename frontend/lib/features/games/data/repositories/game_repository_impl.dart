import 'package:basketvibe/core/errors/exceptions.dart';
import 'package:basketvibe/core/errors/failures.dart';
import 'package:basketvibe/features/games/data/datasources/game_remote_datasource.dart';
import 'package:basketvibe/features/games/domain/entities/game_entity.dart';
import 'package:basketvibe/features/games/domain/entities/game_player_entity.dart';
import 'package:basketvibe/features/games/domain/repositories/game_repository.dart';
import 'package:dartz/dartz.dart';

/// Firestore-backed implementation of [GameRepository].
class GameRepositoryImpl implements GameRepository {
  GameRepositoryImpl(this._remoteDataSource);

  final GameRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, List<GameEntity>>> getActiveGames() =>
      _run(() => _remoteDataSource.getActiveGames());

  @override
  Stream<List<GameEntity>> watchActiveGames() =>
      _remoteDataSource.watchActiveGames();

  @override
  Stream<List<GameEntity>> watchMyGames(String uid) =>
      _remoteDataSource.watchMyGames(uid);

  @override
  Future<Either<Failure,
      ({List<GameEntity> games, bool hasMore, DateTime? nextCursor})>>
      getActiveGamesPage({
    GameStatus? status,
    String? city,
    GameLevel? level,
    DateTime? date,
    DateTime? startAfter,
    int pageSize = 20,
  }) =>
      _run(
        () => _remoteDataSource.getActiveGamesPage(
          status: status,
          city: city,
          level: level,
          date: date,
          startAfter: startAfter,
          pageSize: pageSize,
        ),
      );

  @override
  Future<Either<Failure, List<GameEntity>>> getMyGames(
    String uid, {
    String? role,
    String? status,
  }) =>
      _run(() => _remoteDataSource.getMyGames(uid, role: role, status: status));

  @override
  Future<Either<Failure, GameEntity>> createGame(GameEntity game) =>
      _run(() => _remoteDataSource.createGame(game));

  @override
  Future<Either<Failure, GameEntity>> joinGame(
    String gameId,
    String playerId,
  ) =>
      _run(() => _remoteDataSource.joinGame(gameId, playerId));

  @override
  Future<Either<Failure, GameEntity>> leaveGame(
    String gameId,
    String playerId,
  ) =>
      _run(() => _remoteDataSource.leaveGame(gameId, playerId));

  @override
  Future<Either<Failure, GameEntity>> cancelGame(
    String gameId,
    String requestingUid,
  ) =>
      _run(() => _remoteDataSource.cancelGame(gameId, requestingUid));

  @override
  Future<Either<Failure, List<GamePlayer>>> getPlayers(String gameId) =>
      _run(() => _remoteDataSource.getPlayers(gameId));

  @override
  Future<Either<Failure, GameEntity>> getGameById(String gameId) =>
      _run(() => _remoteDataSource.getGameById(gameId));

  Future<Either<Failure, T>> _run<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on ForbiddenException catch (e) {
      return Left(ForbiddenFailure(e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
