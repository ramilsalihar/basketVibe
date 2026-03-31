import 'package:flutter/material.dart';
import 'package:basketvibe/core/styles/app_spacing.dart';
import 'package:basketvibe/features/games/presentation/pages/game_overview_page.dart';
import 'package:basketvibe/features/games/presentation/widgets/sections/upcoming_games_carousel.dart';
import 'package:basketvibe/features/home/presentation/widgets/sections/home_quick_action_header.dart';
import 'package:basketvibe/features/home/presentation/widgets/sections/upcoming_events_section.dart';
import 'package:basketvibe/features/home/presentation/widgets/sections/whos_balling_ticker.dart';

class HomeFeedContent extends StatelessWidget {
  const HomeFeedContent({
    super.key,
    this.notificationCount = 2,
    this.onNavigateToCourts,
  });

  final int notificationCount;
  final VoidCallback? onNavigateToCourts;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HomeQuickActionHeader(notificationCount: notificationCount),
              AppSpacing.gapSM,
              const WhosBallingTicker(),
              AppSpacing.gapLG,
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: UpcomingGamesCarousel(
            onTapGame: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const GameOverviewPage(),
                ),
              );
            },
          ),
        ),
        SliverToBoxAdapter(
          child: AppSpacing.gapXL,
        ),
        const SliverToBoxAdapter(
          child: UpcomingEventsSection(),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 100),
        ),
      ],
    );
  }
}

