import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/model/enums/default_chart_type.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/ui/charts/wear_chart.dart';
import 'package:wristcheck/ui/charts/wear_pie_chart.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:typed_data';
import 'package:share_plus/share_plus.dart';
import 'package:wristcheck/ui/widgets/wearfilter_bottomsheet.dart';

/// In this class we'll create a widget to graph which watches have been worn, and how often
/// eventually extending this to allow for different parameters to be passed in to redraw the graph
class WearStatsV2 extends StatefulWidget {
  WearStatsV2({Key? key}) : super(key: key);
  final wristCheckController = Get.put(WristCheckController());

  @override
  State<WearStatsV2> createState() => _WearStatsState();
}

class _WearStatsState extends State<WearStatsV2> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;


  ScreenshotController screenshotController = ScreenshotController();
  List<Watches> data = Boxes.getWearChartLoadData();


  @override
  void initState() {
    analytics.setAnalyticsCollectionEnabled(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    analytics.setCurrentScreen(screenName: "wear_charts_v2");
    DefaultChartType _preferredType = WristCheckPreferences.getDefaultChartType() ?? DefaultChartType.bar;
    bool barChart = _preferredType == DefaultChartType.bar? true: false;

    return Screenshot(
      controller: screenshotController,
      child: Scaffold(
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
          body: Column(

            children: [
              _buildFilterRow(context),
              // const SizedBox(height: 10),
              Expanded(
                  flex: 7,
                  //Switch between a bar chart and pie chart with the press of a button
                  child: barChart? WearChart(data: data, animate: true) : WearPieChart(data: data, animate: true)),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [


                  const SizedBox(height: 10),
                  widget.wristCheckController.isAppPro.value? const Text("This chart generated with WristCheck Pro") : const Text ("This chart generated with WristCheck"),
                  const SizedBox(height: 20,)
                ],
              )
            ],
          )),
    );
  }

  Widget _buildFilterRow(BuildContext context){
    return Row(
      children: [
        Expanded(child: Padding(
          padding: const EdgeInsets.fromLTRB(10,0,0,0),
          child: Text("Filter:",
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.left,
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
    final image = File('${directory.path}/shareImage.png');
    image.writeAsBytesSync(bytes);
    await Share.shareFiles([image.path],text: "Chart generated with WristCheck");
  }
}


