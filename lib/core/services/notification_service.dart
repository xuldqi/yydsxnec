import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

const sleepAidToggleAction = 'sleep_aid_toggle';
const sleepAidStopAction = 'sleep_aid_stop';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static const int sleepAidNotificationId = 2001;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final StreamController<String> _actionController =
      StreamController<String>.broadcast();

  Stream<String> get actionStream => _actionController.stream;

  Future<void> init() async {
    // Initialize Timezone
    tz.initializeTimeZones();
    final timezoneInfo = await FlutterTimezone.getLocalTimezone();
    final String timeZoneName = timezoneInfo.identifier;
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    // Initialize Settings for Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Initialize Settings for macOS
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    // Combine settings
    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          macOS: initializationSettingsDarwin,
          iOS: initializationSettingsDarwin, // Just in case
        );

    await _flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: _handleNotificationResponse,
    );

    // Request permissions for Android 13+
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  void _handleNotificationResponse(NotificationResponse response) {
    final actionId = response.actionId;
    if (actionId == null || actionId.isEmpty) return;
    _actionController.add(actionId);
  }

  Future<void> scheduleAlarm(
    DateTime scheduledTime,
    int id,
    String title,
    String body,
  ) async {
    // Make sure we cancel any existing alarm with the same ID
    await cancelAlarm(id);

    // Ignore times in the past
    if (scheduledTime.isBefore(DateTime.now())) {
      return;
    }

    final tz.TZDateTime scheduledTZDate = tz.TZDateTime.from(
      scheduledTime,
      tz.local,
    );

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'alarm_channel',
          '闹钟提醒',
          channelDescription: '用于播放起床闹钟提醒',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          category: AndroidNotificationCategory.alarm,
          fullScreenIntent: true,
        );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
          presentSound: true,
          presentAlert: true,
          presentBadge: true,
          sound: 'default', // Can be customized later
          interruptionLevel:
              InterruptionLevel.timeSensitive, // Ensures it wakes the user
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      macOS: darwinNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledTZDate,
      notificationDetails: notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelAlarm(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id: id);
  }

  Future<void> showSleepAidNotification({
    required String title,
    required bool isPlaying,
    int remainingTimerSeconds = 0,
  }) async {
    final timerText = remainingTimerSeconds > 0
        ? ' · 定时 ${_formatRemaining(remainingTimerSeconds)}'
        : '';
    final status = isPlaying ? '正在播放' : '已暂停';
    final toggleLabel = isPlaying ? '暂停' : '继续';

    final androidDetails = AndroidNotificationDetails(
      'sleep_aid_channel',
      '助眠播放',
      channelDescription: '显示助眠声音播放状态并提供控制按钮',
      importance: Importance.low,
      priority: Priority.low,
      ongoing: isPlaying,
      onlyAlertOnce: true,
      showWhen: false,
      category: AndroidNotificationCategory.transport,
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          sleepAidToggleAction,
          toggleLabel,
          showsUserInterface: false,
        ),
        const AndroidNotificationAction(
          sleepAidStopAction,
          '停止',
          showsUserInterface: false,
          cancelNotification: true,
        ),
      ],
    );

    await _flutterLocalNotificationsPlugin.show(
      id: sleepAidNotificationId,
      title: '小鹿睡眠 · $title',
      body: '$status$timerText',
      notificationDetails: NotificationDetails(android: androidDetails),
      payload: 'sleep_aid',
    );
  }

  Future<void> cancelSleepAidNotification() async {
    await _flutterLocalNotificationsPlugin.cancel(id: sleepAidNotificationId);
  }

  Future<void> testNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'test_channel',
          '测试通知',
          channelDescription: '用于测试通知权限是否正常',
          importance: Importance.high,
          priority: Priority.high,
        );
    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
          presentSound: true,
          presentAlert: true,
          presentBadge: true,
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      macOS: darwinNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      id: 0,
      title: '测试通知',
      body: '这是一条来自 SleepFan 的系统通知',
      notificationDetails: notificationDetails,
    );
  }

  String _formatRemaining(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
