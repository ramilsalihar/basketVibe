# 📁 Project Folder Structure

## Full Directory Tree

```
lib/
├── main.dart
├── app/                          ← injected via core/app
│
├── core/
│   ├── app/
│   │   ├── app.dart              ← Root MaterialApp widget
│   │   ├── app_bloc_observer.dart
│   │   └── di/
│   │       ├── injection.dart    ← GetIt setup
│   │       └── injection.config.dart
│   │
│   ├── constants/
│   │   ├── app_constants.dart    ← General constants
│   │   ├── asset_constants.dart  ← Image/icon paths
│   │   ├── route_constants.dart  ← Route name strings
│   │   └── firebase_constants.dart
│   │
│   ├── styles/
│   │   ├── app_theme.dart        ← ThemeData light/dark
│   │   ├── app_colors.dart       ← Color palette
│   │   ├── app_text_styles.dart  ← TextStyle definitions
│   │   ├── app_spacing.dart      ← Padding/margin constants
│   │   └── app_border_radius.dart
│   │
│   ├── utils/
│   │   ├── extensions/
│   │   │   ├── context_extension.dart
│   │   │   ├── string_extension.dart
│   │   │   ├── datetime_extension.dart
│   │   │   └── list_extension.dart
│   │   ├── helpers/
│   │   │   ├── date_helper.dart
│   │   │   ├── location_helper.dart
│   │   │   └── validator_helper.dart
│   │   └── typedefs.dart         ← Common type aliases
│   │
│   ├── errors/
│   │   ├── failures.dart         ← Failure sealed classes
│   │   └── exceptions.dart       ← Exception classes
│   │
│   ├── network/
│   │   ├── network_info.dart
│   │   └── api_client.dart
│   │
│   ├── router/
│   │   ├── app_router.dart       ← GoRouter config
│   │   └── route_guards.dart
│   │
│   └── widgets/                  ← Shared/common widgets
│       ├── buttons/
│       │   ├── primary_button.dart
│       │   ├── secondary_button.dart
│       │   └── icon_text_button.dart
│       ├── inputs/
│       │   ├── app_text_field.dart
│       │   └── search_field.dart
│       ├── cards/
│       │   ├── game_card.dart
│       │   └── player_card.dart
│       ├── loaders/
│       │   ├── app_loading.dart
│       │   └── shimmer_loader.dart
│       ├── dialogs/
│       │   └── app_dialog.dart
│       ├── app_snackbar.dart
│       ├── app_avatar.dart
│       └── empty_state_widget.dart
│
└── features/
    ├── auth/
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   ├── auth_remote_datasource.dart
    │   │   │   └── auth_local_datasource.dart
    │   │   ├── models/
    │   │   │   └── user_model.dart
    │   │   └── repositories/
    │   │       └── auth_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── user_entity.dart
    │   │   ├── repositories/
    │   │   │   └── auth_repository.dart
    │   │   └── usecases/
    │   │       ├── sign_in_usecase.dart
    │   │       ├── sign_up_usecase.dart
    │   │       ├── sign_out_usecase.dart
    │   │       └── get_current_user_usecase.dart
│   └── presentation/
│       ├── cubit/                  ← or bloc/ for BLoC
│       │   ├── auth_cubit.dart
│       │   └── auth_state.dart
│       ├── pages/
│       │   ├── login_page.dart
│       │   ├── register_page.dart
│       │   └── forgot_password_page.dart
│       └── widgets/
│           ├── buttons/            ← widget files: *_button.dart
│           │   └── social_login_button.dart
│           ├── fields/             ← widget files: *_field.dart
│           │   └── auth_text_field.dart
│           ├── utils/               ← small helpers, loaders, etc.
│           │   └── auth_form.dart
│           └── (other divisions as needed)
    │
    ├── games/
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   └── games_remote_datasource.dart
    │   │   ├── models/
    │   │   │   └── game_model.dart
    │   │   └── repositories/
    │   │       └── games_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── game_entity.dart
    │   │   ├── repositories/
    │   │   │   └── games_repository.dart
    │   │   └── usecases/
    │   │       ├── get_nearby_games_usecase.dart
    │   │       ├── create_game_usecase.dart
    │   │       ├── join_game_usecase.dart
    │   │       └── leave_game_usecase.dart
│   └── presentation/
│       ├── cubit/
│       │   ├── games_cubit.dart
│       │   └── games_state.dart
│       ├── pages/
│       │   ├── games_page.dart
│       │   ├── game_detail_page.dart
│       │   └── create_game_page.dart
│       └── widgets/
│           ├── buttons/
│           │   └── join_game_button.dart
│           ├── cards/
│           │   └── game_card.dart
│           └── utils/
│               ├── games_list.dart
│               └── game_filter_sheet.dart
    │
    ├── courts/
    │   └── ... (same data/domain/presentation structure)
    │
    ├── profile/
    │   └── ... (same data/domain/presentation structure)
    │
    ├── players/
    │   └── ... (same data/domain/presentation structure)
    │
    └── home/
        └── presentation/
            ├── cubit/
            ├── pages/
            │   └── home_page.dart    ← Bottom nav shell
            └── widgets/
                ├── buttons/
                ├── utils/
                └── bottom_nav_bar.dart
```

## Presentation Layer Structure (per feature)

Every feature’s **presentation** folder must follow:

- **`cubit/`** — Cubits (or **`bloc/`** if using BLoC: bloc, events, states)
- **`pages/`** — Full screens; files: `*_page.dart`
- **`widgets/`** — Reusable UI; may be split into subfolders for easier navigation:
  - **`buttons/`** — e.g. `primary_button.dart`, `social_login_button.dart` (suffix `_button.dart`)
  - **`fields/`** — e.g. `auth_text_field.dart`, `search_field.dart` (suffix `_field.dart`)
  - **`utils/`** — form wrappers, loaders, small helpers
  - **`cards/`**, **`dialogs/`**, etc. as needed

**Widget file naming in subfolders:**  
If a widget lives in a subfolder, its name must include the folder type.  
Examples: `buttons/` → `*_button.dart`, `fields/` → `*_field.dart`, `cards/` → `*_card.dart`.

## Key Rules
1. Features never import from other features directly — use shared entities via core
2. Presentation layer only knows about BLoC and domain entities
3. Domain layer has zero Flutter dependencies (pure Dart)
4. Data layer implements domain repository interfaces
5. DI wires everything together in `core/app/di/`
