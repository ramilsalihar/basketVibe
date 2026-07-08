import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:basketvibe/features/games/domain/entities/game_entity.dart';
import 'package:basketvibe/features/games/domain/repositories/game_repository.dart';
import 'package:basketvibe/features/games/presentation/cubit/game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit(this._repository) : super(const GameInitial());

  final GameRepository _repository;
  StreamSubscription<List<GameEntity>>? _subscription;

  // The cubit can be closed (page disposed) while a Firestore call is
  // still in flight — every emit after an await must check isClosed.

  // Accumulators for paginated active-game loading.
  List<GameEntity> _activeGames = const [];
  DateTime? _activeCursor;

  // Latest games from the active stream, kept so action-success states
  // can render the list without flickering to empty.
  List<GameEntity> _games = const [];

  /// Realtime stream of open public upcoming games. New games created by
  /// anyone appear automatically.
  void watchActiveGames() {
    emit(const GameLoading());
    _subscription?.cancel();
    _subscription = _repository.watchActiveGames().listen(
      (games) {
        if (!isClosed) {
          _games = games;
          emit(GameLoaded(games: games));
        }
      },
      onError: (Object e) {
        if (!isClosed) emit(GameError(e.toString()));
      },
    );
  }

  /// Realtime stream of games the user hosts or has joined.
  void watchMyGames(String uid) {
    emit(const GameLoading());
    _subscription?.cancel();
    _subscription = _repository.watchMyGames(uid).listen(
      (games) {
        if (!isClosed) {
          _games = games;
          emit(GameLoaded(games: games));
        }
      },
      onError: (Object e) {
        if (!isClosed) emit(GameError(e.toString()));
      },
    );
  }

  /// One-shot load (kept for non-realtime callers).
  Future<void> loadActiveGames() async {
    emit(const GameLoading());
    final result = await _repository.getActiveGames();
    if (isClosed) return;
    result.fold(
      (failure) => emit(GameError(failure.message)),
      (games) {
        _games = games;
        emit(GameLoaded(games: games));
      },
    );
  }

  /// Paginated, one-shot load of active games that mirrors
  /// `GET /games/?status=&city=&level=&date=&page=&page_size=`.
  ///
  /// Pass [loadMore] to append the next page (using the last page's
  /// `nextCursor`). The first call resets the accumulated list.
  Future<void> loadActiveGamesPage({
    GameStatus? status,
    String? city,
    GameLevel? level,
    DateTime? date,
    int pageSize = 20,
    bool loadMore = false,
  }) async {
    if (!loadMore) {
      emit(const GameLoading());
      _activeGames = const [];
      _activeCursor = null;
    }
    final result = await _repository.getActiveGamesPage(
      status: status,
      city: city,
      level: level,
      date: date,
      startAfter: _activeCursor,
      pageSize: pageSize,
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(GameError(failure.message)),
      (page) {
        _activeGames = [..._activeGames, ...page.games];
        _activeCursor = page.nextCursor;
        _games = _activeGames;
        emit(
          GameLoaded(
            games: _activeGames,
            hasMore: page.hasMore,
            nextCursor: page.nextCursor,
          ),
        );
      },
    );
  }

  /// One-shot "My Games" load with optional role/status filters, mirroring
  /// `GET /games/my/?role=&status=`.
  Future<void> loadMyGames(
    String uid, {
    String? role,
    String? status,
  }) async {
    emit(const GameLoading());
    final result = await _repository.getMyGames(
      uid,
      role: role,
      status: status,
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(GameError(failure.message)),
      (games) {
        _games = games;
        emit(GameLoaded(games: games));
      },
    );
  }

  /// Create a new game lobby. Realtime listeners pick it up automatically.
  Future<void> createGame(GameEntity game) async {
    emit(const GameLoading());
    final result = await _repository.createGame(game);
    if (isClosed) return;
    result.fold(
      (failure) => emit(GameError(failure.message)),
      (createdGame) => emit(GameCreated(game: createdGame)),
    );
  }

  /// Join a game lobby.
  Future<void> joinGame(String gameId, String playerId) async {
    final result = await _repository.joinGame(gameId, playerId);
    if (isClosed) return;
    result.fold(
      (failure) => emit(GameError(failure.message)),
      (_) => emit(GameActionSuccess(
        message: 'You joined the game',
        games: _games,
      )),
    );
  }

  /// Leave a game lobby.
  Future<void> leaveGame(String gameId, String playerId) async {
    final result = await _repository.leaveGame(gameId, playerId);
    if (isClosed) return;
    result.fold(
      (failure) => emit(GameError(failure.message)),
      (_) => emit(GameActionSuccess(
        message: 'You left the game',
        games: _games,
      )),
    );
  }

  /// Host-only: cancel a game (status = cancelled).
  Future<void> cancelGame(String gameId, String hostId) async {
    emit(const GameLoading());
    final result = await _repository.cancelGame(gameId, hostId);
    if (isClosed) return;
    result.fold(
      (failure) => emit(GameError(failure.message)),
      (game) => emit(GameCancelled(game: game)),
    );
  }

  /// Load the players of a game with their profiles.
  Future<void> getPlayers(String gameId) async {
    emit(const GameLoading());
    final result = await _repository.getPlayers(gameId);
    if (isClosed) return;
    result.fold(
      (failure) => emit(GameError(failure.message)),
      (players) => emit(GamePlayersLoaded(players: players)),
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
