import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'week_plan.freezed.dart';
part 'week_plan.g.dart';

@freezed
@HiveType(typeId: 12)
class WeekPlan with _$WeekPlan {
  const factory WeekPlan({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) required String planId, // 关联的断食计划ID
    @HiveField(3) @Default([]) List<int> fastingDays, // 断食日（1-7，1=周一）
    @HiveField(4) @Default([]) List<int> restDays, // 休息日（1-7）
    @HiveField(5) @Default(true) bool isActive,
    @HiveField(6) required DateTime createdAt,
    @HiveField(7) DateTime? updatedAt,
    @HiveField(8) String? notes, // 备注
    @HiveField(9) @Default([]) List<int> lowCalorieDays, // 低卡日（用于5:2）
  }) = _WeekPlan;

  factory WeekPlan.fromJson(Map<String, dynamic> json) =>
      _$WeekPlanFromJson(json);
}

// 扩展方法
extension WeekPlanExtension on WeekPlan {
  /// 检查某天是否需要断食
  bool shouldFastOnDay(int weekday) {
    return fastingDays.contains(weekday);
  }

  /// 检查某天是否是休息日
  bool isRestDay(int weekday) {
    return restDays.contains(weekday);
  }

  /// 检查某天是否是低卡日（5:2）
  bool isLowCalDay(int weekday) {
    return lowCalorieDays.contains(weekday);
  }

  /// 获取周计划描述
  String get description {
    if (fastingDays.length == 6 && restDays.length == 1) {
      return '6+1模式：6天断食，1天休息';
    } else if (fastingDays.length == 5 && restDays.length == 2) {
      return '5+2模式：5天断食，2天休息';
    } else {
      return '自定义模式：${fastingDays.length}天断食，${restDays.length}天休息';
    }
  }

  /// 获取天数名称
  String getDayName(int weekday) {
    const days = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    return days[weekday - 1];
  }
}

// 预设周计划
class WeekPlanPresets {
  /// 6+1模式：周一到周六断食，周日休息
  static WeekPlan sixPlusOne({required String planId, String? name}) {
    return WeekPlan(
      id: 'weekplan_6+1_${DateTime.now().millisecondsSinceEpoch}',
      name: name ?? '6+1周计划',
      planId: planId,
      fastingDays: [1, 2, 3, 4, 5, 6], // 周一到周六
      restDays: [7], // 周日
      createdAt: DateTime.now(),
    );
  }

  /// 5+2模式：周一到周五断食，周末休息
  static WeekPlan fivePlusTwo({required String planId, String? name}) {
    return WeekPlan(
      id: 'weekplan_5+2_${DateTime.now().millisecondsSinceEpoch}',
      name: name ?? '5+2周计划',
      planId: planId,
      fastingDays: [1, 2, 3, 4, 5], // 周一到周五
      restDays: [6, 7], // 周六周日
      createdAt: DateTime.now(),
    );
  }

  /// 5:2模式低卡日（默认周一、周四）
  static WeekPlan fiveTwoLowCal({required String planId, String? name}) {
    return WeekPlan(
      id: 'weekplan_5+2_${DateTime.now().millisecondsSinceEpoch}',
      name: name ?? '5:2周计划',
      planId: planId,
      fastingDays: const [], // 5:2不按小时断食
      restDays: const [2, 3, 5, 6, 7], // 仅标记低卡日，不强制休息
      lowCalorieDays: const [1, 4], // 默认周一、周四为低卡日
      createdAt: DateTime.now(),
      notes: '低卡日目标 500-600 卡路里',
    );
  }
}
