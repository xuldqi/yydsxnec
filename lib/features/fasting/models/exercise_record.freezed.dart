// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ExerciseRecord _$ExerciseRecordFromJson(Map<String, dynamic> json) {
  return _ExerciseRecord.fromJson(json);
}

/// @nodoc
mixin _$ExerciseRecord {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  ExerciseType get type => throw _privateConstructorUsedError;
  @HiveField(2)
  DateTime get recordTime => throw _privateConstructorUsedError;
  @HiveField(3)
  int get durationMinutes => throw _privateConstructorUsedError; // 运动时长（分钟）
  @HiveField(4)
  double? get calories => throw _privateConstructorUsedError; // 消耗的卡路里
  @HiveField(5)
  double? get distance => throw _privateConstructorUsedError; // 距离（公里，适用于跑步、骑行等）
  @HiveField(6)
  String? get notes => throw _privateConstructorUsedError; // 备注
  @HiveField(7)
  int get intensity => throw _privateConstructorUsedError; // 强度等级 1-5
  @HiveField(8)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @HiveField(9)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ExerciseRecordCopyWith<ExerciseRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExerciseRecordCopyWith<$Res> {
  factory $ExerciseRecordCopyWith(
    ExerciseRecord value,
    $Res Function(ExerciseRecord) then,
  ) = _$ExerciseRecordCopyWithImpl<$Res, ExerciseRecord>;
  @useResult
  $Res call({
    @HiveField(0) String id,
    @HiveField(1) ExerciseType type,
    @HiveField(2) DateTime recordTime,
    @HiveField(3) int durationMinutes,
    @HiveField(4) double? calories,
    @HiveField(5) double? distance,
    @HiveField(6) String? notes,
    @HiveField(7) int intensity,
    @HiveField(8) DateTime createdAt,
    @HiveField(9) DateTime? updatedAt,
  });
}

/// @nodoc
class _$ExerciseRecordCopyWithImpl<$Res, $Val extends ExerciseRecord>
    implements $ExerciseRecordCopyWith<$Res> {
  _$ExerciseRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? recordTime = null,
    Object? durationMinutes = null,
    Object? calories = freezed,
    Object? distance = freezed,
    Object? notes = freezed,
    Object? intensity = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as ExerciseType,
            recordTime: null == recordTime
                ? _value.recordTime
                : recordTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            durationMinutes: null == durationMinutes
                ? _value.durationMinutes
                : durationMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            calories: freezed == calories
                ? _value.calories
                : calories // ignore: cast_nullable_to_non_nullable
                      as double?,
            distance: freezed == distance
                ? _value.distance
                : distance // ignore: cast_nullable_to_non_nullable
                      as double?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            intensity: null == intensity
                ? _value.intensity
                : intensity // ignore: cast_nullable_to_non_nullable
                      as int,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ExerciseRecordImplCopyWith<$Res>
    implements $ExerciseRecordCopyWith<$Res> {
  factory _$$ExerciseRecordImplCopyWith(
    _$ExerciseRecordImpl value,
    $Res Function(_$ExerciseRecordImpl) then,
  ) = __$$ExerciseRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @HiveField(0) String id,
    @HiveField(1) ExerciseType type,
    @HiveField(2) DateTime recordTime,
    @HiveField(3) int durationMinutes,
    @HiveField(4) double? calories,
    @HiveField(5) double? distance,
    @HiveField(6) String? notes,
    @HiveField(7) int intensity,
    @HiveField(8) DateTime createdAt,
    @HiveField(9) DateTime? updatedAt,
  });
}

/// @nodoc
class __$$ExerciseRecordImplCopyWithImpl<$Res>
    extends _$ExerciseRecordCopyWithImpl<$Res, _$ExerciseRecordImpl>
    implements _$$ExerciseRecordImplCopyWith<$Res> {
  __$$ExerciseRecordImplCopyWithImpl(
    _$ExerciseRecordImpl _value,
    $Res Function(_$ExerciseRecordImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? recordTime = null,
    Object? durationMinutes = null,
    Object? calories = freezed,
    Object? distance = freezed,
    Object? notes = freezed,
    Object? intensity = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$ExerciseRecordImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as ExerciseType,
        recordTime: null == recordTime
            ? _value.recordTime
            : recordTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        durationMinutes: null == durationMinutes
            ? _value.durationMinutes
            : durationMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        calories: freezed == calories
            ? _value.calories
            : calories // ignore: cast_nullable_to_non_nullable
                  as double?,
        distance: freezed == distance
            ? _value.distance
            : distance // ignore: cast_nullable_to_non_nullable
                  as double?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        intensity: null == intensity
            ? _value.intensity
            : intensity // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ExerciseRecordImpl implements _ExerciseRecord {
  const _$ExerciseRecordImpl({
    @HiveField(0) required this.id,
    @HiveField(1) required this.type,
    @HiveField(2) required this.recordTime,
    @HiveField(3) required this.durationMinutes,
    @HiveField(4) this.calories,
    @HiveField(5) this.distance,
    @HiveField(6) this.notes,
    @HiveField(7) this.intensity = 1,
    @HiveField(8) required this.createdAt,
    @HiveField(9) this.updatedAt,
  });

  factory _$ExerciseRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExerciseRecordImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final ExerciseType type;
  @override
  @HiveField(2)
  final DateTime recordTime;
  @override
  @HiveField(3)
  final int durationMinutes;
  // 运动时长（分钟）
  @override
  @HiveField(4)
  final double? calories;
  // 消耗的卡路里
  @override
  @HiveField(5)
  final double? distance;
  // 距离（公里，适用于跑步、骑行等）
  @override
  @HiveField(6)
  final String? notes;
  // 备注
  @override
  @JsonKey()
  @HiveField(7)
  final int intensity;
  // 强度等级 1-5
  @override
  @HiveField(8)
  final DateTime createdAt;
  @override
  @HiveField(9)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ExerciseRecord(id: $id, type: $type, recordTime: $recordTime, durationMinutes: $durationMinutes, calories: $calories, distance: $distance, notes: $notes, intensity: $intensity, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExerciseRecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.recordTime, recordTime) ||
                other.recordTime == recordTime) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.calories, calories) ||
                other.calories == calories) &&
            (identical(other.distance, distance) ||
                other.distance == distance) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.intensity, intensity) ||
                other.intensity == intensity) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    type,
    recordTime,
    durationMinutes,
    calories,
    distance,
    notes,
    intensity,
    createdAt,
    updatedAt,
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExerciseRecordImplCopyWith<_$ExerciseRecordImpl> get copyWith =>
      __$$ExerciseRecordImplCopyWithImpl<_$ExerciseRecordImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ExerciseRecordImplToJson(this);
  }
}

abstract class _ExerciseRecord implements ExerciseRecord {
  const factory _ExerciseRecord({
    @HiveField(0) required final String id,
    @HiveField(1) required final ExerciseType type,
    @HiveField(2) required final DateTime recordTime,
    @HiveField(3) required final int durationMinutes,
    @HiveField(4) final double? calories,
    @HiveField(5) final double? distance,
    @HiveField(6) final String? notes,
    @HiveField(7) final int intensity,
    @HiveField(8) required final DateTime createdAt,
    @HiveField(9) final DateTime? updatedAt,
  }) = _$ExerciseRecordImpl;

  factory _ExerciseRecord.fromJson(Map<String, dynamic> json) =
      _$ExerciseRecordImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  ExerciseType get type;
  @override
  @HiveField(2)
  DateTime get recordTime;
  @override
  @HiveField(3)
  int get durationMinutes;
  @override // 运动时长（分钟）
  @HiveField(4)
  double? get calories;
  @override // 消耗的卡路里
  @HiveField(5)
  double? get distance;
  @override // 距离（公里，适用于跑步、骑行等）
  @HiveField(6)
  String? get notes;
  @override // 备注
  @HiveField(7)
  int get intensity;
  @override // 强度等级 1-5
  @HiveField(8)
  DateTime get createdAt;
  @override
  @HiveField(9)
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$ExerciseRecordImplCopyWith<_$ExerciseRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
