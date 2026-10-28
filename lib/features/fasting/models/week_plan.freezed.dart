// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'week_plan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

WeekPlan _$WeekPlanFromJson(Map<String, dynamic> json) {
  return _WeekPlan.fromJson(json);
}

/// @nodoc
mixin _$WeekPlan {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get name => throw _privateConstructorUsedError;
  @HiveField(2)
  String get planId => throw _privateConstructorUsedError; // 关联的断食计划ID
  @HiveField(3)
  List<int> get fastingDays => throw _privateConstructorUsedError; // 断食日（1-7，1=周一）
  @HiveField(4)
  List<int> get restDays => throw _privateConstructorUsedError; // 休息日（1-7）
  @HiveField(5)
  bool get isActive => throw _privateConstructorUsedError;
  @HiveField(6)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @HiveField(7)
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @HiveField(8)
  String? get notes => throw _privateConstructorUsedError; // 备注
  @HiveField(9)
  List<int> get lowCalorieDays => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WeekPlanCopyWith<WeekPlan> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeekPlanCopyWith<$Res> {
  factory $WeekPlanCopyWith(WeekPlan value, $Res Function(WeekPlan) then) =
      _$WeekPlanCopyWithImpl<$Res, WeekPlan>;
  @useResult
  $Res call({
    @HiveField(0) String id,
    @HiveField(1) String name,
    @HiveField(2) String planId,
    @HiveField(3) List<int> fastingDays,
    @HiveField(4) List<int> restDays,
    @HiveField(5) bool isActive,
    @HiveField(6) DateTime createdAt,
    @HiveField(7) DateTime? updatedAt,
    @HiveField(8) String? notes,
    @HiveField(9) List<int> lowCalorieDays,
  });
}

/// @nodoc
class _$WeekPlanCopyWithImpl<$Res, $Val extends WeekPlan>
    implements $WeekPlanCopyWith<$Res> {
  _$WeekPlanCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? planId = null,
    Object? fastingDays = null,
    Object? restDays = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? notes = freezed,
    Object? lowCalorieDays = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            planId: null == planId
                ? _value.planId
                : planId // ignore: cast_nullable_to_non_nullable
                      as String,
            fastingDays: null == fastingDays
                ? _value.fastingDays
                : fastingDays // ignore: cast_nullable_to_non_nullable
                      as List<int>,
            restDays: null == restDays
                ? _value.restDays
                : restDays // ignore: cast_nullable_to_non_nullable
                      as List<int>,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            lowCalorieDays: null == lowCalorieDays
                ? _value.lowCalorieDays
                : lowCalorieDays // ignore: cast_nullable_to_non_nullable
                      as List<int>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WeekPlanImplCopyWith<$Res>
    implements $WeekPlanCopyWith<$Res> {
  factory _$$WeekPlanImplCopyWith(
    _$WeekPlanImpl value,
    $Res Function(_$WeekPlanImpl) then,
  ) = __$$WeekPlanImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @HiveField(0) String id,
    @HiveField(1) String name,
    @HiveField(2) String planId,
    @HiveField(3) List<int> fastingDays,
    @HiveField(4) List<int> restDays,
    @HiveField(5) bool isActive,
    @HiveField(6) DateTime createdAt,
    @HiveField(7) DateTime? updatedAt,
    @HiveField(8) String? notes,
    @HiveField(9) List<int> lowCalorieDays,
  });
}

/// @nodoc
class __$$WeekPlanImplCopyWithImpl<$Res>
    extends _$WeekPlanCopyWithImpl<$Res, _$WeekPlanImpl>
    implements _$$WeekPlanImplCopyWith<$Res> {
  __$$WeekPlanImplCopyWithImpl(
    _$WeekPlanImpl _value,
    $Res Function(_$WeekPlanImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? planId = null,
    Object? fastingDays = null,
    Object? restDays = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? notes = freezed,
    Object? lowCalorieDays = null,
  }) {
    return _then(
      _$WeekPlanImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        planId: null == planId
            ? _value.planId
            : planId // ignore: cast_nullable_to_non_nullable
                  as String,
        fastingDays: null == fastingDays
            ? _value._fastingDays
            : fastingDays // ignore: cast_nullable_to_non_nullable
                  as List<int>,
        restDays: null == restDays
            ? _value._restDays
            : restDays // ignore: cast_nullable_to_non_nullable
                  as List<int>,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        lowCalorieDays: null == lowCalorieDays
            ? _value._lowCalorieDays
            : lowCalorieDays // ignore: cast_nullable_to_non_nullable
                  as List<int>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WeekPlanImpl implements _WeekPlan {
  const _$WeekPlanImpl({
    @HiveField(0) required this.id,
    @HiveField(1) required this.name,
    @HiveField(2) required this.planId,
    @HiveField(3) final List<int> fastingDays = const [],
    @HiveField(4) final List<int> restDays = const [],
    @HiveField(5) this.isActive = true,
    @HiveField(6) required this.createdAt,
    @HiveField(7) this.updatedAt,
    @HiveField(8) this.notes,
    @HiveField(9) final List<int> lowCalorieDays = const [],
  }) : _fastingDays = fastingDays,
       _restDays = restDays,
       _lowCalorieDays = lowCalorieDays;

  factory _$WeekPlanImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeekPlanImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String name;
  @override
  @HiveField(2)
  final String planId;
  // 关联的断食计划ID
  final List<int> _fastingDays;
  // 关联的断食计划ID
  @override
  @JsonKey()
  @HiveField(3)
  List<int> get fastingDays {
    if (_fastingDays is EqualUnmodifiableListView) return _fastingDays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_fastingDays);
  }

  // 断食日（1-7，1=周一）
  final List<int> _restDays;
  // 断食日（1-7，1=周一）
  @override
  @JsonKey()
  @HiveField(4)
  List<int> get restDays {
    if (_restDays is EqualUnmodifiableListView) return _restDays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_restDays);
  }

  // 休息日（1-7）
  @override
  @JsonKey()
  @HiveField(5)
  final bool isActive;
  @override
  @HiveField(6)
  final DateTime createdAt;
  @override
  @HiveField(7)
  final DateTime? updatedAt;
  @override
  @HiveField(8)
  final String? notes;
  // 备注
  final List<int> _lowCalorieDays;
  // 备注
  @override
  @JsonKey()
  @HiveField(9)
  List<int> get lowCalorieDays {
    if (_lowCalorieDays is EqualUnmodifiableListView) return _lowCalorieDays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lowCalorieDays);
  }

  @override
  String toString() {
    return 'WeekPlan(id: $id, name: $name, planId: $planId, fastingDays: $fastingDays, restDays: $restDays, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, notes: $notes, lowCalorieDays: $lowCalorieDays)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeekPlanImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.planId, planId) || other.planId == planId) &&
            const DeepCollectionEquality().equals(
              other._fastingDays,
              _fastingDays,
            ) &&
            const DeepCollectionEquality().equals(other._restDays, _restDays) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(
              other._lowCalorieDays,
              _lowCalorieDays,
            ));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    planId,
    const DeepCollectionEquality().hash(_fastingDays),
    const DeepCollectionEquality().hash(_restDays),
    isActive,
    createdAt,
    updatedAt,
    notes,
    const DeepCollectionEquality().hash(_lowCalorieDays),
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WeekPlanImplCopyWith<_$WeekPlanImpl> get copyWith =>
      __$$WeekPlanImplCopyWithImpl<_$WeekPlanImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WeekPlanImplToJson(this);
  }
}

abstract class _WeekPlan implements WeekPlan {
  const factory _WeekPlan({
    @HiveField(0) required final String id,
    @HiveField(1) required final String name,
    @HiveField(2) required final String planId,
    @HiveField(3) final List<int> fastingDays,
    @HiveField(4) final List<int> restDays,
    @HiveField(5) final bool isActive,
    @HiveField(6) required final DateTime createdAt,
    @HiveField(7) final DateTime? updatedAt,
    @HiveField(8) final String? notes,
    @HiveField(9) final List<int> lowCalorieDays,
  }) = _$WeekPlanImpl;

  factory _WeekPlan.fromJson(Map<String, dynamic> json) =
      _$WeekPlanImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get name;
  @override
  @HiveField(2)
  String get planId;
  @override // 关联的断食计划ID
  @HiveField(3)
  List<int> get fastingDays;
  @override // 断食日（1-7，1=周一）
  @HiveField(4)
  List<int> get restDays;
  @override // 休息日（1-7）
  @HiveField(5)
  bool get isActive;
  @override
  @HiveField(6)
  DateTime get createdAt;
  @override
  @HiveField(7)
  DateTime? get updatedAt;
  @override
  @HiveField(8)
  String? get notes;
  @override // 备注
  @HiveField(9)
  List<int> get lowCalorieDays;
  @override
  @JsonKey(ignore: true)
  _$$WeekPlanImplCopyWith<_$WeekPlanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
