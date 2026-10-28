// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'suggestion.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Suggestion _$SuggestionFromJson(Map<String, dynamic> json) {
  return _Suggestion.fromJson(json);
}

/// @nodoc
mixin _$Suggestion {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  SuggestionType get type => throw _privateConstructorUsedError;
  @HiveField(2)
  String get title => throw _privateConstructorUsedError;
  @HiveField(3)
  String get content => throw _privateConstructorUsedError;
  @HiveField(4)
  SuggestionPriority get priority => throw _privateConstructorUsedError;
  @HiveField(5)
  String? get scientificBasis => throw _privateConstructorUsedError;
  @HiveField(6)
  List<String> get actionItems => throw _privateConstructorUsedError;
  @HiveField(7)
  bool get isRead => throw _privateConstructorUsedError;
  @HiveField(8)
  bool get isAdopted => throw _privateConstructorUsedError;
  @HiveField(9)
  bool get isIgnored => throw _privateConstructorUsedError;
  @HiveField(10)
  DateTime? get adoptedAt => throw _privateConstructorUsedError;
  @HiveField(11)
  DateTime? get ignoredAt => throw _privateConstructorUsedError;
  @HiveField(12)
  DateTime? get expiresAt => throw _privateConstructorUsedError;
  @HiveField(13)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @HiveField(14)
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @HiveField(15)
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SuggestionCopyWith<Suggestion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SuggestionCopyWith<$Res> {
  factory $SuggestionCopyWith(
    Suggestion value,
    $Res Function(Suggestion) then,
  ) = _$SuggestionCopyWithImpl<$Res, Suggestion>;
  @useResult
  $Res call({
    @HiveField(0) String id,
    @HiveField(1) SuggestionType type,
    @HiveField(2) String title,
    @HiveField(3) String content,
    @HiveField(4) SuggestionPriority priority,
    @HiveField(5) String? scientificBasis,
    @HiveField(6) List<String> actionItems,
    @HiveField(7) bool isRead,
    @HiveField(8) bool isAdopted,
    @HiveField(9) bool isIgnored,
    @HiveField(10) DateTime? adoptedAt,
    @HiveField(11) DateTime? ignoredAt,
    @HiveField(12) DateTime? expiresAt,
    @HiveField(13) DateTime createdAt,
    @HiveField(14) DateTime? updatedAt,
    @HiveField(15) Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class _$SuggestionCopyWithImpl<$Res, $Val extends Suggestion>
    implements $SuggestionCopyWith<$Res> {
  _$SuggestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? title = null,
    Object? content = null,
    Object? priority = null,
    Object? scientificBasis = freezed,
    Object? actionItems = null,
    Object? isRead = null,
    Object? isAdopted = null,
    Object? isIgnored = null,
    Object? adoptedAt = freezed,
    Object? ignoredAt = freezed,
    Object? expiresAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? metadata = freezed,
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
                      as SuggestionType,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            priority: null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as SuggestionPriority,
            scientificBasis: freezed == scientificBasis
                ? _value.scientificBasis
                : scientificBasis // ignore: cast_nullable_to_non_nullable
                      as String?,
            actionItems: null == actionItems
                ? _value.actionItems
                : actionItems // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            isRead: null == isRead
                ? _value.isRead
                : isRead // ignore: cast_nullable_to_non_nullable
                      as bool,
            isAdopted: null == isAdopted
                ? _value.isAdopted
                : isAdopted // ignore: cast_nullable_to_non_nullable
                      as bool,
            isIgnored: null == isIgnored
                ? _value.isIgnored
                : isIgnored // ignore: cast_nullable_to_non_nullable
                      as bool,
            adoptedAt: freezed == adoptedAt
                ? _value.adoptedAt
                : adoptedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            ignoredAt: freezed == ignoredAt
                ? _value.ignoredAt
                : ignoredAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            expiresAt: freezed == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            metadata: freezed == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SuggestionImplCopyWith<$Res>
    implements $SuggestionCopyWith<$Res> {
  factory _$$SuggestionImplCopyWith(
    _$SuggestionImpl value,
    $Res Function(_$SuggestionImpl) then,
  ) = __$$SuggestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @HiveField(0) String id,
    @HiveField(1) SuggestionType type,
    @HiveField(2) String title,
    @HiveField(3) String content,
    @HiveField(4) SuggestionPriority priority,
    @HiveField(5) String? scientificBasis,
    @HiveField(6) List<String> actionItems,
    @HiveField(7) bool isRead,
    @HiveField(8) bool isAdopted,
    @HiveField(9) bool isIgnored,
    @HiveField(10) DateTime? adoptedAt,
    @HiveField(11) DateTime? ignoredAt,
    @HiveField(12) DateTime? expiresAt,
    @HiveField(13) DateTime createdAt,
    @HiveField(14) DateTime? updatedAt,
    @HiveField(15) Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class __$$SuggestionImplCopyWithImpl<$Res>
    extends _$SuggestionCopyWithImpl<$Res, _$SuggestionImpl>
    implements _$$SuggestionImplCopyWith<$Res> {
  __$$SuggestionImplCopyWithImpl(
    _$SuggestionImpl _value,
    $Res Function(_$SuggestionImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? title = null,
    Object? content = null,
    Object? priority = null,
    Object? scientificBasis = freezed,
    Object? actionItems = null,
    Object? isRead = null,
    Object? isAdopted = null,
    Object? isIgnored = null,
    Object? adoptedAt = freezed,
    Object? ignoredAt = freezed,
    Object? expiresAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? metadata = freezed,
  }) {
    return _then(
      _$SuggestionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as SuggestionType,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        priority: null == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as SuggestionPriority,
        scientificBasis: freezed == scientificBasis
            ? _value.scientificBasis
            : scientificBasis // ignore: cast_nullable_to_non_nullable
                  as String?,
        actionItems: null == actionItems
            ? _value._actionItems
            : actionItems // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        isRead: null == isRead
            ? _value.isRead
            : isRead // ignore: cast_nullable_to_non_nullable
                  as bool,
        isAdopted: null == isAdopted
            ? _value.isAdopted
            : isAdopted // ignore: cast_nullable_to_non_nullable
                  as bool,
        isIgnored: null == isIgnored
            ? _value.isIgnored
            : isIgnored // ignore: cast_nullable_to_non_nullable
                  as bool,
        adoptedAt: freezed == adoptedAt
            ? _value.adoptedAt
            : adoptedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        ignoredAt: freezed == ignoredAt
            ? _value.ignoredAt
            : ignoredAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        expiresAt: freezed == expiresAt
            ? _value.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        metadata: freezed == metadata
            ? _value._metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SuggestionImpl implements _Suggestion {
  const _$SuggestionImpl({
    @HiveField(0) required this.id,
    @HiveField(1) required this.type,
    @HiveField(2) required this.title,
    @HiveField(3) required this.content,
    @HiveField(4) required this.priority,
    @HiveField(5) this.scientificBasis,
    @HiveField(6) final List<String> actionItems = const [],
    @HiveField(7) this.isRead = false,
    @HiveField(8) this.isAdopted = false,
    @HiveField(9) this.isIgnored = false,
    @HiveField(10) this.adoptedAt,
    @HiveField(11) this.ignoredAt,
    @HiveField(12) this.expiresAt,
    @HiveField(13) required this.createdAt,
    @HiveField(14) this.updatedAt,
    @HiveField(15) final Map<String, dynamic>? metadata,
  }) : _actionItems = actionItems,
       _metadata = metadata;

  factory _$SuggestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$SuggestionImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final SuggestionType type;
  @override
  @HiveField(2)
  final String title;
  @override
  @HiveField(3)
  final String content;
  @override
  @HiveField(4)
  final SuggestionPriority priority;
  @override
  @HiveField(5)
  final String? scientificBasis;
  final List<String> _actionItems;
  @override
  @JsonKey()
  @HiveField(6)
  List<String> get actionItems {
    if (_actionItems is EqualUnmodifiableListView) return _actionItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_actionItems);
  }

  @override
  @JsonKey()
  @HiveField(7)
  final bool isRead;
  @override
  @JsonKey()
  @HiveField(8)
  final bool isAdopted;
  @override
  @JsonKey()
  @HiveField(9)
  final bool isIgnored;
  @override
  @HiveField(10)
  final DateTime? adoptedAt;
  @override
  @HiveField(11)
  final DateTime? ignoredAt;
  @override
  @HiveField(12)
  final DateTime? expiresAt;
  @override
  @HiveField(13)
  final DateTime createdAt;
  @override
  @HiveField(14)
  final DateTime? updatedAt;
  final Map<String, dynamic>? _metadata;
  @override
  @HiveField(15)
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'Suggestion(id: $id, type: $type, title: $title, content: $content, priority: $priority, scientificBasis: $scientificBasis, actionItems: $actionItems, isRead: $isRead, isAdopted: $isAdopted, isIgnored: $isIgnored, adoptedAt: $adoptedAt, ignoredAt: $ignoredAt, expiresAt: $expiresAt, createdAt: $createdAt, updatedAt: $updatedAt, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuggestionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.scientificBasis, scientificBasis) ||
                other.scientificBasis == scientificBasis) &&
            const DeepCollectionEquality().equals(
              other._actionItems,
              _actionItems,
            ) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.isAdopted, isAdopted) ||
                other.isAdopted == isAdopted) &&
            (identical(other.isIgnored, isIgnored) ||
                other.isIgnored == isIgnored) &&
            (identical(other.adoptedAt, adoptedAt) ||
                other.adoptedAt == adoptedAt) &&
            (identical(other.ignoredAt, ignoredAt) ||
                other.ignoredAt == ignoredAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    type,
    title,
    content,
    priority,
    scientificBasis,
    const DeepCollectionEquality().hash(_actionItems),
    isRead,
    isAdopted,
    isIgnored,
    adoptedAt,
    ignoredAt,
    expiresAt,
    createdAt,
    updatedAt,
    const DeepCollectionEquality().hash(_metadata),
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SuggestionImplCopyWith<_$SuggestionImpl> get copyWith =>
      __$$SuggestionImplCopyWithImpl<_$SuggestionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SuggestionImplToJson(this);
  }
}

abstract class _Suggestion implements Suggestion {
  const factory _Suggestion({
    @HiveField(0) required final String id,
    @HiveField(1) required final SuggestionType type,
    @HiveField(2) required final String title,
    @HiveField(3) required final String content,
    @HiveField(4) required final SuggestionPriority priority,
    @HiveField(5) final String? scientificBasis,
    @HiveField(6) final List<String> actionItems,
    @HiveField(7) final bool isRead,
    @HiveField(8) final bool isAdopted,
    @HiveField(9) final bool isIgnored,
    @HiveField(10) final DateTime? adoptedAt,
    @HiveField(11) final DateTime? ignoredAt,
    @HiveField(12) final DateTime? expiresAt,
    @HiveField(13) required final DateTime createdAt,
    @HiveField(14) final DateTime? updatedAt,
    @HiveField(15) final Map<String, dynamic>? metadata,
  }) = _$SuggestionImpl;

  factory _Suggestion.fromJson(Map<String, dynamic> json) =
      _$SuggestionImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  SuggestionType get type;
  @override
  @HiveField(2)
  String get title;
  @override
  @HiveField(3)
  String get content;
  @override
  @HiveField(4)
  SuggestionPriority get priority;
  @override
  @HiveField(5)
  String? get scientificBasis;
  @override
  @HiveField(6)
  List<String> get actionItems;
  @override
  @HiveField(7)
  bool get isRead;
  @override
  @HiveField(8)
  bool get isAdopted;
  @override
  @HiveField(9)
  bool get isIgnored;
  @override
  @HiveField(10)
  DateTime? get adoptedAt;
  @override
  @HiveField(11)
  DateTime? get ignoredAt;
  @override
  @HiveField(12)
  DateTime? get expiresAt;
  @override
  @HiveField(13)
  DateTime get createdAt;
  @override
  @HiveField(14)
  DateTime? get updatedAt;
  @override
  @HiveField(15)
  Map<String, dynamic>? get metadata;
  @override
  @JsonKey(ignore: true)
  _$$SuggestionImplCopyWith<_$SuggestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
