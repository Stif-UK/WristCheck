import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/copy/copy.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
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
    final l = AppLocalizations.of(context)!;
    if (currentWatch.wearList.isEmpty) {
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                title: Text(
                  l.noDataRecorded,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: FaIcon(FontAwesomeIcons.folderOpen, size: 50.0),
              ),
              WristCheckCopy.getEmptyWearListWatchChartsCopy(),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: ResponsiveWatchChartsLayout(
        monthSection: _buildMonthSection(context, l),
        daySection: _buildDaySection(context, l),
        yearSection: _buildYearSection(context, l),
      ),
    );
  }

  Widget _buildMonthSection(BuildContext context, AppLocalizations l) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ListTile(
          title: Text(
            l.wearsByMonth,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.start,
          ),
          leading: const FaIcon(FontAwesomeIcons.calendarDays),
          trailing: Obx(
            () => IconButton(
              icon: ChartHelper.getWatchMonthChartIcon(
                wristCheckController.monthChartPreference.value,
              ),
              onPressed: () {
                ChartHelper.getNextMonthChart(
                  wristCheckController.monthChartPreference.value,
                );
              },
            ),
          ),
        ),
        _buildMonthFilterToggleRow(),
        WatchMonthChart(currentWatch: currentWatch),
      ],
    );
  }

  Widget _buildDaySection(BuildContext context, AppLocalizations l) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ListTile(
          title: Text(
            l.wearsByDay,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.start,
          ),
          leading: const FaIcon(FontAwesomeIcons.calendarDay),
          trailing: Obx(
            () => IconButton(
              icon: ChartHelper.getWatchDayChartIcon(
                wristCheckController.dayChartPreference.value,
              ),
              onPressed: () {
                ChartHelper.getNextDayChart(
                  wristCheckController.dayChartPreference.value,
                );
              },
            ),
          ),
        ),
        _buildDayFilterToggleRow(),
        WatchDayChart(currentWatch: currentWatch),
      ],
    );
  }

  Widget _buildYearSection(BuildContext context, AppLocalizations l) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ListTile(
          title: Text(
            l.wearsByYear,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.start,
          ),
          leading: const FaIcon(FontAwesomeIcons.calendarWeek),
          trailing: Obx(
            () => IconButton(
              icon: wristCheckController.yearChartPreference.value == WatchYearChartEnum.bar
                  ? const FaIcon(FontAwesomeIcons.chartBar)
                  : const FaIcon(FontAwesomeIcons.chartPie),
              onPressed: () {
                wristCheckController.yearChartPreference.value == WatchYearChartEnum.bar
                    ? wristCheckController.updateYearChartPreference(WatchYearChartEnum.pie)
                    : wristCheckController.updateYearChartPreference(WatchYearChartEnum.bar);
              },
            ),
          ),
        ),
        WatchYearChart(currentWatch: currentWatch),
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
                  title: AppLocalizations.of(Get.context!)!.filter,
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
              title: AppLocalizations.of(Get.context!)!.filter,
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

class ResponsiveWatchChartsLayout extends StatelessWidget {
  const ResponsiveWatchChartsLayout({
    super.key,
    required this.monthSection,
    required this.daySection,
    required this.yearSection,
    this.portraitMaxWidth = 720.0,
    this.landscapeBreakpoint = 900.0,
    this.landscapeMaxWidth = 1200.0,
    this.landscapeThirdChartMaxWidth = 600.0,
  });

  final Widget monthSection;
  final Widget daySection;
  final Widget yearSection;
  final double portraitMaxWidth;
  final double landscapeBreakpoint;
  final double landscapeMaxWidth;
  final double landscapeThirdChartMaxWidth;

  @override
  Widget build(BuildContext context) {
    final bool isLandscape = MediaQuery.orientationOf(context) == Orientation.landscape;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableWidth = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final bool useTwoColumns = isLandscape && availableWidth >= landscapeBreakpoint;

        if (useTwoColumns) {
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: landscapeMaxWidth),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: monthSection),
                      const SizedBox(width: 24),
                      Expanded(child: daySection),
                    ],
                  ),
                  const Divider(thickness: 2),
                  Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: landscapeThirdChartMaxWidth),
                      child: yearSection,
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          );
        }

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: portraitMaxWidth),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                monthSection,
                const Divider(thickness: 2),
                daySection,
                const Divider(thickness: 2),
                yearSection,
                const SizedBox(height: 50),
              ],
            ),
          ),
        );
      },
    );
  }
}
