import 'package:flutter/material.dart';
import 'package:basketvibe/core/styles/app_spacing.dart';
import 'package:basketvibe/features/courts/presentation/widgets/utils/mini_map_preview.dart';
import 'package:basketvibe/features/home/presentation/widgets/utils/active_runs_carousel.dart';
import 'package:basketvibe/features/home/presentation/widgets/utils/baseline_feed_section.dart';
import 'package:basketvibe/features/home/presentation/widgets/utils/home_quick_action_header.dart';
import 'package:basketvibe/features/home/presentation/widgets/utils/leaderboard_section.dart';
import 'package:basketvibe/features/home/presentation/widgets/utils/top_rated_courts_section.dart';
import 'package:basketvibe/features/home/presentation/widgets/utils/upcoming_events_section.dart';
import 'package:basketvibe/features/home/presentation/widgets/utils/whos_balling_ticker.dart';

/// Main home feed: header, ticker, active runs, baseline, court finder, events, top courts, leaderboard.
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
        const SliverToBoxAdapter(
          child: ActiveRunsCarousel(),
        ),
        SliverToBoxAdapter(
          child: AppSpacing.gapXL,
        ),
        const SliverToBoxAdapter(
          child: BaselineFeedSection(),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: AppSpacing.pagePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSpacing.gapXL,
                MiniMapPreview(onTap: onNavigateToCourts),
                AppSpacing.gapXL,
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: UpcomingEventsSection(),
        ),
        SliverToBoxAdapter(
          child: AppSpacing.gapXL,
        ),
        const SliverToBoxAdapter(
          child: TopRatedCourtsSection(),
        ),
        SliverToBoxAdapter(
          child: AppSpacing.gapXL,
        ),
        const SliverToBoxAdapter(
          child: LeaderboardSection(),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 100),
        ),
      ],
    );
  }
}
