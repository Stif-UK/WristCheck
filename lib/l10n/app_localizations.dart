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

  /// No description provided for @favouriteWatches.
  ///
  /// In en, this message translates to:
  /// **'Favourite Watches'**
  String get favouriteWatches;

  /// No description provided for @wishlist.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get wishlist;

  /// No description provided for @preOrders.
  ///
  /// In en, this message translates to:
  /// **'Pre-Orders'**
  String get preOrders;

  /// No description provided for @retiredWatches.
  ///
  /// In en, this message translates to:
  /// **'Retired Watches'**
  String get retiredWatches;

  /// No description provided for @randomWatch.
  ///
  /// In en, this message translates to:
  /// **'Random Watch'**
  String get randomWatch;

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

  /// No description provided for @lastWorn.
  ///
  /// In en, this message translates to:
  /// **'Last worn: {shortDate}'**
  String lastWorn(Object shortDate);

  /// No description provided for @wornToday.
  ///
  /// In en, this message translates to:
  /// **'Worn Today'**
  String get wornToday;

  /// No description provided for @wearToday.
  ///
  /// In en, this message translates to:
  /// **'Wear this watch today'**
  String get wearToday;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
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

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

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

  /// No description provided for @emptyWearListWatchCharts.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t tracked any wear dates for this watch yet.\n\nTrack data by clicking \'wear today\' on the watch page, or add dates via the calendar view. \n\nOnce tracked charts will show here breaking down your records by month and weekday.'**
  String get emptyWearListWatchCharts;

  /// No description provided for @wearChartFiltersSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Wear Chart Filters'**
  String get wearChartFiltersSheetTitle;

  /// No description provided for @showAll.
  ///
  /// In en, this message translates to:
  /// **'Show all'**
  String get showAll;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @lastMonth.
  ///
  /// In en, this message translates to:
  /// **'Last Month'**
  String get lastMonth;

  /// No description provided for @last30days.
  ///
  /// In en, this message translates to:
  /// **'Last 30 days'**
  String get last30days;

  /// No description provided for @last365days.
  ///
  /// In en, this message translates to:
  /// **'Last 365 days'**
  String get last365days;

  /// No description provided for @sinceLastPurchase.
  ///
  /// In en, this message translates to:
  /// **'Since Last Purchase'**
  String get sinceLastPurchase;

  /// No description provided for @selectMonthYear.
  ///
  /// In en, this message translates to:
  /// **'Select Month/Year'**
  String get selectMonthYear;

  /// No description provided for @betweenSelectedDates.
  ///
  /// In en, this message translates to:
  /// **'Between selected dates'**
  String get betweenSelectedDates;

  /// No description provided for @monthColon.
  ///
  /// In en, this message translates to:
  /// **'Month:'**
  String get monthColon;

  /// No description provided for @yearColon.
  ///
  /// In en, this message translates to:
  /// **'Year:'**
  String get yearColon;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date:'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'  End Date:'**
  String get endDate;

  /// No description provided for @resetToDefaults.
  ///
  /// In en, this message translates to:
  /// **'Reset to Defaults'**
  String get resetToDefaults;

  /// No description provided for @chartGrouping.
  ///
  /// In en, this message translates to:
  /// **'Chart Grouping'**
  String get chartGrouping;

  /// No description provided for @includeCurrentCollection.
  ///
  /// In en, this message translates to:
  /// **'Include Current Collection'**
  String get includeCurrentCollection;

  /// No description provided for @includeSoldWatches.
  ///
  /// In en, this message translates to:
  /// **'Include Sold Watches'**
  String get includeSoldWatches;

  /// No description provided for @includeRetiredWatches.
  ///
  /// In en, this message translates to:
  /// **'Include Retired Watches'**
  String get includeRetiredWatches;

  /// No description provided for @includeArchivedWatches.
  ///
  /// In en, this message translates to:
  /// **'Include Archived Watches'**
  String get includeArchivedWatches;

  /// No description provided for @filterByCategory.
  ///
  /// In en, this message translates to:
  /// **'Filter by Category'**
  String get filterByCategory;

  /// No description provided for @filterByMovement.
  ///
  /// In en, this message translates to:
  /// **'Filter by Movement'**
  String get filterByMovement;

  /// No description provided for @allData.
  ///
  /// In en, this message translates to:
  /// **'All Data'**
  String get allData;

  /// No description provided for @wornThisYear.
  ///
  /// In en, this message translates to:
  /// **'Worn This Year'**
  String get wornThisYear;

  /// No description provided for @wornThisMonth.
  ///
  /// In en, this message translates to:
  /// **'Worn This Month'**
  String get wornThisMonth;

  /// No description provided for @wornLastMonth.
  ///
  /// In en, this message translates to:
  /// **'Worn Last Month'**
  String get wornLastMonth;

  /// No description provided for @wornLastYear.
  ///
  /// In en, this message translates to:
  /// **'Worn Last Year'**
  String get wornLastYear;

  /// No description provided for @wornInLast30Days.
  ///
  /// In en, this message translates to:
  /// **'Worn in last 30 days'**
  String get wornInLast30Days;

  /// No description provided for @wornInLast90Days.
  ///
  /// In en, this message translates to:
  /// **'Worn in last 90 days'**
  String get wornInLast90Days;

  /// No description provided for @wornInLast365Days.
  ///
  /// In en, this message translates to:
  /// **'Worn in last 365 days'**
  String get wornInLast365Days;

  /// No description provided for @wornBetweenDates.
  ///
  /// In en, this message translates to:
  /// **'Worn between {shortDate} & {shortDate2}'**
  String wornBetweenDates(Object shortDate, Object shortDate2);

  /// No description provided for @yearSelected.
  ///
  /// In en, this message translates to:
  /// **'Year: {yearValue}'**
  String yearSelected(Object yearValue);

  /// No description provided for @monthSelected.
  ///
  /// In en, this message translates to:
  /// **'Month: {monthValue}'**
  String monthSelected(Object monthValue);

  /// No description provided for @advancedFilterHeaderLastPurchase.
  ///
  /// In en, this message translates to:
  /// **'{returnText} Last Purchase: {shortDate}, '**
  String advancedFilterHeaderLastPurchase(Object returnText, Object shortDate);

  /// No description provided for @advancedFilterHeaderGrouping.
  ///
  /// In en, this message translates to:
  /// **'{returnText} Group by {filterText}, '**
  String advancedFilterHeaderGrouping(Object filterText, Object returnText);

  /// No description provided for @advancedFilterHeaderCategories.
  ///
  /// In en, this message translates to:
  /// **'{returnText} Categories({filterText}), '**
  String advancedFilterHeaderCategories(Object filterText, Object returnText);

  /// No description provided for @advancedFilterHeaderMovements.
  ///
  /// In en, this message translates to:
  /// **'{returnText} Movements({filterText}), '**
  String advancedFilterHeaderMovements(Object filterText, Object returnText);

  /// No description provided for @advancedFilterHeaderHideCollection.
  ///
  /// In en, this message translates to:
  /// **'{returnText} hide Collection, '**
  String advancedFilterHeaderHideCollection(Object returnText);

  /// No description provided for @advancedFilterHeaderIncSold.
  ///
  /// In en, this message translates to:
  /// **'{returnText} inc. Sold, '**
  String advancedFilterHeaderIncSold(Object returnText);

  /// No description provided for @advancedFilterHeaderIncRetired.
  ///
  /// In en, this message translates to:
  /// **'{returnText} inc. Retired, '**
  String advancedFilterHeaderIncRetired(Object returnText);

  /// No description provided for @advancedFilterHeaderIncArchived.
  ///
  /// In en, this message translates to:
  /// **'{returnText} inc. Archived, '**
  String advancedFilterHeaderIncArchived(Object returnText);

  /// No description provided for @chartsEmptyBackgroundText.
  ///
  /// In en, this message translates to:
  /// **'No data available for the chosen filter'**
  String get chartsEmptyBackgroundText;

  /// No description provided for @generatedWithWristTrackPro.
  ///
  /// In en, this message translates to:
  /// **'This chart generated with WristTrack Pro'**
  String get generatedWithWristTrackPro;

  /// No description provided for @generatedWithWristTrack.
  ///
  /// In en, this message translates to:
  /// **'This chart generated with WristTrack'**
  String get generatedWithWristTrack;

  /// No description provided for @watch.
  ///
  /// In en, this message translates to:
  /// **'Watch'**
  String get watch;

  /// No description provided for @movement.
  ///
  /// In en, this message translates to:
  /// **'Movement'**
  String get movement;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @manufacturer.
  ///
  /// In en, this message translates to:
  /// **'Manufacturer'**
  String get manufacturer;

  /// No description provided for @caseMaterial.
  ///
  /// In en, this message translates to:
  /// **'Case Material'**
  String get caseMaterial;

  /// No description provided for @dateComplication.
  ///
  /// In en, this message translates to:
  /// **'Date Complication'**
  String get dateComplication;

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

  /// No description provided for @sizeOfCollection.
  ///
  /// In en, this message translates to:
  /// **'Size of Collection'**
  String get sizeOfCollection;

  /// No description provided for @oldestWatch.
  ///
  /// In en, this message translates to:
  /// **'Oldest Watch'**
  String get oldestWatch;

  /// No description provided for @newestWatch.
  ///
  /// In en, this message translates to:
  /// **'Newest Watch'**
  String get newestWatch;

  /// No description provided for @mostWorn.
  ///
  /// In en, this message translates to:
  /// **'Most Worn'**
  String get mostWorn;

  /// No description provided for @leastWorn.
  ///
  /// In en, this message translates to:
  /// **'Least Worn'**
  String get leastWorn;

  /// No description provided for @wishListCount.
  ///
  /// In en, this message translates to:
  /// **'Wish listed Watches'**
  String get wishListCount;

  /// No description provided for @soldWatches.
  ///
  /// In en, this message translates to:
  /// **'Sold Watches'**
  String get soldWatches;

  /// No description provided for @noPurchaseDatesTracked.
  ///
  /// In en, this message translates to:
  /// **'No purchase dates tracked'**
  String get noPurchaseDatesTracked;

  /// No description provided for @upgradeToProForMoreCharts.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to WristTrack Pro for more charts here...'**
  String get upgradeToProForMoreCharts;

  /// No description provided for @movements.
  ///
  /// In en, this message translates to:
  /// **'Movements'**
  String get movements;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @dateComplications.
  ///
  /// In en, this message translates to:
  /// **'Date Complications'**
  String get dateComplications;

  /// No description provided for @caseDiameter.
  ///
  /// In en, this message translates to:
  /// **'Case Diameter'**
  String get caseDiameter;

  /// No description provided for @lugWidth.
  ///
  /// In en, this message translates to:
  /// **'Lug Width'**
  String get lugWidth;

  /// No description provided for @lugToLug.
  ///
  /// In en, this message translates to:
  /// **'Lug to Lug'**
  String get lugToLug;

  /// No description provided for @caseThickness.
  ///
  /// In en, this message translates to:
  /// **'Case Thickness'**
  String get caseThickness;

  /// No description provided for @waterResistance.
  ///
  /// In en, this message translates to:
  /// **'Water Resistance'**
  String get waterResistance;

  /// No description provided for @caseMaterials.
  ///
  /// In en, this message translates to:
  /// **'Case Materials'**
  String get caseMaterials;

  /// No description provided for @costPerWear.
  ///
  /// In en, this message translates to:
  /// **'Cost Per Wear'**
  String get costPerWear;

  /// No description provided for @showPaymentOptions.
  ///
  /// In en, this message translates to:
  /// **'Show Payment Options'**
  String get showPaymentOptions;

  /// No description provided for @donateAgain.
  ///
  /// In en, this message translates to:
  /// **'Donate Again'**
  String get donateAgain;

  /// No description provided for @removeAdsMainCopy.
  ///
  /// In en, this message translates to:
  /// **'The core features of **WristTrack** are free, supported by small ads throughout the app.\n\nHowever, you can remove these ads by picking a price for the app below - all options will upgrade the app to **WristTrack Pro**.\n\n**WristTrack Pro** also unlocks:\n\n* The option to set a second daily reminder\n* Individual watch charts showing wear stats by months and weekdays\n* Additional watch data fields and charts '**
  String get removeAdsMainCopy;

  /// No description provided for @supporterCopy.
  ///
  /// In en, this message translates to:
  /// **'Thank you for supporting WristTrack!\n\nYour support means a lot and makes it possible for me to continue to develop WristTrack and other apps like it.\n\nIf you\'re enjoying the app please consider telling your friends about it or leave a review to let me know what you like about the app and what else you\'d like to see added to it!\n\nIf you\'d like to continue to support WristTrack additional donations can be made at any time.'**
  String get supporterCopy;

  /// No description provided for @purchaseRestored.
  ///
  /// In en, this message translates to:
  /// **'Purchase Restored'**
  String get purchaseRestored;

  /// No description provided for @youreAdFree.
  ///
  /// In en, this message translates to:
  /// **'You\'re now ad free!'**
  String get youreAdFree;

  /// No description provided for @restoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Restore Failed'**
  String get restoreFailed;

  /// No description provided for @noPurchaseFound.
  ///
  /// In en, this message translates to:
  /// **'No previous or active purchase found for user'**
  String get noPurchaseFound;

  /// No description provided for @restorePurchase.
  ///
  /// In en, this message translates to:
  /// **'Restore Purchase Status'**
  String get restorePurchase;

  /// No description provided for @noOptionsFound.
  ///
  /// In en, this message translates to:
  /// **'No Options Found, try again later'**
  String get noOptionsFound;

  /// No description provided for @supportWristTrack.
  ///
  /// In en, this message translates to:
  /// **'Support WristTrack'**
  String get supportWristTrack;

  /// No description provided for @payWhatYouLike.
  ///
  /// In en, this message translates to:
  /// **'Pay what you like! Choose any option upgrade to WristTrack Pro'**
  String get payWhatYouLike;

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

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @noThanks.
  ///
  /// In en, this message translates to:
  /// **'No Thanks'**
  String get noThanks;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

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

  /// No description provided for @archivedSuffix.
  ///
  /// In en, this message translates to:
  /// **'(Archived)'**
  String get archivedSuffix;

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

  /// No description provided for @errorHeader.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorHeader;

  /// No description provided for @dontShowThisMessageAgain.
  ///
  /// In en, this message translates to:
  /// **'Don\'t show this message again'**
  String get dontShowThisMessageAgain;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success!'**
  String get success;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @notWornYet.
  ///
  /// In en, this message translates to:
  /// **'Not worn yet'**
  String get notWornYet;

  /// No description provided for @lastWornDate.
  ///
  /// In en, this message translates to:
  /// **'Last worn: {shortDate}'**
  String lastWornDate(Object shortDate);

  /// No description provided for @wearCount.
  ///
  /// In en, this message translates to:
  /// **'Worn {count} times'**
  String wearCount(Object count);

  /// No description provided for @notRecorded.
  ///
  /// In en, this message translates to:
  /// **'Not Recorded'**
  String get notRecorded;

  /// No description provided for @soldDetails.
  ///
  /// In en, this message translates to:
  /// **'Sold on {shortDate} \nfor {price}'**
  String soldDetails(Object price, Object shortDate);

  /// No description provided for @countDownNA.
  ///
  /// In en, this message translates to:
  /// **'Countdown: N/A'**
  String get countDownNA;

  /// No description provided for @dueInXDays.
  ///
  /// In en, this message translates to:
  /// **'Due: {nDays}'**
  String dueInXDays(Object nDays);

  /// No description provided for @overdueXDays.
  ///
  /// In en, this message translates to:
  /// **'Overdue: {nDays}'**
  String overdueXDays(Object nDays);

  /// No description provided for @basic.
  ///
  /// In en, this message translates to:
  /// **'Basic'**
  String get basic;

  /// No description provided for @advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advanced;

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

  /// No description provided for @proFeature.
  ///
  /// In en, this message translates to:
  /// **'Pro Feature'**
  String get proFeature;

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

  /// No description provided for @selectDatesToAdd.
  ///
  /// In en, this message translates to:
  /// **'Select Dates to Add'**
  String get selectDatesToAdd;

  /// No description provided for @selectionMode.
  ///
  /// In en, this message translates to:
  /// **'Selection Mode'**
  String get selectionMode;

  /// No description provided for @rangeDefinition.
  ///
  /// In en, this message translates to:
  /// **'Range (select start and end of range)'**
  String get rangeDefinition;

  /// No description provided for @individualSelectionDefinition.
  ///
  /// In en, this message translates to:
  /// **'Individual (pick multiple dates)'**
  String get individualSelectionDefinition;

  /// No description provided for @thereWasAProblemWithSomeDates.
  ///
  /// In en, this message translates to:
  /// **'There was a problem with some of the dates'**
  String get thereWasAProblemWithSomeDates;

  /// No description provided for @dateAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'Date already exists'**
  String get dateAlreadyExists;

  /// No description provided for @dateIsInTheFuture.
  ///
  /// In en, this message translates to:
  /// **'Date is in the future'**
  String get dateIsInTheFuture;

  /// No description provided for @watchAccuracy.
  ///
  /// In en, this message translates to:
  /// **'Watch Accuracy'**
  String get watchAccuracy;

  /// No description provided for @accuracyTracker.
  ///
  /// In en, this message translates to:
  /// **'Accuracy Tracker'**
  String get accuracyTracker;

  /// No description provided for @timeSynced.
  ///
  /// In en, this message translates to:
  /// **'Time synced with server: \n{timeStamp}'**
  String timeSynced(Object timeStamp);

  /// No description provided for @showAccuracyResultsOptions.
  ///
  /// In en, this message translates to:
  /// **'Show results in seconds per:'**
  String get showAccuracyResultsOptions;

  /// No description provided for @baseLineMeasurement.
  ///
  /// In en, this message translates to:
  /// **'Baseline measurement:'**
  String get baseLineMeasurement;

  /// No description provided for @setBaseLineGuide.
  ///
  /// In en, this message translates to:
  /// **'Set a new baseline if you\'ve just set the time of your watch'**
  String get setBaseLineGuide;

  /// No description provided for @lastBaseLine.
  ///
  /// In en, this message translates to:
  /// **'Last Baseline: {timeStamp}'**
  String lastBaseLine(Object timeStamp);

  /// No description provided for @addCheckPoint.
  ///
  /// In en, this message translates to:
  /// **'Add Checkpoint:'**
  String get addCheckPoint;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'Seconds:'**
  String get seconds;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved!'**
  String get saved;

  /// No description provided for @record.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get record;

  /// No description provided for @records.
  ///
  /// In en, this message translates to:
  /// **'Records'**
  String get records;

  /// No description provided for @baseLine.
  ///
  /// In en, this message translates to:
  /// **'Baseline'**
  String get baseLine;

  /// No description provided for @result.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get result;

  /// No description provided for @systemTimeInUse.
  ///
  /// In en, this message translates to:
  /// **'... system time in use'**
  String get systemTimeInUse;

  /// No description provided for @accuracyHelpTextIntro.
  ///
  /// In en, this message translates to:
  /// **'Track your watches accuracy by creating checkpoints - WristTrack can then compare the change in the time on your watch to the change in time from the atomic clock and calculate if it is gaining or losing time\n\n'**
  String get accuracyHelpTextIntro;

  /// No description provided for @accuracyHelpTextBaselines.
  ///
  /// In en, this message translates to:
  /// **'**Baselines**\n\nWhen you set a checkpoint as a baseline, all following measurements will be compared to it. You should set a new baseline any time you have manually adjusted your watch since the last baseline.\n\nIf you have no records saved, the first result is always tagged as a baseline record.\n\n'**
  String get accuracyHelpTextBaselines;

  /// No description provided for @accuracyHelpTextAddAMeasurement.
  ///
  /// In en, this message translates to:
  /// **'**Capturing a Measurement**\n\nTo capture a data point, set the time value under \'add checkpoint\' to match your watch is going to be (it defaults to a minute ahead) and then press the \'00 seconds\' button when the seconds hand reaches twelve o\'clock. Alternatively, set the time to match your watch and use the \'15/30/45 seconds\' buttons when the seconds hand passes those to capture the timestamp.\n\nThe times captured will then appear in the \'Records\' section below, along with an accuracy calculated since the last baseline record (no accuracy value shows for baselines).\n\n'**
  String get accuracyHelpTextAddAMeasurement;

  /// No description provided for @accuracyHelpTextDeletingARecord.
  ///
  /// In en, this message translates to:
  /// **'**Deleting a Record**\n\nIf you capture a record in error, it can be deleted by swiping it away from right to left in the \'Records\' list.\n\n'**
  String get accuracyHelpTextDeletingARecord;

  /// No description provided for @accuracyHelpTextWhenToCapture.
  ///
  /// In en, this message translates to:
  /// **'**When to capture records**\n\nThe longer you track the watch from the baseline measurement, the more accurate the results are likely to be (as the small delays when pressing buttons become less prominent). As a guide, it\'s useful to leave 12-24 hours between measurements.\n\n'**
  String get accuracyHelpTextWhenToCapture;

  /// No description provided for @accuracyHelpTextOutro.
  ///
  /// In en, this message translates to:
  /// **'_*You can re-open this information box at any time by pressing the question mark in the top right of the page*_\n\n '**
  String get accuracyHelpTextOutro;

  /// No description provided for @servicingTab.
  ///
  /// In en, this message translates to:
  /// **'Servicing'**
  String get servicingTab;

  /// No description provided for @warrantyTab.
  ///
  /// In en, this message translates to:
  /// **'Warranty'**
  String get warrantyTab;

  /// No description provided for @helpTab.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get helpTab;

  /// No description provided for @nextServiceBy.
  ///
  /// In en, this message translates to:
  /// **'Next Service by: {timeStamp}'**
  String nextServiceBy(Object timeStamp);

  /// No description provided for @warrantyExpiresOn.
  ///
  /// In en, this message translates to:
  /// **'Warranty Expires on: {timeStamp}'**
  String warrantyExpiresOn(Object timeStamp);

  /// No description provided for @emptyServiceText.
  ///
  /// In en, this message translates to:
  /// **'No Service Data to show\n\nTo populate a service schedule add purchase dates, service dates and service intervals to your watches.\n\n'**
  String get emptyServiceText;

  /// No description provided for @emptyWarrantyText.
  ///
  /// In en, this message translates to:
  /// **'No Warranty Data to show\n\nTo populate a warranty expiry schedule, add warranty end date values to your watches.\n'**
  String get emptyWarrantyText;

  /// No description provided for @serviceScheduleHelpText.
  ///
  /// In en, this message translates to:
  /// **'Service and Warranty schedule\n\n This page allows you to view a schedule of tracked service dates (calculated based on dates and frequencies tracked in your watch collection), and warranty end dates, based on the manually input warranty end date field for watches.\n'**
  String get serviceScheduleHelpText;

  /// No description provided for @emptyWatchboxCopy.
  ///
  /// In en, this message translates to:
  /// **'Your watch-box is currently empty.\n\nPress the red button to add watches to your collection\n\nSet app preferences, such as preferred currency format, by pressing the cog icon in the top right'**
  String get emptyWatchboxCopy;

  /// No description provided for @emptySoldCopy.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any sold watches in your collection.\n\nYou can mark a watch as sold by editing it\'s status.\n'**
  String get emptySoldCopy;

  /// No description provided for @emptyWishlistCopy.
  ///
  /// In en, this message translates to:
  /// **'You aren\'t tracking any watches in your wishlist.\n\nTo add a watch to your wishlist, create a new watch record and set it\'s status to \'Wishlist\'.\n'**
  String get emptyWishlistCopy;

  /// No description provided for @emptyFavouritesCopy.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any watches marked as \'favourite\' yet. \n\nTo mark a watch as a favourite adjust the toggle on the watch detail screen.\n'**
  String get emptyFavouritesCopy;

  /// No description provided for @emptyPreOrderCopy.
  ///
  /// In en, this message translates to:
  /// **'You\'re not tracking any watch pre-orders. \n\nTo track a countdown for a pre-ordered watch, create a new watch record with a status of \'pre-ordered\'.'**
  String get emptyPreOrderCopy;

  /// No description provided for @listViewTitle.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get listViewTitle;

  /// No description provided for @gridViewTitle.
  ///
  /// In en, this message translates to:
  /// **'Grid'**
  String get gridViewTitle;

  /// No description provided for @displayOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'Display Order:'**
  String get displayOrderTitle;

  /// No description provided for @inOrderOfEntry.
  ///
  /// In en, this message translates to:
  /// **'In order of entry'**
  String get inOrderOfEntry;

  /// No description provided for @inReverseOrderOfEntry.
  ///
  /// In en, this message translates to:
  /// **'In reverse order of entry'**
  String get inReverseOrderOfEntry;

  /// No description provided for @azByManufacturer.
  ///
  /// In en, this message translates to:
  /// **'A-Z by manufacturer'**
  String get azByManufacturer;

  /// No description provided for @zaByManufacturer.
  ///
  /// In en, this message translates to:
  /// **'Z-A by manufacturer'**
  String get zaByManufacturer;

  /// No description provided for @orderByMostWorn.
  ///
  /// In en, this message translates to:
  /// **'Order by most worn'**
  String get orderByMostWorn;

  /// No description provided for @orderByLastWornDate.
  ///
  /// In en, this message translates to:
  /// **'Order by last worn date'**
  String get orderByLastWornDate;

  /// No description provided for @watchNamePurchased.
  ///
  /// In en, this message translates to:
  /// **'{watchName} purchased'**
  String watchNamePurchased(Object watchName);

  /// No description provided for @watchNameSold.
  ///
  /// In en, this message translates to:
  /// **'{watchName} sold'**
  String watchNameSold(Object watchName);

  /// No description provided for @watchNamePreOrderDue.
  ///
  /// In en, this message translates to:
  /// **'{watchName} pre-order due'**
  String watchNamePreOrderDue(Object watchName);

  /// No description provided for @watchNameLastServiced.
  ///
  /// In en, this message translates to:
  /// **'{watchName} last serviced'**
  String watchNameLastServiced(Object watchName);

  /// No description provided for @watchNameNextService.
  ///
  /// In en, this message translates to:
  /// **'{watchName} next service due'**
  String watchNameNextService(Object watchName);

  /// No description provided for @watchNameWarrantyExpires.
  ///
  /// In en, this message translates to:
  /// **'{watchName} warranty expires'**
  String watchNameWarrantyExpires(Object watchName);

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @privacySettings.
  ///
  /// In en, this message translates to:
  /// **'Privacy Settings'**
  String get privacySettings;

  /// No description provided for @privacySettingsUpdated.
  ///
  /// In en, this message translates to:
  /// **'Your Privacy choices have been updated'**
  String get privacySettingsUpdated;

  /// No description provided for @privacyError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred whilst attempting to update privacy settings - please try again'**
  String get privacyError;

  /// No description provided for @anAppForEnthusiasts.
  ///
  /// In en, this message translates to:
  /// **'An app for watch enthusiasts. \nSwipe to learn what WristTrack can do...'**
  String get anAppForEnthusiasts;

  /// No description provided for @yourDigitalWatchbox.
  ///
  /// In en, this message translates to:
  /// **'Your Digital Watchbox'**
  String get yourDigitalWatchbox;

  /// No description provided for @recordAllYourWatches.
  ///
  /// In en, this message translates to:
  /// **'Record all your watches - quickly search, re-organise or get a random pick'**
  String get recordAllYourWatches;

  /// No description provided for @trackTheDetail.
  ///
  /// In en, this message translates to:
  /// **'Track The Detail'**
  String get trackTheDetail;

  /// No description provided for @categoriseAndCaptureTheDetails.
  ///
  /// In en, this message translates to:
  /// **'Categorise and capture the particulars of your watches, or add your own notes'**
  String get categoriseAndCaptureTheDetails;

  /// No description provided for @analyseTheData.
  ///
  /// In en, this message translates to:
  /// **'Analyse The Data'**
  String get analyseTheData;

  /// No description provided for @getInsightsWithDataAndCharts.
  ///
  /// In en, this message translates to:
  /// **'Get insights into your collection through data and charts'**
  String get getInsightsWithDataAndCharts;

  /// No description provided for @letsGo.
  ///
  /// In en, this message translates to:
  /// **'Let\'s go!'**
  String get letsGo;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'SKIP'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'NEXT'**
  String get next;

  /// No description provided for @primaryImage.
  ///
  /// In en, this message translates to:
  /// **'Primary Image'**
  String get primaryImage;

  /// No description provided for @updateImage.
  ///
  /// In en, this message translates to:
  /// **'Update Image'**
  String get updateImage;

  /// No description provided for @deleteImage.
  ///
  /// In en, this message translates to:
  /// **'Delete Image'**
  String get deleteImage;

  /// No description provided for @imageBottomSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'{watchName}\nImage {count}'**
  String imageBottomSheetTitle(Object count, Object watchName);

  /// No description provided for @takeWithCamera.
  ///
  /// In en, this message translates to:
  /// **'Take with Camera'**
  String get takeWithCamera;

  /// No description provided for @selectFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Select from Gallery'**
  String get selectFromGallery;

  /// No description provided for @cropImage.
  ///
  /// In en, this message translates to:
  /// **'Crop Image'**
  String get cropImage;

  /// No description provided for @longPressToEditOrDelete.
  ///
  /// In en, this message translates to:
  /// **'Long press to edit or delete'**
  String get longPressToEditOrDelete;

  /// No description provided for @watchGallery.
  ///
  /// In en, this message translates to:
  /// **'{watchName} Photos'**
  String watchGallery(Object watchName);

  /// No description provided for @enableDailyWearReminder.
  ///
  /// In en, this message translates to:
  /// **'Enable Daily Wear Reminder'**
  String get enableDailyWearReminder;

  /// No description provided for @morning.
  ///
  /// In en, this message translates to:
  /// **'Morning (8am)'**
  String get morning;

  /// No description provided for @afternoon.
  ///
  /// In en, this message translates to:
  /// **'Afternoon (12pm)'**
  String get afternoon;

  /// No description provided for @evening.
  ///
  /// In en, this message translates to:
  /// **'Evening (6pm)'**
  String get evening;

  /// No description provided for @customTime.
  ///
  /// In en, this message translates to:
  /// **'Custom Time'**
  String get customTime;

  /// No description provided for @yourReminderIsSetForTime.
  ///
  /// In en, this message translates to:
  /// **'Your daily reminder is scheduled for {hourTimeStamp}'**
  String yourReminderIsSetForTime(Object hourTimeStamp);

  /// No description provided for @yourSecondReminderIsSetFor.
  ///
  /// In en, this message translates to:
  /// **'Your second reminder is set for {hourTimeStamp}'**
  String yourSecondReminderIsSetFor(Object hourTimeStamp);

  /// No description provided for @notificationTitle.
  ///
  /// In en, this message translates to:
  /// **'WristTrack Reminder'**
  String get notificationTitle;

  /// No description provided for @notificationOneBody.
  ///
  /// In en, this message translates to:
  /// **'Don\'t forget to track what\'s on your wrist today!'**
  String get notificationOneBody;

  /// No description provided for @notificationConfirmationBody.
  ///
  /// In en, this message translates to:
  /// **'Your notifications have now been scheduled for {hourTimeStamp} every day!'**
  String notificationConfirmationBody(Object hourTimeStamp);

  /// No description provided for @notificationTwoBody.
  ///
  /// In en, this message translates to:
  /// **'It\'s time to track what\'s on your wrist!'**
  String get notificationTwoBody;

  /// No description provided for @notificationTwoConfirmationBody.
  ///
  /// In en, this message translates to:
  /// **'Your second notification is set for {hourTimeStamp} every day!'**
  String notificationTwoConfirmationBody(Object hourTimeStamp);

  /// No description provided for @enableSecondDailyWearReminder.
  ///
  /// In en, this message translates to:
  /// **'Enable Second Daily Reminder'**
  String get enableSecondDailyWearReminder;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No Results Found'**
  String get noResultsFound;

  /// Returns the number of times a watch has been worn
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No wears tracked} =1{Worn 1 time} other{Worn {count} times}}'**
  String nWears(num count);

  /// Returns the suitable plural form for the given number of watches
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No watches} =1{1 watch} other{{count} watches}}'**
  String nWatches(num count);

  /// Returns the suitable plural of days
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 days} =1{1 day} other{{count} days}}'**
  String nDays(num count);

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

  /// No description provided for @serviceIntervalTitle.
  ///
  /// In en, this message translates to:
  /// **'Service Interval'**
  String get serviceIntervalTitle;

  /// No description provided for @serviceIntervalText.
  ///
  /// In en, this message translates to:
  /// **'By setting a service interval a \'service due date\' will be calculated and displayed on the Service screen of the app (as long as either a purchase date or last service date is set).\n  \nThe value of this field can be left at zero to disable for this watch.'**
  String get serviceIntervalText;

  /// No description provided for @duplicateWearTitle.
  ///
  /// In en, this message translates to:
  /// **'Duplicate Date Warning'**
  String get duplicateWearTitle;

  /// No description provided for @duplicateWearText.
  ///
  /// In en, this message translates to:
  /// **'It looks like you\'ve already worn this watch on the given date! \n \nIf you want to track an additional wear, select \'Add Again\' to track. \n \notherwise cancel to go back'**
  String get duplicateWearText;

  /// No description provided for @duplicateWearConfirm.
  ///
  /// In en, this message translates to:
  /// **'Add Again'**
  String get duplicateWearConfirm;

  /// No description provided for @collectionStatsDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Collection Stats'**
  String get collectionStatsDialogTitle;

  /// No description provided for @collectionStatsDialogText.
  ///
  /// In en, this message translates to:
  /// **'All values are based on data held within your watch collection.\n\nWhere calculations are made based on dates (such as \'oldest watch\') the data is only as accurate as the data provided to the application.\n\nYou can edit data associated with individual watches by navigating to them via the main watch box screens.'**
  String get collectionStatsDialogText;

  /// No description provided for @archivedHelpDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Watch Archive'**
  String get archivedHelpDialogTitle;

  /// No description provided for @archivedHelpDialogText.
  ///
  /// In en, this message translates to:
  /// **'When a watch status is marked as \'Archived\' it is removed from the main collection and stored here.\n\nWatches in the archive can be permanently deleted with a swipe to the left or restored to your watchbox by swiping right'**
  String get archivedHelpDialogText;

  /// No description provided for @backupHelpDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup Database Help'**
  String get backupHelpDialogTitle;

  /// No description provided for @backupHelpDialogText.
  ///
  /// In en, this message translates to:
  /// **'Getting a new phone or just want a backup in case the worst happens?\n You\'re in the right place!\n\nCreate a backup of your watchbox or restore an existing copy.\n\nNote: Restoring the database will clear down any existing data and REPLACE it with the backup.\n\nIf any issues arise during the backup / restore process these can often be resolved by killing and restarting the application.'**
  String get backupHelpDialogText;

  /// No description provided for @incorrectFilenameDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Incorrect file'**
  String get incorrectFilenameDialogTitle;

  /// No description provided for @incorrectFilenameDialogText.
  ///
  /// In en, this message translates to:
  /// **'The file {fileName} does not match the expected file of watchbox.hive\n\nPlease select a watchbox.hive file'**
  String incorrectFilenameDialogText(Object fileName);

  /// No description provided for @confirmRestoreDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore from Backup'**
  String get confirmRestoreDialogTitle;

  /// No description provided for @confirmRestoreDialogText.
  ///
  /// In en, this message translates to:
  /// **'Restoring this backup will over-write your current watch-box.\n\nDo you want to continue?'**
  String get confirmRestoreDialogText;

  /// No description provided for @restoreFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore Failed'**
  String get restoreFailedTitle;

  /// No description provided for @restoreFailedText.
  ///
  /// In en, this message translates to:
  /// **'Failed to restore from backup, an error occurred:\n\n{error}\n\nPlease try again - if the issue persists please contact the app developer'**
  String restoreFailedText(Object error);

  /// No description provided for @restoreSuccessDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore Successful'**
  String get restoreSuccessDialogTitle;

  /// No description provided for @restoreSuccessDialogText.
  ///
  /// In en, this message translates to:
  /// **'Database successfully restored!\n\nIf watches don\'t show immediately try navigating between the main tabs.'**
  String get restoreSuccessDialogText;

  /// No description provided for @backupLocationNullDialogText.
  ///
  /// In en, this message translates to:
  /// **'No Backup location is specified. Please first select where to store the backup file'**
  String get backupLocationNullDialogText;

  /// No description provided for @backupFailedDialogText.
  ///
  /// In en, this message translates to:
  /// **'Backup Failed\n\n{error}\n\nIt could be that the selected location is not accessible to the application. Try with a different location.\n\nIf this doesn\'t work, please provide feedback to the developer via the app store.'**
  String backupFailedDialogText(Object error);

  /// No description provided for @watchboxFailedErrorDialog.
  ///
  /// In en, this message translates to:
  /// **'Failed to re-open watchbox\n\n{error}\n\nSome errors can be resolved by killing and restarting the application.\n\nIf this doesn\'t work, please provide feedback to the developer via the app store.'**
  String watchboxFailedErrorDialog(Object error);

  /// No description provided for @backupCompleteDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup Complete'**
  String get backupCompleteDialogTitle;

  /// No description provided for @backupCompleteDialogText.
  ///
  /// In en, this message translates to:
  /// **'WatchBox Data has been saved.'**
  String get backupCompleteDialogText;

  /// No description provided for @wristTrackUpdatedBottomSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'WristTrack just updated...'**
  String get wristTrackUpdatedBottomSheetTitle;

  /// No description provided for @futureDateErrorDialogText.
  ///
  /// In en, this message translates to:
  /// **'Wear dates must be in the past, please select a different date.'**
  String get futureDateErrorDialogText;

  /// No description provided for @notificationSettingsHelpDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationSettingsHelpDialogTitle;

  /// No description provided for @notificationsSettingsHelpDialogText.
  ///
  /// In en, this message translates to:
  /// **'When enabled a notification will trigger daily at the selected time.'**
  String get notificationsSettingsHelpDialogText;

  /// No description provided for @notificationSettingsHelpDialogTextAndroid.
  ///
  /// In en, this message translates to:
  /// **'\n\nNote: Some device manufacturers run customised versions of Android OS which may impact the ability for the app to generate notifications when in the background.\n\nUnfortunately as a developer there\'s little that can be done to prevent this. \n\nThis is known to affect Huawei and Xiaomi phones, but may also affect others. '**
  String get notificationSettingsHelpDialogTextAndroid;

  /// No description provided for @wearDatesHelpDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Wear History'**
  String get wearDatesHelpDialogTitle;

  /// No description provided for @wearDatesHelpDialogText.
  ///
  /// In en, this message translates to:
  /// **'This calendar shows the dates this watch was worn, as well as other tracked dates for the watch.\n\nTo add or delete wear dates directly, long press on an individual date.'**
  String get wearDatesHelpDialogText;

  /// No description provided for @deleteImageDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Image'**
  String get deleteImageDialogTitle;

  /// No description provided for @deleteImageDialogText.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete this image?\nThis cannot be undone'**
  String get deleteImageDialogText;

  /// No description provided for @deleteWatchTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Watch'**
  String get deleteWatchTitle;

  /// No description provided for @deleteWatchDialogText.
  ///
  /// In en, this message translates to:
  /// **'Do you want to remove this watch from your collection?\n\n(Watches deleted in error can be restored from the Archive, found in Settings)'**
  String get deleteWatchDialogText;

  /// No description provided for @deleteWatchSnackbarConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Watch Deleted'**
  String get deleteWatchSnackbarConfirmation;

  /// No description provided for @deleteWatchSnackbarText.
  ///
  /// In en, this message translates to:
  /// **'{watchName} has been moved to the Archive'**
  String deleteWatchSnackbarText(Object watchName);

  /// No description provided for @failedToPickImageDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Failed to Pick Image'**
  String get failedToPickImageDialogTitle;

  /// No description provided for @failedToPickImageDialogText.
  ///
  /// In en, this message translates to:
  /// **'The platform encountered an error:\n\n{error}'**
  String failedToPickImageDialogText(Object error);

  /// No description provided for @setupDailyReminderDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Setup Daily Reminders'**
  String get setupDailyReminderDialogTitle;

  /// No description provided for @setupDailyRemindersDialogText.
  ///
  /// In en, this message translates to:
  /// **'WristTrack can send you a daily reminder to track what you\'re wearing\n\nWould you like to set one up?\n\n(This can be found at any time in the settings menu)'**
  String get setupDailyRemindersDialogText;

  /// No description provided for @soldStatusPopupDialogText.
  ///
  /// In en, this message translates to:
  /// **'You\'re marking this watch as sold:\n\nYou can now add a sold date, sale price and information on the buyer under the schedule and value tabs.'**
  String get soldStatusPopupDialogText;

  /// No description provided for @preorderStatusPopupDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Pre-Ordered Watches'**
  String get preorderStatusPopupDialogTitle;

  /// No description provided for @preorderStatusPopupDialogText.
  ///
  /// In en, this message translates to:
  /// **'You\'re marking this watch as Pre-Ordered:\n\nYou can now add a due date on the schedule tab.\nThis will enable a countdown to the given date.'**
  String get preorderStatusPopupDialogText;

  /// No description provided for @noImagesFoundPopupTitle.
  ///
  /// In en, this message translates to:
  /// **'No Images Found'**
  String get noImagesFoundPopupTitle;

  /// No description provided for @noImagesFoundPopupText.
  ///
  /// In en, this message translates to:
  /// **'No backup has been generated as no watch images were identified'**
  String get noImagesFoundPopupText;

  /// No description provided for @failedToBackupImagesDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Failed to Backup Images'**
  String get failedToBackupImagesDialogTitle;

  /// No description provided for @failedToBackupImagesDialogText.
  ///
  /// In en, this message translates to:
  /// **'Failed to backup images, the following error was returned:\n{error}'**
  String failedToBackupImagesDialogText(Object error);

  /// No description provided for @imageBackupSuccessDialogText.
  ///
  /// In en, this message translates to:
  /// **'{count} Images successfully backed up'**
  String imageBackupSuccessDialogText(Object count);

  /// No description provided for @watchboxSuccessfullyBackedUpText.
  ///
  /// In en, this message translates to:
  /// **'Watchbox successfully backed up'**
  String get watchboxSuccessfullyBackedUpText;

  /// No description provided for @extractSuccessfullyCreatedDialogText.
  ///
  /// In en, this message translates to:
  /// **'Extract Successfully Created'**
  String get extractSuccessfullyCreatedDialogText;

  /// No description provided for @generalErrorDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong!'**
  String get generalErrorDialogTitle;

  /// No description provided for @generalErrorDialogText.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occured with message: {error}'**
  String generalErrorDialogText(Object error);

  /// No description provided for @proDialogText.
  ///
  /// In en, this message translates to:
  /// **'This is a WristTrack Pro feature.\n\nTo learn more and upgrade, click below.'**
  String get proDialogText;
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
