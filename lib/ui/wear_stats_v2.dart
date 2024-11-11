import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wristcheck/controllers/filter_controller.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/model/enums/default_chart_type.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/ui/charts/wear_chart.dart';
import 'package:wristcheck/ui/charts/wear_pie_chart.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wristcheck/ui/widgets/wearfilter_bottomsheet.dart';
import 'package:wristcheck/util/wear_charts_helper.dart';

/// In this class we'll create a widget to graph which watches have been worn, and how often
/// eventually extending this to allow for different parameters to be passed in to redraw the graph
class WearStatsV2 extends StatefulWidget {
  WearStatsV2({Key? key}) : super(key: key);
  final wristCheckController = Get.put(WristCheckController());
  final filterController = Get.put(FilterController());

  @override
  State<WearStatsV2> createState() => _WearStatsState();
}

class _WearStatsState extends State<WearStatsV2> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;


  ScreenshotController screenshotController = ScreenshotController();


  @override
  void initState() {
    analytics.setAnalyticsCollectionEnabled(true);
    widget.filterController.populateYearList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(screenName: "wear_charts_v2");
    DefaultChartType _preferredType = WristCheckPreferences.getDefaultChartType() ?? DefaultChartType.bar;
    bool barChart = _preferredType == DefaultChartType.bar? true: false;

    return Scaffold(
        appBar: AppBar(
          title: const Text("Wear Stats"),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0,0,4,0),
              child: IconButton(
                icon: barChart? const Icon(Icons.pie_chart) : const Icon(Icons.bar_chart),
                onPressed: () async {
                  DefaultChartType _newPreferredType;
                  if(_preferredType == DefaultChartType.bar){
                    _newPreferredType = DefaultChartType.pie;
                  }else{
                    _newPreferredType = DefaultChartType.bar;
                  }
                  await WristCheckPreferences.setDefaultChartType(_newPreferredType);
                  await analytics.logEvent(name: "chart_type_change",
                      parameters: {
                        "chart_type" : _newPreferredType.toString()
                      });

                  setState(() {
                  });
                },),
            ),
            Padding(padding: const EdgeInsets.fromLTRB(0,0,4,0),
              child: IconButton(
                icon: const Icon(Icons.add_a_photo_outlined),
                onPressed: () async {
                  await analytics.logEvent(name: "chart_screenshot_capture");
                  final image = await screenshotController.capture();
                  saveAndShare(image!);
                },
              ),)
          ],
        ),
        body: SingleChildScrollView(
          child: Screenshot(
            controller: screenshotController,
            child: Container(
              color: Theme.of(context).canvasColor,
              child: Column(

                children: [
                  _buildFilterRow(context),
                  Obx(
                      ()=>  SizedBox(
                          height: _calculateChartSpace(barChart, context),
                          child: _drawCharts(barChart))
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(height: 10),
                      widget.wristCheckController.isAppPro.value? const Text("This chart generated with WristTrack Pro") : const Text ("This chart generated with WristTrack"),
                      const SizedBox(height: 20,)
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }

  bool get _showAdvanced {
    return !widget.filterController.includeCollection.value || widget.filterController.includeSold.value ||
        widget.filterController.includeArchived.value || widget.filterController.pickGrouping.value || widget.filterController.filterByCategory.value || widget.filterController.filterByMovement.value;
  }

  Widget _buildFilterRow(BuildContext context){

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text("Filter:",
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.left,
          ),
        ),
        Expanded(child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Obx(()=> Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(WearChartsHelper.getBasicFilterHeaderText(widget.filterController.basicWearFilter.value),
                style: Theme.of(context).textTheme.titleLarge,
                ),
              _showAdvanced? InkWell(
                onTap: () {
                  widget.filterController.updateShrinkText(
                      !widget.filterController.shrinkText.value);
                },
                child: Obx(
                  ()=> widget.filterController.shrinkText.value? Text(_getAdvancedFilterText(),
                  style: _getAdvancedFilterTextStyle(),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,) : 
                  Text(_getAdvancedFilterText()
                  ,style: _getAdvancedFilterTextStyle()),
                ),
              ): const SizedBox(height: 0,),

            ],
          ),
          ),
        )),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            type: MaterialType.transparency,
            child: Ink(
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).secondaryHeaderColor,
              ),
              child: InkWell(
                //borderRadius: BorderRadius.circular(100.0),
                onTap: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context){
                        return WearFilterBottomSheet();
                      }
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(
                    FontAwesomeIcons.filter,
                    size: 22.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Future saveAndShare(Uint8List bytes) async{
    final directory = await getApplicationDocumentsDirectory();
    bool exists = await Directory("${directory.path}/cache").exists();
    if(!exists) {
      await Directory("${directory.path}/cache").create();
    }
    final image = File('${directory.path}/cache/shareImage.png');
    image.writeAsBytesSync(bytes);
    await Share.shareXFiles([XFile(image.path)],text: "Chart generated with WristTrack");
  }


  String _getAdvancedFilterText(){
    return WearChartsHelper.getAdvancedFilterHeaderText(
        widget.filterController.includeCollection.value,
        widget.filterController.includeSold.value,
        widget.filterController.includeArchived.value,
        widget.filterController.pickGrouping.value,
        widget.filterController.chartGrouping.value,
        widget.filterController.filterByCategory.value,
        widget.filterController.selectedCategories,
        widget.filterController.filterByMovement.value,
        widget.filterController.selectedMovements);
  }

  TextStyle _getAdvancedFilterTextStyle(){
    return TextStyle(
        color: Colors.red
    );
  }

  List<Watches> _getLoadData(){
    return Boxes.getWearChartLoadData(widget.filterController.basicWearFilter.value,
        widget.filterController.includeCollection.value,
        widget.filterController.includeSold.value,
        widget.filterController.includeArchived.value,
        widget.filterController.filterByCategory.value,
        widget.filterController.selectedCategories,
        widget.filterController.filterByMovement.value,
        widget.filterController.selectedMovements);
  }

  Widget _drawCharts(bool barChart){
    return barChart? WearChart(data: _getLoadData(), animate: true, grouping: widget.filterController.chartGrouping.value,) :
    WearPieChart(data: _getLoadData(), animate: true, grouping: widget.filterController.chartGrouping.value);
  }

  double _calculateChartSpace(bool barChart, BuildContext context){
    double baseSize = MediaQuery.of(context).size.height*0.7;
    if(barChart){
      if(_getLoadData().length > 0){
        int dataSize = _getLoadData().length;
        if (dataSize > 15) {
          baseSize = baseSize * (dataSize / 15);
        }
      }
    }

    return baseSize;
  }
}


