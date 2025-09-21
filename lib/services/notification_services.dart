import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nourishpal/services/food_repository.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';
// import 'package:uuid/uuid.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
late final FoodRepository _repo;

  factory NotificationService() {
    
    return _instance;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Notification channel ID for Android
  static const String _channelId = 'nourish_expiry';

  // Channel name displayed in Android notification settings
  static const String _channelName ='Expiry Alerts';

  // Channel description displayed in Android notification settings
  static const String _channelDescription = 'Notifications for food expiray reminders';

  // Flutter plugin for showing local notifications
  late FlutterLocalNotificationsPlugin _localNotifications;

  // Android-specific notification details
  late AndroidNotificationDetails _androidPlatformChannelSpecifics;

  // iOS-specific notification details
  late DarwinNotificationDetails _iosPlatformChannelSpecifics;

  // UUID generator instance for creating unique identifiers for notifications
  // final Uuid _uuid = const Uuid();

  Future<void> init(FoodRepository repo) async {
    _repo=repo;
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Africa/Lagos'));

    _localNotifications = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings();

    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: androidInitializationSettings,
          iOS: iosInitializationSettings,
        );

    await _notificationsPlugin.initialize(
      initializationSettings,
      // onSelectNotification: onSelectNotification,
    );

    await _createNotificationChannels();
       await scheduleDailySummary();


  }

  Future<void> _createNotificationChannels() async {
    _androidPlatformChannelSpecifics = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      styleInformation: BigTextStyleInformation(''),
      playSound: true, // This alone plays the default system sound
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 250, 250, 250]),
    );

    _iosPlatformChannelSpecifics = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'notification.aiff',
    );
    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission(); // Android 13+
    }

    await androidPlugin?.createNotificationChannel(
      AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDescription,
        importance: Importance.max,
      ),
    );
  }

  Future<void> showNow({required String title, required String body}) async {
    await _notificationsPlugin.show(
      Random().nextInt(1 << 30),
      title,
      body,
      _notificationDetails(),
    );
  }

  Future<void> scheduleDailySummary({int hour = 9, int minute = 0}) async {
    final location = tz.getLocation('Africa/Lagos');
    final now = tz.TZDateTime.now(location);

    try {
      var scheduled = tz.TZDateTime(
        location,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      await _notificationsPlugin.zonedSchedule(
        1001,
        'Upcoming Expiries',
        _summaryText(),

        scheduled,
        _notificationDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      debugPrint('Notification scheduled successfully');
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
    }
  }

  NotificationDetails _notificationDetails() {
    final platformChannelSpecifics = NotificationDetails(
      android: _androidPlatformChannelSpecifics,
      iOS: _iosPlatformChannelSpecifics,
    );

    return platformChannelSpecifics;
    // return NotificationDetails(
    //   android: AndroidNotificationDetails(
    //     'study_reminder_channel',
    //     'Study Reminders',
    //     importance: Importance.max,
    //     priority: Priority.high,
    //     // showWhen: false,
    //   ),
    //   iOS: DarwinNotificationDetails(),
    // );
  }

  String _summaryText() {
    final count = _repo.expiringTomorrowCount();
    if (count == 0) return 'No items expiring tomorrow.';
    if (count == 1) return '1 item expiring tomorrow.';
    return '$count items expiring tomorrow.';
  }

  Future<void> rescheduleExpiryAlerts() async {
    await _notificationsPlugin.cancel(1001);
    await scheduleDailySummary();
  }
}
