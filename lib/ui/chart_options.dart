import 'package:flutter/material.dart';
import 'package:wristcheck/model/enums/wear_chart_options.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';

class ChartOptions extends StatefulWidget {
  const ChartOptions({Key? key}) : super(key: key);

  @override
  State<ChartOptions> createState() => _ChartOptionsState();
}

class _ChartOptionsState extends State<ChartOptions> {
  WearChartOptions _chartOption = WristCheckPreferences.getWearChartOptions() ?? WearChartOptions.all;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chart Options"),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text("Show all"),
            leading: Radio<WearChartOptions>(
              value: WearChartOptions.all,
              groupValue: _chartOption ,
              onChanged: (WearChartOptions? value) async {
                await WristCheckPreferences.setWearChartOptions(value!);
                setState(() {
                  _chartOption = value;
                });

              },
            ),
          ),
          ListTile(
            title: const Text("This Year"),
            leading: Radio<WearChartOptions>(
              value: WearChartOptions.thisYear,
              groupValue: _chartOption ,
              onChanged: (WearChartOptions? value) async {
                await WristCheckPreferences.setWearChartOptions(value!);
                setState(() {
                  _chartOption = value;
                });

              },
            ),
          ),
          ListTile(
            title: const Text("This Month"),
            leading: Radio<WearChartOptions>(
              value: WearChartOptions.thisMonth,
              groupValue: _chartOption ,
              onChanged: (WearChartOptions? value) async {
                await WristCheckPreferences.setWearChartOptions(value!);
                setState(() {
                  _chartOption = value;
                });

              },
            ),
          ),
          ListTile(
            title: const Text("Last Month"),
            leading: Radio<WearChartOptions>(
              value: WearChartOptions.lastMonth,
              groupValue: _chartOption ,
              onChanged: (WearChartOptions? value) async {
                await WristCheckPreferences.setWearChartOptions(value!);
                setState(() {
                  _chartOption = value;
                });

              },
            ),
          ),
        ],
      ),
    );
  }
}
