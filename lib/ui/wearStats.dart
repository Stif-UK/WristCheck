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

List<Watches> data = Boxes.getCollectionWatches();
bool barChart = true;

class _WearStatsState extends State<WearStats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wear to Date"),
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
                child: Container(
                  child: Text ("stuff"), //ToDo: populate with filter buttons
                ),
            )
            // const SizedBox(height: 10)
          ],
        ));
  }
}
