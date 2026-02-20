import 'package:flutter/material.dart';
import 'package:basketvibe/core/styles/app_colors.dart';
import 'package:basketvibe/core/styles/app_spacing.dart';
import 'package:basketvibe/core/styles/app_text_styles.dart';
import 'package:basketvibe/core/styles/app_border_radius.dart';

/// "King of the Week" — most check-ins or highest-rated highlights.
class LeaderboardSection extends StatelessWidget {
  const LeaderboardSection({super.key});

  static const List<Map<String, dynamic>> _mockLeaders = [
    {'name': 'Алмаз К.', 'score': 24, 'label': 'чекинов'},
    {'name': 'Бектур М.', 'score': 18, 'label': 'чекинов'},
    {'name': 'Нурлан С.', 'score': 15, 'label': 'чекинов'},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppSpacing.pagePadding,
          child: Row(
            children: [
              Icon(
                Icons.emoji_events,
                size: 24,
                color: AppColors.accentYellow,
              ),
              const SizedBox(width: 8),
              Text(
                'Король недели',
                style: AppTextStyles.h2.copyWith(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          margin: AppSpacing.pagePadding,
          padding: AppSpacing.cardPadding,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: AppRadius.brMD,
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
          ),
          child: Column(
            children: [
              for (var i = 0; i < _mockLeaders.length; i++) ...[
                _LeaderTile(
                  rank: i + 1,
                  name: _mockLeaders[i]['name'] as String,
                  score: _mockLeaders[i]['score'] as int,
                  label: _mockLeaders[i]['label'] as String,
                  isDark: isDark,
                ),
                if (i < _mockLeaders.length - 1)
                  Divider(
                    height: 1,
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _LeaderTile extends StatelessWidget {
  const _LeaderTile({
    required this.rank,
    required this.name,
    required this.score,
    required this.label,
    required this.isDark,
  });

  final int rank;
  final String name;
  final int score;
  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: rank == 1
            ? AppColors.accentYellow.withOpacity(0.2)
            : (isDark ? AppColors.darkSurface2 : AppColors.lightSurface2),
        child: Text(
          '$rank',
          style: AppTextStyles.labelLG.copyWith(
            color: rank == 1 ? AppColors.accentYellow : (isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary),
          ),
        ),
      ),
      title: Text(
        name,
        style: AppTextStyles.labelLG.copyWith(
          color: isDark
              ? AppColors.darkTextPrimary
              : AppColors.lightTextPrimary,
        ),
      ),
      trailing: Text(
        '$score $label',
        style: AppTextStyles.labelMD.copyWith(
          color: AppColors.primary,
        ),
      ),
    );
  }
}
