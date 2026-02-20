import 'package:flutter/material.dart';
import 'package:basketvibe/core/styles/app_colors.dart';
import 'package:basketvibe/features/home/presentation/widgets/home_feed_content.dart';

/// Full-screen home feed (used as first tab in logged-in home).
class HomeFeedPage extends StatelessWidget {
  const HomeFeedPage({
    super.key,
    this.notificationCount = 0,
  });

  final int notificationCount;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: SafeArea(
        child: HomeFeedContent(notificationCount: notificationCount),
      ),
    );
  }
}
