import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/suggestion.dart';
import '../models/fasting_session.dart';
import '../models/fasting_plan.dart';
import '../models/weight_record.dart';
import '../models/water_record.dart';
import '../models/food_record.dart';
import '../models/exercise_record.dart';
import '../models/user_profile.dart';
import '../core/constants/app_constants.dart';
import '../repositories/suggestion_repository.dart';
import '../providers/fasting_provider.dart';
import '../providers/weight_provider.dart';
import '../providers/water_provider.dart';
import '../providers/food_record_provider.dart';
import '../providers/exercise_provider.dart';
import '../providers/user_settings_provider.dart';

// Repository Provider
final suggestionRepositoryProvider = Provider<SuggestionRepository>((ref) {
  final repository = SuggestionRepository();
  repository.init().catchError((e) {
    debugPrint('建议数据库初始化失败: $e');
  });
  return repository;
});

// 智能建议Provider
final suggestionsProvider =
    StateNotifierProvider<SuggestionsNotifier, AsyncValue<List<Suggestion>>>((
      ref,
    ) {
      return SuggestionsNotifier(ref, ref.read(suggestionRepositoryProvider));
    });

// 最新建议Provider（显示在首页）
final latestSuggestionProvider = Provider<Suggestion?>((ref) {
  final suggestions = ref.watch(suggestionsProvider);
  return suggestions.when(
    data: (list) {
      if (list.isEmpty) return null;
      final unread = list.where((s) => !s.isRead).toList();
      if (unread.isEmpty) return null;
      unread.sort((a, b) => b.priority.index.compareTo(a.priority.index));
      return unread.first;
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

// 建议分析引擎
class SuggestionAnalysisEngine {
  static Future<List<Suggestion>> analyzeHealthData({
    required List<FastingSession> sessions,
    required List<WeightRecord> weightRecords,
    required List<WaterRecord> waterRecords,
    required FastingPlan? currentPlan,
    required List<FoodRecord> todayFoodRecords,
    required List<ExerciseRecord> todayExerciseRecords,
    required UserProfile? userProfile,
  }) async {
    final suggestions = <Suggestion>[];
    final now = DateTime.now();

    suggestions.addAll(_analyzeFastingPlan(sessions, currentPlan, now));
    suggestions.addAll(
      _analyzeWaterIntake(
        waterRecords,
        weightRecords,
        now,
        userProfile: userProfile,
        todayExerciseMinutes: _calculateTodayExerciseMinutes(
          todayExerciseRecords,
          now,
        ),
      ),
    );
    suggestions.addAll(
      _analyzeWeightManagement(weightRecords, now, userProfile: userProfile),
    );
    suggestions.addAll(_analyzeEatingWindow(sessions, now));
    suggestions.addAll(
      _analyzeHealthRisks(weightRecords, waterRecords, sessions, now),
    );
    suggestions.addAll(
      _analyzeLifestyleBalance(
        weightRecords: weightRecords,
        todayFoodRecords: todayFoodRecords,
        todayExerciseRecords: todayExerciseRecords,
        userProfile: userProfile,
        now: now,
      ),
    );

    suggestions.sort((a, b) => b.priority.index.compareTo(a.priority.index));
    return suggestions;
  }

  static List<Suggestion> _analyzeFastingPlan(
    List<FastingSession> sessions,
    FastingPlan? currentPlan,
    DateTime now,
  ) {
    final suggestions = <Suggestion>[];

    if (sessions.isEmpty) {
      suggestions.add(
        Suggestion(
          id: 'suggestion_beginner_tip',
          type: SuggestionType.fastingPlan,
          title: '开始您的轻断食之旅',
          content: '建议从16:8断食方案开始，这是最适合初学者的方案。16小时断食，8小时进食窗口，既容易坚持又能获得良好效果。',
          priority: SuggestionPriority.high,
          scientificBasis: '16:8是研究最充分的轻断食方案之一，安全性高且易于坚持',
          actionItems: ['尝试16:8断食方案', '在8小时窗口内正常进食', '保持充足睡眠'],
          expiresAt: now.add(const Duration(days: 7)),
          createdAt: now,
        ),
      );
      return suggestions;
    }

    final completedSessions = sessions
        .where((s) => s.status == FastingStatus.completed)
        .toList();
    if (completedSessions.isEmpty) return suggestions;

    final successRate =
        completedSessions.map((s) => s.successRate).reduce((a, b) => a + b) /
        completedSessions.length;

    if (successRate < 0.7 && currentPlan != null) {
      final currentDifficulty = currentPlan.difficulty;
      if (currentDifficulty == FastingDifficulty.intermediate) {
        suggestions.add(
          Suggestion(
            id: 'suggestion_lower_difficulty',
            type: SuggestionType.fastingPlan,
            title: '建议降低断食难度',
            content:
                '您当前的断食成功率较低（${(successRate * 100).toStringAsFixed(0)}%），建议先尝试入门级方案，如16:8或14:10，等适应后再逐步提升难度。',
            priority: SuggestionPriority.high,
            scientificBasis: '循序渐进的断食方式更容易坚持并获得长期效果',
            actionItems: ['尝试16:8入门方案', '记录每次断食感受', '逐步增加断食时长'],
            expiresAt: now.add(const Duration(days: 7)),
            createdAt: now,
          ),
        );
      }
    }

    if (successRate >= 0.85 && completedSessions.length >= 5) {
      final currentDifficulty =
          currentPlan?.difficulty ?? FastingDifficulty.beginner;
      if (currentDifficulty == FastingDifficulty.beginner) {
        suggestions.add(
          Suggestion(
            id: 'suggestion_higher_difficulty',
            type: SuggestionType.fastingPlan,
            title: '恭喜！您可以尝试更高难度',
            content:
                '您的断食成功率很高（${(successRate * 100).toStringAsFixed(0)}%），并且已成功完成${completedSessions.length}次。建议尝试中级方案，如18:6或20:4，以获得更好的效果。',
            priority: SuggestionPriority.medium,
            scientificBasis: '当身体适应轻断食后，适当增加断食时长可以带来更多健康益处',
            actionItems: ['尝试18:6中级方案', '注意身体反应', '继续保持良好习惯'],
            expiresAt: now.add(const Duration(days: 7)),
            createdAt: now,
          ),
        );
      }
    }

    return suggestions;
  }

  static List<Suggestion> _analyzeWaterIntake(
    List<WaterRecord> waterRecords,
    List<WeightRecord> weightRecords,
    DateTime now, {
    UserProfile? userProfile,
    int? todayExerciseMinutes,
  }) {
    final suggestions = <Suggestion>[];

    if (weightRecords.isEmpty) return suggestions;

    final today = DateTime(now.year, now.month, now.day);
    final todayWaterRecords = waterRecords
        .where(
          (r) =>
              r.recordTime.year == today.year &&
              r.recordTime.month == today.month &&
              r.recordTime.day == today.day,
        )
        .toList();

    final todayTotal = todayWaterRecords.fold<double>(
      0.0,
      (sum, r) => sum + r.amount,
    );

    double? weight = userProfile?.targetWeightKg;
    if (weight == null || weight <= 0) {
      weight = weightRecords.last.weight;
    }

    var recommendedAmount = (weight * 35).clamp(1500.0, 3500.0);

    if (todayExerciseMinutes != null && todayExerciseMinutes > 0) {
      final extra = (todayExerciseMinutes / 30 * 250).round();
      recommendedAmount += extra;
    }

    if (todayTotal < recommendedAmount * 0.7) {
      suggestions.add(
        Suggestion(
          id: 'suggestion_drink_water',
          type: SuggestionType.waterIntake,
          title: '记得多喝水',
          content:
              '您今日饮水量（${todayTotal.toStringAsFixed(0)}ml）还未达到推荐值（${recommendedAmount.toStringAsFixed(0)}ml）。充足的水分有助于新陈代谢和断食效果。',
          priority: SuggestionPriority.medium,
          scientificBasis: '充足的水分摄入有助于维持新陈代谢、支持身体功能和减轻饥饿感',
          actionItems: ['设置饮水提醒', '每次记录饮水', '携带水杯'],
          expiresAt: DateTime(now.year, now.month, now.day + 1),
          createdAt: now,
        ),
      );
    } else if (todayTotal >= recommendedAmount * 0.9) {
      suggestions.add(
        Suggestion(
          id: 'suggestion_good_water_habit',
          type: SuggestionType.waterIntake,
          title: '饮水习惯良好！',
          content: '您今日的饮水量（${todayTotal.toStringAsFixed(0)}ml）已达到推荐标准，继续保持！',
          priority: SuggestionPriority.low,
          expiresAt: DateTime(now.year, now.month, now.day + 1),
          createdAt: now,
        ),
      );
    }

    return suggestions;
  }

  static List<Suggestion> _analyzeWeightManagement(
    List<WeightRecord> records,
    DateTime now, {
    UserProfile? userProfile,
  }) {
    final suggestions = <Suggestion>[];

    if (records.length < 2) return suggestions;

    final recentRecords = records
        .where(
          (r) => r.recordTime.isAfter(now.subtract(const Duration(days: 7))),
        )
        .toList();

    if (recentRecords.length < 2) return suggestions;

    recentRecords.sort((a, b) => a.recordTime.compareTo(b.recordTime));
    final oldest = recentRecords.first.weight;
    final newest = recentRecords.last.weight;
    final change = newest - oldest;

    if (change < -2.0) {
      suggestions.add(
        Suggestion(
          id: 'suggestion_weight_drop_fast',
          type: SuggestionType.weightManagement,
          title: '体重下降较快',
          content:
              '您最近一周体重下降了${(-change).toStringAsFixed(1)}kg。建议保持匀速减重（每周0.5-1kg），过快可能导致肌肉流失和代谢下降。',
          priority: SuggestionPriority.high,
          scientificBasis: '健康的减重速度是每周0.5-1kg，过快减重可能影响健康',
          actionItems: ['保持均衡饮食', '适量运动', '保证充足睡眠'],
          expiresAt: now.add(const Duration(days: 7)),
          createdAt: now,
        ),
      );
    } else if (change > 1.0) {
      suggestions.add(
        Suggestion(
          id: 'suggestion_weight_gain',
          type: SuggestionType.weightManagement,
          title: '注意体重变化',
          content:
              '您最近一周体重上升了${change.toStringAsFixed(1)}kg。建议检查饮食和运动情况，保持健康的体重管理。',
          priority: SuggestionPriority.medium,
          actionItems: ['回顾饮食记录', '增加运动量', '坚持断食计划'],
          expiresAt: now.add(const Duration(days: 7)),
          createdAt: now,
        ),
      );
    }

    if (userProfile?.targetWeightKg != null && recentRecords.isNotEmpty) {
      final target = userProfile!.targetWeightKg!;
      final current = newest;
      final diff = current - target;

      if (diff > 3.0) {
        suggestions.add(
          Suggestion(
            id: 'suggestion_weight_target',
            type: SuggestionType.weightManagement,
            title: '离目标体重还有一些距离',
            content:
                '您当前体重约为 ${current.toStringAsFixed(1)}kg，与目标体重 ${target.toStringAsFixed(1)}kg 相差约 ${diff.toStringAsFixed(1)}kg。'
                '建议结合轻断食、饮食控制和适量运动，循序渐进地接近目标。',
            priority: SuggestionPriority.medium,
            actionItems: ['设定每周小目标', '记录每日体重', '保持适度运动'],
            expiresAt: now.add(const Duration(days: 7)),
            createdAt: now,
          ),
        );
      }
    }

    return suggestions;
  }

  static List<Suggestion> _analyzeEatingWindow(
    List<FastingSession> sessions,
    DateTime now,
  ) {
    final suggestions = <Suggestion>[];

    if (sessions.isEmpty) return suggestions;

    final completedSessions = sessions
        .where(
          (s) => s.status == FastingStatus.completed && s.successRate >= 0.8,
        )
        .toList();

    if (completedSessions.length >= 3) {
      final eatingWindowStarts = completedSessions.map((s) {
        if (s.plannedEndTime != null) {
          return s.plannedEndTime!
              .subtract(Duration(hours: s.eatingHours))
              .hour;
        }
        return 12;
      }).toList();

      final mostCommonHour = eatingWindowStarts
          .fold<Map<int, int>>(<int, int>{}, (map, hour) {
            map[hour] = (map[hour] ?? 0) + 1;
            return map;
          })
          .entries
          .reduce((a, b) => a.value > b.value ? a : b)
          .key;

      suggestions.add(
        Suggestion(
          id: 'suggestion_eating_window',
          type: SuggestionType.eatingWindow,
          title: '找到适合您的进食时间',
          content:
              '根据您的断食记录，在$mostCommonHour:00开始进食窗口的成功率最高。建议保持这个时间段，有助于形成稳定的生物钟。',
          priority: SuggestionPriority.low,
          scientificBasis: '规律的进食时间有助于调节生物钟和新陈代谢',
          actionItems: ['保持$mostCommonHour:00进食窗口', '规律作息', '记录感受'],
          expiresAt: now.add(const Duration(days: 7)),
          createdAt: now,
        ),
      );
    }

    return suggestions;
  }

  static List<Suggestion> _analyzeHealthRisks(
    List<WeightRecord> weightRecords,
    List<WaterRecord> waterRecords,
    List<FastingSession> sessions,
    DateTime now,
  ) {
    final suggestions = <Suggestion>[];

    if (weightRecords.isNotEmpty) {
      final latestWeight = weightRecords.last;
      final daysSinceLastRecord = now
          .difference(latestWeight.recordTime)
          .inDays;

      if (daysSinceLastRecord > 7) {
        suggestions.add(
          Suggestion(
            id: 'suggestion_no_weight_record',
            type: SuggestionType.healthRisk,
            title: '建议定期记录体重',
            content: '您已有$daysSinceLastRecord天未记录体重。定期记录有助于追踪健康和调整计划。',
            priority: SuggestionPriority.low,
            actionItems: ['今天记录一次体重', '设定定期提醒'],
            expiresAt: now.add(const Duration(days: 7)),
            createdAt: now,
          ),
        );
      }
    }

    return suggestions;
  }

  static int _calculateTodayExerciseMinutes(
    List<ExerciseRecord> records,
    DateTime now,
  ) {
    if (records.isEmpty) return 0;
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final todayRecords = records.where((r) {
      return r.recordTime.isAfter(startOfDay) &&
          r.recordTime.isBefore(endOfDay);
    });

    return todayRecords.fold<int>(0, (sum, r) => sum + r.durationMinutes);
  }

  static List<Suggestion> _analyzeLifestyleBalance({
    required List<WeightRecord> weightRecords,
    required List<FoodRecord> todayFoodRecords,
    required List<ExerciseRecord> todayExerciseRecords,
    required UserProfile? userProfile,
    required DateTime now,
  }) {
    final suggestions = <Suggestion>[];

    if (todayFoodRecords.isEmpty && todayExerciseRecords.isEmpty) {
      suggestions.add(
        Suggestion(
          id: 'suggestion_record_diet',
          type: SuggestionType.healthRisk,
          title: '试着记录一下今天的饮食和运动',
          content: '还没有看到您今天的饮食和运动记录。记录数据可以帮助更好地分析断食效果和健康趋势。',
          priority: SuggestionPriority.low,
          actionItems: ['记录今天的第一顿餐食', '记录一次运动或步行'],
          expiresAt: DateTime(now.year, now.month, now.day + 1),
          createdAt: now,
        ),
      );
      return suggestions;
    }

    final todayCalories = todayFoodRecords.fold<double>(
      0.0,
      (sum, r) => sum + r.totalCalories,
    );
    final todayExerciseMinutes = _calculateTodayExerciseMinutes(
      todayExerciseRecords,
      now,
    );

    if (todayCalories > 0 && todayExerciseMinutes >= 0) {
      if (todayCalories > 2200 && todayExerciseMinutes < 20) {
        suggestions.add(
          Suggestion(
            id: 'suggestion_low_activity',
            type: SuggestionType.healthRisk,
            title: '今天的活动有点少',
            content:
                '根据记录，您今天的摄入热量约为 ${todayCalories.toStringAsFixed(0)} kcal，运动时间少于 20 分钟。'
                '建议适当增加一些轻度活动（如快走、伸展），帮助维持能量平衡。',
            priority: SuggestionPriority.medium,
            actionItems: ['晚间散步 15-30 分钟', '选择低糖零食', '多喝水'],
            expiresAt: DateTime(now.year, now.month, now.day + 1),
            createdAt: now,
          ),
        );
      }

      if (todayCalories < 1200 && todayExerciseMinutes > 40) {
        suggestions.add(
          Suggestion(
            id: 'suggestion_over_diet',
            type: SuggestionType.healthRisk,
            title: '注意不要过度节食',
            content:
                '您今天的摄入热量偏低（约 ${todayCalories.toStringAsFixed(0)} kcal），'
                '同时运动时间超过 40 分钟。建议适当补充优质蛋白和蔬菜，避免过度节食带来的疲劳感。',
            priority: SuggestionPriority.high,
            actionItems: ['在进食窗口补充一顿均衡餐食', '关注身体疲劳信号'],
            expiresAt: DateTime(now.year, now.month, now.day + 1),
            createdAt: now,
          ),
        );
      }
    }

    return suggestions;
  }
}

// 建议状态管理
class SuggestionsNotifier extends StateNotifier<AsyncValue<List<Suggestion>>> {
  final Ref _ref;
  final SuggestionRepository _repository;

  SuggestionsNotifier(this._ref, this._repository)
    : super(const AsyncValue.loading()) {
    _loadSuggestions();
  }

  Future<void> _loadSuggestions() async {
    try {
      state = const AsyncValue.loading();

      // 1. 先加载 Hive 中的历史建议
      final existingSuggestions = _repository.getAll();

      // 2. 获取用户数据生成新建议
      final sessionsAsync = _ref.read(fastingSessionsProvider);
      final weightRecordsAsync = _ref.read(weightRecordsProvider);
      final waterRecordsAsync = _ref.read(waterRecordsProvider);
      final foodRecordsAsync = _ref.read(todayFoodRecordsProvider);
      final exerciseRecordsAsync = _ref.read(todayExerciseRecordsProvider);
      final userProfileAsync = _ref.read(userProfileProvider);
      final plansAsync = _ref.read(fastingPlansProvider);
      final activeSession = _ref.read(activeFastingSessionProvider);

      final sessions = await sessionsAsync.when(
        data: (data) => Future.value(data),
        loading: () => Future.value(<FastingSession>[]),
        error: (_, __) => Future.value(<FastingSession>[]),
      );
      final weightRecords = await weightRecordsAsync.when(
        data: (data) => Future.value(data),
        loading: () => Future.value(<WeightRecord>[]),
        error: (_, __) => Future.value(<WeightRecord>[]),
      );
      final waterRecords = await waterRecordsAsync.when(
        data: (data) => Future.value(data),
        loading: () => Future.value(<WaterRecord>[]),
        error: (_, __) => Future.value(<WaterRecord>[]),
      );
      final todayFoodRecords = await foodRecordsAsync.when(
        data: (data) => Future.value(data),
        loading: () => Future.value(<FoodRecord>[]),
        error: (_, __) => Future.value(<FoodRecord>[]),
      );
      final todayExerciseRecords = await exerciseRecordsAsync.when(
        data: (data) => Future.value(data),
        loading: () => Future.value(<ExerciseRecord>[]),
        error: (_, __) => Future.value(<ExerciseRecord>[]),
      );
      final userProfile = await userProfileAsync.when(
        data: (profile) => Future.value(profile),
        loading: () => Future.value(null),
        error: (_, __) => Future.value(null),
      );
      final plans = await plansAsync.when(
        data: (data) => Future.value(data),
        loading: () => Future.value(<FastingPlan>[]),
        error: (_, __) => Future.value(<FastingPlan>[]),
      );

      FastingPlan? currentPlan;
      if (activeSession != null) {
        currentPlan = plans.firstWhere(
          (p) => p.id == activeSession.planId,
          orElse: () =>
              plans.isNotEmpty ? plans.first : FastingPlan.presetPlans.first,
        );
      }

      // 3. 生成新建议
      final freshSuggestions = await SuggestionAnalysisEngine.analyzeHealthData(
        sessions: sessions,
        weightRecords: weightRecords,
        waterRecords: waterRecords,
        currentPlan: currentPlan,
        todayFoodRecords: todayFoodRecords,
        todayExerciseRecords: todayExerciseRecords,
        userProfile: userProfile,
      );

      // 4. 合并：保留用户交互状态，替换过期内容
      final existingById = <String, Suggestion>{};
      for (final s in existingSuggestions) {
        existingById[s.id] = s;
      }

      final merged = <Suggestion>[];
      for (final fresh in freshSuggestions) {
        final existing = existingById[fresh.id];
        if (existing != null && (existing.isAdopted || existing.isIgnored)) {
          merged.add(existing);
        } else {
          merged.add(fresh);
        }
        existingById.remove(fresh.id);
      }

      // 保留用户已采纳/忽略但本次未生成的建议（不过期的）
      for (final s in existingById.values) {
        if (s.isAdopted || s.isIgnored) {
          if (s.expiresAt == null || DateTime.now().isBefore(s.expiresAt!)) {
            merged.add(s);
          }
        }
      }

      // 5. 过滤过期
      final validSuggestions = merged.where((s) {
        if (s.expiresAt == null) return true;
        return DateTime.now().isBefore(s.expiresAt!);
      }).toList();

      // 6. 持久化
      await _repository.clear();
      await _repository.saveAll(validSuggestions);

      state = AsyncValue.data(validSuggestions);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refresh() async {
    await _loadSuggestions();
  }

  Future<void> markAsRead(String suggestionId) async {
    final current = state.value ?? [];
    final updated = current.map((s) {
      if (s.id == suggestionId) {
        return s.copyWith(isRead: true);
      }
      return s;
    }).toList();
    state = AsyncValue.data(updated);
    final found = current.where((s) => s.id == suggestionId).firstOrNull;
    if (found != null) {
      await _repository.save(found.copyWith(isRead: true));
    }
  }

  Future<void> markAsAdopted(String suggestionId) async {
    final current = state.value ?? [];
    Suggestion? adopted;
    final updated = current.map((s) {
      if (s.id == suggestionId) {
        adopted = s.copyWith(
          isAdopted: true,
          adoptedAt: DateTime.now(),
          isRead: true,
        );
        return adopted!;
      }
      return s;
    }).toList();
    state = AsyncValue.data(updated);
    final result = adopted;
    if (result != null) {
      await _repository.save(result);
    }
  }

  Future<void> markAsIgnored(String suggestionId) async {
    final current = state.value ?? [];
    Suggestion? ignored;
    final updated = current.map((s) {
      if (s.id == suggestionId) {
        ignored = s.copyWith(
          isIgnored: true,
          ignoredAt: DateTime.now(),
          isRead: true,
        );
        return ignored!;
      }
      return s;
    }).toList();
    state = AsyncValue.data(updated);
    final result = ignored;
    if (result != null) {
      await _repository.save(result);
    }
  }
}
