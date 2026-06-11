import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:wristcheck/controllers/language_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/enums/accuracy_enums/rate_unit.dart';
import 'package:wristcheck/model/enums/category.dart';
import 'package:wristcheck/model/enums/chart_grouping.dart';
import 'package:wristcheck/model/enums/collection_view.dart';
import 'package:wristcheck/model/enums/complication_enums/date_complication_enum.dart';
import 'package:wristcheck/model/enums/gallery_selection_enum.dart';
import 'package:wristcheck/model/enums/location.dart';
import 'package:wristcheck/model/enums/month_list.dart';
import 'package:wristcheck/model/enums/movement_enum.dart';
import 'package:wristcheck/model/enums/stats_enums/case_material_enum.dart';
import 'package:wristcheck/model/enums/stats_enums/winder_direction_enum.dart';
import 'package:wristcheck/model/enums/upload_status_enum.dart';
import 'package:wristcheck/model/enums/watch_day_chart_filter_enum.dart';
import 'package:wristcheck/model/enums/watch_month_chart_filter_enum.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:get/get.dart';

class WristCheckFormatter{

  static String getFormattedDate(DateTime date){
    final langController = Get.put(LanguageController());
    final DateFormat formatter = DateFormat('yMMMd', langController.language.value.toString());
    String returnString = formatter.format(date);
    return returnString;
  }

  static String getFormattedDateWithDay(DateTime date){
    final langController = Get.put(LanguageController());
    final DateFormat formatter = DateFormat('E', langController.language.value.toString());
    String returnString = "${formatter.format(date)}, ${WristCheckFormatter.getFormattedDate(date)}";
    return returnString;
  }

  static String getFormattedDateAndTime(DateTime date){
    return "${getFormattedDateWithDay(date)} - ${getTime(date, false)}";
  }

  static String getTime(DateTime date, bool militaryTime){
    final DateFormat formatter = militaryTime? DateFormat('Hms') : DateFormat('h:mm:ss a');
    String returnString = formatter.format(date);
    return returnString;
  }

  static String getShortTime(DateTime date, bool militaryTime){
    final DateFormat formatter = militaryTime? DateFormat('Hm') : DateFormat('h:mm a');
    return formatter.format(date);
  }

  static String getMonthFromDate(DateTime date){
    final langController = Get.put(LanguageController());
    final DateFormat formatter = DateFormat('LLLL', langController.language.value.toString());
    return formatter.format(date);

  }

  static String getMonthName(int monthNumber) {
    final langController = Get.put(LanguageController());
    DateTime date = DateTime(0, monthNumber);
    return DateFormat.MMM(langController.language.value.toString()).format(date);
  }

  /*
  getDay takes an int value between 1 & 7 and returns the day in text form.
  The bool 'short' defines the format of the return i.e. "Monday" vs "Monday"
  The String "error" is returned if the given input is outside of the 1-7 range.
  The method pulls the locale from the languageController to return the day in the correct language
   */
  static String getDay(int day, bool short){
    String format = short? 'EEE': 'EEEE';
    if(day < 1 || day > 7){
      return "error";
    }
    final langController = Get.put(LanguageController());
    // Create a reference date where Monday = 1
    DateTime referenceDate = DateTime(2024, 1, day); // January 1, 2024 is Monday, therefore each int gives the correct day
    return DateFormat(format, langController.language.value.toString()).format(referenceDate);
  }

  static String getCollectionText(CollectionView view){
    String returnText = "";

    switch (view) {
      case CollectionView.all:
        returnText = AppLocalizations.of(Get.context!)!.watchBox;
        break;
      case CollectionView.sold:
        returnText = AppLocalizations.of(Get.context!)!.soldWatches;
        break;
      case CollectionView.wishlist:
        returnText = AppLocalizations.of(Get.context!)!.wishlist;
        break;
      case CollectionView.favourites:
        returnText = AppLocalizations.of(Get.context!)!.favouriteWatches;
        break;
      case CollectionView.random:
        returnText = AppLocalizations.of(Get.context!)!.randomWatch;
        break;
      case CollectionView.preorder:
        returnText = AppLocalizations.of(Get.context!)!.preOrders;
        break;
      case CollectionView.retired:
        returnText = AppLocalizations.of(Get.context!)!.retiredWatches;
        break;
    }

    return returnText;
  }

  static String getMovementText(MovementEnum movement){
    String returnText = "";

    switch (movement) {
      case MovementEnum.blank:
        returnText = "Not Entered";
        break;
      case MovementEnum.mechanical:
        returnText = "Mechanical - Manual";
        break;
      case MovementEnum.automatic:
        returnText = "Mechanical - Automatic";
        break;
      case MovementEnum.analogue_quartz:
        returnText = "Analogue Quartz";
        break;
      case MovementEnum.digital_quartz:
        returnText = "Digital Quartz";
        break;
      case MovementEnum.ana_digi_quartz:
        returnText = "Ana-Digi Quartz";
        break;
      case MovementEnum.kinetic:
        returnText = "Kinetic";
        break;
      case MovementEnum.mechaquartz:
        returnText = "Mecha-Quartz";
        break;
      case MovementEnum.smartwatch:
        returnText = "Smartwatch";
        break;
      case MovementEnum.tourbillon:
        returnText = "Tourbillon";
        break;
      case MovementEnum.solar:
        returnText = "Solar Quartz";
        break;
      case MovementEnum.tuning_fork:
        returnText = "Tuning Fork";
        break;
      case MovementEnum.other:
        returnText = "Other";
        break;
      case MovementEnum.springdrive:
        returnText = "Spring Drive";
        break;
    }
    return returnText;
  }

  static MovementEnum getMovementEnum(String? movement){
    MovementEnum returnValue = MovementEnum.blank;

    //TODO: When translating, retain the English values and create separate switch entries for values in the translation file to prevent existing data being lost
    switch (movement) {
      case "Not Entered":
        returnValue = MovementEnum.blank;
        break;
      case "Mechanical - Manual":
        returnValue = MovementEnum.mechanical;
        break;
      case "Mechanical - Automatic":
        returnValue = MovementEnum.automatic;
        break;
      case "Analogue Quartz":
        returnValue = MovementEnum.analogue_quartz;
        break;
      case "Digital Quartz":
        returnValue = MovementEnum.digital_quartz;
        break;
      case "Ana-Digi Quartz":
        returnValue = MovementEnum.ana_digi_quartz;
        break;
      case "Kinetic":
        returnValue = MovementEnum.kinetic;
        break;
      case "Mecha-Quartz":
        returnValue = MovementEnum.mechaquartz;
        break;
      case "Smartwatch":
        returnValue = MovementEnum.smartwatch;
        break;
      case "Tourbillon":
        returnValue = MovementEnum.tourbillon;
        break;
      case "Solar Quartz":
        returnValue = MovementEnum.solar;
        break;
      case "Tuning Fork":
        returnValue = MovementEnum.tuning_fork;
        break;
      case "Spring Drive":
        returnValue = MovementEnum.springdrive;
        break;
      case "Other":
        returnValue = MovementEnum.other;
        break;
      default:
        returnValue = MovementEnum.blank;
    }
    return returnValue;
  }

  static String getCaseMaterialText(CaseMaterialEnum material){
    String returnText = "";

    switch(material) {
      case CaseMaterialEnum.blank:
        returnText = "Not Entered";
        break;
      case CaseMaterialEnum.steel:
        returnText = "Steel";
        break;
      case CaseMaterialEnum.titanium:
        returnText = "Titanium";
        break;
      case CaseMaterialEnum.gold:
        returnText = "Gold";
        break;
      case CaseMaterialEnum.twotone:
        returnText = "Two-Tone";
        break;
      case CaseMaterialEnum.platinum:
        returnText = "Platinum";
        break;
      case CaseMaterialEnum.bronze:
        returnText = "Bronze";
        break;
      case CaseMaterialEnum.ceramic:
        returnText = "Ceramic";
        break;
      case CaseMaterialEnum.carbon:
        returnText = "Carbon";
        break;
      case CaseMaterialEnum.resin:
        returnText = "Resin";
        break;
      case CaseMaterialEnum.plastic:
        returnText = "Plastic";
        break;
      case CaseMaterialEnum.other:
        returnText = "Other";
        break;
      case CaseMaterialEnum.pvdsteel:
        returnText = "PVD/DLC Steel";
        break;
      case CaseMaterialEnum.tungsten:
        returnText = "Tungsten";
        break;
    }
    return returnText;
  }

  static CaseMaterialEnum getCaseMaterialEnum(String? material){
    CaseMaterialEnum returnValue = CaseMaterialEnum.blank;

    switch(material) {
      case "Not Entered":
        returnValue = CaseMaterialEnum.blank;
        break;
      case "Steel":
        returnValue = CaseMaterialEnum.steel;
        break;
      case "Titanium":
        returnValue = CaseMaterialEnum.titanium;
        break;
      case "Gold":
        returnValue = CaseMaterialEnum.gold;
        break;
      case "Two-Tone":
        returnValue = CaseMaterialEnum.twotone;
        break;
      case "Platinum":
        returnValue = CaseMaterialEnum.platinum;
        break;
      case "Bronze":
        returnValue = CaseMaterialEnum.bronze;
        break;
      case "Ceramic":
        returnValue = CaseMaterialEnum.ceramic;
        break;
      case "Carbon":
        returnValue = CaseMaterialEnum.carbon;
        break;
      case "Resin":
        returnValue = CaseMaterialEnum.resin;
        break;
      case "Plastic":
        returnValue = CaseMaterialEnum.plastic;
        break;
      case "Other":
        returnValue = CaseMaterialEnum.other;
        break;
      case "PVD/DLC Steel":
        returnValue = CaseMaterialEnum.pvdsteel;
        break;
      case "Tungsten":
        returnValue = CaseMaterialEnum.tungsten;
        break;
      default:
        returnValue = CaseMaterialEnum.blank;
        break;
    }
    return returnValue;
  }

  static String getCategoryText(CategoryEnum category){
    String returnText = "";

    switch (category) {

      case CategoryEnum.blank:
        returnText = "Not Selected";
        break;
      case CategoryEnum.dive:
        returnText = "Diver";
        break;
      case CategoryEnum.sports:
        returnText = "Sports";
        break;
      case CategoryEnum.flight:
        returnText = "Flight";
        break;
      case CategoryEnum.field:
        returnText = "Field";
        break;
      case CategoryEnum.dress:
        returnText = "Dress";
        break;
      case CategoryEnum.tool:
        returnText = "Tool";
        break;
      case CategoryEnum.chronograph:
        returnText = "Chronograph";
        break;
      case CategoryEnum.travel:
        returnText = "Travel";
        break;
    }
    return returnText;
  }

  static CategoryEnum getCategoryEnum(String? category){
    CategoryEnum returnValue = CategoryEnum.blank;

    switch (category) {
      case "Not Selected":
        returnValue = CategoryEnum.blank;
        break;
      case "Diver":
        returnValue = CategoryEnum.dive;
        break;
      case "Sports":
        returnValue = CategoryEnum.sports;
        break;
      case "Flight":
        returnValue = CategoryEnum.flight;
        break;
      case "Field":
        returnValue = CategoryEnum.field;
        break;
      case "Dress":
        returnValue = CategoryEnum.dress;
        break;
      case "Tool":
        returnValue = CategoryEnum.tool;
        break;
      case "Chronograph":
        returnValue = CategoryEnum.chronograph;
        break;
      case "Travel":
        returnValue = CategoryEnum.travel;
        break;
      default:
        returnValue = CategoryEnum.blank;
    }
    return returnValue;
  }

  static String getWinderDirectionText(WinderDirectionEnum direction){
    return direction.toDbString();
  }

  static WinderDirectionEnum getWinderDirectionEnum(String? direction){
    return WinderDirectionEnumLocalization.fromDbString(direction);
  }

  static Icon getWinderDirectionIcon(WinderDirectionEnum direction){
    Icon returnIcon = Icon(Icons.watch);

    switch(direction) {
      case WinderDirectionEnum.clockwise:
        returnIcon = Icon(FontAwesomeIcons.rotateRight);
        break;
      case WinderDirectionEnum.counterclockwise:
        returnIcon = Icon(FontAwesomeIcons.rotateLeft);
        break;
      case WinderDirectionEnum.both:
        returnIcon = Icon(FontAwesomeIcons.rotate);
        break;
      case WinderDirectionEnum.blank:
        returnIcon = Icon(FontAwesomeIcons.rotate);
        break;
    }

    return returnIcon;
  }

  static String getLocaleString(LocationEnum location){
    String returnText = "en_US";

    switch(location) {
      case LocationEnum.uk:
        returnText = "en_GB";
        break;
      case LocationEnum.irl:
        returnText = "en_IE";
        break;
      case LocationEnum.ind:
        returnText = "en_IN";
        break;
      case LocationEnum.us:
        returnText = "en_US";
        break;
      case LocationEnum.jap:
        returnText = "ja_JP";
        break;
      case LocationEnum.ger:
        returnText = "de_DE";
        break;
      case LocationEnum.dut:
        returnText = "nl_NL";
        break;
      case LocationEnum.swiss:
        returnText = "fr_CH";
        break;
      case LocationEnum.hun:
        returnText = "hu_HU";
        break;
      case LocationEnum.pol:
        returnText = "pl_PL";
        break;
      case LocationEnum.thai:
        returnText = "th_TH";
        break;
      case LocationEnum.nor:
        returnText = "no_NO";
        break;
      case LocationEnum.czh:
        returnText = "cs-CZ";
        break;
      case LocationEnum.my:
        returnText = "ms-MY";
        break;
    }
    return returnText;
  }

  static LocationEnum getLocaleEnum(String localeText){
    LocationEnum returnNum = LocationEnum.us;

    switch(localeText) {
      case "nl_NL":
        returnNum = LocationEnum.dut;
        break;
      case "en_GB":
        returnNum = LocationEnum.uk;
        break;
      case "en_IE":
        returnNum = LocationEnum.irl;
        break;
      case "en_IN":
        returnNum = LocationEnum.ind;
        break;
      case "en_US":
        returnNum = LocationEnum.us;
        break;
      case "ja_JP":
        returnNum = LocationEnum.jap;
        break;
      case "de_DE":
        returnNum = LocationEnum.ger;
        break;
      case "fr_CH":
        returnNum = LocationEnum.swiss;
        break;
      case "hu_HU":
        returnNum = LocationEnum.hun;
        break;
      case "pl_PL":
        returnNum = LocationEnum.pol;
        break;
      case "th_TH":
        returnNum = LocationEnum.thai;
        break;
      case "no_NO":
        returnNum = LocationEnum.nor;
        break;
      case "cs-CZ":
        returnNum = LocationEnum.czh;
        break;
      case "ms-MY":
        returnNum = LocationEnum.my;
        break;
      default:
        returnNum = LocationEnum.us;
        break;
    }
    return returnNum;
  }

  static String getLocaleDisplayText(LocationEnum location){
    String returnString = "";

    switch(location) {
      case LocationEnum.uk:
        returnString = AppLocalizations.of(Get.context!)!.currencySterling;
        break;
      case LocationEnum.irl:
        returnString = AppLocalizations.of(Get.context!)!.currencyEuroIreland;
        break;
      case LocationEnum.ind:
        returnString = AppLocalizations.of(Get.context!)!.currencyIndianRupee;
        break;
      case LocationEnum.us:
        returnString = AppLocalizations.of(Get.context!)!.currencyUSDollar;
        break;
      case LocationEnum.jap:
        returnString = AppLocalizations.of(Get.context!)!.currencyYen;
        break;
      case LocationEnum.ger:
        returnString = AppLocalizations.of(Get.context!)!.currencyEuroTrailing;
        break;
      case LocationEnum.dut:
        returnString = AppLocalizations.of(Get.context!)!.currencyEuroLeading;
        break;
      case LocationEnum.swiss:
        returnString = AppLocalizations.of(Get.context!)!.currencySwissFranc;
        break;
      case LocationEnum.hun:
        returnString = AppLocalizations.of(Get.context!)!.currencyHungarianForint;
        break;
      case LocationEnum.pol:
        returnString = AppLocalizations.of(Get.context!)!.currencyPolishZloty;
        break;
      case LocationEnum.thai:
        returnString = AppLocalizations.of(Get.context!)!.currencyThaiBaht;
        break;
      case LocationEnum.nor:
        returnString = AppLocalizations.of(Get.context!)!.currencyNorwegianKrone;
        break;
      case LocationEnum.czh:
        returnString = AppLocalizations.of(Get.context!)!.currencyCzechKoruna;
        break;
      case LocationEnum.my:
        returnString = AppLocalizations.of(Get.context!)!.currencyMalaysianRinggit;
        break;
    }

    return returnString;
}

static String getMonthText(MonthList month){
    String returnText = "";

    switch(month) {
      case MonthList.all:
        returnText = AppLocalizations.of(Get.context!)!.all;
        break;
      case MonthList.january:
        returnText = AppLocalizations.of(Get.context!)!.january;
        break;
      case MonthList.february:
        returnText = AppLocalizations.of(Get.context!)!.february;
        break;
      case MonthList.march:
        returnText = AppLocalizations.of(Get.context!)!.march;
        break;
      case MonthList.april:
        returnText = AppLocalizations.of(Get.context!)!.april;
        break;
      case MonthList.may:
        returnText = AppLocalizations.of(Get.context!)!.may;
        break;
      case MonthList.june:
        returnText = AppLocalizations.of(Get.context!)!.june;
        break;
      case MonthList.july:
        returnText = AppLocalizations.of(Get.context!)!.july;
        break;
      case MonthList.august:
        returnText = AppLocalizations.of(Get.context!)!.august;
        break;
      case MonthList.september:
        returnText = AppLocalizations.of(Get.context!)!.september;
        break;
      case MonthList.october:
        returnText = AppLocalizations.of(Get.context!)!.october;
        break;
      case MonthList.november:
        returnText = AppLocalizations.of(Get.context!)!.november;
        break;
      case MonthList.december:
        returnText = AppLocalizations.of(Get.context!)!.december;
        break;
    }

    return returnText;
}

static int? getMonthInt(MonthList month){
    int? returnValue = null;

    switch(month) {
      case MonthList.all:
        returnValue = null;
        break;
      case MonthList.january:
        returnValue = 1;
        break;
      case MonthList.february:
        returnValue = 2;
        break;
      case MonthList.march:
        returnValue = 3;
        break;
      case MonthList.april:
        returnValue = 4;
        break;
      case MonthList.may:
        returnValue = 5;
        break;
      case MonthList.june:
        returnValue = 6;
        break;
      case MonthList.july:
        returnValue = 7;
        break;
      case MonthList.august:
        returnValue = 8;
        break;
      case MonthList.september:
        returnValue = 9;
        break;
      case MonthList.october:
        returnValue = 10;
        break;
      case MonthList.november:
        returnValue = 11;
        break;
      case MonthList.december:
        returnValue = 12;
        break;
    }

    return returnValue;
}

static String getCurrencyValue(String locale, int price, int? digits){
    String returnText = price == 0 ? "": NumberFormat.simpleCurrency(locale: locale, decimalDigits: digits).format(price);

    return returnText;
}

static String trimDecimalZero(String value) {
  if (value.endsWith(".0")) {
    value = value.substring(0, value.length - 2);
  }
  return value;
}

static String getDayFilterName(WatchDayChartFilterEnum filter){
    String returnString = "";

    switch(filter) {
      case WatchDayChartFilterEnum.all:
        returnString = AppLocalizations.of(Get.context!)!.all;
        break;
      case WatchDayChartFilterEnum.thisYear:
        returnString = AppLocalizations.of(Get.context!)!.thisYear;
        break;
      case WatchDayChartFilterEnum.lastYear:
        returnString = AppLocalizations.of(Get.context!)!.lastYear;
        break;
      case WatchDayChartFilterEnum.last12months:
        returnString = AppLocalizations.of(Get.context!)!.last12Months;
        break;
      case WatchDayChartFilterEnum.last90days:
        returnString = AppLocalizations.of(Get.context!)!.last90days;
        break;
    }

    return returnString;
}

  static String getMonthFilterName(WatchMonthChartFilterEnum filter){
    String returnString = "";

    switch(filter) {

      case WatchMonthChartFilterEnum.all:
        returnString = AppLocalizations.of(Get.context!)!.all;
        break;
      case WatchMonthChartFilterEnum.thisYear:
        returnString = AppLocalizations.of(Get.context!)!.thisYear;
        break;
      case WatchMonthChartFilterEnum.lastYear:
        returnString = AppLocalizations.of(Get.context!)!.lastYear;
        break;
      case WatchMonthChartFilterEnum.last12months:
        returnString = AppLocalizations.of(Get.context!)!.last12Months;
        break;
    }

    return returnString;
  }

  static String getChartGroupingText(ChartGrouping value){
    switch(value) {
      case ChartGrouping.watch:
        return AppLocalizations.of(Get.context!)!.watch;
      case ChartGrouping.movement:
        return AppLocalizations.of(Get.context!)!.movement;
      case ChartGrouping.category:
        return AppLocalizations.of(Get.context!)!.category;
      case ChartGrouping.manufacturer:
        return AppLocalizations.of(Get.context!)!.manufacturer;
      case ChartGrouping.caseDiameter:
        return AppLocalizations.of(Get.context!)!.caseDiameter;
      case ChartGrouping.lugWidth:
        return AppLocalizations.of(Get.context!)!.lugWidth;
      case ChartGrouping.lug2lug:
        return AppLocalizations.of(Get.context!)!.lugToLug;
      case ChartGrouping.caseThickness:
        return AppLocalizations.of(Get.context!)!.caseThickness;
      case ChartGrouping.waterResistance:
        return AppLocalizations.of(Get.context!)!.waterResistance;
      case ChartGrouping.caseMaterial:
        return AppLocalizations.of(Get.context!)!.caseMaterial;
      case ChartGrouping.dateComplication:
        return AppLocalizations.of(Get.context!)!.dateComplication;
        default:
          return "";
    }
  }

  static String getGallerySelectionName(GallerySelectionEnum selection){
    String returnString = "";

    switch(selection) {
      case GallerySelectionEnum.watchbox:
        returnString = AppLocalizations.of(Get.context!)!.galleryCollectionTab;
        break;
      case GallerySelectionEnum.favourite:
        returnString = AppLocalizations.of(Get.context!)!.favouriteWatches;
        break;
      case GallerySelectionEnum.sold:
        returnString = AppLocalizations.of(Get.context!)!.soldWatches;
        break;
      case GallerySelectionEnum.archived:
        returnString = AppLocalizations.of(Get.context!)!.galleryArchivedTab;
        break;
      case GallerySelectionEnum.retired:
        returnString = AppLocalizations.of(Get.context!)!.retiredWatches;
        break;
      case GallerySelectionEnum.preordered:
        returnString = AppLocalizations.of(Get.context!)!.preorderStatusPopupDialogTitle;
        break;
      case GallerySelectionEnum.wishlist:
        returnString = AppLocalizations.of(Get.context!)!.galleryWishlistedWatchesTab;
        break;
      case GallerySelectionEnum.all:
        returnString = AppLocalizations.of(Get.context!)!.galleryEverythingTab;
        break;
    }

    return returnString;

  }

  static DateComplicationEnum getDateComplicationEnum(String? date){
    return DateComplicationEnumLocalization.fromDbString(date);
  }

  static String getDateComplicationName(DateComplicationEnum date){
    return date.toDbString();
  }

  static String getGallerySubheaderText(Watches watch){
    String returnString = "${watch.status}";
    
    //["In Collection", "Sold", "Wishlist", "Pre-Order", "Retired", "Archived"];
    
    switch(watch.status){
      case "In Collection":
        var favourite = watch.favourite? " (Favourite)" : "";
        returnString = "$returnString$favourite - ${WristCheckFormatter.getWearCountText(watch.wearList.length)}";
        break;
      case "Sold":
        if(watch.soldDate != null) {
          var soldDateText = "Sold Date:";
          var soldDate = watch.soldDate == ""
              ? "$soldDateText (not captured)"
              : "$soldDateText ${WristCheckFormatter.getFormattedDate(watch.soldDate!)}";
          returnString = "$returnString - $soldDate";
        }
        break;
      case "Pre-Order":
        if(watch.deliveryDate != null){
          var dueDateText = "Due Date:";
          var soldDate = watch.deliveryDate == ""
              ? "$dueDateText (not captured)"
              : "$dueDateText ${WristCheckFormatter.getFormattedDate(watch.deliveryDate!)}";
          returnString = "$returnString - $soldDate";
        }
    }

    return returnString;
  }

  static String getWearCountText(int wearCount){
    return wearCount == 1? "Worn 1 time" : "Worn: $wearCount times";
  }

  static String getUploadStatusText(UploadStatusEnum status){
    String returnString = "";

    switch(status) {
      case UploadStatusEnum.pass:
        returnString = AppLocalizations.of(Get.context!)!.pass;
        break;
      case UploadStatusEnum.fail:
        returnString = AppLocalizations.of(Get.context!)!.fail;
        break;
      case UploadStatusEnum.partialpass:
        returnString = AppLocalizations.of(Get.context!)!.partialPass;
        break;
      case UploadStatusEnum.duplicate:
        returnString = AppLocalizations.of(Get.context!)!.duplicateFound;
        break;
    }
    return returnString;
  }


  static String getUploadStatusSubtitle(UploadStatusEnum status){
    String returnString = "";

    switch(status) {
      case UploadStatusEnum.pass:
        returnString = AppLocalizations.of(Get.context!)!.successSubtitle;
        break;
      case UploadStatusEnum.fail:
        returnString = AppLocalizations.of(Get.context!)!.failureSubtitle;
        break;
      case UploadStatusEnum.partialpass:
        returnString = AppLocalizations.of(Get.context!)!.partialPassSubtitle;
        break;
      case UploadStatusEnum.duplicate:
        returnString = AppLocalizations.of(Get.context!)!.duplicateFoundSubtitle;
        break;
      default:
        returnString = "";
        break;
    }
    return returnString;
  }

  static String getAccuracyPeriodText(RateUnit unit){
    String returnText = "Day";
    final l = AppLocalizations.of(Get.context!);

    switch(unit) {
      case RateUnit.day:
        returnText = l!.day;
        break;
      case RateUnit.month:
        returnText = l!.month;
        break;
      case RateUnit.year:
        returnText = l!.year;
        break;
    }

    return returnText;
  }


}

