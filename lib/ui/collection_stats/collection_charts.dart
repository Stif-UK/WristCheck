import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/collection_stats_controller.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/copy/dialogs.dart';
import 'package:wristcheck/model/enums/collection_chart_enums/case_thickness_chart_enum.dart';
import 'package:wristcheck/model/enums/collection_chart_enums/lug2lug_chart_enum.dart';
import 'package:wristcheck/ui/charts/dimension_charts/case_diameters_chart.dart';
import 'package:wristcheck/ui/charts/category_chart.dart';
import 'package:wristcheck/ui/charts/cost_per_wear_chart.dart';
import 'package:wristcheck/ui/charts/dimension_charts/case_material_chart.dart';
import 'package:wristcheck/ui/charts/dimension_charts/case_thickness_chart.dart';
import 'package:wristcheck/ui/charts/dimension_charts/lug2lug_chart.dart';
import 'package:wristcheck/ui/charts/dimension_charts/lug_width_chart.dart';
import 'package:wristcheck/ui/charts/dimension_charts/water_resistance_chart.dart';
import 'package:wristcheck/ui/charts/movement_chart.dart';
import 'package:wristcheck/util/chart_helper_classes.dart';

class CollectionCharts extends StatefulWidget {
  CollectionCharts({Key? key}) : super(key: key);
  final collectionStatsController = Get.put(CollectionStatsController());

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
            child: Obx(()=> getCostPerWearHeader(wristCheckController.isAppPro.value)),
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
                  child: Text("Case Diameter", style: Theme.of(context).textTheme.headlineSmall,),
                ),
                Padding(
                  padding: getPagePadding(),
                  child: const CaseDiameterChart(),
                ),
                const Divider(thickness: 2,),
                Padding(
                  padding: getPagePadding(),
                  child: Text("Lug Width", style: Theme.of(context).textTheme.headlineSmall,),
                ),
                Padding(
                  padding: getPagePadding(),
                  child: const LugWidthChart(),
                ),
                const Divider(thickness: 2,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: getPagePadding(),
                      child: Text("Lug to Lug", style: Theme.of(context).textTheme.headlineSmall,),
                    ),
                    IconButton(
                      icon: widget.collectionStatsController.lug2lugChartType.value == Lug2lugChartEnum.line?
                      Icon(FontAwesomeIcons.chartLine):
                      Icon(FontAwesomeIcons.chartBar),
                      onPressed: (){
                        //On press swap between line and bar chart types
                        widget.collectionStatsController.lug2lugChartType.value == Lug2lugChartEnum.line ?
                        widget.collectionStatsController.updateLug2LugChartType(Lug2lugChartEnum.bar) :
                        widget.collectionStatsController.updateLug2LugChartType(Lug2lugChartEnum.line);
                      },
                    )
                  ],
                ),
                Padding(
                  padding: getPagePadding(),
                  child: L2LChart(),
                ),
                const Divider(thickness: 2,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: getPagePadding(),
                      child: Text("Case Thickness", style: Theme.of(context).textTheme.headlineSmall,),
                    ),
                    IconButton(
                      icon: widget.collectionStatsController.caseThicknessChartType.value == CaseThicknessChartEnum.line?
                      Icon(FontAwesomeIcons.chartLine):
                      Icon(FontAwesomeIcons.chartBar),
                      onPressed: (){
                        //On press swap between line and bar chart types
                        widget.collectionStatsController.caseThicknessChartType.value == CaseThicknessChartEnum.line ?
                        widget.collectionStatsController.updateCaseThicknessChartType(CaseThicknessChartEnum.bar) :
                            widget.collectionStatsController.updateCaseThicknessChartType(CaseThicknessChartEnum.line);
                      },
                    )
                  ],
                ),
                Padding(
                  padding: getPagePadding(),
                  child: CaseThicknessChart(),
                ),
                const Divider(thickness: 2,),
                Padding(
                  padding: getPagePadding(),
                  child: Text("Water Resistance", style: Theme.of(context).textTheme.headlineSmall,),
                ),
                Padding(
                  padding: getPagePadding(),
                  child: WaterResistanceChart(),
                ),
                const Divider(thickness: 2,),
                Padding(
                  padding: getPagePadding(),
                  child: Text("Case Materials", style: Theme.of(context).textTheme.headlineSmall,),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CaseMaterialChart(),
                ),
                const Divider(thickness: 2,)
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

  Widget getCostPerWearHeader(bool isPro){

    return !isPro? Text("Go Pro!", style: Theme.of(context).textTheme.headlineSmall,):
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 24,),
            Expanded(child: Center(child: Text( "Cost Per Wear", style: Theme.of(context).textTheme.headlineSmall,))),
            IconButton(
                icon: Icon(widget.collectionStatsController.showPrice.value? FontAwesomeIcons.dollarSign: Icons.money_off),
            onPressed: (){
                  widget.collectionStatsController.updateShowPrice(!widget.collectionStatsController.showPrice.value);
            },)
          ],
        );
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
