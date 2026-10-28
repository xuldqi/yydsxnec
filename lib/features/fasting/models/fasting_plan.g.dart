// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fasting_plan.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FastingPlanAdapter extends TypeAdapter<FastingPlan> {
  @override
  final int typeId = 0;

  @override
  FastingPlan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FastingPlan(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      fastingHours: fields[3] as int,
      eatingHours: fields[4] as int,
      difficulty: fields[5] as FastingDifficulty,
      isCustom: fields[6] as bool,
      isActive: fields[7] as bool,
      createdAt: fields[8] as DateTime,
      updatedAt: fields[9] as DateTime?,
      tips: fields[10] as String?,
      benefits: (fields[11] as List).cast<String>(),
      precautions: (fields[12] as List).cast<String>(),
      successCount: fields[13] as int,
      totalAttempts: fields[14] as int,
    );
  }

  @override
  void write(BinaryWriter writer, FastingPlan obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.fastingHours)
      ..writeByte(4)
      ..write(obj.eatingHours)
      ..writeByte(5)
      ..write(obj.difficulty)
      ..writeByte(6)
      ..write(obj.isCustom)
      ..writeByte(7)
      ..write(obj.isActive)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.updatedAt)
      ..writeByte(10)
      ..write(obj.tips)
      ..writeByte(11)
      ..write(obj.benefits)
      ..writeByte(12)
      ..write(obj.precautions)
      ..writeByte(13)
      ..write(obj.successCount)
      ..writeByte(14)
      ..write(obj.totalAttempts);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FastingPlanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FastingPlanImpl _$$FastingPlanImplFromJson(Map<String, dynamic> json) =>
    _$FastingPlanImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      fastingHours: (json['fastingHours'] as num).toInt(),
      eatingHours: (json['eatingHours'] as num).toInt(),
      difficulty: $enumDecode(_$FastingDifficultyEnumMap, json['difficulty']),
      isCustom: json['isCustom'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      tips: json['tips'] as String?,
      benefits:
          (json['benefits'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      precautions:
          (json['precautions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      successCount: (json['successCount'] as num?)?.toInt() ?? 0,
      totalAttempts: (json['totalAttempts'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$FastingPlanImplToJson(_$FastingPlanImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'fastingHours': instance.fastingHours,
      'eatingHours': instance.eatingHours,
      'difficulty': _$FastingDifficultyEnumMap[instance.difficulty]!,
      'isCustom': instance.isCustom,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'tips': instance.tips,
      'benefits': instance.benefits,
      'precautions': instance.precautions,
      'successCount': instance.successCount,
      'totalAttempts': instance.totalAttempts,
    };

const _$FastingDifficultyEnumMap = {
  FastingDifficulty.beginner: 'beginner',
  FastingDifficulty.intermediate: 'intermediate',
  FastingDifficulty.advanced: 'advanced',
};
