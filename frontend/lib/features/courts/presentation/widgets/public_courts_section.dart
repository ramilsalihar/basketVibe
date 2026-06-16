import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:basketvibe/core/styles/app_border_radius.dart';
import 'package:basketvibe/core/styles/app_colors.dart';
import 'package:basketvibe/core/styles/app_spacing.dart';
import 'package:basketvibe/core/styles/app_text_styles.dart';
import 'package:basketvibe/features/courts/data/models/court_model.dart';
import 'package:basketvibe/features/courts/presentation/cubit/courts_cubit.dart';
import 'package:basketvibe/features/courts/presentation/cubit/courts_state.dart';
import 'package:basketvibe/core/l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Horizontally scrolling "public places to play" section, driven by the
/// surrounding [CourtsCubit].
class PublicCourtsSection extends StatelessWidget {
  const PublicCourtsSection({super.key, this.onTapCourt});

  /// Called with the tapped court (e.g. open the court finder map).
  final void Function(CourtModel court)? onTapCourt;

  static const _skeletonCourts = [
    CourtModel(
      id: '',
      name: 'Court name',
      address: 'Street address',
      city: '',
      lat: 0,
      lng: 0,
      isFree: true,
      type: 'outdoor',
      schedule: '09:00 - 23:00',
    ),
    CourtModel(
      id: '',
      name: 'Court name',
      address: 'Street address',
      city: '',
      lat: 0,
      lng: 0,
      isFree: true,
      type: 'outdoor',
      schedule: '09:00 - 23:00',
    ),
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
            AppLocalizations.of(context).courtsSectionTitle,
            style: AppTextStyles.h2.copyWith(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
        ),
        const SizedBox(height: 8),
        BlocBuilder<CourtsCubit, CourtsState>(
          builder: (context, state) {
            if (state.status == CourtsStatus.error) {
              return Padding(
                padding: AppSpacing.pagePadding,
                child: Text(
                  AppLocalizations.of(context).courtsLoadError,
                  style: AppTextStyles.bodyMD.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              );
            }

            final loading = state.status == CourtsStatus.loading ||
                state.status == CourtsStatus.initial;
            final courts = loading ? _skeletonCourts : state.courts;

            if (courts.isEmpty) return const SizedBox.shrink();

            return Skeletonizer(
              enabled: loading,
              child: SizedBox(
                height: 210,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: courts.length,
                  itemBuilder: (context, index) {
                    final court = courts[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: _CourtCard(
                        court: court,
                        onTap: onTapCourt == null
                            ? null
                            : () => onTapCourt!(court),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _CourtCard extends StatelessWidget {
  const _CourtCard({required this.court, this.onTap});

  final CourtModel court;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: AppRadius.brMD,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 110,
                width: double.infinity,
                child: court.imageUrls.isEmpty
                    ? Container(
                        color: AppColors.primaryMuted,
                        child: Icon(
                          court.type == 'indoor'
                              ? Icons.warehouse_rounded
                              : Icons.park_rounded,
                          color: AppColors.primary,
                          size: 40,
                        ),
                      )
                    : CachedNetworkImage(
                        imageUrl: court.imageUrls.first,
                        fit: BoxFit.cover,
                        placeholder: (_, _) =>
                            Container(color: AppColors.primaryMuted),
                        errorWidget: (_, _, _) => Container(
                          color: AppColors.primaryMuted,
                          child: const Icon(
                            Icons.image_not_supported_rounded,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      court.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyLG.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (court.schedule.isNotEmpty)
                      Row(
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            size: 14,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            court.schedule,
                            style: AppTextStyles.bodySM.copyWith(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 2),
                    Text(
                      court.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySM.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
