import 'package:flutter/material.dart';
import 'package:wristcheck/ui/charts/wear_chart.dart';
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


class _WearStatsState extends State<WearStats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wear to Date"),
      ),
        body: Column(
          children: [
            const SizedBox(height: 10),
            Expanded(
              flex: 8,
                child: WearChart(data: data, animate: true)),
            const SizedBox(height: 10)
          ],
        ));
  }
}
