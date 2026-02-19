# 🚀 Features & Coding Rules

## Feature Roadmap (Priority Order)

### Phase 1 — MVP
- [x] Auth (sign up, login, forgot password) — Firebase Auth
- [ ] Profile setup (username, skill level, positions, location)
- [ ] Courts — browse courts on map, court detail
- [ ] Games — list nearby games, game detail, join/leave
- [ ] Create Game — pick court, set time, player limits, skill level
- [ ] My Games — games I joined / created

### Phase 2
- [ ] In-game chat (Firestore real-time)
- [ ] Player search & connect
- [ ] Push notifications (FCM) — game starting soon, player joined
- [ ] Game invites / share link
- [ ] Court reviews & ratings

### Phase 3
- [ ] Player ratings after games
- [ ] Teams / squads
- [ ] Tournament mode
- [ ] Stats tracking

---

## Coding Rules & Conventions

### File Naming
- All files: `snake_case.dart`
- Classes: `PascalCase`
- Variables/methods: `camelCase`
- Constants: `camelCase` (avoid SCREAMING_SNAKE)

### BLoC Conventions
- One BLoC per feature screen/flow
- Events are actions (verbs): `LoadGames`, `JoinGame`, `CreateGame`
- States are nouns/adjectives: `GamesLoading`, `GamesLoaded`, `GamesError`
- Use `sealed class` for events and states (Dart 3+)
- Always use `Equatable` on events and states

### Widget Conventions
- Prefer `StatelessWidget` — move state to BLoC
- Extract widgets > 50 lines into separate files
- Use `const` constructors wherever possible
- Name keys: `Key('login_button')` for testing

### Import Order (follow flutter lints)
```dart
// 1. dart:
import 'dart:async';
// 2. package:flutter/
import 'package:flutter/material.dart';
// 3. package: (third party)
import 'package:flutter_bloc/flutter_bloc.dart';
// 4. relative imports
import '../widgets/game_card.dart';
```

### Error Handling Pattern
```dart
// Always use Either from dartz in domain/data
// Never throw from use cases or repositories
// Convert exceptions to failures in repository
// Map failures to user-facing messages in BLoC or UI

extension FailureMessage on Failure {
  String get userMessage => switch (this) {
    NetworkFailure() => 'No internet connection. Please try again.',
    ServerFailure(:final message) => message ?? 'Something went wrong.',
    AuthFailure(:final message) => message ?? 'Authentication failed.',
    _ => 'An unexpected error occurred.',
  };
}
```

### Async in BLoC
```dart
// Always use Emitter properly
Future<void> _onEvent(Event event, Emitter<State> emit) async {
  emit(Loading());
  final result = await useCase(params);
  // result.fold handles both success and failure
  result.fold(
    (failure) => emit(Error(failure.userMessage)),
    (data) => emit(Loaded(data)),
  );
}
```

### Firebase Firestore Patterns
```dart
// Always use .withConverter for type safety
final gamesRef = FirebaseFirestore.instance
    .collection('games')
    .withConverter<GameModel>(
      fromFirestore: (snap, _) => GameModel.fromJson(snap.data()!),
      toFirestore: (model, _) => model.toJson(),
    );

// Use GeoFlutterFire or Geoflutterfire_plus for geo queries
// Store lat/lng as separate fields AND as GeoPoint for geo queries
```

### Testing Strategy
- Unit test: Use cases, BLoCs, utilities
- Use `mocktail` for mocking
- Use `bloc_test` for BLoC testing
- Name tests: `given_when_then` format

```dart
group('GamesBloc', () {
  blocTest<GamesBloc, GamesState>(
    'given valid location when LoadNearbyGames then emits [Loading, Loaded]',
    build: () => GamesBloc(...),
    act: (bloc) => bloc.add(LoadNearbyGames(lat: 0, lng: 0)),
    expect: () => [isA<GamesLoading>(), isA<GamesLoaded>()],
  );
});
```

---

## DO's and DON'Ts

### ✅ DO
- Use `go_router` for navigation with route guards
- Use `GetIt` + `@injectable` for DI
- Use `freezed` for immutable models
- Use `dartz` Either for error handling
- Provide BLoC at the page level with `BlocProvider`
- Use `BlocConsumer` when you need both listen and build
- Write `toEntity()` on Models, not `fromEntity()` on Entities

### ❌ DON'T
- Don't put business logic in widgets
- Don't call Firebase directly from BLoC or presentation
- Don't use `context` in BLoC
- Don't use `BuildContext` in domain or data layers
- Don't use `setState` — use BLoC
- Don't import feature A directly into feature B
- Don't use `dynamic` types
