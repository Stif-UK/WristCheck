import 'package:flutter/material.dart';
import 'package:wristcheck/model/watches.dart';

class ViewWatchHelper{

  static Icon getEditIcon(bool editable){
    return !editable ? const Icon(Icons.edit) : const Icon(Icons.save);

  }

  static String getScheduleText(int schedule, Watches currentWatch){
    return schedule == 0? "N/A" : "Every ${currentWatch.serviceInterval} years";
  }
}