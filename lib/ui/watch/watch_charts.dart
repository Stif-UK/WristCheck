import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/ui/charts/watch_days.dart';
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

            ListTile(
              title: Text("Wears by month",
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.start,),
              leading: Icon(FontAwesomeIcons.calendarDays),
            ),
            WatchMonthChart(currentWatch: widget.currentWatch),
            const Divider(thickness: 2,),
            ListTile(
              title: Text("Wears by day",
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.start,),
              leading: Icon(FontAwesomeIcons.calendarDay),
              trailing: Icon(Icons.bar_chart),
            ),
            WatchDayChart(currentWatch: widget.currentWatch),
          ],
        ),
      ),
    );
  }
}
