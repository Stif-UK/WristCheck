import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wristcheck/model/enums/category.dart';
import 'package:wristcheck/model/enums/collection_view.dart';
import 'package:wristcheck/model/enums/location.dart';
import 'package:wristcheck/model/enums/month_list.dart';
import 'package:wristcheck/model/enums/movement_enum.dart';

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

}

