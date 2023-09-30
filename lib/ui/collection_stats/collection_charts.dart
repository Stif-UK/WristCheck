import 'package:flutter/material.dart';
import 'package:wristcheck/ui/charts/category_chart.dart';
import 'package:wristcheck/ui/charts/movement_chart.dart';

class CollectionCharts extends StatefulWidget {
  const CollectionCharts({Key? key}) : super(key: key);

  @override
  State<CollectionCharts> createState() => _CollectionChartsState();
}

class _CollectionChartsState extends State<CollectionCharts> {
  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: getPagePadding(),
            child: Text("Movements", style: Theme.of(context).textTheme.headlineSmall,),
          ),
          Padding(
            padding: getPagePadding(),
            child: const MovementChart(),
          ),
          const Divider(thickness: 2,),
          Padding(
            padding: getPagePadding(),
            child: Text("Categories", style: Theme.of(context).textTheme.headlineSmall,),
          ),
          Padding(
            padding: getPagePadding(),
            child: const CategoryChart(),
          ),
        ],
      ),
    );
  }

  EdgeInsets getPagePadding(){
    return const EdgeInsets.all(8.0);
  }
}
