import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:basketvibe/core/constants/route_constants.dart';
import 'package:basketvibe/core/styles/app_colors.dart';

/// Pop-up shown to guests who try a feature that needs an account.
/// "Войти" sends them to the login page.
Future<void> showLoginRequiredDialog(
  BuildContext context, {
  String message = 'Войдите в аккаунт, чтобы продолжить.',
}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        icon: const Icon(
          Icons.lock_outline_rounded,
          color: AppColors.primary,
          size: 32,
        ),
        title: const Text('Требуется вход'),
        content: Text(message, textAlign: TextAlign.center),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Отмена'),
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.go(RouteConstants.login);
            },
            icon: const Icon(Icons.login_rounded, size: 18),
            label: const Text('Войти'),
          ),
        ],
      );
    },
  );
}
