import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/week_plan.dart';
import '../repositories/week_plan_repository.dart';

// Week Plan Repository Provider
final weekPlanRepositoryProvider = Provider<WeekPlanRepository>((ref) {
  final repository = WeekPlanRepository();
  // 异步初始化，不阻塞
  repository.init().catchError((e) {
    debugPrint('周计划数据库初始化失败: $e');
  });
  return repository;
});

// 周计划列表Provider
final weekPlansProvider =
    StateNotifierProvider<WeekPlansNotifier, AsyncValue<List<WeekPlan>>>((ref) {
      return WeekPlansNotifier(ref.read(weekPlanRepositoryProvider));
    });

// 当前活跃的周计划Provider
final activeWeekPlanProvider = Provider<AsyncValue<WeekPlan?>>((ref) {
  final plans = ref.watch(weekPlansProvider);
  return plans.when(
    data: (planList) {
      final activePlan = planList.where((plan) => plan.isActive).firstOrNull;
      return AsyncValue.data(activePlan);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

// 今日是否需要断食（根据周计划）
final shouldFastTodayProvider = Provider<AsyncValue<bool>>((ref) {
  final activePlan = ref.watch(activeWeekPlanProvider);
  return activePlan.when(
    data: (plan) {
      if (plan == null) {
        return const AsyncValue.data(true); // 没有周计划时，默认可以断食
      }

      final today = DateTime.now();
      final weekday = today.weekday; // 1=周一, 7=周日
      final needFast =
          plan.shouldFastOnDay(weekday) || plan.isLowCalDay(weekday);
      return AsyncValue.data(needFast);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

// 周计划状态管理
class WeekPlansNotifier extends StateNotifier<AsyncValue<List<WeekPlan>>> {
  final WeekPlanRepository _repository;

  WeekPlansNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadPlans();
  }

  Future<void> loadPlans() async {
    try {
      state = const AsyncValue.loading();
      final plans = await _repository.getAllPlans();
      state = AsyncValue.data(plans);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addPlan(WeekPlan plan) async {
    try {
      await _repository.savePlan(plan);
      await loadPlans();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updatePlan(WeekPlan plan) async {
    try {
      await _repository.updatePlan(plan);
      await loadPlans();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deletePlan(String planId) async {
    try {
      await _repository.deletePlan(planId);
      await loadPlans();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> setActivePlan(String planId) async {
    try {
      await _repository.setActivePlan(planId);
      await loadPlans();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
