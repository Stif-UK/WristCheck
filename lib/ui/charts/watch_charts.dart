import 'package:flutter/material.dart';
import 'package:wristcheck/model/watches.dart';

class WatchCharts extends StatefulWidget {
  WatchCharts({
    Key? key,
    required this.currentWatch
  }) : super(key: key);

  Watches? currentWatch;

  @override
  State<WatchCharts> createState() => _WatchChartsState();
}

class _WatchChartsState extends State<WatchCharts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.currentWatch!.manufacturer} ${widget.currentWatch!.model}"),
      ),
    );
  }
}
