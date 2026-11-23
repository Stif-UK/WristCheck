import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wristcheck/config.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/controllers/wrist_recap_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/adunits.dart';
import 'package:wristcheck/provider/adstate.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_widgets/recap_chart_builders.dart';
import 'package:wristcheck/util/ad_widget_helper.dart';
import 'package:wristcheck/util/helper_classes.dart';
import 'package:wristcheck/util/wear_charts_helper.dart';

class WearChart extends StatefulWidget {
  WearChart({super.key, this.isAppProOverride});

  final bool? isAppProOverride;

  @override
  State<WearChart> createState() => _WearChartState();
}

class _WearChartState extends State<WearChart> {
  BannerAd? banner;
  bool isExpanded = false;
  RecapCategoryChartType _chartType = RecapCategoryChartType.bar;

  bool get _isAppPro =>
      widget.isAppProOverride ?? Get.find<WristCheckController>().isAppPro.value;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isAppPro) {
      final adState = Provider.of<AdState>(context);
      adState.initialization.then((status) {
        if (!mounted) return;
        setState(() {
          banner = BannerAd(
              adUnitId: WristCheckConfig.prodBuild == false
                  ? adState.getTestAds
                  : AdUnits.recapWearChartAd,
              size: AdSize.banner,
              request: const AdRequest(),
              listener: adState.adListener)
            ..load();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Card(
          elevation: 4,
          margin: const EdgeInsets.all(8.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.wearChartTitle,
                        style: Theme.of(context).textTheme.bodyLarge,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          key: const Key('wear_chart_expand_button'),
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
                          key: const Key('wear_chart_type_button'),
                          icon: buildCategoryChartTypeIcon(_chartType),
                          onPressed: () {
                            setState(() {
                              _chartType = nextCategoryChartType(_chartType);
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                Obx(() {
                  final recapController = Get.find<WristRecapController>();
                  double baseHeight = MediaQuery.of(context).size.height * 0.35;
                  // Linear scaling: height increases every 10 watches from the base height
                  int count = recapController.watchesWorn.length;
                  double heightMultiplier = (count / 10).ceilToDouble();
                  if (heightMultiplier < 1.0) heightMultiplier = 1.0;

                  double chartHeight = baseHeight * heightMultiplier;
                  if (isExpanded) {
                    chartHeight *= 1.5;
                  }

                  return SizedBox(
                    height: chartHeight,
                    child: buildRecapCategoricalChart<WornWatchesClass>(
                      chartType: _chartType,
                      items: recapController.watchesWorn.toList(),
                      labelOf: (WornWatchesClass item) {
                        final suffix =
                            WearChartsHelper.getLabelSuffix(item.watch);
                        return suffix.isEmpty
                            ? item.watch.toString()
                            : '${item.watch} $suffix';
                      },
                      countOf: (WornWatchesClass item) => item.count,
                      barDataLabelOf: (WornWatchesClass item) =>
                          "${item.watch.toString()} ${WearChartsHelper.getLabelSuffix(item.watch)}: ${item.count}",
                      circularDataLabelOf: (WornWatchesClass item) {
                        final suffix =
                            WearChartsHelper.getLabelSuffix(item.watch);
                        final name = suffix.isEmpty
                            ? item.watch.toString()
                            : '${item.watch} $suffix';
                        return '$name: ${item.count}';
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
        if (widget.isAppProOverride != null)
          const SizedBox(height: 0)
        else
          Obx(() => Get.find<WristCheckController>().isAppPro.value
              ? const SizedBox(height: 0)
              : AdWidgetHelper.buildSmallAdSpace(banner, context)),
      ],
    );
  }
}
