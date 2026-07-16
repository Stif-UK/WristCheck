import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:wristcheck/config.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/controllers/wrist_recap_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/adunits.dart';
import 'package:wristcheck/provider/adstate.dart';
import 'package:wristcheck/ui/wrist_recap/wrist_recap_widgets/insight_card.dart';
import 'package:wristcheck/util/ad_widget_helper.dart';

class WristRecapInsights extends StatefulWidget {
  WristRecapInsights({super.key});

  @override
  State<WristRecapInsights> createState() => _WristRecapInsightsState();
}

class _WristRecapInsightsState extends State<WristRecapInsights> {
  final recapController = Get.put(WristRecapController());
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
                  : AdUnits.recapInsightsAd,
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(context)!.insightsTitle,
                      style: Theme.of(context).textTheme.bodyLarge),
                  Obx(() => GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: _getInsights(context),
                      )),
                ],
              ),
            )),
        Obx(() => wristCheckController.isAppPro.value
            ? const SizedBox(height: 0)
            : AdWidgetHelper.buildSmallAdSpace(banner, context)),
      ],
    );
  }

  List<InsightCard> _getInsights(BuildContext context) {
    List<InsightCard> insights = [];
    if (recapController.watchesWorn.isNotEmpty) {
      int watchesWorn = recapController.watchesWorn.length;
      double wearCount = recapController.watchesWorn.fold(
          0, (previousValue, watch) => previousValue + watch.count);

      //Get total watches worn
      insights.add(InsightCard(
        title: AppLocalizations.of(context)!.watchesWornInsightTitle,
        value: watchesWorn.toString(),
        valueBig: true,
      ));
      //Get wears tracked per day
      //TODO: handle months and years with less than a full track - get first wear entry in the month or year and if later than the 1st of the month reduce count
      int days = recapController.getDaysInPeriod();

      //Total wear count
      insights.add(InsightCard(
        title: AppLocalizations.of(context)!.totalWearsInsightTitle,
        value: wearCount.toInt().toString(),
        valueBig: true,
      ));

      //Wears per day
      insights.add(InsightCard(
          title: AppLocalizations.of(context)!.wearsPerDayInsightTitle,
          value: (wearCount / days).toStringAsFixed(1),
          valueBig: true));
      //Top Brand
      if (recapController.brandsWorn.isNotEmpty) {
        insights.add(InsightCard(
          title: AppLocalizations.of(context)!.topBrandInsightTitle,
          value: recapController.brandsWorn.first.manufacturer,
          valueBig: false,
        ));
      }
      if (recapController.categoriesWorn.isNotEmpty) {
        insights.add(InsightCard(
            title: AppLocalizations.of(context)!.topCategoryInsightTitle,
            value: recapController.categoriesWorn.first.category,
            valueBig: false));
      }
    }
    return insights;
  }
}
