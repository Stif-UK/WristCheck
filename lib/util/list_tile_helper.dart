import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

/**
 * ListTileHelper provides helper methods to generate dynamic elements of List Tiles throughout the app
 */

class ListTileHelper {

  static Widget getServicingIcon(DateTime nextServicingDate){
    var dueSoon = Icon(Icons.warning_amber_rounded, color: Colors.red,);
    var standard = Icon(Icons.manage_history_rounded);

    return nextServicingDate.isBefore(Jiffy().add(months: 3).dateTime)?  dueSoon :  standard;
  }

}