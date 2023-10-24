import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class WristCheckLocalNotificationService{
  WristCheckLocalNotificationService();

  final _localNotificationService = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

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

  //Show a scheduled notification
  Future<void> showScheduledNotification({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
}) async {
    if(Platform.isIOS){
      await _getIOSNotificationPermissions();
    }
    if(Platform.isAndroid){
      await _getAndroidNotificationPermissions();
    }
    //Create Datetime
    DateTime now = DateTime.now();
    DateTime tomorrow = now.add(const Duration(days: 1));
    DateTime notificationTime = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, time.hour, time.minute);


    final details = await _notificationDetails();
    await _localNotificationService.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(notificationTime, tz.local),
        details,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.wallClockTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time
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

  Future<void> _getAndroidNotificationPermissions() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()!.requestNotificationsPermission();
  }

  Future<void> cancelNotification(int id) async {
    _localNotificationService.cancel(id);
  }
}