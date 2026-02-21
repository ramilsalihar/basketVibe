import 'package:injectable/injectable.dart';
import 'package:basketvibe/features/games/data/repositories/game_repository_impl.dart';
import 'package:basketvibe/features/games/domain/repositories/game_repository.dart';
import 'package:basketvibe/features/games/presentation/cubit/game_cubit.dart';

@module
abstract class GameModule {
  @injectable
  GameRepository gameRepository() => GameRepositoryImpl();

  @injectable
  GameCubit gameCubit(GameRepository repository) => GameCubit(repository);
}
