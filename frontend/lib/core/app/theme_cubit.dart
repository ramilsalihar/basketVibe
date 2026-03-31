import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:basketvibe/core/local_storage/local_storage_keys.dart';
import 'package:basketvibe/core/local_storage/local_storage_service.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(this._localStorage) : super(ThemeMode.system);

  final LocalStorageService _localStorage;

  Future<void> loadThemeMode() async {
    final raw = await _localStorage.getString(LocalStorageKeys.themeMode);
    emit(_fromRaw(raw));
  }

  Future<void> toggleThemeMode() async {
    final next = switch (state) {
      ThemeMode.dark => ThemeMode.light,
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.system => ThemeMode.dark,
    };
    emit(next);
    await _localStorage.setString(LocalStorageKeys.themeMode, _toRaw(next));
  }

  String _toRaw(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.system => 'system',
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
    };
  }

  ThemeMode _fromRaw(String? raw) {
    return switch (raw) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }
}

