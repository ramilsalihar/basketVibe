import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:basketvibe/core/constants/route_constants.dart';
import 'package:basketvibe/core/styles/app_colors.dart';
import 'package:basketvibe/core/styles/app_spacing.dart';
import 'package:basketvibe/core/styles/app_text_styles.dart';

class GuestHomeView extends StatelessWidget {
  const GuestHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Padding(
        padding: AppSpacing.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppSpacing.gapXL,

            // Hero
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryButtonGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.25),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.sports_basketball,
                  size: 48,
                  color: Colors.white,
                ),
              ),
            ),

            AppSpacing.gapXL,

            Text(
              'Run with your city',
              style: AppTextStyles.h1.copyWith(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
              textAlign: TextAlign.center,
            ),

            AppSpacing.gapSM,

            Text(
              'Находи площадки, создавай игры и делись моментами с баскетбольным комьюнити.',
              style: AppTextStyles.bodyMD.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),

            const Spacer(),

            // CTAs
            ElevatedButton(
              onPressed: () => context.push(RouteConstants.login),
              child: Text('Войти', style: AppTextStyles.buttonLG),
            ),

            AppSpacing.gapLG,

            OutlinedButton(
              onPressed: () {
                // TODO: Navigate to register when implemented
                context.push(RouteConstants.login);
              },
              child: Text(
                'Зарегистрироваться',
                style: AppTextStyles.buttonMD,
              ),
            ),

            AppSpacing.gapXL,
          ],
        ),
      ),
    );
  }
}
