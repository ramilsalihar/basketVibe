import 'package:flutter/material.dart';
import 'package:basketvibe/core/styles/app_colors.dart';
import 'package:basketvibe/core/styles/app_spacing.dart';
import 'package:basketvibe/core/styles/app_text_styles.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: ListView(
        padding: AppSpacing.pagePadding,
        children: [
          Text(
            'Your activity history',
            style: AppTextStyles.h2.copyWith(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          AppSpacing.gapMD,
          _HistoryTile(
            title: 'Joined Evening Run',
            subtitle: 'Yesterday, 19:30 · Восток-5',
            isDark: isDark,
          ),
          _HistoryTile(
            title: 'Hosted 3x3 game',
            subtitle: '2 days ago, 20:00 · Бишкек Арена',
            isDark: isDark,
          ),
          _HistoryTile(
            title: 'Completed game',
            subtitle: 'Last week · Спартак',
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({
    required this.title,
    required this.subtitle,
    required this.isDark,
  });

  final String title;
  final String subtitle;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(Icons.history_rounded, color: AppColors.primary),
        title: Text(
          title,
          style: AppTextStyles.labelLG.copyWith(
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTextStyles.bodySM.copyWith(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
      ),
    );
  }
}

