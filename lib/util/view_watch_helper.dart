import 'package:flutter/material.dart';
import 'package:wristcheck/model/enums/watchviewEnum.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:intl/intl.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class ViewWatchHelper{

  static WatchViewEnum getWatchViewState(Watches? watch, bool canEdit){
    if(watch == null){
      //State 1: Add note
      return WatchViewEnum.add;
    } else if(canEdit){
      //State 2: Edit Note
      return WatchViewEnum.edit;
    }
    //State 3(default): View Note
    return WatchViewEnum.view;
  }

  static Widget getTitle(WatchViewEnum watchviewState, String manufacturer, String model){
    //TODO: Update to create title from watch make + model
    String title = "$manufacturer $model";
    String returnText = title;
    switch(watchviewState){
      case WatchViewEnum.edit:
        returnText = "Edit: $title";
        break;
      case WatchViewEnum.add:
        returnText = "Add Watch";
        break;
      case WatchViewEnum.view:
        returnText = title;
        break;
    }

    return Text(returnText);
  }

  static Icon getEditIcon(bool editable){
    return !editable ? const Icon(Icons.edit) : const Icon(Icons.save);

  }

  static String getScheduleText(int schedule, Watches currentWatch){
    return schedule == 0? "N/A" : "Every ${currentWatch.serviceInterval} years";
  }

  static String getPurchaseDateToDisplay(Watches currentWatch, DateTime? purchaseDate, bool canEditPurchaseDate){
    if(canEditPurchaseDate){
      return purchaseDate != null ?  DateFormat
          .yMMMd().format(purchaseDate) : "Not Recorded";
    }else {
      return currentWatch.purchaseDate != null ? DateFormat
          .yMMMd().format(currentWatch.purchaseDate!) : "Not Recorded";
    }
  }

  static String getServiceDateToDisplay(Watches currentWatch, DateTime? lastServiceDate, bool canEditServiceDate){
    if(canEditServiceDate){
      return lastServiceDate != null ?  DateFormat
          .yMMMd().format(lastServiceDate) : "N/A";
    }else {
      return currentWatch.lastServicedDate != null ? DateFormat
          .yMMMd().format(currentWatch.lastServicedDate!) : "N/A";
    }
  }

  static String getLastWearDate(Watches currentWatch){
    if(currentWatch.wearList == null || currentWatch.wearList.isEmpty){
      return "N/A";
    }else {
      var wearList = currentWatch.wearList;
      wearList.sort();
      return ViewWatchHelper.isDateToday(wearList.last)? "Today" : WristCheckFormatter.getFormattedDate(wearList.last);
    }
  }
  
  static bool isDateToday(DateTime submittedDate){
    final now = DateTime.now();
    return now.day == submittedDate.day &&
    now.month == submittedDate.month &&
    now.year == submittedDate.year;
  }

  static DateTime? getDateFromFieldString(String dateField){
    if(dateField == "Not Recorded" || dateField == "N/A"){
      return null;
    } else {
      final dateFormat = DateFormat('MMM d, yyyy');
      return dateField.length != 0 ? dateFormat.parse(dateField) : null;
    }
  }

  /**
   * getPrice takes a String as input and, if this is empty returns 0, otherwise it parses the string to return an integer value
   */
  static int getPrice(String price){
    return price.length == 0? 0: int.parse(price);
  }

}