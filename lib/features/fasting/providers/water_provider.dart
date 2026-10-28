import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/water_record.dart';
import '../repositories/water_repository.dart';
import '../core/constants/app_constants.dart';

// Water Repository Provider
final waterRepositoryProvider = Provider<WaterRepository>((ref) {
  final repository = WaterRepository();
  // 异步初始化，不阻塞
  repository.init().catchError((e) {
    debugPrint('水分记录数据库初始化失败: $e');
  });
  return repository;
});

// 水分记录列表Provider
final waterRecordsProvider =
    StateNotifierProvider<WaterRecordsNotifier, AsyncValue<List<WaterRecord>>>((
      ref,
    ) {
      return WaterRecordsNotifier(ref.read(waterRepositoryProvider));
    });

// 今日水分记录Provider
final todayWaterRecordsProvider = Provider<AsyncValue<List<WaterRecord>>>((
  ref,
) {
  final records = ref.watch(waterRecordsProvider);
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

// 今日总饮水量Provider
final todayWaterTotalProvider = Provider<AsyncValue<int>>((ref) {
  final todayRecords = ref.watch(todayWaterRecordsProvider);
  return todayRecords.when(
    data: (records) {
      final total = records.fold(
        0,
        (sum, record) => sum + record.amount.round(),
      );
      return AsyncValue.data(total);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

// 推荐饮水量Provider
final recommendedWaterAmountProvider = Provider<int>((ref) {
  // TODO: 从用户设置或体重记录中获取真实数据
  final repository = ref.read(waterRepositoryProvider);
  return repository.getRecommendedDailyAmount();
});

// 饮水进度Provider
final waterProgressProvider = Provider<AsyncValue<double>>((ref) {
  final totalAsync = ref.watch(todayWaterTotalProvider);
  final recommended = ref.watch(recommendedWaterAmountProvider);

  return totalAsync.when(
    data: (total) {
      final progress = total / recommended.toDouble();
      return AsyncValue.data(progress.clamp(0.0, 1.0));
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

// 水分记录状态管理
class WaterRecordsNotifier
    extends StateNotifier<AsyncValue<List<WaterRecord>>> {
  final WaterRepository _repository;

  WaterRecordsNotifier(this._repository) : super(const AsyncValue.loading()) {
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
    required double amount,
    required WaterType type,
    DateTime? recordTime,
    String? notes,
    double? temperature,
    bool isReminder = false,
  }) async {
    try {
      final record = WaterRecord(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        amount: amount,
        type: type,
        recordTime: recordTime ?? DateTime.now(),
        notes: notes,
        temperature: temperature ?? 0.0,
        isReminder: isReminder,
        createdAt: DateTime.now(),
      );

      await _repository.addRecord(record);
      await loadRecords();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateRecord(WaterRecord record) async {
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

  Future<void> addQuickRecord(int amount) async {
    await addRecord(
      amount: amount.toDouble(),
      type: WaterType.water,
      isReminder: false,
    );
  }

  Future<void> clearTodayRecords() async {
    try {
      final records = state.value ?? [];
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final todayRecords = records.where((record) {
        return record.recordTime.isAfter(startOfDay) &&
            record.recordTime.isBefore(endOfDay);
      });

      for (final record in todayRecords) {
        await _repository.deleteRecord(record.id);
      }

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
