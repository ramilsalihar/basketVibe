# 🏀 BasketVibe

**Run with your city.**

BasketVibe is the digital home for the Central Asian basketball community. It merges game logistics with social media storytelling — solving fragmentation, court information gaps, and the absence of a dedicated local streetball culture platform.

## 🎯 Target Region
Central Asia — Bishkek (primary), Almaty, Tashkent

## ✨ Core Features
- **Interactive Court Map** — Browse courts, specs, real-time check-in
- **The Run (Game Lobby)** — Create pickup games, join requests, host approval
- **The Baseline** — TikTok-style short video highlights feed
- **Player Profiles** — Karma/reliability score, skill level, positions
- **Payments** — Court fee splitting via MBank, O!Money, Kaspi
- **Telegram Sync** — Cross-post runs to local Telegram groups

## 🛠 Tech Stack
- **Framework:** Flutter (iOS + Android)
- **State Management:** flutter_bloc / bloc
- **Architecture:** Clean Architecture
- **Backend:** Firebase (Auth, Firestore, Storage, Functions)
- **Maps:** Google Maps Flutter
- **Video:** video_player + chewie + camera
- **Payments:** url_launcher + webview_flutter
- **Localization:** flutter_localizations (RU/EN/KY)

## 📚 Documentation
See the `commands/` folder for detailed documentation:
- `PROJECT_OVERVIEW.md` — Complete project overview and vision
- `AI_INSTRUCTIONS.md` — Development guidelines and workflow
- `ARCHITECTURE.md` — Clean Architecture patterns
- `FOLDER_STRUCTURE.md` — File organization
- `UI_STYLE_GUIDE.md` — Design system and styling
- `DOMAIN_MODELS.md` — Entity definitions
- `FEATURES_AND_RULES.md` — Feature roadmap and coding rules
- `CONTEXT_ROUTER.md` — Smart documentation routing guide

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (latest stable)
- Firebase project configured
- Google Maps API key

### Installation
```bash
# Install dependencies
flutter pub get

# Generate code (DI, models, etc.)
flutter pub run build_runner build --delete-conflicting-outputs
```

### Run
```bash
flutter run
```

## 📖 Development Guidelines
1. Read `commands/AI_INSTRUCTIONS.md` before starting any feature
2. Follow Clean Architecture patterns from `commands/ARCHITECTURE.md`
3. Use the design system from `commands/UI_STYLE_GUIDE.md`
4. Check `commands/CONTEXT_ROUTER.md` to find relevant documentation

## 🌍 Languages
- Russian 🇷🇺 — primary
- English 🇬🇧 — secondary
- Kyrgyz 🇰🇬 — partial

---

*Built with ❤️ for the Central Asian basketball community*
