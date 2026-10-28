// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fasting_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FastingSessionAdapter extends TypeAdapter<FastingSession> {
  @override
  final int typeId = 2;

  @override
  FastingSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FastingSession(
      id: fields[0] as String,
      planId: fields[1] as String,
      startTime: fields[2] as DateTime,
      endTime: fields[3] as DateTime?,
      plannedEndTime: fields[4] as DateTime?,
      status: fields[5] as FastingStatus,
      fastingHours: fields[6] as int,
      eatingHours: fields[7] as int,
      notes: fields[8] as String?,
      startWeight: fields[9] as double,
      endWeight: fields[10] as double,
      difficultyRating: fields[11] as int,
      satisfactionRating: fields[12] as int,
      symptoms: (fields[13] as List).cast<String>(),
      benefits: (fields[14] as List).cast<String>(),
      lastPauseTime: fields[15] as DateTime?,
      totalPauseDuration: fields[16] as int,
      isCompleted: fields[17] as bool,
      isCancelled: fields[18] as bool,
      createdAt: fields[19] as DateTime,
      updatedAt: fields[20] as DateTime?,
      autoEndEnabled: fields[21] as bool,
      isLowCalorieDay: fields[22] as bool,
      calorieTarget: fields[23] as double?,
      mood: fields[24] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, FastingSession obj) {
    writer
      ..writeByte(25)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.planId)
      ..writeByte(2)
      ..write(obj.startTime)
      ..writeByte(3)
      ..write(obj.endTime)
      ..writeByte(4)
      ..write(obj.plannedEndTime)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.fastingHours)
      ..writeByte(7)
      ..write(obj.eatingHours)
      ..writeByte(8)
      ..write(obj.notes)
      ..writeByte(9)
      ..write(obj.startWeight)
      ..writeByte(10)
      ..write(obj.endWeight)
      ..writeByte(11)
      ..write(obj.difficultyRating)
      ..writeByte(12)
      ..write(obj.satisfactionRating)
      ..writeByte(13)
      ..write(obj.symptoms)
      ..writeByte(14)
      ..write(obj.benefits)
      ..writeByte(15)
      ..write(obj.lastPauseTime)
      ..writeByte(16)
      ..write(obj.totalPauseDuration)
      ..writeByte(17)
      ..write(obj.isCompleted)
      ..writeByte(18)
      ..write(obj.isCancelled)
      ..writeByte(19)
      ..write(obj.createdAt)
      ..writeByte(20)
      ..write(obj.updatedAt)
      ..writeByte(21)
      ..write(obj.autoEndEnabled)
      ..writeByte(22)
      ..write(obj.isLowCalorieDay)
      ..writeByte(23)
      ..write(obj.calorieTarget)
      ..writeByte(24)
      ..write(obj.mood);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FastingSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FastingStatusAdapterAdapter extends TypeAdapter<FastingStatusAdapter> {
  @override
  final int typeId = 3;

  @override
  FastingStatusAdapter read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return FastingStatusAdapter.notStarted;
      case 1:
        return FastingStatusAdapter.active;
      case 2:
        return FastingStatusAdapter.completed;
      case 3:
        return FastingStatusAdapter.cancelled;
      default:
        return FastingStatusAdapter.notStarted;
    }
  }

  @override
  void write(BinaryWriter writer, FastingStatusAdapter obj) {
    switch (obj) {
      case FastingStatusAdapter.notStarted:
        writer.writeByte(0);
        break;
      case FastingStatusAdapter.active:
        writer.writeByte(1);
        break;
      case FastingStatusAdapter.completed:
        writer.writeByte(2);
        break;
      case FastingStatusAdapter.cancelled:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FastingStatusAdapterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FastingSessionImpl _$$FastingSessionImplFromJson(
  Map<String, dynamic> json,
) => _$FastingSessionImpl(
  id: json['id'] as String,
  planId: json['planId'] as String,
  startTime: DateTime.parse(json['startTime'] as String),
  endTime: json['endTime'] == null
      ? null
      : DateTime.parse(json['endTime'] as String),
  plannedEndTime: json['plannedEndTime'] == null
      ? null
      : DateTime.parse(json['plannedEndTime'] as String),
  status:
      $enumDecodeNullable(_$FastingStatusEnumMap, json['status']) ??
      FastingStatus.notStarted,
  fastingHours: (json['fastingHours'] as num?)?.toInt() ?? 0,
  eatingHours: (json['eatingHours'] as num?)?.toInt() ?? 0,
  notes: json['notes'] as String?,
  startWeight: (json['startWeight'] as num?)?.toDouble() ?? 0.0,
  endWeight: (json['endWeight'] as num?)?.toDouble() ?? 0.0,
  difficultyRating: (json['difficultyRating'] as num?)?.toInt() ?? 1,
  satisfactionRating: (json['satisfactionRating'] as num?)?.toInt() ?? 1,
  symptoms:
      (json['symptoms'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  benefits:
      (json['benefits'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  lastPauseTime: json['lastPauseTime'] == null
      ? null
      : DateTime.parse(json['lastPauseTime'] as String),
  totalPauseDuration: (json['totalPauseDuration'] as num?)?.toInt() ?? 0,
  isCompleted: json['isCompleted'] as bool? ?? false,
  isCancelled: json['isCancelled'] as bool? ?? false,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  autoEndEnabled: json['autoEndEnabled'] as bool? ?? false,
  isLowCalorieDay: json['isLowCalorieDay'] as bool? ?? false,
  calorieTarget: (json['calorieTarget'] as num?)?.toDouble(),
  mood: json['mood'] as String?,
);

Map<String, dynamic> _$$FastingSessionImplToJson(
  _$FastingSessionImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'planId': instance.planId,
  'startTime': instance.startTime.toIso8601String(),
  'endTime': instance.endTime?.toIso8601String(),
  'plannedEndTime': instance.plannedEndTime?.toIso8601String(),
  'status': _$FastingStatusEnumMap[instance.status]!,
  'fastingHours': instance.fastingHours,
  'eatingHours': instance.eatingHours,
  'notes': instance.notes,
  'startWeight': instance.startWeight,
  'endWeight': instance.endWeight,
  'difficultyRating': instance.difficultyRating,
  'satisfactionRating': instance.satisfactionRating,
  'symptoms': instance.symptoms,
  'benefits': instance.benefits,
  'lastPauseTime': instance.lastPauseTime?.toIso8601String(),
  'totalPauseDuration': instance.totalPauseDuration,
  'isCompleted': instance.isCompleted,
  'isCancelled': instance.isCancelled,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'autoEndEnabled': instance.autoEndEnabled,
  'isLowCalorieDay': instance.isLowCalorieDay,
  'calorieTarget': instance.calorieTarget,
  'mood': instance.mood,
};

const _$FastingStatusEnumMap = {
  FastingStatus.notStarted: 'notStarted',
  FastingStatus.active: 'active',
  FastingStatus.paused: 'paused',
  FastingStatus.completed: 'completed',
  FastingStatus.cancelled: 'cancelled',
};
