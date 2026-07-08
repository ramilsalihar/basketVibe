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
  String get deleteAccount => 'Delete account';

  @override
  String get deleteAccountConfirm => 'Delete account?';

  @override
  String get deleteAccountConfirmMessage =>
      'This will permanently delete your account and all your games. This cannot be undone.';

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
  String get gamesJoin => 'Join';

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

  @override
  String get done => 'Done';

  @override
  String get createGameTitle => 'Host a game';

  @override
  String get createGameTitleLabel => 'Title *';

  @override
  String get createGameTitleHint => 'e.g. Evening Run, 3x3 Tournament';

  @override
  String get createGameTitleError => 'Enter a title';

  @override
  String get createGameDescription => 'Description';

  @override
  String get createGameDescriptionHint =>
      'e.g. 3x3, intermediate, bring dark tee';

  @override
  String get createGameCourtLabel => 'Court *';

  @override
  String get createGameLoadingCourts => 'Loading courts…';

  @override
  String get createGameChooseCourt => 'Choose a court';

  @override
  String get createGameLocationLabel => 'Location *';

  @override
  String get createGameLocationHint => 'Paste a map link or address';

  @override
  String get createGameLocationError => 'Enter a location';

  @override
  String get createGameDate => 'Date *';

  @override
  String get createGameTime => 'Time *';

  @override
  String get createGameMaxPlayers => 'Max players *';

  @override
  String get createGameMaxPlayersError => 'Enter number of players';

  @override
  String get createGameMaxPlayersRange => 'Between 2 and 20';

  @override
  String get createGameVisibility => 'Visibility';

  @override
  String get visibilityPublic => 'Public';

  @override
  String get visibilityPrivate => 'Private';

  @override
  String get visibilityPublicHint => 'Anyone can find and join';

  @override
  String get visibilityPrivateHint => 'Only people with the link';

  @override
  String get historyTitle => 'History';

  @override
  String get historyEmpty => 'No games yet. Join or host one!';

  @override
  String get createGamePayment => 'Payment';

  @override
  String get paymentOnline => 'Online';

  @override
  String get paymentCash => 'Cash';

  @override
  String get paymentFree => 'Free';

  @override
  String get inDevelopment => 'In development';

  @override
  String get createGameAmount => 'Amount to bring';

  @override
  String get createGameAmountHint => 'e.g. 500';

  @override
  String get createGameSubmit => 'Host game';

  @override
  String get createGameSelectDateTime => 'Select date and time';

  @override
  String get createGameInvalidAmount => 'Enter a valid amount';

  @override
  String get createGameSuccess => 'Run created successfully!';

  @override
  String get createGameYou => 'You';

  @override
  String get homeLocation => 'Bishkek, Kyrgyzstan';

  @override
  String get tickerMessage1 =>
      '12 players just checked into Vostok-5... 3 spots for 5v5 at Bishkek Arena at 19:00';

  @override
  String get tickerMessage2 => 'New run at 18:30 at Spartak — 4/10 spots';

  @override
  String get tickerMessage3 =>
      'Vostok-5 is hot right now — 8 people on the court';

  @override
  String gamesSpots(Object spots) {
    return 'Spots: $spots';
  }

  @override
  String get gamesLeave => 'Leave game';
}
