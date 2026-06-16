import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:basketvibe/core/styles/app_spacing.dart';
import 'package:basketvibe/core/styles/app_text_styles.dart';
import 'package:basketvibe/core/styles/app_colors.dart';
import 'package:basketvibe/features/games/domain/entities/game_entity.dart';
import 'package:basketvibe/features/games/presentation/widgets/cards/upcoming_game_card.dart';
import 'package:basketvibe/core/l10n/app_localizations.dart';

class UpcomingGamesCarousel extends StatelessWidget {
  const UpcomingGamesCarousel({
    super.key,
    required this.games,
    this.onTapGame,
  });

  final List<GameEntity> games;
  final void Function(GameEntity game)? onTapGame;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (games.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppSpacing.pagePadding,
          child: Text(
            AppLocalizations.of(context).gamesTitle,
            style: AppTextStyles.h2.copyWith(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 132,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: games.length,
            itemBuilder: (context, index) {
              final game = games[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: UpcomingGameCard(
                  width: 180,
                  courtName: game.courtName,
                  time: DateFormat('HH:mm').format(game.startTime),
                  spots: '${game.currentPlayers}/${game.maxPlayers}',
                  isLive: game.status == GameStatus.inProgress,
                  onTap: onTapGame == null ? null : () => onTapGame!(game),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
