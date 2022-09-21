import 'package:flutter/material.dart';
import 'package:wristcheck/copy/dialogs.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/services/local_notification_service.dart';
import 'package:wristcheck/model/enums/notification_time_options.dart';

// enum NotificationTimeOptions {morning, afternoon, evening, custom}

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  late final WristCheckLocalNotificationService notificationService;


  @override
  void initState() {
    notificationService = WristCheckLocalNotificationService();
    notificationService.initialize();
    super.initState();
  }

  //TODO: Implement shared pref
  bool _notificationsEnabled = WristCheckPreferences.getDailyNotificationStatus() ?? false;
  NotificationTimeOptions _notificationTime = WristCheckPreferences.getNotificationTime() ??NotificationTimeOptions.morning;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification Settings"),
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SwitchListTile(
            title: const Text("Enable Daily Wear Reminder"),
              secondary: const Icon(Icons.notification_add_outlined),
              value: _notificationsEnabled,
              onChanged: (bool value) async {
                WristCheckPreferences.setDailyNotificationStatus(value);
              if(value == true){
                _notificationTime = NotificationTimeOptions.morning;
                await WristCheckPreferences.setNotificationTime(_notificationTime);
                await _setNotification(_notificationTime, const TimeOfDay(hour: 8, minute: 00));
              } else{
                await notificationService.cancelNotification(1);
              }
                //value == true? await _setNotification(_notificationTime, null) : await notificationService.cancelNotification(1);
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
                    setState(() {
                      _notificationTime = value!;
                    });
                    await WristCheckPreferences.setNotificationTime(value!);
                    await _setNotification(_notificationTime, const TimeOfDay(hour: 8, minute: 00));
                  },
                ),
              ),
              ListTile(
                title: const Text("Afternoon (12pm"),
                leading: Radio<NotificationTimeOptions>(
                  value: NotificationTimeOptions.afternoon,
                  groupValue: _notificationTime ,
                  onChanged: (NotificationTimeOptions? value) async {
                    setState(() {
                      _notificationTime = value!;
                    });
                    await WristCheckPreferences.setNotificationTime(value!);
                    await _setNotification(_notificationTime, const TimeOfDay(hour: 12, minute: 00));
                  },
                ),
              ),
              ListTile(
                title: const Text("Evening (6pm)"),
                leading: Radio<NotificationTimeOptions>(
                  value: NotificationTimeOptions.evening,
                  groupValue: _notificationTime ,
                  onChanged: (NotificationTimeOptions? value) async {
                    setState(() {
                      _notificationTime = value!;
                    });
                    await WristCheckPreferences.setNotificationTime(value!);
                    await _setNotification(_notificationTime, const TimeOfDay(hour: 18, minute: 00));
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

                    setState(() {
                      _notificationTime = value!;
                    });
                    await WristCheckPreferences.setNotificationTime(value!);
                    await _setNotification(_notificationTime, selectedTime);
                  },

                ),
              ),
              const Divider(thickness: 2,),
            ],
          ):
              //If notifications are off, just show a blank space
              const SizedBox(height: 20,),
          ElevatedButton(onPressed: () async {
            await notificationService.showNotification(id: 0, title: "WristCheck Reminder", body: "Don't forget to log what's on your wrist!");
          }, child: const Text("Press to see a test notification")),

        ],
      ),
    );
  }

  //_setNotification takes the enum input (plus an optional custom time) and passes this to the local notification service to set up the scheduled message
  Future<void> _setNotification(NotificationTimeOptions selectedTime, TimeOfDay? customTime) async {
    // customTime ?? const TimeOfDay(hour: 12, minute: 00);
    notificationService.showScheduledNotification(id: 1, title: "WristCheck Reminder", body: "$selectedTime + ${customTime.toString()}", time: customTime!);
  }
}
