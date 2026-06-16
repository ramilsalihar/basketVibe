import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:basketvibe/core/local_storage/local_storage_keys.dart';
import 'package:basketvibe/core/local_storage/local_storage_service.dart';

/// Holds the app locale and persists the choice. Defaults to Russian.
class LocaleCubit extends Cubit<Locale> {
  LocaleCubit(this._localStorage) : super(const Locale('ru'));

  final LocalStorageService _localStorage;

  static const supported = [Locale('en'), Locale('ru')];

  Future<void> loadLocale() async {
    final raw = await _localStorage.getString(LocalStorageKeys.language);
    if (raw != null && raw.isNotEmpty) {
      emit(Locale(raw));
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (locale.languageCode == state.languageCode) return;
    emit(locale);
    await _localStorage.setString(
      LocalStorageKeys.language,
      locale.languageCode,
    );
  }
}
