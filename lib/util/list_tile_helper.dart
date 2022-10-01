import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/util/view_watch_helper.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

/**
 * ListTileHelper provides helper methods to generate dynamic elements of List Tiles throughout the app
 */

class ListTileHelper {

  static Widget getServicingIcon(DateTime nextServicingDate){
    var dueSoon = const Icon(Icons.warning_amber_rounded, color: Colors.red,);
    var standard = const Icon(Icons.manage_history_rounded);

    return nextServicingDate.isBefore(Jiffy().add(months: 3).dateTime)?  dueSoon :  standard;
  }

  static String getWatchboxListSubtitle(Watches watch){

    if(watch.wearList.isNotEmpty) {
      int _wearCount = watch.wearList.length;
      watch.wearList.sort();
      String _lastWorn = ViewWatchHelper.isDateToday(watch.wearList.last)? "Today" : WristCheckFormatter.getFormattedDate(watch.wearList.last);

      return "Last worn: $_lastWorn  \nWorn $_wearCount times";
    }else{
      return "Not worn yet";
    }
  }


}