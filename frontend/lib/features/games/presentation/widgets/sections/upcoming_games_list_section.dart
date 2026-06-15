import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:basketvibe/core/styles/app_colors.dart';
import 'package:basketvibe/core/styles/app_spacing.dart';
import 'package:basketvibe/core/styles/app_text_styles.dart';
import 'package:basketvibe/features/games/domain/entities/game_entity.dart';
import 'package:basketvibe/features/games/presentation/widgets/cards/upcoming_game_card.dart';

/// Vertical list of upcoming games using the same card design as home carousel.
class UpcomingGamesListSection extends StatelessWidget {
  const UpcomingGamesListSection({
    super.key,
    required this.games,
    this.onTapGame,
  });

  final List<GameEntity> games;
  final void Function(GameEntity game)? onTapGame;

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
        if (games.isEmpty)
          Text(
            'Пока нет предстоящих игр. Создайте первую!',
            style: AppTextStyles.bodyMD.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          )
        else
          ...games.map(
            (game) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: UpcomingGameCard(
                courtName: game.courtName,
                time: DateFormat('HH:mm').format(game.startTime),
                spots: '${game.currentPlayers}/${game.maxPlayers}',
                isLive: game.status == GameStatus.inProgress,
                onTap: onTapGame == null ? null : () => onTapGame!(game),
              ),
            ),
          ),
      ],
    );
  }
}
