// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weight_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeightRecordAdapter extends TypeAdapter<WeightRecord> {
  @override
  final int typeId = 6;

  @override
  WeightRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WeightRecord(
      id: fields[0] as String,
      weight: fields[1] as double,
      recordTime: fields[2] as DateTime,
      notes: fields[3] as String?,
      bodyFat: fields[4] as double,
      muscleMass: fields[5] as double,
      waterPercentage: fields[6] as double,
      bmi: fields[7] as double,
      isTarget: fields[8] as bool,
      createdAt: fields[9] as DateTime,
      updatedAt: fields[10] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, WeightRecord obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.weight)
      ..writeByte(2)
      ..write(obj.recordTime)
      ..writeByte(3)
      ..write(obj.notes)
      ..writeByte(4)
      ..write(obj.bodyFat)
      ..writeByte(5)
      ..write(obj.muscleMass)
      ..writeByte(6)
      ..write(obj.waterPercentage)
      ..writeByte(7)
      ..write(obj.bmi)
      ..writeByte(8)
      ..write(obj.isTarget)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeightRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WeightRecordImpl _$$WeightRecordImplFromJson(Map<String, dynamic> json) =>
    _$WeightRecordImpl(
      id: json['id'] as String,
      weight: (json['weight'] as num).toDouble(),
      recordTime: DateTime.parse(json['recordTime'] as String),
      notes: json['notes'] as String?,
      bodyFat: (json['bodyFat'] as num?)?.toDouble() ?? 0.0,
      muscleMass: (json['muscleMass'] as num?)?.toDouble() ?? 0.0,
      waterPercentage: (json['waterPercentage'] as num?)?.toDouble() ?? 0.0,
      bmi: (json['bmi'] as num?)?.toDouble() ?? 0.0,
      isTarget: json['isTarget'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$WeightRecordImplToJson(_$WeightRecordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'weight': instance.weight,
      'recordTime': instance.recordTime.toIso8601String(),
      'notes': instance.notes,
      'bodyFat': instance.bodyFat,
      'muscleMass': instance.muscleMass,
      'waterPercentage': instance.waterPercentage,
      'bmi': instance.bmi,
      'isTarget': instance.isTarget,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
