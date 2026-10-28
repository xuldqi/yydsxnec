import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../core/constants/app_constants.dart';

/// 通知服务
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  /// 初始化通知服务
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      // 初始化时区
      tz.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('Asia/Shanghai'));

      // Android 初始化设置
      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );

      // iOS / macOS 初始化设置
      const darwinSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: darwinSettings,
        macOS: darwinSettings,
      );

      final bool? initialized = await _notifications.initialize(settings: initSettings, onDidReceiveNotificationResponse: _onNotificationTapped);

      if (initialized == true) {
        // Android 需要单独请求权限
        await _requestAndroidPermissions();
        _isInitialized = true;
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// 请求 Android 权限
  Future<void> _requestAndroidPermissions() async {
    final androidImplementation = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
      await androidImplementation.requestExactAlarmsPermission();
    }
  }

  /// 通知点击回调
  void _onNotificationTapped(NotificationResponse response) {
    // 处理通知点击事件
  }

  /// 显示即时通知
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    const androidDetails = AndroidNotificationDetails(
      AppConstants.fastingStartChannelId,
      '断食提醒',
      channelDescription: '断食相关的通知提醒',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = const NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: darwinDetails,
    );

    await _notifications.show(id: id, title: title, body: body, notificationDetails: details, payload: payload);
  }

  /// 安排定时通知
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
    String? channelId,
    String? channelName,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    final scheduledTime = _nextFutureTime(scheduledDate);
    if (scheduledTime == null) {
      return;
    }

    final androidDetails = AndroidNotificationDetails(
      channelId ?? AppConstants.fastingStartChannelId,
      channelName ?? '断食提醒',
      channelDescription: '定时通知提醒',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: darwinDetails,
    );

    await _notifications.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(scheduledTime, tz.local),
      notificationDetails: details,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  /// 取消通知
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id: id);
  }

  /// 取消所有通知
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  /// 获取待处理的通知
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  // ========== 具体的通知方法 ==========

  /// 断食开始提醒
  Future<void> notifyFastingStart({required DateTime startTime}) async {
    await showNotification(
      id: 1001,
      title: '断食已开始',
      body: '您的轻断食计划已经开始，加油！',
      payload: 'fasting_start',
    );
  }

  /// 断食结束提醒
  Future<void> notifyFastingEnd({required DateTime endTime}) async {
    await scheduleNotification(
      id: 1002,
      title: '断食即将结束',
      body: '您的断食计划即将结束，可以开始进食了！',
      scheduledDate: endTime.subtract(const Duration(minutes: 5)),
      channelId: AppConstants.fastingEndChannelId,
      channelName: '断食结束',
    );
  }

  /// 进食窗口开始提醒
  Future<void> notifyEatingWindowStart({
    required DateTime windowStartTime,
  }) async {
    await scheduleNotification(
      id: 1003,
      title: '进食窗口已开启',
      body: '您现在可以开始进食了，记得均衡营养！',
      scheduledDate: windowStartTime,
      channelId: AppConstants.fastingEndChannelId,
      channelName: '进食窗口',
    );
  }

  /// 饮水提醒
  Future<void> scheduleWaterReminder({required List<TimeOfDay> times}) async {
    final now = DateTime.now();

    int baseId = 2001;
    for (final time in times) {
      var scheduledTime = DateTime(
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );

      if (scheduledTime.isBefore(now)) {
        scheduledTime = scheduledTime.add(const Duration(days: 1));
      }

      await scheduleNotification(
        id: baseId + time.hour,
        title: '记得喝水',
        body: '该喝水了！保持充足的水分对身体很重要。',
        scheduledDate: scheduledTime,
        channelId: AppConstants.waterReminderChannelId,
        channelName: '饮水提醒',
        payload: 'water_reminder',
      );
    }
  }

  /// 取消饮水提醒
  Future<void> cancelWaterReminders() async {
    // 取消所有饮水相关的通知（ID范围：2001-2010）
    for (int i = 2001; i <= 2010; i++) {
      await cancelNotification(i);
    }
  }

  /// 体重记录提醒
  Future<void> scheduleWeightReminder({required TimeOfDay time}) async {
    final now = DateTime.now();
    var scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    await scheduleNotification(
      id: 3001,
      title: '记录体重',
      body: '别忘了记录今天的体重哦！',
      scheduledDate: scheduledTime,
      channelId: AppConstants.waterReminderChannelId, // 复用
      channelName: '体重提醒',
      payload: 'weight_reminder',
    );
  }

  /// 取消体重提醒
  Future<void> cancelWeightReminder() async {
    await cancelNotification(3001);
  }

  /// 清除所有断食相关通知
  Future<void> clearFastingNotifications() async {
    await cancelNotification(1001);
    await cancelNotification(1002);
    await cancelNotification(1003);
  }

  DateTime? _nextFutureTime(DateTime dateTime) {
    final now = DateTime.now();
    if (dateTime.isAfter(now.add(const Duration(seconds: 5)))) {
      return dateTime;
    }
    return null;
  }
}
