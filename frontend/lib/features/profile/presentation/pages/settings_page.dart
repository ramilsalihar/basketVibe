import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:basketvibe/core/app/locale_cubit.dart';
import 'package:basketvibe/core/app/theme_cubit.dart';
import 'package:basketvibe/core/l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
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
        ],
      ),
    );
  }
}
