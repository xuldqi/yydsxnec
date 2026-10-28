import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'food_record.freezed.dart';
part 'food_record.g.dart';

@freezed
@HiveType(typeId: 11)
class FoodRecord with _$FoodRecord {
  const factory FoodRecord({
    @HiveField(0) required String id,
    @HiveField(1) required String foodId, // 关联的食物ID
    @HiveField(2) required String foodName, // 食物名称
    @HiveField(3) required DateTime recordTime,
    @HiveField(4) @Default(100.0) double quantity, // 数量（克或毫升）
    @HiveField(5) @Default('g') String unit, // 单位：g/ml/份
    @HiveField(6) String? mealType, // 餐次：早餐/午餐/晚餐/加餐
    @HiveField(7) String? notes, // 备注
    @HiveField(8) Map<String, dynamic>? nutrition, // 营养成分（快照）
    @HiveField(9) double? calories, // 卡路里
    @HiveField(10) required DateTime createdAt,
    @HiveField(11) DateTime? updatedAt,
  }) = _FoodRecord;

  factory FoodRecord.fromJson(Map<String, dynamic> json) =>
      _$FoodRecordFromJson(json);
}

// 扩展方法
extension FoodRecordExtension on FoodRecord {
  /// 获取餐次显示名称
  String get mealTypeDisplayName {
    switch (mealType) {
      case 'breakfast':
        return '早餐';
      case 'lunch':
        return '午餐';
      case 'dinner':
        return '晚餐';
      case 'snack':
        return '加餐';
      default:
        return mealType ?? '未分类';
    }
  }

  /// 计算总卡路里
  double get totalCalories {
    if (calories != null && calories! > 0) {
      return calories!;
    }

    // 从营养成分中计算
    if (nutrition != null) {
      final energy =
          nutrition!['能量'] ??
          nutrition!['energy'] ??
          nutrition!['kcal'] ??
          nutrition!['卡路里'];

      if (energy != null) {
        final energyStr = energy.toString().replaceAll(RegExp(r'[^\d.]'), '');
        final energyValue = double.tryParse(energyStr) ?? 0;
        // 营养成分通常是每100g/100ml的值
        return (energyValue * quantity / 100.0);
      }
    }

    return 0.0;
  }

  /// 获取营养成分文本
  String get nutritionText {
    if (nutrition == null) return '';

    final parts = <String>[];
    final energy =
        nutrition!['能量'] ?? nutrition!['energy'] ?? nutrition!['kcal'];
    final protein = nutrition!['蛋白质'] ?? nutrition!['protein'];
    final fat = nutrition!['脂肪'] ?? nutrition!['fat'];
    final carbs = nutrition!['碳水化合物'] ?? nutrition!['carbohydrate'];

    if (energy != null) parts.add('能量: $energy');
    if (protein != null) parts.add('蛋白: $protein');
    if (fat != null) parts.add('脂肪: $fat');
    if (carbs != null) parts.add('碳水: $carbs');

    return parts.join('  ');
  }
}
