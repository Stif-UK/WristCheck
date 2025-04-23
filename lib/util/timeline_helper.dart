import 'package:flutter/material.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/model/enums/timeline_type_enum.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/ui/decoration/decoration_helper.dart';

class TimeLineHelper{
  static List<TimeLineEvent>getTimeLineData(bool orderAscending, bool showPurchases, bool showSold, bool showServiced, bool showNextService, bool showWarranty, bool showPreOrders){
    List<TimeLineEvent> returnList = [];
    Set<int> years = {};
    List<Watches> initialList = Boxes.getAllNonArchivedWatches();
    //Populate purchase and sale dates
    for(Watches watch in initialList){
      if(showPurchases && watch.purchaseDate != null){
        returnList.add(TimeLineEvent(TimeLineEventType.purchase, watch.purchaseDate!, "${watch.toString()} purchased."));
        years.add(watch.purchaseDate!.year);
      }
      if(showSold && watch.soldDate != null){
        returnList.add(TimeLineEvent(TimeLineEventType.sold, watch.soldDate!, "${watch.toString()} sold."));
        years.add(watch.soldDate!.year);
      }
      if(showPreOrders && watch.status == "Pre-Order" && watch.deliveryDate != null){
        returnList.add(TimeLineEvent(TimeLineEventType.preorder, watch.deliveryDate!, "${watch.toString()} pre-order due"));
      }
      if(showServiced && watch.lastServicedDate != null && watch.status == "In Collection"){
        returnList.add(TimeLineEvent(TimeLineEventType.lastService, watch.lastServicedDate!, "${watch.toString()} last serviced."));
        years.add(watch.lastServicedDate!.year);
      }
      if(showNextService && watch.nextServiceDue != null && watch.status == "In Collection"){
        returnList.add(TimeLineEvent(TimeLineEventType.nextService, watch.nextServiceDue!, "${watch.toString()} next service due."));
        years.add(watch.nextServiceDue!.year);
      }
      if(showWarranty && watch.warrantyEndDate != null && watch.status == "In Collection"){
        returnList.add(TimeLineEvent(TimeLineEventType.warranty, watch.warrantyEndDate!, "${watch.toString()} warranty expires."));
        years.add(watch.warrantyEndDate!.year);
      }
    }
    
    //For each year add an event
    for(int year in years){
      DateTime trackedYear = orderAscending? DateTime(year) : DateTime(year, 12, 31, 23, 59, 59);
      returnList.add(TimeLineEvent(TimeLineEventType.year, trackedYear, year.toString()));
    }
    

    //Sort the list by date
    returnList.sort((a, b) => a.date.compareTo(b.date));
    if(!orderAscending) returnList = returnList.reversed.toList();
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
      case TimeLineEventType.lastService:
        returnIcon = Icons.build_rounded;
        break;
      case TimeLineEventType.warranty:
        returnIcon = Icons.construction_outlined;
        break;
      case TimeLineEventType.nextService:
        returnIcon = Icons.handyman;
        break;
      case TimeLineEventType.preorder:
        returnIcon = Icons.mail;
        break;
    }

    return returnIcon;
  }

  static Color getTimeLineIndicatorColour(TimeLineEvent event){
    Color returnColour = Colors.grey;
    TimeLineEventType type = event.type;

    switch(type) {
      case TimeLineEventType.purchase:
        returnColour = Colors.green;
        break;
      case TimeLineEventType.sold:
        returnColour = Colors.redAccent;
        break;
      case TimeLineEventType.year:
        returnColour = Colors.grey;
        break;
      case TimeLineEventType.lastService:
        returnColour = Colors.blueAccent;
        break;
      case TimeLineEventType.warranty:
        returnColour = Colors.purpleAccent;
        break;
      case TimeLineEventType.nextService:
        returnColour = Colors.amber;
        break;
      case TimeLineEventType.preorder:
        returnColour = Colors.teal;
        break;
    }

    if(event.date.isAfter(DateTime.now())){
      returnColour = DecorationHelper.lightenColour(returnColour, 0.2);
    }

    return returnColour;
  }

  static Color getCardColour(TimeLineEvent event) {
    Color returnColour = DecorationHelper.lightenColour(TimeLineHelper.getTimeLineIndicatorColour(event), 0.2);
    if(event.date.isAfter(DateTime.now())){
      returnColour = DecorationHelper.lightenColour(returnColour, 0.2);
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