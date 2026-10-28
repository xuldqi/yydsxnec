import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/achievement.dart';
import '../repositories/achievement_repository.dart';

// Achievement Repository Provider
final achievementRepositoryProvider = Provider<AchievementRepository>((ref) {
  final repository = AchievementRepository();
  // 异步初始化，不阻塞
  repository.init().catchError((e) {
    debugPrint('成就数据库初始化失败: $e');
  });
  return repository;
});

// 成就列表Provider
final achievementsProvider =
    StateNotifierProvider<AchievementsNotifier, AsyncValue<List<Achievement>>>((
      ref,
    ) {
      return AchievementsNotifier(ref.read(achievementRepositoryProvider));
    });

// 已解锁成就Provider
final unlockedAchievementsProvider = Provider<AsyncValue<List<Achievement>>>((
  ref,
) {
  final achievements = ref.watch(achievementsProvider);
  return achievements.when(
    data: (list) {
      final unlocked = list.where((a) => a.isUnlocked).toList();
      return AsyncValue.data(unlocked);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

// 成就统计Provider
final achievementStatsProvider = Provider<AsyncValue<Map<String, dynamic>>>((
  ref,
) {
  final achievements = ref.watch(achievementsProvider);
  return achievements.when(
    data: (list) {
      final total = list.length;
      final unlocked = list.where((a) => a.isUnlocked).length;
      final locked = total - unlocked;

      final byRarity = <AchievementRarity, int>{};
      for (final rarity in AchievementRarity.values) {
        byRarity[rarity] = list
            .where((a) => a.rarity == rarity && a.isUnlocked)
            .length;
      }

      return AsyncValue.data({
        'total': total,
        'unlocked': unlocked,
        'locked': locked,
        'progress': total > 0 ? unlocked / total : 0.0,
        'byRarity': byRarity,
      });
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

// 成就状态管理
class AchievementsNotifier
    extends StateNotifier<AsyncValue<List<Achievement>>> {
  final AchievementRepository _repository;

  AchievementsNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadAchievements();
  }

  Future<void> loadAchievements() async {
    try {
      state = const AsyncValue.loading();
      final achievements = await _repository.getAllAchievements();
      state = AsyncValue.data(achievements);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> unlockAchievement(String id) async {
    try {
      await _repository.unlockAchievement(id);
      await loadAchievements();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateProgress(String id, int currentValue) async {
    try {
      await _repository.updateAchievementProgress(id, currentValue);
      await loadAchievements();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

// 检查并更新成就进度（基于用户数据）
class AchievementChecker {
  static Future<void> checkFastingAchievements(
    AchievementRepository repository,
    int totalSessions,
    int consecutiveDays,
    double successRate,
  ) async {
    // 更新总断食次数成就
    await repository.updateAchievementProgress(
      'ach_sessions_10',
      totalSessions,
    );
    await repository.updateAchievementProgress(
      'ach_sessions_50',
      totalSessions,
    );

    // 更新连续天数成就
    await repository.updateAchievementProgress(
      'ach_fasting_7',
      consecutiveDays,
    );
    await repository.updateAchievementProgress(
      'ach_fasting_30',
      consecutiveDays,
    );

    // 更新成功率成就（百分比）
    if (totalSessions > 0) {
      await repository.updateAchievementProgress(
        'ach_success_80',
        (successRate * 100).toInt(),
      );
    }

    // 初次断食成就
    if (totalSessions >= 1) {
      await repository.updateAchievementProgress('ach_fasting_1', 1);
    }
  }

  static Future<void> checkHealthAchievements(
    AchievementRepository repository,
    double weightLoss,
    int waterDays,
    int exerciseDays,
  ) async {
    await repository.updateAchievementProgress(
      'ach_weight_5',
      weightLoss.toInt(),
    );
    await repository.updateAchievementProgress('ach_water_7', waterDays);
    await repository.updateAchievementProgress('ach_exercise_7', exerciseDays);
  }
}
