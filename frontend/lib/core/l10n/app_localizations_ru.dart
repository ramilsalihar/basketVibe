// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get darkTheme => 'Тёмная тема';

  @override
  String get language => 'Язык';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageRussian => 'Русский';

  @override
  String get cancel => 'Отмена';

  @override
  String get save => 'Сохранить';

  @override
  String get retry => 'Попробовать снова';

  @override
  String get login => 'Войти';

  @override
  String get loginRequiredTitle => 'Требуется вход';

  @override
  String get loginRequiredMessage => 'Войдите в аккаунт, чтобы продолжить.';

  @override
  String get createGameLoginMessage => 'Войдите, чтобы создать игру.';

  @override
  String get joinGameLoginMessage => 'Войдите, чтобы присоединиться.';

  @override
  String get authLockTitle => 'Войдите в аккаунт';

  @override
  String get authLockProfileMessage =>
      'Войдите, чтобы видеть профиль и историю игр.';

  @override
  String get profileMyProfile => 'Мой профиль';

  @override
  String get profileEdit => 'Редактировать профиль';

  @override
  String get profileName => 'Имя';

  @override
  String get profileCity => 'Город';

  @override
  String get profileSkillLevel => 'Уровень';

  @override
  String profileGamesPlayed(int count) {
    return 'Сыграно игр: $count';
  }

  @override
  String profileCityLine(String city) {
    return 'Город: $city';
  }

  @override
  String profileLevelLine(String level) {
    return 'Уровень: $level';
  }

  @override
  String get profileEnterName => 'Введите имя';

  @override
  String get profileNotSignedIn => 'Вы не вошли';

  @override
  String get skillBeginner => 'Новичок';

  @override
  String get skillIntermediate => 'Средний';

  @override
  String get skillAdvanced => 'Продвинутый';

  @override
  String get skillPro => 'Профи';

  @override
  String get profileHistory => 'История';

  @override
  String get profileOpenHistory => 'Открыть историю активности';

  @override
  String get logout => 'Выйти';

  @override
  String get gamesTitle => 'Предстоящие игры';

  @override
  String get gamesEmptyTitle => 'Пока нет игр';

  @override
  String get gamesEmptySubtitle =>
      'Создайте игру и позовите игроков на площадку.';

  @override
  String get gamesCreate => 'Создать игру';

  @override
  String get gamesJoin => 'Присоединиться';

  @override
  String get gamesFull => 'Мест нет';

  @override
  String get courtsSectionTitle => 'Площадки для игры';

  @override
  String get courtsTitle => 'Площадки';

  @override
  String get courtsNotFound => 'Площадки не найдены';

  @override
  String get courtsFilterAll => 'Все';

  @override
  String get courtsFilterIndoor => 'Зал';

  @override
  String get courtsFilterOutdoor => 'Улица';

  @override
  String get courtsFilterFree => 'Бесплатно';

  @override
  String get courtsLoadError => 'Не удалось загрузить площадки';

  @override
  String get courtsOpenHours => 'Время работы';

  @override
  String get courtsWhatsappError => 'Не удалось открыть WhatsApp';
}
