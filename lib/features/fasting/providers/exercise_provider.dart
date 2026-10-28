import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/exercise_record.dart';
import '../repositories/exercise_repository.dart';
import '../core/constants/app_constants.dart';

// Exercise Repository Provider
final exerciseRepositoryProvider = Provider<ExerciseRepository>((ref) {
  final repository = ExerciseRepository();
  // 异步初始化，不阻塞
  repository.init().catchError((e) {
    debugPrint('运动记录数据库初始化失败: $e');
  });
  return repository;
});

// 运动记录列表Provider
final exerciseRecordsProvider =
    StateNotifierProvider<
      ExerciseRecordsNotifier,
      AsyncValue<List<ExerciseRecord>>
    >((ref) {
      return ExerciseRecordsNotifier(ref.read(exerciseRepositoryProvider));
    });

// 今日运动记录Provider
final todayExerciseRecordsProvider = Provider<AsyncValue<List<ExerciseRecord>>>(
  (ref) {
    final records = ref.watch(exerciseRecordsProvider);
    return records.when(
      data: (allRecords) {
        final today = DateTime.now();
        final startOfDay = DateTime(today.year, today.month, today.day);
        final endOfDay = startOfDay.add(const Duration(days: 1));

        final todayRecords = allRecords.where((record) {
          return record.recordTime.isAfter(startOfDay) &&
              record.recordTime.isBefore(endOfDay);
        }).toList();

        todayRecords.sort((a, b) => b.recordTime.compareTo(a.recordTime));
        return AsyncValue.data(todayRecords);
      },
      loading: () => const AsyncValue.loading(),
      error: (error, stack) => AsyncValue.error(error, stack),
    );
  },
);

// 今日总运动时长Provider
final todayExerciseDurationProvider = Provider<AsyncValue<int>>((ref) {
  final todayRecords = ref.watch(todayExerciseRecordsProvider);
  return todayRecords.when(
    data: (records) {
      final totalMinutes = records.fold(
        0,
        (sum, record) => sum + record.durationMinutes,
      );
      return AsyncValue.data(totalMinutes);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

// 今日消耗卡路里Provider
final todayExerciseCaloriesProvider = Provider<AsyncValue<double>>((ref) {
  final todayRecords = ref.watch(todayExerciseRecordsProvider);
  return todayRecords.when(
    data: (records) {
      final totalCalories = records.fold(
        0.0,
        (sum, record) => sum + (record.calories ?? record.estimatedCalories),
      );
      return AsyncValue.data(totalCalories);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

// 运动记录状态管理
class ExerciseRecordsNotifier
    extends StateNotifier<AsyncValue<List<ExerciseRecord>>> {
  final ExerciseRepository _repository;

  ExerciseRecordsNotifier(this._repository)
    : super(const AsyncValue.loading()) {
    loadRecords();
  }

  Future<void> loadRecords() async {
    try {
      state = const AsyncValue.loading();
      final records = await _repository.getAllRecords();
      state = AsyncValue.data(records);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addRecord({
    required ExerciseType type,
    required int durationMinutes,
    DateTime? recordTime,
    double? calories,
    double? distance,
    String? notes,
    int? intensity,
  }) async {
    try {
      final record = ExerciseRecord(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: type,
        recordTime: recordTime ?? DateTime.now(),
        durationMinutes: durationMinutes,
        calories: calories,
        distance: distance,
        notes: notes,
        intensity: intensity ?? 3,
        createdAt: DateTime.now(),
      );

      await _repository.addRecord(record);
      await loadRecords();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateRecord(ExerciseRecord record) async {
    try {
      final updatedRecord = record.copyWith(updatedAt: DateTime.now());

      await _repository.updateRecord(updatedRecord);
      await loadRecords();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteRecord(String id) async {
    try {
      await _repository.deleteRecord(id);
      await loadRecords();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
