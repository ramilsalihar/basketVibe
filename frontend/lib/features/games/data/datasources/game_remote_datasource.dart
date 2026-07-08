import 'package:basketvibe/core/errors/exceptions.dart';
import 'package:basketvibe/features/games/data/models/game_model.dart';
import 'package:basketvibe/features/games/domain/entities/game_entity.dart';
import 'package:basketvibe/features/games/domain/entities/game_player_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore access for the `games` collection.
class GameRemoteDataSource {
  GameRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _games =>
      _firestore.collection('games');

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

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

  /// Realtime stream of open, public games that haven't ended yet
  /// (soonest first). A game stays visible until start + duration passes.
  Stream<List<GameEntity>> watchActiveGames() {
    return _games
        .where('visibility', isEqualTo: GameVisibility.public.name)
        .where('status', isEqualTo: GameStatus.open.name)
        .orderBy('startTime')
        .snapshots()
        .map((snapshot) {
      final now = DateTime.now();
      return snapshot.docs
          .map(GameModel.fromFirestore)
          .where((g) => g.endTime.isAfter(now))
          .toList();
    });
  }

  /// Realtime stream of games the user hosts or has joined, newest first.
  Stream<List<GameEntity>> watchMyGames(String uid) {
    return _games
        .where('playerIds', arrayContains: uid)
        .snapshots()
        .map((snapshot) {
      final games = snapshot.docs.map(GameModel.fromFirestore).toList()
        ..sort((a, b) => b.startTime.compareTo(a.startTime));
      return games;
    });
  }

  /// One-shot, paginated list of active games.
  ///
  /// Mirrors `GET /games/?status=&city=&level=&date=&page=&page_size=`.
  /// [startAfter] is the cursor (last game's `startTime`) for the next page.
  /// Returns the page of games plus whether more pages exist.
  Future<({List<GameEntity> games, bool hasMore, DateTime? nextCursor})>
      getActiveGamesPage({
    GameStatus? status,
    String? city,
    GameLevel? level,
    DateTime? date,
    DateTime? startAfter,
    int pageSize = 20,
  }) async {
    Query<Map<String, dynamic>> query = _games;

    if (status != null) {
      query = query.where('status', isEqualTo: status.name);
    }
    if (city != null) {
      query = query.where('city', isEqualTo: city);
    }
    if (level != null) {
      query = query.where('level', isEqualTo: level.name);
    }
    if (date != null) {
      final dayStart = DateTime(date.year, date.month, date.day);
      final dayEnd = dayStart.add(const Duration(days: 1));
      query = query
          .where('startTime',
              isGreaterThanOrEqualTo: Timestamp.fromDate(dayStart))
          .where('startTime', isLessThan: Timestamp.fromDate(dayEnd));
    }

    query = query.orderBy('startTime');
    if (startAfter != null) {
      query = query.startAfter([Timestamp.fromDate(startAfter)]);
    }
    query = query.limit(pageSize + 1);

    final snapshot = await query.get();
    final docs = snapshot.docs;
    final hasMore = docs.length > pageSize;
    final pageDocs = hasMore ? docs.take(pageSize).toList() : docs;
    final games = pageDocs.map(GameModel.fromFirestore).toList();
    final nextCursor = hasMore ? games.last.startTime : null;

    return (games: games, hasMore: hasMore, nextCursor: nextCursor);
  }

  /// One-shot list of the current user's games, filtered by role/status.
  ///
  /// Mirrors `GET /games/my/?role=&status=`. Role filters (`host`/`player`)
  /// and status filters (`upcoming`/`completed`/`cancelled`) are applied in
  /// Dart to avoid composite-index requirements on a personal list.
  Future<List<GameEntity>> getMyGames(
    String uid, {
    String? role,
    String? status,
  }) async {
    final snapshot =
        await _games.where('playerIds', arrayContains: uid).get();

    var games = snapshot.docs.map(GameModel.fromFirestore).toList();

    if (role == 'host') {
      games = games.where((g) => g.hostId == uid).toList();
    } else if (role == 'player') {
      games = games.where((g) => g.hostId != uid).toList();
    }

    if (status != null) {
      final now = DateTime.now();
      games = games.where((g) {
        switch (status) {
          case 'upcoming':
            return g.status != GameStatus.cancelled &&
                g.status != GameStatus.completed &&
                g.endTime.isAfter(now);
          case 'completed':
            return g.status == GameStatus.completed;
          case 'cancelled':
            return g.status == GameStatus.cancelled;
          default:
            return true;
        }
      }).toList();
    }

    games.sort((a, b) => b.startTime.compareTo(a.startTime));
    return games;
  }

  /// Creates the game document; the host is the first player.
  Future<GameEntity> createGame(GameEntity game) async {
    final doc = _games.doc();
    await doc.set({
      ...GameModel.toFirestore(
        game.copyWith(status: GameStatus.open, playerIds: [game.hostId]),
      ),
      'players': {
        game.hostId: FieldValue.serverTimestamp(),
      },
    });

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
      final playerIds =
          (snapshot.data()!['playerIds'] as List<dynamic>).cast<String>();

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
        'players.$playerId': FieldValue.serverTimestamp(),
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

      final playerIds =
          (snapshot.data()!['playerIds'] as List<dynamic>).cast<String>();
      final updated = playerIds.where((id) => id != playerId).toList();

      transaction.update(ref, {
        'playerIds': updated,
        'players.$playerId': FieldValue.delete(),
        if (game.status == GameStatus.full) 'status': GameStatus.open.name,
      });

      return game.copyWith(
        currentPlayers: updated.length,
        status:
            game.status == GameStatus.full ? GameStatus.open : game.status,
      );
    });
  }

  /// Host-only. Sets `status = cancelled`.
  ///
  /// Mirrors `POST /games/{id}/cancel/`. The [requestingUid] must be the
  /// host, otherwise [ForbiddenException] is thrown (maps to HTTP 403).
  Future<GameEntity> cancelGame(
    String gameId,
    String requestingUid,
  ) async {
    return _firestore.runTransaction((transaction) async {
      final ref = _games.doc(gameId);
      final snapshot = await transaction.get(ref);
      if (!snapshot.exists) {
        throw const NotFoundException('Game not found');
      }

      final game = GameModel.fromFirestore(snapshot);
      if (game.hostId != requestingUid) {
        throw const ForbiddenException('Only the host can cancel this game');
      }

      transaction.update(ref, {'status': GameStatus.cancelled.name});
      return game.copyWith(status: GameStatus.cancelled);
    });
  }

  /// Resolves the players of a game to their user profiles.
  ///
  /// Mirrors `GET /games/{id}/players/`. `joinedAt` comes from the game's
  /// `players` map; profile fields come from the `users` collection.
  Future<List<GamePlayer>> getPlayers(String gameId) async {
    final snapshot = await _games.doc(gameId).get();
    if (!snapshot.exists) {
      throw const NotFoundException('Game not found');
    }

    final players =
        (snapshot.data()!['players'] as Map<String, dynamic>? ?? {});
    if (players.isEmpty) return const [];

    final result = <GamePlayer>[];
    for (final entry in players.entries) {
      final uid = entry.key;
      final joinedAt = (entry.value as Timestamp?)?.toDate();
      final userDoc = await _users.doc(uid).get();
      final user = userDoc.data();
      result.add(
        GamePlayer(
          userId: uid,
          displayName: user?['displayName'] as String?,
          avatarUrl: user?['avatarUrl'] as String?,
          skillLevel: user?['skillLevel'] as String?,
          joinedAt: joinedAt,
        ),
      );
    }
    return result;
  }

  /// Cleans up a user's game data on account deletion:
  /// deletes games they host and removes them from games they joined.
  /// Must run while the user is still authenticated (Firestore rules
  /// require `request.auth`).
  Future<void> deleteUserGames(String uid) async {
    // 1. Delete games the user hosts.
    final hosted = await _games.where('hostId', isEqualTo: uid).get();
    if (hosted.docs.isNotEmpty) {
      final batch = _firestore.batch();
      for (final doc in hosted.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    }

    // 2. Remove the user from games they joined as a player.
    final joined =
        await _games.where('playerIds', arrayContains: uid).get();
    final batch = _firestore.batch();
    var hasUpdates = false;
    for (final doc in joined.docs) {
      final data = doc.data();
      if (data['hostId'] == uid) continue; // already deleted above
      final playerIds =
          (data['playerIds'] as List<dynamic>).cast<String>();
      if (!playerIds.contains(uid)) continue;
      batch.update(doc.reference, {
        'playerIds': playerIds.where((id) => id != uid).toList(),
        'players.$uid': FieldValue.delete(),
      });
      hasUpdates = true;
    }
    if (hasUpdates) await batch.commit();
  }

  /// Resolves the host's current display name from the `users` collection.
  /// Lets the game overview show an up-to-date name even if the
  /// denormalized `hostName` stored on the game document is stale.
  Future<String?> getHostDisplayName(String hostId) async {
    final doc = await _users.doc(hostId).get();
    final data = doc.data();
    if (data == null) return null;
    return (data['displayName'] as String?) ?? (data['username'] as String?);
  }

  Future<GameEntity> getGameById(String gameId) async {
    final snapshot = await _games.doc(gameId).get();
    if (!snapshot.exists) {
      throw const NotFoundException('Game not found');
    }
    return GameModel.fromFirestore(snapshot);
  }
}
