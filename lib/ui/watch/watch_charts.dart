import 'package:flutter/material.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/ui/charts/watch_months.dart';

class WatchCharts extends StatefulWidget {
  WatchCharts({
    Key? key,
    required this.currentWatch
  }) : super(key: key);

  Watches currentWatch;

  @override
  State<WatchCharts> createState() => _WatchChartsState();
}

class _WatchChartsState extends State<WatchCharts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.currentWatch.manufacturer} ${widget.currentWatch.model}"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Most worn months",
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,),
            WatchMonthChart(currentWatch: widget.currentWatch),
          ],
        ),
      ),
    );
  }
}
