# 🏗️ Architecture Rules & Patterns

## Clean Architecture Layers

```
Presentation → Domain ← Data
      ↓            ↓
    BLoC       UseCases
                  ↓
             Repository (abstract)
                  ↑
             RepositoryImpl (data layer)
                  ↓
             DataSources + Models
```

## Layer Responsibilities

### Domain Layer (Pure Dart — NO Flutter imports)
- **Entities:** Plain Dart classes, no JSON/serialization logic
- **Repository interfaces:** Abstract classes defining contracts
- **Use cases:** Single responsibility, one public `call()` method, returns `Either<Failure, T>`

### Data Layer
- **Models:** Extend entities, add `fromJson/toJson` (use freezed)
- **DataSources:** Raw Firebase/API calls, throw `Exceptions`
- **RepositoryImpl:** Implements domain repository, catches exceptions → returns `Failures`

### Presentation Layer
- **BLoC:** Receives events, emits states, calls use cases
- **Pages:** Listen to BLoC states via `BlocBuilder`/`BlocListener`
- **Widgets:** Dumb UI components, receive data via constructor

---

## Code Templates

### Entity
```dart
// core has no dependencies
class GameEntity extends Equatable {
  final String id;
  final String title;
  final GeoPoint location;
  final DateTime scheduledAt;
  final int maxPlayers;
  final List<String> playerIds;
  final SkillLevel skillLevel;

  const GameEntity({...});

  @override
  List<Object?> get props => [id, title, location, scheduledAt];
}
```

### Use Case
```dart
class GetNearbyGamesUseCase {
  final GamesRepository _repository;
  const GetNearbyGamesUseCase(this._repository);

  Future<Either<Failure, List<GameEntity>>> call(GetNearbyGamesParams params) {
    return _repository.getNearbyGames(
      lat: params.lat,
      lng: params.lng,
      radiusKm: params.radiusKm,
    );
  }
}

class GetNearbyGamesParams extends Equatable {
  final double lat;
  final double lng;
  final double radiusKm;
  const GetNearbyGamesParams({required this.lat, required this.lng, this.radiusKm = 10.0});
  
  @override
  List<Object?> get props => [lat, lng, radiusKm];
}
```

### Repository Interface
```dart
abstract class GamesRepository {
  Future<Either<Failure, List<GameEntity>>> getNearbyGames({
    required double lat,
    required double lng,
    required double radiusKm,
  });
  Future<Either<Failure, GameEntity>> createGame(GameEntity game);
  Future<Either<Failure, Unit>> joinGame(String gameId, String userId);
  Future<Either<Failure, Unit>> leaveGame(String gameId, String userId);
}
```

### Repository Implementation
```dart
class GamesRepositoryImpl implements GamesRepository {
  final GamesRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  const GamesRepositoryImpl(this._remoteDataSource, this._networkInfo);

  @override
  Future<Either<Failure, List<GameEntity>>> getNearbyGames({...}) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure());
    }
    try {
      final models = await _remoteDataSource.getNearbyGames(...);
      return Right(models.map((m) => m.toEntity()).toList());
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
```

### BLoC
```dart
// events
sealed class GamesEvent extends Equatable {}

class LoadNearbyGames extends GamesEvent {
  final double lat;
  final double lng;
  const LoadNearbyGames({required this.lat, required this.lng});
  @override List<Object?> get props => [lat, lng];
}

class JoinGame extends GamesEvent {
  final String gameId;
  const JoinGame(this.gameId);
  @override List<Object?> get props => [gameId];
}

// states
sealed class GamesState extends Equatable {}

class GamesInitial extends GamesState {
  @override List<Object?> get props => [];
}
class GamesLoading extends GamesState {
  @override List<Object?> get props => [];
}
class GamesLoaded extends GamesState {
  final List<GameEntity> games;
  const GamesLoaded(this.games);
  @override List<Object?> get props => [games];
}
class GamesError extends GamesState {
  final String message;
  const GamesError(this.message);
  @override List<Object?> get props => [message];
}

// bloc
class GamesBloc extends Bloc<GamesEvent, GamesState> {
  final GetNearbyGamesUseCase _getNearbyGames;
  final JoinGameUseCase _joinGame;

  GamesBloc({
    required GetNearbyGamesUseCase getNearbyGames,
    required JoinGameUseCase joinGame,
  })  : _getNearbyGames = getNearbyGames,
        _joinGame = joinGame,
        super(GamesInitial()) {
    on<LoadNearbyGames>(_onLoadNearbyGames);
    on<JoinGame>(_onJoinGame);
  }

  Future<void> _onLoadNearbyGames(
    LoadNearbyGames event,
    Emitter<GamesState> emit,
  ) async {
    emit(GamesLoading());
    final result = await _getNearbyGames(
      GetNearbyGamesParams(lat: event.lat, lng: event.lng),
    );
    result.fold(
      (failure) => emit(GamesError(failure.message)),
      (games) => emit(GamesLoaded(games)),
    );
  }
}
```

### Page with BlocBuilder
```dart
class GamesPage extends StatelessWidget {
  const GamesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<GamesBloc>()..add(LoadNearbyGames(lat: 0, lng: 0)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Nearby Games')),
        body: BlocConsumer<GamesBloc, GamesState>(
          listener: (context, state) {
            if (state is GamesError) {
              AppSnackbar.showError(context, state.message);
            }
          },
          builder: (context, state) {
            return switch (state) {
              GamesInitial() || GamesLoading() => const AppLoading(),
              GamesLoaded(:final games) => GamesList(games: games),
              GamesError(:final message) => EmptyStateWidget(message: message),
            };
          },
        ),
      ),
    );
  }
}
```

---

## Failures
```dart
// core/errors/failures.dart
sealed class Failure extends Equatable {
  final String message;
  const Failure(this.message);
  @override List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error occurred']);
}
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error occurred']);
}
class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed']);
}
class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Resource not found']);
}
```

## Dependency Injection (GetIt + Injectable)
```dart
// Register in each feature's module or core/app/di/injection.dart
@module
abstract class GamesModule {
  @lazySingleton
  GamesRemoteDataSource gamesRemoteDataSource(FirebaseFirestore firestore) =>
      GamesRemoteDataSourceImpl(firestore);

  @lazySingleton
  GamesRepository gamesRepository(
    GamesRemoteDataSource remote,
    NetworkInfo network,
  ) => GamesRepositoryImpl(remote, network);

  @injectable
  GetNearbyGamesUseCase getNearbyGames(GamesRepository repo) =>
      GetNearbyGamesUseCase(repo);

  @injectable
  GamesBloc gamesBloc(
    GetNearbyGamesUseCase getNearbyGames,
    JoinGameUseCase joinGame,
  ) => GamesBloc(getNearbyGames: getNearbyGames, joinGame: joinGame);
}
```
