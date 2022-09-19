import 'package:flutter/material.dart';
import 'package:wristcheck/copy/dialogs.dart';
import 'package:wristcheck/services/local_notification_service.dart';

enum NotificationTimeOptions {morning, afternoon, evening, custom}

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
  bool _notificationsEnabled = false;
  NotificationTimeOptions _notificationTime = NotificationTimeOptions.morning;

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
              onChanged: (bool value) {
              setState((){
                //TODO: Implement notification toggle
                _notificationsEnabled = value;
              });

              }
          ),
          const Divider(thickness: 2,),

          //ToDo: Remove this once tested
          ElevatedButton(onPressed: () async {
            await notificationService.showNotification(id: 0, title: "WristCheck Reminder", body: "Don't forget to log what's on your wrist!");
          }, child: const Text("Press to see a test notification")),

          //If notifications have been enabled, show time picker
          _notificationsEnabled? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ListTile(
                title: const Text("Morning (8am)"),
                leading: Radio<NotificationTimeOptions>(
                  value: NotificationTimeOptions.morning,
                  groupValue: _notificationTime ,
                  onChanged: (NotificationTimeOptions? value){
                    setState(() {
                      _notificationTime = value!;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text("Afternoon (12pm"),
                leading: Radio<NotificationTimeOptions>(
                  value: NotificationTimeOptions.afternoon,
                  groupValue: _notificationTime ,
                  onChanged: (NotificationTimeOptions? value){
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
                  onChanged: (NotificationTimeOptions? value){
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
                  onChanged: (NotificationTimeOptions? value){
                    Future<TimeOfDay?> selectedTime = showTimePicker(context: context, initialTime: TimeOfDay.now());

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

        ],
      ),
    );
  }
}
