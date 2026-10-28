// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'suggestion.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SuggestionAdapter extends TypeAdapter<Suggestion> {
  @override
  final int typeId = 7;

  @override
  Suggestion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Suggestion(
      id: fields[0] as String,
      type: fields[1] as SuggestionType,
      title: fields[2] as String,
      content: fields[3] as String,
      priority: fields[4] as SuggestionPriority,
      scientificBasis: fields[5] as String?,
      actionItems: (fields[6] as List).cast<String>(),
      isRead: fields[7] as bool,
      isAdopted: fields[8] as bool,
      isIgnored: fields[9] as bool,
      adoptedAt: fields[10] as DateTime?,
      ignoredAt: fields[11] as DateTime?,
      expiresAt: fields[12] as DateTime?,
      createdAt: fields[13] as DateTime,
      updatedAt: fields[14] as DateTime?,
      metadata: (fields[15] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, Suggestion obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.content)
      ..writeByte(4)
      ..write(obj.priority)
      ..writeByte(5)
      ..write(obj.scientificBasis)
      ..writeByte(6)
      ..write(obj.actionItems)
      ..writeByte(7)
      ..write(obj.isRead)
      ..writeByte(8)
      ..write(obj.isAdopted)
      ..writeByte(9)
      ..write(obj.isIgnored)
      ..writeByte(10)
      ..write(obj.adoptedAt)
      ..writeByte(11)
      ..write(obj.ignoredAt)
      ..writeByte(12)
      ..write(obj.expiresAt)
      ..writeByte(13)
      ..write(obj.createdAt)
      ..writeByte(14)
      ..write(obj.updatedAt)
      ..writeByte(15)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SuggestionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SuggestionImpl _$$SuggestionImplFromJson(Map<String, dynamic> json) =>
    _$SuggestionImpl(
      id: json['id'] as String,
      type: $enumDecode(_$SuggestionTypeEnumMap, json['type']),
      title: json['title'] as String,
      content: json['content'] as String,
      priority: $enumDecode(_$SuggestionPriorityEnumMap, json['priority']),
      scientificBasis: json['scientificBasis'] as String?,
      actionItems:
          (json['actionItems'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isRead: json['isRead'] as bool? ?? false,
      isAdopted: json['isAdopted'] as bool? ?? false,
      isIgnored: json['isIgnored'] as bool? ?? false,
      adoptedAt: json['adoptedAt'] == null
          ? null
          : DateTime.parse(json['adoptedAt'] as String),
      ignoredAt: json['ignoredAt'] == null
          ? null
          : DateTime.parse(json['ignoredAt'] as String),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$SuggestionImplToJson(_$SuggestionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$SuggestionTypeEnumMap[instance.type]!,
      'title': instance.title,
      'content': instance.content,
      'priority': _$SuggestionPriorityEnumMap[instance.priority]!,
      'scientificBasis': instance.scientificBasis,
      'actionItems': instance.actionItems,
      'isRead': instance.isRead,
      'isAdopted': instance.isAdopted,
      'isIgnored': instance.isIgnored,
      'adoptedAt': instance.adoptedAt?.toIso8601String(),
      'ignoredAt': instance.ignoredAt?.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'metadata': instance.metadata,
    };

const _$SuggestionTypeEnumMap = {
  SuggestionType.fastingPlan: 'fastingPlan',
  SuggestionType.waterIntake: 'waterIntake',
  SuggestionType.weightManagement: 'weightManagement',
  SuggestionType.exercise: 'exercise',
  SuggestionType.eatingWindow: 'eatingWindow',
  SuggestionType.healthRisk: 'healthRisk',
};

const _$SuggestionPriorityEnumMap = {
  SuggestionPriority.low: 'low',
  SuggestionPriority.medium: 'medium',
  SuggestionPriority.high: 'high',
  SuggestionPriority.urgent: 'urgent',
};
