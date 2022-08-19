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
// List<Watches> data = Boxes.getWatchesWornThisYear(2020);
bool barChart = true;
enum ChartFilter { allTime, year, month }



class _WearStatsState extends State<WearStats> {
  ChartFilter _filter = ChartFilter.allTime;

  @override
  Widget build(BuildContext context) {


    switch (_filter){
      case ChartFilter.allTime: {
        data = Boxes.getCollectionWatches();
      }
      break;

      case ChartFilter.year: {
        //ToDo: Remove hardcoded 2020 value!
        data = Boxes.getWatchesWornFilter(3, 2018);
      }
      break;

      case ChartFilter.month: {
        //ToDo: Update to include month filter, using year as testing placeholder
        data = Boxes.getWatchesWornFilter(null, 2021);
      }
      break;

      default: {
        data = Boxes.getCollectionWatches();
      }
      break;
    }
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
              flex: 6,
                //Switch between a bar chart and pie chart with the press of a button
                child: barChart? WearChart(data: data, animate: true) : WearPieChart(data: data, animate: true)),
            Expanded(
              flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ListTile(
                      title: const Text('All Time'),
                      dense: true,
                      leading: Radio<ChartFilter>(
                        value: ChartFilter.allTime,
                        groupValue: _filter,
                        onChanged: (ChartFilter? value) {
                          setState(() {
                            _filter = value!;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('filter1 (current: Year = 2021)'),
                      dense: true,
                      leading: Radio<ChartFilter>(
                        value: ChartFilter.year,
                        groupValue: _filter,
                        onChanged: (ChartFilter? value) {
                          setState(() {
                            _filter = value!;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('filter2 (current: Year = 2020'),
                      dense: true,
                      leading: Radio<ChartFilter>(
                        value: ChartFilter.month,
                        groupValue: _filter,
                        onChanged: (ChartFilter? value) {
                          setState(() {
                            _filter = value!;
                          });
                        },
                      ),
                    ),
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
}
