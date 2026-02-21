import 'package:equatable/equatable.dart';
import 'package:basketvibe/features/games/domain/entities/game_entity.dart';

sealed class GameState extends Equatable {
  const GameState();

  @override
  List<Object?> get props => [];
}

class GameInitial extends GameState {
  const GameInitial();
}

class GameLoading extends GameState {
  const GameLoading();
}

class GameLoaded extends GameState {
  const GameLoaded({required this.games});

  final List<GameEntity> games;

  @override
  List<Object?> get props => [games];
}

class GameCreated extends GameState {
  const GameCreated({required this.game});

  final GameEntity game;

  @override
  List<Object?> get props => [game];
}

class GameError extends GameState {
  const GameError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
