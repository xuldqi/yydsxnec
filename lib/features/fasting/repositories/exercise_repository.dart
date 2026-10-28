import 'package:hive_flutter/hive_flutter.dart';
import '../models/exercise_record.dart';
import '../core/constants/app_constants.dart';

class ExerciseRepository {
  Box<ExerciseRecord>? _exerciseBox;
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    _exerciseBox = await Hive.openBox<ExerciseRecord>(
      AppConstants.exerciseRecordBox,
    );
    _isInitialized = true;
  }

  Future<void> addRecord(ExerciseRecord record) async {
    if (!_isInitialized) return;
    await _exerciseBox!.put(record.id, record);
  }

  Future<void> updateRecord(ExerciseRecord record) async {
    if (!_isInitialized) return;
    await _exerciseBox!.put(record.id, record);
  }

  Future<void> deleteRecord(String id) async {
    if (!_isInitialized) return;
    await _exerciseBox!.delete(id);
  }

  Future<List<ExerciseRecord>> getAllRecords() async {
    if (!_isInitialized) return [];
    final records = _exerciseBox!.values.toList();
    records.sort((a, b) => b.recordTime.compareTo(a.recordTime));
    return records;
  }

  Future<List<ExerciseRecord>> getRecordsByDate(DateTime date) async {
    if (!_isInitialized) return [];
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final records = _exerciseBox!.values.where((record) {
      return record.recordTime.isAfter(startOfDay) &&
          record.recordTime.isBefore(endOfDay);
    }).toList();

    records.sort((a, b) => b.recordTime.compareTo(a.recordTime));
    return records;
  }

  Future<List<ExerciseRecord>> getTodayRecords() async {
    return getRecordsByDate(DateTime.now());
  }

  Future<List<ExerciseRecord>> getWeekRecords() async {
    if (!_isInitialized) return [];
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfWeekDay = DateTime(
      startOfWeek.year,
      startOfWeek.month,
      startOfWeek.day,
    );
    final endOfWeek = startOfWeekDay.add(const Duration(days: 7));

    final records = _exerciseBox!.values.where((record) {
      return record.recordTime.isAfter(startOfWeekDay) &&
          record.recordTime.isBefore(endOfWeek);
    }).toList();

    records.sort((a, b) => b.recordTime.compareTo(a.recordTime));
    return records;
  }

  Future<List<ExerciseRecord>> getRecordsByType(ExerciseType type) async {
    if (!_isInitialized) return [];
    final records = _exerciseBox!.values
        .where((record) => record.type == type)
        .toList();
    records.sort((a, b) => b.recordTime.compareTo(a.recordTime));
    return records;
  }

  Future<int> getTodayTotalDuration() async {
    final todayRecords = await getTodayRecords();
    return todayRecords.fold<int>(
      0,
      (sum, record) => sum + record.durationMinutes,
    );
  }

  Future<double> getTodayTotalCalories() async {
    final todayRecords = await getTodayRecords();
    return todayRecords.fold<double>(
      0.0,
      (sum, record) => sum + (record.calories ?? record.estimatedCalories),
    );
  }

  Future<void> clearAllRecords() async {
    if (!_isInitialized) return;
    await _exerciseBox!.clear();
  }

  Future<void> clearRecordsByDate(DateTime date) async {
    final records = await getRecordsByDate(date);
    for (final record in records) {
      await deleteRecord(record.id);
    }
  }
}
