import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'achievement.freezed.dart';
part 'achievement.g.dart';

@freezed
@HiveType(typeId: 13)
class Achievement with _$Achievement {
  const factory Achievement({
    @HiveField(0) required String id,
    @HiveField(1) required String title,
    @HiveField(2) required String description,
    @HiveField(3) required String icon, // 图标名称或emoji
    @HiveField(4) @Default(false) bool isUnlocked, // 是否已解锁
    @HiveField(5) DateTime? unlockedAt, // 解锁时间
    @HiveField(6) required int targetValue, // 目标值
    @HiveField(7) @Default(0) int currentValue, // 当前进度
    @HiveField(8) required AchievementType type,
    @HiveField(9) required AchievementRarity rarity, // 稀有度
    @HiveField(10) @Default('') String category, // 分类
    @HiveField(11) required DateTime createdAt,
  }) = _Achievement;

  factory Achievement.fromJson(Map<String, dynamic> json) =>
      _$AchievementFromJson(json);
}

@HiveType(typeId: 14)
enum AchievementType {
  @HiveField(0)
  fastingDays, // 连续断食天数
  @HiveField(1)
  totalSessions, // 总断食次数
  @HiveField(2)
  successRate, // 成功率
  @HiveField(3)
  totalFastingHours, // 总断食时长
  @HiveField(4)
  weightLoss, // 减重
  @HiveField(5)
  waterIntake, // 饮水量
  @HiveField(6)
  exerciseDays, // 运动天数
  @HiveField(7)
  other, // 其他
}

@HiveType(typeId: 15)
enum AchievementRarity {
  @HiveField(0)
  common, // 普通
  @HiveField(1)
  rare, // 稀有
  @HiveField(2)
  epic, // 史诗
  @HiveField(3)
  legendary, // 传奇
}

// 预设成就
class AchievementPresets {
  static List<Achievement> get defaultAchievements => [
    // 断食相关成就
    Achievement(
      id: 'ach_fasting_1',
      title: '初次断食',
      description: '完成第一次断食',
      icon: '🌱',
      targetValue: 1,
      type: AchievementType.totalSessions,
      rarity: AchievementRarity.common,
      category: '断食',
      createdAt: DateTime.now(),
    ),
    Achievement(
      id: 'ach_fasting_7',
      title: '一周坚持',
      description: '连续断食7天',
      icon: '🔥',
      targetValue: 7,
      type: AchievementType.fastingDays,
      rarity: AchievementRarity.rare,
      category: '断食',
      createdAt: DateTime.now(),
    ),
    Achievement(
      id: 'ach_fasting_30',
      title: '月度坚持',
      description: '连续断食30天',
      icon: '⭐',
      targetValue: 30,
      type: AchievementType.fastingDays,
      rarity: AchievementRarity.epic,
      category: '断食',
      createdAt: DateTime.now(),
    ),
    Achievement(
      id: 'ach_sessions_10',
      title: '十全十美',
      description: '完成10次断食',
      icon: '🎯',
      targetValue: 10,
      type: AchievementType.totalSessions,
      rarity: AchievementRarity.common,
      category: '断食',
      createdAt: DateTime.now(),
    ),
    Achievement(
      id: 'ach_sessions_50',
      title: '断食达人',
      description: '完成50次断食',
      icon: '🏆',
      targetValue: 50,
      type: AchievementType.totalSessions,
      rarity: AchievementRarity.epic,
      category: '断食',
      createdAt: DateTime.now(),
    ),
    Achievement(
      id: 'ach_success_80',
      title: '高成功率',
      description: '断食成功率超过80%',
      icon: '✨',
      targetValue: 80,
      type: AchievementType.successRate,
      rarity: AchievementRarity.rare,
      category: '断食',
      createdAt: DateTime.now(),
    ),
    // 健康相关成就
    Achievement(
      id: 'ach_weight_5',
      title: '减重5kg',
      description: '累计减重5kg',
      icon: '💪',
      targetValue: 5,
      type: AchievementType.weightLoss,
      rarity: AchievementRarity.rare,
      category: '健康',
      createdAt: DateTime.now(),
    ),
    Achievement(
      id: 'ach_water_7',
      title: '饮水习惯',
      description: '连续7天达到饮水目标',
      icon: '💧',
      targetValue: 7,
      type: AchievementType.waterIntake,
      rarity: AchievementRarity.common,
      category: '健康',
      createdAt: DateTime.now(),
    ),
    Achievement(
      id: 'ach_exercise_7',
      title: '运动习惯',
      description: '连续7天记录运动',
      icon: '🏃',
      targetValue: 7,
      type: AchievementType.exerciseDays,
      rarity: AchievementRarity.common,
      category: '健康',
      createdAt: DateTime.now(),
    ),
  ];
}
