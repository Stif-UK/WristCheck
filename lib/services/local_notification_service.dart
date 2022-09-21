import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class WristCheckLocalNotificationService{
  WristCheckLocalNotificationService();

  final _localNotificationService = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('@drawable/ic_stat_watch');

    DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings(
          requestSoundPermission: false,
          requestBadgePermission: false,
          requestAlertPermission: false,
          onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
        );

    final InitializationSettings settings = InitializationSettings(
        android: androidInitializationSettings,
        iOS: iosInitializationSettings);

    await _localNotificationService.initialize(settings, onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        'channel_id',
        'channel_name',
      channelDescription: 'description',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true
    );

    const DarwinNotificationDetails iosNotificationDetails = DarwinNotificationDetails();

    return const NotificationDetails(
        android: androidNotificationDetails,
        iOS: iosNotificationDetails);
  }

  //Show an instant notification
  Future<void> showNotification(
  {required int id,
  required String title,
  required String body} 
      ) async {
    if(Platform.isIOS){
      await _getIOSNotificationPermissions();
    }

    final details = await _notificationDetails();
    await _localNotificationService.show(id, title, body, details);
}

//TODO: Modify this example method to set up recurring daily notification
  //Show a scheduled notification
  Future<void> showScheduledNotification({
    required int id,
    required String title,
    required String body,
    required int seconds,
}) async {
    if(Platform.isIOS){
      await _getIOSNotificationPermissions();
    }
    final details = await _notificationDetails();
    await _localNotificationService.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(DateTime.now().add(Duration(seconds: 3)), tz.local),
        details,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        //matchDateTimeComponents: DateTimeComponents.time // use this to set as daily
    );
  }

  void _onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) {
    print("id: $id");
  }

  void onDidReceiveNotificationResponse(NotificationResponse details) {
    print("Payload: ${details.payload}");
  }

  Future<void> _getIOSNotificationPermissions() async {
    final bool? result = await _localNotificationService.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,);
  }

  Future<void> cancelNotification(int id) async {
    _localNotificationService.cancel(id);
    print("Notifications cancelled for id: $id");
  }
}