import 'package:hive_flutter/hive_flutter.dart';
import '../models/achievement.dart';

class AchievementRepository {
  Box<Achievement>? _achievementBox;
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    _achievementBox = await Hive.openBox<Achievement>('achievements');
    _isInitialized = true;
    await _initializeDefaultAchievements();
  }

  Future<void> _initializeDefaultAchievements() async {
    final existingIds = _achievementBox!.keys.toSet();
    final defaultAchievements = AchievementPresets.defaultAchievements;

    for (final achievement in defaultAchievements) {
      if (!existingIds.contains(achievement.id)) {
        await _achievementBox!.put(achievement.id, achievement);
      }
    }
  }

  Future<List<Achievement>> getAllAchievements() async {
    if (!_isInitialized) return [];
    final achievements = _achievementBox!.values.toList();
    achievements.sort((a, b) {
      if (a.isUnlocked != b.isUnlocked) {
        return a.isUnlocked ? -1 : 1;
      }
      return b.rarity.index.compareTo(a.rarity.index);
    });
    return achievements;
  }

  Future<List<Achievement>> getUnlockedAchievements() async {
    if (!_isInitialized) return [];
    return _achievementBox!.values
        .where((achievement) => achievement.isUnlocked)
        .toList();
  }

  Future<List<Achievement>> getLockedAchievements() async {
    if (!_isInitialized) return [];
    return _achievementBox!.values
        .where((achievement) => !achievement.isUnlocked)
        .toList();
  }

  Future<Achievement?> getAchievementById(String id) async {
    if (!_isInitialized) return null;
    return _achievementBox!.get(id);
  }

  Future<void> updateAchievement(Achievement achievement) async {
    if (!_isInitialized) return;
    await _achievementBox!.put(achievement.id, achievement);
  }

  Future<void> unlockAchievement(String id) async {
    final achievement = await getAchievementById(id);
    if (achievement != null && !achievement.isUnlocked) {
      final updated = achievement.copyWith(
        isUnlocked: true,
        unlockedAt: DateTime.now(),
      );
      await updateAchievement(updated);
    }
  }

  Future<void> updateAchievementProgress(String id, int currentValue) async {
    final achievement = await getAchievementById(id);
    if (achievement != null) {
      final updated = achievement.copyWith(currentValue: currentValue);
      await updateAchievement(updated);

      if (currentValue >= achievement.targetValue && !achievement.isUnlocked) {
        await unlockAchievement(id);
      }
    }
  }

  Future<int> getUnlockedCount() async {
    if (!_isInitialized) return 0;
    return _achievementBox!.values
        .where((achievement) => achievement.isUnlocked)
        .length;
  }
}
