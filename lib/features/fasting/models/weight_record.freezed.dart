// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weight_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

WeightRecord _$WeightRecordFromJson(Map<String, dynamic> json) {
  return _WeightRecord.fromJson(json);
}

/// @nodoc
mixin _$WeightRecord {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  double get weight => throw _privateConstructorUsedError; // kg
  @HiveField(2)
  DateTime get recordTime => throw _privateConstructorUsedError;
  @HiveField(3)
  String? get notes => throw _privateConstructorUsedError;
  @HiveField(4)
  double get bodyFat => throw _privateConstructorUsedError; // 体脂率
  @HiveField(5)
  double get muscleMass => throw _privateConstructorUsedError; // 肌肉量
  @HiveField(6)
  double get waterPercentage => throw _privateConstructorUsedError; // 水分百分比
  @HiveField(7)
  double get bmi => throw _privateConstructorUsedError; // BMI
  @HiveField(8)
  bool get isTarget => throw _privateConstructorUsedError; // 是否为目标体重
  @HiveField(9)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @HiveField(10)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WeightRecordCopyWith<WeightRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeightRecordCopyWith<$Res> {
  factory $WeightRecordCopyWith(
    WeightRecord value,
    $Res Function(WeightRecord) then,
  ) = _$WeightRecordCopyWithImpl<$Res, WeightRecord>;
  @useResult
  $Res call({
    @HiveField(0) String id,
    @HiveField(1) double weight,
    @HiveField(2) DateTime recordTime,
    @HiveField(3) String? notes,
    @HiveField(4) double bodyFat,
    @HiveField(5) double muscleMass,
    @HiveField(6) double waterPercentage,
    @HiveField(7) double bmi,
    @HiveField(8) bool isTarget,
    @HiveField(9) DateTime createdAt,
    @HiveField(10) DateTime? updatedAt,
  });
}

/// @nodoc
class _$WeightRecordCopyWithImpl<$Res, $Val extends WeightRecord>
    implements $WeightRecordCopyWith<$Res> {
  _$WeightRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? weight = null,
    Object? recordTime = null,
    Object? notes = freezed,
    Object? bodyFat = null,
    Object? muscleMass = null,
    Object? waterPercentage = null,
    Object? bmi = null,
    Object? isTarget = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            weight: null == weight
                ? _value.weight
                : weight // ignore: cast_nullable_to_non_nullable
                      as double,
            recordTime: null == recordTime
                ? _value.recordTime
                : recordTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            bodyFat: null == bodyFat
                ? _value.bodyFat
                : bodyFat // ignore: cast_nullable_to_non_nullable
                      as double,
            muscleMass: null == muscleMass
                ? _value.muscleMass
                : muscleMass // ignore: cast_nullable_to_non_nullable
                      as double,
            waterPercentage: null == waterPercentage
                ? _value.waterPercentage
                : waterPercentage // ignore: cast_nullable_to_non_nullable
                      as double,
            bmi: null == bmi
                ? _value.bmi
                : bmi // ignore: cast_nullable_to_non_nullable
                      as double,
            isTarget: null == isTarget
                ? _value.isTarget
                : isTarget // ignore: cast_nullable_to_non_nullable
                      as bool,
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
abstract class _$$WeightRecordImplCopyWith<$Res>
    implements $WeightRecordCopyWith<$Res> {
  factory _$$WeightRecordImplCopyWith(
    _$WeightRecordImpl value,
    $Res Function(_$WeightRecordImpl) then,
  ) = __$$WeightRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @HiveField(0) String id,
    @HiveField(1) double weight,
    @HiveField(2) DateTime recordTime,
    @HiveField(3) String? notes,
    @HiveField(4) double bodyFat,
    @HiveField(5) double muscleMass,
    @HiveField(6) double waterPercentage,
    @HiveField(7) double bmi,
    @HiveField(8) bool isTarget,
    @HiveField(9) DateTime createdAt,
    @HiveField(10) DateTime? updatedAt,
  });
}

/// @nodoc
class __$$WeightRecordImplCopyWithImpl<$Res>
    extends _$WeightRecordCopyWithImpl<$Res, _$WeightRecordImpl>
    implements _$$WeightRecordImplCopyWith<$Res> {
  __$$WeightRecordImplCopyWithImpl(
    _$WeightRecordImpl _value,
    $Res Function(_$WeightRecordImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? weight = null,
    Object? recordTime = null,
    Object? notes = freezed,
    Object? bodyFat = null,
    Object? muscleMass = null,
    Object? waterPercentage = null,
    Object? bmi = null,
    Object? isTarget = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$WeightRecordImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        weight: null == weight
            ? _value.weight
            : weight // ignore: cast_nullable_to_non_nullable
                  as double,
        recordTime: null == recordTime
            ? _value.recordTime
            : recordTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        bodyFat: null == bodyFat
            ? _value.bodyFat
            : bodyFat // ignore: cast_nullable_to_non_nullable
                  as double,
        muscleMass: null == muscleMass
            ? _value.muscleMass
            : muscleMass // ignore: cast_nullable_to_non_nullable
                  as double,
        waterPercentage: null == waterPercentage
            ? _value.waterPercentage
            : waterPercentage // ignore: cast_nullable_to_non_nullable
                  as double,
        bmi: null == bmi
            ? _value.bmi
            : bmi // ignore: cast_nullable_to_non_nullable
                  as double,
        isTarget: null == isTarget
            ? _value.isTarget
            : isTarget // ignore: cast_nullable_to_non_nullable
                  as bool,
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
class _$WeightRecordImpl implements _WeightRecord {
  const _$WeightRecordImpl({
    @HiveField(0) required this.id,
    @HiveField(1) required this.weight,
    @HiveField(2) required this.recordTime,
    @HiveField(3) this.notes,
    @HiveField(4) this.bodyFat = 0.0,
    @HiveField(5) this.muscleMass = 0.0,
    @HiveField(6) this.waterPercentage = 0.0,
    @HiveField(7) this.bmi = 0.0,
    @HiveField(8) this.isTarget = false,
    @HiveField(9) required this.createdAt,
    @HiveField(10) this.updatedAt,
  });

  factory _$WeightRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeightRecordImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final double weight;
  // kg
  @override
  @HiveField(2)
  final DateTime recordTime;
  @override
  @HiveField(3)
  final String? notes;
  @override
  @JsonKey()
  @HiveField(4)
  final double bodyFat;
  // 体脂率
  @override
  @JsonKey()
  @HiveField(5)
  final double muscleMass;
  // 肌肉量
  @override
  @JsonKey()
  @HiveField(6)
  final double waterPercentage;
  // 水分百分比
  @override
  @JsonKey()
  @HiveField(7)
  final double bmi;
  // BMI
  @override
  @JsonKey()
  @HiveField(8)
  final bool isTarget;
  // 是否为目标体重
  @override
  @HiveField(9)
  final DateTime createdAt;
  @override
  @HiveField(10)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'WeightRecord(id: $id, weight: $weight, recordTime: $recordTime, notes: $notes, bodyFat: $bodyFat, muscleMass: $muscleMass, waterPercentage: $waterPercentage, bmi: $bmi, isTarget: $isTarget, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeightRecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.recordTime, recordTime) ||
                other.recordTime == recordTime) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.bodyFat, bodyFat) || other.bodyFat == bodyFat) &&
            (identical(other.muscleMass, muscleMass) ||
                other.muscleMass == muscleMass) &&
            (identical(other.waterPercentage, waterPercentage) ||
                other.waterPercentage == waterPercentage) &&
            (identical(other.bmi, bmi) || other.bmi == bmi) &&
            (identical(other.isTarget, isTarget) ||
                other.isTarget == isTarget) &&
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
    weight,
    recordTime,
    notes,
    bodyFat,
    muscleMass,
    waterPercentage,
    bmi,
    isTarget,
    createdAt,
    updatedAt,
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WeightRecordImplCopyWith<_$WeightRecordImpl> get copyWith =>
      __$$WeightRecordImplCopyWithImpl<_$WeightRecordImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WeightRecordImplToJson(this);
  }
}

abstract class _WeightRecord implements WeightRecord {
  const factory _WeightRecord({
    @HiveField(0) required final String id,
    @HiveField(1) required final double weight,
    @HiveField(2) required final DateTime recordTime,
    @HiveField(3) final String? notes,
    @HiveField(4) final double bodyFat,
    @HiveField(5) final double muscleMass,
    @HiveField(6) final double waterPercentage,
    @HiveField(7) final double bmi,
    @HiveField(8) final bool isTarget,
    @HiveField(9) required final DateTime createdAt,
    @HiveField(10) final DateTime? updatedAt,
  }) = _$WeightRecordImpl;

  factory _WeightRecord.fromJson(Map<String, dynamic> json) =
      _$WeightRecordImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  double get weight;
  @override // kg
  @HiveField(2)
  DateTime get recordTime;
  @override
  @HiveField(3)
  String? get notes;
  @override
  @HiveField(4)
  double get bodyFat;
  @override // 体脂率
  @HiveField(5)
  double get muscleMass;
  @override // 肌肉量
  @HiveField(6)
  double get waterPercentage;
  @override // 水分百分比
  @HiveField(7)
  double get bmi;
  @override // BMI
  @HiveField(8)
  bool get isTarget;
  @override // 是否为目标体重
  @HiveField(9)
  DateTime get createdAt;
  @override
  @HiveField(10)
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$WeightRecordImplCopyWith<_$WeightRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
