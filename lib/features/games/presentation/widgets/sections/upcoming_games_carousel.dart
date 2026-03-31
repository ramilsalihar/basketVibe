import 'package:flutter/material.dart';
import 'package:basketvibe/core/styles/app_spacing.dart';
import 'package:basketvibe/core/styles/app_text_styles.dart';
import 'package:basketvibe/core/styles/app_colors.dart';
import 'package:basketvibe/features/games/presentation/widgets/cards/upcoming_game_card.dart';

class UpcomingGamesCarousel extends StatelessWidget {
  const UpcomingGamesCarousel({
    super.key,
    this.onTapGame,
  });

  final VoidCallback? onTapGame;

  static const List<Map<String, dynamic>> mockGames = [
    {
      'court': 'Восток-5',
      'time': '18:30',
      'spots': '3/10',
      'isLive': true,
    },
    {
      'court': 'Бишкек Арена',
      'time': '19:00',
      'spots': '5/10',
      'isLive': true,
    },
    {
      'court': 'Спартак',
      'time': '20:00',
      'spots': '7/10',
      'isLive': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppSpacing.pagePadding,
          child: Text(
            'Предстоящие игры',
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
            itemCount: mockGames.length,
            itemBuilder: (context, index) {
              final game = mockGames[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: UpcomingGameCard(
                  width: 180,
                  courtName: game['court'] as String,
                  time: game['time'] as String,
                  spots: game['spots'] as String,
                  isLive: game['isLive'] as bool,
                  onTap: onTapGame,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

