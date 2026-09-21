import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_kronos/flutter_kronos.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:wristcheck/config.dart';
import 'package:wristcheck/controllers/time_controller.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/adunits.dart';
import 'package:wristcheck/model/enums/time_view_enum.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/provider/adstate.dart';
import 'package:wristcheck/ui/time/gmt.dart';
import 'package:wristcheck/ui/time/moon_phase.dart';
import 'package:wristcheck/ui/widgets/bottomsheets/time_settings_bottomsheet.dart';
import 'package:wristcheck/util/wristcheck_formatter.dart';
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

  late final AudioPlayer _audioPlayer;
  Timer? _timer;
  Duration _ntpOffset = Duration.zero;


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

    return PopScope(
      onPopInvokedWithResult: (bool didPop, dynamic result) => widget.timeController.updateIsTimerActive(!didPop),
      child: Obx(() => Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                        child: FittedBox(child: Text(AppLocalizations.of(context)!.lastSync,
                          style: Theme.of(context).textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,)),
                      ),
                      widget.timeController.timeSynced.value ?
                      Text(widget.timeController.lastSyncTime.value,
                      style: Theme.of(context).textTheme.bodySmall,) :
                      SizedBox(
                          height: 10,
                          width: 10,
                          child: CircularProgressIndicator(strokeWidth: 1.5,)
                      ),
                    ],
                  ),
                ),
                //TODO: Implement text if time sync fails
                Obx(()=> Center(child: widget.timeController.timeSynced.value?
                    Text("${AppLocalizations.of(context)!.deviation} ${widget.timeController.deviation.value}", style: Theme.of(context).textTheme.bodySmall,) :
                    Text(AppLocalizations.of(context)!.inProgress, style: Theme.of(context).textTheme.bodySmall))),
                const Divider(thickness: 2,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Obx(() => widget.wristCheckController.isAppPro.value
                          ? Wrap(
                              spacing: 8.0,
                              children: TimeViewEnum.values.map((option) {
                                return ChoiceChip(
                                  label: Text(option.toLocalizedString(context)),
                                  selected: widget.timeController.timeView.value == option,
                                  onSelected: (bool selected) {
                                    if (selected) {
                                      widget.timeController.updateTimeView(option);
                                    }
                                  },
                                );
                              }).toList(),
                            )
                          : const SizedBox.shrink()),
                    ),
                    IconButton(
                      icon: const FaIcon(FontAwesomeIcons.sliders),
                      onPressed: () {
                        Get.bottomSheet(
                          TimeSettingsBottomSheet(),
                          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20,),
            widget.wristCheckController.isAppPro.value || widget.wristCheckController.isDrawerOpen.value? const SizedBox(height: 0,) : _buildAdSpace(banner, context),
            //TODO: Finish moonphase implementation
            widget.wristCheckController.isAppPro.value 
                ? Obx(() => widget.timeController.timeView.value == TimeViewEnum.moonphase 
                    ? MoonPhaseWidget() 
                    : GMT(),
              )
                : const SizedBox(height: 0,),
            const SizedBox(height: 20,)

          ],
        ),
      ),
    );


  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (Timer t) {
      if (!widget.timeController.isTimerActive.value) {
        t.cancel();
        return;
      }
      var date = widget.timeController.timeSynced.value
          ? DateTime.now().add(_ntpOffset)
          : DateTime.now();

      var gmt = date.add(Duration(hours: widget.timeController.timeOffset.value));
      triggerBeep(date.second);
      widget.timeController.currentDateTime(date);
      widget.timeController.currentTime(WristCheckFormatter.getTime(date, widget.timeController.militaryTime.value));
      widget.timeController.currentDate(WristCheckFormatter.getFormattedDateWithDay(date));
      widget.timeController.currentGMTtime(WristCheckFormatter.getTime(gmt, widget.timeController.militaryTime.value));
    });
  }

  triggerBeep(int current) {
    var triggerList = [57, 58, 59, 0];
    if (triggerList.contains(current)) {
      if (widget.timeController.enableBeep.value) {
        if (current != widget.timeController.lastBeep.value) {
          if (current == 0) {
            _audioPlayer.play(AssetSource('audio/main_chime1.mp3'));
          } else {
            _audioPlayer.play(AssetSource('audio/chime1.mp3'));
          }
        }
      }
      widget.timeController.updateLastBeep(current);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    widget.timeController.isTimerActive(false);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    analytics.setAnalyticsCollectionEnabled(true);
    widget.timeController.isTimerActive(true);
    initPlatformState();
    startTimer();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    FlutterKronos.sync();
    await Future.delayed(const Duration(seconds: 2));
    try {
      _currentNTPDateTime = await FlutterKronos.getNtpDateTime;
      if (_currentNTPDateTime != null && mounted) {
        _ntpOffset = _currentNTPDateTime!.difference(DateTime.now());
        widget.timeController.updateTimeSynced(true);
        widget.timeController.updateLastSyncTime(_currentNTPDateTime!);
        widget.timeController.updateDeviation(_ntpOffset);
      } else if (mounted) {
        widget.timeController.updateSyncFailed(true);
      }
    } on PlatformException {
      if (mounted) {
        widget.timeController.updateSyncFailed(true);
      }
    }
  }
}

Widget _buildAdSpace(BannerAd? banner, BuildContext context){
  return banner == null
      ? SizedBox(height: MediaQuery.of(context).size.height > 500.0? 250: 100,)
      : Container(
    height: MediaQuery.of(context).size.height > 500.0? 250: 100,
    child: AdWidget(ad: banner),
  );
}
