import 'package:flutter/material.dart';

class ChartOptions extends StatefulWidget {
  const ChartOptions({Key? key}) : super(key: key);

  @override
  State<ChartOptions> createState() => _ChartOptionsState();
}

class _ChartOptionsState extends State<ChartOptions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chart Options")
      ),
    );
  }
}
