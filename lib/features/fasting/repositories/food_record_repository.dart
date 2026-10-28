import 'package:hive_flutter/hive_flutter.dart';
import '../models/food_record.dart';

class FoodRecordRepository {
  Box<FoodRecord>? _foodBox;
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    _foodBox = await Hive.openBox<FoodRecord>('food_records');
    _isInitialized = true;
  }

  Future<void> addRecord(FoodRecord record) async {
    if (!_isInitialized) return;
    await _foodBox!.put(record.id, record);
  }

  Future<void> updateRecord(FoodRecord record) async {
    if (!_isInitialized) return;
    await _foodBox!.put(record.id, record);
  }

  Future<void> deleteRecord(String id) async {
    if (!_isInitialized) return;
    await _foodBox!.delete(id);
  }

  Future<List<FoodRecord>> getAllRecords() async {
    if (!_isInitialized) return [];
    final records = _foodBox!.values.toList();
    records.sort((a, b) => b.recordTime.compareTo(a.recordTime));
    return records;
  }

  Future<List<FoodRecord>> getRecordsByDate(DateTime date) async {
    if (!_isInitialized) return [];
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final records = _foodBox!.values.where((record) {
      return record.recordTime.isAfter(startOfDay) &&
          record.recordTime.isBefore(endOfDay);
    }).toList();

    records.sort((a, b) => b.recordTime.compareTo(a.recordTime));
    return records;
  }

  Future<List<FoodRecord>> getTodayRecords() async {
    return getRecordsByDate(DateTime.now());
  }

  Future<double> getTodayTotalCalories() async {
    final todayRecords = await getTodayRecords();
    return todayRecords.fold<double>(
      0.0,
      (sum, record) => sum + record.totalCalories,
    );
  }

  Future<Map<String, List<FoodRecord>>> getTodayRecordsByMeal() async {
    final todayRecords = await getTodayRecords();
    final Map<String, List<FoodRecord>> result = {
      'breakfast': [],
      'lunch': [],
      'dinner': [],
      'snack': [],
      'other': [],
    };

    for (final record in todayRecords) {
      final mealType = record.mealType ?? 'other';
      if (result.containsKey(mealType)) {
        result[mealType]!.add(record);
      } else {
        result['other']!.add(record);
      }
    }

    return result;
  }

  Future<void> clearAllRecords() async {
    if (!_isInitialized) return;
    await _foodBox!.clear();
  }
}
