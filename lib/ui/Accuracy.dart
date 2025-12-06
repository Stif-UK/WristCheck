import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_kronos_plus/flutter_kronos_plus.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/boxes.dart';
import 'package:wristcheck/controllers/accuracy_controller.dart';
import 'package:wristcheck/model/enums/accuracy_enums/rate_unit.dart';
import 'package:wristcheck/model/measurement.dart';
import 'package:wristcheck/model/measurement_methods.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/ui/widgets/bottomsheets/accuracy_help_bottomsheet.dart';
import 'package:wristcheck/util/accuracty_helper.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';

class Accuracy extends StatefulWidget {
  Accuracy({super.key, required this.currentWatch});

  final Watches currentWatch;
  final accuracyController = Get.put(AccuracyController());

  @override
  State<Accuracy> createState() => _AccuracyState();
}

class _AccuracyState extends State<Accuracy> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    analytics.setAnalyticsCollectionEnabled(true);
    initPlatformState();
    super.initState();
    //After the page is loaded, check and show the help overlay if first use
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showHelpOverlayOnFirstUse();
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    FlutterKronosPlus.sync();
    try {
      //Try to get the date and capture sync timestamp
      DateTime? _currentNTPDateTime = await FlutterKronosPlus.getNtpDateTime;
      widget.accuracyController.updateSyncTimestamp(_currentNTPDateTime);
    } on PlatformException {}

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

  }
  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(screenName: "accuracy");
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
    //Initiate the value of the last baseline
    widget.accuracyController.updateLastBaseline(MeasurementMethods.getLastBaseLineForWatch(widget.currentWatch));

    //Selectable values for the time offset
    final List<int> _chipValues = [00, 15, 30, 45];

    return Scaffold(
      appBar: AppBar(title: const Text("Accuracy Tracker"),
      actions: [Padding(
        padding: const EdgeInsets.all(8.0),
        child: IconButton(icon: Icon(FontAwesomeIcons.circleQuestion),
        onPressed: ()=> showAccuracyHelpBottomSheet(),),
      )],),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.currentWatch.toString(),
                style: Theme.of(context).textTheme.headlineSmall ,
              textAlign: TextAlign.center,),
            ),
            Obx(()=> Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text("Time synced with server:\n${_getLastSyncTime()}", textAlign: TextAlign.center,)),
              ),
            )),
            const Divider(thickness: 2,),
            Text("Show results in seconds per:"),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            spacing: 8.0, // Horizontal space between chips
            runSpacing: 4.0, // Vertical space between lines
            children: RateUnit.values.map((unit) {

              return Obx(()=>ChoiceChip(
                  label: Text(unit.name, ),
                  selected: widget.accuracyController.scale.value == unit,
                  onSelected: (bool selected) => widget.accuracyController.updateScale(unit),
                  selectedColor: Colors.red,
                ),
              );
            }).toList(), // Don't forget .toList()!
          ),
        ),

            Obx(() =>
                Card(
                  child: SwitchListTile(
                      title: const Text("24 Hour Display:"),
                      value: widget.accuracyController.militaryTime.value,
                      onChanged: (value) =>
                          widget.accuracyController.updateMilitaryTime(value)),
                )),
            Obx(() =>
                Card(
                  child: SwitchListTile(
                      title: const Text("Baseline measurement:"),
                      subtitle: const Text("Set a new baseline if you've just set the time of your watch"),
                      value: widget.accuracyController.baseLine.value,
                      onChanged: (value) =>
                          widget.accuracyController.updateBaseline(value)),
                )),
            Obx(()=> widget.accuracyController.lastBaseline.value == null? const SizedBox(height: 0,):
                Text("Last Baseline: ${WristCheckFormatter.getFormattedDateAndTime(widget.accuracyController.lastBaseline.value!.atomicTime)}") ),
            const Divider(thickness: 2,),
                Text("Add Checkpoint:", style: Theme.of(context).textTheme.headlineSmall,),
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
            const Divider(thickness: 2,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Text("Seconds:"),
            ),
            //Select the time offset
            Wrap(
              spacing: 15.0,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: _chipValues.map((value) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Obx(()=> ChoiceChip(
                      label: Container(
                          width: 45,
                          child: Text(value.toString(), textAlign: TextAlign.center,)),
                      selected: widget.accuracyController.selectedOffset == value,
                      selectedColor: Colors.red,
                      onSelected: (bool selected) =>
                        widget.accuracyController.updateSelectedOffset(
                            value)
                    ),
                  ),
                );
              }).toList(),
            ),

            const Divider(thickness: 2,),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                      child: const SizedBox(width: 20,)),
                  Obx(()=> ElevatedButton(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.accuracyController.valueRecorded.value? "Saved!" : "Record", style: TextStyle(
                          fontSize: Theme.of(context).textTheme.headlineSmall?.fontSize,
                        ),),
                      ),
                      onPressed: () {
                        if(!widget.accuracyController.valueRecorded.value) {
                            _addMeasurement(
                                widget.accuracyController.selectedOffset.value);
                            widget.accuracyController.updateValueRecorded(true);
                          }
                        null;
                        }
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        icon: Icon(FontAwesomeIcons.arrowsRotate,
                        ), onPressed: () {
                          widget.accuracyController.updateValueRecorded(false);
                      },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(thickness: 2,),
            Text("Records", style: Theme
                    .of(context)
                    .textTheme
                    .headlineSmall, textAlign: TextAlign.center,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: Text("Baseline", textAlign: TextAlign.start,)),
                  Expanded(child: Text("Time", textAlign: TextAlign.center,)),
                  Expanded(child: Text("Result", textAlign: TextAlign.end,)),
                ],
              ),
            ),
            Obx(() =>
                ListView.builder(
                    physics: BouncingScrollPhysics(),
                    //reverse: true,//widget.accuracyController.dataLastFirst.value,
                    shrinkWrap: true,
                    itemCount: widget.accuracyController.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Dismissible(
                        
                        key: Key(widget.accuracyController.data[index].key.toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Icon(FontAwesomeIcons.trash, color: Colors.white),
                        ),
                        onDismissed: (direction) async {
                          var result = await MeasurementMethods.deleteRecord(widget.accuracyController.data[index].key);
                          if(result) _refreshData();
                        },
                        child: Card(
                          child: ListTile(
                            leading: widget.accuracyController.data[index].baseLine ? Icon(FontAwesomeIcons.thumbtack) : Icon(FontAwesomeIcons.thumbtackSlash) ,
                            title: Text(
                                "${WristCheckFormatter.getFormattedDateAndTime(widget.accuracyController.data[index]
                                    .watchTime)}"),
                            trailing: Obx(()=> Text(_getDisplayRate(index))),
                          
                          ),
                        ),
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
    //Refresh data list
    widget.accuracyController.updateData(
        Boxes.getMeasurementsForWatch(widget.currentWatch).toList());
    //Refresh last baseline value
    widget.accuracyController.updateLastBaseline(
        MeasurementMethods.getLastBaseLineForWatch(widget.currentWatch));
    //Add latest measurement record to controller
    widget.accuracyController.updateLastMeasurement(
      MeasurementMethods.getLatestMeasurementForWatch(widget.currentWatch)
    );
  }

  Future<void> _addMeasurement(int offset) async {
    await analytics.logEvent(name: "accuracy_tracked");
    double? rate;
    bool calculateRate = true;
    int index;

    //Add the seconds offset
    DateTime record = widget.accuracyController.watchDateTime.value.add(Duration(seconds: offset));

    //1. Get the last baseline value - if no baseline, this MUST be treated as a baseline and no calculation
    //should be completed.
    Measurement? baseline = MeasurementMethods.getLastBaseLineForWatch(widget.currentWatch);
    if(baseline == null) {
      widget.accuracyController.updateBaseline(true);
      calculateRate = false;
    }

    //2. Get the atomic time from the server, or default to system time if not synced
    DateTime timestamp = await FlutterKronosPlus.getNtpDateTime ?? DateTime.now();

    //3. Save the record (at this point rate is zero)
    index = await MeasurementMethods.addMeasurement(widget.currentWatch.key,
        widget.accuracyController.baseLine.value,
        timestamp,
        record,
        rate);

    //4. If this is not a baseline calculate the rate
    if(calculateRate) {
      rate = AccuracyHelper.calculateRate(baseline!, MeasurementMethods.getMeasurementByIndex(index)!);
      MeasurementMethods.addRateToRecord(index, rate);
    }
    _refreshData();
    //Once a measurement is made, set baseline to false ready for the next measurement
    widget.accuracyController.updateBaseline(false);
  }

  String _getDisplayRate(int index) {
    String returnText = " - ";
    //Wrap in if - if the record is a baseline, don't show a value
    if (!widget.accuracyController.data[index].baseLine) {
      double? rate;
      String unit = widget.accuracyController.scale.value.name;
      // /unit = unit.substring(0,1).toUpperCase();

      rate = widget.accuracyController.data[index].rawAccuracy == null? null :
      AccuracyHelper.getScaledRate(widget.accuracyController.data[index].rawAccuracy!,widget.accuracyController.scale.value);

      if(rate != null) returnText = rate.toStringAsFixed(1);
      returnText = "$returnText\ns/$unit";
    }
    return returnText;

  }

  _getLastSyncTime() {
    return widget.accuracyController.syncTimestamp.value != null?
    WristCheckFormatter.getFormattedDateAndTime(widget.accuracyController.syncTimestamp.value!)
        : "... system time in use";
  }

  Future showAccuracyHelpBottomSheet() {
    return showModalBottomSheet(
      isScrollControlled: true,
        context: context,
        builder: (context){
          return Container(
            height: MediaQuery.of(context).size.height*0.8,
          child: AccuracyHelpBottomsheet());
        });
  }

  void _showHelpOverlayOnFirstUse() {
    //Check if this is the first time the user has used the accuracy check - if so, open the help dialog
    if(WristCheckPreferences.getShowAccuracyHelp()){
      //show help overlay on first use
      showAccuracyHelpBottomSheet();
      //Hide on future openings
      WristCheckPreferences.setShowAccuracyHelp(false);
    }
  }
}
