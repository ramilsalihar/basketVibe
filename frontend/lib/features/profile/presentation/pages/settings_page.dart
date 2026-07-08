import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:basketvibe/core/app/locale_cubit.dart';
import 'package:basketvibe/core/app/theme_cubit.dart';
import 'package:basketvibe/core/constants/route_constants.dart';
import 'package:basketvibe/core/l10n/app_localizations.dart';
import 'package:basketvibe/core/utils/snackbars/app_snackbar.dart';
import 'package:basketvibe/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:basketvibe/features/auth/presentation/cubit/auth_state.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _deleting = false;

  Future<void> _requestDelete(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteAccountConfirm),
        content: Text(l10n.deleteAccountConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.deleteAccount),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    setState(() => _deleting = true);
    await context.read<AuthCubit>().deleteAccount();
    if (context.mounted) setState(() => _deleting = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.go(RouteConstants.login);
        } else if (state is AuthError) {
          AppSnackbar.error(context, state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.settingsTitle)),
        body: ListView(
          children: [
            BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, themeMode) {
                final isDarkMode = themeMode == ThemeMode.dark;
                return SwitchListTile(
                  title: Text(l10n.darkTheme),
                  secondary: Icon(
                    isDarkMode
                        ? Icons.dark_mode_rounded
                        : Icons.light_mode_rounded,
                  ),
                  value: isDarkMode,
                  onChanged: (_) => context.read<ThemeCubit>().toggleThemeMode(),
                );
              },
            ),
            const Divider(height: 1),
            BlocBuilder<LocaleCubit, Locale>(
              builder: (context, locale) {
                return ListTile(
                  leading: const Icon(Icons.language_rounded),
                  title: Text(l10n.language),
                  trailing: SegmentedButton<String>(
                    segments: [
                      ButtonSegment(
                        value: 'en',
                        label: Text(l10n.languageEnglish),
                      ),
                      ButtonSegment(
                        value: 'ru',
                        label: Text(l10n.languageRussian),
                      ),
                    ],
                    selected: {locale.languageCode},
                    showSelectedIcon: false,
                    onSelectionChanged: (selection) =>
                        context.read<LocaleCubit>().setLocale(
                              Locale(selection.first),
                            ),
                  ),
                );
              },
            ),
            const Divider(height: 1),
            ListTile(
              enabled: !_deleting,
              leading: const Icon(Icons.delete_forever_rounded, color: Colors.red),
              title: Text(
                l10n.deleteAccount,
                style: const TextStyle(color: Colors.red),
              ),
              onTap: _deleting ? null : () => _requestDelete(context),
              trailing: _deleting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
