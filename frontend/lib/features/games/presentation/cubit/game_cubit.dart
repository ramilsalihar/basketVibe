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

  /// Realtime stream of open public upcoming games. New games created by
  /// anyone appear automatically.
  void watchActiveGames() {
    emit(const GameLoading());
    _subscription?.cancel();
    _subscription = _repository.watchActiveGames().listen(
      (games) {
        if (!isClosed) emit(GameLoaded(games: games));
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
        if (!isClosed) emit(GameLoaded(games: games));
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
      (games) => emit(GameLoaded(games: games)),
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
      (_) {},
    );
  }

  /// Leave a game lobby.
  Future<void> leaveGame(String gameId, String playerId) async {
    final result = await _repository.leaveGame(gameId, playerId);
    if (isClosed) return;
    result.fold(
      (failure) => emit(GameError(failure.message)),
      (_) {},
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
