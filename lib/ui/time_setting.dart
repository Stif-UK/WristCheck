import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/time_controller.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';
import 'package:flutter_kronos/flutter_kronos.dart';

class TimeSetting extends StatefulWidget {
  final timeController = Get.put(TimeController());

  @override
  State<TimeSetting> createState() => _TimeSettingState();
}


class _TimeSettingState extends State<TimeSetting> {
  DateTime? _currentNTPDateTime;




  @override
  Widget build(BuildContext context) {
    updateTime();
    return PopScope(
      onPopInvoked: (bool didPop) => widget.timeController.updateIsTimerActive(!didPop),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() => Text(widget.timeController.currentDate.value, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall,)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() => Text(widget.timeController.currentTime.value, textAlign: TextAlign.center, style: Theme.of(context).textTheme.displayMedium,)),
                  ],
                ),
                Obx(()=> Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text("Last Synced:", style: Theme.of(context).textTheme.bodySmall,),
                      ),
                      widget.timeController.timeSynced.value ?
                      Text(widget.timeController.lastSyncTime.value,
                      style: Theme.of(context).textTheme.bodySmall,) :
                      SizedBox(
                          height: 10,
                          width: 10,
                          child: CircularProgressIndicator(strokeWidth: 1.5,)
                      ),
                      IconButton(
                          icon: Icon(FontAwesomeIcons.arrowRotateRight,
                            color: Theme.of(context).textTheme.bodySmall?.color,
                            size: Theme.of(context).textTheme.bodySmall?.fontSize,),
                          onPressed: () => widget.timeController.updateTimeSynced(!widget.timeController.timeSynced.value)
                      )
                    ],
                  ),
                ),
                Obx(()=> Center(child: widget.timeController.timeSynced.value?
                    Text("System time deviation: ${widget.timeController.deviation.value}", style: Theme.of(context).textTheme.bodySmall,) :
                    Text("Sync in progress - displaying system time...", style: Theme.of(context).textTheme.bodySmall))),
                const Divider(thickness: 2,),
                Obx(() => SwitchListTile(
                  title: Text("Beep Countdown"),
                    value: widget.timeController.enableBeep.value,
                    onChanged: (beep) => widget.timeController.updateBeepSetting(beep))),
                const Divider(thickness: 2,),
                Obx(() => SwitchListTile(
                  title: Text("24 hour time"),
                    value: widget.timeController.militaryTime.value,
                    onChanged: (mt) => widget.timeController.updateMilitaryTime(mt))),
                const Divider(thickness: 2,),
              ],
            ),
          ),
        ],
      ),
    );


  }



  updateTime() {
    Future.delayed(Duration(seconds: 2), () async {
      //small delay, then check if time is synced - if it is, set the value of synced in the controller
      var synced = await FlutterKronos.getNtpDateTime;
      if(synced != null) {
        widget.timeController.updateTimeSynced(true);
        widget.timeController.updateLastSyncTime(synced);
        widget.timeController.updateDeviation(DateTime.now().difference(synced));
      }
    });

    Timer.periodic(Duration(milliseconds: 50), (Timer t) async {
      if(!widget.timeController.isTimerActive.value){
        t.cancel();
      }
      var date = widget.timeController.timeSynced.value? await FlutterKronos.getNtpDateTime : DateTime.now();
      if(date == null) {
        widget.timeController.updateTimeSynced(false);
        date = DateTime.now();
      }
      triggerBeep(date.second);
      widget.timeController.currentDateTime(date);
      widget.timeController.currentTime(WristCheckFormatter.getTime(date, widget.timeController.militaryTime.value));
      widget.timeController.currentDate(WristCheckFormatter.getFormattedDateWithDay(date));

    });

  }

  triggerBeep(int current){
    final player = AudioPlayer();
    var triggerList = [57, 58, 59, 00];
    if(triggerList.contains(current)) {
      if(widget.timeController.enableBeep.value) {
        if (current != widget.timeController.lastBeep.value) {
          current == 00
              ? player.play(AssetSource('audio/main_chime1.mp3'))
              : player.play(AssetSource('audio/chime1.mp3'));
        }
        ;
      }
      widget.timeController.updateLastBeep(current);
    }
  }

  @override
  void dispose() {
    widget.timeController.isTimerActive(false);
    Get.delete<TimeController>();
    super.dispose();
  }

  @override
  void initState() {
    widget.timeController.isTimerActive(true);
    initPlatformState();
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    FlutterKronos.sync();
    try {
      _currentNTPDateTime = await FlutterKronos.getNtpDateTime;
    } on PlatformException {}

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

  }
}
