# 🏀 Domain Models & Entities

## Core Entities

### UserEntity
```dart
enum SkillLevel { beginner, intermediate, advanced, pro }
enum PlayerPosition { pointGuard, shootingGuard, smallForward, powerForward, center, flex }

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String username;
  final String? displayName;
  final String? avatarUrl;
  final SkillLevel skillLevel;
  final List<PlayerPosition> positions;
  final String? city;
  final double? lat;
  final double? lng;
  final int gamesPlayed;
  final int gamesCreated;
  final double rating;         // avg rating from other players
  final bool isVerified;
  final DateTime createdAt;
}
```

### GameEntity
```dart
enum GameStatus { open, full, inProgress, completed, cancelled }
enum GameType { pickup, organized, tournament }
enum SportType { basketball }    // extendable later

class GameEntity extends Equatable {
  final String id;
  final String creatorId;
  final String title;
  final String? description;
  final CourtEntity court;
  final DateTime scheduledAt;
  final int durationMinutes;     // e.g. 60, 90, 120
  final int maxPlayers;
  final int minPlayers;
  final List<String> playerIds;
  final List<String> waitlistIds;
  final SkillLevel? skillLevel;  // null = all levels
  final GameType gameType;
  final GameStatus status;
  final bool isPrivate;
  final String? accessCode;      // for private games
  final double? costPerPlayer;   // null = free
  final DateTime createdAt;
}
```

### CourtEntity
```dart
enum CourtSurface { hardwood, asphalt, concrete }
enum CourtType { indoor, outdoor }

class CourtEntity extends Equatable {
  final String id;
  final String name;
  final String address;
  final double lat;
  final double lng;
  final CourtSurface surface;
  final CourtType type;
  final int numberOfBaskets;
  final bool hasLights;
  final bool isFree;
  final String? imageUrl;
  final double rating;
  final int reviewCount;
}
```

### MessageEntity (in-game chat)
```dart
class MessageEntity extends Equatable {
  final String id;
  final String gameId;
  final String senderId;
  final String senderUsername;
  final String? senderAvatarUrl;
  final String content;
  final DateTime sentAt;
}
```

---

## Firestore Collections Structure

```
/users/{userId}
  - id, email, username, displayName, avatarUrl
  - skillLevel, positions, city, lat, lng
  - gamesPlayed, gamesCreated, rating, isVerified
  - createdAt

/courts/{courtId}
  - id, name, address, lat, lng
  - surface, type, numberOfBaskets, hasLights, isFree
  - imageUrl, rating, reviewCount

/games/{gameId}
  - id, creatorId, title, description
  - courtId (reference), courtSnapshot (denormalized)
  - scheduledAt, durationMinutes, maxPlayers, minPlayers
  - playerIds[], waitlistIds[]
  - skillLevel, gameType, status
  - isPrivate, accessCode, costPerPlayer
  - createdAt

/games/{gameId}/messages/{messageId}
  - id, senderId, senderUsername, senderAvatarUrl
  - content, sentAt
```

---

## Enums & Shared Types

```dart
// core/utils/typedefs.dart
typedef EitherFailure<T> = Future<Either<Failure, T>>;
typedef JsonMap = Map<String, dynamic>;
```
