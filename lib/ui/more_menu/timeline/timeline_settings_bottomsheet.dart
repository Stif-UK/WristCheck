import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wristcheck/controllers/timeline_controller.dart';
import 'package:get/get.dart';
import 'package:wristcheck/model/enums/timeline_type_enum.dart';
import 'package:wristcheck/util/timeline_helper.dart';


class TimelineSettingsBottomSheet extends StatefulWidget {
  TimelineSettingsBottomSheet({Key? key}) : super(key: key);
  final timelineController = Get.put(TimelineController());

  @override
  State<TimelineSettingsBottomSheet> createState() => _TimelineSettingsBottomSheetState();
}

class _TimelineSettingsBottomSheetState extends State<TimelineSettingsBottomSheet> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;


  @override
  void initState() {
    analytics.setAnalyticsCollectionEnabled(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(screenName: "timeline_sheet");

    return Container(
      decoration: BoxDecoration(
        color: Colors.white38,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(15),
      ),
      height: MediaQuery.of(context).size.height*0.65,
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //Header#
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Timeline Settings", style: Theme.of(context).textTheme.headlineSmall,),
          ),
          Obx(()=> SwitchListTile(
            value: widget.timelineController.timelineOrderAscending.value,
            onChanged: (newValue) {
              widget.timelineController.timelineOrderAscending(newValue);
            },
            title: widget.timelineController.timelineOrderAscending.value ? Text("Order: Ascending."):Text("Order: Descending."),
            secondary: widget.timelineController.timelineOrderAscending.value ? Icon(FontAwesomeIcons.upLong) : Icon(FontAwesomeIcons.downLong),
          ),
          ),
          Obx(()=> SwitchListTile(
              value: widget.timelineController.showPurchases.value,
              onChanged: (newValue) => widget.timelineController.updateShowPurchases(newValue),
              title: Text("Show watches purchased."),
              activeColor: TimeLineHelper.getTimeLineIndicatorColour(TimeLineEvent(TimeLineEventType.purchase, DateTime.now(), "")),
              secondary: Icon(TimeLineHelper.getTimeLineIcon(TimeLineEventType.purchase)),
          ),
          ),
          Obx(()=> SwitchListTile(
            value: widget.timelineController.showSales.value,
            onChanged: (newValue) => widget.timelineController.updateShowSales(newValue),
            title: Text("Show watches sold."),
            activeColor: TimeLineHelper.getTimeLineIndicatorColour(TimeLineEvent(TimeLineEventType.sold, DateTime.now(), "")),
            secondary: Icon(TimeLineHelper.getTimeLineIcon(TimeLineEventType.sold)),
          ),
          ),
          Obx(()=> SwitchListTile(
            value: widget.timelineController.showLastServiced.value,
            onChanged: (newValue) => widget.timelineController.updateShowLastServiced(newValue),
            title: Text("Show last serviced dates."),
            activeColor: TimeLineHelper.getTimeLineIndicatorColour(TimeLineEvent(TimeLineEventType.service, DateTime.now(), "")),
            secondary: Icon(TimeLineHelper.getTimeLineIcon(TimeLineEventType.service)),
          ),
          ),
          Obx(()=> SwitchListTile(
            value: widget.timelineController.showWarrantyEnd.value,
            onChanged: (newValue) => widget.timelineController.updateShowWarrantyEnd(newValue),
            title: Text("Show warranty end dates."),
            activeColor: TimeLineHelper.getTimeLineIndicatorColour(TimeLineEvent(TimeLineEventType.warranty, DateTime.now(), "")),
            secondary: Icon(TimeLineHelper.getTimeLineIcon(TimeLineEventType.warranty)),
          ),
          ),


        ],
      ),

    );
  }
}
