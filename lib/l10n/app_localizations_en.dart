// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get watchBox => 'Watch Box';

  @override
  String get collection => 'Collection';

  @override
  String get stats => 'Stats';

  @override
  String get calendar => 'Calendar';

  @override
  String get time => 'Time';

  @override
  String get more => 'More';

  @override
  String get settings => 'Settings';

  @override
  String get appData => 'App Data';

  @override
  String get privacy => 'Privacy';

  @override
  String get removeAds => 'Remove Ads';

  @override
  String get support => 'Support WristTrack';

  @override
  String get review => 'Leave an app review';

  @override
  String get about => 'About';

  @override
  String get follow => 'Follow WristTrack';

  @override
  String get email => 'Email Feedback';

  @override
  String get languageLink => 'Language';

  @override
  String get reminderLink => 'Daily Reminder';

  @override
  String get currencyLink => 'Currency Options';

  @override
  String get chartOptionsLink => 'Chart Options';

  @override
  String get appPreferencesLink => 'App Preferences';

  @override
  String get showArchiveLink => 'Show Archived Watches';

  @override
  String get showDemoLink => 'Show First Use Demo';

  @override
  String get appVersion => 'App Version: ';

  @override
  String get unknownAppVersionText => 'Not determined';

  @override
  String get wearStatsButton => 'Wear Stats';

  @override
  String get collectionStatsButton => 'Collection Stats';

  @override
  String get wristRecap => 'Wrist Recap';

  @override
  String get lastSync => 'Last Synced:';

  @override
  String get deviation => 'System time deviation:';

  @override
  String get inProgress => 'Sync in progress - displaying system time...';

  @override
  String get beepCountdown => 'Beep Countdown';

  @override
  String get timeFormat => '24 hour time';

  @override
  String get moonPhase => 'Current Moon Phase';

  @override
  String get gallery => 'Gallery';

  @override
  String get timeline => 'Timeline';

  @override
  String get all => 'all';

  @override
  String get january => 'January';

  @override
  String get february => 'February';

  @override
  String get march => 'March';

  @override
  String get april => 'April';

  @override
  String get may => 'May';

  @override
  String get june => 'June';

  @override
  String get july => 'July';

  @override
  String get august => 'August';

  @override
  String get september => 'September';

  @override
  String get october => 'October';

  @override
  String get november => 'November';

  @override
  String get december => 'December';

  @override
  String get month => 'Month';

  @override
  String get year => 'Year';

  @override
  String get filter => 'Filter:';

  @override
  String get wearsByDay => 'Wears by Day';

  @override
  String get wearsByMonth => 'Wears by Month';

  @override
  String get wearsByYear => 'Wears by Year';

  @override
  String get thisYear => 'This Year';

  @override
  String get lastYear => 'Last Year';

  @override
  String get last12Months => 'Last 12 Months';

  @override
  String get last90days => 'Last 90 Days';

  @override
  String get noDataRecorded => 'No Data Recorded';

  @override
  String get warning => 'Warning';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get tellMeMore => 'Tell me more';

  @override
  String get backupRestore => 'Backup / Restore Database';

  @override
  String get altExports => 'Alternative Exports';

  @override
  String get dataImport => 'Data Import';

  @override
  String get deleteCollection => 'Delete Collection';

  @override
  String get backupRestoreHeader => 'Backup / Restore';

  @override
  String get backup => 'Backup';

  @override
  String get restore => 'Restore';

  @override
  String get backupDatabase => 'Backup Database';

  @override
  String get restoreDatabase => 'Restore Database';

  @override
  String get pleaseSelectFile => 'Please select backup file';

  @override
  String get selectFile => 'Select Backup File';

  @override
  String get fileSelected => 'File selected: ';

  @override
  String get readyToLoad => 'Ready to load';

  @override
  String get restoreFromBackup => 'Restore from Backup';

  @override
  String get backupWatchImages => 'Backup Watch Images';

  @override
  String get simpleExtractButton => 'Simple Extract (CSV)';

  @override
  String get detailedExtractButton => 'Detailed Extract (CSV)';

  @override
  String get wristTrackProFeature => 'WristTrack Pro Feature';

  @override
  String get deleteWarning =>
      'Pressing OK will delete all watch data, including your wishlist and all saved images\n \n THIS CANNOT BE UNDONE';

  @override
  String get backupInstruction =>
      'Press the button below to create a copy of the app database (this can take a few seconds!). \n\nOnce created a \'share\' pop-up should appear, allowing you to choose where to send the backup file.  ';

  @override
  String get imageBackupInstructions =>
      'Watch Images can be separately exported.';

  @override
  String get altExtractsGuidance =>
      '**Alternative Data Extracts**\n\nThese options allow your watch and wear data to be extracted from **WristTrack**\n\nThey are meant to free your data, rather than as a backup _(see the Backup/Restore options if you are simply looking to move data from one device to another)._\n\nThe simple extract provides a list of all watch data, including wear count and notes **(one row per watch)**\n\nThe detailed extract provides a line of data for each **tracked wear date** and only includes watches which have been tracked as worn.**(multiple rows per watch)**\n\nThis raw data is output in CSV format, allowing easy import into your favourite spreadsheet application.';
}
