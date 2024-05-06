import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:wristcheck/config.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/copy/dialogs.dart';
import 'package:wristcheck/model/adunits.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/provider/adstate.dart';
import 'package:wristcheck/services/local_notification_service.dart';
import 'package:wristcheck/model/enums/notification_time_options.dart';
import 'package:wristcheck/copy/snackbars.dart';
import 'package:wristcheck/util/ad_widget_helper.dart';

// enum NotificationTimeOptions {morning, afternoon, evening, custom}

class Notifications extends StatefulWidget {
  Notifications({Key? key}) : super(key: key);
  final wristCheckController = Get.put(WristCheckController());


  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  late final WristCheckLocalNotificationService notificationService;
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
              adUnitId: WristCheckConfig.prodBuild == false? adState.getTestAds : AdUnits.notificationsPageBannerAdUnitId,
              //If the device screen is large enough display a larger ad on this screen
              size: AdSize.banner,
              request: const AdRequest(),
              listener: adState.adListener)
            ..load();
        });
      });
    }
  }


  @override
  void initState() {
    notificationService = WristCheckLocalNotificationService();
    notificationService.initialize();
    analytics.setAnalyticsCollectionEnabled(true);
    super.initState();
  }

  bool _notificationsEnabled = WristCheckPreferences.getDailyNotificationStatus() ?? false;
  NotificationTimeOptions _notificationTime = WristCheckPreferences.getNotificationTimeOption() ??NotificationTimeOptions.morning;
  //String? _selectedTime = WristCheckPreferences.getDailyNotificationTime();
  String? _selectedTime;

  @override
  Widget build(BuildContext context) {

    analytics.setCurrentScreen(screenName: "notification_options");
    _selectedTime = _notificationsEnabled? WristCheckPreferences.getDailyNotificationTime() : null;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification Settings"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(closeOverlays: true),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: (){
              WristCheckDialogs.getNotificationSettingsHelpDialog();
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SwitchListTile(
                  title: const Text("Enable Daily Wear Reminder"),
                    secondary: const Icon(Icons.notifications_active),
                    value: _notificationsEnabled,
                    onChanged: (bool value) async {
                      await analytics.logEvent(
                          name: "setup_notifications",
                          parameters: {
                            "enabled" : value.toString()
                          });
                      WristCheckPreferences.setDailyNotificationStatus(value);
                    if(value == true){
                      _notificationTime = NotificationTimeOptions.morning;
                      await WristCheckPreferences.setNotificationTimeOption(_notificationTime);
                      await _setNotification(_notificationTime, const TimeOfDay(hour: 8, minute: 00));
                    } else{
                      _selectedTime = null;
                      await notificationService.cancelNotification(1);
                    }
                      setState(() {
                      _notificationsEnabled = value;
                    });

                    }
                ),
                const Divider(thickness: 2,),




                //If notifications have been enabled, show time picker
                _notificationsEnabled? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ListTile(
                      title: const Text("Morning (8am)"),
                      leading: Radio<NotificationTimeOptions>(
                        value: NotificationTimeOptions.morning,
                        groupValue: _notificationTime ,
                        onChanged: (NotificationTimeOptions? value) async {
                          await WristCheckPreferences.setNotificationTimeOption(value!);
                          await _setNotification(_notificationTime, const TimeOfDay(hour: 8, minute: 00));
                          setState(() {
                            _notificationTime = value!;
                          });

                        },
                      ),
                    ),
                    ListTile(
                      title: const Text("Afternoon (12pm)"),
                      leading: Radio<NotificationTimeOptions>(
                        value: NotificationTimeOptions.afternoon,
                        groupValue: _notificationTime ,
                        onChanged: (NotificationTimeOptions? value) async {
                          await WristCheckPreferences.setNotificationTimeOption(value!);
                          await _setNotification(_notificationTime, const TimeOfDay(hour: 12, minute: 00));
                          setState(() {
                            _notificationTime = value!;
                          });

                        },
                      ),
                    ),
                    ListTile(
                      title: const Text("Evening (6pm)"),
                      leading: Radio<NotificationTimeOptions>(
                        value: NotificationTimeOptions.evening,
                        groupValue: _notificationTime ,
                        onChanged: (NotificationTimeOptions? value) async {
                          await WristCheckPreferences.setNotificationTimeOption(value!);
                          await _setNotification(_notificationTime, const TimeOfDay(hour: 18, minute: 00));
                          setState(() {
                            _notificationTime = value!;
                          });

                        },
                      ),
                    ),
                    ListTile(
                      title: const Text("Custom Time"),
                      leading: Radio<NotificationTimeOptions>(
                        value: NotificationTimeOptions.custom,
                        groupValue: _notificationTime ,
                        onChanged: (NotificationTimeOptions? value) async {
                         // Future<TimeOfDay?> selectedTime = showTimePicker(context: context, initialTime: TimeOfDay.now());
                          TimeOfDay? selectedTime = await showTimePicker(context: context, initialTime: TimeOfDay.now()) ?? const TimeOfDay(hour: 12, minute: 00);
                          await WristCheckPreferences.setNotificationTimeOption(value!);
                          await _setNotification(_notificationTime, selectedTime);
                          setState(() {
                            _notificationTime = value!;
                          });

                        },

                      ),
                    ),
                    const Divider(thickness: 2,),
                  ],
                ):
                    //If notifications are off, just show a blank space
                    const SizedBox(height: 20,),
                _selectedTime == null? const SizedBox(height: 20,): Text("Your daily reminder is scheduled for ${_selectedTime!.substring(10,_selectedTime!.length-1)}",
                style: const TextStyle(fontSize: 16, ),),
                _selectedTime == null? const SizedBox(height: 0,): const Divider(thickness: 2,),
                //2nd Daily Reminder for Pro users
                _notificationsEnabled? _getSecondNotificationListTile(true) : SizedBox(height: 0),
                _notificationsEnabled ? const Divider(thickness: 2,) : SizedBox(height: 0,),


              ],
            ),
          ),
          purchaseStatus? const SizedBox(height: 0,) : AdWidgetHelper.buildSmallAdSpace(banner, context),
          const SizedBox(height: 50,)
        ],
      ),
    );
  }

  //_setNotification takes the enum input (plus an optional custom time) and passes this to the local notification service to set up the scheduled message
  Future<void> _setNotification(NotificationTimeOptions selectedTime, TimeOfDay? customTime) async {
    _selectedTime = customTime.toString();
    await WristCheckPreferences.setDailyNotificationTime(customTime.toString());
    notificationService.showScheduledNotification(id: 1, title: "WristCheck Reminder", body: "Don't forget to track what's on your wrist today!", time: customTime!);
    String timeString = _selectedTime!.substring(10, _selectedTime!.length-1);
    notificationService.showNotification(id: 0, title: "WristCheck Reminder", body: "Your notifications have now been scheduled for $timeString every day!");
    WristCheckSnackBars.dailyNotification(timeString);
  }

  Widget _getSecondNotificationListTile(bool isAppPro){
    Icon tileIcon = Icon(Icons.notification_add);
    Text tileTitle = Text("Enable Second Daily Reminder");
    return isAppPro? SwitchListTile(
      title: tileTitle,
      secondary: tileIcon,
      value: true ,
      onChanged: (bool value){},
    )
        :
    ListTile(
        leading: tileIcon,
        title: tileTitle,
        trailing: Icon(FontAwesomeIcons.handPointUp),
        onTap: () => WristCheckDialogs.getProUpgradeMessage()
    );
  }
}
