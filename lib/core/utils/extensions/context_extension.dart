import 'package:flutter/material.dart';
import '../../styles/app_colors.dart';

extension ContextExtension on BuildContext {
  /// Get theme brightness
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  /// Get theme colors based on brightness
  Color get backgroundColor =>
      isDark ? AppColors.darkBg : AppColors.lightBg;

  Color get surfaceColor =>
      isDark ? AppColors.darkSurface : AppColors.lightSurface;

  Color get surfaceColor2 =>
      isDark ? AppColors.darkSurface2 : AppColors.lightSurface2;

  Color get textPrimaryColor =>
      isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

  Color get textSecondaryColor =>
      isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

  Color get borderColor =>
      isDark ? AppColors.darkBorder : AppColors.lightBorder;

  /// Show snackbar
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Get screen size
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
}
