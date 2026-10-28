// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'week_plan.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeekPlanAdapter extends TypeAdapter<WeekPlan> {
  @override
  final int typeId = 12;

  @override
  WeekPlan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WeekPlan(
      id: fields[0] as String,
      name: fields[1] as String,
      planId: fields[2] as String,
      fastingDays: (fields[3] as List).cast<int>(),
      restDays: (fields[4] as List).cast<int>(),
      isActive: fields[5] as bool,
      createdAt: fields[6] as DateTime,
      updatedAt: fields[7] as DateTime?,
      notes: fields[8] as String?,
      lowCalorieDays: (fields[9] as List).cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, WeekPlan obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.planId)
      ..writeByte(3)
      ..write(obj.fastingDays)
      ..writeByte(4)
      ..write(obj.restDays)
      ..writeByte(5)
      ..write(obj.isActive)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt)
      ..writeByte(8)
      ..write(obj.notes)
      ..writeByte(9)
      ..write(obj.lowCalorieDays);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeekPlanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WeekPlanImpl _$$WeekPlanImplFromJson(Map<String, dynamic> json) =>
    _$WeekPlanImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      planId: json['planId'] as String,
      fastingDays:
          (json['fastingDays'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      restDays:
          (json['restDays'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      notes: json['notes'] as String?,
      lowCalorieDays:
          (json['lowCalorieDays'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$WeekPlanImplToJson(_$WeekPlanImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'planId': instance.planId,
      'fastingDays': instance.fastingDays,
      'restDays': instance.restDays,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'notes': instance.notes,
      'lowCalorieDays': instance.lowCalorieDays,
    };
