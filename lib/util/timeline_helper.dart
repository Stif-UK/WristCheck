import 'package:flutter/material.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/model/enums/timeline_type_enum.dart';
import 'package:wristcheck/model/watches.dart';

class TimeLineHelper{
  static List<TimeLineEvent>getTimeLineData(){
    List<TimeLineEvent> returnList = [];
    Set<int> years = {};
    List<Watches> initialList = Boxes.getAllNonArchivedWatches();
    //Populate purchase and sale dates
    for(Watches watch in initialList){
      if(watch.purchaseDate != null){
        returnList.add(TimeLineEvent(TimeLineEventType.purchase, watch.purchaseDate!, "${watch.toString()} purchased."));
        years.add(watch.purchaseDate!.year);
      }
      if(watch.soldDate != null){
        returnList.add(TimeLineEvent(TimeLineEventType.sold, watch.soldDate!, "${watch.toString()} sold."));
        years.add(watch.purchaseDate!.year);
      }
      if(watch.lastServicedDate != null && watch.status == "In Collection"){
        returnList.add(TimeLineEvent(TimeLineEventType.service, watch.lastServicedDate!, "${watch.toString()} last serviced."));
      }
      if(watch.warrantyEndDate != null && watch.status == "In Collection"){
        returnList.add(TimeLineEvent(TimeLineEventType.warranty, watch.warrantyEndDate!, "${watch.toString()} warranty expires."));
      }
    }
    
    //For each year add an event
    for(int year in years){
      returnList.add(TimeLineEvent(TimeLineEventType.year, DateTime(year), year.toString()));
    }
    

    //Sort the list by date
    returnList.sort((a, b) => a.date.compareTo(b.date));

    return returnList;

  }

  static IconData? getTimeLineIcon(TimeLineEventType? type){
    IconData? returnIcon;

    switch(type) {
      case TimeLineEventType.purchase:
        returnIcon = Icons.attach_money_outlined;// FontAwesomeIcons.dollarSign;
        break;
      case TimeLineEventType.sold:
        returnIcon = Icons.local_grocery_store; //FontAwesomeIcons.handHoldingDollar;
        break;
      case null:
        returnIcon;
        break;
      case TimeLineEventType.year:
        returnIcon = Icons.calendar_month_outlined;
        break;
      case TimeLineEventType.service:
        returnIcon = Icons.build_rounded;
        break;
      case TimeLineEventType.warranty:
        returnIcon = Icons.construction_outlined;
        break;
    }

    return returnIcon;
  }

  static Color getTimeLineIndicatorColour(TimeLineEventType? type){
    Color returnColour = Colors.grey;

    switch(type) {
      case TimeLineEventType.purchase:
        returnColour = Colors.green;
        break;
      case TimeLineEventType.sold:
        returnColour = Colors.redAccent;
        break;
      case null:
       returnColour = Colors.grey;
        break;
      case TimeLineEventType.year:
        returnColour = Colors.grey;
        break;
      case TimeLineEventType.service:
        returnColour = Colors.blueAccent;
        break;
      case TimeLineEventType.warranty:
        returnColour = Colors.purpleAccent;
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

  late final TimeLineEventType type;
  late final DateTime date;
  late final String description;
}