import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:flutter_timezone/flutter_timezone.dart';

import 'ohos_native_service.dart';
import 'relax_audio_notification_service.dart';

/// 每日提醒：在用户设置的时间点发送本地通知
/// 实现：原生 AlarmManager + 开机恢复 + 前台兜底
class DailyReminderService {
  static const int _dailyReminderId = 0;
  static const String _channelId = 'daily_reminder_v2';
  static const String _channelName = '每日提醒';
  static const String reminderModeSystem = 'system';
  static const String reminderModeCalendar = 'calendar';
  static const String reminderModeAndroid = 'notification';
  static const String _ohosCalendarDailyReminderEventIdKey =
      'ohos_daily_calendar_reminder_event_id';
  static const _nativeChannel = MethodChannel('com.bear.emoon/reminder');

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  /// 前台兜底：app 在前台时到点发送即时通知
  static Timer? _foregroundFallbackTimer;

  /// 初始化（应用启动时调用一次）
  static Future<void> init() async {
    if (_initialized) return;
    if (OhosNativeService.isOhos) {
      _initialized = true;
      return;
    }
    tz_data.initializeTimeZones();
    try {
      final name = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(name.toString()));
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('Asia/Shanghai'));
    }

    const android = AndroidInitializationSettings('@mipmap/launcher_icon');
    // 不在 init 时请求权限，避免一进 app 就弹通知权限弹窗；仅在用户开启「每日提醒」时再请求
    const ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const settings = InitializationSettings(
      android: android,
      iOS: ios,
      macOS: ios,
    );
    await _plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse:
          RelaxAudioNotificationService.handleNotificationResponse,
    );

    // Android：创建通知渠道（创建渠道不触发权限弹窗，仅发通知时才需权限）
    if (Platform.isAndroid) {
      final androidPlugin = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      if (androidPlugin != null) {
        const channel = AndroidNotificationChannel(
          _channelId,
          _channelName,
          description: '提醒你记录今日心情',
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
          showBadge: true,
        );
        await androidPlugin.createNotificationChannel(channel);
      }
    }

    _initialized = true;
  }

  /// 仅检查是否已有通知权限（不弹窗）
  static Future<bool> hasPermission({
    String reminderMode = reminderModeSystem,
  }) async {
    if (OhosNativeService.isOhos) {
      if (reminderMode == reminderModeCalendar) return true;
      return OhosNativeService.areNotificationsEnabled();
    }
    if (!Platform.isAndroid) return true;
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidPlugin == null) return true;
    final granted = await androidPlugin.areNotificationsEnabled();
    return granted ?? false;
  }

  /// 是否已有精确闹钟权限（与 reminddrugs 一致，用于选择 alarmClock 调度）
  static Future<bool> hasExactAlarmPermission() async {
    if (!Platform.isAndroid) return true;
    try {
      final status = await Permission.scheduleExactAlarm.status;
      return status.isGranted;
    } catch (_) {
      return false;
    }
  }

  /// 检查并请求通知权限和精确闹钟权限。
  /// 仅应在用户第一次打开「每日提醒」开关时调用，其它地方不要调用，避免提前弹权限。
  static Future<bool> checkAndRequestPermissions({
    String reminderMode = reminderModeSystem,
  }) async {
    if (OhosNativeService.isOhos) {
      if (reminderMode == reminderModeCalendar) return true;
      return OhosNativeService.requestNotificationPermission();
    }
    if (!Platform.isAndroid) return true;

    // 1. 通知权限：先 permission_handler，若不弹窗则用插件再试一次（Android 13+ 才有系统弹窗，12 及以下默认有权限）
    bool notifyGranted = (await Permission.notification.status).isGranted;
    if (!notifyGranted) {
      final result = await Permission.notification.request();
      notifyGranted = result.isGranted;
    }
    if (!notifyGranted) {
      final androidPlugin = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      if (androidPlugin != null) {
        final pluginGranted = await androidPlugin
            .requestNotificationsPermission();
        notifyGranted = pluginGranted == true;
      }
    }
    if (!notifyGranted) return false;

    // 2. 精确闹钟权限 (Android 12+)，否则到点可能不响铃
    try {
      final exactStatus = await Permission.scheduleExactAlarm.status;
      if (exactStatus.isDenied) {
        await Permission.scheduleExactAlarm.request();
        // 用户拒绝精确闹钟时仍继续，后续用普通调度兜底
      }
    } catch (_) {
      // 旧系统或未支持时忽略
    }

    return true;
  }

  /// 安排每日在 [hour]:[minute] 发送提醒（仅在已有通知权限时执行；权限仅在使用时请求）
  static Future<bool> scheduleDaily(
    int hour,
    int minute, {
    String reminderMode = reminderModeSystem,
    int? id,
    String? title,
  }) async {
    if (!_initialized) await init();
    final reminderId = id ?? _dailyReminderId;
    if (OhosNativeService.isOhos) {
      if (reminderMode == reminderModeCalendar) {
        return true;
      }
      return OhosNativeService.scheduleReminder(
        id: reminderId,
        title: title ?? _channelName,
        body: '今天过得怎么样？来记录一下心情吧～',
        hour: hour,
        minute: minute,
        repeatDaily: true,
      );
    }
    if (Platform.isAndroid && !(await hasPermission())) return false;

    // 前台兜底（如果有）对于多条提醒暂时不实现，仅保留单条遗留接口的兜底
    if (reminderId == _dailyReminderId) {
      _foregroundFallbackTimer?.cancel();
      _foregroundFallbackTimer = null;
    }

    return true;
  }

  /// 仅同步所有提醒列表给 Android 的 AlarmManager，一次性覆盖
  static Future<void> syncAndroidReminders(List<Map<String, dynamic>> reminders) async {
    if (Platform.isAndroid) {
      try {
        await _nativeChannel.invokeMethod('syncReminders', reminders);
      } catch (e) {
        print('Error syncing Android reminders: $e');
      }
    }
  }

  /// 取消每日提醒
  static Future<void> cancelDaily({
    String reminderMode = reminderModeSystem,
    int? id,
  }) async {
    final reminderId = id ?? _dailyReminderId;
    if (reminderId == _dailyReminderId) {
      _foregroundFallbackTimer?.cancel();
      _foregroundFallbackTimer = null;
    }
    if (OhosNativeService.isOhos) {
      if (reminderMode == reminderModeCalendar) {
        await cancelOhosCalendarDaily();
        return;
      }
      await OhosNativeService.cancelReminder(reminderId);
      return;
    }

    await _plugin.cancel(id: reminderId);
  }

  /// 取消当前平台下所有每日提醒实现（系统提醒和日历提醒）
  static Future<void> cancelAllDailyReminders() async {
    if (OhosNativeService.isOhos) {
      await cancelDaily(reminderMode: reminderModeSystem);
      await cancelDaily(reminderMode: reminderModeCalendar);
      return;
    }
    await cancelDaily();
  }

  /// 仅用于鸿蒙系统日历提醒：取消由本应用创建的每日事件
  static Future<void> cancelOhosCalendarDaily() async {
    if (!OhosNativeService.isOhos) return;

    final prefs = await SharedPreferences.getInstance();
    final eventId = prefs.getInt(_ohosCalendarDailyReminderEventIdKey) ?? 0;
    if (eventId != 0) {
      await OhosNativeService.removeCalendarEvent(eventId: eventId);
    }
    await prefs.remove(_ohosCalendarDailyReminderEventIdKey);
  }

  /// 仅用于鸿蒙系统日历提醒：创建或重建每日重复事件
  static Future<bool> scheduleOhosCalendarDaily(int hour, int minute) async {
    if (!OhosNativeService.isOhos) return false;

    await cancelOhosCalendarDaily();
    final eventId = await OhosNativeService.addCalendarEvent(
      title: 'FOMO情绪',
      body: '今天过得怎么样？来记录一下心情吧～',
      hour: hour,
      minute: minute,
    );
    if (eventId == null) return false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_ohosCalendarDailyReminderEventIdKey, eventId);
    return true;
  }

  /// 立即发送一条测试提醒（用于验证通知是否正常）
  static Future<void> showTestNotification() async {
    if (!_initialized) await init();
    if (OhosNativeService.isOhos) {
      await OhosNativeService.showNotification(
        id: 999,
        title: 'FOMO情绪',
        body: '今天过得怎么样？来记录一下心情吧～',
      );
      return;
    }
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: '提醒你记录今日心情',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      channelAction: AndroidNotificationChannelAction.createIfNotExists,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    await _plugin.show(id: 999, title: 'FOMO情绪', body: '今天过得怎么样？来记录一下心情吧～', notificationDetails: details);
  }

  /// 安排一次性的复测提醒。
  static Future<void> scheduleRetestReminder({
    required int notificationId,
    required DateTime scheduledAt,
    String title = 'FOMO情绪',
    String body = '到时间复测一下最近的状态了，回到应用看看这几天有没有变化。',
    String? payload,
  }) async {
    if (!_initialized) await init();
    if (OhosNativeService.isOhos) {
      await OhosNativeService.scheduleReminder(
        id: notificationId,
        title: title,
        body: body,
        hour: scheduledAt.hour,
        minute: scheduledAt.minute,
        scheduledAt: scheduledAt,
      );
      return;
    }
    if (Platform.isAndroid && !(await hasPermission())) return;

    final target = tz.TZDateTime.from(scheduledAt, tz.local);
    final now = tz.TZDateTime.now(tz.local);
    final safeTarget = target.isBefore(now)
        ? now.add(const Duration(minutes: 1))
        : target;

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: '提醒你记录今日心情',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      channelAction: AndroidNotificationChannelAction.createIfNotExists,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final exact = await hasExactAlarmPermission();
    await _plugin.zonedSchedule(id: notificationId, title: title, body: body, scheduledDate: safeTarget, notificationDetails: details, androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle);
  }

  static Future<void> cancelNotification(int notificationId) async {
    if (!_initialized) await init();
    if (OhosNativeService.isOhos) {
      await OhosNativeService.cancelNotification(notificationId);
      return;
    }
    await _plugin.cancel(id: notificationId);
  }
}
