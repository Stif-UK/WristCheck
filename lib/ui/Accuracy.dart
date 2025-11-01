import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/controllers/accuracy_controller.dart';
import 'package:wristcheck/model/measurement.dart';
import 'package:wristcheck/model/measurement_methods.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class Accuracy extends StatefulWidget {
  Accuracy({super.key, required this.currentWatch});

  final Watches currentWatch;
  final accuracyController = Get.put(AccuracyController());

  @override
  State<Accuracy> createState() => _AccuracyState();
}

class _AccuracyState extends State<Accuracy> {
  @override
  Widget build(BuildContext context) {
    //Initialise the page
    //Set the value of watch time to 1 minute ahead (ignore seconds)
    var now = DateTime.now();
    var nowPlus = now.add(Duration(minutes: 1));
    widget.accuracyController.updateWatchDateTime(DateTime(
        nowPlus.year, nowPlus.month, nowPlus.day, nowPlus.hour,
        nowPlus.minute));
    //and initialise the record list in the controller
    widget.accuracyController.updateData(
        Boxes.getMeasurementsForWatch(widget.currentWatch).toList());
    //If there are no records for the watch, set baseline to true
    if(widget.accuracyController.data.isEmpty) widget.accuracyController.updateBaseline(true);

    return Scaffold(
      appBar: AppBar(title: const Text("Accuracy Tracker"),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() =>
                SwitchListTile(
                    title: const Text("24 Hour Display:"),
                    value: widget.accuracyController.militaryTime.value,
                    onChanged: (value) =>
                        widget.accuracyController.updateMilitaryTime(value))),
            Obx(() =>
                SwitchListTile(
                    title: const Text("Baseline measurement:"),
                    value: widget.accuracyController.baseLine.value,
                    onChanged: (value) =>
                        widget.accuracyController.updateBaseline(value))),
            IconButton(
              icon: Icon(FontAwesomeIcons.caretUp),
              onPressed: () => widget.accuracyController.addAMinute(),
            ),
            Obx(() =>
                Text(WristCheckFormatter.getShortTime(
                    widget.accuracyController.watchDateTime.value,
                    widget.accuracyController.militaryTime.value),
                  style: Theme
                      .of(context)
                      .textTheme
                      .headlineLarge,)),
            IconButton(
              icon: Icon(FontAwesomeIcons.caretDown),
              onPressed: () => widget.accuracyController.subtractAMinute(),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("00 seconds", style: Theme
                      .of(context)
                      .textTheme
                      .headlineSmall,),
                ),
                onPressed: () => _addMeasurement(00),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 15.0, 25.0, 15.0),
                  child: ElevatedButton(
                    child: Text("45 seconds", style: Theme
                        .of(context)
                        .textTheme
                        .bodyLarge,),
                    onPressed: () => _addMeasurement(45),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25.0, 15.0, 8.0, 15.0),
                  child: ElevatedButton(
                    child: Text("15 seconds", style: Theme
                        .of(context)
                        .textTheme
                        .bodyLarge,),
                    onPressed: () => _addMeasurement(15),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                child: Text("30 seconds", style: Theme
                    .of(context)
                    .textTheme
                    .bodyLarge,),
                onPressed: () => _addMeasurement(30),
              ),
            ),
            const Divider(thickness: 2,),
            Text("Records", style: Theme
                .of(context)
                .textTheme
                .headlineSmall, textAlign: TextAlign.center,),
            Obx(() =>
                ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.accuracyController.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(
                            "Key: ${widget.accuracyController.data[index]
                                .key}"),
                        subtitle: Text(
                            "Timestamp: ${widget.accuracyController.data[index]
                                .watchTime}"),

                      );
                    }),
            )
          ],
        ),
      ),
    );
  }

  /*
  refreshData() calls the controller and updates the stored version of the measurement database for the watch
   */
  void _refreshData() {
    widget.accuracyController.updateData(
        Boxes.getMeasurementsForWatch(widget.currentWatch).toList());
  }

  void _addMeasurement(int offset) {
    //Add the seconds offset
    DateTime record = widget.accuracyController.watchDateTime.value.add(Duration(seconds: offset));

    MeasurementMethods.addMeasurement(widget.currentWatch.key,
        widget.accuracyController.baseLine.value,
        DateTime.now(),
        record);
    _refreshData();
    //Once a measurement is made, set baseline to false ready for the next measurement
    widget.accuracyController.updateBaseline(false);
  }
}
