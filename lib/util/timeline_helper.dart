import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/model/enums/timeline_type_enum.dart';
import 'package:wristcheck/model/watches.dart';

class TimeLineHelper{
  static List<TimeLineEvent>getTimeLineData(){
    List<TimeLineEvent> returnList = [];
    List<Watches> initialList = Boxes.getAllNonArchivedWatches();
    //Populate purchase and sale dates
    for(Watches watch in initialList){
      if(watch.purchaseDate != null){
        returnList.add(TimeLineEvent(TimeLineType.purchase, watch.purchaseDate!, "${watch.toString()} purchased."));
      }
      if(watch.soldDate != null){
        returnList.add(TimeLineEvent(TimeLineType.sold, watch.soldDate!, "${watch.toString()} sold."));
      }
    }

    //Sort the list by date
    returnList.sort((a, b) => a.date.compareTo(b.date));

    return returnList;

  }

  static IconData? getTimeLineIcon(TimeLineType? type){
    IconData? returnIcon;

    switch(type) {
      case TimeLineType.purchase:
        returnIcon = Icons.attach_money_outlined;// FontAwesomeIcons.dollarSign;
        break;
      case TimeLineType.sold:
        returnIcon = Icons.local_grocery_store; //FontAwesomeIcons.handHoldingDollar;
        break;
      case null:
        returnIcon;
        break;
    }

    return returnIcon;
  }

  static Color getTimeLineIndicatorColour(TimeLineType? type){
    Color returnColour = Colors.grey;

    switch(type) {
      case TimeLineType.purchase:
        returnColour = Colors.green;
        break;
      case TimeLineType.sold:
        returnColour = Colors.redAccent;
        break;
      case null:
       returnColour = Colors.grey;
        break;
    }

    return returnColour;
  }
}

class TimeLineEvent{
  TimeLineEvent(
      this.type,
      this.date,
      this.description);

  late final TimeLineType type;
  late final DateTime date;
  late final String description;
}