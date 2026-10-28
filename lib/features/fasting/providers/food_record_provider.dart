import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/food_record.dart';
import '../repositories/food_record_repository.dart';

// Food Record Repository Provider
final foodRecordRepositoryProvider = Provider<FoodRecordRepository>((ref) {
  final repository = FoodRecordRepository();
  // 异步初始化，不阻塞
  repository.init().catchError((e) {
    debugPrint('饮食记录数据库初始化失败: $e');
  });
  return repository;
});

// 饮食记录列表Provider
final foodRecordsProvider =
    StateNotifierProvider<FoodRecordsNotifier, AsyncValue<List<FoodRecord>>>((
      ref,
    ) {
      return FoodRecordsNotifier(ref.read(foodRecordRepositoryProvider));
    });

// 今日饮食记录Provider
final todayFoodRecordsProvider = Provider<AsyncValue<List<FoodRecord>>>((ref) {
  final records = ref.watch(foodRecordsProvider);
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
});

// 今日总卡路里Provider
final todayFoodCaloriesProvider = Provider<AsyncValue<double>>((ref) {
  final todayRecords = ref.watch(todayFoodRecordsProvider);
  return todayRecords.when(
    data: (records) {
      final totalCalories = records.fold(
        0.0,
        (sum, record) => sum + record.totalCalories,
      );
      return AsyncValue.data(totalCalories);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

// 今日餐次记录Provider
final todayFoodRecordsByMealProvider =
    Provider<AsyncValue<Map<String, List<FoodRecord>>>>((ref) {
      final todayRecords = ref.watch(todayFoodRecordsProvider);
      return todayRecords.when(
        data: (records) {
          final Map<String, List<FoodRecord>> result = {
            'breakfast': [],
            'lunch': [],
            'dinner': [],
            'snack': [],
            'other': [],
          };

          for (final record in records) {
            final mealType = record.mealType ?? 'other';
            if (result.containsKey(mealType)) {
              result[mealType]!.add(record);
            } else {
              result['other']!.add(record);
            }
          }

          return AsyncValue.data(result);
        },
        loading: () => const AsyncValue.loading(),
        error: (error, stack) => AsyncValue.error(error, stack),
      );
    });

// 饮食记录状态管理
class FoodRecordsNotifier extends StateNotifier<AsyncValue<List<FoodRecord>>> {
  final FoodRecordRepository _repository;

  FoodRecordsNotifier(this._repository) : super(const AsyncValue.loading()) {
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
    required String foodId,
    required String foodName,
    required double quantity,
    DateTime? recordTime,
    String unit = 'g',
    String? mealType,
    String? notes,
    Map<String, dynamic>? nutrition,
    double? calories,
  }) async {
    try {
      final record = FoodRecord(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        foodId: foodId,
        foodName: foodName,
        recordTime: recordTime ?? DateTime.now(),
        quantity: quantity,
        unit: unit,
        mealType: mealType,
        notes: notes,
        nutrition: nutrition,
        calories: calories,
        createdAt: DateTime.now(),
      );

      await _repository.addRecord(record);
      await loadRecords();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateRecord(FoodRecord record) async {
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
