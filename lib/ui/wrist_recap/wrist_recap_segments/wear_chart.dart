import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wristcheck/config.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/controllers/wrist_recap_controllers/wrist_recap_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/adunits.dart';
import 'package:wristcheck/provider/adstate.dart';
import 'package:wristcheck/util/ad_widget_helper.dart';
import 'package:wristcheck/util/helper_classes.dart';
import 'package:wristcheck/util/wear_charts_helper.dart';

class WearChart extends StatefulWidget {
  WearChart({super.key});

  @override
  State<WearChart> createState() => _WearChartState();
}

class _WearChartState extends State<WearChart> {
  final wristCheckController = Get.find<WristCheckController>();
  BannerAd? banner;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!wristCheckController.isAppPro.value) {
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
                Text(AppLocalizations.of(context)!.wearChartTitle),
                Obx(() {
                  final recapController = Get.find<WristRecapController>();
                  double baseHeight = MediaQuery.of(context).size.height * 0.35;
                  // Calculate multiplier: 1.0 for 0-9, 2.0 for 10-19, 4.0 for 20-29, etc.
                  int factor = recapController.watchesWorn.length ~/ 10;
                  double heightMultiplier = factor > 0 ? (1 << factor).toDouble() : 1.0;

                  return SizedBox(
                    height: baseHeight * heightMultiplier,
                    child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(
                        isVisible: false,
                      ),
                      primaryYAxis: NumericAxis(),
                      series: _getBarSeries(),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
        Obx(() => wristCheckController.isAppPro.value
            ? const SizedBox(height: 0)
            : AdWidgetHelper.buildSmallAdSpace(banner, context)),
      ],
    );
  }

  List<BarSeries<dynamic, dynamic>> _getBarSeries() {
    List<BarSeries<dynamic, dynamic>> returnSeries = [];
    final recapController = Get.put(WristRecapController());

    returnSeries = <BarSeries<WornWatchesClass, String>>[
      BarSeries(
        dataSource: recapController.watchesWorn.reversed.toList(),
        xValueMapper: (WornWatchesClass series, _) => (series.watch.toString()),
        yValueMapper: (WornWatchesClass series, _) => series.count,
        dataLabelMapper: (wornWatch, _) =>
            "${wornWatch.watch.toString()} ${WearChartsHelper.getLabelSuffix(wornWatch.watch)}: ${wornWatch.count}",
        dataLabelSettings: const DataLabelSettings(
            isVisible:
                true), //can add showZero = false here, however it just makes the labels invisible, it doesn't remove the line itself
        // animationDuration: 0 Set to zero to stop it animating!
      )
    ];

    return returnSeries;
  }
}
