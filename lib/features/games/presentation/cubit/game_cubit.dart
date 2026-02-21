import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:basketvibe/features/games/domain/entities/game_entity.dart';
import 'package:basketvibe/features/games/domain/repositories/game_repository.dart';
import 'package:basketvibe/features/games/presentation/cubit/game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit(this._repository) : super(const GameInitial());

  final GameRepository _repository;

  /// Load all active game lobbies.
  Future<void> loadActiveGames() async {
    emit(const GameLoading());
    final result = await _repository.getActiveGames();
    result.fold(
      (failure) => emit(GameError(failure.message)),
      (games) => emit(GameLoaded(games: games)),
    );
  }

  /// Create a new game lobby.
  Future<void> createGame(GameEntity game) async {
    emit(const GameLoading());
    final result = await _repository.createGame(game);
    result.fold(
      (failure) => emit(GameError(failure.message)),
      (createdGame) {
        emit(GameCreated(game: createdGame));
        // Reload active games to include the new one
        loadActiveGames();
      },
    );
  }

  /// Join a game lobby.
  Future<void> joinGame(String gameId, String playerId) async {
    final result = await _repository.joinGame(gameId, playerId);
    result.fold(
      (failure) => emit(GameError(failure.message)),
      (_) {
        // Reload active games to reflect the change
        loadActiveGames();
      },
    );
  }

  /// Leave a game lobby.
  Future<void> leaveGame(String gameId, String playerId) async {
    final result = await _repository.leaveGame(gameId, playerId);
    result.fold(
      (failure) => emit(GameError(failure.message)),
      (_) {
        // Reload active games to reflect the change
        loadActiveGames();
      },
    );
  }
}
