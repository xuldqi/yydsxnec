import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../models/fasting_plan.dart';
import '../models/fasting_session.dart';
import '../repositories/fasting_repository.dart';
import '../core/constants/app_constants.dart';
import '../services/notification_service.dart';
import '../services/widget_service.dart';

// Repository Provider
final fastingRepositoryProvider = Provider<FastingRepository>((ref) {
  return FastingRepository();
});

// 断食计划相关Providers
final fastingPlansProvider =
    StateNotifierProvider<FastingPlansNotifier, AsyncValue<List<FastingPlan>>>((
      ref,
    ) {
      return FastingPlansNotifier(ref.read(fastingRepositoryProvider));
    });

final currentFastingPlanProvider = StateProvider<FastingPlan?>((ref) => null);

// 断食会话相关Providers
final fastingSessionsProvider =
    StateNotifierProvider<
      FastingSessionsNotifier,
      AsyncValue<List<FastingSession>>
    >((ref) {
      return FastingSessionsNotifier(ref.read(fastingRepositoryProvider));
    });

final currentFastingSessionProvider = StateProvider<FastingSession?>(
  (ref) => null,
);

// 当前活跃的断食会话
final activeFastingSessionProvider = Provider<FastingSession?>((ref) {
  final sessions = ref.watch(fastingSessionsProvider);
  return sessions.when(
    data: (sessionList) {
      try {
        return sessionList.firstWhere(
          (session) => session.status == FastingStatus.active,
        );
      } catch (e) {
        return null;
      }
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

// 断食计划状态管理
class FastingPlansNotifier
    extends StateNotifier<AsyncValue<List<FastingPlan>>> {
  final FastingRepository _repository;

  FastingPlansNotifier(this._repository)
    : super(AsyncValue.data(FastingPlan.presetPlans)) {
    // 先立即返回预设方案，让应用能快速启动
    // 然后在后台异步加载数据库数据
    _loadPlansInBackground();
  }

  Future<void> _loadPlansInBackground() async {
    try {
      // 添加超时保护
      final plans = await _repository.getAllPlans().timeout(
        const Duration(seconds: 2),
        onTimeout: () {
          debugPrint('读取断食计划超时，继续使用预设方案');
          return <FastingPlan>[];
        },
      );

      // 如果有数据且与预设不同，更新状态
      if (plans.isNotEmpty && plans.length != FastingPlan.presetPlans.length) {
        state = AsyncValue.data(plans);
        return;
      }

      // 如果没有计划，尝试初始化预设方案（后台进行）
      if (plans.isEmpty) {
        try {
          await _repository.initializePresetPlans().timeout(
            const Duration(seconds: 1),
            onTimeout: () {
              debugPrint('初始化预设方案超时');
            },
          );
          final updatedPlans = await _repository.getAllPlans().timeout(
            const Duration(seconds: 1),
            onTimeout: () => <FastingPlan>[],
          );

          if (updatedPlans.isNotEmpty) {
            state = AsyncValue.data(updatedPlans);
          }
        } catch (e) {
          debugPrint('初始化预设方案失败: $e');
          // 保持使用预设方案
        }
      }
    } catch (error) {
      debugPrint('后台加载断食计划失败: $error');
      // 出错时保持使用预设方案，不影响用户体验
    }
  }

  Future<void> loadPlans() async {
    await _loadPlansInBackground();
  }

  void usePresetPlans() {
    state = AsyncValue.data(FastingPlan.presetPlans);
  }

  Future<void> addPlan(FastingPlan plan) async {
    try {
      await _repository.savePlan(plan);
      await loadPlans();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updatePlan(FastingPlan plan) async {
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

  Future<void> initializePresetPlans() async {
    try {
      await _repository.initializePresetPlans();
      await loadPlans();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

// 断食会话状态管理
class FastingSessionsNotifier
    extends StateNotifier<AsyncValue<List<FastingSession>>> {
  final FastingRepository _repository;

  FastingSessionsNotifier(this._repository)
    : super(const AsyncValue.loading()) {
    loadSessions();
  }

  Future<void> loadSessions() async {
    try {
      state = const AsyncValue.loading();
      final sessions = await _repository.getAllSessions();
      state = AsyncValue.data(sessions);

      // Sync with widget
      try {
        final activeSession = sessions.firstWhere(
          (s) => s.status == FastingStatus.active,
        );
        await WidgetService.updateFastingWidget(activeSession);
      } catch (e) {
        await WidgetService.updateFastingWidget(null);
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<String?> startFasting(
    FastingPlan plan, {
    DateTime? startTime,
    bool autoEndEnabled = false,
    bool isLowCalorieDay = false,
    double? calorieTarget,
  }) async {
    try {
      // 检查是否已有活跃断食
      final sessionsList = state.valueOrNull ?? <FastingSession>[];
      // 确保所有项都是 FastingSession 类型
      final sessions = sessionsList.whereType<FastingSession>().toList();
      try {
        final activeSession = sessions.firstWhere(
          (s) => s.status == FastingStatus.active,
        );

        if (activeSession.id.isNotEmpty) {
          return '已有正在进行的断食，请先结束当前断食';
        }
      } catch (e) {
        // 没有活跃断食，继续
      }

      final start = startTime ?? DateTime.now();
      DateTime? plannedEndTime;

      // 计算计划结束时间（特殊处理24小时断食和OMAD）
      if (!isLowCalorieDay) {
        if (plan.fastingHours > 0) {
          plannedEndTime = start.add(Duration(hours: plan.fastingHours));
        } else {
          // 如果没有断食时长，使用默认24小时
          plannedEndTime = start.add(const Duration(hours: 24));
        }
      }

      final session = FastingSession(
        id: start.millisecondsSinceEpoch.toString(),
        planId: plan.id,
        startTime: start,
        plannedEndTime: plannedEndTime,
        status: FastingStatus.active,
        fastingHours: isLowCalorieDay
            ? 0
            : (plan.fastingHours > 0 ? plan.fastingHours : 24),
        eatingHours: isLowCalorieDay ? 0 : plan.eatingHours,
        autoEndEnabled: autoEndEnabled && !isLowCalorieDay,
        isLowCalorieDay: isLowCalorieDay,
        calorieTarget: calorieTarget,
        createdAt: DateTime.now(),
      );

      await _repository.saveSession(session);

      // 发送通知
      final prefs = await SharedPreferences.getInstance();
      final notificationService = NotificationService();

      if (!isLowCalorieDay &&
          (prefs.getBool('notification_fasting_start') ?? true)) {
        await notificationService.notifyFastingStart(startTime: start);
      }

      // 安排结束提醒（只有有进食窗口的才提醒）
      if (!isLowCalorieDay &&
          plan.eatingHours > 0 &&
          (prefs.getBool('notification_fasting_end') ?? true)) {
        await notificationService.notifyFastingEnd(endTime: plannedEndTime!);
      }

      // 安排进食窗口开始提醒（只有有进食窗口的才提醒）
      if (!isLowCalorieDay &&
          plan.eatingHours > 0 &&
          (prefs.getBool('notification_eating_window') ?? true)) {
        await notificationService.notifyEatingWindowStart(
          windowStartTime: plannedEndTime!,
        );
      }

      await loadSessions();
      return null; // 成功
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return '开始断食失败: $error';
    }
  }

  Future<void> endFasting(
    String sessionId, {
    double? endWeight,
    int? difficultyRating,
    int? satisfactionRating,
    String? notes,
    String? mood,
  }) async {
    try {
      final sessions = state.value ?? [];
      final session = sessions.firstWhere((s) => s.id == sessionId);

      final updatedSession = session.copyWith(
        endTime: DateTime.now(),
        status: FastingStatus.completed,
        isCompleted: true,
        endWeight: endWeight ?? session.endWeight,
        difficultyRating: difficultyRating ?? session.difficultyRating,
        satisfactionRating: satisfactionRating ?? session.satisfactionRating,
        notes: notes ?? session.notes,
        mood: mood ?? session.mood,
        updatedAt: DateTime.now(),
      );

      // 清除相关通知
      final notificationService = NotificationService();
      await notificationService.clearFastingNotifications();

      await _repository.updateSession(updatedSession);
      await loadSessions();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> cancelFasting(String sessionId, {String? reason}) async {
    try {
      final sessions = state.value ?? [];
      final session = sessions.firstWhere((s) => s.id == sessionId);

      final updatedSession = session.copyWith(
        endTime: DateTime.now(),
        status: FastingStatus.cancelled,
        isCancelled: true,
        notes: reason ?? session.notes,
        updatedAt: DateTime.now(),
      );

      // 清除相关通知
      final notificationService = NotificationService();
      await notificationService.clearFastingNotifications();

      await _repository.updateSession(updatedSession);
      await loadSessions();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> pauseFasting(String sessionId) async {
    try {
      final sessions = state.value ?? [];
      final session = sessions.firstWhere((s) => s.id == sessionId);

      final updatedSession = session.copyWith(
        status: FastingStatus.paused,
        lastPauseTime: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _repository.updateSession(updatedSession);
      await loadSessions();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> resumeFasting(String sessionId) async {
    try {
      final sessions = state.value ?? [];
      final session = sessions.firstWhere((s) => s.id == sessionId);

      if (session.lastPauseTime != null) {
        final pauseDuration = DateTime.now()
            .difference(session.lastPauseTime!)
            .inMinutes;
        final updatedSession = session.copyWith(
          status: FastingStatus.active,
          totalPauseDuration: session.totalPauseDuration + pauseDuration,
          lastPauseTime: null,
          updatedAt: DateTime.now(),
        );

        await _repository.updateSession(updatedSession);
        await loadSessions();
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateSession(FastingSession session) async {
    try {
      await _repository.updateSession(session);
      await loadSessions();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteSession(String sessionId) async {
    try {
      await _repository.deleteSession(sessionId);
      await loadSessions();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addManualSession(FastingSession session) async {
    try {
      await _repository.saveSession(session);
      await loadSessions();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
