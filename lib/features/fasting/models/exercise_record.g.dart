// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExerciseRecordAdapter extends TypeAdapter<ExerciseRecord> {
  @override
  final int typeId = 16;

  @override
  ExerciseRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExerciseRecord(
      id: fields[0] as String,
      type: fields[1] as ExerciseType,
      recordTime: fields[2] as DateTime,
      durationMinutes: fields[3] as int,
      calories: fields[4] as double?,
      distance: fields[5] as double?,
      notes: fields[6] as String?,
      intensity: fields[7] as int,
      createdAt: fields[8] as DateTime,
      updatedAt: fields[9] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ExerciseRecord obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.recordTime)
      ..writeByte(3)
      ..write(obj.durationMinutes)
      ..writeByte(4)
      ..write(obj.calories)
      ..writeByte(5)
      ..write(obj.distance)
      ..writeByte(6)
      ..write(obj.notes)
      ..writeByte(7)
      ..write(obj.intensity)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExerciseRecordImpl _$$ExerciseRecordImplFromJson(Map<String, dynamic> json) =>
    _$ExerciseRecordImpl(
      id: json['id'] as String,
      type: $enumDecode(_$ExerciseTypeEnumMap, json['type']),
      recordTime: DateTime.parse(json['recordTime'] as String),
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      calories: (json['calories'] as num?)?.toDouble(),
      distance: (json['distance'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
      intensity: (json['intensity'] as num?)?.toInt() ?? 1,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ExerciseRecordImplToJson(
  _$ExerciseRecordImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': _$ExerciseTypeEnumMap[instance.type]!,
  'recordTime': instance.recordTime.toIso8601String(),
  'durationMinutes': instance.durationMinutes,
  'calories': instance.calories,
  'distance': instance.distance,
  'notes': instance.notes,
  'intensity': instance.intensity,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

const _$ExerciseTypeEnumMap = {
  ExerciseType.walking: 'walking',
  ExerciseType.running: 'running',
  ExerciseType.cycling: 'cycling',
  ExerciseType.swimming: 'swimming',
  ExerciseType.yoga: 'yoga',
  ExerciseType.weightTraining: 'weightTraining',
  ExerciseType.other: 'other',
};
