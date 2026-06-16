import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:basketvibe/core/constants/route_constants.dart';
import 'package:basketvibe/core/styles/app_colors.dart';
import 'package:basketvibe/core/l10n/app_localizations.dart';

/// Pop-up shown to guests who try a feature that needs an account.
/// The confirm button sends them to the login page.
Future<void> showLoginRequiredDialog(
  BuildContext context, {
  String? message,
}) {
  final l10n = AppLocalizations.of(context);
  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        icon: const Icon(
          Icons.lock_outline_rounded,
          color: AppColors.primary,
          size: 32,
        ),
        title: Text(l10n.loginRequiredTitle),
        content: Text(
          message ?? l10n.loginRequiredMessage,
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.go(RouteConstants.login);
            },
            icon: const Icon(Icons.login_rounded, size: 18),
            label: Text(l10n.login),
          ),
        ],
      );
    },
  );
}
