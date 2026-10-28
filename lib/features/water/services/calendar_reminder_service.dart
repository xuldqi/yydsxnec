import 'dart:math';
import 'package:flutter/services.dart';

class CalendarReminderResult {
  final bool supported;
  final bool success;
  final int? eventId;
  final String? message;

  const CalendarReminderResult({
    required this.supported,
    this.success = false,
    this.eventId,
    this.message,
  });

  factory CalendarReminderResult.fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return const CalendarReminderResult(supported: false, message: '日历提醒不可用');
    }
    return CalendarReminderResult(
      supported: map['supported'] == true,
      success: map['success'] == true || map['supported'] == true,
      eventId: (map['eventId'] as num?)?.toInt(),
      message: map['message']?.toString(),
    );
  }
}

class CalendarReminderService {
  CalendarReminderService._();

  static const MethodChannel _channel = MethodChannel('xiaolu_water/calendar');

  static Future<CalendarReminderResult> createDailyWaterReminder({
    required int hour,
    required int minute,
  }) async {
    final now = DateTime.now();
    var start = DateTime(now.year, now.month, now.day, hour, minute);
    if (!start.isAfter(now)) {
      start = start.add(const Duration(days: 1));
    }
    final end = start.add(const Duration(minutes: 10));

    const titles = [
      '小鹿喝水：该补水啦，别让身体缺水哦～',
      '小鹿喝水：记得喝水！健康从一杯水开始 💧',
      '小鹿喝水：渴了吗？赶紧喝一杯水吧～',
      '小鹿喝水：补水时间到，喝完继续加油！',
      '小鹿喝水：小鹿提醒你，水分不够要及时补哦！',
      '小鹿喝水：每一杯水都是对自己的关爱 🦛',
      '小鹿喝水：喝水打卡时间，来记录一下吧～',
    ];
    final title = titles[Random().nextInt(titles.length)];

    try {
      final result = await _channel
          .invokeMapMethod<String, dynamic>('createDailyWaterReminder', {
            'title': title,
            'description': '小鹿喝水提醒您，注意补水哦～',
            'startTime': start.millisecondsSinceEpoch,
            'endTime': end.millisecondsSinceEpoch,
            'reminderMinutes': 0,
          });
      return CalendarReminderResult.fromMap(result);
    } on MissingPluginException {
      return const CalendarReminderResult(
        supported: false,
        message: '当前平台未接入日历提醒',
      );
    } on PlatformException catch (e) {
      return CalendarReminderResult(
        supported: true,
        success: false,
        message: e.message ?? '日历提醒创建失败',
      );
    }
  }

  static Future<CalendarReminderResult> deleteCalendarReminder({
    required int eventId,
  }) async {
    try {
      final result = await _channel.invokeMapMethod<String, dynamic>(
        'deleteCalendarReminder',
        {'eventId': eventId},
      );
      return CalendarReminderResult.fromMap(result);
    } on MissingPluginException {
      return const CalendarReminderResult(
        supported: false,
        message: '当前平台未接入日历提醒',
      );
    } on PlatformException catch (e) {
      return CalendarReminderResult(
        supported: true,
        success: false,
        message: e.message ?? '日历提醒删除失败',
      );
    }
  }
}
