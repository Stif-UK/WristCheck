import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/copy/copy.dart';
import 'package:wristcheck/model/enums/watch_day_chart_enum.dart';
import 'package:wristcheck/model/enums/watch_day_chart_filter_enum.dart';
import 'package:wristcheck/model/enums/watch_year_chart_enum.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/ui/charts/watch_charts/watch_days.dart';
import 'package:wristcheck/ui/charts/watch_charts/watch_months.dart';
import 'package:wristcheck/ui/charts/watch_charts/watch_years.dart';
import 'package:wristcheck/util/chart_helper_classes.dart';
import 'package:choice/choice.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

import '../../../model/enums/watch_month_chart_filter_enum.dart';

class WatchChartsBody extends StatelessWidget {
  WatchChartsBody({
    Key? key,
    required this.currentWatch
  }) : super(key: key);

  final Watches currentWatch;
  final wristCheckController = Get.put(WristCheckController());

  @override
  Widget build(BuildContext context) {
    return currentWatch.wearList.isNotEmpty ? SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          ListTile(
              title: Text("Wears by Month",
                style: Theme
                    .of(context)
                    .textTheme
                    .headlineSmall,
                textAlign: TextAlign.start,),
              leading: Icon(FontAwesomeIcons.calendarDays),
              trailing: Obx(() =>
                  IconButton(
                    icon: ChartHelper.getWatchMonthChartIcon(
                        wristCheckController.monthChartPreference.value),
                    onPressed: () {
                      ChartHelper.getNextMonthChart(
                          wristCheckController.monthChartPreference.value);
                    },
                  ),
              )
          ),
          _buildMonthFilterToggleRow(),
          WatchMonthChart(currentWatch: currentWatch),
          const Divider(thickness: 2,),
          ListTile(
              title: Text("Wears by Day",
                style: Theme
                    .of(context)
                    .textTheme
                    .headlineSmall,
                textAlign: TextAlign.start,),
              leading: Icon(FontAwesomeIcons.calendarDay),
              trailing: Obx(() =>
                  IconButton(
                    icon: ChartHelper.getWatchDayChartIcon(
                        wristCheckController.dayChartPreference.value),
                    onPressed: () {
                      ChartHelper.getNextDayChart(
                          wristCheckController.dayChartPreference.value);
                    },
                  ),
              )
          ),
          _buildDayFilterToggleRow(),
          WatchDayChart(currentWatch: currentWatch),
          const Divider(thickness: 2,),
          ListTile(title: Text("Wears by Year",
                    style: Theme
                        .of(context)
                        .textTheme
                        .headlineSmall,
                    textAlign: TextAlign.start,),
                    leading: Icon(FontAwesomeIcons.calendarWeek),
                    trailing: Obx(() =>
                    IconButton(
                    icon: wristCheckController.yearChartPreference.value == WatchYearChartEnum.bar ?
                    Icon(FontAwesomeIcons.chartBar):
                      Icon(FontAwesomeIcons.chartPie),
                    onPressed: () {
                    wristCheckController.yearChartPreference.value == WatchYearChartEnum.bar ?
                        wristCheckController.updateYearChartPreference(WatchYearChartEnum.pie) :
                        wristCheckController.updateYearChartPreference(WatchYearChartEnum.bar);
                    },
                    ),
                    )
          ),
          WatchYearChart(currentWatch: currentWatch),
          SizedBox(height: 50,), //Add some space at the bottom of the page
        ],
      ),
    ) :
    //Wearlist is empty
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ListTile(
          title: Text("No Data Recorded", style: Theme
              .of(context)
              .textTheme
              .headlineSmall, textAlign: TextAlign.center,),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(FontAwesomeIcons.folderOpen, size: 50.0,),
        ),
        WristCheckCopy.getEmptyWearListWatchChartsCopy(),
      ],
    );
  }


  _buildDayFilterToggleRow() {

    void setSingleSelected(String? value) {
    }

    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 250,
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Obx(()=> PromptedChoice<String>.single(
                  title: 'Filter:',
                    value: WristCheckFormatter.getDayFilterName(wristCheckController.dayChartFilter.value),
                    onChanged: setSingleSelected,
                    itemCount: WatchDayChartFilterEnum.values.length,
                    itemBuilder: (state, i) {
                      return Obx(()=> RadioListTile(
                            value: wristCheckController.dayChartFilter.value,
                            groupValue: state.single,
                            onChanged: (value) {
                              wristCheckController.updateDayChartFilter(WatchDayChartFilterEnum.values[i]);
                              Navigator.pop(Get.context!);
                            },
                            title: ChoiceText(
                              WristCheckFormatter.getDayFilterName(WatchDayChartFilterEnum.values[i]),
                              highlight: state.search?.value,
                            ),
                          ),
                      );
                    },
                  promptDelegate: ChoicePrompt.delegateBottomSheet(),
                anchorBuilder: ChoiceAnchor.create(inline: true),
                    ),
              ),
            ),
          )
        ],
      );
  }

  _buildMonthFilterToggleRow() {

    void setSingleSelected(String? value) {
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 250,
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Obx(()=> PromptedChoice<String>.single(
              title: 'Filter:',
              value: WristCheckFormatter.getMonthFilterName(wristCheckController.monthChartFilter.value),
              onChanged: setSingleSelected,
              itemCount: WatchMonthChartFilterEnum.values.length,
              itemBuilder: (state, i) {
                return Obx(()=> RadioListTile(
                  value: wristCheckController.monthChartFilter.value,
                  groupValue: state.single,
                  onChanged: (value) {
                    wristCheckController.updateMonthChartFilter(WatchMonthChartFilterEnum.values[i]);
                    Navigator.pop(Get.context!);
                  },
                  title: ChoiceText(
                    WristCheckFormatter.getMonthFilterName(WatchMonthChartFilterEnum.values[i]),
                    highlight: state.search?.value,
                  ),
                ),
                );
              },
              promptDelegate: ChoicePrompt.delegateBottomSheet(),
              anchorBuilder: ChoiceAnchor.create(inline: true),
            ),
            ),
          ),
        )
      ],
    );
  }

}
