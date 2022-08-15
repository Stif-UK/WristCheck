import 'package:flutter/material.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:intl/intl.dart';

class ViewWatchHelper{

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
}