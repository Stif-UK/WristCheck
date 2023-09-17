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
        returnText = "Mechanical";
        break;
      case MovementEnum.automatic:
        returnText = "Automatic";
        break;
      case MovementEnum.quartz:
        returnText = "Quartz";
        break;
    }
    return returnText;
  }

}

