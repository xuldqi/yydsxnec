import 'package:hive_flutter/hive_flutter.dart';
import '../models/water_record.dart';
import '../core/constants/app_constants.dart';

class WaterRepository {
  Box<WaterRecord>? _waterBox;
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    _waterBox = await Hive.openBox<WaterRecord>(AppConstants.waterRecordBox);
    _isInitialized = true;
  }

  Future<void> addRecord(WaterRecord record) async {
    if (!_isInitialized) return;
    await _waterBox!.put(record.id, record);
  }

  Future<void> updateRecord(WaterRecord record) async {
    if (!_isInitialized) return;
    await _waterBox!.put(record.id, record);
  }

  Future<void> deleteRecord(String id) async {
    if (!_isInitialized) return;
    await _waterBox!.delete(id);
  }

  Future<List<WaterRecord>> getAllRecords() async {
    if (!_isInitialized) return [];
    final records = _waterBox!.values.toList();
    records.sort((a, b) => b.recordTime.compareTo(a.recordTime));
    return records;
  }

  Future<List<WaterRecord>> getRecordsByDate(DateTime date) async {
    if (!_isInitialized) return [];
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final records = _waterBox!.values.where((record) {
      return record.recordTime.isAfter(startOfDay) &&
          record.recordTime.isBefore(endOfDay);
    }).toList();

    records.sort((a, b) => b.recordTime.compareTo(a.recordTime));
    return records;
  }

  Future<List<WaterRecord>> getTodayRecords() async {
    return getRecordsByDate(DateTime.now());
  }

  Future<int> getTodayTotalAmount() async {
    final todayRecords = await getTodayRecords();
    return todayRecords.fold<int>(
      0,
      (sum, record) => sum + record.amount.round(),
    );
  }

  Future<List<WaterRecord>> getRecordsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    if (!_isInitialized) return [];
    final records = _waterBox!.values.where((record) {
      return record.recordTime.isAfter(start) &&
          record.recordTime.isBefore(end);
    }).toList();

    records.sort((a, b) => b.recordTime.compareTo(a.recordTime));
    return records;
  }

  Future<Map<DateTime, int>> getDailyAmountsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final records = await getRecordsByDateRange(start, end);
    final dailyAmounts = <DateTime, int>{};

    for (final record in records) {
      final date = DateTime(
        record.recordTime.year,
        record.recordTime.month,
        record.recordTime.day,
      );

      dailyAmounts[date] = (dailyAmounts[date] ?? 0) + record.amount.round();
    }

    return dailyAmounts;
  }

  Future<Map<WaterType, int>> getTypeStatsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final records = await getRecordsByDateRange(start, end);
    final typeStats = <WaterType, int>{};

    for (final record in records) {
      typeStats[record.type] =
          (typeStats[record.type] ?? 0) + record.amount.round();
    }

    return typeStats;
  }

  Future<int> getWeeklyAverage() async {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 7));

    final dailyAmounts = await getDailyAmountsByDateRange(weekStart, weekEnd);
    if (dailyAmounts.isEmpty) return 0;

    final totalAmount = dailyAmounts.values.fold(
      0,
      (sum, amount) => sum + amount,
    );
    return (totalAmount / dailyAmounts.length).round();
  }

  Future<List<WaterRecord>> getRecentRecords({int limit = 10}) async {
    final allRecords = await getAllRecords();
    return allRecords.take(limit).toList();
  }

  Future<void> clearAllRecords() async {
    if (!_isInitialized) return;
    await _waterBox!.clear();
  }

  Future<void> close() async {
    if (_waterBox != null && _isInitialized) {
      await _waterBox!.close();
      _isInitialized = false;
    }
  }

  int getRecommendedDailyAmount({double? weight, int? activityMinutes}) {
    int baseAmount = 2000;

    if (weight != null) {
      baseAmount = (weight * 35).round();
    }

    if (activityMinutes != null) {
      final extraAmount = (activityMinutes / 30 * 250).round();
      baseAmount += extraAmount;
    }

    return baseAmount.clamp(1500, 4000);
  }
}
