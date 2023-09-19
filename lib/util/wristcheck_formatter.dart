import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wristcheck/model/enums/collection_view.dart';
import 'package:wristcheck/model/enums/movement_enum.dart';

class WristCheckFormatter{

  static String getFormattedDate(DateTime date){
    final DateFormat formatter = DateFormat('yMMMd');
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

}

