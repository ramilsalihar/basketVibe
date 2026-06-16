import 'package:flutter/material.dart';
import 'package:basketvibe/core/styles/app_colors.dart';

/// Rounded, floating, app-colored snackbars.
///
/// Use the static methods anywhere ([AppSnackbar.error]), or mix
/// [SnackbarMixin] into a widget for the instance-style helpers.
class AppSnackbar {
  AppSnackbar._();

  static void error(BuildContext context, String message) => _show(
        context,
        message: message,
        icon: Icons.error_outline_rounded,
        color: AppColors.error,
      );

  static void success(BuildContext context, String message) => _show(
        context,
        message: message,
        icon: Icons.check_circle_outline_rounded,
        color: AppColors.success,
      );

  static void alert(BuildContext context, String message) => _show(
        context,
        message: message,
        icon: Icons.warning_amber_rounded,
        color: AppColors.warning,
      );

  static void _show(
    BuildContext context, {
    required String message,
    required IconData icon,
    required Color color,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor:
              isDark ? AppColors.darkSurface : AppColors.lightSurface,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: color.withValues(alpha: 0.5)),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        ),
      );
  }
}

/// Instance-style helpers for widgets: `class X with SnackbarMixin`.
mixin SnackbarMixin {
  void showErrorSnackbar(BuildContext context, String message) =>
      AppSnackbar.error(context, message);

  void showSuccessSnackbar(BuildContext context, String message) =>
      AppSnackbar.success(context, message);

  void showAlertSnackbar(BuildContext context, String message) =>
      AppSnackbar.alert(context, message);
}
