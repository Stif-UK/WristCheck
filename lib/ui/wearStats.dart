import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wristcheck/ui/charts/wear_chart.dart';
import 'package:wristcheck/ui/charts/wear_pie_chart.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:typed_data';
import 'package:share_plus/share_plus.dart';

/// In this class we'll create a widget to graph which watches have been worn, and how often
/// eventually extending this to allow for different parameters to be passed in to redraw the graph
class WearStats extends StatefulWidget {
  const WearStats({Key? key}) : super(key: key);

  @override
  State<WearStats> createState() => _WearStatsState();
}

String _monthValue = "All";
String _yearValue = "All";

List _monthList = ["All","January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
//yearValues and yearMap will need to BOTH be updated to enable additional years to be selected
//ToDo: There's a tidier way of dealing with years, the map is not necessary!
List _yearValues =  ["All","2019", "2020", "2021", "2022"];

Map _yearMap = {
  "All":null,
  "2019": 2019,
  "2020": 2020,
  "2021": 2021,
  "2022": 2022
};

Map _monthMap = {
  "All": null,
  "January":1,
  "February":2,
  "March":3,
  "April":4,
  "May":5,
  "June":6,
  "July":7,
  "August":8,
  "September":9,
  "October":10,
  "November":11,
  "December":12

};


List<Watches> data = Boxes.getWatchesWornFilter(_monthMap[_monthValue], _yearMap[_yearValue]);
bool barChart = true;

class _WearStatsState extends State<WearStats> {

  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {



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
              onPressed: (){
                  setState(() {
                    barChart = !barChart;
                  });
              },),
            ),
            Padding(padding: const EdgeInsets.fromLTRB(0,0,4,0),
            child: IconButton(
              icon: const Icon(Icons.add_a_photo_outlined),
              onPressed: () async {
                final image = await screenshotController.capture();
                saveAndShare(image!);
              },
            ),)
          ],
        ),
          body: Column(

            children: [
              // const SizedBox(height: 10),
              Expanded(
                flex: 7,
                  //Switch between a bar chart and pie chart with the press of a button
                  child: barChart? WearChart(data: data, animate: true) : WearPieChart(data: data, animate: true)),
              Expanded(
                flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [

                      _buildFilterRow(),
                      const SizedBox(height: 10),
                      const Text ("This chart generated with WristCheck"),
                      const SizedBox(height: 20,)
                    ],
                  ),
              )
            ],
          )),
    );
  }

  Widget _buildFilterRow(){
    return ExpansionTile(
      title: const Text("Filter Graph"),
      children: [Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Month: "),
          DropdownButton(
              value: _monthValue,
              items: _monthList
                  .map((status) => DropdownMenuItem(
                  value: status,
                  child: Text(status))

              ).toList(),
              onChanged: (status) {
                setState(() => _monthValue = status.toString());
              }
          ),
          const Text("Year: "),
          DropdownButton(
              value: _yearValue,
              items: _yearValues
                  .map((status) => DropdownMenuItem(
                  value: status,
                  child: Text(status))

              ).toList(),
              onChanged: (status) {
                setState(() => _yearValue = status.toString());
              }
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: InkWell(
                child: const Icon(Icons.send),
              onTap: (){
                  setState(() {
                    data = Boxes.getWatchesWornFilter(_monthMap[_monthValue], _yearMap[_yearValue]);
                  });
              }
            ),
          ),
          InkWell(
              child: const Icon(Icons.clear),
              onTap: (){
                setState(() {
                  _monthValue = "All";
                  _yearValue = "All";
                  data = Boxes.getWatchesWornFilter(_monthMap[_monthValue], _yearMap[_yearValue]);
                });
              }
          )
        ],
      ),
      ]
    );
  }

  Future saveAndShare(Uint8List bytes) async{
    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/shareImage.png');
    image.writeAsBytesSync(bytes);
    await Share.shareFiles([image.path],text: "Chart generated with WristCheck");
  }
}


