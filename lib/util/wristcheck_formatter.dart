import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:wristcheck/model/enums/category.dart';
import 'package:wristcheck/model/enums/chart_grouping.dart';
import 'package:wristcheck/model/enums/collection_view.dart';
import 'package:wristcheck/model/enums/gallery_selection_enum.dart';
import 'package:wristcheck/model/enums/location.dart';
import 'package:wristcheck/model/enums/month_list.dart';
import 'package:wristcheck/model/enums/movement_enum.dart';
import 'package:wristcheck/model/enums/stats_enums/case_material_enum.dart';
import 'package:wristcheck/model/enums/stats_enums/winder_direction_enum.dart';
import 'package:wristcheck/model/enums/watch_day_chart_filter_enum.dart';
import 'package:wristcheck/model/enums/watch_month_chart_filter_enum.dart';
import 'package:wristcheck/model/watches.dart';

class WristCheckFormatter{

  static String getFormattedDate(DateTime date){
    final DateFormat formatter = DateFormat('yMMMd');
    String returnString = formatter.format(date);
    return returnString;
  }

  static String getFormattedDateWithDay(DateTime date){
    final DateFormat formatter = DateFormat('E');
    String returnString = "${formatter.format(date)}, ${WristCheckFormatter.getFormattedDate(date)}";
    return returnString;
  }

  static String getFormattedDateAndTime(DateTime date){
    return "${getFormattedDateWithDay(date)} - ${getTime(date, false)}";
  }

  static String getTime(DateTime date, bool militaryTime){
    final DateFormat formatter = militaryTime? DateFormat('Hms') : DateFormat('hh:mm:ss a');
    String returnString = formatter.format(date);
    return returnString;
  }

  static String getMonthFromDate(DateTime date){
    final DateFormat formatter = DateFormat('LLLL');
    return formatter.format(date);

  }

  static String getMonthName(int monthNumber) {
    DateTime date = DateTime(0, monthNumber);
    return DateFormat.MMM().format(date);
  }

  static String getCollectionText(CollectionView view){
    String returnText = "";

    switch (view) {
      case CollectionView.all:
        returnText = "Watch Box";
        break;
      case CollectionView.sold:
        returnText = "Sold Watches";
        break;
      case CollectionView.wishlist:
        returnText = "Wishlist";
        break;
      case CollectionView.favourites:
        returnText = "Favourite Watches";
        break;
      case CollectionView.random:
        returnText = "Random Watch";
        break;
      case CollectionView.preorder:
        returnText = "Pre-Orders";
        break;
      case CollectionView.retired:
        returnText = "Retired Watches";
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
    }
    return returnText;
  }

  static MovementEnum getMovementEnum(String? movement){
    MovementEnum returnValue = MovementEnum.blank;

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
    String returnString = "";

    switch(direction) {
      case WinderDirectionEnum.clockwise:
        returnString = "Clockwise";
        break;
      case WinderDirectionEnum.counterclockwise:
        returnString = "Counter-Clockwise";
        break;
      case WinderDirectionEnum.both:
        returnString = "Both";
        break;
      case WinderDirectionEnum.blank:
        returnString = "";
        break;
    }
    return returnString;
  }

  static WinderDirectionEnum getWinderDirectionEnum(String direction){
    WinderDirectionEnum returnValue = WinderDirectionEnum.blank;

    switch(direction) {
      case "Clockwise":
        returnValue = WinderDirectionEnum.clockwise;
        break;
      case "Counter-Clockwise":
        returnValue = WinderDirectionEnum.counterclockwise;
        break;
      case "Both":
        returnValue = WinderDirectionEnum.both;
        break;
      case "":
        returnValue = WinderDirectionEnum.blank;
        break;
      default:
        returnValue = WinderDirectionEnum.blank;
    }
    return returnValue;
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
        returnString = "Pound";
        break;
      case LocationEnum.irl:
        returnString = "Euro (Ireland)";
        break;
      case LocationEnum.ind:
        returnString = "Rupee";
        break;
      case LocationEnum.us:
        returnString = "Dollar";
        break;
      case LocationEnum.jap:
        returnString = "Yen";
        break;
      case LocationEnum.ger:
        returnString = "Euro (trailing icon)";
        break;
      case LocationEnum.dut:
        returnString = "Euro (leading icon)";
        break;
      case LocationEnum.swiss:
        returnString = "Swiss Franc";
        break;
      case LocationEnum.hun:
        returnString = "Hungarian Forint";
        break;
      case LocationEnum.pol:
        returnString = "Polish Zloty";
        break;
    }

    return returnString;
}

static String getMonthText(MonthList month){
    String returnText = "";

    switch(month) {
      case MonthList.all:
        returnText = "All";
        break;
      case MonthList.january:
        returnText = "January";
        break;
      case MonthList.february:
        returnText = "February";
        break;
      case MonthList.march:
        returnText = "March";
        break;
      case MonthList.april:
        returnText = "April";
        break;
      case MonthList.may:
        returnText = "May";
        break;
      case MonthList.june:
        returnText = "June";
        break;
      case MonthList.july:
        returnText = "July";
        break;
      case MonthList.august:
        returnText = "August";
        break;
      case MonthList.september:
        returnText = "September";
        break;
      case MonthList.october:
        returnText = "October";
        break;
      case MonthList.november:
        returnText = "November";
        break;
      case MonthList.december:
        returnText = "December";
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
        returnString = "All";
        break;
      case WatchDayChartFilterEnum.thisYear:
        returnString = "This Year";
        break;
      case WatchDayChartFilterEnum.lastYear:
        returnString = "Last Year";
        break;
      case WatchDayChartFilterEnum.last12months:
        returnString = "Last 12 months";
        break;
      case WatchDayChartFilterEnum.last90days:
        returnString = "Last 90 days";
        break;
    }

    return returnString;
}

  static String getMonthFilterName(WatchMonthChartFilterEnum filter){
    String returnString = "";

    switch(filter) {

      case WatchMonthChartFilterEnum.all:
        returnString = "All";
        break;
      case WatchMonthChartFilterEnum.thisYear:
        returnString = "This Year";
        break;
      case WatchMonthChartFilterEnum.lastYear:
        returnString = "Last Year";
        break;
      case WatchMonthChartFilterEnum.last12months:
        returnString = "Last 12 Months";
        break;
    }

    return returnString;
  }

  static String getChartGroupingText(ChartGrouping value){
    switch(value) {
      case ChartGrouping.watch:
        return "Watch";
      case ChartGrouping.movement:
        return "Movement";
      case ChartGrouping.category:
        return "Category";
      case ChartGrouping.manufacturer:
        return "Manufacturer";
      case ChartGrouping.caseDiameter:
        return "Case Diameter";
      case ChartGrouping.lugWidth:
        return "Lug Width";
      case ChartGrouping.lug2lug:
        return "Lug to Lug";
      case ChartGrouping.caseThickness:
        return "Case Thickness";
      case ChartGrouping.waterResistance:
        return "Water Resistance";
      case ChartGrouping.caseMaterial:
        return "Case Material";
        default:
          return "";
    }
  }

  static String getGallerySelectionName(GallerySelectionEnum selection){
    String returnString = "";

    switch(selection) {
      case GallerySelectionEnum.watchbox:
        returnString = "collection watches";
        break;
      case GallerySelectionEnum.favourite:
        returnString = "favourite watches";
        break;
      case GallerySelectionEnum.sold:
        returnString = "sold watches";
        break;
      case GallerySelectionEnum.archived:
        returnString = "archived watches";
        break;
      case GallerySelectionEnum.retired:
        returnString = "retired watches";
        break;
      case GallerySelectionEnum.preordered:
        returnString = "pre-ordered watches";
        break;
      case GallerySelectionEnum.wishlist:
        returnString = "wishlisted watches";
        break;
    }

    return returnString;

  }

  // static String getGallerySubheaderText(Watches watch){
  //   String returnString = "Status: ${watch.status}";
  //   switch(watch.status){
  //     case "In Collection":
  //       returnString = "$returnString, Worn"
  //   }
  //
  //   return returnString;
  // }

  static String getWearCountText(int wearCount){
    return wearCount == 1? "Worn 1 time" : "Worn: $wearCount times";
  }


}

