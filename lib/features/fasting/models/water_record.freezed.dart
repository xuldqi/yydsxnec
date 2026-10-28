// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'water_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

WaterRecord _$WaterRecordFromJson(Map<String, dynamic> json) {
  return _WaterRecord.fromJson(json);
}

/// @nodoc
mixin _$WaterRecord {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  double get amount => throw _privateConstructorUsedError; // 毫升
  @HiveField(2)
  WaterType get type => throw _privateConstructorUsedError;
  @HiveField(3)
  DateTime get recordTime => throw _privateConstructorUsedError;
  @HiveField(4)
  String? get notes => throw _privateConstructorUsedError;
  @HiveField(5)
  double get temperature => throw _privateConstructorUsedError; // 温度（摄氏度）
  @HiveField(6)
  bool get isReminder => throw _privateConstructorUsedError; // 是否通过提醒记录
  @HiveField(7)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @HiveField(8)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WaterRecordCopyWith<WaterRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WaterRecordCopyWith<$Res> {
  factory $WaterRecordCopyWith(
    WaterRecord value,
    $Res Function(WaterRecord) then,
  ) = _$WaterRecordCopyWithImpl<$Res, WaterRecord>;
  @useResult
  $Res call({
    @HiveField(0) String id,
    @HiveField(1) double amount,
    @HiveField(2) WaterType type,
    @HiveField(3) DateTime recordTime,
    @HiveField(4) String? notes,
    @HiveField(5) double temperature,
    @HiveField(6) bool isReminder,
    @HiveField(7) DateTime createdAt,
    @HiveField(8) DateTime? updatedAt,
  });
}

/// @nodoc
class _$WaterRecordCopyWithImpl<$Res, $Val extends WaterRecord>
    implements $WaterRecordCopyWith<$Res> {
  _$WaterRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? amount = null,
    Object? type = null,
    Object? recordTime = null,
    Object? notes = freezed,
    Object? temperature = null,
    Object? isReminder = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as WaterType,
            recordTime: null == recordTime
                ? _value.recordTime
                : recordTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            temperature: null == temperature
                ? _value.temperature
                : temperature // ignore: cast_nullable_to_non_nullable
                      as double,
            isReminder: null == isReminder
                ? _value.isReminder
                : isReminder // ignore: cast_nullable_to_non_nullable
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
abstract class _$$WaterRecordImplCopyWith<$Res>
    implements $WaterRecordCopyWith<$Res> {
  factory _$$WaterRecordImplCopyWith(
    _$WaterRecordImpl value,
    $Res Function(_$WaterRecordImpl) then,
  ) = __$$WaterRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @HiveField(0) String id,
    @HiveField(1) double amount,
    @HiveField(2) WaterType type,
    @HiveField(3) DateTime recordTime,
    @HiveField(4) String? notes,
    @HiveField(5) double temperature,
    @HiveField(6) bool isReminder,
    @HiveField(7) DateTime createdAt,
    @HiveField(8) DateTime? updatedAt,
  });
}

/// @nodoc
class __$$WaterRecordImplCopyWithImpl<$Res>
    extends _$WaterRecordCopyWithImpl<$Res, _$WaterRecordImpl>
    implements _$$WaterRecordImplCopyWith<$Res> {
  __$$WaterRecordImplCopyWithImpl(
    _$WaterRecordImpl _value,
    $Res Function(_$WaterRecordImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? amount = null,
    Object? type = null,
    Object? recordTime = null,
    Object? notes = freezed,
    Object? temperature = null,
    Object? isReminder = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$WaterRecordImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as WaterType,
        recordTime: null == recordTime
            ? _value.recordTime
            : recordTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        temperature: null == temperature
            ? _value.temperature
            : temperature // ignore: cast_nullable_to_non_nullable
                  as double,
        isReminder: null == isReminder
            ? _value.isReminder
            : isReminder // ignore: cast_nullable_to_non_nullable
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
class _$WaterRecordImpl implements _WaterRecord {
  const _$WaterRecordImpl({
    @HiveField(0) required this.id,
    @HiveField(1) required this.amount,
    @HiveField(2) this.type = WaterType.water,
    @HiveField(3) required this.recordTime,
    @HiveField(4) this.notes,
    @HiveField(5) this.temperature = 0.0,
    @HiveField(6) this.isReminder = false,
    @HiveField(7) required this.createdAt,
    @HiveField(8) this.updatedAt,
  });

  factory _$WaterRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$WaterRecordImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final double amount;
  // 毫升
  @override
  @JsonKey()
  @HiveField(2)
  final WaterType type;
  @override
  @HiveField(3)
  final DateTime recordTime;
  @override
  @HiveField(4)
  final String? notes;
  @override
  @JsonKey()
  @HiveField(5)
  final double temperature;
  // 温度（摄氏度）
  @override
  @JsonKey()
  @HiveField(6)
  final bool isReminder;
  // 是否通过提醒记录
  @override
  @HiveField(7)
  final DateTime createdAt;
  @override
  @HiveField(8)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'WaterRecord(id: $id, amount: $amount, type: $type, recordTime: $recordTime, notes: $notes, temperature: $temperature, isReminder: $isReminder, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WaterRecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.recordTime, recordTime) ||
                other.recordTime == recordTime) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.temperature, temperature) ||
                other.temperature == temperature) &&
            (identical(other.isReminder, isReminder) ||
                other.isReminder == isReminder) &&
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
    amount,
    type,
    recordTime,
    notes,
    temperature,
    isReminder,
    createdAt,
    updatedAt,
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WaterRecordImplCopyWith<_$WaterRecordImpl> get copyWith =>
      __$$WaterRecordImplCopyWithImpl<_$WaterRecordImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WaterRecordImplToJson(this);
  }
}

abstract class _WaterRecord implements WaterRecord {
  const factory _WaterRecord({
    @HiveField(0) required final String id,
    @HiveField(1) required final double amount,
    @HiveField(2) final WaterType type,
    @HiveField(3) required final DateTime recordTime,
    @HiveField(4) final String? notes,
    @HiveField(5) final double temperature,
    @HiveField(6) final bool isReminder,
    @HiveField(7) required final DateTime createdAt,
    @HiveField(8) final DateTime? updatedAt,
  }) = _$WaterRecordImpl;

  factory _WaterRecord.fromJson(Map<String, dynamic> json) =
      _$WaterRecordImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  double get amount;
  @override // 毫升
  @HiveField(2)
  WaterType get type;
  @override
  @HiveField(3)
  DateTime get recordTime;
  @override
  @HiveField(4)
  String? get notes;
  @override
  @HiveField(5)
  double get temperature;
  @override // 温度（摄氏度）
  @HiveField(6)
  bool get isReminder;
  @override // 是否通过提醒记录
  @HiveField(7)
  DateTime get createdAt;
  @override
  @HiveField(8)
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$WaterRecordImplCopyWith<_$WaterRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
