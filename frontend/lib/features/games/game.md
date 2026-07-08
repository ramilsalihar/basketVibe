# Games Feature

## Current State

In-memory mock (`GameRepositoryImpl`). No backend calls yet.

Enums:

```dart
enum GameVisibility { public, friendsOnly, private }
enum GameLevel { casual, balanced, competitive }
enum GameStatus { open, full, inProgress, completed, cancelled }
```

---

## Backend Endpoints Required

Base path: `/games/`

### 1. List Active Games

```
GET /games/?status=open&city={city}
```

Query params:

| Param | Type | Required | Notes |
|-------|------|----------|-------|
| `status` | `string` | no | filter by `open`, `full`, `inProgress` |
| `city` | `string` | no | filter by city |
| `level` | `string` | no | `casual / balanced / competitive` |
| `date` | `ISO 8601` | no | filter by start date |
| `page` | `int` | no | pagination, default 1 |
| `page_size` | `int` | no | default 20 |

Response `200`:

```json
{
  "count": 42,
  "next": "/games/?page=2",
  "results": [ ...GameEntity ]
}
```

---

### 2. Get Game by ID

```
GET /games/{id}/
```

Response `200`: single `GameEntity`
Response `404`: game not found

---

### 3. Create Game

```
POST /games/
Authorization: Bearer <access_token>
```

Request body:

| Field | Type | Required | Notes |
|-------|------|----------|-------|
| `court_id` | `string` | yes | |
| `start_time` | `ISO 8601` | yes | |
| `duration_minutes` | `int` | yes | e.g. `120` |
| `max_players` | `int` | yes | 2–20 |
| `visibility` | `string` | yes | `public / friends_only / private` |
| `level` | `string` | yes | `casual / balanced / competitive` |
| `title` | `string` | no | max 80 chars |
| `description` | `string` | no | max 300 chars |
| `price_per_player` | `number` | no | local currency |

Response `201`: created `GameEntity`
Response `400`: validation error

---

### 4. Update Game

```
PATCH /games/{id}/
Authorization: Bearer <access_token>
```

Host only. Same optional fields as create. Cannot change `court_id` after players joined.

Response `200`: updated `GameEntity`
Response `403`: not the host
Response `404`: game not found

---

### 5. Cancel Game

```
POST /games/{id}/cancel/
Authorization: Bearer <access_token>
```

Host only. Sets `status = cancelled`. Notifies all joined players.

Response `200`: `{ "status": "cancelled" }`
Response `403`: not the host

---

### 6. Join Game

```
POST /games/{id}/join/
Authorization: Bearer <access_token>
```

Response `200`: updated `GameEntity` (incremented `current_players`)
Response `400`: game full or not open
Response `409`: player already in game

---

### 7. Leave Game

```
POST /games/{id}/leave/
Authorization: Bearer <access_token>
```

Response `200`: updated `GameEntity`
Response `400`: player not in game
Response `403`: host cannot leave — must cancel instead

---

### 8. Get Players in Game

```
GET /games/{id}/players/
Authorization: Bearer <access_token>
```

Response `200`:

```json
[
  {
    "user_id": "42",
    "display_name": "Алмаз К.",
    "avatar_url": "...",
    "skill_level": "intermediate",
    "joined_at": "2024-01-01T10:00:00Z"
  }
]
```

---

### 9. My Games

```
GET /games/my/
Authorization: Bearer <access_token>
```

Query params:

| Param | Type | Notes |
|-------|------|-------|
| `role` | `string` | `host / player` — filter by role |
| `status` | `string` | `upcoming / completed / cancelled` |

Response `200`: paginated list of `GameEntity`

---

## GameEntity — Backend Field Mapping

| Dart field | Backend key | Type |
|------------|-------------|------|
| `id` | `id` | `string (UUID)` |
| `courtId` | `court_id` | `string` |
| `courtName` | `court_name` | `string` |
| `city` | `city` | `string` |
| `address` | `address` | `string` |
| `hostId` | `host_id` | `string` |
| `hostName` | `host_name` | `string` |
| `startTime` | `start_time` | `ISO 8601` |
| `duration` | `duration_minutes` | `int` |
| `maxPlayers` | `max_players` | `int` |
| `currentPlayers` | `current_players` | `int` |
| `visibility` | `visibility` | `string` |
| `level` | `level` | `string` |
| `status` | `status` | `string` |
| `title` | `title` | `string?` |
| `pricePerPlayer` | `price_per_player` | `number?` |
| `description` | `description` | `string?` |
| `chatId` | `chat_id` | `string?` |
| `createdAt` | `created_at` | `ISO 8601?` |

---

## TODO

- [x] Create `GameRemoteDataSource` (`data/datasources/game_remote_datasource.dart`)
- [x] Replace `GameRepositoryImpl` mock with remote datasource calls
- [x] Add pagination support to `GameLoaded` state
- [x] Add `GameCubit.loadMyGames()` method
- [x] Add `GameCubit.cancelGame()` method
- [x] Add `GameCubit.getPlayers()` method
- [x] Wire `GameRemoteDataSource` into `injection.dart`
