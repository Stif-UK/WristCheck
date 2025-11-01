import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:wristcheck/model/measurement.dart';
import 'package:wristcheck/model/measurement_methods.dart';

import '../../boxes.dart';

class DeveloperAccuracyView extends StatefulWidget {
  const DeveloperAccuracyView({super.key});

  @override
  State<DeveloperAccuracyView> createState() => _DeveloperAccuracyViewState();
}

class _DeveloperAccuracyViewState extends State<DeveloperAccuracyView> {
  @override
  Widget build(BuildContext context) {
    var data = Boxes.getMeasurements();
    return Scaffold(
      appBar: AppBar(title: const Text("All Accuracy Stats"),),
      body: Column(
        children: [
          ListTile(title: const Text("Clear data"),
            trailing: IconButton(
              icon: const Icon(FontAwesomeIcons.trash),
              onPressed: (){
                setState(() {
                  MeasurementMethods.clearMeasurementData();
                });
              },),),
          const Divider(thickness: 2,),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                  columns:[
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Baseline')),
                    DataColumn(label: Text('Atomic Time')),
                    DataColumn(label: Text('Watch Time')),
                    DataColumn(label: Text('Accuracy'))],
                  rows: getRows(data)),
            ),
          ),
        ],
      ),
    );
  }

  List<DataRow> getRows(Box<Measurement> data) {
    List<DataRow> rows = [];
    List<Measurement> dataList = data.values.toList();
    for(Measurement m in dataList){
      rows.add(DataRow(
          cells:[
            DataCell(Text(m.watchKey.toString())),
            DataCell(Text(m.baseLine.toString())),
            DataCell(Text(m.atomicTime.toString())),
            DataCell(Text(m.watchTime.toString())),
            DataCell(Text('')),//final column currently blank
          ]));

    }
    return rows;
  }
}
