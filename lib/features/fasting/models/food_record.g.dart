// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FoodRecordAdapter extends TypeAdapter<FoodRecord> {
  @override
  final int typeId = 11;

  @override
  FoodRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FoodRecord(
      id: fields[0] as String,
      foodId: fields[1] as String,
      foodName: fields[2] as String,
      recordTime: fields[3] as DateTime,
      quantity: fields[4] as double,
      unit: fields[5] as String,
      mealType: fields[6] as String?,
      notes: fields[7] as String?,
      nutrition: (fields[8] as Map?)?.cast<String, dynamic>(),
      calories: fields[9] as double?,
      createdAt: fields[10] as DateTime,
      updatedAt: fields[11] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, FoodRecord obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.foodId)
      ..writeByte(2)
      ..write(obj.foodName)
      ..writeByte(3)
      ..write(obj.recordTime)
      ..writeByte(4)
      ..write(obj.quantity)
      ..writeByte(5)
      ..write(obj.unit)
      ..writeByte(6)
      ..write(obj.mealType)
      ..writeByte(7)
      ..write(obj.notes)
      ..writeByte(8)
      ..write(obj.nutrition)
      ..writeByte(9)
      ..write(obj.calories)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FoodRecordImpl _$$FoodRecordImplFromJson(Map<String, dynamic> json) =>
    _$FoodRecordImpl(
      id: json['id'] as String,
      foodId: json['foodId'] as String,
      foodName: json['foodName'] as String,
      recordTime: DateTime.parse(json['recordTime'] as String),
      quantity: (json['quantity'] as num?)?.toDouble() ?? 100.0,
      unit: json['unit'] as String? ?? 'g',
      mealType: json['mealType'] as String?,
      notes: json['notes'] as String?,
      nutrition: json['nutrition'] as Map<String, dynamic>?,
      calories: (json['calories'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$FoodRecordImplToJson(_$FoodRecordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'foodId': instance.foodId,
      'foodName': instance.foodName,
      'recordTime': instance.recordTime.toIso8601String(),
      'quantity': instance.quantity,
      'unit': instance.unit,
      'mealType': instance.mealType,
      'notes': instance.notes,
      'nutrition': instance.nutrition,
      'calories': instance.calories,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
