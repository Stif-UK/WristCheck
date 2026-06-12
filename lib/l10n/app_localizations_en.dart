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
  String get favouriteWatches => 'Favourite Watches';

  @override
  String get wishlist => 'Wishlist';

  @override
  String get preOrders => 'Pre-Orders';

  @override
  String get retiredWatches => 'Retired Watches';

  @override
  String get randomWatch => 'Random Watch';

  @override
  String get statusInCollection => 'In Collection';

  @override
  String get statusSold => 'Sold';

  @override
  String get statusWishlist => 'Wishlist';

  @override
  String get statusPreOrder => 'Pre-Order';

  @override
  String get statusRetired => 'Retired';

  @override
  String get statusArchived => 'Archived';

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
  String lastWorn(Object shortDate) {
    return 'Last worn: $shortDate';
  }

  @override
  String get wornToday => 'Worn Today';

  @override
  String get wearToday => 'Wear this watch today';

  @override
  String editTitle(Object watchName) {
    return 'Edit: $watchName';
  }

  @override
  String get addWatch => 'Add Watch';

  @override
  String get addOptionalDetails => 'Add optional details?';

  @override
  String get addedToWatchbox => 'added to watchbox';

  @override
  String get favouriteLabel => 'Favourite';

  @override
  String get caseDiameterRowTitle => 'Case Diameter (mm):';

  @override
  String get caseDiameterRowHintText => 'Case Diameter';

  @override
  String get caseThicknessRowTitle => 'Case Thickness (mm):';

  @override
  String get caseThicknessRowHintText => 'Case Thickness';

  @override
  String get lastServicedDateRowTitle => 'Last Serviced Date:';

  @override
  String get lastServicedDateRowHintText => 'Last Serviced Date';

  @override
  String get lug2lugRowTitle => 'Lug to Lug (mm):';

  @override
  String get lug2lugRowHintText => 'Lug to Lug';

  @override
  String get lugWidthRowTitle => 'Lug Width (mm):';

  @override
  String get lugWidthHintText => 'Lug Width';

  @override
  String get manufacturerRowTitle => 'Manufacturer:';

  @override
  String get manufacturerRowHintText => 'Manufacturer';

  @override
  String get modelRowTitle => 'Model:';

  @override
  String get modelRowHintText => 'Model';

  @override
  String get purchaseDateRowTitle => 'Purchase Date:';

  @override
  String get purchaseDateRowHintText => 'Purchase Date';

  @override
  String get purchasePriceRowTitle => 'Purchase Price:';

  @override
  String get purchasePriceRowHintText => 'Purchase Price';

  @override
  String get purchasedFromRowTitle => 'Purchased From:';

  @override
  String get purchasedFromHintText => 'Purchased From';

  @override
  String get referenceNumberRowTitle => 'Reference Number:';

  @override
  String get referenceNumberOptionalTitle => 'Reference Number (Optional):';

  @override
  String get referenceNumberRowHelpText => 'Reference Number';

  @override
  String get serialNumberRowTitle => 'Serial Number:';

  @override
  String get serialNumberOptionalTitle => 'Serial Number (Optional):';

  @override
  String get serialNumberRowHintText => 'Serial Number';

  @override
  String get soldDateRowTitle => 'Sold Date:';

  @override
  String get soldDateRowHintText => 'Sold Date';

  @override
  String get soldPriceRowTitle => 'Sold Price:';

  @override
  String get soldPriceRowHintText => 'Sold Price';

  @override
  String get soldToRowTitle => 'Sold To:';

  @override
  String get soldToRowHintText => 'Sold To';

  @override
  String get warrantyEndRowTitle => 'Warranty Expiry Date:';

  @override
  String get warrantyEndRowHintText => 'Warranty Expiry Date';

  @override
  String waterResistanceRowTitle(Object units) {
    return 'Water Resistance $units:';
  }

  @override
  String get waterResistanceRowHintText => 'Water Resistance';

  @override
  String get movementRowTitle => 'Movement:';

  @override
  String get categoryRowTitle => 'Category:';

  @override
  String get watchDetailsSectionTitle => 'Watch Details';

  @override
  String get caseMaterialRowTitle => 'Case Material:';

  @override
  String get winderSettingsSectionTitle => 'Winder Settings';

  @override
  String get tpdRowTitle => 'TPD:';

  @override
  String get winderDirectionRowTitle => 'Winder Direction:';

  @override
  String get dateComplicationRowTitle => 'Date Complication:';

  @override
  String get notesRowTitle => 'Notes:';

  @override
  String get notesRowHintText => 'Notes';

  @override
  String get costPerWearRowTitle => 'Cost per Wear:';

  @override
  String get accuracyRowTitle => 'Accuracy:';

  @override
  String get mustBeNumber2decimals =>
      'Must be numbers only with up to two decimal points';

  @override
  String get mustBeWholeNumberLessThan99 =>
      'Must be a whole number less than 99';

  @override
  String get manufacturerInvalidError =>
      'Manufacturer missing or invalid characters included';

  @override
  String get modelInvalidError =>
      'Model missing or invalid characters included';

  @override
  String get digitsNoDecimalsError =>
      'Enter digits only, no decimals, we\'ll take care of the rest!';

  @override
  String get invalidCharactersDetected => 'Invalid characters detected.';

  @override
  String get referenceNumberErrorText =>
      'Reference Number is missing or invalid characters included';

  @override
  String get serialNumberErrorText =>
      'Serial Number contains invalid characters';

  @override
  String get mustBeAValidWholeNumber => 'Must be a whole number';

  @override
  String get infoTabLabel => 'Info';

  @override
  String get scheduleTabLabel => 'Dates';

  @override
  String get valueTabLabel => 'Value';

  @override
  String get proDataTabLabel => 'Pro Data';

  @override
  String get notesTabLabel => 'Notes';

  @override
  String get all => 'All';

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
  String get day => 'Day';

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
  String get emptyWearListWatchCharts =>
      'You haven\'t tracked any wear dates for this watch yet.\n\nTrack data by clicking \'wear today\' on the watch page, or add dates via the calendar view. \n\nOnce tracked charts will show here breaking down your records by month and weekday.';

  @override
  String get wearChartFiltersSheetTitle => 'Wear Chart Filters';

  @override
  String get showAll => 'Show all';

  @override
  String get thisMonth => 'This Month';

  @override
  String get lastMonth => 'Last Month';

  @override
  String get last30days => 'Last 30 days';

  @override
  String get last365days => 'Last 365 days';

  @override
  String get sinceLastPurchase => 'Since Last Purchase';

  @override
  String get selectMonthYear => 'Select Month/Year';

  @override
  String get betweenSelectedDates => 'Between selected dates';

  @override
  String get monthColon => 'Month:';

  @override
  String get yearColon => 'Year:';

  @override
  String get startDate => 'Start Date:';

  @override
  String get endDate => '  End Date:';

  @override
  String get resetToDefaults => 'Reset to Defaults';

  @override
  String get chartGrouping => 'Chart Grouping';

  @override
  String get includeCurrentCollection => 'Include Current Collection';

  @override
  String get includeSoldWatches => 'Include Sold Watches';

  @override
  String get includeRetiredWatches => 'Include Retired Watches';

  @override
  String get includeArchivedWatches => 'Include Archived Watches';

  @override
  String get filterByCategory => 'Filter by Category';

  @override
  String get filterByMovement => 'Filter by Movement';

  @override
  String get allData => 'All Data';

  @override
  String get wornThisYear => 'Worn This Year';

  @override
  String get wornThisMonth => 'Worn This Month';

  @override
  String get wornLastMonth => 'Worn Last Month';

  @override
  String get wornLastYear => 'Worn Last Year';

  @override
  String get wornInLast30Days => 'Worn in last 30 days';

  @override
  String get wornInLast90Days => 'Worn in last 90 days';

  @override
  String get wornInLast365Days => 'Worn in last 365 days';

  @override
  String wornBetweenDates(Object shortDate, Object shortDate2) {
    return 'Worn between $shortDate & $shortDate2';
  }

  @override
  String yearSelected(Object yearValue) {
    return 'Year: $yearValue';
  }

  @override
  String monthSelected(Object monthValue) {
    return 'Month: $monthValue';
  }

  @override
  String advancedFilterHeaderLastPurchase(Object returnText, Object shortDate) {
    return '$returnText Last Purchase: $shortDate, ';
  }

  @override
  String advancedFilterHeaderGrouping(Object filterText, Object returnText) {
    return '$returnText Group by $filterText, ';
  }

  @override
  String advancedFilterHeaderCategories(Object filterText, Object returnText) {
    return '$returnText Categories($filterText), ';
  }

  @override
  String advancedFilterHeaderMovements(Object filterText, Object returnText) {
    return '$returnText Movements($filterText), ';
  }

  @override
  String advancedFilterHeaderHideCollection(Object returnText) {
    return '$returnText hide Collection, ';
  }

  @override
  String advancedFilterHeaderIncSold(Object returnText) {
    return '$returnText inc. Sold, ';
  }

  @override
  String advancedFilterHeaderIncRetired(Object returnText) {
    return '$returnText inc. Retired, ';
  }

  @override
  String advancedFilterHeaderIncArchived(Object returnText) {
    return '$returnText inc. Archived, ';
  }

  @override
  String get chartsEmptyBackgroundText =>
      'No data available for the chosen filter';

  @override
  String get generatedWithWristTrackPro =>
      'This chart generated with WristTrack Pro';

  @override
  String get generatedWithWristTrack => 'This chart generated with WristTrack';

  @override
  String get watch => 'Watch';

  @override
  String get movement => 'Movement';

  @override
  String get category => 'Category';

  @override
  String get manufacturer => 'Manufacturer';

  @override
  String get caseMaterial => 'Case Material';

  @override
  String get dateComplication => 'Date Complication';

  @override
  String get pageTitleCollectionStats => 'Collection Stats';

  @override
  String get labelCharts => 'Charts';

  @override
  String get labelInfo => 'Info';

  @override
  String get labelValue => 'Value Data';

  @override
  String get collectionCost => 'Current Collection Cost';

  @override
  String get noValue => 'No value captured';

  @override
  String get totalSpend => 'Total Collection Spend';

  @override
  String get totalSold => 'Total Sold Value';

  @override
  String get averageResale => 'Average Resale %';

  @override
  String get noDataTracked => 'No Data Tracked';

  @override
  String get resaleRatio => 'Resale Ratio =';

  @override
  String get sizeOfCollection => 'Size of Collection';

  @override
  String get oldestWatch => 'Oldest Watch';

  @override
  String get newestWatch => 'Newest Watch';

  @override
  String get mostWorn => 'Most Worn';

  @override
  String get leastWorn => 'Least Worn';

  @override
  String get wishListCount => 'Wish listed Watches';

  @override
  String get soldWatches => 'Sold Watches';

  @override
  String get noPurchaseDatesTracked => 'No purchase dates tracked';

  @override
  String get upgradeToProForMoreCharts =>
      'Upgrade to WristTrack Pro for more charts here...';

  @override
  String get movements => 'Movements';

  @override
  String get categories => 'Categories';

  @override
  String get dateComplications => 'Date Complications';

  @override
  String get caseDiameter => 'Case Diameter';

  @override
  String get lugWidth => 'Lug Width';

  @override
  String get lugToLug => 'Lug to Lug';

  @override
  String get caseThickness => 'Case Thickness';

  @override
  String get waterResistance => 'Water Resistance';

  @override
  String get caseMaterials => 'Case Materials';

  @override
  String get costPerWear => 'Cost Per Wear';

  @override
  String get showPaymentOptions => 'Show Payment Options';

  @override
  String get donateAgain => 'Donate Again';

  @override
  String get removeAdsMainCopy =>
      'The core features of **WristTrack** are free, supported by small ads throughout the app.\n\nHowever, you can remove these ads by picking a price for the app below - all options will upgrade the app to **WristTrack Pro**.\n\n**WristTrack Pro** also unlocks:\n\n* The option to set a second daily reminder\n* Individual watch charts showing wear stats by months and weekdays\n* Additional watch data fields and charts ';

  @override
  String get supporterCopy =>
      'Thank you for supporting WristTrack!\n\nYour support means a lot and makes it possible for me to continue to develop WristTrack and other apps like it.\n\nIf you\'re enjoying the app please consider telling your friends about it or leave a review to let me know what you like about the app and what else you\'d like to see added to it!\n\nIf you\'d like to continue to support WristTrack additional donations can be made at any time.';

  @override
  String get purchaseRestored => 'Purchase Restored';

  @override
  String get youreAdFree => 'You\'re now ad free!';

  @override
  String get restoreFailed => 'Restore Failed';

  @override
  String get noPurchaseFound => 'No previous or active purchase found for user';

  @override
  String get restorePurchase => 'Restore Purchase Status';

  @override
  String get noOptionsFound => 'No Options Found, try again later';

  @override
  String get supportWristTrack => 'Support WristTrack';

  @override
  String get payWhatYouLike =>
      'Pay what you like! Choose any option upgrade to WristTrack Pro';

  @override
  String get noDataRecorded => 'No Data Recorded';

  @override
  String get warning => 'Warning';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Yes';

  @override
  String get noThanks => 'No Thanks';

  @override
  String get cancel => 'Cancel';

  @override
  String get done => 'Done';

  @override
  String get tellMeMore => 'Tell me more';

  @override
  String get soldSuffix => '(Sold)';

  @override
  String get retiredSuffix => '(Retired)';

  @override
  String get archivedSuffix => '(Archived)';

  @override
  String get watchColon => 'Watch:';

  @override
  String get deleting => 'Deleting';

  @override
  String get errorHeader => 'Error';

  @override
  String get dontShowThisMessageAgain => 'Don\'t show this message again';

  @override
  String get success => 'Success!';

  @override
  String get today => 'Today';

  @override
  String get notWornYet => 'Not worn yet';

  @override
  String lastWornDate(Object shortDate) {
    return 'Last worn: $shortDate';
  }

  @override
  String wearCount(Object count) {
    return 'Worn $count times';
  }

  @override
  String get notRecorded => 'Not Recorded';

  @override
  String soldDetails(Object price, Object shortDate) {
    return 'Sold on $shortDate \nfor $price';
  }

  @override
  String get countDownNA => 'Countdown: N/A';

  @override
  String dueInXDays(Object nDays) {
    return 'Due: $nDays';
  }

  @override
  String overdueXDays(Object nDays) {
    return 'Overdue: $nDays';
  }

  @override
  String get basic => 'Basic';

  @override
  String get advanced => 'Advanced';

  @override
  String get na => 'N/A';

  @override
  String schedule(Object nYears) {
    return 'Every $nYears';
  }

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
  String get proFeature => 'Pro Feature';

  @override
  String get track => 'Track';

  @override
  String get trackWear => 'Track Wear';

  @override
  String get removeWear => 'Remove Wear';

  @override
  String get removeDate => 'Remove Date';

  @override
  String get date => 'Date:';

  @override
  String get pickWatch => 'Pick Watch';

  @override
  String get pleaseSelectAWatch => 'Please select a watch';

  @override
  String get searchByName => 'Search by watch name';

  @override
  String get deleteWear => 'Delete Wear Record';

  @override
  String get deleteFromCalendar => 'Delete Wear from Calendar';

  @override
  String get addWearToCalendar => 'Add Wear to Calendar';

  @override
  String get serviceDue => 'Service Due';

  @override
  String get warrantyExpires => 'Warranty Expires';

  @override
  String get deliveryExpected => 'delivery expected';

  @override
  String get longPressToAddRemove => 'Long press to add/remove wear dates';

  @override
  String get tapToAddMultipleDates => 'Tap here to add multiple dates';

  @override
  String get deleteDate => 'Delete Date';

  @override
  String watchWorn(Object watchName) {
    return '$watchName worn';
  }

  @override
  String get noDatesForWatch => 'No dates recorded for this watch.';

  @override
  String get allDatesWorn => 'All dates worn';

  @override
  String get selectDatesToAdd => 'Select Dates to Add';

  @override
  String get selectionMode => 'Selection Mode';

  @override
  String get rangeDefinition => 'Range (select start and end of range)';

  @override
  String get individualSelectionDefinition =>
      'Individual (pick multiple dates)';

  @override
  String get thereWasAProblemWithSomeDates =>
      'There was a problem with some of the dates';

  @override
  String get dateAlreadyExists => 'Date already exists';

  @override
  String get dateIsInTheFuture => 'Date is in the future';

  @override
  String get watchAccuracy => 'Watch Accuracy';

  @override
  String get accuracyTracker => 'Accuracy Tracker';

  @override
  String timeSynced(Object timeStamp) {
    return 'Time synced with server: \n$timeStamp';
  }

  @override
  String get showAccuracyResultsOptions => 'Show results in seconds per:';

  @override
  String get baseLineMeasurement => 'Baseline measurement:';

  @override
  String get setBaseLineGuide =>
      'Set a new baseline if you\'ve just set the time of your watch';

  @override
  String lastBaseLine(Object timeStamp) {
    return 'Last Baseline: $timeStamp';
  }

  @override
  String get addCheckPoint => 'Add Checkpoint:';

  @override
  String get seconds => 'Seconds:';

  @override
  String get saved => 'Saved!';

  @override
  String get record => 'Record';

  @override
  String get records => 'Records';

  @override
  String get baseLine => 'Baseline';

  @override
  String get result => 'Result';

  @override
  String get noRecordsTracked => 'No records tracked';

  @override
  String get measurementInProgress => 'Measurement in progress...';

  @override
  String get noRateFound => 'No rate found';

  @override
  String get systemTimeInUse => '... system time in use';

  @override
  String get accuracyHelpTextIntro =>
      'Track your watches accuracy by creating checkpoints - WristTrack can then compare the change in the time on your watch to the change in time from the atomic clock and calculate if it is gaining or losing time\n\n';

  @override
  String get accuracyHelpTextBaselines =>
      '**Baselines**\n\nWhen you set a checkpoint as a baseline, all following measurements will be compared to it. You should set a new baseline any time you have manually adjusted your watch since the last baseline.\n\nIf you have no records saved, the first result is always tagged as a baseline record.\n\n';

  @override
  String get accuracyHelpTextAddAMeasurement =>
      '**Capturing a Measurement**\n\nTo capture a data point, set the time value under \'add checkpoint\' to match your watch is going to be (it defaults to a minute ahead) and then press the \'00 seconds\' button when the seconds hand reaches twelve o\'clock. Alternatively, set the time to match your watch and use the \'15/30/45 seconds\' buttons when the seconds hand passes those to capture the timestamp.\n\nThe times captured will then appear in the \'Records\' section below, along with an accuracy calculated since the last baseline record (no accuracy value shows for baselines).\n\n';

  @override
  String get accuracyHelpTextDeletingARecord =>
      '**Deleting a Record**\n\nIf you capture a record in error, it can be deleted by swiping it away from right to left in the \'Records\' list.\n\n';

  @override
  String get accuracyHelpTextWhenToCapture =>
      '**When to capture records**\n\nThe longer you track the watch from the baseline measurement, the more accurate the results are likely to be (as the small delays when pressing buttons become less prominent). As a guide, it\'s useful to leave 12-24 hours between measurements.\n\n';

  @override
  String get accuracyHelpTextOutro =>
      '_*You can re-open this information box at any time by pressing the question mark in the top right of the page*_\n\n ';

  @override
  String secondsPerUnit(Object rateUnit) {
    return 'seconds/$rateUnit';
  }

  @override
  String get servicingTab => 'Servicing';

  @override
  String get warrantyTab => 'Warranty';

  @override
  String get helpTab => 'Help';

  @override
  String nextServiceBy(Object timeStamp) {
    return 'Next Service by: $timeStamp';
  }

  @override
  String warrantyExpiresOn(Object timeStamp) {
    return 'Warranty Expires on: $timeStamp';
  }

  @override
  String get emptyServiceText =>
      'No Service Data to show\n\nTo populate a service schedule add purchase dates, service dates and service intervals to your watches.\n\n';

  @override
  String get emptyWarrantyText =>
      'No Warranty Data to show\n\nTo populate a warranty expiry schedule, add warranty end date values to your watches.\n';

  @override
  String get serviceScheduleHelpText =>
      'Service and Warranty schedule\n\n This page allows you to view a schedule of tracked service dates (calculated based on dates and frequencies tracked in your watch collection), and warranty end dates, based on the manually input warranty end date field for watches.\n';

  @override
  String get pass => 'Pass';

  @override
  String get fail => 'Fail';

  @override
  String get partialPass => 'Partial Pass';

  @override
  String get duplicateFound => 'Duplicate Found';

  @override
  String get successSubtitle => 'All Watch fields successfully validated';

  @override
  String get failureSubtitle =>
      'This watch record cannot be uploaded. The Watch manufacturer or model cannot be determined.';

  @override
  String get partialPassSubtitle =>
      'Some fields are failing validation and will be ignored if not corrected';

  @override
  String get duplicateFoundSubtitle =>
      'A record already exists in the app with this make and model. Please ensure this is unique';

  @override
  String get clockwise => 'Clockwise';

  @override
  String get counterClockwise => 'Counter-Clockwise';

  @override
  String get both => 'Both';

  @override
  String get dateComplicationsDate => 'Date';

  @override
  String get dateComplicationsNoDate => 'No Date';

  @override
  String get dateComplicationsDayDate => 'Day-Date';

  @override
  String get dateComplicationsPointerDate => 'Pointer Date';

  @override
  String get dateComplicationsSubDialDate => 'Sub-Dial Date';

  @override
  String get dateComplicationsPerpetualDate => 'Perpetual Date';

  @override
  String get dateComplicationsDigitalDate => 'Digital Date';

  @override
  String get emptyWatchboxCopy =>
      'Your watch-box is currently empty.\n\nPress the red button to add watches to your collection\n\nSet app preferences, such as preferred currency format, by pressing the cog icon in the top right';

  @override
  String get emptySoldCopy =>
      'You don\'t have any sold watches in your collection.\n\nYou can mark a watch as sold by editing it\'s status.\n';

  @override
  String get emptyWishlistCopy =>
      'You aren\'t tracking any watches in your wishlist.\n\nTo add a watch to your wishlist, create a new watch record and set it\'s status to \'Wishlist\'.\n';

  @override
  String get emptyFavouritesCopy =>
      'You don\'t have any watches marked as \'favourite\' yet. \n\nTo mark a watch as a favourite adjust the toggle on the watch detail screen.\n';

  @override
  String get emptyPreOrderCopy =>
      'You\'re not tracking any watch pre-orders. \n\nTo track a countdown for a pre-ordered watch, create a new watch record with a status of \'pre-ordered\'.';

  @override
  String get listViewTitle => 'List';

  @override
  String get gridViewTitle => 'Grid';

  @override
  String get displayOrderTitle => 'Display Order:';

  @override
  String get inOrderOfEntry => 'In order of entry';

  @override
  String get inReverseOrderOfEntry => 'In reverse order of entry';

  @override
  String get azByManufacturer => 'A-Z by manufacturer';

  @override
  String get zaByManufacturer => 'Z-A by manufacturer';

  @override
  String get orderByMostWorn => 'Order by most worn';

  @override
  String get orderByLastWornDate => 'Order by last worn date';

  @override
  String watchNamePurchased(Object watchName) {
    return '$watchName purchased';
  }

  @override
  String watchNameSold(Object watchName) {
    return '$watchName sold';
  }

  @override
  String watchNamePreOrderDue(Object watchName) {
    return '$watchName pre-order due';
  }

  @override
  String watchNameLastServiced(Object watchName) {
    return '$watchName last serviced';
  }

  @override
  String watchNameNextService(Object watchName) {
    return '$watchName next service due';
  }

  @override
  String watchNameWarrantyExpires(Object watchName) {
    return '$watchName warranty expires';
  }

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get privacySettings => 'Privacy Settings';

  @override
  String get privacySettingsUpdated => 'Your Privacy choices have been updated';

  @override
  String get privacyError =>
      'An error occurred whilst attempting to update privacy settings - please try again';

  @override
  String get anAppForEnthusiasts =>
      'An app for watch enthusiasts. \nSwipe to learn what WristTrack can do...';

  @override
  String get yourDigitalWatchbox => 'Your Digital Watchbox';

  @override
  String get recordAllYourWatches =>
      'Record all your watches - quickly search, re-organise or get a random pick';

  @override
  String get trackTheDetail => 'Track The Detail';

  @override
  String get categoriseAndCaptureTheDetails =>
      'Categorise and capture the particulars of your watches, or add your own notes';

  @override
  String get analyseTheData => 'Analyse The Data';

  @override
  String get getInsightsWithDataAndCharts =>
      'Get insights into your collection through data and charts';

  @override
  String get letsGo => 'Let\'s go!';

  @override
  String get skip => 'SKIP';

  @override
  String get next => 'NEXT';

  @override
  String get primaryImage => 'Primary Image';

  @override
  String get updateImage => 'Update Image';

  @override
  String get deleteImage => 'Delete Image';

  @override
  String imageBottomSheetTitle(Object count, Object watchName) {
    return '$watchName\nImage $count';
  }

  @override
  String get takeWithCamera => 'Take with Camera';

  @override
  String get selectFromGallery => 'Select from Gallery';

  @override
  String get cropImage => 'Crop Image';

  @override
  String get longPressToEditOrDelete => 'Long press to edit or delete';

  @override
  String watchGallery(Object watchName) {
    return '$watchName Photos';
  }

  @override
  String get galleryTitle => 'Watch Gallery';

  @override
  String get galleryEmptyFilterReturn => 'No Images were found for this filter';

  @override
  String galleryError(Object error) {
    return 'An error occurred: $error';
  }

  @override
  String get galleryCollectionTab => 'Collection Watches';

  @override
  String get galleryArchivedTab => 'Archived Watches';

  @override
  String get galleryWishlistedWatchesTab => 'Wishlisted Watches';

  @override
  String get galleryEverythingTab => 'Everything';

  @override
  String get currencyOptionsTitle => 'Currency Options';

  @override
  String get currencyOptionsGuideText =>
      'WristTrack can track values of watches and collections, and in places will display these in a currency format of your choosing.\n\n,Note: All watch values should be saved in the same currency to enable accurate calculations.';

  @override
  String get currencyPleaseSelect =>
      'Please select your preferred currency layout:';

  @override
  String get currencyExample => 'Example output';

  @override
  String get currencyAdditionRequest =>
      'Something missing? Please contact the developer to make a request!';

  @override
  String get currencySterling => 'British Pound';

  @override
  String get currencyEuroIreland => 'Euro (Ireland)';

  @override
  String get currencyIndianRupee => 'Indian Rupee';

  @override
  String get currencyUSDollar => 'US Dollar';

  @override
  String get currencyYen => 'Japanese Yen';

  @override
  String get currencyEuroTrailing => 'Euro (trailing icon)';

  @override
  String get currencyEuroLeading => 'Euro (leading icon)';

  @override
  String get currencySwissFranc => 'Swiss Franc';

  @override
  String get currencyHungarianForint => 'Hungarian Forint';

  @override
  String get currencyPolishZloty => 'Polish Zloty';

  @override
  String get currencyThaiBaht => 'Thai Baht';

  @override
  String get currencyNorwegianKrone => 'Norwegian Krone';

  @override
  String get currencyCzechKoruna => 'Czech Koruna';

  @override
  String get currencyMalaysianRinggit => 'Malaysian Ringgit';

  @override
  String get enableDailyWearReminder => 'Enable Daily Wear Reminder';

  @override
  String get morning => 'Morning (8am)';

  @override
  String get afternoon => 'Afternoon (12pm)';

  @override
  String get evening => 'Evening (6pm)';

  @override
  String get customTime => 'Custom Time';

  @override
  String yourReminderIsSetForTime(Object hourTimeStamp) {
    return 'Your daily reminder is scheduled for $hourTimeStamp';
  }

  @override
  String yourSecondReminderIsSetFor(Object hourTimeStamp) {
    return 'Your second reminder is set for $hourTimeStamp';
  }

  @override
  String get notificationTitle => 'WristTrack Reminder';

  @override
  String get notificationOneBody =>
      'Don\'t forget to track what\'s on your wrist today!';

  @override
  String notificationConfirmationBody(Object hourTimeStamp) {
    return 'Your notifications have now been scheduled for $hourTimeStamp every day!';
  }

  @override
  String get notificationTwoBody =>
      'It\'s time to track what\'s on your wrist!';

  @override
  String notificationTwoConfirmationBody(Object hourTimeStamp) {
    return 'Your second notification is set for $hourTimeStamp every day!';
  }

  @override
  String get enableSecondDailyWearReminder => 'Enable Second Daily Reminder';

  @override
  String get search => 'Search';

  @override
  String get noResultsFound => 'No Results Found';

  @override
  String nWears(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Worn $countString times',
      one: 'Worn 1 time',
      zero: 'No wears tracked',
    );
    return '$_temp0';
  }

  @override
  String nWatches(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString watches',
      one: '1 watch',
      zero: 'No watches',
    );
    return '$_temp0';
  }

  @override
  String nDays(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString days',
      one: '1 day',
      zero: '0 days',
    );
    return '$_temp0';
  }

  @override
  String nYears(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString years',
      one: '1 year',
      zero: '0 years',
    );
    return '$_temp0';
  }

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

  @override
  String get watchChartsUpgradeCopy =>
      '**Watch Wear Charts**\n\nWatch charts are a **WristTrack Pro** feature.\n\nThey allow you to view charts breaking down which months and days this watch has been worn.\n\nWant to know more about **WristTrack Pro**? Click the button below...';

  @override
  String get serviceIntervalTitle => 'Service Interval';

  @override
  String get serviceIntervalText =>
      'By setting a service interval a \'service due date\' will be calculated and displayed on the Service screen of the app (as long as either a purchase date or last service date is set).\n  \nThe value of this field can be left at zero to disable for this watch.';

  @override
  String get duplicateWearTitle => 'Duplicate Date Warning';

  @override
  String get duplicateWearText =>
      'It looks like you\'ve already worn this watch on the given date! \n \nIf you want to track an additional wear, select \'Add Again\' to track. \n \notherwise cancel to go back';

  @override
  String get duplicateWearConfirm => 'Add Again';

  @override
  String get collectionStatsDialogTitle => 'Collection Stats';

  @override
  String get collectionStatsDialogText =>
      'All values are based on data held within your watch collection.\n\nWhere calculations are made based on dates (such as \'oldest watch\') the data is only as accurate as the data provided to the application.\n\nYou can edit data associated with individual watches by navigating to them via the main watch box screens.';

  @override
  String get archivedHelpDialogTitle => 'Watch Archive';

  @override
  String get archivedHelpDialogText =>
      'When a watch status is marked as \'Archived\' it is removed from the main collection and stored here.\n\nWatches in the archive can be permanently deleted with a swipe to the left or restored to your watchbox by swiping right';

  @override
  String get backupHelpDialogTitle => 'Backup Database Help';

  @override
  String get backupHelpDialogText =>
      'Getting a new phone or just want a backup in case the worst happens?\n You\'re in the right place!\n\nCreate a backup of your watchbox or restore an existing copy.\n\nNote: Restoring the database will clear down any existing data and REPLACE it with the backup.\n\nIf any issues arise during the backup / restore process these can often be resolved by killing and restarting the application.';

  @override
  String get incorrectFilenameDialogTitle => 'Incorrect file';

  @override
  String incorrectFilenameDialogText(Object fileName) {
    return 'The file $fileName does not match the expected file of watchbox.hive\n\nPlease select a watchbox.hive file';
  }

  @override
  String get confirmRestoreDialogTitle => 'Restore from Backup';

  @override
  String get confirmRestoreDialogText =>
      'Restoring this backup will over-write your current watch-box.\n\nDo you want to continue?';

  @override
  String get restoreFailedTitle => 'Restore Failed';

  @override
  String restoreFailedText(Object error) {
    return 'Failed to restore from backup, an error occurred:\n\n$error\n\nPlease try again - if the issue persists please contact the app developer';
  }

  @override
  String get restoreSuccessDialogTitle => 'Restore Successful';

  @override
  String get restoreSuccessDialogText =>
      'Database successfully restored!\n\nIf watches don\'t show immediately try navigating between the main tabs.';

  @override
  String get backupLocationNullDialogText =>
      'No Backup location is specified. Please first select where to store the backup file';

  @override
  String backupFailedDialogText(Object error) {
    return 'Backup Failed\n\n$error\n\nIt could be that the selected location is not accessible to the application. Try with a different location.\n\nIf this doesn\'t work, please provide feedback to the developer via the app store.';
  }

  @override
  String watchboxFailedErrorDialog(Object error) {
    return 'Failed to re-open watchbox\n\n$error\n\nSome errors can be resolved by killing and restarting the application.\n\nIf this doesn\'t work, please provide feedback to the developer via the app store.';
  }

  @override
  String get backupCompleteDialogTitle => 'Backup Complete';

  @override
  String get backupCompleteDialogText => 'WatchBox Data has been saved.';

  @override
  String get wristTrackUpdatedBottomSheetTitle => 'WristTrack just updated...';

  @override
  String get futureDateErrorDialogText =>
      'Wear dates must be in the past, please select a different date.';

  @override
  String get notificationSettingsHelpDialogTitle => 'Notification Settings';

  @override
  String get notificationsSettingsHelpDialogText =>
      'When enabled a notification will trigger daily at the selected time.';

  @override
  String get notificationSettingsHelpDialogTextAndroid =>
      '\n\nNote: Some device manufacturers run customised versions of Android OS which may impact the ability for the app to generate notifications when in the background.\n\nUnfortunately as a developer there\'s little that can be done to prevent this. \n\nThis is known to affect Huawei and Xiaomi phones, but may also affect others. ';

  @override
  String get wearDatesHelpDialogTitle => 'Wear History';

  @override
  String get wearDatesHelpDialogText =>
      'This calendar shows the dates this watch was worn, as well as other tracked dates for the watch.\n\nTo add or delete wear dates directly, long press on an individual date.';

  @override
  String get deleteImageDialogTitle => 'Delete Image';

  @override
  String get deleteImageDialogText =>
      'Do you want to delete this image?\nThis cannot be undone';

  @override
  String get deleteWatchTitle => 'Delete Watch';

  @override
  String get deleteWatchDialogText =>
      'Do you want to remove this watch from your collection?\n\n(Watches deleted in error can be restored from the Archive, found in Settings)';

  @override
  String get deleteWatchSnackbarConfirmation => 'Watch Deleted';

  @override
  String deleteWatchSnackbarText(Object watchName) {
    return '$watchName has been moved to the Archive';
  }

  @override
  String get failedToPickImageDialogTitle => 'Failed to Pick Image';

  @override
  String failedToPickImageDialogText(Object error) {
    return 'The platform encountered an error:\n\n$error';
  }

  @override
  String get setupDailyReminderDialogTitle => 'Setup Daily Reminders';

  @override
  String get setupDailyRemindersDialogText =>
      'WristTrack can send you a daily reminder to track what you\'re wearing\n\nWould you like to set one up?\n\n(This can be found at any time in the settings menu)';

  @override
  String get soldStatusPopupDialogText =>
      'You\'re marking this watch as sold:\n\nYou can now add a sold date, sale price and information on the buyer under the schedule and value tabs.';

  @override
  String get preorderStatusPopupDialogTitle => 'Pre-Ordered Watches';

  @override
  String get preorderStatusPopupDialogText =>
      'You\'re marking this watch as Pre-Ordered:\n\nYou can now add a due date on the schedule tab.\nThis will enable a countdown to the given date.';

  @override
  String get noImagesFoundPopupTitle => 'No Images Found';

  @override
  String get noImagesFoundPopupText =>
      'No backup has been generated as no watch images were identified';

  @override
  String get failedToBackupImagesDialogTitle => 'Failed to Backup Images';

  @override
  String failedToBackupImagesDialogText(Object error) {
    return 'Failed to backup images, the following error was returned:\n$error';
  }

  @override
  String imageBackupSuccessDialogText(Object count) {
    return '$count Images successfully backed up';
  }

  @override
  String get watchboxSuccessfullyBackedUpText =>
      'Watchbox successfully backed up';

  @override
  String get extractSuccessfullyCreatedDialogText =>
      'Extract Successfully Created';

  @override
  String get generalErrorDialogTitle => 'Something went wrong!';

  @override
  String generalErrorDialogText(Object error) {
    return 'An unexpected error occured with message: $error';
  }

  @override
  String get proDialogText =>
      'This is a WristTrack Pro feature.\n\nTo learn more and upgrade, click below.';

  @override
  String get saveUpdates => 'Save Updates';

  @override
  String get updatesSaved => 'Updates Saved';

  @override
  String get editWatchUnsavedChangesTitle => 'You have unsaved changes';

  @override
  String get editWatchUnsavedChangesCopy =>
      'Are you sure you want to exit?\nUnsaved changes will be lost.';

  @override
  String get editWatchUnsavedChangesExitOption => 'Exit without saving';

  @override
  String get editWatchUnsavedChangesContinueEditingOption => 'Continue editing';
}
