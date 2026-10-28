// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'achievement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Achievement _$AchievementFromJson(Map<String, dynamic> json) {
  return _Achievement.fromJson(json);
}

/// @nodoc
mixin _$Achievement {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get title => throw _privateConstructorUsedError;
  @HiveField(2)
  String get description => throw _privateConstructorUsedError;
  @HiveField(3)
  String get icon => throw _privateConstructorUsedError; // 图标名称或emoji
  @HiveField(4)
  bool get isUnlocked => throw _privateConstructorUsedError; // 是否已解锁
  @HiveField(5)
  DateTime? get unlockedAt => throw _privateConstructorUsedError; // 解锁时间
  @HiveField(6)
  int get targetValue => throw _privateConstructorUsedError; // 目标值
  @HiveField(7)
  int get currentValue => throw _privateConstructorUsedError; // 当前进度
  @HiveField(8)
  AchievementType get type => throw _privateConstructorUsedError;
  @HiveField(9)
  AchievementRarity get rarity => throw _privateConstructorUsedError; // 稀有度
  @HiveField(10)
  String get category => throw _privateConstructorUsedError; // 分类
  @HiveField(11)
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AchievementCopyWith<Achievement> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AchievementCopyWith<$Res> {
  factory $AchievementCopyWith(
    Achievement value,
    $Res Function(Achievement) then,
  ) = _$AchievementCopyWithImpl<$Res, Achievement>;
  @useResult
  $Res call({
    @HiveField(0) String id,
    @HiveField(1) String title,
    @HiveField(2) String description,
    @HiveField(3) String icon,
    @HiveField(4) bool isUnlocked,
    @HiveField(5) DateTime? unlockedAt,
    @HiveField(6) int targetValue,
    @HiveField(7) int currentValue,
    @HiveField(8) AchievementType type,
    @HiveField(9) AchievementRarity rarity,
    @HiveField(10) String category,
    @HiveField(11) DateTime createdAt,
  });
}

/// @nodoc
class _$AchievementCopyWithImpl<$Res, $Val extends Achievement>
    implements $AchievementCopyWith<$Res> {
  _$AchievementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? icon = null,
    Object? isUnlocked = null,
    Object? unlockedAt = freezed,
    Object? targetValue = null,
    Object? currentValue = null,
    Object? type = null,
    Object? rarity = null,
    Object? category = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            icon: null == icon
                ? _value.icon
                : icon // ignore: cast_nullable_to_non_nullable
                      as String,
            isUnlocked: null == isUnlocked
                ? _value.isUnlocked
                : isUnlocked // ignore: cast_nullable_to_non_nullable
                      as bool,
            unlockedAt: freezed == unlockedAt
                ? _value.unlockedAt
                : unlockedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            targetValue: null == targetValue
                ? _value.targetValue
                : targetValue // ignore: cast_nullable_to_non_nullable
                      as int,
            currentValue: null == currentValue
                ? _value.currentValue
                : currentValue // ignore: cast_nullable_to_non_nullable
                      as int,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as AchievementType,
            rarity: null == rarity
                ? _value.rarity
                : rarity // ignore: cast_nullable_to_non_nullable
                      as AchievementRarity,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AchievementImplCopyWith<$Res>
    implements $AchievementCopyWith<$Res> {
  factory _$$AchievementImplCopyWith(
    _$AchievementImpl value,
    $Res Function(_$AchievementImpl) then,
  ) = __$$AchievementImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @HiveField(0) String id,
    @HiveField(1) String title,
    @HiveField(2) String description,
    @HiveField(3) String icon,
    @HiveField(4) bool isUnlocked,
    @HiveField(5) DateTime? unlockedAt,
    @HiveField(6) int targetValue,
    @HiveField(7) int currentValue,
    @HiveField(8) AchievementType type,
    @HiveField(9) AchievementRarity rarity,
    @HiveField(10) String category,
    @HiveField(11) DateTime createdAt,
  });
}

/// @nodoc
class __$$AchievementImplCopyWithImpl<$Res>
    extends _$AchievementCopyWithImpl<$Res, _$AchievementImpl>
    implements _$$AchievementImplCopyWith<$Res> {
  __$$AchievementImplCopyWithImpl(
    _$AchievementImpl _value,
    $Res Function(_$AchievementImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? icon = null,
    Object? isUnlocked = null,
    Object? unlockedAt = freezed,
    Object? targetValue = null,
    Object? currentValue = null,
    Object? type = null,
    Object? rarity = null,
    Object? category = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$AchievementImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        icon: null == icon
            ? _value.icon
            : icon // ignore: cast_nullable_to_non_nullable
                  as String,
        isUnlocked: null == isUnlocked
            ? _value.isUnlocked
            : isUnlocked // ignore: cast_nullable_to_non_nullable
                  as bool,
        unlockedAt: freezed == unlockedAt
            ? _value.unlockedAt
            : unlockedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        targetValue: null == targetValue
            ? _value.targetValue
            : targetValue // ignore: cast_nullable_to_non_nullable
                  as int,
        currentValue: null == currentValue
            ? _value.currentValue
            : currentValue // ignore: cast_nullable_to_non_nullable
                  as int,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as AchievementType,
        rarity: null == rarity
            ? _value.rarity
            : rarity // ignore: cast_nullable_to_non_nullable
                  as AchievementRarity,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AchievementImpl implements _Achievement {
  const _$AchievementImpl({
    @HiveField(0) required this.id,
    @HiveField(1) required this.title,
    @HiveField(2) required this.description,
    @HiveField(3) required this.icon,
    @HiveField(4) this.isUnlocked = false,
    @HiveField(5) this.unlockedAt,
    @HiveField(6) required this.targetValue,
    @HiveField(7) this.currentValue = 0,
    @HiveField(8) required this.type,
    @HiveField(9) required this.rarity,
    @HiveField(10) this.category = '',
    @HiveField(11) required this.createdAt,
  });

  factory _$AchievementImpl.fromJson(Map<String, dynamic> json) =>
      _$$AchievementImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String title;
  @override
  @HiveField(2)
  final String description;
  @override
  @HiveField(3)
  final String icon;
  // 图标名称或emoji
  @override
  @JsonKey()
  @HiveField(4)
  final bool isUnlocked;
  // 是否已解锁
  @override
  @HiveField(5)
  final DateTime? unlockedAt;
  // 解锁时间
  @override
  @HiveField(6)
  final int targetValue;
  // 目标值
  @override
  @JsonKey()
  @HiveField(7)
  final int currentValue;
  // 当前进度
  @override
  @HiveField(8)
  final AchievementType type;
  @override
  @HiveField(9)
  final AchievementRarity rarity;
  // 稀有度
  @override
  @JsonKey()
  @HiveField(10)
  final String category;
  // 分类
  @override
  @HiveField(11)
  final DateTime createdAt;

  @override
  String toString() {
    return 'Achievement(id: $id, title: $title, description: $description, icon: $icon, isUnlocked: $isUnlocked, unlockedAt: $unlockedAt, targetValue: $targetValue, currentValue: $currentValue, type: $type, rarity: $rarity, category: $category, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AchievementImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.isUnlocked, isUnlocked) ||
                other.isUnlocked == isUnlocked) &&
            (identical(other.unlockedAt, unlockedAt) ||
                other.unlockedAt == unlockedAt) &&
            (identical(other.targetValue, targetValue) ||
                other.targetValue == targetValue) &&
            (identical(other.currentValue, currentValue) ||
                other.currentValue == currentValue) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.rarity, rarity) || other.rarity == rarity) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    description,
    icon,
    isUnlocked,
    unlockedAt,
    targetValue,
    currentValue,
    type,
    rarity,
    category,
    createdAt,
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AchievementImplCopyWith<_$AchievementImpl> get copyWith =>
      __$$AchievementImplCopyWithImpl<_$AchievementImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AchievementImplToJson(this);
  }
}

abstract class _Achievement implements Achievement {
  const factory _Achievement({
    @HiveField(0) required final String id,
    @HiveField(1) required final String title,
    @HiveField(2) required final String description,
    @HiveField(3) required final String icon,
    @HiveField(4) final bool isUnlocked,
    @HiveField(5) final DateTime? unlockedAt,
    @HiveField(6) required final int targetValue,
    @HiveField(7) final int currentValue,
    @HiveField(8) required final AchievementType type,
    @HiveField(9) required final AchievementRarity rarity,
    @HiveField(10) final String category,
    @HiveField(11) required final DateTime createdAt,
  }) = _$AchievementImpl;

  factory _Achievement.fromJson(Map<String, dynamic> json) =
      _$AchievementImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get title;
  @override
  @HiveField(2)
  String get description;
  @override
  @HiveField(3)
  String get icon;
  @override // 图标名称或emoji
  @HiveField(4)
  bool get isUnlocked;
  @override // 是否已解锁
  @HiveField(5)
  DateTime? get unlockedAt;
  @override // 解锁时间
  @HiveField(6)
  int get targetValue;
  @override // 目标值
  @HiveField(7)
  int get currentValue;
  @override // 当前进度
  @HiveField(8)
  AchievementType get type;
  @override
  @HiveField(9)
  AchievementRarity get rarity;
  @override // 稀有度
  @HiveField(10)
  String get category;
  @override // 分类
  @HiveField(11)
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$AchievementImplCopyWith<_$AchievementImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
