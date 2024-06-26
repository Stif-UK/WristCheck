import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/copy/copy.dart';
import 'package:wristcheck/model/enums/default_chart_type.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/ui/charts/watch_days.dart';
import 'package:wristcheck/ui/charts/watch_months.dart';

class WatchChartsBody extends StatelessWidget {
  WatchChartsBody({
    Key? key,
    required this.currentWatch
  }) : super(key: key);

  Watches currentWatch;
  final wristCheckController = Get.put(WristCheckController());

  @override
  Widget build(BuildContext context) {
    return currentWatch.wearList.isNotEmpty ? Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        ListTile(
            title: Text("Wears by month",
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.start,),
            leading: Icon(FontAwesomeIcons.calendarDays),
            trailing: Obx( () => IconButton(
              icon: wristCheckController.monthChartPreference.value == DefaultChartType.bar? Icon(FontAwesomeIcons.chartPie) : Icon(FontAwesomeIcons.chartSimple),
              onPressed: (){
                wristCheckController.monthChartPreference.value == DefaultChartType.bar? wristCheckController.updateMonthChartPreference(DefaultChartType.pie) : wristCheckController.updateMonthChartPreference(DefaultChartType.bar);
              },
            ),
            )
        ),
        WatchMonthChart(currentWatch: currentWatch),
        const Divider(thickness: 2,),
        ListTile(
            title: Text("Wears by day",
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.start,),
            leading: Icon(FontAwesomeIcons.calendarDay),
            trailing: Obx( () => IconButton(
              icon: wristCheckController.dayChartPreference.value == DefaultChartType.bar? Icon(FontAwesomeIcons.chartPie) : Icon(FontAwesomeIcons.chartSimple),
              onPressed: (){
                wristCheckController.dayChartPreference.value == DefaultChartType.bar? wristCheckController.updateDayChartPreference(DefaultChartType.pie) : wristCheckController.updateDayChartPreference(DefaultChartType.bar);
              },
            ),
            )
        ),
        WatchDayChart(currentWatch: currentWatch),
      ],
    ) :
        //Wearlist is empty
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ListTile(
          title: Text("No Data Recorded", style: Theme.of(context).textTheme.headlineSmall,textAlign: TextAlign.center,),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(FontAwesomeIcons.folderOpen, size: 50.0,),
        ),
        WristCheckCopy.getEmptyWearListWatchChartsCopy(),
      ],
    );
  }
}
