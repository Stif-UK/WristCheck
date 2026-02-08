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

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @timeline.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get timeline;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'all'**
  String get all;

  /// No description provided for @january.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get january;

  /// No description provided for @february.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get february;

  /// No description provided for @march.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get march;

  /// No description provided for @april.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get april;

  /// No description provided for @may.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// No description provided for @june.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get june;

  /// No description provided for @july.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get july;

  /// No description provided for @august.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get august;

  /// No description provided for @september.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get september;

  /// No description provided for @october.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get october;

  /// No description provided for @november.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get november;

  /// No description provided for @december.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get december;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter:'**
  String get filter;

  /// No description provided for @wearsByDay.
  ///
  /// In en, this message translates to:
  /// **'Wears by Day'**
  String get wearsByDay;

  /// No description provided for @wearsByMonth.
  ///
  /// In en, this message translates to:
  /// **'Wears by Month'**
  String get wearsByMonth;

  /// No description provided for @wearsByYear.
  ///
  /// In en, this message translates to:
  /// **'Wears by Year'**
  String get wearsByYear;

  /// No description provided for @thisYear.
  ///
  /// In en, this message translates to:
  /// **'This Year'**
  String get thisYear;

  /// No description provided for @lastYear.
  ///
  /// In en, this message translates to:
  /// **'Last Year'**
  String get lastYear;

  /// No description provided for @last12Months.
  ///
  /// In en, this message translates to:
  /// **'Last 12 Months'**
  String get last12Months;

  /// No description provided for @last90days.
  ///
  /// In en, this message translates to:
  /// **'Last 90 Days'**
  String get last90days;

  /// No description provided for @pageTitleCollectionStats.
  ///
  /// In en, this message translates to:
  /// **'Collection Stats'**
  String get pageTitleCollectionStats;

  /// No description provided for @labelCharts.
  ///
  /// In en, this message translates to:
  /// **'Charts'**
  String get labelCharts;

  /// No description provided for @labelInfo.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get labelInfo;

  /// No description provided for @labelValue.
  ///
  /// In en, this message translates to:
  /// **'Value Data'**
  String get labelValue;

  /// No description provided for @collectionCost.
  ///
  /// In en, this message translates to:
  /// **'Current Collection Cost'**
  String get collectionCost;

  /// No description provided for @noValue.
  ///
  /// In en, this message translates to:
  /// **'No value captured'**
  String get noValue;

  /// No description provided for @totalSpend.
  ///
  /// In en, this message translates to:
  /// **'Total Collection Spend'**
  String get totalSpend;

  /// No description provided for @totalSold.
  ///
  /// In en, this message translates to:
  /// **'Total Sold Value'**
  String get totalSold;

  /// No description provided for @averageResale.
  ///
  /// In en, this message translates to:
  /// **'Average Resale %'**
  String get averageResale;

  /// No description provided for @noDataTracked.
  ///
  /// In en, this message translates to:
  /// **'No Data Tracked'**
  String get noDataTracked;

  /// No description provided for @resaleRatio.
  ///
  /// In en, this message translates to:
  /// **'Resale Ratio ='**
  String get resaleRatio;

  /// No description provided for @noDataRecorded.
  ///
  /// In en, this message translates to:
  /// **'No Data Recorded'**
  String get noDataRecorded;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @tellMeMore.
  ///
  /// In en, this message translates to:
  /// **'Tell me more'**
  String get tellMeMore;

  /// No description provided for @soldSuffix.
  ///
  /// In en, this message translates to:
  /// **'(Sold)'**
  String get soldSuffix;

  /// No description provided for @retiredSuffix.
  ///
  /// In en, this message translates to:
  /// **'(Retired)'**
  String get retiredSuffix;

  /// No description provided for @watchColon.
  ///
  /// In en, this message translates to:
  /// **'Watch:'**
  String get watchColon;

  /// No description provided for @deleting.
  ///
  /// In en, this message translates to:
  /// **'Deleting'**
  String get deleting;

  /// No description provided for @backupRestore.
  ///
  /// In en, this message translates to:
  /// **'Backup / Restore Database'**
  String get backupRestore;

  /// No description provided for @altExports.
  ///
  /// In en, this message translates to:
  /// **'Alternative Exports'**
  String get altExports;

  /// No description provided for @dataImport.
  ///
  /// In en, this message translates to:
  /// **'Data Import'**
  String get dataImport;

  /// No description provided for @deleteCollection.
  ///
  /// In en, this message translates to:
  /// **'Delete Collection'**
  String get deleteCollection;

  /// No description provided for @backupRestoreHeader.
  ///
  /// In en, this message translates to:
  /// **'Backup / Restore'**
  String get backupRestoreHeader;

  /// No description provided for @backup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backup;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @backupDatabase.
  ///
  /// In en, this message translates to:
  /// **'Backup Database'**
  String get backupDatabase;

  /// No description provided for @restoreDatabase.
  ///
  /// In en, this message translates to:
  /// **'Restore Database'**
  String get restoreDatabase;

  /// No description provided for @pleaseSelectFile.
  ///
  /// In en, this message translates to:
  /// **'Please select backup file'**
  String get pleaseSelectFile;

  /// No description provided for @selectFile.
  ///
  /// In en, this message translates to:
  /// **'Select Backup File'**
  String get selectFile;

  /// No description provided for @fileSelected.
  ///
  /// In en, this message translates to:
  /// **'File selected: '**
  String get fileSelected;

  /// No description provided for @readyToLoad.
  ///
  /// In en, this message translates to:
  /// **'Ready to load'**
  String get readyToLoad;

  /// No description provided for @restoreFromBackup.
  ///
  /// In en, this message translates to:
  /// **'Restore from Backup'**
  String get restoreFromBackup;

  /// No description provided for @backupWatchImages.
  ///
  /// In en, this message translates to:
  /// **'Backup Watch Images'**
  String get backupWatchImages;

  /// No description provided for @simpleExtractButton.
  ///
  /// In en, this message translates to:
  /// **'Simple Extract (CSV)'**
  String get simpleExtractButton;

  /// No description provided for @detailedExtractButton.
  ///
  /// In en, this message translates to:
  /// **'Detailed Extract (CSV)'**
  String get detailedExtractButton;

  /// No description provided for @wristTrackProFeature.
  ///
  /// In en, this message translates to:
  /// **'WristTrack Pro Feature'**
  String get wristTrackProFeature;

  /// No description provided for @track.
  ///
  /// In en, this message translates to:
  /// **'Track'**
  String get track;

  /// No description provided for @trackWear.
  ///
  /// In en, this message translates to:
  /// **'Track Wear'**
  String get trackWear;

  /// No description provided for @removeWear.
  ///
  /// In en, this message translates to:
  /// **'Remove Wear'**
  String get removeWear;

  /// No description provided for @removeDate.
  ///
  /// In en, this message translates to:
  /// **'Remove Date'**
  String get removeDate;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date:'**
  String get date;

  /// No description provided for @pickWatch.
  ///
  /// In en, this message translates to:
  /// **'Pick Watch'**
  String get pickWatch;

  /// No description provided for @pleaseSelectAWatch.
  ///
  /// In en, this message translates to:
  /// **'Please select a watch'**
  String get pleaseSelectAWatch;

  /// No description provided for @searchByName.
  ///
  /// In en, this message translates to:
  /// **'Search by watch name'**
  String get searchByName;

  /// No description provided for @deleteWear.
  ///
  /// In en, this message translates to:
  /// **'Delete Wear Record'**
  String get deleteWear;

  /// No description provided for @deleteFromCalendar.
  ///
  /// In en, this message translates to:
  /// **'Delete Wear from Calendar'**
  String get deleteFromCalendar;

  /// No description provided for @addWearToCalendar.
  ///
  /// In en, this message translates to:
  /// **'Add Wear to Calendar'**
  String get addWearToCalendar;

  /// No description provided for @serviceDue.
  ///
  /// In en, this message translates to:
  /// **'Service Due'**
  String get serviceDue;

  /// No description provided for @warrantyExpires.
  ///
  /// In en, this message translates to:
  /// **'Warranty Expires'**
  String get warrantyExpires;

  /// No description provided for @deliveryExpected.
  ///
  /// In en, this message translates to:
  /// **'delivery expected'**
  String get deliveryExpected;

  /// No description provided for @longPressToAddRemove.
  ///
  /// In en, this message translates to:
  /// **'Long press to add/remove wear dates'**
  String get longPressToAddRemove;

  /// No description provided for @tapToAddMultipleDates.
  ///
  /// In en, this message translates to:
  /// **'Tap here to add multiple dates'**
  String get tapToAddMultipleDates;

  /// No description provided for @deleteDate.
  ///
  /// In en, this message translates to:
  /// **'Delete Date'**
  String get deleteDate;

  /// No description provided for @watchWorn.
  ///
  /// In en, this message translates to:
  /// **'{watchName} worn'**
  String watchWorn(Object watchName);

  /// No description provided for @noDatesForWatch.
  ///
  /// In en, this message translates to:
  /// **'No dates recorded for this watch.'**
  String get noDatesForWatch;

  /// No description provided for @allDatesWorn.
  ///
  /// In en, this message translates to:
  /// **'All dates worn'**
  String get allDatesWorn;

  /// No description provided for @deleteWarning.
  ///
  /// In en, this message translates to:
  /// **'Pressing OK will delete all watch data, including your wishlist and all saved images\n \n THIS CANNOT BE UNDONE'**
  String get deleteWarning;

  /// No description provided for @backupInstruction.
  ///
  /// In en, this message translates to:
  /// **'Press the button below to create a copy of the app database (this can take a few seconds!). \n\nOnce created a \'share\' pop-up should appear, allowing you to choose where to send the backup file.  '**
  String get backupInstruction;

  /// No description provided for @imageBackupInstructions.
  ///
  /// In en, this message translates to:
  /// **'Watch Images can be separately exported.'**
  String get imageBackupInstructions;

  /// No description provided for @altExtractsGuidance.
  ///
  /// In en, this message translates to:
  /// **'**Alternative Data Extracts**\n\nThese options allow your watch and wear data to be extracted from **WristTrack**\n\nThey are meant to free your data, rather than as a backup _(see the Backup/Restore options if you are simply looking to move data from one device to another)._\n\nThe simple extract provides a list of all watch data, including wear count and notes **(one row per watch)**\n\nThe detailed extract provides a line of data for each **tracked wear date** and only includes watches which have been tracked as worn.**(multiple rows per watch)**\n\nThis raw data is output in CSV format, allowing easy import into your favourite spreadsheet application.'**
  String get altExtractsGuidance;

  /// No description provided for @watchChartsUpgradeCopy.
  ///
  /// In en, this message translates to:
  /// **'**Watch Wear Charts**\n\nWatch charts are a **WristTrack Pro** feature.\n\nThey allow you to view charts breaking down which months and days this watch has been worn.\n\nWant to know more about **WristTrack Pro**? Click the button below...'**
  String get watchChartsUpgradeCopy;
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
