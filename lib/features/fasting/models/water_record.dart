import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import '../core/constants/app_constants.dart';

part 'water_record.freezed.dart';
part 'water_record.g.dart';

@freezed
@HiveType(typeId: 4)
class WaterRecord with _$WaterRecord {
  const factory WaterRecord({
    @HiveField(0) required String id,
    @HiveField(1) required double amount, // 毫升
    @HiveField(2) @Default(WaterType.water) WaterType type,
    @HiveField(3) required DateTime recordTime,
    @HiveField(4) String? notes,
    @HiveField(5) @Default(0.0) double temperature, // 温度（摄氏度）
    @HiveField(6) @Default(false) bool isReminder, // 是否通过提醒记录
    @HiveField(7) required DateTime createdAt,
    @HiveField(8) DateTime? updatedAt,
  }) = _WaterRecord;

  factory WaterRecord.fromJson(Map<String, dynamic> json) =>
      _$WaterRecordFromJson(json);
}

// 扩展方法
extension WaterRecordExtension on WaterRecord {
  /// 获取水分类型描述
  String get typeDescription {
    switch (type) {
      case WaterType.water:
        return '白开水';
      case WaterType.tea:
        return '茶';
      case WaterType.coffee:
        return '咖啡';
      case WaterType.other:
        return '其他';
    }
  }

  /// 获取温度描述
  String get temperatureDescription {
    if (temperature == 0.0) return '常温';
    if (temperature < 10) return '冰水';
    if (temperature < 40) return '凉水';
    if (temperature < 60) return '温水';
    return '热水';
  }

  /// 是否为今天的记录
  bool get isToday {
    final now = DateTime.now();
    return recordTime.year == now.year &&
        recordTime.month == now.month &&
        recordTime.day == now.day;
  }

  /// 获取显示文本
  String get displayText {
    return '${amount.toInt()}ml $typeDescription';
  }

  /// 获取详细显示文本
  String get detailDisplayText {
    final buffer = StringBuffer();
    buffer.write('${amount.toInt()}ml $typeDescription');
    if (temperature > 0) {
      buffer.write(' ($temperatureDescription)');
    }
    if (notes != null && notes!.isNotEmpty) {
      buffer.write(' - $notes');
    }
    return buffer.toString();
  }
}

// Hive适配器
@HiveType(typeId: 5)
enum WaterTypeAdapter {
  @HiveField(0)
  water,
  @HiveField(1)
  tea,
  @HiveField(2)
  coffee,
  @HiveField(3)
  other,
}
