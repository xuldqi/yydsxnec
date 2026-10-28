// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fasting_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FastingSession _$FastingSessionFromJson(Map<String, dynamic> json) {
  return _FastingSession.fromJson(json);
}

/// @nodoc
mixin _$FastingSession {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get planId => throw _privateConstructorUsedError;
  @HiveField(2)
  DateTime get startTime => throw _privateConstructorUsedError;
  @HiveField(3)
  DateTime? get endTime => throw _privateConstructorUsedError;
  @HiveField(4)
  DateTime? get plannedEndTime => throw _privateConstructorUsedError;
  @HiveField(5)
  FastingStatus get status => throw _privateConstructorUsedError;
  @HiveField(6)
  int get fastingHours => throw _privateConstructorUsedError;
  @HiveField(7)
  int get eatingHours => throw _privateConstructorUsedError;
  @HiveField(8)
  String? get notes => throw _privateConstructorUsedError;
  @HiveField(9)
  double get startWeight => throw _privateConstructorUsedError;
  @HiveField(10)
  double get endWeight => throw _privateConstructorUsedError;
  @HiveField(11)
  int get difficultyRating => throw _privateConstructorUsedError; // 1-5星难度评价
  @HiveField(12)
  int get satisfactionRating => throw _privateConstructorUsedError; // 1-5星满意度评价
  @HiveField(13)
  List<String> get symptoms => throw _privateConstructorUsedError; // 断食期间的症状
  @HiveField(14)
  List<String> get benefits => throw _privateConstructorUsedError; // 感受到的益处
  @HiveField(15)
  DateTime? get lastPauseTime => throw _privateConstructorUsedError;
  @HiveField(16)
  int get totalPauseDuration => throw _privateConstructorUsedError; // 总暂停时长（分钟）
  @HiveField(17)
  bool get isCompleted => throw _privateConstructorUsedError;
  @HiveField(18)
  bool get isCancelled => throw _privateConstructorUsedError;
  @HiveField(19)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @HiveField(20)
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @HiveField(21)
  bool get autoEndEnabled => throw _privateConstructorUsedError; // 是否启用自动结束
  @HiveField(22)
  bool get isLowCalorieDay => throw _privateConstructorUsedError; // 低卡日（5:2）
  @HiveField(23)
  double? get calorieTarget => throw _privateConstructorUsedError; // 低卡日目标卡路里
  @HiveField(24)
  String? get mood => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FastingSessionCopyWith<FastingSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FastingSessionCopyWith<$Res> {
  factory $FastingSessionCopyWith(
    FastingSession value,
    $Res Function(FastingSession) then,
  ) = _$FastingSessionCopyWithImpl<$Res, FastingSession>;
  @useResult
  $Res call({
    @HiveField(0) String id,
    @HiveField(1) String planId,
    @HiveField(2) DateTime startTime,
    @HiveField(3) DateTime? endTime,
    @HiveField(4) DateTime? plannedEndTime,
    @HiveField(5) FastingStatus status,
    @HiveField(6) int fastingHours,
    @HiveField(7) int eatingHours,
    @HiveField(8) String? notes,
    @HiveField(9) double startWeight,
    @HiveField(10) double endWeight,
    @HiveField(11) int difficultyRating,
    @HiveField(12) int satisfactionRating,
    @HiveField(13) List<String> symptoms,
    @HiveField(14) List<String> benefits,
    @HiveField(15) DateTime? lastPauseTime,
    @HiveField(16) int totalPauseDuration,
    @HiveField(17) bool isCompleted,
    @HiveField(18) bool isCancelled,
    @HiveField(19) DateTime createdAt,
    @HiveField(20) DateTime? updatedAt,
    @HiveField(21) bool autoEndEnabled,
    @HiveField(22) bool isLowCalorieDay,
    @HiveField(23) double? calorieTarget,
    @HiveField(24) String? mood,
  });
}

/// @nodoc
class _$FastingSessionCopyWithImpl<$Res, $Val extends FastingSession>
    implements $FastingSessionCopyWith<$Res> {
  _$FastingSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? planId = null,
    Object? startTime = null,
    Object? endTime = freezed,
    Object? plannedEndTime = freezed,
    Object? status = null,
    Object? fastingHours = null,
    Object? eatingHours = null,
    Object? notes = freezed,
    Object? startWeight = null,
    Object? endWeight = null,
    Object? difficultyRating = null,
    Object? satisfactionRating = null,
    Object? symptoms = null,
    Object? benefits = null,
    Object? lastPauseTime = freezed,
    Object? totalPauseDuration = null,
    Object? isCompleted = null,
    Object? isCancelled = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? autoEndEnabled = null,
    Object? isLowCalorieDay = null,
    Object? calorieTarget = freezed,
    Object? mood = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            planId: null == planId
                ? _value.planId
                : planId // ignore: cast_nullable_to_non_nullable
                      as String,
            startTime: null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endTime: freezed == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            plannedEndTime: freezed == plannedEndTime
                ? _value.plannedEndTime
                : plannedEndTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as FastingStatus,
            fastingHours: null == fastingHours
                ? _value.fastingHours
                : fastingHours // ignore: cast_nullable_to_non_nullable
                      as int,
            eatingHours: null == eatingHours
                ? _value.eatingHours
                : eatingHours // ignore: cast_nullable_to_non_nullable
                      as int,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            startWeight: null == startWeight
                ? _value.startWeight
                : startWeight // ignore: cast_nullable_to_non_nullable
                      as double,
            endWeight: null == endWeight
                ? _value.endWeight
                : endWeight // ignore: cast_nullable_to_non_nullable
                      as double,
            difficultyRating: null == difficultyRating
                ? _value.difficultyRating
                : difficultyRating // ignore: cast_nullable_to_non_nullable
                      as int,
            satisfactionRating: null == satisfactionRating
                ? _value.satisfactionRating
                : satisfactionRating // ignore: cast_nullable_to_non_nullable
                      as int,
            symptoms: null == symptoms
                ? _value.symptoms
                : symptoms // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            benefits: null == benefits
                ? _value.benefits
                : benefits // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            lastPauseTime: freezed == lastPauseTime
                ? _value.lastPauseTime
                : lastPauseTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            totalPauseDuration: null == totalPauseDuration
                ? _value.totalPauseDuration
                : totalPauseDuration // ignore: cast_nullable_to_non_nullable
                      as int,
            isCompleted: null == isCompleted
                ? _value.isCompleted
                : isCompleted // ignore: cast_nullable_to_non_nullable
                      as bool,
            isCancelled: null == isCancelled
                ? _value.isCancelled
                : isCancelled // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            autoEndEnabled: null == autoEndEnabled
                ? _value.autoEndEnabled
                : autoEndEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            isLowCalorieDay: null == isLowCalorieDay
                ? _value.isLowCalorieDay
                : isLowCalorieDay // ignore: cast_nullable_to_non_nullable
                      as bool,
            calorieTarget: freezed == calorieTarget
                ? _value.calorieTarget
                : calorieTarget // ignore: cast_nullable_to_non_nullable
                      as double?,
            mood: freezed == mood
                ? _value.mood
                : mood // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FastingSessionImplCopyWith<$Res>
    implements $FastingSessionCopyWith<$Res> {
  factory _$$FastingSessionImplCopyWith(
    _$FastingSessionImpl value,
    $Res Function(_$FastingSessionImpl) then,
  ) = __$$FastingSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @HiveField(0) String id,
    @HiveField(1) String planId,
    @HiveField(2) DateTime startTime,
    @HiveField(3) DateTime? endTime,
    @HiveField(4) DateTime? plannedEndTime,
    @HiveField(5) FastingStatus status,
    @HiveField(6) int fastingHours,
    @HiveField(7) int eatingHours,
    @HiveField(8) String? notes,
    @HiveField(9) double startWeight,
    @HiveField(10) double endWeight,
    @HiveField(11) int difficultyRating,
    @HiveField(12) int satisfactionRating,
    @HiveField(13) List<String> symptoms,
    @HiveField(14) List<String> benefits,
    @HiveField(15) DateTime? lastPauseTime,
    @HiveField(16) int totalPauseDuration,
    @HiveField(17) bool isCompleted,
    @HiveField(18) bool isCancelled,
    @HiveField(19) DateTime createdAt,
    @HiveField(20) DateTime? updatedAt,
    @HiveField(21) bool autoEndEnabled,
    @HiveField(22) bool isLowCalorieDay,
    @HiveField(23) double? calorieTarget,
    @HiveField(24) String? mood,
  });
}

/// @nodoc
class __$$FastingSessionImplCopyWithImpl<$Res>
    extends _$FastingSessionCopyWithImpl<$Res, _$FastingSessionImpl>
    implements _$$FastingSessionImplCopyWith<$Res> {
  __$$FastingSessionImplCopyWithImpl(
    _$FastingSessionImpl _value,
    $Res Function(_$FastingSessionImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? planId = null,
    Object? startTime = null,
    Object? endTime = freezed,
    Object? plannedEndTime = freezed,
    Object? status = null,
    Object? fastingHours = null,
    Object? eatingHours = null,
    Object? notes = freezed,
    Object? startWeight = null,
    Object? endWeight = null,
    Object? difficultyRating = null,
    Object? satisfactionRating = null,
    Object? symptoms = null,
    Object? benefits = null,
    Object? lastPauseTime = freezed,
    Object? totalPauseDuration = null,
    Object? isCompleted = null,
    Object? isCancelled = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? autoEndEnabled = null,
    Object? isLowCalorieDay = null,
    Object? calorieTarget = freezed,
    Object? mood = freezed,
  }) {
    return _then(
      _$FastingSessionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        planId: null == planId
            ? _value.planId
            : planId // ignore: cast_nullable_to_non_nullable
                  as String,
        startTime: null == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endTime: freezed == endTime
            ? _value.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        plannedEndTime: freezed == plannedEndTime
            ? _value.plannedEndTime
            : plannedEndTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as FastingStatus,
        fastingHours: null == fastingHours
            ? _value.fastingHours
            : fastingHours // ignore: cast_nullable_to_non_nullable
                  as int,
        eatingHours: null == eatingHours
            ? _value.eatingHours
            : eatingHours // ignore: cast_nullable_to_non_nullable
                  as int,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        startWeight: null == startWeight
            ? _value.startWeight
            : startWeight // ignore: cast_nullable_to_non_nullable
                  as double,
        endWeight: null == endWeight
            ? _value.endWeight
            : endWeight // ignore: cast_nullable_to_non_nullable
                  as double,
        difficultyRating: null == difficultyRating
            ? _value.difficultyRating
            : difficultyRating // ignore: cast_nullable_to_non_nullable
                  as int,
        satisfactionRating: null == satisfactionRating
            ? _value.satisfactionRating
            : satisfactionRating // ignore: cast_nullable_to_non_nullable
                  as int,
        symptoms: null == symptoms
            ? _value._symptoms
            : symptoms // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        benefits: null == benefits
            ? _value._benefits
            : benefits // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        lastPauseTime: freezed == lastPauseTime
            ? _value.lastPauseTime
            : lastPauseTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        totalPauseDuration: null == totalPauseDuration
            ? _value.totalPauseDuration
            : totalPauseDuration // ignore: cast_nullable_to_non_nullable
                  as int,
        isCompleted: null == isCompleted
            ? _value.isCompleted
            : isCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        isCancelled: null == isCancelled
            ? _value.isCancelled
            : isCancelled // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        autoEndEnabled: null == autoEndEnabled
            ? _value.autoEndEnabled
            : autoEndEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        isLowCalorieDay: null == isLowCalorieDay
            ? _value.isLowCalorieDay
            : isLowCalorieDay // ignore: cast_nullable_to_non_nullable
                  as bool,
        calorieTarget: freezed == calorieTarget
            ? _value.calorieTarget
            : calorieTarget // ignore: cast_nullable_to_non_nullable
                  as double?,
        mood: freezed == mood
            ? _value.mood
            : mood // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FastingSessionImpl implements _FastingSession {
  const _$FastingSessionImpl({
    @HiveField(0) required this.id,
    @HiveField(1) required this.planId,
    @HiveField(2) required this.startTime,
    @HiveField(3) this.endTime,
    @HiveField(4) this.plannedEndTime,
    @HiveField(5) this.status = FastingStatus.notStarted,
    @HiveField(6) this.fastingHours = 0,
    @HiveField(7) this.eatingHours = 0,
    @HiveField(8) this.notes,
    @HiveField(9) this.startWeight = 0.0,
    @HiveField(10) this.endWeight = 0.0,
    @HiveField(11) this.difficultyRating = 1,
    @HiveField(12) this.satisfactionRating = 1,
    @HiveField(13) final List<String> symptoms = const [],
    @HiveField(14) final List<String> benefits = const [],
    @HiveField(15) this.lastPauseTime,
    @HiveField(16) this.totalPauseDuration = 0,
    @HiveField(17) this.isCompleted = false,
    @HiveField(18) this.isCancelled = false,
    @HiveField(19) required this.createdAt,
    @HiveField(20) this.updatedAt,
    @HiveField(21) this.autoEndEnabled = false,
    @HiveField(22) this.isLowCalorieDay = false,
    @HiveField(23) this.calorieTarget,
    @HiveField(24) this.mood,
  }) : _symptoms = symptoms,
       _benefits = benefits;

  factory _$FastingSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$FastingSessionImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String planId;
  @override
  @HiveField(2)
  final DateTime startTime;
  @override
  @HiveField(3)
  final DateTime? endTime;
  @override
  @HiveField(4)
  final DateTime? plannedEndTime;
  @override
  @JsonKey()
  @HiveField(5)
  final FastingStatus status;
  @override
  @JsonKey()
  @HiveField(6)
  final int fastingHours;
  @override
  @JsonKey()
  @HiveField(7)
  final int eatingHours;
  @override
  @HiveField(8)
  final String? notes;
  @override
  @JsonKey()
  @HiveField(9)
  final double startWeight;
  @override
  @JsonKey()
  @HiveField(10)
  final double endWeight;
  @override
  @JsonKey()
  @HiveField(11)
  final int difficultyRating;
  // 1-5星难度评价
  @override
  @JsonKey()
  @HiveField(12)
  final int satisfactionRating;
  // 1-5星满意度评价
  final List<String> _symptoms;
  // 1-5星满意度评价
  @override
  @JsonKey()
  @HiveField(13)
  List<String> get symptoms {
    if (_symptoms is EqualUnmodifiableListView) return _symptoms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_symptoms);
  }

  // 断食期间的症状
  final List<String> _benefits;
  // 断食期间的症状
  @override
  @JsonKey()
  @HiveField(14)
  List<String> get benefits {
    if (_benefits is EqualUnmodifiableListView) return _benefits;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_benefits);
  }

  // 感受到的益处
  @override
  @HiveField(15)
  final DateTime? lastPauseTime;
  @override
  @JsonKey()
  @HiveField(16)
  final int totalPauseDuration;
  // 总暂停时长（分钟）
  @override
  @JsonKey()
  @HiveField(17)
  final bool isCompleted;
  @override
  @JsonKey()
  @HiveField(18)
  final bool isCancelled;
  @override
  @HiveField(19)
  final DateTime createdAt;
  @override
  @HiveField(20)
  final DateTime? updatedAt;
  @override
  @JsonKey()
  @HiveField(21)
  final bool autoEndEnabled;
  // 是否启用自动结束
  @override
  @JsonKey()
  @HiveField(22)
  final bool isLowCalorieDay;
  // 低卡日（5:2）
  @override
  @HiveField(23)
  final double? calorieTarget;
  // 低卡日目标卡路里
  @override
  @HiveField(24)
  final String? mood;

  @override
  String toString() {
    return 'FastingSession(id: $id, planId: $planId, startTime: $startTime, endTime: $endTime, plannedEndTime: $plannedEndTime, status: $status, fastingHours: $fastingHours, eatingHours: $eatingHours, notes: $notes, startWeight: $startWeight, endWeight: $endWeight, difficultyRating: $difficultyRating, satisfactionRating: $satisfactionRating, symptoms: $symptoms, benefits: $benefits, lastPauseTime: $lastPauseTime, totalPauseDuration: $totalPauseDuration, isCompleted: $isCompleted, isCancelled: $isCancelled, createdAt: $createdAt, updatedAt: $updatedAt, autoEndEnabled: $autoEndEnabled, isLowCalorieDay: $isLowCalorieDay, calorieTarget: $calorieTarget, mood: $mood)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FastingSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.planId, planId) || other.planId == planId) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.plannedEndTime, plannedEndTime) ||
                other.plannedEndTime == plannedEndTime) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.fastingHours, fastingHours) ||
                other.fastingHours == fastingHours) &&
            (identical(other.eatingHours, eatingHours) ||
                other.eatingHours == eatingHours) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.startWeight, startWeight) ||
                other.startWeight == startWeight) &&
            (identical(other.endWeight, endWeight) ||
                other.endWeight == endWeight) &&
            (identical(other.difficultyRating, difficultyRating) ||
                other.difficultyRating == difficultyRating) &&
            (identical(other.satisfactionRating, satisfactionRating) ||
                other.satisfactionRating == satisfactionRating) &&
            const DeepCollectionEquality().equals(other._symptoms, _symptoms) &&
            const DeepCollectionEquality().equals(other._benefits, _benefits) &&
            (identical(other.lastPauseTime, lastPauseTime) ||
                other.lastPauseTime == lastPauseTime) &&
            (identical(other.totalPauseDuration, totalPauseDuration) ||
                other.totalPauseDuration == totalPauseDuration) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.isCancelled, isCancelled) ||
                other.isCancelled == isCancelled) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.autoEndEnabled, autoEndEnabled) ||
                other.autoEndEnabled == autoEndEnabled) &&
            (identical(other.isLowCalorieDay, isLowCalorieDay) ||
                other.isLowCalorieDay == isLowCalorieDay) &&
            (identical(other.calorieTarget, calorieTarget) ||
                other.calorieTarget == calorieTarget) &&
            (identical(other.mood, mood) || other.mood == mood));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    planId,
    startTime,
    endTime,
    plannedEndTime,
    status,
    fastingHours,
    eatingHours,
    notes,
    startWeight,
    endWeight,
    difficultyRating,
    satisfactionRating,
    const DeepCollectionEquality().hash(_symptoms),
    const DeepCollectionEquality().hash(_benefits),
    lastPauseTime,
    totalPauseDuration,
    isCompleted,
    isCancelled,
    createdAt,
    updatedAt,
    autoEndEnabled,
    isLowCalorieDay,
    calorieTarget,
    mood,
  ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FastingSessionImplCopyWith<_$FastingSessionImpl> get copyWith =>
      __$$FastingSessionImplCopyWithImpl<_$FastingSessionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FastingSessionImplToJson(this);
  }
}

abstract class _FastingSession implements FastingSession {
  const factory _FastingSession({
    @HiveField(0) required final String id,
    @HiveField(1) required final String planId,
    @HiveField(2) required final DateTime startTime,
    @HiveField(3) final DateTime? endTime,
    @HiveField(4) final DateTime? plannedEndTime,
    @HiveField(5) final FastingStatus status,
    @HiveField(6) final int fastingHours,
    @HiveField(7) final int eatingHours,
    @HiveField(8) final String? notes,
    @HiveField(9) final double startWeight,
    @HiveField(10) final double endWeight,
    @HiveField(11) final int difficultyRating,
    @HiveField(12) final int satisfactionRating,
    @HiveField(13) final List<String> symptoms,
    @HiveField(14) final List<String> benefits,
    @HiveField(15) final DateTime? lastPauseTime,
    @HiveField(16) final int totalPauseDuration,
    @HiveField(17) final bool isCompleted,
    @HiveField(18) final bool isCancelled,
    @HiveField(19) required final DateTime createdAt,
    @HiveField(20) final DateTime? updatedAt,
    @HiveField(21) final bool autoEndEnabled,
    @HiveField(22) final bool isLowCalorieDay,
    @HiveField(23) final double? calorieTarget,
    @HiveField(24) final String? mood,
  }) = _$FastingSessionImpl;

  factory _FastingSession.fromJson(Map<String, dynamic> json) =
      _$FastingSessionImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get planId;
  @override
  @HiveField(2)
  DateTime get startTime;
  @override
  @HiveField(3)
  DateTime? get endTime;
  @override
  @HiveField(4)
  DateTime? get plannedEndTime;
  @override
  @HiveField(5)
  FastingStatus get status;
  @override
  @HiveField(6)
  int get fastingHours;
  @override
  @HiveField(7)
  int get eatingHours;
  @override
  @HiveField(8)
  String? get notes;
  @override
  @HiveField(9)
  double get startWeight;
  @override
  @HiveField(10)
  double get endWeight;
  @override
  @HiveField(11)
  int get difficultyRating;
  @override // 1-5星难度评价
  @HiveField(12)
  int get satisfactionRating;
  @override // 1-5星满意度评价
  @HiveField(13)
  List<String> get symptoms;
  @override // 断食期间的症状
  @HiveField(14)
  List<String> get benefits;
  @override // 感受到的益处
  @HiveField(15)
  DateTime? get lastPauseTime;
  @override
  @HiveField(16)
  int get totalPauseDuration;
  @override // 总暂停时长（分钟）
  @HiveField(17)
  bool get isCompleted;
  @override
  @HiveField(18)
  bool get isCancelled;
  @override
  @HiveField(19)
  DateTime get createdAt;
  @override
  @HiveField(20)
  DateTime? get updatedAt;
  @override
  @HiveField(21)
  bool get autoEndEnabled;
  @override // 是否启用自动结束
  @HiveField(22)
  bool get isLowCalorieDay;
  @override // 低卡日（5:2）
  @HiveField(23)
  double? get calorieTarget;
  @override // 低卡日目标卡路里
  @HiveField(24)
  String? get mood;
  @override
  @JsonKey(ignore: true)
  _$$FastingSessionImplCopyWith<_$FastingSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
