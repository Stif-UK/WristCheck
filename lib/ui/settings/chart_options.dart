import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:wristcheck/config.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/adunits.dart';
import 'package:wristcheck/model/enums/chart_ordering.dart';
import 'package:wristcheck/model/enums/wear_chart_options.dart';
import 'package:wristcheck/model/enums/default_chart_type.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/provider/adstate.dart';
import 'package:wristcheck/util/ad_widget_helper.dart';

class ChartOptions extends StatefulWidget {
  const ChartOptions({Key? key}) : super(key: key);


  @override
  State<ChartOptions> createState() => _ChartOptionsState();
}

class _ChartOptionsState extends State<ChartOptions> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  WearChartOptions _chartOption = WristCheckPreferences.getWearChartOptions() ?? WearChartOptions.all;
  ChartOrdering _chartOrder = WristCheckPreferences.getWearChartOrder() ?? ChartOrdering.watchbox;
  DefaultChartType _chartType = WristCheckPreferences.getDefaultChartType() ?? DefaultChartType.bar;

  BannerAd? banner;
  bool purchaseStatus = WristCheckPreferences.getAppPurchasedStatus() ?? false;


  @override
  void initState() {
    analytics.setAnalyticsCollectionEnabled(true);
    super.initState();
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(!purchaseStatus)
    {
      final adState = Provider.of<AdState>(context);
      adState.initialization.then((status) {
        setState(() {
          banner = BannerAd(
              adUnitId: WristCheckConfig.prodBuild == false? adState.getTestAds : AdUnits.chartOptionsAdUnitID,
              //If the device screen is large enough display a larger ad on this screen
              size: AdSize.largeBanner,
              request: const AdRequest(),
              listener: adState.adListener)
            ..load();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(screenName: "chart_options");
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(Get.context!)!.chartOptionsPageTitle),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ExpansionTile(
                    title: Text(AppLocalizations.of(Get.context!)!.wearChartsDefaultFilterSectionTitle),
                    leading: const Icon(Icons.filter_alt_outlined),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(AppLocalizations.of(Get.context!)!.wearChartsFilterGuidanceText),
                      ),
                      ListTile(
                        title: Text(AppLocalizations.of(Get.context!)!.showAllRecordedWears),
                        leading: Radio<WearChartOptions>(
                          value: WearChartOptions.all,
                          groupValue: _chartOption ,
                          onChanged: (WearChartOptions? value) async {
                            await WristCheckPreferences.setWearChartOptions(value!);
                            setState(() {
                              _chartOption = value;
                            });

                          },
                        ),
                      ),
                      ListTile(
                        title: Text(AppLocalizations.of(Get.context!)!.wornThisYear),
                        leading: Radio<WearChartOptions>(
                          value: WearChartOptions.thisYear,
                          groupValue: _chartOption ,
                          onChanged: (WearChartOptions? value) async {
                            await WristCheckPreferences.setWearChartOptions(value!);
                            setState(() {
                              _chartOption = value;
                            });

                          },
                        ),
                      ),
                      ListTile(
                        title: Text(AppLocalizations.of(Get.context!)!.wornThisMonth),
                        leading: Radio<WearChartOptions>(
                          value: WearChartOptions.thisMonth,
                          groupValue: _chartOption ,
                          onChanged: (WearChartOptions? value) async {
                            await WristCheckPreferences.setWearChartOptions(value!);
                            setState(() {
                              _chartOption = value;
                            });

                          },
                        ),
                      ),
                      ListTile(
                        title: Text(AppLocalizations.of(Get.context!)!.wornLastMonth),
                        leading: Radio<WearChartOptions>(
                          value: WearChartOptions.lastMonth,
                          groupValue: _chartOption ,
                          onChanged: (WearChartOptions? value) async {
                            await WristCheckPreferences.setWearChartOptions(value!);
                            setState(() {
                              _chartOption = value;
                            });

                          },
                        ),
                      ),
                      ListTile(
                        title: Text(AppLocalizations.of(Get.context!)!.wornInLast30Days),
                        leading: Radio<WearChartOptions>(
                          value: WearChartOptions.last30days,
                          groupValue: _chartOption ,
                          onChanged: (WearChartOptions? value) async {
                            await WristCheckPreferences.setWearChartOptions(value!);
                            setState(() {
                              _chartOption = value;
                            });

                          },
                        ),
                      ),
                      ListTile(
                        title: Text(AppLocalizations.of(Get.context!)!.wornInLast90Days),
                        leading: Radio<WearChartOptions>(
                          value: WearChartOptions.last90days,
                          groupValue: _chartOption ,
                          onChanged: (WearChartOptions? value) async {
                            await WristCheckPreferences.setWearChartOptions(value!);
                            setState(() {
                              _chartOption = value;
                            });

                          },
                        ),
                      ),
                      ListTile(
                        title: Text(AppLocalizations.of(Get.context!)!.wornInLast365Days),
                        leading: Radio<WearChartOptions>(
                          value: WearChartOptions.last365days,
                          groupValue: _chartOption ,
                          onChanged: (WearChartOptions? value) async {
                            await WristCheckPreferences.setWearChartOptions(value!);
                            setState(() {
                              _chartOption = value;
                            });

                          },
                        ),
                      ),
                      ListTile(
                        title: Text(AppLocalizations.of(Get.context!)!.sinceLastPurchase),
                        leading: Radio<WearChartOptions>(
                          value: WearChartOptions.lastPurchase,
                          groupValue: _chartOption ,
                          onChanged: (WearChartOptions? value) async {
                            await WristCheckPreferences.setWearChartOptions(value!);
                            setState(() {
                              _chartOption = value;
                            });

                          },
                        ),
                      ),
                    ],
                  ),
                  const Divider(thickness: 2,),
                  ExpansionTile(
                    title: const Text("Wear Stats results order"),
                    leading: const Icon(Icons.bar_chart_rounded),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: const Text("Set the default order that results show in the graph - by default watches are listed in the same order selected for the collection view, however can also be displayed in ascending or descending order."),
                      ),
                      ListTile(
                        title: const Text("Show in Collection Order"),
                        leading: Radio<ChartOrdering>(
                          value: ChartOrdering.watchbox,
                          groupValue: _chartOrder ,
                          onChanged: (ChartOrdering? value) async {
                            await WristCheckPreferences.setWearChartOrder(value!);
                            setState(() {
                              _chartOrder = value;
                            });

                          },
                        ),
                      ),
                      ListTile(
                        title: const Text("Ascending order by wear count"),
                        leading: Radio<ChartOrdering>(
                          value: ChartOrdering.ascending,
                          groupValue: _chartOrder ,
                          onChanged: (ChartOrdering? value) async {
                            await WristCheckPreferences.setWearChartOrder(value!);
                            setState(() {
                              _chartOrder = value;
                            });

                          },
                        ),
                      ),
                      ListTile(
                        title: const Text("Descending order by wear count"),
                        leading: Radio<ChartOrdering>(
                          value: ChartOrdering.descending,
                          groupValue: _chartOrder ,
                          onChanged: (ChartOrdering? value) async {
                            await WristCheckPreferences.setWearChartOrder(value!);
                            setState(() {
                              _chartOrder = value;
                            });

                          },
                        ),
                      ),

                    ],
                  ),
                  const Divider(thickness: 2,),
                  ExpansionTile(
                      title: const Text("Default chart type"),
                    leading: const Icon(Icons.pie_chart),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: const Text("Select the default chart type.\nThis can also be changed on the chart view itself and will remember the last chart type used."),
                      ),
                      ListTile(
                        title: Text(AppLocalizations.of(Get.context!)!.barChart),
                        leading: Radio<DefaultChartType>(
                          value: DefaultChartType.bar,
                          groupValue: _chartType ,
                          onChanged: (DefaultChartType? value) async {
                            await WristCheckPreferences.setDefaultChartType(value!);
                            setState(() {
                              _chartType = value;
                            });

                          },
                        ),
                      ),
                      ListTile(
                        title: Text(AppLocalizations.of(Get.context!)!.pieChart),
                        leading: Radio<DefaultChartType>(
                          value: DefaultChartType.pie,
                          groupValue: _chartType ,
                          onChanged: (DefaultChartType? value) async {
                            await WristCheckPreferences.setDefaultChartType(value!);
                            setState(() {
                              _chartType = value;
                            });

                          },
                        ),
                      ),
                    ],
                  ),
                  const Divider(thickness: 2,)
                ],
              ),
            ),
          ),
          purchaseStatus? const SizedBox(height: 0,) : AdWidgetHelper.buildLargeAdSpace(banner, context),
          purchaseStatus? const SizedBox(height: 0,) : const SizedBox(height: 40,)

        ],
      ),

    );
  }
}
