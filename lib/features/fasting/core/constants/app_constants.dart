import 'package:hive/hive.dart';

part 'app_constants.g.dart';

// 应用常量定义
class AppConstants {
  // 应用信息
  static const String appName = '小鹿轻断食';
  static const String appVersion = '1.0.0';

  // 数据库相关
  static const String databaseName = 'light_fasting_db';
  static const int databaseVersion = 1;

  // Hive Box 名称
  // 使用 v2 版本名称，避免读取旧版本中已损坏的数据结构
  static const String fastingPlanBox = 'fasting_plans_v2';
  static const String fastingSessionBox = 'fasting_sessions_v2';
  static const String waterRecordBox = 'water_records';
  static const String weightRecordBox = 'weight_records';
  static const String exerciseRecordBox = 'exercise_records';
  static const String suggestionBox = 'suggestions';
  static const String userSettingsBox = 'user_settings';

  // 默认值
  static const double defaultWaterGoal = 2000.0; // 毫升
  static const int defaultFastingHours = 16;
  static const int defaultEatingHours = 8;

  // 建议系统相关
  static const int maxSuggestionsPerDay = 5;
  static const int suggestionValidityDays = 7;

  // 通知相关
  static const String fastingStartChannelId = 'fasting_start';
  static const String fastingEndChannelId = 'fasting_end';
  static const String waterReminderChannelId = 'water_reminder';
  static const String suggestionChannelId = 'suggestion';
}

// 枚举定义
@HiveType(typeId: 1)
enum FastingDifficulty {
  @HiveField(0)
  beginner,
  @HiveField(1)
  intermediate,
  @HiveField(2)
  advanced,
}

@HiveType(typeId: 10)
enum FastingStatus {
  @HiveField(0)
  notStarted,
  @HiveField(1)
  active,
  @HiveField(2)
  paused,
  @HiveField(3)
  completed,
  @HiveField(4)
  cancelled,
}

@HiveType(typeId: 8)
enum SuggestionType {
  @HiveField(0)
  fastingPlan,
  @HiveField(1)
  waterIntake,
  @HiveField(2)
  weightManagement,
  @HiveField(3)
  exercise,
  @HiveField(4)
  eatingWindow,
  @HiveField(5)
  healthRisk,
}

@HiveType(typeId: 9)
enum SuggestionPriority {
  @HiveField(0)
  low,
  @HiveField(1)
  medium,
  @HiveField(2)
  high,
  @HiveField(3)
  urgent,
}

enum NotificationType {
  fastingStart,
  fastingEnd,
  eatingWindowStart,
  waterReminder,
  weightReminder,
  exerciseReminder,
  suggestion,
}

enum WaterType { water, tea, coffee, other }

@HiveType(typeId: 17)
enum ExerciseType {
  @HiveField(0)
  walking,
  @HiveField(1)
  running,
  @HiveField(2)
  cycling,
  @HiveField(3)
  swimming,
  @HiveField(4)
  yoga,
  @HiveField(5)
  weightTraining,
  @HiveField(6)
  other,
}
