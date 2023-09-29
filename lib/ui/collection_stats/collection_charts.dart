import 'package:flutter/material.dart';
import 'package:wristcheck/ui/charts/movement_chart.dart';

class CollectionCharts extends StatefulWidget {
  const CollectionCharts({Key? key}) : super(key: key);

  @override
  State<CollectionCharts> createState() => _CollectionChartsState();
}

class _CollectionChartsState extends State<CollectionCharts> {
  @override
  Widget build(BuildContext context) {
    return MovementChart();
  }
}
