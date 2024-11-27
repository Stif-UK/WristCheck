import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:wristcheck/config.dart';
import 'package:wristcheck/controllers/time_controller.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/model/adunits.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/provider/adstate.dart';
import 'package:wristcheck/ui/time/moon_phase.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';
import 'package:flutter_kronos/flutter_kronos.dart';
import 'package:firebase_analytics/firebase_analytics.dart';


class TimeSetting extends StatefulWidget {
  final timeController = Get.put(TimeController());
  final wristCheckController = Get.put(WristCheckController());

  @override
  State<TimeSetting> createState() => _TimeSettingState();
}


class _TimeSettingState extends State<TimeSetting> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  DateTime? _currentNTPDateTime;
  BannerAd? banner;
  bool purchaseStatus = WristCheckPreferences.getAppPurchasedStatus() ?? false;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(!purchaseStatus)
    {
      final adState = Provider.of<AdState>(context);
      adState.initialization.then((status) {
        setState(() {
          banner = BannerAd(
            //Check config to confirm if this is a prod or test app build
              adUnitId: WristCheckConfig.prodBuild == false? adState.getTestAds : AdUnits.timeSettingAdUnitID,
              //If the device screen is large enough display a larger ad on this screen
              size: MediaQuery.of(context).size.height > 500.0
                  ? AdSize.mediumRectangle
                  : AdSize.largeBanner,
              request: const AdRequest(),
              listener: adState.adListener)
            ..load();
        });
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(screenName: "timesetting");

    updateTime();
    return PopScope(
      onPopInvoked: (bool didPop) => widget.timeController.updateIsTimerActive(!didPop),
      child: Obx(() => Column(
          children: [
            Expanded(
              flex: 4,
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
                        // IconButton(
                        //     icon: Icon(FontAwesomeIcons.arrowRotateRight,
                        //       color: Theme.of(context).textTheme.bodySmall?.color,
                        //       size: Theme.of(context).textTheme.bodySmall?.fontSize,),
                        //     onPressed: () {}
                        // )
                      ],
                    ),
                  ),
                  //TODO: Implement text if time sync fails
                  Obx(()=> Center(child: widget.timeController.timeSynced.value?
                      Text("System time deviation: ${widget.timeController.deviation.value}", style: Theme.of(context).textTheme.bodySmall,) :
                      Text("Sync in progress - displaying system time...", style: Theme.of(context).textTheme.bodySmall))),
                  const Divider(thickness: 2,),
                  Obx(() => SwitchListTile(
                    title: Text("Beep Countdown"),
                      value: widget.timeController.enableBeep.value,
                      onChanged: (beep) {
                        analytics.logEvent(name: "enablebeep",
                            parameters: {
                              "beep" : beep
                            });
                        widget.timeController.updateBeepSetting(beep);
                      })),
                  const Divider(thickness: 2,),
                  Obx(() => SwitchListTile(
                    title: Text("24 hour time"),
                      value: widget.timeController.militaryTime.value,
                      onChanged: (mt) {
                        analytics.logEvent(name: "enable24hrtime",
                            parameters: {
                              "24hr" : mt
                            });
                        widget.timeController.updateMilitaryTime(mt);
                      })),
                  const Divider(thickness: 2,),
                ],
              ),
            ),
            widget.wristCheckController.isAppPro.value || widget.wristCheckController.isDrawerOpen.value? Expanded(flex: 5, child: MoonPhaseWidget()) : _buildAdSpace(banner, context),
            const SizedBox(height: 20,)

          ],
        ),
      ),
    );


  }



  updateTime() {
    Future.delayed(Duration(seconds: 2), () async {
      //small delay, then check if time is synced - if it is, set the value of synced in the controller
      var synced = await FlutterKronos.getNtpDateTime;
      if(synced != null) {
        widget.timeController.updateTimeSynced(true);
        widget.timeController.updateLastSyncTime(_currentNTPDateTime ?? synced);
        widget.timeController.updateDeviation(DateTime.now().difference(synced));
      }
      if(synced == null){
        widget.timeController.updateSyncFailed(true);
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
    analytics.setAnalyticsCollectionEnabled(true);
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

Widget _buildAdSpace(BannerAd? banner, BuildContext context){
  return banner == null
      ? SizedBox(height: MediaQuery.of(context).size.height > 500.0? 250: 100,)
      : Container(
    height: MediaQuery.of(context).size.height > 500.0? 250: 100,
    child: AdWidget(ad: banner!),
  );
}
