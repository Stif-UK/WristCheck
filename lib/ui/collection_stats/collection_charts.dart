import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/copy/dialogs.dart';
import 'package:wristcheck/ui/charts/category_chart.dart';
import 'package:wristcheck/ui/charts/cost_per_wear_chart.dart';
import 'package:wristcheck/ui/charts/movement_chart.dart';

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
        children: [
          Padding(
            padding: getPagePadding(),
            child: Text("Cost Per Wear", style: Theme.of(context).textTheme.headlineSmall,),
          ),
          Obx(()=> Padding(
              padding: getPagePadding(),
              child: wristCheckController.isAppPro.value? const CostPerWearChart() : ListTile(
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
        ],
      ),
    );
  }

  EdgeInsets getPagePadding(){
    return const EdgeInsets.all(8.0);
  }
}
