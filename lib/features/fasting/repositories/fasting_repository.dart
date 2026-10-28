import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'dart:async';
import '../models/fasting_plan.dart';
import '../models/fasting_session.dart';
import '../core/constants/app_constants.dart';

class FastingRepository {
  late Box<FastingPlan> _plansBox;
  late Box<FastingSession> _sessionsBox;
  bool _isInitialized = false;
  Future<void>? _initializing;

  Future<void> _ensureInitialized() async {
    if (_isInitialized) return;

    final currentInitialization = _initializing;
    if (currentInitialization != null) {
      await currentInitialization;
      return;
    }

    _initializing = _openBoxes();
    try {
      await _initializing;
    } finally {
      _initializing = null;
    }
  }

  Future<void> _openBoxes() async {
    try {
      // 添加超时保护，避免 Web 环境下卡死
      _plansBox = await _openBox<FastingPlan>(
        AppConstants.fastingPlanBox,
        '打开断食计划数据库超时',
      );
      _sessionsBox = await _openBox<FastingSession>(
        AppConstants.fastingSessionBox,
        '打开断食会话数据库超时',
      );
      _isInitialized = true;
    } catch (e) {
      debugPrint('Hive 数据库初始化失败: $e');
      // 如果失败，尝试清理后重新打开
      try {
        await Hive.deleteBoxFromDisk(AppConstants.fastingPlanBox);
        await Hive.deleteBoxFromDisk(AppConstants.fastingSessionBox);
      } catch (_) {}
      // 重新尝试打开
      _plansBox = await Hive.openBox<FastingPlan>(AppConstants.fastingPlanBox);
      _sessionsBox = await Hive.openBox<FastingSession>(
        AppConstants.fastingSessionBox,
      );
      _isInitialized = true;
    }
  }

  Future<Box<T>> _openBox<T>(String name, String timeoutMessage) {
    if (Hive.isBoxOpen(name)) {
      return Future.value(Hive.box<T>(name));
    }
    return Hive.openBox<T>(name).timeout(
      const Duration(seconds: 5),
      onTimeout: () => throw TimeoutException(timeoutMessage),
    );
  }

  // 断食计划相关方法
  Future<List<FastingPlan>> getAllPlans() async {
    await _ensureInitialized();
    final plans = <FastingPlan>[];

    // 安全读取，过滤掉类型错误的数据
    try {
      for (final key in _plansBox.keys) {
        try {
          final plan = _plansBox.get(key);
          if (plan != null && plan.isActive) {
            plans.add(plan);
          }
        } catch (e) {
          // 如果读取失败，删除损坏的数据
          debugPrint('Warning: 删除损坏的断食计划数据: $key, 错误: $e');
          try {
            await _plansBox.delete(key);
          } catch (_) {}
        }
      }
    } catch (e) {
      debugPrint('Warning: 读取断食计划时出错: $e');
      // 如果整个 box 读取失败，尝试清理并重新初始化
      try {
        await _plansBox.clear();
      } catch (_) {}
    }

    return plans;
  }

  Future<FastingPlan?> getPlanById(String id) async {
    await _ensureInitialized();
    return _plansBox.get(id);
  }

  Future<void> savePlan(FastingPlan plan) async {
    await _ensureInitialized();
    await _plansBox.put(plan.id, plan);
  }

  Future<void> updatePlan(FastingPlan plan) async {
    await _ensureInitialized();
    final updatedPlan = plan.copyWith(updatedAt: DateTime.now());
    await _plansBox.put(plan.id, updatedPlan);
  }

  Future<void> deletePlan(String planId) async {
    await _ensureInitialized();
    final plan = await getPlanById(planId);
    if (plan != null) {
      final updatedPlan = plan.copyWith(
        isActive: false,
        updatedAt: DateTime.now(),
      );
      await _plansBox.put(planId, updatedPlan);
    }
  }

  Future<void> initializePresetPlans() async {
    await _ensureInitialized();

    // 检查是否已经初始化过预设方案
    final existingPlans = await getAllPlans();
    final existingPresetIds = existingPlans
        .where((p) => !p.isCustom)
        .map((p) => p.id)
        .toSet();

    // 只添加不存在的预设方案
    for (final presetPlan in FastingPlan.presetPlans) {
      if (!existingPresetIds.contains(presetPlan.id)) {
        await savePlan(presetPlan);
      }
    }
  }

  Future<List<FastingPlan>> getPresetPlans() async {
    await _ensureInitialized();
    return _plansBox.values
        .where((plan) => !plan.isCustom && plan.isActive)
        .toList();
  }

  Future<List<FastingPlan>> getCustomPlans() async {
    await _ensureInitialized();
    return _plansBox.values
        .where((plan) => plan.isCustom && plan.isActive)
        .toList();
  }

  Future<List<FastingPlan>> getPlansByDifficulty(
    FastingDifficulty difficulty,
  ) async {
    await _ensureInitialized();
    return _plansBox.values
        .where((plan) => plan.difficulty == difficulty && plan.isActive)
        .toList();
  }

  // 断食会话相关方法
  Future<List<FastingSession>> getAllSessions() async {
    await _ensureInitialized();
    final List<FastingSession> sessions = [];

    try {
      // 遍历所有 key，逐个检查类型
      for (final key in _sessionsBox.keys) {
        try {
          final value = _sessionsBox.get(key);
          if (value is FastingSession) {
            sessions.add(value);
          } else {
            // 类型不匹配，删除这个 key
            debugPrint('Warning: 发现类型不匹配的会话数据 (key: $key)，已删除');
            await _sessionsBox.delete(key);
          }
        } catch (e) {
          // 单个 key 读取失败，删除它
          debugPrint('Warning: 读取会话数据时出错 (key: $key): $e，已删除');
          try {
            await _sessionsBox.delete(key);
          } catch (_) {}
        }
      }
    } catch (e) {
      debugPrint('Warning: 读取断食会话时出错: $e');
      // 如果整个 box 读取失败，尝试清理
      try {
        await _sessionsBox.clear();
      } catch (_) {}
    }

    sessions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sessions;
  }

  Future<FastingSession?> getSessionById(String id) async {
    await _ensureInitialized();
    return _sessionsBox.get(id);
  }

  Future<void> saveSession(FastingSession session) async {
    await _ensureInitialized();
    await _sessionsBox.put(session.id, session);
  }

  Future<void> updateSession(FastingSession session) async {
    await _ensureInitialized();
    final updatedSession = session.copyWith(updatedAt: DateTime.now());
    await _sessionsBox.put(session.id, updatedSession);
  }

  Future<void> deleteSession(String sessionId) async {
    await _ensureInitialized();
    await _sessionsBox.delete(sessionId);
  }

  Future<FastingSession?> getActiveSession() async {
    await _ensureInitialized();
    final sessions = _sessionsBox.values
        .where((session) => session.status == FastingStatus.active)
        .toList();
    return sessions.isNotEmpty ? sessions.first : null;
  }

  Future<List<FastingSession>> getSessionsByPlan(String planId) async {
    await _ensureInitialized();
    return _sessionsBox.values
        .where((session) => session.planId == planId)
        .toList();
  }

  Future<List<FastingSession>> getSessionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    await _ensureInitialized();
    return _sessionsBox.values
        .where(
          (session) =>
              session.startTime.isAfter(startDate) &&
              session.startTime.isBefore(endDate),
        )
        .toList();
  }

  Future<List<FastingSession>> getTodaySessions() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    return getSessionsByDateRange(startOfDay, endOfDay);
  }

  Future<List<FastingSession>> getWeekSessions() async {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfWeekDay = DateTime(
      startOfWeek.year,
      startOfWeek.month,
      startOfWeek.day,
    );
    final endOfWeek = startOfWeekDay.add(const Duration(days: 7));
    return getSessionsByDateRange(startOfWeekDay, endOfWeek);
  }

  Future<List<FastingSession>> getMonthSessions() async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 1);
    return getSessionsByDateRange(startOfMonth, endOfMonth);
  }

  // 统计相关方法
  Future<int> getTotalSessionsCount() async {
    await _ensureInitialized();
    return _sessionsBox.length;
  }

  Future<int> getCompletedSessionsCount() async {
    await _ensureInitialized();
    return _sessionsBox.values
        .where((session) => session.status == FastingStatus.completed)
        .length;
  }

  Future<double> getAverageSuccessRate() async {
    await _ensureInitialized();
    final completedSessions = _sessionsBox.values
        .where((session) => session.status == FastingStatus.completed)
        .toList();

    if (completedSessions.isEmpty) return 0.0;

    final totalSuccessRate = completedSessions
        .map((session) => session.successRate)
        .reduce((a, b) => a + b);

    return totalSuccessRate / completedSessions.length;
  }

  Future<Duration> getTotalFastingTime() async {
    await _ensureInitialized();
    final completedSessions = _sessionsBox.values
        .where((session) => session.status == FastingStatus.completed)
        .toList();

    int totalMinutes = 0;
    for (final session in completedSessions) {
      totalMinutes += session.actualFastingDurationMinutes;
    }

    return Duration(minutes: totalMinutes);
  }

  Future<Map<FastingDifficulty, int>> getSessionCountByDifficulty() async {
    await _ensureInitialized();
    final sessions = await getAllSessions();
    final result = <FastingDifficulty, int>{};

    for (final difficulty in FastingDifficulty.values) {
      result[difficulty] = 0;
    }

    for (final session in sessions) {
      final plan = await getPlanById(session.planId);
      if (plan != null) {
        result[plan.difficulty] = (result[plan.difficulty] ?? 0) + 1;
      }
    }

    return result;
  }

  // 清理数据
  Future<void> clearAllData() async {
    await _ensureInitialized();
    await _plansBox.clear();
    await _sessionsBox.clear();
  }

  Future<void> clearSessions() async {
    await _ensureInitialized();
    await _sessionsBox.clear();
  }

  // 关闭数据库
  Future<void> close() async {
    if (_isInitialized) {
      await _plansBox.close();
      await _sessionsBox.close();
      _isInitialized = false;
    }
  }
}
