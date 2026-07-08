import 'package:basketvibe/features/games/domain/entities/game_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Maps [GameEntity] to/from the `games/{gameId}` Firestore document.
///
/// Firestore additionally stores `playerIds` (joined player uids);
/// `currentPlayers` on the entity is derived from its length.
class GameModel {
  GameModel._();

  static GameEntity fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    final playerIds =
        (data['playerIds'] as List<dynamic>? ?? const []).cast<String>();

    return GameEntity(
      id: doc.id,
      courtId: data['courtId'] as String,
      courtName: data['courtName'] as String,
      city: data['city'] as String,
      address: data['address'] as String,
      hostId: data['hostId'] as String,
      hostName: data['hostName'] as String,
      startTime: (data['startTime'] as Timestamp).toDate(),
      duration: Duration(minutes: data['durationMinutes'] as int),
      maxPlayers: data['maxPlayers'] as int,
      currentPlayers: playerIds.length,
      playerIds: playerIds,
      visibility: GameVisibility.values.byName(data['visibility'] as String),
      level: GameLevel.values.byName(data['level'] as String),
      status: GameStatus.values.byName(data['status'] as String),
      title: data['title'] as String?,
      pricePerPlayer: (data['pricePerPlayer'] as num?)?.toDouble(),
      description: data['description'] as String?,
      chatId: data['chatId'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  static Map<String, dynamic> toFirestore(GameEntity game) {
    return {
      'courtId': game.courtId,
      'courtName': game.courtName,
      'city': game.city,
      'address': game.address,
      'hostId': game.hostId,
      'hostName': game.hostName,
      'startTime': Timestamp.fromDate(game.startTime),
      'durationMinutes': game.duration.inMinutes,
      'maxPlayers': game.maxPlayers,
      'playerIds': game.playerIds,
      'visibility': game.visibility.name,
      'level': game.level.name,
      'status': game.status.name,
      'title': game.title,
      'pricePerPlayer': game.pricePerPlayer,
      'description': game.description,
      'chatId': game.chatId,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
