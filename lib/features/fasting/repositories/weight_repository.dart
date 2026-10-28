import 'package:hive_flutter/hive_flutter.dart';
import '../models/weight_record.dart';
import '../core/constants/app_constants.dart';

class WeightRepository {
  Box<WeightRecord>? _weightBox;
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    _weightBox = await Hive.openBox<WeightRecord>(AppConstants.weightRecordBox);
    _isInitialized = true;
  }

  Future<void> addRecord(WeightRecord record) async {
    if (!_isInitialized) return;
    await _weightBox!.put(record.id, record);
  }

  Future<void> updateRecord(WeightRecord record) async {
    if (!_isInitialized) return;
    await _weightBox!.put(record.id, record);
  }

  Future<void> deleteRecord(String id) async {
    if (!_isInitialized) return;
    await _weightBox!.delete(id);
  }

  Future<List<WeightRecord>> getAllRecords() async {
    if (!_isInitialized) return [];
    final records = _weightBox!.values.toList();
    records.sort((a, b) => b.recordTime.compareTo(a.recordTime));
    return records;
  }

  Future<List<WeightRecord>> getRecordsByDate(DateTime date) async {
    if (!_isInitialized) return [];
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final records = _weightBox!.values.where((record) {
      return record.recordTime.isAfter(startOfDay) &&
          record.recordTime.isBefore(endOfDay);
    }).toList();

    records.sort((a, b) => b.recordTime.compareTo(a.recordTime));
    return records;
  }

  Future<List<WeightRecord>> getTodayRecords() async {
    return getRecordsByDate(DateTime.now());
  }

  Future<WeightRecord?> getLatestRecord() async {
    final allRecords = await getAllRecords();
    return allRecords.isNotEmpty ? allRecords.first : null;
  }

  Future<WeightRecord?> getTodayLatestRecord() async {
    final todayRecords = await getTodayRecords();
    return todayRecords.isNotEmpty ? todayRecords.first : null;
  }

  Future<List<WeightRecord>> getRecordsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    if (!_isInitialized) return [];
    final records = _weightBox!.values.where((record) {
      return record.recordTime.isAfter(start) &&
          record.recordTime.isBefore(end);
    }).toList();

    records.sort((a, b) => b.recordTime.compareTo(a.recordTime));
    return records;
  }

  Future<List<WeightRecord>> getRecentRecords({int limit = 10}) async {
    final allRecords = await getAllRecords();
    return allRecords.take(limit).toList();
  }

  Future<Map<DateTime, double>> getWeightTrendByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final records = await getRecordsByDateRange(start, end);
    final weightTrend = <DateTime, double>{};

    for (final record in records) {
      final date = DateTime(
        record.recordTime.year,
        record.recordTime.month,
        record.recordTime.day,
      );

      if (!weightTrend.containsKey(date) ||
          record.recordTime.isAfter(
            DateTime(date.year, date.month, date.day),
          )) {
        weightTrend[date] = record.weight;
      }
    }

    return weightTrend;
  }

  Future<double?> getWeightChange() async {
    final recentRecords = await getRecentRecords(limit: 2);
    if (recentRecords.length < 2) return null;

    return recentRecords[0].weight - recentRecords[1].weight;
  }

  double calculateBMI(double weight, {double? height}) {
    final userHeight = height ?? 1.70;
    return weight / (userHeight * userHeight);
  }

  String getBMICategory(double bmi) {
    if (bmi < 18.5) return '偏瘦';
    if (bmi < 24.0) return '正常';
    if (bmi < 28.0) return '超重';
    return '肥胖';
  }

  String getBMICategoryColor(double bmi) {
    if (bmi < 18.5) return 'blue';
    if (bmi < 24.0) return 'green';
    if (bmi < 28.0) return 'orange';
    return 'red';
  }

  Future<double?> getWeeklyAverageWeight() async {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 7));

    final weightTrend = await getWeightTrendByDateRange(weekStart, weekEnd);
    if (weightTrend.isEmpty) return null;

    final totalWeight = weightTrend.values.fold(
      0.0,
      (sum, weight) => sum + weight,
    );
    return totalWeight / weightTrend.length;
  }

  Future<double?> getMonthlyAverageWeight() async {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 1);

    final weightTrend = await getWeightTrendByDateRange(monthStart, monthEnd);
    if (weightTrend.isEmpty) return null;

    final totalWeight = weightTrend.values.fold(
      0.0,
      (sum, weight) => sum + weight,
    );
    return totalWeight / weightTrend.length;
  }

  Future<WeightRecord?> getTargetWeightRecord() async {
    if (!_isInitialized) return null;
    final records = _weightBox!.values
        .where((record) => record.isTarget)
        .toList();
    if (records.isEmpty) return null;

    records.sort((a, b) => b.recordTime.compareTo(a.recordTime));
    return records.first;
  }

  Future<void> setTargetWeight(double targetWeight, {String? notes}) async {
    if (!_isInitialized) return;

    final allRecords = await getAllRecords();
    for (final record in allRecords.where((r) => r.isTarget)) {
      final updatedRecord = record.copyWith(
        isTarget: false,
        updatedAt: DateTime.now(),
      );
      await updateRecord(updatedRecord);
    }

    final targetRecord = WeightRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      weight: targetWeight,
      recordTime: DateTime.now(),
      isTarget: true,
      notes: notes ?? '目标体重',
      createdAt: DateTime.now(),
    );

    await addRecord(targetRecord);
  }

  Future<void> clearAllRecords() async {
    if (!_isInitialized) return;
    await _weightBox!.clear();
  }

  Future<void> close() async {
    if (!_isInitialized) return;
    await _weightBox!.close();
    _isInitialized = false;
  }

  Future<Map<String, dynamic>> getWeightSummary() async {
    final latestRecord = await getLatestRecord();
    final weeklyAverage = await getWeeklyAverageWeight();
    final monthlyAverage = await getMonthlyAverageWeight();
    final weightChange = await getWeightChange();
    final targetRecord = await getTargetWeightRecord();

    double? bmi;
    String? bmiCategory;
    String? bmiColor;

    if (latestRecord != null) {
      bmi = calculateBMI(latestRecord.weight);
      bmiCategory = getBMICategory(bmi);
      bmiColor = getBMICategoryColor(bmi);
    }

    return {
      'latestWeight': latestRecord?.weight,
      'latestRecordTime': latestRecord?.recordTime,
      'weeklyAverage': weeklyAverage,
      'monthlyAverage': monthlyAverage,
      'weightChange': weightChange,
      'targetWeight': targetRecord?.weight,
      'bmi': bmi,
      'bmiCategory': bmiCategory,
      'bmiColor': bmiColor,
      'totalRecords': _isInitialized ? _weightBox!.length : 0,
    };
  }
}
