import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import '../core/constants/app_constants.dart';

part 'fasting_session.freezed.dart';
part 'fasting_session.g.dart';

@freezed
@HiveType(typeId: 2)
class FastingSession with _$FastingSession {
  const factory FastingSession({
    @HiveField(0) required String id,
    @HiveField(1) required String planId,
    @HiveField(2) required DateTime startTime,
    @HiveField(3) DateTime? endTime,
    @HiveField(4) DateTime? plannedEndTime,
    @HiveField(5) @Default(FastingStatus.notStarted) FastingStatus status,
    @HiveField(6) @Default(0) int fastingHours,
    @HiveField(7) @Default(0) int eatingHours,
    @HiveField(8) String? notes,
    @HiveField(9) @Default(0.0) double startWeight,
    @HiveField(10) @Default(0.0) double endWeight,
    @HiveField(11) @Default(1) int difficultyRating, // 1-5星难度评价
    @HiveField(12) @Default(1) int satisfactionRating, // 1-5星满意度评价
    @HiveField(13) @Default([]) List<String> symptoms, // 断食期间的症状
    @HiveField(14) @Default([]) List<String> benefits, // 感受到的益处
    @HiveField(15) DateTime? lastPauseTime,
    @HiveField(16) @Default(0) int totalPauseDuration, // 总暂停时长（分钟）
    @HiveField(17) @Default(false) bool isCompleted,
    @HiveField(18) @Default(false) bool isCancelled,
    @HiveField(19) required DateTime createdAt,
    @HiveField(20) DateTime? updatedAt,
    @HiveField(21) @Default(false) bool autoEndEnabled, // 是否启用自动结束
    @HiveField(22) @Default(false) bool isLowCalorieDay, // 低卡日（5:2）
    @HiveField(23) double? calorieTarget, // 低卡日目标卡路里
    @HiveField(24) String? mood, // 心情记录
  }) = _FastingSession;

  factory FastingSession.fromJson(Map<String, dynamic> json) =>
      _$FastingSessionFromJson(json);
}

// 扩展方法
extension FastingSessionExtension on FastingSession {
  /// 获取实际断食时长（分钟）
  int get actualFastingDurationMinutes {
    if (endTime == null) {
      if (status == FastingStatus.active) {
        return DateTime.now().difference(startTime).inMinutes -
            totalPauseDuration;
      }
      return 0;
    }
    return endTime!.difference(startTime).inMinutes - totalPauseDuration;
  }

  /// 获取实际断食时长（小时）
  double get actualFastingDurationHours {
    return actualFastingDurationMinutes / 60.0;
  }

  /// 获取计划断食时长（分钟）
  int get plannedFastingDurationMinutes {
    if (fastingHours <= 0) return 0;
    return fastingHours * 60;
  }

  /// 获取断食进度百分比
  double get progressPercentage {
    if (plannedFastingDurationMinutes == 0) return 0.0;
    final progress =
        actualFastingDurationMinutes / plannedFastingDurationMinutes;
    return (progress * 100).clamp(0.0, 100.0);
  }

  /// 获取剩余时间（分钟）
  int get remainingMinutes {
    final remaining =
        plannedFastingDurationMinutes - actualFastingDurationMinutes;
    return remaining > 0 ? remaining : 0;
  }

  /// 获取剩余时间（Duration）
  Duration get remainingDuration {
    return Duration(minutes: remainingMinutes);
  }

  /// 是否已超时
  bool get isOvertime {
    return actualFastingDurationMinutes > plannedFastingDurationMinutes;
  }

  /// 获取超时时长（分钟）
  int get overtimeMinutes {
    final overtime =
        actualFastingDurationMinutes - plannedFastingDurationMinutes;
    return overtime > 0 ? overtime : 0;
  }

  /// 是否可以结束断食
  bool get canEndFasting {
    return status == FastingStatus.active &&
        actualFastingDurationMinutes >= plannedFastingDurationMinutes;
  }

  /// 是否已进入进食窗口
  bool get isInEatingWindow {
    if (plannedEndTime == null || eatingHours == 0) return false;
    final now = DateTime.now();
    return now.isAfter(plannedEndTime!) &&
        now.isBefore(plannedEndTime!.add(Duration(hours: eatingHours)));
  }

  /// 进食窗口是否已结束
  bool get isEatingWindowEnded {
    if (plannedEndTime == null || eatingHours == 0) return false;
    final now = DateTime.now();
    return now.isAfter(plannedEndTime!.add(Duration(hours: eatingHours)));
  }

  /// 获取进食窗口剩余时间（分钟）
  int get eatingWindowRemainingMinutes {
    if (plannedEndTime == null || eatingHours == 0) return 0;
    final eatingWindowEnd = plannedEndTime!.add(Duration(hours: eatingHours));
    final now = DateTime.now();
    if (now.isBefore(plannedEndTime!)) return 0; // 还在断食中
    if (now.isAfter(eatingWindowEnd)) return 0; // 进食窗口已结束
    return eatingWindowEnd.difference(now).inMinutes;
  }

  /// 是否正在进行中
  bool get isActive {
    return status == FastingStatus.active;
  }

  /// 是否已完成
  bool get isFinished {
    return status == FastingStatus.completed || isCompleted;
  }

  /// 是否已取消
  bool get wasCancelled {
    return status == FastingStatus.cancelled || isCancelled;
  }

  /// 获取体重变化
  double get weightChange {
    if (startWeight == 0.0 || endWeight == 0.0) return 0.0;
    return endWeight - startWeight;
  }

  /// 是否有体重记录
  bool get hasWeightRecord {
    return startWeight > 0.0 && endWeight > 0.0;
  }

  /// 获取成功率（基于是否完成目标时长）
  double get successRate {
    if (plannedFastingDurationMinutes == 0) return 0.0;
    final rate = actualFastingDurationMinutes / plannedFastingDurationMinutes;
    return (rate * 100).clamp(0.0, 100.0);
  }

  /// 是否达到目标
  bool get achievedGoal {
    return actualFastingDurationMinutes >= plannedFastingDurationMinutes;
  }

  /// 获取状态描述
  String get statusDescription {
    switch (status) {
      case FastingStatus.notStarted:
        return '未开始';
      case FastingStatus.active:
        if (isInEatingWindow) {
          return '进食窗口';
        }
        return '进行中';
      case FastingStatus.paused:
        return '已暂停';
      case FastingStatus.completed:
        return '已完成';
      case FastingStatus.cancelled:
        return '已取消';
    }
  }

  /// 检查是否需要自动结束（基于autoEndEnabled和到达时间）
  bool shouldAutoEnd(DateTime now) {
    if (!autoEndEnabled) return false;
    if (status != FastingStatus.active) return false;
    if (plannedEndTime == null) return false;

    // 如果到达了计划结束时间，且已启用自动结束
    return now.isAfter(plannedEndTime!) ||
        now.isAtSameMomentAs(plannedEndTime!);
  }

  /// 当前阶段：断食中 / 进食窗口 / 进食结束 / 低卡日
  String get currentPhase {
    if (isLowCalorieDay) return 'low_calorie';
    if (plannedEndTime == null || fastingHours == 0) return 'fasting';
    if (isInEatingWindow) return 'eating';
    if (isEatingWindowEnded) return 'post_eating';
    return 'fasting';
  }

  /// 获取评价描述
  String getDifficultyDescription() {
    switch (difficultyRating) {
      case 1:
        return '非常容易';
      case 2:
        return '容易';
      case 3:
        return '一般';
      case 4:
        return '困难';
      case 5:
        return '非常困难';
      default:
        return '未评价';
    }
  }

  String getSatisfactionDescription() {
    switch (satisfactionRating) {
      case 1:
        return '非常不满意';
      case 2:
        return '不满意';
      case 3:
        return '一般';
      case 4:
        return '满意';
      case 5:
        return '非常满意';
      default:
        return '未评价';
    }
  }
}

// Hive适配器
@HiveType(typeId: 3)
enum FastingStatusAdapter {
  @HiveField(0)
  notStarted,
  @HiveField(1)
  active,
  @HiveField(2)
  completed,
  @HiveField(3)
  cancelled,
}
