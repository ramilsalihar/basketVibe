import 'package:flutter/material.dart';
import 'package:basketvibe/core/styles/app_colors.dart';
import 'package:basketvibe/core/styles/app_spacing.dart';
import 'package:basketvibe/core/styles/app_text_styles.dart';
import 'package:basketvibe/core/styles/app_border_radius.dart';

class TopRatedCourtsSection extends StatelessWidget {
  const TopRatedCourtsSection({super.key});

  static const List<Map<String, dynamic>> _mockCourts = [
    {'name': 'Восток-5', 'rating': 4.8, 'reviews': 124},
    {'name': 'Спартак', 'rating': 4.6, 'reviews': 89},
    {'name': 'Бишкек Арена', 'rating': 4.9, 'reviews': 56},
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
            'Топ площадок за неделю',
            style: AppTextStyles.h2.copyWith(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _mockCourts.length,
            itemBuilder: (context, index) {
              final c = _mockCourts[index];
              return _CourtChip(
                name: c['name'] as String,
                rating: c['rating'] as double,
                reviews: c['reviews'] as int,
                isDark: isDark,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CourtChip extends StatelessWidget {
  const _CourtChip({
    required this.name,
    required this.rating,
    required this.reviews,
    required this.isDark,
  });

  final String name;
  final double rating;
  final int reviews;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: AppRadius.brMD,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            style: AppTextStyles.labelLG.copyWith(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.star, size: 16, color: AppColors.accentYellow),
              const SizedBox(width: 4),
              Text(
                rating.toString(),
                style: AppTextStyles.labelMD.copyWith(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$reviews отзывов',
                style: AppTextStyles.bodySM.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
