// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'food_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FoodRecord _$FoodRecordFromJson(Map<String, dynamic> json) {
  return _FoodRecord.fromJson(json);
}

/// @nodoc
mixin _$FoodRecord {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get foodId => throw _privateConstructorUsedError; // 关联的食物ID
  @HiveField(2)
  String get foodName => throw _privateConstructorUsedError; // 食物名称
  @HiveField(3)
  DateTime get recordTime => throw _privateConstructorUsedError;
  @HiveField(4)
  double get quantity => throw _privateConstructorUsedError; // 数量（克或毫升）
  @HiveField(5)
  String get unit => throw _privateConstructorUsedError; // 单位：g/ml/份
  @HiveField(6)
  String? get mealType => throw _privateConstructorUsedError; // 餐次：早餐/午餐/晚餐/加餐
  @HiveField(7)
  String? get notes => throw _privateConstructorUsedError; // 备注
  @HiveField(8)
  Map<String, dynamic>? get nutrition => throw _privateConstructorUsedError; // 营养成分（快照）
  @HiveField(9)
  double? get calories => throw _privateConstructorUsedError; // 卡路里
  @HiveField(10)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @HiveField(11)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FoodRecordCopyWith<FoodRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FoodRecordCopyWith<$Res> {
  factory $FoodRecordCopyWith(
    FoodRecord value,
    $Res Function(FoodRecord) then,
  ) = _$FoodRecordCopyWithImpl<$Res, FoodRecord>;
  @useResult
  $Res call({
    @HiveField(0) String id,
    @HiveField(1) String foodId,
    @HiveField(2) String foodName,
    @HiveField(3) DateTime recordTime,
    @HiveField(4) double quantity,
    @HiveField(5) String unit,
    @HiveField(6) String? mealType,
    @HiveField(7) String? notes,
    @HiveField(8) Map<String, dynamic>? nutrition,
    @HiveField(9) double? calories,
    @HiveField(10) DateTime createdAt,
    @HiveField(11) DateTime? updatedAt,
  });
}

/// @nodoc
class _$FoodRecordCopyWithImpl<$Res, $Val extends FoodRecord>
    implements $FoodRecordCopyWith<$Res> {
  _$FoodRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? foodId = null,
    Object? foodName = null,
    Object? recordTime = null,
    Object? quantity = null,
    Object? unit = null,
    Object? mealType = freezed,
    Object? notes = freezed,
    Object? nutrition = freezed,
    Object? calories = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            foodId: null == foodId
                ? _value.foodId
                : foodId // ignore: cast_nullable_to_non_nullable
                      as String,
            foodName: null == foodName
                ? _value.foodName
                : foodName // ignore: cast_nullable_to_non_nullable
                      as String,
            recordTime: null == recordTime
                ? _value.recordTime
                : recordTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as double,
            unit: null == unit
                ? _value.unit
                : unit // ignore: cast_nullable_to_non_nullable
                      as String,
            mealType: freezed == mealType
                ? _value.mealType
                : mealType // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            nutrition: freezed == nutrition
                ? _value.nutrition
                : nutrition // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            calories: freezed == calories
                ? _value.calories
                : calories // ignore: cast_nullable_to_non_nullable
                      as double?,
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
abstract class _$$FoodRecordImplCopyWith<$Res>
    implements $FoodRecordCopyWith<$Res> {
  factory _$$FoodRecordImplCopyWith(
    _$FoodRecordImpl value,
    $Res Function(_$FoodRecordImpl) then,
  ) = __$$FoodRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @HiveField(0) String id,
    @HiveField(1) String foodId,
    @HiveField(2) String foodName,
    @HiveField(3) DateTime recordTime,
    @HiveField(4) double quantity,
    @HiveField(5) String unit,
    @HiveField(6) String? mealType,
    @HiveField(7) String? notes,
    @HiveField(8) Map<String, dynamic>? nutrition,
    @HiveField(9) double? calories,
    @HiveField(10) DateTime createdAt,
    @HiveField(11) DateTime? updatedAt,
  });
}

/// @nodoc
class __$$FoodRecordImplCopyWithImpl<$Res>
    extends _$FoodRecordCopyWithImpl<$Res, _$FoodRecordImpl>
    implements _$$FoodRecordImplCopyWith<$Res> {
  __$$FoodRecordImplCopyWithImpl(
    _$FoodRecordImpl _value,
    $Res Function(_$FoodRecordImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? foodId = null,
    Object? foodName = null,
    Object? recordTime = null,
    Object? quantity = null,
    Object? unit = null,
    Object? mealType = freezed,
    Object? notes = freezed,
    Object? nutrition = freezed,
    Object? calories = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$FoodRecordImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        foodId: null == foodId
            ? _value.foodId
            : foodId // ignore: cast_nullable_to_non_nullable
                  as String,
        foodName: null == foodName
            ? _value.foodName
            : foodName // ignore: cast_nullable_to_non_nullable
                  as String,
        recordTime: null == recordTime
            ? _value.recordTime
            : recordTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as double,
        unit: null == unit
            ? _value.unit
            : unit // ignore: cast_nullable_to_non_nullable
                  as String,
        mealType: freezed == mealType
            ? _value.mealType
            : mealType // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        nutrition: freezed == nutrition
            ? _value._nutrition
            : nutrition // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        calories: freezed == calories
            ? _value.calories
            : calories // ignore: cast_nullable_to_non_nullable
                  as double?,
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
class _$FoodRecordImpl implements _FoodRecord {
  const _$FoodRecordImpl({
    @HiveField(0) required this.id,
    @HiveField(1) required this.foodId,
    @HiveField(2) required this.foodName,
    @HiveField(3) required this.recordTime,
    @HiveField(4) this.quantity = 100.0,
    @HiveField(5) this.unit = 'g',
    @HiveField(6) this.mealType,
    @HiveField(7) this.notes,
    @HiveField(8) final Map<String, dynamic>? nutrition,
    @HiveField(9) this.calories,
    @HiveField(10) required this.createdAt,
    @HiveField(11) this.updatedAt,
  }) : _nutrition = nutrition;

  factory _$FoodRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$FoodRecordImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String foodId;
  // 关联的食物ID
  @override
  @HiveField(2)
  final String foodName;
  // 食物名称
  @override
  @HiveField(3)
  final DateTime recordTime;
  @override
  @JsonKey()
  @HiveField(4)
  final double quantity;
  // 数量（克或毫升）
  @override
  @JsonKey()
  @HiveField(5)
  final String unit;
  // 单位：g/ml/份
  @override
  @HiveField(6)
  final String? mealType;
  // 餐次：早餐/午餐/晚餐/加餐
  @override
  @HiveField(7)
  final String? notes;
  // 备注
  final Map<String, dynamic>? _nutrition;
  // 备注
  @override
  @HiveField(8)
  Map<String, dynamic>? get nutrition {
    final value = _nutrition;
    if (value == null) return null;
    if (_nutrition is EqualUnmodifiableMapView) return _nutrition;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  // 营养成分（快照）
  @override
  @HiveField(9)
  final double? calories;
  // 卡路里
  @override
  @HiveField(10)
  final DateTime createdAt;
  @override
  @HiveField(11)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'FoodRecord(id: $id, foodId: $foodId, foodName: $foodName, recordTime: $recordTime, quantity: $quantity, unit: $unit, mealType: $mealType, notes: $notes, nutrition: $nutrition, calories: $calories, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FoodRecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.foodId, foodId) || other.foodId == foodId) &&
            (identical(other.foodName, foodName) ||
                other.foodName == foodName) &&
            (identical(other.recordTime, recordTime) ||
                other.recordTime == recordTime) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.mealType, mealType) ||
                other.mealType == mealType) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(
              other._nutrition,
              _nutrition,
            ) &&
            (identical(other.calories, calories) ||
                other.calories == calories) &&
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
    foodId,
    foodName,
    recordTime,
    quantity,
    unit,
    mealType,
    notes,
    const DeepCollectionEquality().hash(_nutrition),
    calories,
    createdAt,
    updatedAt,
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FoodRecordImplCopyWith<_$FoodRecordImpl> get copyWith =>
      __$$FoodRecordImplCopyWithImpl<_$FoodRecordImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FoodRecordImplToJson(this);
  }
}

abstract class _FoodRecord implements FoodRecord {
  const factory _FoodRecord({
    @HiveField(0) required final String id,
    @HiveField(1) required final String foodId,
    @HiveField(2) required final String foodName,
    @HiveField(3) required final DateTime recordTime,
    @HiveField(4) final double quantity,
    @HiveField(5) final String unit,
    @HiveField(6) final String? mealType,
    @HiveField(7) final String? notes,
    @HiveField(8) final Map<String, dynamic>? nutrition,
    @HiveField(9) final double? calories,
    @HiveField(10) required final DateTime createdAt,
    @HiveField(11) final DateTime? updatedAt,
  }) = _$FoodRecordImpl;

  factory _FoodRecord.fromJson(Map<String, dynamic> json) =
      _$FoodRecordImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get foodId;
  @override // 关联的食物ID
  @HiveField(2)
  String get foodName;
  @override // 食物名称
  @HiveField(3)
  DateTime get recordTime;
  @override
  @HiveField(4)
  double get quantity;
  @override // 数量（克或毫升）
  @HiveField(5)
  String get unit;
  @override // 单位：g/ml/份
  @HiveField(6)
  String? get mealType;
  @override // 餐次：早餐/午餐/晚餐/加餐
  @HiveField(7)
  String? get notes;
  @override // 备注
  @HiveField(8)
  Map<String, dynamic>? get nutrition;
  @override // 营养成分（快照）
  @HiveField(9)
  double? get calories;
  @override // 卡路里
  @HiveField(10)
  DateTime get createdAt;
  @override
  @HiveField(11)
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$FoodRecordImplCopyWith<_$FoodRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
