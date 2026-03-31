import 'package:flutter/material.dart';
import 'package:basketvibe/core/styles/app_border_radius.dart';
import 'package:basketvibe/core/styles/app_colors.dart';
import 'package:basketvibe/core/styles/app_spacing.dart';
import 'package:basketvibe/core/styles/app_text_styles.dart';

/// Reusable app dialog helper for custom bottom-sheet content.
class AppDialog {
  AppDialog._();

  /// Shows a custom bottom sheet.
  ///
  /// Pass any widget through [content] to render your custom UI.
  static Future<T?> showBottomSheet<T>({
    required BuildContext context,
    required Widget content,
    String? title,
    List<Widget>? actions,
    bool isScrollControlled = true,
    bool isDismissible = true,
    bool enableDrag = true,
    EdgeInsetsGeometry padding = AppSpacing.pagePadding,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: padding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      borderRadius: AppRadius.brPill,
                    ),
                  ),
                ),
                if (title != null) ...[
                  Text(
                    title,
                    style: AppTextStyles.h2.copyWith(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  AppSpacing.gapMD,
                ],
                content,
                if (actions != null && actions.isNotEmpty) ...[
                  AppSpacing.gapLG,
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.end,
                    children: actions,
                  ),
                ],
                SizedBox(height: MediaQuery.of(sheetContext).viewInsets.bottom),
              ],
            ),
          ),
        );
      },
    );
  }
}

