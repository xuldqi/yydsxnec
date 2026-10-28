// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'achievement.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AchievementAdapter extends TypeAdapter<Achievement> {
  @override
  final int typeId = 13;

  @override
  Achievement read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Achievement(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      icon: fields[3] as String,
      isUnlocked: fields[4] as bool,
      unlockedAt: fields[5] as DateTime?,
      targetValue: fields[6] as int,
      currentValue: fields[7] as int,
      type: fields[8] as AchievementType,
      rarity: fields[9] as AchievementRarity,
      category: fields[10] as String,
      createdAt: fields[11] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Achievement obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.icon)
      ..writeByte(4)
      ..write(obj.isUnlocked)
      ..writeByte(5)
      ..write(obj.unlockedAt)
      ..writeByte(6)
      ..write(obj.targetValue)
      ..writeByte(7)
      ..write(obj.currentValue)
      ..writeByte(8)
      ..write(obj.type)
      ..writeByte(9)
      ..write(obj.rarity)
      ..writeByte(10)
      ..write(obj.category)
      ..writeByte(11)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AchievementAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AchievementTypeAdapter extends TypeAdapter<AchievementType> {
  @override
  final int typeId = 14;

  @override
  AchievementType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AchievementType.fastingDays;
      case 1:
        return AchievementType.totalSessions;
      case 2:
        return AchievementType.successRate;
      case 3:
        return AchievementType.totalFastingHours;
      case 4:
        return AchievementType.weightLoss;
      case 5:
        return AchievementType.waterIntake;
      case 6:
        return AchievementType.exerciseDays;
      case 7:
        return AchievementType.other;
      default:
        return AchievementType.fastingDays;
    }
  }

  @override
  void write(BinaryWriter writer, AchievementType obj) {
    switch (obj) {
      case AchievementType.fastingDays:
        writer.writeByte(0);
        break;
      case AchievementType.totalSessions:
        writer.writeByte(1);
        break;
      case AchievementType.successRate:
        writer.writeByte(2);
        break;
      case AchievementType.totalFastingHours:
        writer.writeByte(3);
        break;
      case AchievementType.weightLoss:
        writer.writeByte(4);
        break;
      case AchievementType.waterIntake:
        writer.writeByte(5);
        break;
      case AchievementType.exerciseDays:
        writer.writeByte(6);
        break;
      case AchievementType.other:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AchievementTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AchievementRarityAdapter extends TypeAdapter<AchievementRarity> {
  @override
  final int typeId = 15;

  @override
  AchievementRarity read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AchievementRarity.common;
      case 1:
        return AchievementRarity.rare;
      case 2:
        return AchievementRarity.epic;
      case 3:
        return AchievementRarity.legendary;
      default:
        return AchievementRarity.common;
    }
  }

  @override
  void write(BinaryWriter writer, AchievementRarity obj) {
    switch (obj) {
      case AchievementRarity.common:
        writer.writeByte(0);
        break;
      case AchievementRarity.rare:
        writer.writeByte(1);
        break;
      case AchievementRarity.epic:
        writer.writeByte(2);
        break;
      case AchievementRarity.legendary:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AchievementRarityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AchievementImpl _$$AchievementImplFromJson(Map<String, dynamic> json) =>
    _$AchievementImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      unlockedAt: json['unlockedAt'] == null
          ? null
          : DateTime.parse(json['unlockedAt'] as String),
      targetValue: (json['targetValue'] as num).toInt(),
      currentValue: (json['currentValue'] as num?)?.toInt() ?? 0,
      type: $enumDecode(_$AchievementTypeEnumMap, json['type']),
      rarity: $enumDecode(_$AchievementRarityEnumMap, json['rarity']),
      category: json['category'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$AchievementImplToJson(_$AchievementImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'icon': instance.icon,
      'isUnlocked': instance.isUnlocked,
      'unlockedAt': instance.unlockedAt?.toIso8601String(),
      'targetValue': instance.targetValue,
      'currentValue': instance.currentValue,
      'type': _$AchievementTypeEnumMap[instance.type]!,
      'rarity': _$AchievementRarityEnumMap[instance.rarity]!,
      'category': instance.category,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$AchievementTypeEnumMap = {
  AchievementType.fastingDays: 'fastingDays',
  AchievementType.totalSessions: 'totalSessions',
  AchievementType.successRate: 'successRate',
  AchievementType.totalFastingHours: 'totalFastingHours',
  AchievementType.weightLoss: 'weightLoss',
  AchievementType.waterIntake: 'waterIntake',
  AchievementType.exerciseDays: 'exerciseDays',
  AchievementType.other: 'other',
};

const _$AchievementRarityEnumMap = {
  AchievementRarity.common: 'common',
  AchievementRarity.rare: 'rare',
  AchievementRarity.epic: 'epic',
  AchievementRarity.legendary: 'legendary',
};
