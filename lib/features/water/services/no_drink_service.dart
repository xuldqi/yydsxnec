import '../models/drink_record.dart';
import 'database_service.dart';

class NoDrinkStats {
  final int totalDays;
  final int longestStreak;
  final int currentStreak;
  final int thisMonthCount;
  final int thisYearCount;

  NoDrinkStats({
    required this.totalDays,
    required this.longestStreak,
    required this.currentStreak,
    required this.thisMonthCount,
    required this.thisYearCount,
  });
}

class NoDrinkService {
  static final NoDrinkService _instance = NoDrinkService._internal();
  factory NoDrinkService() => _instance;
  NoDrinkService._internal();

  final DatabaseService _db = DatabaseService();

  // 格式化日期：YYYY-M-D
  String _formatDate(DateTime dt) {
    return '${dt.year}-${dt.month}-${dt.day}';
  }

  // 检查当天是否记录了高糖饮品
  Future<bool> hasDrunkOnDate(String userId, DateTime dt) async {
    final start = DateTime(dt.year, dt.month, dt.day);
    final end = start.add(const Duration(days: 1));
    final records = await _db.getDrinkRecords(
      userId: userId,
      startDate: start,
      endDate: end,
    );
    return records.any(_isHighSugarDrink);
  }

  bool _isHighSugarDrink(DrinkRecord record) {
    final category = record.category;
    final name = record.name;
    if (record.sugar >= 15 || record.calories >= 150) return true;
    return category.contains('奶茶') ||
        category.contains('果茶') ||
        name.contains('奶茶') ||
        name.contains('可乐') ||
        name.contains('雪碧') ||
        name.contains('果汁') ||
        name.contains('奶昔') ||
        name.contains('冰淇淋');
  }

  // 今日控糖打卡
  Future<bool> checkIn(String userId) async {
    final now = DateTime.now();
    final todayStr = _formatDate(now);

    // 1. 检查今天是否记录了高糖饮品
    final drunk = await hasDrunkOnDate(userId, now);
    if (drunk) return false;

    // 2. 打卡
    await _db.insertCheckIn(userId, todayStr);
    return true;
  }

  // 批量补签打卡
  Future<Map<String, int>> batchCheckIn(
    String userId,
    List<DateTime> dates,
  ) async {
    int success = 0;
    int skipped = 0;

    for (var date in dates) {
      final dateStr = _formatDate(date);

      // 检查这一天是否已经打卡
      final checkIns = await _db.getCheckInDates(userId);
      if (checkIns.contains(dateStr)) {
        skipped++;
        continue;
      }

      // 检查这一天是否记录了高糖饮品
      final drunk = await hasDrunkOnDate(userId, date);
      if (drunk) {
        skipped++;
        continue;
      }

      await _db.insertCheckIn(userId, dateStr);
      success++;
    }

    return {'success': success, 'skipped': skipped};
  }

  // 撤销打卡
  Future<void> deleteCheckIn(String userId, DateTime date) async {
    await _db.deleteCheckIn(userId, _formatDate(date));
  }

  // 获取统计信息
  Future<NoDrinkStats> getStats(String userId) async {
    final checkInDates = await _db.getCheckInDates(userId);
    if (checkInDates.isEmpty) {
      return NoDrinkStats(
        totalDays: 0,
        longestStreak: 0,
        currentStreak: 0,
        thisMonthCount: 0,
        thisYearCount: 0,
      );
    }

    // 解析日期列表并排序
    final List<DateTime> dates = checkInDates.map((dStr) {
      final parts = dStr.split('-');
      return DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
    }).toList();
    dates.sort();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    // 计算当前连续天数 (currentStreak)
    int currentStreak = 0;
    if (checkInDates.contains(_formatDate(today))) {
      currentStreak = 1;
      while (checkInDates.contains(
        _formatDate(today.subtract(Duration(days: currentStreak))),
      )) {
        currentStreak++;
      }
    } else if (checkInDates.contains(_formatDate(yesterday))) {
      currentStreak = 1;
      while (checkInDates.contains(
        _formatDate(yesterday.subtract(Duration(days: currentStreak))),
      )) {
        currentStreak++;
      }
    }

    // 计算最长连续天数 (longestStreak)
    int longestStreak = 0;
    int currentRun = 0;

    for (int i = 0; i < dates.length; i++) {
      if (i == 0) {
        currentRun = 1;
      } else {
        final diff = dates[i].difference(dates[i - 1]).inDays;
        if (diff == 1) {
          currentRun++;
        } else if (diff > 1) {
          if (currentRun > longestStreak) {
            longestStreak = currentRun;
          }
          currentRun = 1;
        }
      }
    }
    if (currentRun > longestStreak) {
      longestStreak = currentRun;
    }

    // 统计本月及本年打卡天数
    int thisMonth = 0;
    int thisYear = 0;

    for (var date in dates) {
      if (date.year == now.year) {
        thisYear++;
        if (date.month == now.month) {
          thisMonth++;
        }
      }
    }

    return NoDrinkStats(
      totalDays: checkInDates.length,
      longestStreak: longestStreak,
      currentStreak: currentStreak,
      thisMonthCount: thisMonth,
      thisYearCount: thisYear,
    );
  }
}
