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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.currentWatch.manufacturer} ${widget.currentWatch.model}"),
      ),
      //Check if there is data available
      body: SingleChildScrollView(
        child: true?
        // widget.wristCheckController.isAppPro.value?
            WatchChartsBody(currentWatch: widget.currentWatch)
            :
            WristcheckProPrompt(textWidget: WristCheckCopy.getWatchWearChartsUpgradeCopy())

      ),
    );
  }
}
