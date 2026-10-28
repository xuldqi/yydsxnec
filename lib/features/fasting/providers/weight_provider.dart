import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/weight_record.dart';
import '../repositories/weight_repository.dart';

// Weight Repository Provider
final weightRepositoryProvider = Provider<WeightRepository>((ref) {
  final repository = WeightRepository();
  // 异步初始化，不阻塞
  repository.init().catchError((e) {
    debugPrint('体重记录数据库初始化失败: $e');
  });
  return repository;
});

// 体重记录列表Provider
final weightRecordsProvider =
    StateNotifierProvider<
      WeightRecordsNotifier,
      AsyncValue<List<WeightRecord>>
    >((ref) {
      return WeightRecordsNotifier(ref.read(weightRepositoryProvider));
    });

// 最新体重记录Provider
final latestWeightRecordProvider = Provider<AsyncValue<WeightRecord?>>((ref) {
  final records = ref.watch(weightRecordsProvider);
  return records.when(
    data: (allRecords) {
      final latestRecord = allRecords.isNotEmpty ? allRecords.first : null;
      return AsyncValue.data(latestRecord);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

// 今日最新体重Provider
final todayLatestWeightProvider = Provider<AsyncValue<WeightRecord?>>((ref) {
  final records = ref.watch(weightRecordsProvider);
  return records.when(
    data: (allRecords) {
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final todayRecords = allRecords.where((record) {
        return record.recordTime.isAfter(startOfDay) &&
            record.recordTime.isBefore(endOfDay);
      }).toList();

      final latestTodayRecord = todayRecords.isNotEmpty
          ? todayRecords.first
          : null;
      return AsyncValue.data(latestTodayRecord);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

// BMI计算Provider
final bmiProvider = Provider<AsyncValue<double?>>((ref) {
  final latestWeight = ref.watch(latestWeightRecordProvider);
  final repository = ref.read(weightRepositoryProvider);

  return latestWeight.when(
    data: (record) {
      if (record == null) return const AsyncValue.data(null);
      final bmi = repository.calculateBMI(record.weight);
      return AsyncValue.data(bmi);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

// BMI分类Provider
final bmiCategoryProvider = Provider<AsyncValue<String?>>((ref) {
  final bmiAsync = ref.watch(bmiProvider);
  final repository = ref.read(weightRepositoryProvider);

  return bmiAsync.when(
    data: (bmi) {
      if (bmi == null) return const AsyncValue.data(null);
      final category = repository.getBMICategory(bmi);
      return AsyncValue.data(category);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

// 体重变化Provider（与上次记录比较）
final weightChangeProvider = Provider<AsyncValue<double?>>((ref) {
  final records = ref.watch(weightRecordsProvider);
  return records.when(
    data: (allRecords) {
      if (allRecords.length < 2) return const AsyncValue.data(null);
      final change = allRecords[0].weight - allRecords[1].weight;
      return AsyncValue.data(change);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

// 目标体重Provider
final targetWeightProvider = Provider<AsyncValue<WeightRecord?>>((ref) {
  final records = ref.watch(weightRecordsProvider);
  return records.when(
    data: (allRecords) {
      final targetRecord =
          allRecords.where((record) => record.isTarget).isNotEmpty
          ? allRecords.where((record) => record.isTarget).first
          : null;
      return AsyncValue.data(targetRecord);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

// 体重统计摘要Provider
final weightSummaryProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final repository = ref.read(weightRepositoryProvider);
  return await repository.getWeightSummary();
});

// 体重记录状态管理
class WeightRecordsNotifier
    extends StateNotifier<AsyncValue<List<WeightRecord>>> {
  final WeightRepository _repository;

  WeightRecordsNotifier(this._repository) : super(const AsyncValue.loading()) {
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
    required double weight,
    DateTime? recordTime,
    String? notes,
    double? bodyFat,
    double? muscleMass,
    double? waterPercentage,
    bool isTarget = false,
  }) async {
    try {
      final record = WeightRecord(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        weight: weight,
        recordTime: recordTime ?? DateTime.now(),
        notes: notes,
        bodyFat: bodyFat ?? 0.0,
        muscleMass: muscleMass ?? 0.0,
        waterPercentage: waterPercentage ?? 0.0,
        isTarget: isTarget,
        createdAt: DateTime.now(),
      );

      await _repository.addRecord(record);
      await loadRecords();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateRecord(WeightRecord record) async {
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

  Future<void> addQuickRecord(double weight) async {
    await addRecord(weight: weight, isTarget: false);
  }

  Future<void> setTargetWeight(double targetWeight, {String? notes}) async {
    try {
      await _repository.setTargetWeight(targetWeight, notes: notes);
      await loadRecords();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> clearAllRecords() async {
    try {
      await _repository.clearAllRecords();
      await loadRecords();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

// 简化的体重显示Provider（用于简单的UI组件）
final simpleWeightProvider = Provider<String>((ref) {
  final latestWeight = ref.watch(latestWeightRecordProvider);
  return latestWeight.when(
    data: (record) =>
        record != null ? '${record.weight.toStringAsFixed(1)}kg' : '--kg',
    loading: () => '--kg',
    error: (_, __) => '--kg',
  );
});

// BMI显示Provider
final simpleBMIProvider = Provider<String>((ref) {
  final bmi = ref.watch(bmiProvider);
  return bmi.when(
    data: (value) => value != null ? value.toStringAsFixed(1) : '--',
    loading: () => '--',
    error: (_, __) => '--',
  );
});

// 体重变化显示Provider
final weightChangeDisplayProvider = Provider<String>((ref) {
  final change = ref.watch(weightChangeProvider);
  return change.when(
    data: (value) {
      if (value == null) return '--';
      final prefix = value > 0 ? '+' : '';
      return '$prefix${value.toStringAsFixed(1)}kg';
    },
    loading: () => '--',
    error: (_, __) => '--',
  );
});
