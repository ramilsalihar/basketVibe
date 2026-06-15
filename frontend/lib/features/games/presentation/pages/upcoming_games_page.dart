import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:basketvibe/core/network/injection.dart';
import 'package:basketvibe/core/styles/app_colors.dart';
import 'package:basketvibe/core/styles/app_spacing.dart';
import 'package:basketvibe/core/styles/app_text_styles.dart';
import 'package:basketvibe/features/games/domain/entities/game_entity.dart';
import 'package:basketvibe/features/games/presentation/cubit/game_cubit.dart';
import 'package:basketvibe/features/games/presentation/cubit/game_state.dart';
import 'package:basketvibe/features/games/presentation/pages/game_overview_page.dart';
import 'package:basketvibe/features/games/presentation/widgets/sections/upcoming_games_list_section.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Full-page tab for upcoming games list, loaded from Firestore.
class UpcomingGamesPage extends StatelessWidget {
  const UpcomingGamesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<GameCubit>()..loadActiveGames(),
      child: const _UpcomingGamesView(),
    );
  }
}

class _UpcomingGamesView extends StatelessWidget {
  const _UpcomingGamesView();

  static final _skeletonGames = List.generate(
    3,
    (i) => GameEntity(
      id: 'skeleton_$i',
      courtId: '',
      courtName: 'Court name',
      city: '',
      address: '',
      hostId: '',
      hostName: '',
      startTime: DateTime(2030),
      duration: const Duration(hours: 2),
      maxPlayers: 10,
      currentPlayers: 0,
      visibility: GameVisibility.public,
      level: GameLevel.balanced,
      status: GameStatus.open,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => context.read<GameCubit>().loadActiveGames(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: AppSpacing.pagePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: kToolbarHeight),
                BlocBuilder<GameCubit, GameState>(
                  builder: (context, state) {
                    return switch (state) {
                      GameInitial() || GameLoading() => Skeletonizer(
                          enabled: true,
                          child: UpcomingGamesListSection(
                            games: _skeletonGames,
                          ),
                        ),
                      GameError(:final message) => _GamesErrorView(
                          message: message,
                          onRetry: () =>
                              context.read<GameCubit>().loadActiveGames(),
                        ),
                      _ => UpcomingGamesListSection(
                          games: state is GameLoaded
                              ? state.games
                              : const <GameEntity>[],
                          onTapGame: (game) {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) =>
                                    GameOverviewPage(gameId: game.id),
                              ),
                            );
                          },
                        ),
                    };
                  },
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GamesErrorView extends StatelessWidget {
  const _GamesErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Icon(Icons.error_outline_rounded, color: AppColors.error, size: 44),
        AppSpacing.gapMD,
        Text(
          message,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMD.copyWith(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
        AppSpacing.gapMD,
        OutlinedButton(
          onPressed: onRetry,
          child: const Text('Попробовать снова'),
        ),
      ],
    );
  }
}
