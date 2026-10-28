import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'weight_record.freezed.dart';
part 'weight_record.g.dart';

@freezed
@HiveType(typeId: 6)
class WeightRecord with _$WeightRecord {
  const factory WeightRecord({
    @HiveField(0) required String id,
    @HiveField(1) required double weight, // kg
    @HiveField(2) required DateTime recordTime,
    @HiveField(3) String? notes,
    @HiveField(4) @Default(0.0) double bodyFat, // 体脂率
    @HiveField(5) @Default(0.0) double muscleMass, // 肌肉量
    @HiveField(6) @Default(0.0) double waterPercentage, // 水分百分比
    @HiveField(7) @Default(0.0) double bmi, // BMI
    @HiveField(8) @Default(false) bool isTarget, // 是否为目标体重
    @HiveField(9) required DateTime createdAt,
    @HiveField(10) DateTime? updatedAt,
  }) = _WeightRecord;

  factory WeightRecord.fromJson(Map<String, dynamic> json) =>
      _$WeightRecordFromJson(json);
}
