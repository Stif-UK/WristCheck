import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/model/enums/category.dart';
import 'package:wristcheck/model/enums/collection_view.dart';
import 'package:wristcheck/model/enums/watchbox_ordering.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/util/view_watch_helper.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/**
 * ListTileHelper provides helper methods to generate dynamic elements of List Tiles throughout the app
 */

class ListTileHelper {

  static Widget getServicingIcon(DateTime nextServicingDate){
    var dueSoon = const Icon(Icons.warning_amber_rounded, color: Colors.red,);
    var standard = const Icon(Icons.manage_history_rounded);

    return nextServicingDate.isBefore(Jiffy.now().add(months: 3).dateTime)?  dueSoon :  standard;
  }

  static Icon getCategoryIcon(CategoryEnum category){
    Icon returnIcon = const Icon(FontAwesomeIcons.sitemap);

    switch(category) {
      case CategoryEnum.blank:
        returnIcon = const Icon(FontAwesomeIcons.sitemap);
        break;
      case CategoryEnum.dive:
        returnIcon = const Icon(FontAwesomeIcons.waterLadder);
        break;
      case CategoryEnum.sports:
        returnIcon = const Icon(FontAwesomeIcons.personSnowboarding);
        break;
      case CategoryEnum.flight:
        returnIcon = const Icon(FontAwesomeIcons.plane);
        break;
      case CategoryEnum.field:
        returnIcon = const Icon(FontAwesomeIcons.personHiking);
        break;
      case CategoryEnum.dress:
        returnIcon = const Icon(FontAwesomeIcons.userTie);
        break;
      case CategoryEnum.tool:
        returnIcon = const Icon(FontAwesomeIcons.screwdriverWrench);
        break;
      case CategoryEnum.chronograph:
        returnIcon = const Icon(FontAwesomeIcons.stopwatch);
        break;
      case CategoryEnum.travel:
        returnIcon = const Icon(FontAwesomeIcons.earthAmericas);
        break;
    }

    return returnIcon;
  }

  static String getWatchboxListSubtitle(Watches watch, CollectionView view){
    String returnText = "";

    switch(view) {
      case CollectionView.all:
        returnText = _getStandardReturnText(watch);
        break;
      case CollectionView.favourites:
        returnText = _getStandardReturnText(watch);
        break;
      case CollectionView.wishlist:
        returnText = "";
        break;
      case CollectionView.sold:
        returnText = _getSoldReturnText(watch);
        break;
      case CollectionView.preorder:
        returnText = _getPreOrderReturnText(watch);
        break;
      case CollectionView.random:
        returnText = _getStandardReturnText(watch);
        break;
    }
    return returnText;
  }

  static String _getStandardReturnText(Watches watch){
    String returnText = "";
    if (watch.wearList.isNotEmpty) {
      int _wearCount = watch.wearList.length;
      watch.wearList.sort();
      String _lastWorn = ViewWatchHelper.isDateToday(watch.wearList.last)
          ? "Today"
          : WristCheckFormatter.getFormattedDate(watch.wearList.last);

      returnText =  "Last worn: $_lastWorn  \nWorn $_wearCount times";
    } else {
      returnText = "Not worn yet";
    }
    return returnText;
  }

  static String _getSoldReturnText(Watches watch){
    final wristCheckController = Get.put(WristCheckController());
    String locale = WristCheckFormatter.getLocaleString(wristCheckController.locale.value);
    String returnText = "Sold Test";
    DateTime? soldDate = watch.soldDate;
    int soldPrice = watch.soldPrice ?? 0;
    returnText = "Sold on: ${soldDate != null? WristCheckFormatter.getFormattedDate(soldDate): "Not Recorded"}\n"
        "for: ${soldPrice == 0? "Not Recorded":WristCheckFormatter.getCurrencyValue(locale, soldPrice, 0)}";
    return returnText;
  }

  static String _getPreOrderReturnText(Watches watch){
    String returnText = "Countdown: N/A";
    DateTime? dueDate = watch.deliveryDate;
    if(dueDate != null){
      Duration countdown = DateTime.now().difference(dueDate);
      if(countdown.inDays <= 0){
        returnText = "Due: ${countdown.inDays} days";
      }else{
        returnText = "Overdue: +${countdown.inDays} days";
      }

    }
    return returnText;
  }


  static Icon getWatchOrderIcon(WatchOrder? watchOrder){
    Icon returnIcon = const Icon(FontAwesomeIcons.sort);

    switch(watchOrder){
      case WatchOrder.watchbox:
        returnIcon = const Icon(FontAwesomeIcons.arrowDownWideShort);
        break;
      case WatchOrder.reverse:
        returnIcon = const Icon(FontAwesomeIcons.arrowUpWideShort);
        break;
      case WatchOrder.alpha_asc:
        returnIcon = const Icon(FontAwesomeIcons.arrowDownAZ);
        break;
      case WatchOrder.alpha_desc:
        returnIcon = const Icon(FontAwesomeIcons.arrowUpAZ);
        break;
      case WatchOrder.lastworn:
        returnIcon = const Icon(FontAwesomeIcons.arrowDown91);
        break;
      case WatchOrder.mostworn:
        returnIcon = const Icon(FontAwesomeIcons.chartLine);
        break;
    }

    return returnIcon;
  }

  static TextStyle? getSubtitleTheme(Watches watch){
    TextStyle? returnStyle = null;
    if(watch.status == "Pre-Order" && watch.deliveryDate != null){
      if (watch.deliveryDate!.isBefore(DateTime.now())) {
        returnStyle = TextStyle(
          color: Colors.red
        );
      }
    }
    return returnStyle;
  }


}