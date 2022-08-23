import 'package:flutter/material.dart';
import 'package:wristcheck/ui/charts/wear_chart.dart';
import 'package:wristcheck/ui/charts/wear_pie_chart.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/model/watches.dart';


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

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(
        title: const Text("Wear Stats"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: barChart? const Icon(Icons.pie_chart) : const Icon(Icons.bar_chart),
            onPressed: (){
                setState(() {
                  barChart = !barChart;
                });
            },),
          )
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
            // const SizedBox(height: 10)
          ],
        ));
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

}


