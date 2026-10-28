import 'package:hive_flutter/hive_flutter.dart';
import '../models/week_plan.dart';

class WeekPlanRepository {
  Box<WeekPlan>? _weekPlanBox;
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    _weekPlanBox = await Hive.openBox<WeekPlan>('week_plans');
    _isInitialized = true;
  }

  Future<void> savePlan(WeekPlan plan) async {
    if (!_isInitialized) return;
    await _weekPlanBox!.put(plan.id, plan);
  }

  Future<void> updatePlan(WeekPlan plan) async {
    if (!_isInitialized) return;
    final updatedPlan = plan.copyWith(updatedAt: DateTime.now());
    await _weekPlanBox!.put(plan.id, updatedPlan);
  }

  Future<void> deletePlan(String planId) async {
    if (!_isInitialized) return;
    await _weekPlanBox!.delete(planId);
  }

  Future<List<WeekPlan>> getAllPlans() async {
    if (!_isInitialized) return [];
    final plans = _weekPlanBox!.values.toList();
    plans.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return plans;
  }

  Future<WeekPlan?> getPlanById(String id) async {
    if (!_isInitialized) return null;
    return _weekPlanBox!.get(id);
  }

  Future<WeekPlan?> getActivePlan() async {
    if (!_isInitialized) return null;
    final activePlans = _weekPlanBox!.values
        .where((plan) => plan.isActive)
        .toList();
    return activePlans.isNotEmpty ? activePlans.first : null;
  }

  Future<void> deactivateAllPlans() async {
    if (!_isInitialized) return;
    final allPlans = _weekPlanBox!.values.toList();
    for (final plan in allPlans) {
      await updatePlan(plan.copyWith(isActive: false));
    }
  }

  Future<void> setActivePlan(String planId) async {
    if (!_isInitialized) return;
    await deactivateAllPlans();
    final plan = await getPlanById(planId);
    if (plan != null) {
      await updatePlan(plan.copyWith(isActive: true));
    }
  }

  Future<void> clearAllPlans() async {
    if (!_isInitialized) return;
    await _weekPlanBox!.clear();
  }
}
