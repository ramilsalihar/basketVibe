import 'package:flutter/material.dart';
import 'package:basketvibe/core/styles/app_colors.dart';
import 'package:basketvibe/core/styles/app_spacing.dart';
import 'package:basketvibe/core/styles/app_text_styles.dart';
import 'package:basketvibe/core/styles/app_border_radius.dart';

class ActiveRunsCarousel extends StatelessWidget {
  const ActiveRunsCarousel({super.key});

  static const List<Map<String, dynamic>> _mockRuns = [
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
            'Активные раны',
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
            itemCount: _mockRuns.length,
            itemBuilder: (context, index) {
              final run = _mockRuns[index];
              return _ActiveRunCard(
                courtName: run['court'] as String,
                time: run['time'] as String,
                spots: run['spots'] as String,
                isLive: run['isLive'] as bool,
                isDark: isDark,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ActiveRunCard extends StatelessWidget {
  const _ActiveRunCard({
    required this.courtName,
    required this.time,
    required this.spots,
    required this.isLive,
    required this.isDark,
  });

  final String courtName;
  final String time;
  final String spots;
  final bool isLive;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 12),
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: AppRadius.brMD,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: AppColors.lightShadow,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (isLive)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.success.withOpacity(0.6),
                        blurRadius: 4,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: Text(
                  courtName,
                  style: AppTextStyles.labelLG.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Text(
            time,
            style: AppTextStyles.h3.copyWith(
              color: AppColors.primary,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Мест: $spots',
                style: AppTextStyles.labelSM.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
              Text(
                'Присоединиться',
                style: AppTextStyles.labelSM.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
