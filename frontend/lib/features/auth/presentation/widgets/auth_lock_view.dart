import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:basketvibe/core/constants/route_constants.dart';
import 'package:basketvibe/core/styles/app_colors.dart';
import 'package:basketvibe/core/styles/app_spacing.dart';
import 'package:basketvibe/core/styles/app_text_styles.dart';

/// Shown to guests when they try to reach a feature that requires an
/// account. The button sends them to the login page.
class AuthLockView extends StatelessWidget {
  const AuthLockView({
    super.key,
    this.title = 'Войдите в аккаунт',
    this.message =
        'Эта возможность доступна только зарегистрированным игрокам.',
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: AppSpacing.pagePadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: AppColors.primaryMuted,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_outline_rounded,
                color: AppColors.primary,
                size: 34,
              ),
            ),
            AppSpacing.gapLG,
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.h2.copyWith(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
            AppSpacing.gapSM,
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMD.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            AppSpacing.gapLG,
            FilledButton.icon(
              onPressed: () => context.go(RouteConstants.login),
              icon: const Icon(Icons.login_rounded, size: 20),
              label: const Text('Войти'),
            ),
          ],
        ),
      ),
    );
  }
}
