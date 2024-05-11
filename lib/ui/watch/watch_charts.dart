import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/copy/copy.dart';
import 'package:wristcheck/model/enums/default_chart_type.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/ui/charts/watch_days.dart';
import 'package:wristcheck/ui/charts/watch_months.dart';
import 'package:wristcheck/ui/remove_ads.dart';

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
        child: widget.wristCheckController.isAppPro.value?
        //TODO: Separate first option out into sub-page WatchChartsBody()
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            ListTile(
              title: Text("Wears by month",
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.start,),
              leading: Icon(FontAwesomeIcons.calendarDays),
              trailing: Obx( () => IconButton(
                  icon: widget.wristCheckController.monthChartPreference.value == DefaultChartType.bar? Icon(FontAwesomeIcons.chartPie) : Icon(FontAwesomeIcons.chartSimple),
                  onPressed: (){
                    widget.wristCheckController.monthChartPreference.value == DefaultChartType.bar? widget.wristCheckController.updateMonthChartPreference(DefaultChartType.pie) : widget.wristCheckController.updateMonthChartPreference(DefaultChartType.bar);
                  },
                ),
              )
            ),
            WatchMonthChart(currentWatch: widget.currentWatch),
            const Divider(thickness: 2,),
            ListTile(
              title: Text("Wears by day",
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.start,),
              leading: Icon(FontAwesomeIcons.calendarDay),
              trailing: Obx( () => IconButton(
                      icon: widget.wristCheckController.dayChartPreference.value == DefaultChartType.bar? Icon(FontAwesomeIcons.chartPie) : Icon(FontAwesomeIcons.chartSimple),
                      onPressed: (){
                      widget.wristCheckController.dayChartPreference.value == DefaultChartType.bar? widget.wristCheckController.updateDayChartPreference(DefaultChartType.pie) : widget.wristCheckController.updateDayChartPreference(DefaultChartType.bar);
    },
    ),
    )
            ),
            WatchDayChart(currentWatch: widget.currentWatch),
          ],
        ) :
            //TODO: Create generic Pro Feature page?
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListTile(
              title: Text("WristCheck Pro Feature", style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center,),
            ),
            Image.asset('assets/customicons/pro_icon.png',scale:1.0,height:75.0,width:75.0, color: Theme.of(context).hintColor),
            WristCheckCopy.getWatchWearChartsUpgradeCopy(),
            ElevatedButton(
              child: Text("Tell me more"),
              onPressed: () => Get.to(() => RemoveAds()),
            )
          ],
        )
      ),
    );
  }
}
