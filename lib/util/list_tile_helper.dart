import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
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

    if (view == CollectionView.all ||
        view == CollectionView.favourites ||
        view == CollectionView.random) {
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
    }
    if(view == CollectionView.preorder){
      //TODO: Implement pre-order countdown text
      returnText = "Placeholder Pre-Order text";
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


}