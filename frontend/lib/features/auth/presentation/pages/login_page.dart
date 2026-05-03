import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:basketvibe/core/constants/route_constants.dart';
import 'package:basketvibe/core/styles/app_colors.dart';
import 'package:basketvibe/core/styles/app_text_styles.dart';
import 'package:basketvibe/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:basketvibe/features/auth/presentation/cubit/auth_state.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            if (state.isNewUser) {
              context.go(RouteConstants.onboarding);
            } else {
              context.go(RouteConstants.home);
            }
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // Logo
                  Image.asset(
                    'assets/logo/app_logo.png',
                    width: 100,
                    height: 100,
                  ),

                  const SizedBox(height: 24),

                  // App name
                  Text(
                    'LineUp',
                    style: AppTextStyles.h1.copyWith(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Find your next run',
                    style: AppTextStyles.bodyMD.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),

                  const Spacer(flex: 3),

                  // Google sign-in button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      onPressed: isLoading
                          ? null
                          : () => context.read<AuthCubit>().googleSignIn(),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: isDark
                            ? AppColors.darkSurface
                            : AppColors.lightSurface,
                      ),
                      child: isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primary,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _GoogleLogo(),
                                const SizedBox(width: 12),
                                Text(
                                  'Continue with Google',
                                  style: AppTextStyles.buttonMD.copyWith(
                                    color: isDark
                                        ? AppColors.darkTextPrimary
                                        : AppColors.lightTextPrimary,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),

                  const Spacer(flex: 1),

                  Text(
                    'By continuing, you agree to our Terms of Service\nand Privacy Policy',
                    style: AppTextStyles.bodySM.copyWith(
                      color: isDark
                          ? AppColors.darkTextMuted
                          : AppColors.lightTextMuted,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 12),

                  TextButton(
                    onPressed: () => context.go(RouteConstants.home),
                    child: Text(
                      'Continue without registration',
                      style: AppTextStyles.bodySM.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _GoogleLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(painter: _GoogleLogoPainter()),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Red (top-right)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.05,
      1.57,
      false,
      Paint()
        ..color = const Color(0xFFEA4335)
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.2,
    );
    // Yellow (bottom)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0.52,
      1.57,
      false,
      Paint()
        ..color = const Color(0xFFFBBC05)
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.2,
    );
    // Green (bottom-left)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      2.09,
      0.79,
      false,
      Paint()
        ..color = const Color(0xFF34A853)
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.2,
    );
    // Blue (left)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      2.88,
      1.74,
      false,
      Paint()
        ..color = const Color(0xFF4285F4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.2,
    );

    // Blue horizontal bar
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.5,
        size.height * 0.38,
        size.width * 0.5,
        size.height * 0.24,
      ),
      Paint()..color = const Color(0xFF4285F4),
    );
  }

  @override
  bool shouldRepaint(_GoogleLogoPainter old) => false;
}
