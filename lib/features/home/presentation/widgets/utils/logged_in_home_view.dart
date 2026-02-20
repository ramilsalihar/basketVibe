import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:basketvibe/core/styles/app_colors.dart';
import 'package:basketvibe/core/styles/app_spacing.dart';
import 'package:basketvibe/core/styles/app_text_styles.dart';
import 'package:basketvibe/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:basketvibe/features/courts/presentation/pages/court_finder_page.dart';
import 'package:basketvibe/features/home/presentation/pages/home_feed_page.dart';
import 'package:basketvibe/features/home/presentation/widgets/utils/bottom_nav_bar.dart';

class LoggedInHomeView extends StatefulWidget {
  const LoggedInHomeView({super.key});

  @override
  State<LoggedInHomeView> createState() => _LoggedInHomeViewState();
}

class _LoggedInHomeViewState extends State<LoggedInHomeView> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeFeedPage(
            notificationCount: 2,
            onNavigateToCourts: () => setState(() => _currentIndex = 1),
          ),
          const CourtFinderPage(),
          _buildProfileTab(context),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }

  Widget _buildProfileTab(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person,
            size: 64,
            color: AppColors.primary,
          ),
          AppSpacing.gapLG,
          Text(
            'Профиль',
            style: AppTextStyles.h1.copyWith(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          AppSpacing.gapXL,
          OutlinedButton.icon(
            onPressed: () => context.read<AuthCubit>().logout(),
            icon: const Icon(Icons.logout, size: 20),
            label: const Text('Выйти'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: const BorderSide(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
