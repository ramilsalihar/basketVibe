// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get settingsTitle => 'Settings';

  @override
  String get darkTheme => 'Dark theme';

  @override
  String get language => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageRussian => 'Русский';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get retry => 'Try again';

  @override
  String get login => 'Log in';

  @override
  String get loginRequiredTitle => 'Sign in required';

  @override
  String get loginRequiredMessage => 'Sign in to your account to continue.';

  @override
  String get createGameLoginMessage => 'Sign in to create a game.';

  @override
  String get joinGameLoginMessage => 'Sign in to join.';

  @override
  String get authLockTitle => 'Sign in to your account';

  @override
  String get authLockProfileMessage =>
      'Sign in to see your profile and game history.';

  @override
  String get profileMyProfile => 'My profile';

  @override
  String get profileEdit => 'Edit profile';

  @override
  String get profileName => 'Name';

  @override
  String get profileCity => 'City';

  @override
  String get profileSkillLevel => 'Skill level';

  @override
  String profileGamesPlayed(int count) {
    return 'Games played: $count';
  }

  @override
  String profileCityLine(String city) {
    return 'City: $city';
  }

  @override
  String profileLevelLine(String level) {
    return 'Level: $level';
  }

  @override
  String get profileEnterName => 'Enter your name';

  @override
  String get profileNotSignedIn => 'Not signed in';

  @override
  String get skillBeginner => 'Beginner';

  @override
  String get skillIntermediate => 'Intermediate';

  @override
  String get skillAdvanced => 'Advanced';

  @override
  String get skillPro => 'Pro';

  @override
  String get profileHistory => 'History';

  @override
  String get profileOpenHistory => 'Open activity history';

  @override
  String get logout => 'Log out';

  @override
  String get gamesTitle => 'Upcoming games';

  @override
  String get gamesEmptyTitle => 'No games yet';

  @override
  String get gamesEmptySubtitle =>
      'Create a game and call players to the court.';

  @override
  String get gamesCreate => 'Create game';

  @override
  String get gamesJoin => 'Join game';

  @override
  String get gamesFull => 'Game is full';

  @override
  String get courtsSectionTitle => 'Places to play';

  @override
  String get courtsTitle => 'Courts';

  @override
  String get courtsNotFound => 'No courts found';

  @override
  String get courtsFilterAll => 'All';

  @override
  String get courtsFilterIndoor => 'Indoor';

  @override
  String get courtsFilterOutdoor => 'Outdoor';

  @override
  String get courtsFilterFree => 'Free';

  @override
  String get courtsLoadError => 'Failed to load courts';

  @override
  String get courtsOpenHours => 'Opening hours';

  @override
  String get courtsWhatsappError => 'Could not open WhatsApp';
}
