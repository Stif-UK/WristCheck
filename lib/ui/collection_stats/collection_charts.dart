import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/copy/dialogs.dart';
import 'package:wristcheck/ui/charts/dimension_charts/case_diameters_chart.dart';
import 'package:wristcheck/ui/charts/category_chart.dart';
import 'package:wristcheck/ui/charts/cost_per_wear_chart.dart';
import 'package:wristcheck/ui/charts/dimension_charts/lug_width_chart.dart';
import 'package:wristcheck/ui/charts/movement_chart.dart';
import 'package:wristcheck/util/chart_helper_classes.dart';

class CollectionCharts extends StatefulWidget {
  const CollectionCharts({Key? key}) : super(key: key);

  @override
  State<CollectionCharts> createState() => _CollectionChartsState();
}

class _CollectionChartsState extends State<CollectionCharts> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;


  @override
  void initState() {
    analytics.setAnalyticsCollectionEnabled(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(screenName: "collection_charts");
    final wristCheckController = Get.put(WristCheckController());

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: getPagePadding(),
            child: Obx(()=> Text(wristCheckController.isAppPro.value? "Cost Per Wear" : "Go Pro!", style: Theme.of(context).textTheme.headlineSmall,)),
          ),
          Obx(()=> Padding(
              padding: getPagePadding(),
              child: wristCheckController.isAppPro.value? SizedBox(
                  height: _calculateChartSpace(context, ChartHelper.getCostPerWearChartSize()),
                  child: const CostPerWearChart()) : ListTile(
                title: Text("Upgrade to WristTrack Pro for more charts here..."),
                  trailing: Image.asset('assets/customicons/pro_icon.png',scale:1.0,height:30.0,width:30.0,color: Theme.of(context).hintColor),
                  onTap: () => WristCheckDialogs.getProUpgradeMessage(context)
              ),
            ),
          ),
          const Divider(thickness: 2,),
          Padding(
            padding: getPagePadding(),
            child: Text("Movements", style: Theme.of(context).textTheme.headlineSmall,),
          ),
          Padding(
            padding: getPagePadding(),
            child: const MovementChart(),
          ),
          const Divider(thickness: 2,),
          Padding(
            padding: getPagePadding(),
            child: Text("Categories", style: Theme.of(context).textTheme.headlineSmall,),
          ),
          Padding(
            padding: getPagePadding(),
            child: const CategoryChart(),
          ),
          const Divider(thickness: 2,),
          //Separate out other Pro charts for dimensions
          Obx(()=> wristCheckController.isAppPro.value? Column(
              children: [
                Padding(
                  padding: getPagePadding(),
                  child: Text("Dimensions: Case Diameter", style: Theme.of(context).textTheme.headlineSmall,),
                ),
                Padding(
                  padding: getPagePadding(),
                  child: const CaseDiameterChart(),
                ),
                Padding(
                  padding: getPagePadding(),
                  child: Text("Dimensions: Lug Width", style: Theme.of(context).textTheme.headlineSmall,),
                ),
                Padding(
                  padding: getPagePadding(),
                  child: const LugWidthChart(),
                ),
              ],
            ) : SizedBox(height: 0,),
          ),
        ],
      ),
    );
  }

  EdgeInsets getPagePadding(){
    return const EdgeInsets.all(8.0);
  }
}

double _calculateChartSpace(BuildContext context, int dataSize){
  double baseSize = MediaQuery.of(context).size.height*0.45;
  print("DataSize: $dataSize");

    if(dataSize > 10){
      baseSize = baseSize*(dataSize / 10);
    }
    print("BaseSize: $baseSize");

  return baseSize;
}
