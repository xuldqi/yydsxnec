// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fasting_plan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FastingPlan _$FastingPlanFromJson(Map<String, dynamic> json) {
  return _FastingPlan.fromJson(json);
}

/// @nodoc
mixin _$FastingPlan {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get name => throw _privateConstructorUsedError;
  @HiveField(2)
  String get description => throw _privateConstructorUsedError;
  @HiveField(3)
  int get fastingHours => throw _privateConstructorUsedError;
  @HiveField(4)
  int get eatingHours => throw _privateConstructorUsedError;
  @HiveField(5)
  FastingDifficulty get difficulty => throw _privateConstructorUsedError;
  @HiveField(6)
  bool get isCustom => throw _privateConstructorUsedError;
  @HiveField(7)
  bool get isActive => throw _privateConstructorUsedError;
  @HiveField(8)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @HiveField(9)
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @HiveField(10)
  String? get tips => throw _privateConstructorUsedError;
  @HiveField(11)
  List<String> get benefits => throw _privateConstructorUsedError;
  @HiveField(12)
  List<String> get precautions => throw _privateConstructorUsedError;
  @HiveField(13)
  int get successCount => throw _privateConstructorUsedError;
  @HiveField(14)
  int get totalAttempts => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FastingPlanCopyWith<FastingPlan> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FastingPlanCopyWith<$Res> {
  factory $FastingPlanCopyWith(
    FastingPlan value,
    $Res Function(FastingPlan) then,
  ) = _$FastingPlanCopyWithImpl<$Res, FastingPlan>;
  @useResult
  $Res call({
    @HiveField(0) String id,
    @HiveField(1) String name,
    @HiveField(2) String description,
    @HiveField(3) int fastingHours,
    @HiveField(4) int eatingHours,
    @HiveField(5) FastingDifficulty difficulty,
    @HiveField(6) bool isCustom,
    @HiveField(7) bool isActive,
    @HiveField(8) DateTime createdAt,
    @HiveField(9) DateTime? updatedAt,
    @HiveField(10) String? tips,
    @HiveField(11) List<String> benefits,
    @HiveField(12) List<String> precautions,
    @HiveField(13) int successCount,
    @HiveField(14) int totalAttempts,
  });
}

/// @nodoc
class _$FastingPlanCopyWithImpl<$Res, $Val extends FastingPlan>
    implements $FastingPlanCopyWith<$Res> {
  _$FastingPlanCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? fastingHours = null,
    Object? eatingHours = null,
    Object? difficulty = null,
    Object? isCustom = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? tips = freezed,
    Object? benefits = null,
    Object? precautions = null,
    Object? successCount = null,
    Object? totalAttempts = null,
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
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            fastingHours: null == fastingHours
                ? _value.fastingHours
                : fastingHours // ignore: cast_nullable_to_non_nullable
                      as int,
            eatingHours: null == eatingHours
                ? _value.eatingHours
                : eatingHours // ignore: cast_nullable_to_non_nullable
                      as int,
            difficulty: null == difficulty
                ? _value.difficulty
                : difficulty // ignore: cast_nullable_to_non_nullable
                      as FastingDifficulty,
            isCustom: null == isCustom
                ? _value.isCustom
                : isCustom // ignore: cast_nullable_to_non_nullable
                      as bool,
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
            tips: freezed == tips
                ? _value.tips
                : tips // ignore: cast_nullable_to_non_nullable
                      as String?,
            benefits: null == benefits
                ? _value.benefits
                : benefits // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            precautions: null == precautions
                ? _value.precautions
                : precautions // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            successCount: null == successCount
                ? _value.successCount
                : successCount // ignore: cast_nullable_to_non_nullable
                      as int,
            totalAttempts: null == totalAttempts
                ? _value.totalAttempts
                : totalAttempts // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FastingPlanImplCopyWith<$Res>
    implements $FastingPlanCopyWith<$Res> {
  factory _$$FastingPlanImplCopyWith(
    _$FastingPlanImpl value,
    $Res Function(_$FastingPlanImpl) then,
  ) = __$$FastingPlanImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @HiveField(0) String id,
    @HiveField(1) String name,
    @HiveField(2) String description,
    @HiveField(3) int fastingHours,
    @HiveField(4) int eatingHours,
    @HiveField(5) FastingDifficulty difficulty,
    @HiveField(6) bool isCustom,
    @HiveField(7) bool isActive,
    @HiveField(8) DateTime createdAt,
    @HiveField(9) DateTime? updatedAt,
    @HiveField(10) String? tips,
    @HiveField(11) List<String> benefits,
    @HiveField(12) List<String> precautions,
    @HiveField(13) int successCount,
    @HiveField(14) int totalAttempts,
  });
}

/// @nodoc
class __$$FastingPlanImplCopyWithImpl<$Res>
    extends _$FastingPlanCopyWithImpl<$Res, _$FastingPlanImpl>
    implements _$$FastingPlanImplCopyWith<$Res> {
  __$$FastingPlanImplCopyWithImpl(
    _$FastingPlanImpl _value,
    $Res Function(_$FastingPlanImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? fastingHours = null,
    Object? eatingHours = null,
    Object? difficulty = null,
    Object? isCustom = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? tips = freezed,
    Object? benefits = null,
    Object? precautions = null,
    Object? successCount = null,
    Object? totalAttempts = null,
  }) {
    return _then(
      _$FastingPlanImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        fastingHours: null == fastingHours
            ? _value.fastingHours
            : fastingHours // ignore: cast_nullable_to_non_nullable
                  as int,
        eatingHours: null == eatingHours
            ? _value.eatingHours
            : eatingHours // ignore: cast_nullable_to_non_nullable
                  as int,
        difficulty: null == difficulty
            ? _value.difficulty
            : difficulty // ignore: cast_nullable_to_non_nullable
                  as FastingDifficulty,
        isCustom: null == isCustom
            ? _value.isCustom
            : isCustom // ignore: cast_nullable_to_non_nullable
                  as bool,
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
        tips: freezed == tips
            ? _value.tips
            : tips // ignore: cast_nullable_to_non_nullable
                  as String?,
        benefits: null == benefits
            ? _value._benefits
            : benefits // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        precautions: null == precautions
            ? _value._precautions
            : precautions // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        successCount: null == successCount
            ? _value.successCount
            : successCount // ignore: cast_nullable_to_non_nullable
                  as int,
        totalAttempts: null == totalAttempts
            ? _value.totalAttempts
            : totalAttempts // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FastingPlanImpl implements _FastingPlan {
  const _$FastingPlanImpl({
    @HiveField(0) required this.id,
    @HiveField(1) required this.name,
    @HiveField(2) required this.description,
    @HiveField(3) required this.fastingHours,
    @HiveField(4) required this.eatingHours,
    @HiveField(5) required this.difficulty,
    @HiveField(6) this.isCustom = false,
    @HiveField(7) this.isActive = true,
    @HiveField(8) required this.createdAt,
    @HiveField(9) this.updatedAt,
    @HiveField(10) this.tips,
    @HiveField(11) final List<String> benefits = const [],
    @HiveField(12) final List<String> precautions = const [],
    @HiveField(13) this.successCount = 0,
    @HiveField(14) this.totalAttempts = 0,
  }) : _benefits = benefits,
       _precautions = precautions;

  factory _$FastingPlanImpl.fromJson(Map<String, dynamic> json) =>
      _$$FastingPlanImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String name;
  @override
  @HiveField(2)
  final String description;
  @override
  @HiveField(3)
  final int fastingHours;
  @override
  @HiveField(4)
  final int eatingHours;
  @override
  @HiveField(5)
  final FastingDifficulty difficulty;
  @override
  @JsonKey()
  @HiveField(6)
  final bool isCustom;
  @override
  @JsonKey()
  @HiveField(7)
  final bool isActive;
  @override
  @HiveField(8)
  final DateTime createdAt;
  @override
  @HiveField(9)
  final DateTime? updatedAt;
  @override
  @HiveField(10)
  final String? tips;
  final List<String> _benefits;
  @override
  @JsonKey()
  @HiveField(11)
  List<String> get benefits {
    if (_benefits is EqualUnmodifiableListView) return _benefits;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_benefits);
  }

  final List<String> _precautions;
  @override
  @JsonKey()
  @HiveField(12)
  List<String> get precautions {
    if (_precautions is EqualUnmodifiableListView) return _precautions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_precautions);
  }

  @override
  @JsonKey()
  @HiveField(13)
  final int successCount;
  @override
  @JsonKey()
  @HiveField(14)
  final int totalAttempts;

  @override
  String toString() {
    return 'FastingPlan(id: $id, name: $name, description: $description, fastingHours: $fastingHours, eatingHours: $eatingHours, difficulty: $difficulty, isCustom: $isCustom, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, tips: $tips, benefits: $benefits, precautions: $precautions, successCount: $successCount, totalAttempts: $totalAttempts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FastingPlanImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.fastingHours, fastingHours) ||
                other.fastingHours == fastingHours) &&
            (identical(other.eatingHours, eatingHours) ||
                other.eatingHours == eatingHours) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(other.isCustom, isCustom) ||
                other.isCustom == isCustom) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.tips, tips) || other.tips == tips) &&
            const DeepCollectionEquality().equals(other._benefits, _benefits) &&
            const DeepCollectionEquality().equals(
              other._precautions,
              _precautions,
            ) &&
            (identical(other.successCount, successCount) ||
                other.successCount == successCount) &&
            (identical(other.totalAttempts, totalAttempts) ||
                other.totalAttempts == totalAttempts));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    description,
    fastingHours,
    eatingHours,
    difficulty,
    isCustom,
    isActive,
    createdAt,
    updatedAt,
    tips,
    const DeepCollectionEquality().hash(_benefits),
    const DeepCollectionEquality().hash(_precautions),
    successCount,
    totalAttempts,
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FastingPlanImplCopyWith<_$FastingPlanImpl> get copyWith =>
      __$$FastingPlanImplCopyWithImpl<_$FastingPlanImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FastingPlanImplToJson(this);
  }
}

abstract class _FastingPlan implements FastingPlan {
  const factory _FastingPlan({
    @HiveField(0) required final String id,
    @HiveField(1) required final String name,
    @HiveField(2) required final String description,
    @HiveField(3) required final int fastingHours,
    @HiveField(4) required final int eatingHours,
    @HiveField(5) required final FastingDifficulty difficulty,
    @HiveField(6) final bool isCustom,
    @HiveField(7) final bool isActive,
    @HiveField(8) required final DateTime createdAt,
    @HiveField(9) final DateTime? updatedAt,
    @HiveField(10) final String? tips,
    @HiveField(11) final List<String> benefits,
    @HiveField(12) final List<String> precautions,
    @HiveField(13) final int successCount,
    @HiveField(14) final int totalAttempts,
  }) = _$FastingPlanImpl;

  factory _FastingPlan.fromJson(Map<String, dynamic> json) =
      _$FastingPlanImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get name;
  @override
  @HiveField(2)
  String get description;
  @override
  @HiveField(3)
  int get fastingHours;
  @override
  @HiveField(4)
  int get eatingHours;
  @override
  @HiveField(5)
  FastingDifficulty get difficulty;
  @override
  @HiveField(6)
  bool get isCustom;
  @override
  @HiveField(7)
  bool get isActive;
  @override
  @HiveField(8)
  DateTime get createdAt;
  @override
  @HiveField(9)
  DateTime? get updatedAt;
  @override
  @HiveField(10)
  String? get tips;
  @override
  @HiveField(11)
  List<String> get benefits;
  @override
  @HiveField(12)
  List<String> get precautions;
  @override
  @HiveField(13)
  int get successCount;
  @override
  @HiveField(14)
  int get totalAttempts;
  @override
  @JsonKey(ignore: true)
  _$$FastingPlanImplCopyWith<_$FastingPlanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
