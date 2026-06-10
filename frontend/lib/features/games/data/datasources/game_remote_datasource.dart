import 'package:basketvibe/core/errors/exceptions.dart';
import 'package:basketvibe/features/games/data/models/game_model.dart';
import 'package:basketvibe/features/games/domain/entities/game_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore access for the `games` collection.
class GameRemoteDataSource {
  GameRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _games =>
      _firestore.collection('games');

  /// Open, public games that haven't started yet, soonest first.
  ///
  /// Note: this query needs a composite index (status + startTime);
  /// Firestore logs a creation link on first run.
  Future<List<GameEntity>> getActiveGames() async {
    final snapshot = await _games
        .where('status', isEqualTo: GameStatus.open.name)
        .where('startTime', isGreaterThan: Timestamp.now())
        .orderBy('startTime')
        .get();

    return snapshot.docs.map(GameModel.fromFirestore).toList();
  }

  /// Creates the game document; the host is the first player.
  Future<GameEntity> createGame(GameEntity game) async {
    final doc = _games.doc();
    await doc.set(
      GameModel.toFirestore(
        game.copyWith(status: GameStatus.open),
        playerIds: [game.hostId],
      ),
    );

    final created = await doc.get();
    return GameModel.fromFirestore(created);
  }

  /// Adds [playerId] inside a transaction so capacity can't be exceeded
  /// by concurrent joins.
  Future<GameEntity> joinGame(String gameId, String playerId) async {
    return _firestore.runTransaction((transaction) async {
      final ref = _games.doc(gameId);
      final snapshot = await transaction.get(ref);
      if (!snapshot.exists) {
        throw const NotFoundException('Game not found');
      }

      final game = GameModel.fromFirestore(snapshot);
      final playerIds = (snapshot.data()!['playerIds'] as List<dynamic>)
          .cast<String>();

      if (playerIds.contains(playerId)) {
        return game;
      }
      if (game.status != GameStatus.open) {
        throw const ValidationException('Game is not open for joining');
      }
      if (playerIds.length >= game.maxPlayers) {
        throw const ValidationException('Game is full');
      }

      final updated = [...playerIds, playerId];
      transaction.update(ref, {
        'playerIds': updated,
        if (updated.length >= game.maxPlayers)
          'status': GameStatus.full.name,
      });

      return game.copyWith(
        currentPlayers: updated.length,
        status: updated.length >= game.maxPlayers
            ? GameStatus.full
            : game.status,
      );
    });
  }

  /// Removes [playerId]; reopens a full game. Host cannot leave.
  Future<GameEntity> leaveGame(String gameId, String playerId) async {
    return _firestore.runTransaction((transaction) async {
      final ref = _games.doc(gameId);
      final snapshot = await transaction.get(ref);
      if (!snapshot.exists) {
        throw const NotFoundException('Game not found');
      }

      final game = GameModel.fromFirestore(snapshot);
      if (playerId == game.hostId) {
        throw const ValidationException('Cannot leave: host must remain');
      }

      final playerIds = (snapshot.data()!['playerIds'] as List<dynamic>)
          .cast<String>();
      final updated = playerIds.where((id) => id != playerId).toList();

      transaction.update(ref, {
        'playerIds': updated,
        if (game.status == GameStatus.full) 'status': GameStatus.open.name,
      });

      return game.copyWith(
        currentPlayers: updated.length,
        status: game.status == GameStatus.full ? GameStatus.open : game.status,
      );
    });
  }

  Future<GameEntity> getGameById(String gameId) async {
    final snapshot = await _games.doc(gameId).get();
    if (!snapshot.exists) {
      throw const NotFoundException('Game not found');
    }
    return GameModel.fromFirestore(snapshot);
  }
}
