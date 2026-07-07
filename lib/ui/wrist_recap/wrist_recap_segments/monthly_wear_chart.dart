import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wristcheck/config.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/controllers/wrist_recap_controllers/wrist_recap_monthly_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/adunits.dart';
import 'package:wristcheck/provider/adstate.dart';
import 'package:wristcheck/util/ad_widget_helper.dart';
import 'package:wristcheck/util/helper_classes.dart';
import 'package:wristcheck/util/wear_charts_helper.dart';

class MonthlyWearChart extends StatefulWidget {
  MonthlyWearChart({super.key});

  @override
  State<MonthlyWearChart> createState() => _MonthlyWearChartState();
}

class _MonthlyWearChartState extends State<MonthlyWearChart> {
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
      children: [
        Card(
          elevation: 4,
          margin: const EdgeInsets.all(8.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context)!.wearChartTitle),
                SfCartesianChart(
                    primaryXAxis: CategoryAxis(
                      isVisible: false,
                    ),
                    primaryYAxis: NumericAxis(),
                    series: _getBarSeries())
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
    final recapController = Get.put(WristRecapMonthlyController());

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
