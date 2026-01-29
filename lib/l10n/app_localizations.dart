import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('fr')
  ];

  /// Watch box label
  ///
  /// In en, this message translates to:
  /// **'Watch Box'**
  String get watchBox;

  /// No description provided for @collection.
  ///
  /// In en, this message translates to:
  /// **'Collection'**
  String get collection;

  /// No description provided for @stats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get stats;

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @appData.
  ///
  /// In en, this message translates to:
  /// **'App Data'**
  String get appData;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @removeAds.
  ///
  /// In en, this message translates to:
  /// **'Remove Ads'**
  String get removeAds;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support WristTrack'**
  String get support;

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'Leave an app review'**
  String get review;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @follow.
  ///
  /// In en, this message translates to:
  /// **'Follow WristTrack'**
  String get follow;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email Feedback'**
  String get email;

  /// No description provided for @languageLink.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLink;

  /// No description provided for @reminderLink.
  ///
  /// In en, this message translates to:
  /// **'Daily Reminder'**
  String get reminderLink;

  /// No description provided for @currencyLink.
  ///
  /// In en, this message translates to:
  /// **'Currency Options'**
  String get currencyLink;

  /// No description provided for @chartOptionsLink.
  ///
  /// In en, this message translates to:
  /// **'Chart Options'**
  String get chartOptionsLink;

  /// No description provided for @appPreferencesLink.
  ///
  /// In en, this message translates to:
  /// **'App Preferences'**
  String get appPreferencesLink;

  /// No description provided for @showArchiveLink.
  ///
  /// In en, this message translates to:
  /// **'Show Archived Watches'**
  String get showArchiveLink;

  /// No description provided for @showDemoLink.
  ///
  /// In en, this message translates to:
  /// **'Show First Use Demo'**
  String get showDemoLink;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version: '**
  String get appVersion;

  /// No description provided for @unknownAppVersionText.
  ///
  /// In en, this message translates to:
  /// **'Not determined'**
  String get unknownAppVersionText;

  /// No description provided for @wearStatsButton.
  ///
  /// In en, this message translates to:
  /// **'Wear Stats'**
  String get wearStatsButton;

  /// No description provided for @collectionStatsButton.
  ///
  /// In en, this message translates to:
  /// **'Collection Stats'**
  String get collectionStatsButton;

  /// No description provided for @wristRecap.
  ///
  /// In en, this message translates to:
  /// **'Wrist Recap'**
  String get wristRecap;

  /// No description provided for @lastSync.
  ///
  /// In en, this message translates to:
  /// **'Last Synced:'**
  String get lastSync;

  /// No description provided for @deviation.
  ///
  /// In en, this message translates to:
  /// **'System time deviation:'**
  String get deviation;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'Sync in progress - displaying system time...'**
  String get inProgress;

  /// No description provided for @beepCountdown.
  ///
  /// In en, this message translates to:
  /// **'Beep Countdown'**
  String get beepCountdown;

  /// No description provided for @timeFormat.
  ///
  /// In en, this message translates to:
  /// **'24 hour time'**
  String get timeFormat;

  /// No description provided for @moonPhase.
  ///
  /// In en, this message translates to:
  /// **'Current Moon Phase'**
  String get moonPhase;
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
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
