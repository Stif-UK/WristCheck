import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/wrist_recap_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/enums/wrist_recap_enums.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_widgets/recap_chart_builders.dart';
import 'package:wristcheck/util/helper_classes.dart';

class TopWatchMonthly extends StatefulWidget {
  const TopWatchMonthly({super.key});

  @override
  State<TopWatchMonthly> createState() => _TopWatchMonthlyState();
}

class _TopWatchMonthlyState extends State<TopWatchMonthly> {
  bool isExpanded = false;
  RecapMonthlyChartType _chartType = RecapMonthlyChartType.bar;

  @override
  Widget build(BuildContext context) {
    final recapController = Get.find<WristRecapController>();

    return Obx(() {
      if (recapController.selectedRecapOption.value != WristRecapEnums.annually ||
          recapController.topWatchMonthly.isEmpty) {
        return const SizedBox.shrink();
      }

      // Check if there are actually any watches worn in any month
      bool hasData =
          recapController.topWatchMonthly.any((element) => element.count > 0);
      if (!hasData) return const SizedBox.shrink();

      double baseHeight = MediaQuery.of(context).size.height * 0.35;
      int count = recapController.topWatchMonthly.length;
      double heightMultiplier = (count / 10).ceilToDouble();
      if (heightMultiplier < 1.0) heightMultiplier = 1.0;

      double chartHeight = baseHeight * heightMultiplier;
      if (isExpanded) {
        chartHeight *= 1.5;
      }

      return Card(
        elevation: 4,
        margin: const EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.topWatchMonthlyTitle,
                      style: Theme.of(context).textTheme.bodyLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        key: const Key('top_watch_monthly_expand_button'),
                        icon: FaIcon(
                          isExpanded
                              ? FontAwesomeIcons.compress
                              : FontAwesomeIcons.expand,
                          size: 16,
                        ),
                        onPressed: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                      ),
                      IconButton(
                        key: const Key('top_watch_monthly_chart_type_button'),
                        icon: buildMonthlyChartTypeIcon(_chartType),
                        onPressed: () {
                          setState(() {
                            _chartType = nextMonthlyChartType(_chartType);
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: chartHeight,
                child: buildRecapMonthlyChart<TopWatchMonthlyClass>(
                  context: context,
                  chartType: _chartType,
                  items: recapController.topWatchMonthly.toList(),
                  monthOf: (TopWatchMonthlyClass data) => data.month,
                  countOf: (TopWatchMonthlyClass data) => data.count,
                  nameOf: (TopWatchMonthlyClass data) =>
                      data.watch?.toString() ?? "",
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
