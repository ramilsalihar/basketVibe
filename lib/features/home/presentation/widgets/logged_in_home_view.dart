import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:basketvibe/core/constants/route_constants.dart';
import 'package:basketvibe/core/styles/app_colors.dart';
import 'package:basketvibe/core/styles/app_spacing.dart';
import 'package:basketvibe/core/styles/app_text_styles.dart';
import 'package:basketvibe/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:basketvibe/features/home/presentation/pages/home_feed_page.dart';
import 'package:basketvibe/features/home/presentation/widgets/bottom_nav_bar.dart';

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
          const HomeFeedPage(notificationCount: 2),
          _CourtsTabPlaceholder(isDark: Theme.of(context).brightness == Brightness.dark),
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

class _CourtsTabPlaceholder extends StatelessWidget {
  const _CourtsTabPlaceholder({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.pagePadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.map_outlined,
              size: 64,
              color: AppColors.primary,
            ),
            AppSpacing.gapLG,
            Text(
              'Площадки',
              style: AppTextStyles.h1.copyWith(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
            AppSpacing.gapSM,
            Text(
              'Карта площадок, фильтры и список кортов',
              style: AppTextStyles.bodyMD.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.gapXL,
            ElevatedButton.icon(
              onPressed: () => context.push(RouteConstants.courts),
              icon: const Icon(Icons.map),
              label: const Text('Открыть карту площадок'),
            ),
          ],
        ),
      ),
    );
  }
}
