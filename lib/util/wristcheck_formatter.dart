import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

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

}

