import 'package:equatable/equatable.dart';

/// Core domain entity for a pickup game lobby ("The Run").
///
/// This represents a single playable session that players can discover
/// and join. Data-layer models should map to/from this entity.
class GameEntity extends Equatable {
  const GameEntity({
    required this.id,
    required this.courtId,
    required this.courtName,
    required this.city,
    required this.address,
    required this.hostId,
    required this.hostName,
    required this.startTime,
    required this.duration,
    required this.maxPlayers,
    required this.currentPlayers,
    required this.visibility,
    required this.level,
    required this.status,
    this.pricePerPlayer,
    this.description,
    this.chatId,
    this.createdAt,
  });

  /// Unique game / lobby identifier.
  final String id;

  /// Court reference and display info.
  final String courtId;
  final String courtName;
  final String city;
  final String address;

  /// Host (creator of the run).
  final String hostId;
  final String hostName;

  /// When the run starts and how long it lasts.
  final DateTime startTime;
  final Duration duration;

  /// Capacity and current participants.
  final int maxPlayers;
  final int currentPlayers;

  /// Who can discover / join this lobby.
  final GameVisibility visibility;

  /// Intensity / competitiveness of the run.
  final GameLevel level;

  /// Current lifecycle state of the lobby.
  final GameStatus status;

  /// Optional monetization info.
  ///
  /// Price per player in local currency (e.g. KGS).
  final double? pricePerPlayer;

  /// Optional host message / notes (e.g. “3x3, intermediate, bring a dark tee”).
  final String? description;

  /// Optional reference to an in-game chat channel.
  final String? chatId;

  /// When this lobby was created (server time when persisted).
  final DateTime? createdAt;

  /// True if the lobby is open for new players.
  bool get isJoinable =>
      status == GameStatus.open && currentPlayers < maxPlayers;

  /// True if lobby is full.
  bool get isFull => currentPlayers >= maxPlayers;

  /// Calculated end time.
  DateTime get endTime => startTime.add(duration);

  GameEntity copyWith({
    String? id,
    String? courtId,
    String? courtName,
    String? city,
    String? address,
    String? hostId,
    String? hostName,
    DateTime? startTime,
    Duration? duration,
    int? maxPlayers,
    int? currentPlayers,
    GameVisibility? visibility,
    GameLevel? level,
    GameStatus? status,
    double? pricePerPlayer,
    String? description,
    String? chatId,
    DateTime? createdAt,
  }) {
    return GameEntity(
      id: id ?? this.id,
      courtId: courtId ?? this.courtId,
      courtName: courtName ?? this.courtName,
      city: city ?? this.city,
      address: address ?? this.address,
      hostId: hostId ?? this.hostId,
      hostName: hostName ?? this.hostName,
      startTime: startTime ?? this.startTime,
      duration: duration ?? this.duration,
      maxPlayers: maxPlayers ?? this.maxPlayers,
      currentPlayers: currentPlayers ?? this.currentPlayers,
      visibility: visibility ?? this.visibility,
      level: level ?? this.level,
      status: status ?? this.status,
      pricePerPlayer: pricePerPlayer ?? this.pricePerPlayer,
      description: description ?? this.description,
      chatId: chatId ?? this.chatId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        courtId,
        courtName,
        city,
        address,
        hostId,
        hostName,
        startTime,
        duration,
        maxPlayers,
        currentPlayers,
        visibility,
        level,
        status,
        pricePerPlayer,
        description,
        chatId,
        createdAt,
      ];
}

/// Who can see / join a game lobby.
enum GameVisibility {
  public, // visible to everyone
  friendsOnly,
  private,
}

/// Intensity / level of play.
enum GameLevel {
  casual,
  balanced,
  competitive,
}

/// Lifecycle of the lobby.
enum GameStatus {
  open,
  full,
  inProgress,
  completed,
  cancelled,
}

