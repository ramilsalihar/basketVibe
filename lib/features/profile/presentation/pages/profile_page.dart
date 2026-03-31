import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:basketvibe/core/app/theme_cubit.dart';
import 'package:basketvibe/core/styles/app_colors.dart';
import 'package:basketvibe/core/styles/app_spacing.dart';
import 'package:basketvibe/core/styles/app_text_styles.dart';
import 'package:basketvibe/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:basketvibe/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:basketvibe/features/profile/domain/usecases/get_profile_use_case.dart';
import 'package:basketvibe/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:basketvibe/features/profile/presentation/cubit/profile_state.dart';
import 'package:basketvibe/features/profile/presentation/pages/history/history_page.dart';
import 'package:basketvibe/features/profile/presentation/widgets/cards/profile_info_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
    required this.userId,
    required this.onLogout,
  });

  final String userId;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(
        GetProfileUseCase(
          const ProfileRepositoryImpl(
            ProfileLocalDataSource(),
          ),
        ),
      )..loadProfile(userId),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return switch (state) {
            ProfileInitial() || ProfileLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            ProfileError(:final message) => _ProfileErrorView(
                message: message,
                onRetry: () => context.read<ProfileCubit>().loadProfile(userId),
              ),
            ProfileLoaded(:final profile) => _ProfileContentView(
                userName: profile.displayName,
                profileCard: ProfileInfoCard(profile: profile),
                onLogout: onLogout,
              ),
          };
        },
      ),
    );
  }
}

class _ProfileContentView extends StatelessWidget {
  const _ProfileContentView({
    required this.userName,
    required this.profileCard,
    required this.onLogout,
  });

  final String userName;
  final Widget profileCard;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: AppSpacing.pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: kToolbarHeight),
          AppSpacing.gapLG,
          Row(
            children: [
              _AvatarPhoto(
                name: userName,
              ),
              AppSpacing.rowGapMD,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: AppTextStyles.h2.copyWith(
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    AppSpacing.gapXS,
                    Text(
                      'My profile',
                      style: AppTextStyles.bodySM.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Settings',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Settings in development')),
                  );
                },
                icon: Icon(
                  Icons.settings_rounded,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          AppSpacing.gapLG,
          profileCard,
          AppSpacing.gapMD,
          TextFormField(
            readOnly: true,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const HistoryPage(),
                ),
              );
            },
            decoration: const InputDecoration(
              labelText: 'History',
              hintText: 'Open activity history',
              suffixIcon: Icon(Icons.chevron_right_rounded),
              prefixIcon: Icon(Icons.history_rounded),
            ),
          ),
          AppSpacing.gapMD,
          OutlinedButton.icon(
            onPressed: () => context.read<ThemeCubit>().toggleThemeMode(),
            icon: Icon(
              isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              size: 20,
            ),
            label: Text(
              isDarkMode ? 'Switch to light theme' : 'Switch to dark theme',
            ),
          ),
          AppSpacing.gapXL,
          OutlinedButton.icon(
            onPressed: onLogout,
            icon: const Icon(Icons.logout_rounded, size: 20),
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

class _ProfileErrorView extends StatelessWidget {
  const _ProfileErrorView({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: AppSpacing.pagePadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, color: AppColors.error, size: 44),
            AppSpacing.gapMD,
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMD.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            AppSpacing.gapMD,
            OutlinedButton(
              onPressed: onRetry,
              child: const Text('Попробовать снова'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AvatarPhoto extends StatelessWidget {
  const _AvatarPhoto({
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      width: 72,
      child: ClipOval(
        child: Image.network(
          'https://i.pravatar.cc/300?u=$name',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: AppColors.primaryMuted,
            alignment: Alignment.center,
            child: Text(
              name.isEmpty ? 'P' : name.substring(0, 1).toUpperCase(),
              style: AppTextStyles.h2.copyWith(color: AppColors.primary),
            ),
          ),
        ),
      ),
    );
  }
}

