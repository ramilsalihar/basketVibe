import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:basketvibe/core/network/injection.dart';
import 'package:basketvibe/core/styles/app_spacing.dart';
import 'package:basketvibe/features/games/presentation/cubit/game_cubit.dart';
import 'package:basketvibe/features/games/presentation/cubit/game_state.dart';
import 'package:basketvibe/features/games/presentation/pages/game_overview_page.dart';
import 'package:basketvibe/features/games/presentation/widgets/sections/upcoming_games_carousel.dart';
import 'package:basketvibe/features/home/presentation/widgets/sections/home_quick_action_header.dart';
import 'package:basketvibe/features/courts/data/models/court_model.dart';
import 'package:basketvibe/features/courts/presentation/widgets/public_courts_section.dart';
import 'package:basketvibe/features/home/presentation/widgets/sections/whos_balling_ticker.dart';

class HomeFeedContent extends StatelessWidget {
  const HomeFeedContent({
    super.key,
    this.notificationCount = 2,
    this.onNavigateToCourts,
    this.onOpenCourt,
  });

  final int notificationCount;
  final VoidCallback? onNavigateToCourts;
  final void Function(CourtModel court)? onOpenCourt;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<GameCubit>()..watchActiveGames(),
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HomeQuickActionHeader(notificationCount: notificationCount),
              AppSpacing.gapSM,
              // const WhosBallingTicker(),
              AppSpacing.gapLG,
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: BlocBuilder<GameCubit, GameState>(
            builder: (context, state) {
              return UpcomingGamesCarousel(
                games: state is GameLoaded ? state.games : const [],
                onTapGame: (game) {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => GameOverviewPage(gameId: game.id),
                    ),
                  );
                },
              );
            },
          ),
        ),
        SliverToBoxAdapter(child: AppSpacing.gapXL),
        SliverToBoxAdapter(
          child: PublicCourtsSection(
            onTapCourt: (court) => onOpenCourt?.call(court),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}
