import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:basketvibe/core/styles/app_colors.dart';
import 'package:basketvibe/core/styles/app_spacing.dart';
import 'package:basketvibe/core/styles/app_text_styles.dart';

/// Full-screen court finder with map, heatmap, and filters.
/// Map integration (e.g. google_maps_flutter) to be added later.
class CourtFinderPage extends StatelessWidget {
  const CourtFinderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        title: const Text('Площадки'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Placeholder for map
            Container(
              height: 220,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface2 : AppColors.lightSurface2,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.map_outlined,
                      size: 48,
                      color: isDark
                          ? AppColors.darkTextMuted
                          : AppColors.lightTextMuted,
                    ),
                    AppSpacing.gapSM,
                    Text(
                      'Карта площадок',
                      style: AppTextStyles.labelLG.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                    Text(
                      'Heatmap и список кортов — скоро',
                      style: AppTextStyles.bodySM.copyWith(
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AppSpacing.gapLG,
            // Quick filters
            Row(
              children: [
                _FilterChip(label: 'Зал', isSelected: false),
                const SizedBox(width: 8),
                _FilterChip(label: 'Улица', isSelected: true),
                const SizedBox(width: 8),
                _FilterChip(label: 'Бесплатно', isSelected: false),
              ],
            ),
            AppSpacing.gapXL,
            Text(
              'Популярные площадки',
              style: AppTextStyles.h2.copyWith(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
            AppSpacing.gapMD,
            _CourtListTile(name: 'Восток-5', subtitle: 'Улица · Бесплатно'),
            _CourtListTile(name: 'Спартак', subtitle: 'Зал · Платно'),
            _CourtListTile(name: 'Бишкек Арена', subtitle: 'Зал · Платно'),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.isSelected});

  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {},
      selectedColor: AppColors.primaryMuted,
      checkmarkColor: AppColors.primary,
    );
  }
}

class _CourtListTile extends StatelessWidget {
  const _CourtListTile({required this.name, required this.subtitle});

  final String name;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: AppColors.primaryMuted,
        child: const Icon(Icons.sports_basketball, color: AppColors.primary),
      ),
      title: Text(
        name,
        style: AppTextStyles.labelLG.copyWith(
          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
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
      trailing: const Icon(Icons.chevron_right),
      onTap: () {},
    );
  }
}
