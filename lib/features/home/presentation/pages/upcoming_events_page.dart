import 'package:flutter/material.dart';
import 'package:basketvibe/core/styles/app_colors.dart';
import 'package:basketvibe/core/styles/app_spacing.dart';
import 'package:basketvibe/features/home/presentation/widgets/utils/upcoming_events_section.dart';

/// Full-page tab for upcoming events / tournaments.
class UpcomingEventsPage extends StatelessWidget {
  const UpcomingEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.pagePadding,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              UpcomingEventsSection(),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
