import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:basketvibe/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:basketvibe/core/styles/app_colors.dart';
import 'package:basketvibe/core/styles/app_spacing.dart';
import 'package:basketvibe/core/styles/app_text_styles.dart';
import 'package:basketvibe/core/network/injection.dart';
import 'package:basketvibe/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:basketvibe/features/profile/presentation/cubit/profile_state.dart';
import 'package:basketvibe/features/profile/domain/entities/profile_entity.dart';
import 'package:basketvibe/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:basketvibe/features/profile/presentation/pages/history/history_page.dart';
import 'package:basketvibe/features/profile/presentation/pages/settings_page.dart';
import 'package:basketvibe/features/profile/presentation/widgets/cards/profile_info_card.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProfileCubit>()..loadProfile(userId),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return switch (state) {
            ProfileInitial() || ProfileLoading() => Skeletonizer(
                enabled: true,
                child: _ProfileContentView(
                  userName: 'Player Name',
                  profileCard: ProfileInfoCard(
                    profile: const ProfileEntity(
                      id: '',
                      displayName: 'Player Name',
                      city: 'City name',
                      skillLevel: 'intermediate',
                      gamesPlayed: 0,
                    ),
                  ),
                ),
              ),
            ProfileError(:final message) => _ProfileErrorView(
                message: message,
                onRetry: () => context.read<ProfileCubit>().loadProfile(userId),
              ),
            ProfileLoaded(:final profile) => _ProfileContentView(
                userName: profile.displayName,
                avatarUrl: profile.avatarUrl,
                profileCard: ProfileInfoCard(
                  profile: profile,
                  onEdit: () {
                    final cubit = context.read<ProfileCubit>();
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => BlocProvider.value(
                          value: cubit,
                          child: EditProfilePage(profile: profile),
                        ),
                      ),
                    );
                  },
                ),
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
    this.avatarUrl,
  });

  final String userName;
  final Widget profileCard;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                avatarUrl: avatarUrl,
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
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const SettingsPage(),
                    ),
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
          AppSpacing.gapXL,
          OutlinedButton.icon(
            onPressed: () => context.read<AuthCubit>().logout(),
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
    this.avatarUrl,
  });

  final String name;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    final url = avatarUrl;

    return SizedBox(
      height: 72,
      width: 72,
      child: ClipOval(
        child: url == null || url.isEmpty
            ? const _AnimatedDefaultAvatar()
            : Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const _AnimatedDefaultAvatar(),
              ),
      ),
    );
  }
}

/// Default avatar when the user has no photo: the male SVG with a
/// gentle breathing animation.
class _AnimatedDefaultAvatar extends StatefulWidget {
  const _AnimatedDefaultAvatar();

  @override
  State<_AnimatedDefaultAvatar> createState() => _AnimatedDefaultAvatarState();
}

class _AnimatedDefaultAvatarState extends State<_AnimatedDefaultAvatar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: SvgPicture.asset(
        'assets/icons/avatar_male.svg',
        fit: BoxFit.cover,
      ),
    );
  }
}

