import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/copy/copy.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/ui/charts/watch_charts_body.dart';
import 'package:wristcheck/ui/wristcheck_pro_prompt.dart';

class WatchCharts extends StatefulWidget {
  WatchCharts({
    Key? key,
    required this.currentWatch
  }) : super(key: key);

  Watches currentWatch;
  final wristCheckController = Get.put(WristCheckController());


  @override
  State<WatchCharts> createState() => _WatchChartsState();
}

class _WatchChartsState extends State<WatchCharts> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    analytics.setAnalyticsCollectionEnabled(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(screenName: "watch_charts");

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.currentWatch.manufacturer} ${widget.currentWatch.model}"),
      ),
      //Check if there is data available
      body: Obx(()=> SingleChildScrollView(
          child:
          widget.wristCheckController.isAppPro.value?
              WatchChartsBody(currentWatch: widget.currentWatch)
              :
              WristcheckProPrompt(textWidget: WristCheckCopy.getWatchWearChartsUpgradeCopy())

        ),
      ),
    );
  }
}
