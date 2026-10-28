import 'package:intl/intl.dart';

/// 日期时间工具类
class AppDateUtils {
  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  static final DateFormat _timeFormat = DateFormat('HH:mm');
  static final DateFormat _dateTimeFormat = DateFormat('yyyy-MM-dd HH:mm');
  static final DateFormat _displayDateFormat = DateFormat('M月d日');
  static final DateFormat _displayTimeFormat = DateFormat('HH:mm');

  /// 格式化日期为字符串 (yyyy-MM-dd)
  static String formatDate(DateTime date) {
    return _dateFormat.format(date);
  }

  /// 格式化时间为字符串 (HH:mm)
  static String formatTime(DateTime time) {
    return _timeFormat.format(time);
  }

  /// 格式化日期时间为字符串 (yyyy-MM-dd HH:mm)
  static String formatDateTime(DateTime dateTime) {
    return _dateTimeFormat.format(dateTime);
  }

  /// 格式化显示日期 (M月d日)
  static String formatDisplayDate(DateTime date) {
    return _displayDateFormat.format(date);
  }

  /// 格式化显示时间 (HH:mm)
  static String formatDisplayTime(DateTime time) {
    return _displayTimeFormat.format(time);
  }

  /// 解析日期字符串
  static DateTime? parseDate(String dateString) {
    try {
      return _dateFormat.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// 解析时间字符串
  static DateTime? parseTime(String timeString) {
    try {
      return _timeFormat.parse(timeString);
    } catch (e) {
      return null;
    }
  }

  /// 解析日期时间字符串
  static DateTime? parseDateTime(String dateTimeString) {
    try {
      return _dateTimeFormat.parse(dateTimeString);
    } catch (e) {
      return null;
    }
  }

  /// 获取今天的开始时间 (00:00:00)
  static DateTime getTodayStart() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// 获取今天的结束时间 (23:59:59)
  static DateTime getTodayEnd() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, 23, 59, 59);
  }

  /// 获取本周开始时间 (周一 00:00:00)
  static DateTime getWeekStart([DateTime? date]) {
    final target = date ?? DateTime.now();
    final weekday = target.weekday;
    final daysToSubtract = weekday - 1;
    final weekStart = target.subtract(Duration(days: daysToSubtract));
    return DateTime(weekStart.year, weekStart.month, weekStart.day);
  }

  /// 获取本周结束时间 (周日 23:59:59)
  static DateTime getWeekEnd([DateTime? date]) {
    final weekStart = getWeekStart(date);
    final weekEnd = weekStart.add(const Duration(days: 6));
    return DateTime(weekEnd.year, weekEnd.month, weekEnd.day, 23, 59, 59);
  }

  /// 获取本月开始时间
  static DateTime getMonthStart([DateTime? date]) {
    final target = date ?? DateTime.now();
    return DateTime(target.year, target.month, 1);
  }

  /// 获取本月结束时间
  static DateTime getMonthEnd([DateTime? date]) {
    final target = date ?? DateTime.now();
    final nextMonth = target.month == 12 ? 1 : target.month + 1;
    final nextYear = target.month == 12 ? target.year + 1 : target.year;
    return DateTime(
      nextYear,
      nextMonth,
      1,
    ).subtract(const Duration(microseconds: 1));
  }

  /// 判断是否为同一天
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// 判断是否为今天
  static bool isToday(DateTime date) {
    return isSameDay(date, DateTime.now());
  }

  /// 判断是否为昨天
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return isSameDay(date, yesterday);
  }

  /// 计算两个日期之间的天数差
  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  /// 格式化持续时间
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '$hours小时$minutes分钟';
    } else {
      return '$minutes分钟';
    }
  }

  /// 格式化倒计时
  static String formatCountdown(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  /// 获取相对时间描述
  static String getRelativeTimeDescription(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}天前';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}小时前';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}分钟前';
    } else {
      return '刚刚';
    }
  }
}
