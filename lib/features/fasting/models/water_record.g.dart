// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WaterRecordAdapter extends TypeAdapter<WaterRecord> {
  @override
  final int typeId = 4;

  @override
  WaterRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WaterRecord(
      id: fields[0] as String,
      amount: fields[1] as double,
      type: fields[2] as WaterType,
      recordTime: fields[3] as DateTime,
      notes: fields[4] as String?,
      temperature: fields[5] as double,
      isReminder: fields[6] as bool,
      createdAt: fields[7] as DateTime,
      updatedAt: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, WaterRecord obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.recordTime)
      ..writeByte(4)
      ..write(obj.notes)
      ..writeByte(5)
      ..write(obj.temperature)
      ..writeByte(6)
      ..write(obj.isReminder)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WaterRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WaterTypeAdapterAdapter extends TypeAdapter<WaterTypeAdapter> {
  @override
  final int typeId = 5;

  @override
  WaterTypeAdapter read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return WaterTypeAdapter.water;
      case 1:
        return WaterTypeAdapter.tea;
      case 2:
        return WaterTypeAdapter.coffee;
      case 3:
        return WaterTypeAdapter.other;
      default:
        return WaterTypeAdapter.water;
    }
  }

  @override
  void write(BinaryWriter writer, WaterTypeAdapter obj) {
    switch (obj) {
      case WaterTypeAdapter.water:
        writer.writeByte(0);
        break;
      case WaterTypeAdapter.tea:
        writer.writeByte(1);
        break;
      case WaterTypeAdapter.coffee:
        writer.writeByte(2);
        break;
      case WaterTypeAdapter.other:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WaterTypeAdapterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WaterRecordImpl _$$WaterRecordImplFromJson(Map<String, dynamic> json) =>
    _$WaterRecordImpl(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      type:
          $enumDecodeNullable(_$WaterTypeEnumMap, json['type']) ??
          WaterType.water,
      recordTime: DateTime.parse(json['recordTime'] as String),
      notes: json['notes'] as String?,
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.0,
      isReminder: json['isReminder'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$WaterRecordImplToJson(_$WaterRecordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'type': _$WaterTypeEnumMap[instance.type]!,
      'recordTime': instance.recordTime.toIso8601String(),
      'notes': instance.notes,
      'temperature': instance.temperature,
      'isReminder': instance.isReminder,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$WaterTypeEnumMap = {
  WaterType.water: 'water',
  WaterType.tea: 'tea',
  WaterType.coffee: 'coffee',
  WaterType.other: 'other',
};
