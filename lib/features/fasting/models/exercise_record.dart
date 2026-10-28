import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import '../core/constants/app_constants.dart';

part 'exercise_record.freezed.dart';
part 'exercise_record.g.dart';

@freezed
@HiveType(typeId: 16)
class ExerciseRecord with _$ExerciseRecord {
  const factory ExerciseRecord({
    @HiveField(0) required String id,
    @HiveField(1) required ExerciseType type,
    @HiveField(2) required DateTime recordTime,
    @HiveField(3) required int durationMinutes, // 运动时长（分钟）
    @HiveField(4) double? calories, // 消耗的卡路里
    @HiveField(5) double? distance, // 距离（公里，适用于跑步、骑行等）
    @HiveField(6) String? notes, // 备注
    @HiveField(7) @Default(1) int intensity, // 强度等级 1-5
    @HiveField(8) required DateTime createdAt,
    @HiveField(9) DateTime? updatedAt,
  }) = _ExerciseRecord;

  factory ExerciseRecord.fromJson(Map<String, dynamic> json) =>
      _$ExerciseRecordFromJson(json);
}

// 扩展方法
extension ExerciseRecordExtension on ExerciseRecord {
  /// 获取运动类型显示名称
  String get typeDisplayName {
    switch (type) {
      case ExerciseType.walking:
        return '步行';
      case ExerciseType.running:
        return '跑步';
      case ExerciseType.cycling:
        return '骑行';
      case ExerciseType.swimming:
        return '游泳';
      case ExerciseType.yoga:
        return '瑜伽';
      case ExerciseType.weightTraining:
        return '力量训练';
      case ExerciseType.other:
        return '其他';
    }
  }

  /// 获取运动时长显示
  String get durationDisplay {
    if (durationMinutes < 60) {
      return '$durationMinutes分钟';
    }
    final hours = durationMinutes ~/ 60;
    final minutes = durationMinutes % 60;
    if (minutes == 0) {
      return '$hours小时';
    }
    return '$hours小时$minutes分钟';
  }

  /// 估算卡路里（如果未提供）
  double get estimatedCalories {
    if (calories != null && calories! > 0) {
      return calories!;
    }

    // 简单的卡路里估算公式：MET值 * 体重(kg) * 时长(小时)
    // 假设平均体重65kg
    const averageWeight = 65.0;
    final hours = durationMinutes / 60.0;

    // 不同运动类型的MET值（代谢当量）
    double met;
    switch (type) {
      case ExerciseType.walking:
        met = 3.5;
        break;
      case ExerciseType.running:
        met = 8.0 + (intensity - 1) * 2.0; // 根据强度调整
        break;
      case ExerciseType.cycling:
        met = 6.0 + (intensity - 1) * 2.0;
        break;
      case ExerciseType.swimming:
        met = 7.0;
        break;
      case ExerciseType.yoga:
        met = 2.5;
        break;
      case ExerciseType.weightTraining:
        met = 5.0 + (intensity - 1) * 1.5;
        break;
      case ExerciseType.other:
        met = 4.0;
        break;
    }

    return met * averageWeight * hours;
  }
}
