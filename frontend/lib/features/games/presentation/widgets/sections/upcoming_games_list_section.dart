import 'package:flutter/material.dart';
import 'package:basketvibe/core/styles/app_colors.dart';
import 'package:basketvibe/core/styles/app_spacing.dart';
import 'package:basketvibe/core/styles/app_text_styles.dart';
import 'package:basketvibe/features/games/presentation/widgets/cards/upcoming_game_card.dart';
import 'package:basketvibe/features/games/presentation/widgets/sections/upcoming_games_carousel.dart';

/// Vertical list of upcoming games using the same card design as home carousel.
class UpcomingGamesListSection extends StatelessWidget {
  const UpcomingGamesListSection({
    super.key,
    this.onTapGame,
  });

  final VoidCallback? onTapGame;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Предстоящие игры',
          style: AppTextStyles.h2.copyWith(
            color:
                isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        AppSpacing.gapMD,
        ...UpcomingGamesCarousel.mockGames.map(
          (game) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: UpcomingGameCard(
              courtName: game['court'] as String,
              time: game['time'] as String,
              spots: game['spots'] as String,
              isLive: game['isLive'] as bool,
              onTap: onTapGame,
            ),
          ),
        ),
      ],
    );
  }
}

