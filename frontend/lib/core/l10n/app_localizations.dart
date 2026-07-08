import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark theme'**
  String get darkTheme;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageRussian.
  ///
  /// In en, this message translates to:
  /// **'Русский'**
  String get languageRussian;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get login;

  /// No description provided for @loginRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in required'**
  String get loginRequiredTitle;

  /// No description provided for @loginRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Sign in to your account to continue.'**
  String get loginRequiredMessage;

  /// No description provided for @createGameLoginMessage.
  ///
  /// In en, this message translates to:
  /// **'Sign in to create a game.'**
  String get createGameLoginMessage;

  /// No description provided for @joinGameLoginMessage.
  ///
  /// In en, this message translates to:
  /// **'Sign in to join.'**
  String get joinGameLoginMessage;

  /// No description provided for @authLockTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to your account'**
  String get authLockTitle;

  /// No description provided for @authLockProfileMessage.
  ///
  /// In en, this message translates to:
  /// **'Sign in to see your profile and game history.'**
  String get authLockProfileMessage;

  /// No description provided for @profileMyProfile.
  ///
  /// In en, this message translates to:
  /// **'My profile'**
  String get profileMyProfile;

  /// No description provided for @profileEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get profileEdit;

  /// No description provided for @profileName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get profileName;

  /// No description provided for @profileCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get profileCity;

  /// No description provided for @profileSkillLevel.
  ///
  /// In en, this message translates to:
  /// **'Skill level'**
  String get profileSkillLevel;

  /// No description provided for @profileGamesPlayed.
  ///
  /// In en, this message translates to:
  /// **'Games played: {count}'**
  String profileGamesPlayed(int count);

  /// No description provided for @profileCityLine.
  ///
  /// In en, this message translates to:
  /// **'City: {city}'**
  String profileCityLine(String city);

  /// No description provided for @profileLevelLine.
  ///
  /// In en, this message translates to:
  /// **'Level: {level}'**
  String profileLevelLine(String level);

  /// No description provided for @profileEnterName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get profileEnterName;

  /// No description provided for @profileNotSignedIn.
  ///
  /// In en, this message translates to:
  /// **'Not signed in'**
  String get profileNotSignedIn;

  /// No description provided for @skillBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get skillBeginner;

  /// No description provided for @skillIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get skillIntermediate;

  /// No description provided for @skillAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get skillAdvanced;

  /// No description provided for @skillPro.
  ///
  /// In en, this message translates to:
  /// **'Pro'**
  String get skillPro;

  /// No description provided for @profileHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get profileHistory;

  /// No description provided for @profileOpenHistory.
  ///
  /// In en, this message translates to:
  /// **'Open activity history'**
  String get profileOpenHistory;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete account?'**
  String get deleteAccountConfirm;

  /// No description provided for @deleteAccountConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete your account and all your games. This cannot be undone.'**
  String get deleteAccountConfirmMessage;

  /// No description provided for @gamesTitle.
  ///
  /// In en, this message translates to:
  /// **'Upcoming games'**
  String get gamesTitle;

  /// No description provided for @gamesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No games yet'**
  String get gamesEmptyTitle;

  /// No description provided for @gamesEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a game and call players to the court.'**
  String get gamesEmptySubtitle;

  /// No description provided for @gamesCreate.
  ///
  /// In en, this message translates to:
  /// **'Create game'**
  String get gamesCreate;

  /// No description provided for @gamesJoin.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get gamesJoin;

  /// No description provided for @gamesFull.
  ///
  /// In en, this message translates to:
  /// **'Game is full'**
  String get gamesFull;

  /// No description provided for @courtsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Places to play'**
  String get courtsSectionTitle;

  /// No description provided for @courtsTitle.
  ///
  /// In en, this message translates to:
  /// **'Courts'**
  String get courtsTitle;

  /// No description provided for @courtsNotFound.
  ///
  /// In en, this message translates to:
  /// **'No courts found'**
  String get courtsNotFound;

  /// No description provided for @courtsFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get courtsFilterAll;

  /// No description provided for @courtsFilterIndoor.
  ///
  /// In en, this message translates to:
  /// **'Indoor'**
  String get courtsFilterIndoor;

  /// No description provided for @courtsFilterOutdoor.
  ///
  /// In en, this message translates to:
  /// **'Outdoor'**
  String get courtsFilterOutdoor;

  /// No description provided for @courtsFilterFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get courtsFilterFree;

  /// No description provided for @courtsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load courts'**
  String get courtsLoadError;

  /// No description provided for @courtsOpenHours.
  ///
  /// In en, this message translates to:
  /// **'Opening hours'**
  String get courtsOpenHours;

  /// No description provided for @courtsWhatsappError.
  ///
  /// In en, this message translates to:
  /// **'Could not open WhatsApp'**
  String get courtsWhatsappError;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @createGameTitle.
  ///
  /// In en, this message translates to:
  /// **'Host a game'**
  String get createGameTitle;

  /// No description provided for @createGameTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title *'**
  String get createGameTitleLabel;

  /// No description provided for @createGameTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Evening Run, 3x3 Tournament'**
  String get createGameTitleHint;

  /// No description provided for @createGameTitleError.
  ///
  /// In en, this message translates to:
  /// **'Enter a title'**
  String get createGameTitleError;

  /// No description provided for @createGameDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get createGameDescription;

  /// No description provided for @createGameDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 3x3, intermediate, bring dark tee'**
  String get createGameDescriptionHint;

  /// No description provided for @createGameCourtLabel.
  ///
  /// In en, this message translates to:
  /// **'Court *'**
  String get createGameCourtLabel;

  /// No description provided for @createGameLoadingCourts.
  ///
  /// In en, this message translates to:
  /// **'Loading courts…'**
  String get createGameLoadingCourts;

  /// No description provided for @createGameChooseCourt.
  ///
  /// In en, this message translates to:
  /// **'Choose a court'**
  String get createGameChooseCourt;

  /// No description provided for @createGameLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location *'**
  String get createGameLocationLabel;

  /// No description provided for @createGameLocationHint.
  ///
  /// In en, this message translates to:
  /// **'Paste a map link or address'**
  String get createGameLocationHint;

  /// No description provided for @createGameLocationError.
  ///
  /// In en, this message translates to:
  /// **'Enter a location'**
  String get createGameLocationError;

  /// No description provided for @createGameDate.
  ///
  /// In en, this message translates to:
  /// **'Date *'**
  String get createGameDate;

  /// No description provided for @createGameTime.
  ///
  /// In en, this message translates to:
  /// **'Time *'**
  String get createGameTime;

  /// No description provided for @createGameMaxPlayers.
  ///
  /// In en, this message translates to:
  /// **'Max players *'**
  String get createGameMaxPlayers;

  /// No description provided for @createGameMaxPlayersError.
  ///
  /// In en, this message translates to:
  /// **'Enter number of players'**
  String get createGameMaxPlayersError;

  /// No description provided for @createGameMaxPlayersRange.
  ///
  /// In en, this message translates to:
  /// **'Between 2 and 20'**
  String get createGameMaxPlayersRange;

  /// No description provided for @createGameVisibility.
  ///
  /// In en, this message translates to:
  /// **'Visibility'**
  String get createGameVisibility;

  /// No description provided for @visibilityPublic.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get visibilityPublic;

  /// No description provided for @visibilityPrivate.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get visibilityPrivate;

  /// No description provided for @visibilityPublicHint.
  ///
  /// In en, this message translates to:
  /// **'Anyone can find and join'**
  String get visibilityPublicHint;

  /// No description provided for @visibilityPrivateHint.
  ///
  /// In en, this message translates to:
  /// **'Only people with the link'**
  String get visibilityPrivateHint;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTitle;

  /// No description provided for @historyEmpty.
  ///
  /// In en, this message translates to:
  /// **'No games yet. Join or host one!'**
  String get historyEmpty;

  /// No description provided for @createGamePayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get createGamePayment;

  /// No description provided for @paymentOnline.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get paymentOnline;

  /// No description provided for @paymentCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get paymentCash;

  /// No description provided for @paymentFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get paymentFree;

  /// No description provided for @inDevelopment.
  ///
  /// In en, this message translates to:
  /// **'In development'**
  String get inDevelopment;

  /// No description provided for @createGameAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount to bring'**
  String get createGameAmount;

  /// No description provided for @createGameAmountHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 500'**
  String get createGameAmountHint;

  /// No description provided for @createGameSubmit.
  ///
  /// In en, this message translates to:
  /// **'Host game'**
  String get createGameSubmit;

  /// No description provided for @createGameSelectDateTime.
  ///
  /// In en, this message translates to:
  /// **'Select date and time'**
  String get createGameSelectDateTime;

  /// No description provided for @createGameInvalidAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get createGameInvalidAmount;

  /// No description provided for @createGameSuccess.
  ///
  /// In en, this message translates to:
  /// **'Run created successfully!'**
  String get createGameSuccess;

  /// No description provided for @createGameYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get createGameYou;

  /// No description provided for @homeLocation.
  ///
  /// In en, this message translates to:
  /// **'Bishkek, Kyrgyzstan'**
  String get homeLocation;

  /// No description provided for @tickerMessage1.
  ///
  /// In en, this message translates to:
  /// **'12 players just checked into Vostok-5... 3 spots for 5v5 at Bishkek Arena at 19:00'**
  String get tickerMessage1;

  /// No description provided for @tickerMessage2.
  ///
  /// In en, this message translates to:
  /// **'New run at 18:30 at Spartak — 4/10 spots'**
  String get tickerMessage2;

  /// No description provided for @tickerMessage3.
  ///
  /// In en, this message translates to:
  /// **'Vostok-5 is hot right now — 8 people on the court'**
  String get tickerMessage3;

  /// No description provided for @gamesSpots.
  ///
  /// In en, this message translates to:
  /// **'Spots: {spots}'**
  String gamesSpots(Object spots);

  /// No description provided for @gamesLeave.
  ///
  /// In en, this message translates to:
  /// **'Leave game'**
  String get gamesLeave;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
