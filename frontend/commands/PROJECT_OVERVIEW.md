# 🏀 BasketVibe — Basketball Community App

## Tagline
**Run with your city.**

## Project Overview
BasketVibe is the digital home for the Central Asian basketball community. It merges game logistics with social media storytelling — solving fragmentation, court information gaps, and the absence of a dedicated local streetball culture platform.

## Target Region
Central Asia — Bishkek (primary), Almaty, Tashkent

## Core Concept
- Players can discover pickup games near them
- Create and join games at local courts
- Build player profiles with stats and skill levels
- Connect with other players and build squads
- Share basketball highlights and moments
- Split court fees seamlessly

## Core Features

### 1. Interactive Court Map
Browse courts, view specs, real-time check-in, and follow favorite courts.

### 2. The Run (Game Lobby)
Create pickup games, join requests, host approval flow — the core game discovery and organization system.

### 3. The Baseline
TikTok-style short video highlights feed — vertical feed, upload clips, dap (like), and comment.

### 4. Player Profiles
Karma/reliability score, skill level, positions, games played, and player stats.

### 5. Payments
Court fee splitting via MBank, O!Money, Kaspi — seamless payment integration for Central Asian markets.

### 6. Telegram Sync
Cross-post runs to local Telegram groups — bridge the gap between app and existing community channels.

## Tech Stack

| Layer            | Choice                                         |
|------------------|------------------------------------------------|
| Framework        | Flutter (iOS + Android)                        |
| State Management | flutter_bloc / bloc                            |
| Architecture     | Clean Architecture (data/domain/presentation)  |
| DI               | get_it + injectable                            |
| Navigation       | go_router                                      |
| Backend          | Firebase (Auth, Firestore, Storage, Functions) |
| Maps             | google_maps_flutter                            |
| Video            | video_player + chewie + camera                 |
| Payments         | url_launcher (deep-link) + webview_flutter     |
| Localization     | flutter_localizations + arb                    |
| Error Handling   | dartz (Either)                                 |
| Local Storage    | shared_preferences, hive                       |

## Key Dependencies (pubspec.yaml)

```yaml
dependencies:
  # State Management
  flutter_bloc: ^8.1.6
  equatable: ^2.0.5
  
  # Dependency Injection
  get_it: ^8.0.2
  injectable: ^2.4.4
  
  # Functional Programming
  dartz: ^0.10.1
  
  # Firebase
  firebase_core: ^3.x.x
  firebase_auth: ^5.x.x
  cloud_firestore: ^5.x.x
  firebase_storage: ^12.x.x
  cloud_functions: ^4.x.x
  
  # Navigation
  go_router: ^14.x.x
  
  # Maps & Location
  google_maps_flutter: ^2.x.x
  geolocator: ^13.x.x
  
  # Video
  video_player: ^2.x.x
  chewie: ^1.x.x
  camera: ^0.x.x
  
  # Payments
  url_launcher: ^6.x.x
  webview_flutter: ^4.x.x
  
  # Localization
  flutter_localizations:
    sdk: flutter
  intl: ^0.19.x
  
  # Local Storage
  shared_preferences: ^2.x.x
  hive_flutter: ^1.x.x
  
  # Media
  image_picker: ^1.x.x
  cached_network_image: ^3.x.x
  
  # Utilities
  uuid: ^4.x.x
  freezed_annotation: ^2.x.x
  json_annotation: ^4.x.x

dev_dependencies:
  build_runner: ^2.x.x
  freezed: ^2.x.x
  json_serializable: ^6.x.x
  injectable_generator: ^2.x.x
  bloc_test: ^9.x.x
  mocktail: ^1.x.x
```

## Languages
- **Russian 🇷🇺** — primary
- **English 🇬🇧** — secondary
- **Kyrgyz 🇰🇬** — partial (tournament descriptions)

## Build Stages

| Stage | Name                        | Key Deliverable                              |
|-------|-----------------------------|----------------------------------------------|
| 0     | Project Setup               | Running skeleton, Firebase, DI, router, theme|
| 1     | Auth & Onboarding           | Phone OTP + Google, profile onboarding       |
| 2     | Player Profile              | Karma score, edit profile, avatar upload     |
| 3     | Court Map & Directory       | Map + list, specs, check-in, follow court    |
| 4     | Game Lobby ("The Run")      | Create/join games, approval flow             |
| 5     | In-Game Chat                | Real-time Firestore messaging                |
| 6     | The Baseline (Video Feed)   | Vertical feed, upload, dap, comments         |
| 7     | Notifications + Telegram    | FCM push + Telegram bot cross-post           |
| 8     | Payments                    | Fee splitting via MBank/O!Money/Kaspi        |
| 9     | Localization & Polish       | RU/EN/KY, Crashlytics, release build         |

## Firestore Collections

### Users
- `/users/{uid}` — player profiles with karma, skill level, positions, stats

### Courts
- `/courts/{courtId}` — court directory with specs, location, ratings

### Games (The Run)
- `/games/{gameId}` — runs/pickup games
- `/games/{gameId}/joinRequests/{requestId}` — join request queue
- `/games/{gameId}/messages/{messageId}` — in-game chat messages
- `/games/{gameId}/payments/{playerId}` — payment tracking per player

### Clips (The Baseline)
- `/clips/{clipId}` — video highlights
- `/clips/{clipId}/comments/{commentId}` — comments on clips
- `/clips/{clipId}/daps/{userId}` — dap (like) tracking

## Cloud Functions

| Function                | Trigger          | Purpose                          |
|-------------------------|------------------|----------------------------------|
| `onGameJoined`          | Firestore write  | Update karma, notify host        |
| `onGameNoShow`          | Scheduled        | Decrease karma for no-shows      |
| `onGameCompleted`       | Firestore write  | Increment gamesPlayed            |
| `onVideoUploaded`        | Storage          | Generate thumbnail               |
| `sendTelegramGamePost`  | Firestore create | Cross-post Run to Telegram       |
| `splitPaymentWebhook`   | HTTP             | Handle payment gateway webhooks  |
| `onJoinRequestCreated`  | Firestore create | Push notification to host        |
| `onJoinRequestUpdated`  | Firestore update | Push notification to applicant   |
| `onGameStartingSoon`    | Scheduled        | 30-min reminder push             |

## Product Vision
BasketVibe bridges the gap between fragmented basketball communities in Central Asia by providing:
- **Unified Discovery** — One platform to find courts and games
- **Social Integration** — Video highlights feed + Telegram sync
- **Trust System** — Karma scores ensure reliable players
- **Local Payments** — Native integration with regional payment systems
- **Cultural Relevance** — Multi-language support for the region

---

*Last updated: Project initialization*
