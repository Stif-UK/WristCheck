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
          ExpansionTile(
            title: const Text("Wear Stats default filter"),
            leading: const Icon(Icons.filter_alt_outlined),
            children: [
              const Text("Set the default filter for the Wear Stats page. \nThe graph can still be updated to show different filters as required, but will always initially load with the chosen default."),
              ListTile(
                title: const Text("Show all recorded wears"),
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
                title: const Text("Watches worn this year"),
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
                title: const Text("Watches worn this month"),
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
                title: const Text("Watches worn last month"),
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
          const Divider(height: 2,)
        ],
      ),
    );
  }
}
