// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $StepCountsTable extends StepCounts
    with TableInfo<$StepCountsTable, StepCount> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StepCountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _useTimeMeta = const VerificationMeta(
    'useTime',
  );
  @override
  late final GeneratedColumn<int> useTime = GeneratedColumn<int>(
    'use_time',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _stepsNumMeta = const VerificationMeta(
    'stepsNum',
  );
  @override
  late final GeneratedColumn<int> stepsNum = GeneratedColumn<int>(
    'steps_num',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<int> type = GeneratedColumn<int>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _subTypeMeta = const VerificationMeta(
    'subType',
  );
  @override
  late final GeneratedColumn<int> subType = GeneratedColumn<int>(
    'sub_type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _speedMeta = const VerificationMeta('speed');
  @override
  late final GeneratedColumn<String> speed = GeneratedColumn<String>(
    'speed',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cstatusMeta = const VerificationMeta(
    'cstatus',
  );
  @override
  late final GeneratedColumn<String> cstatus = GeneratedColumn<String>(
    'cstatus',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _calMeta = const VerificationMeta('cal');
  @override
  late final GeneratedColumn<String> cal = GeneratedColumn<String>(
    'cal',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sync1Meta = const VerificationMeta('sync1');
  @override
  late final GeneratedColumn<String> sync1 = GeneratedColumn<String>(
    'sync1',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sync2Meta = const VerificationMeta('sync2');
  @override
  late final GeneratedColumn<String> sync2 = GeneratedColumn<String>(
    'sync2',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _distanceMeta = const VerificationMeta(
    'distance',
  );
  @override
  late final GeneratedColumn<String> distance = GeneratedColumn<String>(
    'distance',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    startTime,
    useTime,
    stepsNum,
    type,
    subType,
    speed,
    cstatus,
    cal,
    sync1,
    sync2,
    distance,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'step_counts';
  @override
  VerificationContext validateIntegrity(
    Insertable<StepCount> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('use_time')) {
      context.handle(
        _useTimeMeta,
        useTime.isAcceptableOrUnknown(data['use_time']!, _useTimeMeta),
      );
    }
    if (data.containsKey('steps_num')) {
      context.handle(
        _stepsNumMeta,
        stepsNum.isAcceptableOrUnknown(data['steps_num']!, _stepsNumMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('sub_type')) {
      context.handle(
        _subTypeMeta,
        subType.isAcceptableOrUnknown(data['sub_type']!, _subTypeMeta),
      );
    }
    if (data.containsKey('speed')) {
      context.handle(
        _speedMeta,
        speed.isAcceptableOrUnknown(data['speed']!, _speedMeta),
      );
    }
    if (data.containsKey('cstatus')) {
      context.handle(
        _cstatusMeta,
        cstatus.isAcceptableOrUnknown(data['cstatus']!, _cstatusMeta),
      );
    }
    if (data.containsKey('cal')) {
      context.handle(
        _calMeta,
        cal.isAcceptableOrUnknown(data['cal']!, _calMeta),
      );
    }
    if (data.containsKey('sync1')) {
      context.handle(
        _sync1Meta,
        sync1.isAcceptableOrUnknown(data['sync1']!, _sync1Meta),
      );
    }
    if (data.containsKey('sync2')) {
      context.handle(
        _sync2Meta,
        sync2.isAcceptableOrUnknown(data['sync2']!, _sync2Meta),
      );
    }
    if (data.containsKey('distance')) {
      context.handle(
        _distanceMeta,
        distance.isAcceptableOrUnknown(data['distance']!, _distanceMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StepCount map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StepCount(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_time'],
      )!,
      useTime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}use_time'],
      )!,
      stepsNum: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}steps_num'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}type'],
      )!,
      subType: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sub_type'],
      )!,
      speed: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}speed'],
      ),
      cstatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cstatus'],
      ),
      cal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cal'],
      ),
      sync1: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync1'],
      ),
      sync2: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync2'],
      ),
      distance: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}distance'],
      ),
    );
  }

  @override
  $StepCountsTable createAlias(String alias) {
    return $StepCountsTable(attachedDatabase, alias);
  }
}

class StepCount extends DataClass implements Insertable<StepCount> {
  final int id;
  final DateTime startTime;
  final int useTime;
  final int stepsNum;
  final int type;
  final int subType;
  final String? speed;
  final String? cstatus;
  final String? cal;
  final String? sync1;
  final String? sync2;
  final String? distance;
  const StepCount({
    required this.id,
    required this.startTime,
    required this.useTime,
    required this.stepsNum,
    required this.type,
    required this.subType,
    this.speed,
    this.cstatus,
    this.cal,
    this.sync1,
    this.sync2,
    this.distance,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['start_time'] = Variable<DateTime>(startTime);
    map['use_time'] = Variable<int>(useTime);
    map['steps_num'] = Variable<int>(stepsNum);
    map['type'] = Variable<int>(type);
    map['sub_type'] = Variable<int>(subType);
    if (!nullToAbsent || speed != null) {
      map['speed'] = Variable<String>(speed);
    }
    if (!nullToAbsent || cstatus != null) {
      map['cstatus'] = Variable<String>(cstatus);
    }
    if (!nullToAbsent || cal != null) {
      map['cal'] = Variable<String>(cal);
    }
    if (!nullToAbsent || sync1 != null) {
      map['sync1'] = Variable<String>(sync1);
    }
    if (!nullToAbsent || sync2 != null) {
      map['sync2'] = Variable<String>(sync2);
    }
    if (!nullToAbsent || distance != null) {
      map['distance'] = Variable<String>(distance);
    }
    return map;
  }

  StepCountsCompanion toCompanion(bool nullToAbsent) {
    return StepCountsCompanion(
      id: Value(id),
      startTime: Value(startTime),
      useTime: Value(useTime),
      stepsNum: Value(stepsNum),
      type: Value(type),
      subType: Value(subType),
      speed: speed == null && nullToAbsent
          ? const Value.absent()
          : Value(speed),
      cstatus: cstatus == null && nullToAbsent
          ? const Value.absent()
          : Value(cstatus),
      cal: cal == null && nullToAbsent ? const Value.absent() : Value(cal),
      sync1: sync1 == null && nullToAbsent
          ? const Value.absent()
          : Value(sync1),
      sync2: sync2 == null && nullToAbsent
          ? const Value.absent()
          : Value(sync2),
      distance: distance == null && nullToAbsent
          ? const Value.absent()
          : Value(distance),
    );
  }

  factory StepCount.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StepCount(
      id: serializer.fromJson<int>(json['id']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      useTime: serializer.fromJson<int>(json['useTime']),
      stepsNum: serializer.fromJson<int>(json['stepsNum']),
      type: serializer.fromJson<int>(json['type']),
      subType: serializer.fromJson<int>(json['subType']),
      speed: serializer.fromJson<String?>(json['speed']),
      cstatus: serializer.fromJson<String?>(json['cstatus']),
      cal: serializer.fromJson<String?>(json['cal']),
      sync1: serializer.fromJson<String?>(json['sync1']),
      sync2: serializer.fromJson<String?>(json['sync2']),
      distance: serializer.fromJson<String?>(json['distance']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'startTime': serializer.toJson<DateTime>(startTime),
      'useTime': serializer.toJson<int>(useTime),
      'stepsNum': serializer.toJson<int>(stepsNum),
      'type': serializer.toJson<int>(type),
      'subType': serializer.toJson<int>(subType),
      'speed': serializer.toJson<String?>(speed),
      'cstatus': serializer.toJson<String?>(cstatus),
      'cal': serializer.toJson<String?>(cal),
      'sync1': serializer.toJson<String?>(sync1),
      'sync2': serializer.toJson<String?>(sync2),
      'distance': serializer.toJson<String?>(distance),
    };
  }

  StepCount copyWith({
    int? id,
    DateTime? startTime,
    int? useTime,
    int? stepsNum,
    int? type,
    int? subType,
    Value<String?> speed = const Value.absent(),
    Value<String?> cstatus = const Value.absent(),
    Value<String?> cal = const Value.absent(),
    Value<String?> sync1 = const Value.absent(),
    Value<String?> sync2 = const Value.absent(),
    Value<String?> distance = const Value.absent(),
  }) => StepCount(
    id: id ?? this.id,
    startTime: startTime ?? this.startTime,
    useTime: useTime ?? this.useTime,
    stepsNum: stepsNum ?? this.stepsNum,
    type: type ?? this.type,
    subType: subType ?? this.subType,
    speed: speed.present ? speed.value : this.speed,
    cstatus: cstatus.present ? cstatus.value : this.cstatus,
    cal: cal.present ? cal.value : this.cal,
    sync1: sync1.present ? sync1.value : this.sync1,
    sync2: sync2.present ? sync2.value : this.sync2,
    distance: distance.present ? distance.value : this.distance,
  );
  StepCount copyWithCompanion(StepCountsCompanion data) {
    return StepCount(
      id: data.id.present ? data.id.value : this.id,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      useTime: data.useTime.present ? data.useTime.value : this.useTime,
      stepsNum: data.stepsNum.present ? data.stepsNum.value : this.stepsNum,
      type: data.type.present ? data.type.value : this.type,
      subType: data.subType.present ? data.subType.value : this.subType,
      speed: data.speed.present ? data.speed.value : this.speed,
      cstatus: data.cstatus.present ? data.cstatus.value : this.cstatus,
      cal: data.cal.present ? data.cal.value : this.cal,
      sync1: data.sync1.present ? data.sync1.value : this.sync1,
      sync2: data.sync2.present ? data.sync2.value : this.sync2,
      distance: data.distance.present ? data.distance.value : this.distance,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StepCount(')
          ..write('id: $id, ')
          ..write('startTime: $startTime, ')
          ..write('useTime: $useTime, ')
          ..write('stepsNum: $stepsNum, ')
          ..write('type: $type, ')
          ..write('subType: $subType, ')
          ..write('speed: $speed, ')
          ..write('cstatus: $cstatus, ')
          ..write('cal: $cal, ')
          ..write('sync1: $sync1, ')
          ..write('sync2: $sync2, ')
          ..write('distance: $distance')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    startTime,
    useTime,
    stepsNum,
    type,
    subType,
    speed,
    cstatus,
    cal,
    sync1,
    sync2,
    distance,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StepCount &&
          other.id == this.id &&
          other.startTime == this.startTime &&
          other.useTime == this.useTime &&
          other.stepsNum == this.stepsNum &&
          other.type == this.type &&
          other.subType == this.subType &&
          other.speed == this.speed &&
          other.cstatus == this.cstatus &&
          other.cal == this.cal &&
          other.sync1 == this.sync1 &&
          other.sync2 == this.sync2 &&
          other.distance == this.distance);
}

class StepCountsCompanion extends UpdateCompanion<StepCount> {
  final Value<int> id;
  final Value<DateTime> startTime;
  final Value<int> useTime;
  final Value<int> stepsNum;
  final Value<int> type;
  final Value<int> subType;
  final Value<String?> speed;
  final Value<String?> cstatus;
  final Value<String?> cal;
  final Value<String?> sync1;
  final Value<String?> sync2;
  final Value<String?> distance;
  const StepCountsCompanion({
    this.id = const Value.absent(),
    this.startTime = const Value.absent(),
    this.useTime = const Value.absent(),
    this.stepsNum = const Value.absent(),
    this.type = const Value.absent(),
    this.subType = const Value.absent(),
    this.speed = const Value.absent(),
    this.cstatus = const Value.absent(),
    this.cal = const Value.absent(),
    this.sync1 = const Value.absent(),
    this.sync2 = const Value.absent(),
    this.distance = const Value.absent(),
  });
  StepCountsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime startTime,
    this.useTime = const Value.absent(),
    this.stepsNum = const Value.absent(),
    this.type = const Value.absent(),
    this.subType = const Value.absent(),
    this.speed = const Value.absent(),
    this.cstatus = const Value.absent(),
    this.cal = const Value.absent(),
    this.sync1 = const Value.absent(),
    this.sync2 = const Value.absent(),
    this.distance = const Value.absent(),
  }) : startTime = Value(startTime);
  static Insertable<StepCount> custom({
    Expression<int>? id,
    Expression<DateTime>? startTime,
    Expression<int>? useTime,
    Expression<int>? stepsNum,
    Expression<int>? type,
    Expression<int>? subType,
    Expression<String>? speed,
    Expression<String>? cstatus,
    Expression<String>? cal,
    Expression<String>? sync1,
    Expression<String>? sync2,
    Expression<String>? distance,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startTime != null) 'start_time': startTime,
      if (useTime != null) 'use_time': useTime,
      if (stepsNum != null) 'steps_num': stepsNum,
      if (type != null) 'type': type,
      if (subType != null) 'sub_type': subType,
      if (speed != null) 'speed': speed,
      if (cstatus != null) 'cstatus': cstatus,
      if (cal != null) 'cal': cal,
      if (sync1 != null) 'sync1': sync1,
      if (sync2 != null) 'sync2': sync2,
      if (distance != null) 'distance': distance,
    });
  }

  StepCountsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? startTime,
    Value<int>? useTime,
    Value<int>? stepsNum,
    Value<int>? type,
    Value<int>? subType,
    Value<String?>? speed,
    Value<String?>? cstatus,
    Value<String?>? cal,
    Value<String?>? sync1,
    Value<String?>? sync2,
    Value<String?>? distance,
  }) {
    return StepCountsCompanion(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      useTime: useTime ?? this.useTime,
      stepsNum: stepsNum ?? this.stepsNum,
      type: type ?? this.type,
      subType: subType ?? this.subType,
      speed: speed ?? this.speed,
      cstatus: cstatus ?? this.cstatus,
      cal: cal ?? this.cal,
      sync1: sync1 ?? this.sync1,
      sync2: sync2 ?? this.sync2,
      distance: distance ?? this.distance,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (useTime.present) {
      map['use_time'] = Variable<int>(useTime.value);
    }
    if (stepsNum.present) {
      map['steps_num'] = Variable<int>(stepsNum.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    if (subType.present) {
      map['sub_type'] = Variable<int>(subType.value);
    }
    if (speed.present) {
      map['speed'] = Variable<String>(speed.value);
    }
    if (cstatus.present) {
      map['cstatus'] = Variable<String>(cstatus.value);
    }
    if (cal.present) {
      map['cal'] = Variable<String>(cal.value);
    }
    if (sync1.present) {
      map['sync1'] = Variable<String>(sync1.value);
    }
    if (sync2.present) {
      map['sync2'] = Variable<String>(sync2.value);
    }
    if (distance.present) {
      map['distance'] = Variable<String>(distance.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StepCountsCompanion(')
          ..write('id: $id, ')
          ..write('startTime: $startTime, ')
          ..write('useTime: $useTime, ')
          ..write('stepsNum: $stepsNum, ')
          ..write('type: $type, ')
          ..write('subType: $subType, ')
          ..write('speed: $speed, ')
          ..write('cstatus: $cstatus, ')
          ..write('cal: $cal, ')
          ..write('sync1: $sync1, ')
          ..write('sync2: $sync2, ')
          ..write('distance: $distance')
          ..write(')'))
        .toString();
  }
}

class $StepPerDaysTable extends StepPerDays
    with TableInfo<$StepPerDaysTable, StepPerDay> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StepPerDaysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<DateTime> time = GeneratedColumn<DateTime>(
    'time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stepCountMeta = const VerificationMeta(
    'stepCount',
  );
  @override
  late final GeneratedColumn<int> stepCount = GeneratedColumn<int>(
    'step_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<int> state = GeneratedColumn<int>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _backup1Meta = const VerificationMeta(
    'backup1',
  );
  @override
  late final GeneratedColumn<int> backup1 = GeneratedColumn<int>(
    'backup1',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    time,
    stepCount,
    state,
    backup1,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'step_per_days';
  @override
  VerificationContext validateIntegrity(
    Insertable<StepPerDay> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('time')) {
      context.handle(
        _timeMeta,
        time.isAcceptableOrUnknown(data['time']!, _timeMeta),
      );
    } else if (isInserting) {
      context.missing(_timeMeta);
    }
    if (data.containsKey('step_count')) {
      context.handle(
        _stepCountMeta,
        stepCount.isAcceptableOrUnknown(data['step_count']!, _stepCountMeta),
      );
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    }
    if (data.containsKey('backup1')) {
      context.handle(
        _backup1Meta,
        backup1.isAcceptableOrUnknown(data['backup1']!, _backup1Meta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StepPerDay map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StepPerDay(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      time: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}time'],
      )!,
      stepCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}step_count'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}state'],
      )!,
      backup1: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}backup1'],
      )!,
    );
  }

  @override
  $StepPerDaysTable createAlias(String alias) {
    return $StepPerDaysTable(attachedDatabase, alias);
  }
}

class StepPerDay extends DataClass implements Insertable<StepPerDay> {
  final int id;
  final String date;
  final DateTime time;
  final int stepCount;
  final int state;
  final int backup1;
  const StepPerDay({
    required this.id,
    required this.date,
    required this.time,
    required this.stepCount,
    required this.state,
    required this.backup1,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<String>(date);
    map['time'] = Variable<DateTime>(time);
    map['step_count'] = Variable<int>(stepCount);
    map['state'] = Variable<int>(state);
    map['backup1'] = Variable<int>(backup1);
    return map;
  }

  StepPerDaysCompanion toCompanion(bool nullToAbsent) {
    return StepPerDaysCompanion(
      id: Value(id),
      date: Value(date),
      time: Value(time),
      stepCount: Value(stepCount),
      state: Value(state),
      backup1: Value(backup1),
    );
  }

  factory StepPerDay.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StepPerDay(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      time: serializer.fromJson<DateTime>(json['time']),
      stepCount: serializer.fromJson<int>(json['stepCount']),
      state: serializer.fromJson<int>(json['state']),
      backup1: serializer.fromJson<int>(json['backup1']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<String>(date),
      'time': serializer.toJson<DateTime>(time),
      'stepCount': serializer.toJson<int>(stepCount),
      'state': serializer.toJson<int>(state),
      'backup1': serializer.toJson<int>(backup1),
    };
  }

  StepPerDay copyWith({
    int? id,
    String? date,
    DateTime? time,
    int? stepCount,
    int? state,
    int? backup1,
  }) => StepPerDay(
    id: id ?? this.id,
    date: date ?? this.date,
    time: time ?? this.time,
    stepCount: stepCount ?? this.stepCount,
    state: state ?? this.state,
    backup1: backup1 ?? this.backup1,
  );
  StepPerDay copyWithCompanion(StepPerDaysCompanion data) {
    return StepPerDay(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      time: data.time.present ? data.time.value : this.time,
      stepCount: data.stepCount.present ? data.stepCount.value : this.stepCount,
      state: data.state.present ? data.state.value : this.state,
      backup1: data.backup1.present ? data.backup1.value : this.backup1,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StepPerDay(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('time: $time, ')
          ..write('stepCount: $stepCount, ')
          ..write('state: $state, ')
          ..write('backup1: $backup1')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, time, stepCount, state, backup1);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StepPerDay &&
          other.id == this.id &&
          other.date == this.date &&
          other.time == this.time &&
          other.stepCount == this.stepCount &&
          other.state == this.state &&
          other.backup1 == this.backup1);
}

class StepPerDaysCompanion extends UpdateCompanion<StepPerDay> {
  final Value<int> id;
  final Value<String> date;
  final Value<DateTime> time;
  final Value<int> stepCount;
  final Value<int> state;
  final Value<int> backup1;
  const StepPerDaysCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.time = const Value.absent(),
    this.stepCount = const Value.absent(),
    this.state = const Value.absent(),
    this.backup1 = const Value.absent(),
  });
  StepPerDaysCompanion.insert({
    this.id = const Value.absent(),
    required String date,
    required DateTime time,
    this.stepCount = const Value.absent(),
    this.state = const Value.absent(),
    this.backup1 = const Value.absent(),
  }) : date = Value(date),
       time = Value(time);
  static Insertable<StepPerDay> custom({
    Expression<int>? id,
    Expression<String>? date,
    Expression<DateTime>? time,
    Expression<int>? stepCount,
    Expression<int>? state,
    Expression<int>? backup1,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (time != null) 'time': time,
      if (stepCount != null) 'step_count': stepCount,
      if (state != null) 'state': state,
      if (backup1 != null) 'backup1': backup1,
    });
  }

  StepPerDaysCompanion copyWith({
    Value<int>? id,
    Value<String>? date,
    Value<DateTime>? time,
    Value<int>? stepCount,
    Value<int>? state,
    Value<int>? backup1,
  }) {
    return StepPerDaysCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      time: time ?? this.time,
      stepCount: stepCount ?? this.stepCount,
      state: state ?? this.state,
      backup1: backup1 ?? this.backup1,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (time.present) {
      map['time'] = Variable<DateTime>(time.value);
    }
    if (stepCount.present) {
      map['step_count'] = Variable<int>(stepCount.value);
    }
    if (state.present) {
      map['state'] = Variable<int>(state.value);
    }
    if (backup1.present) {
      map['backup1'] = Variable<int>(backup1.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StepPerDaysCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('time: $time, ')
          ..write('stepCount: $stepCount, ')
          ..write('state: $state, ')
          ..write('backup1: $backup1')
          ..write(')'))
        .toString();
  }
}

class $TargetsTable extends Targets with TableInfo<$TargetsTable, Target> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TargetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _targetNameMeta = const VerificationMeta(
    'targetName',
  );
  @override
  late final GeneratedColumn<String> targetName = GeneratedColumn<String>(
    'target_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetHintMeta = const VerificationMeta(
    'targetHint',
  );
  @override
  late final GeneratedColumn<String> targetHint = GeneratedColumn<String>(
    'target_hint',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetAllTimesMeta = const VerificationMeta(
    'targetAllTimes',
  );
  @override
  late final GeneratedColumn<int> targetAllTimes = GeneratedColumn<int>(
    'target_all_times',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _targetFinishTimesMeta = const VerificationMeta(
    'targetFinishTimes',
  );
  @override
  late final GeneratedColumn<int> targetFinishTimes = GeneratedColumn<int>(
    'target_finish_times',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isLoopMeta = const VerificationMeta('isLoop');
  @override
  late final GeneratedColumn<bool> isLoop = GeneratedColumn<bool>(
    'is_loop',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_loop" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _achieveDataListMeta = const VerificationMeta(
    'achieveDataList',
  );
  @override
  late final GeneratedColumn<String> achieveDataList = GeneratedColumn<String>(
    'achieve_data_list',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastTimeMeta = const VerificationMeta(
    'lastTime',
  );
  @override
  late final GeneratedColumn<DateTime> lastTime = GeneratedColumn<DateTime>(
    'last_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetTimeMeta = const VerificationMeta(
    'targetTime',
  );
  @override
  late final GeneratedColumn<DateTime> targetTime = GeneratedColumn<DateTime>(
    'target_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetTypeMeta = const VerificationMeta(
    'targetType',
  );
  @override
  late final GeneratedColumn<int> targetType = GeneratedColumn<int>(
    'target_type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _targetSync1Meta = const VerificationMeta(
    'targetSync1',
  );
  @override
  late final GeneratedColumn<String> targetSync1 = GeneratedColumn<String>(
    'target_sync1',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetSync2Meta = const VerificationMeta(
    'targetSync2',
  );
  @override
  late final GeneratedColumn<String> targetSync2 = GeneratedColumn<String>(
    'target_sync2',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetSync3Meta = const VerificationMeta(
    'targetSync3',
  );
  @override
  late final GeneratedColumn<String> targetSync3 = GeneratedColumn<String>(
    'target_sync3',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetSync4Meta = const VerificationMeta(
    'targetSync4',
  );
  @override
  late final GeneratedColumn<String> targetSync4 = GeneratedColumn<String>(
    'target_sync4',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    targetName,
    targetHint,
    targetAllTimes,
    targetFinishTimes,
    isLoop,
    achieveDataList,
    startTime,
    lastTime,
    targetTime,
    targetType,
    targetSync1,
    targetSync2,
    targetSync3,
    targetSync4,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'targets';
  @override
  VerificationContext validateIntegrity(
    Insertable<Target> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('target_name')) {
      context.handle(
        _targetNameMeta,
        targetName.isAcceptableOrUnknown(data['target_name']!, _targetNameMeta),
      );
    }
    if (data.containsKey('target_hint')) {
      context.handle(
        _targetHintMeta,
        targetHint.isAcceptableOrUnknown(data['target_hint']!, _targetHintMeta),
      );
    }
    if (data.containsKey('target_all_times')) {
      context.handle(
        _targetAllTimesMeta,
        targetAllTimes.isAcceptableOrUnknown(
          data['target_all_times']!,
          _targetAllTimesMeta,
        ),
      );
    }
    if (data.containsKey('target_finish_times')) {
      context.handle(
        _targetFinishTimesMeta,
        targetFinishTimes.isAcceptableOrUnknown(
          data['target_finish_times']!,
          _targetFinishTimesMeta,
        ),
      );
    }
    if (data.containsKey('is_loop')) {
      context.handle(
        _isLoopMeta,
        isLoop.isAcceptableOrUnknown(data['is_loop']!, _isLoopMeta),
      );
    }
    if (data.containsKey('achieve_data_list')) {
      context.handle(
        _achieveDataListMeta,
        achieveDataList.isAcceptableOrUnknown(
          data['achieve_data_list']!,
          _achieveDataListMeta,
        ),
      );
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('last_time')) {
      context.handle(
        _lastTimeMeta,
        lastTime.isAcceptableOrUnknown(data['last_time']!, _lastTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_lastTimeMeta);
    }
    if (data.containsKey('target_time')) {
      context.handle(
        _targetTimeMeta,
        targetTime.isAcceptableOrUnknown(data['target_time']!, _targetTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_targetTimeMeta);
    }
    if (data.containsKey('target_type')) {
      context.handle(
        _targetTypeMeta,
        targetType.isAcceptableOrUnknown(data['target_type']!, _targetTypeMeta),
      );
    }
    if (data.containsKey('target_sync1')) {
      context.handle(
        _targetSync1Meta,
        targetSync1.isAcceptableOrUnknown(
          data['target_sync1']!,
          _targetSync1Meta,
        ),
      );
    }
    if (data.containsKey('target_sync2')) {
      context.handle(
        _targetSync2Meta,
        targetSync2.isAcceptableOrUnknown(
          data['target_sync2']!,
          _targetSync2Meta,
        ),
      );
    }
    if (data.containsKey('target_sync3')) {
      context.handle(
        _targetSync3Meta,
        targetSync3.isAcceptableOrUnknown(
          data['target_sync3']!,
          _targetSync3Meta,
        ),
      );
    }
    if (data.containsKey('target_sync4')) {
      context.handle(
        _targetSync4Meta,
        targetSync4.isAcceptableOrUnknown(
          data['target_sync4']!,
          _targetSync4Meta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Target map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Target(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      targetName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_name'],
      ),
      targetHint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_hint'],
      ),
      targetAllTimes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_all_times'],
      )!,
      targetFinishTimes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_finish_times'],
      )!,
      isLoop: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_loop'],
      )!,
      achieveDataList: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}achieve_data_list'],
      ),
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_time'],
      )!,
      lastTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_time'],
      )!,
      targetTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}target_time'],
      )!,
      targetType: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_type'],
      )!,
      targetSync1: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_sync1'],
      ),
      targetSync2: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_sync2'],
      ),
      targetSync3: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_sync3'],
      ),
      targetSync4: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_sync4'],
      ),
    );
  }

  @override
  $TargetsTable createAlias(String alias) {
    return $TargetsTable(attachedDatabase, alias);
  }
}

class Target extends DataClass implements Insertable<Target> {
  final int id;
  final String? targetName;
  final String? targetHint;
  final int targetAllTimes;
  final int targetFinishTimes;
  final bool isLoop;
  final String? achieveDataList;
  final DateTime startTime;
  final DateTime lastTime;
  final DateTime targetTime;
  final int targetType;
  final String? targetSync1;
  final String? targetSync2;
  final String? targetSync3;
  final String? targetSync4;
  const Target({
    required this.id,
    this.targetName,
    this.targetHint,
    required this.targetAllTimes,
    required this.targetFinishTimes,
    required this.isLoop,
    this.achieveDataList,
    required this.startTime,
    required this.lastTime,
    required this.targetTime,
    required this.targetType,
    this.targetSync1,
    this.targetSync2,
    this.targetSync3,
    this.targetSync4,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || targetName != null) {
      map['target_name'] = Variable<String>(targetName);
    }
    if (!nullToAbsent || targetHint != null) {
      map['target_hint'] = Variable<String>(targetHint);
    }
    map['target_all_times'] = Variable<int>(targetAllTimes);
    map['target_finish_times'] = Variable<int>(targetFinishTimes);
    map['is_loop'] = Variable<bool>(isLoop);
    if (!nullToAbsent || achieveDataList != null) {
      map['achieve_data_list'] = Variable<String>(achieveDataList);
    }
    map['start_time'] = Variable<DateTime>(startTime);
    map['last_time'] = Variable<DateTime>(lastTime);
    map['target_time'] = Variable<DateTime>(targetTime);
    map['target_type'] = Variable<int>(targetType);
    if (!nullToAbsent || targetSync1 != null) {
      map['target_sync1'] = Variable<String>(targetSync1);
    }
    if (!nullToAbsent || targetSync2 != null) {
      map['target_sync2'] = Variable<String>(targetSync2);
    }
    if (!nullToAbsent || targetSync3 != null) {
      map['target_sync3'] = Variable<String>(targetSync3);
    }
    if (!nullToAbsent || targetSync4 != null) {
      map['target_sync4'] = Variable<String>(targetSync4);
    }
    return map;
  }

  TargetsCompanion toCompanion(bool nullToAbsent) {
    return TargetsCompanion(
      id: Value(id),
      targetName: targetName == null && nullToAbsent
          ? const Value.absent()
          : Value(targetName),
      targetHint: targetHint == null && nullToAbsent
          ? const Value.absent()
          : Value(targetHint),
      targetAllTimes: Value(targetAllTimes),
      targetFinishTimes: Value(targetFinishTimes),
      isLoop: Value(isLoop),
      achieveDataList: achieveDataList == null && nullToAbsent
          ? const Value.absent()
          : Value(achieveDataList),
      startTime: Value(startTime),
      lastTime: Value(lastTime),
      targetTime: Value(targetTime),
      targetType: Value(targetType),
      targetSync1: targetSync1 == null && nullToAbsent
          ? const Value.absent()
          : Value(targetSync1),
      targetSync2: targetSync2 == null && nullToAbsent
          ? const Value.absent()
          : Value(targetSync2),
      targetSync3: targetSync3 == null && nullToAbsent
          ? const Value.absent()
          : Value(targetSync3),
      targetSync4: targetSync4 == null && nullToAbsent
          ? const Value.absent()
          : Value(targetSync4),
    );
  }

  factory Target.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Target(
      id: serializer.fromJson<int>(json['id']),
      targetName: serializer.fromJson<String?>(json['targetName']),
      targetHint: serializer.fromJson<String?>(json['targetHint']),
      targetAllTimes: serializer.fromJson<int>(json['targetAllTimes']),
      targetFinishTimes: serializer.fromJson<int>(json['targetFinishTimes']),
      isLoop: serializer.fromJson<bool>(json['isLoop']),
      achieveDataList: serializer.fromJson<String?>(json['achieveDataList']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      lastTime: serializer.fromJson<DateTime>(json['lastTime']),
      targetTime: serializer.fromJson<DateTime>(json['targetTime']),
      targetType: serializer.fromJson<int>(json['targetType']),
      targetSync1: serializer.fromJson<String?>(json['targetSync1']),
      targetSync2: serializer.fromJson<String?>(json['targetSync2']),
      targetSync3: serializer.fromJson<String?>(json['targetSync3']),
      targetSync4: serializer.fromJson<String?>(json['targetSync4']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'targetName': serializer.toJson<String?>(targetName),
      'targetHint': serializer.toJson<String?>(targetHint),
      'targetAllTimes': serializer.toJson<int>(targetAllTimes),
      'targetFinishTimes': serializer.toJson<int>(targetFinishTimes),
      'isLoop': serializer.toJson<bool>(isLoop),
      'achieveDataList': serializer.toJson<String?>(achieveDataList),
      'startTime': serializer.toJson<DateTime>(startTime),
      'lastTime': serializer.toJson<DateTime>(lastTime),
      'targetTime': serializer.toJson<DateTime>(targetTime),
      'targetType': serializer.toJson<int>(targetType),
      'targetSync1': serializer.toJson<String?>(targetSync1),
      'targetSync2': serializer.toJson<String?>(targetSync2),
      'targetSync3': serializer.toJson<String?>(targetSync3),
      'targetSync4': serializer.toJson<String?>(targetSync4),
    };
  }

  Target copyWith({
    int? id,
    Value<String?> targetName = const Value.absent(),
    Value<String?> targetHint = const Value.absent(),
    int? targetAllTimes,
    int? targetFinishTimes,
    bool? isLoop,
    Value<String?> achieveDataList = const Value.absent(),
    DateTime? startTime,
    DateTime? lastTime,
    DateTime? targetTime,
    int? targetType,
    Value<String?> targetSync1 = const Value.absent(),
    Value<String?> targetSync2 = const Value.absent(),
    Value<String?> targetSync3 = const Value.absent(),
    Value<String?> targetSync4 = const Value.absent(),
  }) => Target(
    id: id ?? this.id,
    targetName: targetName.present ? targetName.value : this.targetName,
    targetHint: targetHint.present ? targetHint.value : this.targetHint,
    targetAllTimes: targetAllTimes ?? this.targetAllTimes,
    targetFinishTimes: targetFinishTimes ?? this.targetFinishTimes,
    isLoop: isLoop ?? this.isLoop,
    achieveDataList: achieveDataList.present
        ? achieveDataList.value
        : this.achieveDataList,
    startTime: startTime ?? this.startTime,
    lastTime: lastTime ?? this.lastTime,
    targetTime: targetTime ?? this.targetTime,
    targetType: targetType ?? this.targetType,
    targetSync1: targetSync1.present ? targetSync1.value : this.targetSync1,
    targetSync2: targetSync2.present ? targetSync2.value : this.targetSync2,
    targetSync3: targetSync3.present ? targetSync3.value : this.targetSync3,
    targetSync4: targetSync4.present ? targetSync4.value : this.targetSync4,
  );
  Target copyWithCompanion(TargetsCompanion data) {
    return Target(
      id: data.id.present ? data.id.value : this.id,
      targetName: data.targetName.present
          ? data.targetName.value
          : this.targetName,
      targetHint: data.targetHint.present
          ? data.targetHint.value
          : this.targetHint,
      targetAllTimes: data.targetAllTimes.present
          ? data.targetAllTimes.value
          : this.targetAllTimes,
      targetFinishTimes: data.targetFinishTimes.present
          ? data.targetFinishTimes.value
          : this.targetFinishTimes,
      isLoop: data.isLoop.present ? data.isLoop.value : this.isLoop,
      achieveDataList: data.achieveDataList.present
          ? data.achieveDataList.value
          : this.achieveDataList,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      lastTime: data.lastTime.present ? data.lastTime.value : this.lastTime,
      targetTime: data.targetTime.present
          ? data.targetTime.value
          : this.targetTime,
      targetType: data.targetType.present
          ? data.targetType.value
          : this.targetType,
      targetSync1: data.targetSync1.present
          ? data.targetSync1.value
          : this.targetSync1,
      targetSync2: data.targetSync2.present
          ? data.targetSync2.value
          : this.targetSync2,
      targetSync3: data.targetSync3.present
          ? data.targetSync3.value
          : this.targetSync3,
      targetSync4: data.targetSync4.present
          ? data.targetSync4.value
          : this.targetSync4,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Target(')
          ..write('id: $id, ')
          ..write('targetName: $targetName, ')
          ..write('targetHint: $targetHint, ')
          ..write('targetAllTimes: $targetAllTimes, ')
          ..write('targetFinishTimes: $targetFinishTimes, ')
          ..write('isLoop: $isLoop, ')
          ..write('achieveDataList: $achieveDataList, ')
          ..write('startTime: $startTime, ')
          ..write('lastTime: $lastTime, ')
          ..write('targetTime: $targetTime, ')
          ..write('targetType: $targetType, ')
          ..write('targetSync1: $targetSync1, ')
          ..write('targetSync2: $targetSync2, ')
          ..write('targetSync3: $targetSync3, ')
          ..write('targetSync4: $targetSync4')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    targetName,
    targetHint,
    targetAllTimes,
    targetFinishTimes,
    isLoop,
    achieveDataList,
    startTime,
    lastTime,
    targetTime,
    targetType,
    targetSync1,
    targetSync2,
    targetSync3,
    targetSync4,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Target &&
          other.id == this.id &&
          other.targetName == this.targetName &&
          other.targetHint == this.targetHint &&
          other.targetAllTimes == this.targetAllTimes &&
          other.targetFinishTimes == this.targetFinishTimes &&
          other.isLoop == this.isLoop &&
          other.achieveDataList == this.achieveDataList &&
          other.startTime == this.startTime &&
          other.lastTime == this.lastTime &&
          other.targetTime == this.targetTime &&
          other.targetType == this.targetType &&
          other.targetSync1 == this.targetSync1 &&
          other.targetSync2 == this.targetSync2 &&
          other.targetSync3 == this.targetSync3 &&
          other.targetSync4 == this.targetSync4);
}

class TargetsCompanion extends UpdateCompanion<Target> {
  final Value<int> id;
  final Value<String?> targetName;
  final Value<String?> targetHint;
  final Value<int> targetAllTimes;
  final Value<int> targetFinishTimes;
  final Value<bool> isLoop;
  final Value<String?> achieveDataList;
  final Value<DateTime> startTime;
  final Value<DateTime> lastTime;
  final Value<DateTime> targetTime;
  final Value<int> targetType;
  final Value<String?> targetSync1;
  final Value<String?> targetSync2;
  final Value<String?> targetSync3;
  final Value<String?> targetSync4;
  const TargetsCompanion({
    this.id = const Value.absent(),
    this.targetName = const Value.absent(),
    this.targetHint = const Value.absent(),
    this.targetAllTimes = const Value.absent(),
    this.targetFinishTimes = const Value.absent(),
    this.isLoop = const Value.absent(),
    this.achieveDataList = const Value.absent(),
    this.startTime = const Value.absent(),
    this.lastTime = const Value.absent(),
    this.targetTime = const Value.absent(),
    this.targetType = const Value.absent(),
    this.targetSync1 = const Value.absent(),
    this.targetSync2 = const Value.absent(),
    this.targetSync3 = const Value.absent(),
    this.targetSync4 = const Value.absent(),
  });
  TargetsCompanion.insert({
    this.id = const Value.absent(),
    this.targetName = const Value.absent(),
    this.targetHint = const Value.absent(),
    this.targetAllTimes = const Value.absent(),
    this.targetFinishTimes = const Value.absent(),
    this.isLoop = const Value.absent(),
    this.achieveDataList = const Value.absent(),
    required DateTime startTime,
    required DateTime lastTime,
    required DateTime targetTime,
    this.targetType = const Value.absent(),
    this.targetSync1 = const Value.absent(),
    this.targetSync2 = const Value.absent(),
    this.targetSync3 = const Value.absent(),
    this.targetSync4 = const Value.absent(),
  }) : startTime = Value(startTime),
       lastTime = Value(lastTime),
       targetTime = Value(targetTime);
  static Insertable<Target> custom({
    Expression<int>? id,
    Expression<String>? targetName,
    Expression<String>? targetHint,
    Expression<int>? targetAllTimes,
    Expression<int>? targetFinishTimes,
    Expression<bool>? isLoop,
    Expression<String>? achieveDataList,
    Expression<DateTime>? startTime,
    Expression<DateTime>? lastTime,
    Expression<DateTime>? targetTime,
    Expression<int>? targetType,
    Expression<String>? targetSync1,
    Expression<String>? targetSync2,
    Expression<String>? targetSync3,
    Expression<String>? targetSync4,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (targetName != null) 'target_name': targetName,
      if (targetHint != null) 'target_hint': targetHint,
      if (targetAllTimes != null) 'target_all_times': targetAllTimes,
      if (targetFinishTimes != null) 'target_finish_times': targetFinishTimes,
      if (isLoop != null) 'is_loop': isLoop,
      if (achieveDataList != null) 'achieve_data_list': achieveDataList,
      if (startTime != null) 'start_time': startTime,
      if (lastTime != null) 'last_time': lastTime,
      if (targetTime != null) 'target_time': targetTime,
      if (targetType != null) 'target_type': targetType,
      if (targetSync1 != null) 'target_sync1': targetSync1,
      if (targetSync2 != null) 'target_sync2': targetSync2,
      if (targetSync3 != null) 'target_sync3': targetSync3,
      if (targetSync4 != null) 'target_sync4': targetSync4,
    });
  }

  TargetsCompanion copyWith({
    Value<int>? id,
    Value<String?>? targetName,
    Value<String?>? targetHint,
    Value<int>? targetAllTimes,
    Value<int>? targetFinishTimes,
    Value<bool>? isLoop,
    Value<String?>? achieveDataList,
    Value<DateTime>? startTime,
    Value<DateTime>? lastTime,
    Value<DateTime>? targetTime,
    Value<int>? targetType,
    Value<String?>? targetSync1,
    Value<String?>? targetSync2,
    Value<String?>? targetSync3,
    Value<String?>? targetSync4,
  }) {
    return TargetsCompanion(
      id: id ?? this.id,
      targetName: targetName ?? this.targetName,
      targetHint: targetHint ?? this.targetHint,
      targetAllTimes: targetAllTimes ?? this.targetAllTimes,
      targetFinishTimes: targetFinishTimes ?? this.targetFinishTimes,
      isLoop: isLoop ?? this.isLoop,
      achieveDataList: achieveDataList ?? this.achieveDataList,
      startTime: startTime ?? this.startTime,
      lastTime: lastTime ?? this.lastTime,
      targetTime: targetTime ?? this.targetTime,
      targetType: targetType ?? this.targetType,
      targetSync1: targetSync1 ?? this.targetSync1,
      targetSync2: targetSync2 ?? this.targetSync2,
      targetSync3: targetSync3 ?? this.targetSync3,
      targetSync4: targetSync4 ?? this.targetSync4,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (targetName.present) {
      map['target_name'] = Variable<String>(targetName.value);
    }
    if (targetHint.present) {
      map['target_hint'] = Variable<String>(targetHint.value);
    }
    if (targetAllTimes.present) {
      map['target_all_times'] = Variable<int>(targetAllTimes.value);
    }
    if (targetFinishTimes.present) {
      map['target_finish_times'] = Variable<int>(targetFinishTimes.value);
    }
    if (isLoop.present) {
      map['is_loop'] = Variable<bool>(isLoop.value);
    }
    if (achieveDataList.present) {
      map['achieve_data_list'] = Variable<String>(achieveDataList.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (lastTime.present) {
      map['last_time'] = Variable<DateTime>(lastTime.value);
    }
    if (targetTime.present) {
      map['target_time'] = Variable<DateTime>(targetTime.value);
    }
    if (targetType.present) {
      map['target_type'] = Variable<int>(targetType.value);
    }
    if (targetSync1.present) {
      map['target_sync1'] = Variable<String>(targetSync1.value);
    }
    if (targetSync2.present) {
      map['target_sync2'] = Variable<String>(targetSync2.value);
    }
    if (targetSync3.present) {
      map['target_sync3'] = Variable<String>(targetSync3.value);
    }
    if (targetSync4.present) {
      map['target_sync4'] = Variable<String>(targetSync4.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TargetsCompanion(')
          ..write('id: $id, ')
          ..write('targetName: $targetName, ')
          ..write('targetHint: $targetHint, ')
          ..write('targetAllTimes: $targetAllTimes, ')
          ..write('targetFinishTimes: $targetFinishTimes, ')
          ..write('isLoop: $isLoop, ')
          ..write('achieveDataList: $achieveDataList, ')
          ..write('startTime: $startTime, ')
          ..write('lastTime: $lastTime, ')
          ..write('targetTime: $targetTime, ')
          ..write('targetType: $targetType, ')
          ..write('targetSync1: $targetSync1, ')
          ..write('targetSync2: $targetSync2, ')
          ..write('targetSync3: $targetSync3, ')
          ..write('targetSync4: $targetSync4')
          ..write(')'))
        .toString();
  }
}

class $WaterRecordsTable extends WaterRecords
    with TableInfo<$WaterRecordsTable, WaterRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WaterRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<DateTime> time = GeneratedColumn<DateTime>(
    'time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _waterTypeMeta = const VerificationMeta(
    'waterType',
  );
  @override
  late final GeneratedColumn<String> waterType = GeneratedColumn<String>(
    'water_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('白水'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, time, amount, note, waterType];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'water_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<WaterRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('time')) {
      context.handle(
        _timeMeta,
        time.isAcceptableOrUnknown(data['time']!, _timeMeta),
      );
    } else if (isInserting) {
      context.missing(_timeMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('water_type')) {
      context.handle(
        _waterTypeMeta,
        waterType.isAcceptableOrUnknown(data['water_type']!, _waterTypeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WaterRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WaterRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      time: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}time'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      waterType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}water_type'],
      )!,
    );
  }

  @override
  $WaterRecordsTable createAlias(String alias) {
    return $WaterRecordsTable(attachedDatabase, alias);
  }
}

class WaterRecord extends DataClass implements Insertable<WaterRecord> {
  final int id;
  final DateTime time;
  final int amount;
  final String? note;
  final String waterType;
  const WaterRecord({
    required this.id,
    required this.time,
    required this.amount,
    this.note,
    required this.waterType,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['time'] = Variable<DateTime>(time);
    map['amount'] = Variable<int>(amount);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['water_type'] = Variable<String>(waterType);
    return map;
  }

  WaterRecordsCompanion toCompanion(bool nullToAbsent) {
    return WaterRecordsCompanion(
      id: Value(id),
      time: Value(time),
      amount: Value(amount),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      waterType: Value(waterType),
    );
  }

  factory WaterRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WaterRecord(
      id: serializer.fromJson<int>(json['id']),
      time: serializer.fromJson<DateTime>(json['time']),
      amount: serializer.fromJson<int>(json['amount']),
      note: serializer.fromJson<String?>(json['note']),
      waterType: serializer.fromJson<String>(json['waterType']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'time': serializer.toJson<DateTime>(time),
      'amount': serializer.toJson<int>(amount),
      'note': serializer.toJson<String?>(note),
      'waterType': serializer.toJson<String>(waterType),
    };
  }

  WaterRecord copyWith({
    int? id,
    DateTime? time,
    int? amount,
    Value<String?> note = const Value.absent(),
    String? waterType,
  }) => WaterRecord(
    id: id ?? this.id,
    time: time ?? this.time,
    amount: amount ?? this.amount,
    note: note.present ? note.value : this.note,
    waterType: waterType ?? this.waterType,
  );
  WaterRecord copyWithCompanion(WaterRecordsCompanion data) {
    return WaterRecord(
      id: data.id.present ? data.id.value : this.id,
      time: data.time.present ? data.time.value : this.time,
      amount: data.amount.present ? data.amount.value : this.amount,
      note: data.note.present ? data.note.value : this.note,
      waterType: data.waterType.present ? data.waterType.value : this.waterType,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WaterRecord(')
          ..write('id: $id, ')
          ..write('time: $time, ')
          ..write('amount: $amount, ')
          ..write('note: $note, ')
          ..write('waterType: $waterType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, time, amount, note, waterType);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WaterRecord &&
          other.id == this.id &&
          other.time == this.time &&
          other.amount == this.amount &&
          other.note == this.note &&
          other.waterType == this.waterType);
}

class WaterRecordsCompanion extends UpdateCompanion<WaterRecord> {
  final Value<int> id;
  final Value<DateTime> time;
  final Value<int> amount;
  final Value<String?> note;
  final Value<String> waterType;
  const WaterRecordsCompanion({
    this.id = const Value.absent(),
    this.time = const Value.absent(),
    this.amount = const Value.absent(),
    this.note = const Value.absent(),
    this.waterType = const Value.absent(),
  });
  WaterRecordsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime time,
    this.amount = const Value.absent(),
    this.note = const Value.absent(),
    this.waterType = const Value.absent(),
  }) : time = Value(time);
  static Insertable<WaterRecord> custom({
    Expression<int>? id,
    Expression<DateTime>? time,
    Expression<int>? amount,
    Expression<String>? note,
    Expression<String>? waterType,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (time != null) 'time': time,
      if (amount != null) 'amount': amount,
      if (note != null) 'note': note,
      if (waterType != null) 'water_type': waterType,
    });
  }

  WaterRecordsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? time,
    Value<int>? amount,
    Value<String?>? note,
    Value<String>? waterType,
  }) {
    return WaterRecordsCompanion(
      id: id ?? this.id,
      time: time ?? this.time,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      waterType: waterType ?? this.waterType,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (time.present) {
      map['time'] = Variable<DateTime>(time.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (waterType.present) {
      map['water_type'] = Variable<String>(waterType.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WaterRecordsCompanion(')
          ..write('id: $id, ')
          ..write('time: $time, ')
          ..write('amount: $amount, ')
          ..write('note: $note, ')
          ..write('waterType: $waterType')
          ..write(')'))
        .toString();
  }
}

class $DietRecordsTable extends DietRecords
    with TableInfo<$DietRecordsTable, DietRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DietRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<DateTime> time = GeneratedColumn<DateTime>(
    'time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _caloriesMeta = const VerificationMeta(
    'calories',
  );
  @override
  late final GeneratedColumn<int> calories = GeneratedColumn<int>(
    'calories',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _foodNameMeta = const VerificationMeta(
    'foodName',
  );
  @override
  late final GeneratedColumn<String> foodName = GeneratedColumn<String>(
    'food_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mealTypeMeta = const VerificationMeta(
    'mealType',
  );
  @override
  late final GeneratedColumn<int> mealType = GeneratedColumn<int>(
    'meal_type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
    'weight',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    time,
    calories,
    foodName,
    note,
    mealType,
    weight,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'diet_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<DietRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('time')) {
      context.handle(
        _timeMeta,
        time.isAcceptableOrUnknown(data['time']!, _timeMeta),
      );
    } else if (isInserting) {
      context.missing(_timeMeta);
    }
    if (data.containsKey('calories')) {
      context.handle(
        _caloriesMeta,
        calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta),
      );
    }
    if (data.containsKey('food_name')) {
      context.handle(
        _foodNameMeta,
        foodName.isAcceptableOrUnknown(data['food_name']!, _foodNameMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('meal_type')) {
      context.handle(
        _mealTypeMeta,
        mealType.isAcceptableOrUnknown(data['meal_type']!, _mealTypeMeta),
      );
    }
    if (data.containsKey('weight')) {
      context.handle(
        _weightMeta,
        weight.isAcceptableOrUnknown(data['weight']!, _weightMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DietRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DietRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      time: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}time'],
      )!,
      calories: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}calories'],
      )!,
      foodName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}food_name'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      mealType: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}meal_type'],
      )!,
      weight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight'],
      )!,
    );
  }

  @override
  $DietRecordsTable createAlias(String alias) {
    return $DietRecordsTable(attachedDatabase, alias);
  }
}

class DietRecord extends DataClass implements Insertable<DietRecord> {
  final int id;
  final DateTime time;
  final int calories;
  final String? foodName;
  final String? note;
  final int mealType;
  final double weight;
  const DietRecord({
    required this.id,
    required this.time,
    required this.calories,
    this.foodName,
    this.note,
    required this.mealType,
    required this.weight,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['time'] = Variable<DateTime>(time);
    map['calories'] = Variable<int>(calories);
    if (!nullToAbsent || foodName != null) {
      map['food_name'] = Variable<String>(foodName);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['meal_type'] = Variable<int>(mealType);
    map['weight'] = Variable<double>(weight);
    return map;
  }

  DietRecordsCompanion toCompanion(bool nullToAbsent) {
    return DietRecordsCompanion(
      id: Value(id),
      time: Value(time),
      calories: Value(calories),
      foodName: foodName == null && nullToAbsent
          ? const Value.absent()
          : Value(foodName),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      mealType: Value(mealType),
      weight: Value(weight),
    );
  }

  factory DietRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DietRecord(
      id: serializer.fromJson<int>(json['id']),
      time: serializer.fromJson<DateTime>(json['time']),
      calories: serializer.fromJson<int>(json['calories']),
      foodName: serializer.fromJson<String?>(json['foodName']),
      note: serializer.fromJson<String?>(json['note']),
      mealType: serializer.fromJson<int>(json['mealType']),
      weight: serializer.fromJson<double>(json['weight']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'time': serializer.toJson<DateTime>(time),
      'calories': serializer.toJson<int>(calories),
      'foodName': serializer.toJson<String?>(foodName),
      'note': serializer.toJson<String?>(note),
      'mealType': serializer.toJson<int>(mealType),
      'weight': serializer.toJson<double>(weight),
    };
  }

  DietRecord copyWith({
    int? id,
    DateTime? time,
    int? calories,
    Value<String?> foodName = const Value.absent(),
    Value<String?> note = const Value.absent(),
    int? mealType,
    double? weight,
  }) => DietRecord(
    id: id ?? this.id,
    time: time ?? this.time,
    calories: calories ?? this.calories,
    foodName: foodName.present ? foodName.value : this.foodName,
    note: note.present ? note.value : this.note,
    mealType: mealType ?? this.mealType,
    weight: weight ?? this.weight,
  );
  DietRecord copyWithCompanion(DietRecordsCompanion data) {
    return DietRecord(
      id: data.id.present ? data.id.value : this.id,
      time: data.time.present ? data.time.value : this.time,
      calories: data.calories.present ? data.calories.value : this.calories,
      foodName: data.foodName.present ? data.foodName.value : this.foodName,
      note: data.note.present ? data.note.value : this.note,
      mealType: data.mealType.present ? data.mealType.value : this.mealType,
      weight: data.weight.present ? data.weight.value : this.weight,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DietRecord(')
          ..write('id: $id, ')
          ..write('time: $time, ')
          ..write('calories: $calories, ')
          ..write('foodName: $foodName, ')
          ..write('note: $note, ')
          ..write('mealType: $mealType, ')
          ..write('weight: $weight')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, time, calories, foodName, note, mealType, weight);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DietRecord &&
          other.id == this.id &&
          other.time == this.time &&
          other.calories == this.calories &&
          other.foodName == this.foodName &&
          other.note == this.note &&
          other.mealType == this.mealType &&
          other.weight == this.weight);
}

class DietRecordsCompanion extends UpdateCompanion<DietRecord> {
  final Value<int> id;
  final Value<DateTime> time;
  final Value<int> calories;
  final Value<String?> foodName;
  final Value<String?> note;
  final Value<int> mealType;
  final Value<double> weight;
  const DietRecordsCompanion({
    this.id = const Value.absent(),
    this.time = const Value.absent(),
    this.calories = const Value.absent(),
    this.foodName = const Value.absent(),
    this.note = const Value.absent(),
    this.mealType = const Value.absent(),
    this.weight = const Value.absent(),
  });
  DietRecordsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime time,
    this.calories = const Value.absent(),
    this.foodName = const Value.absent(),
    this.note = const Value.absent(),
    this.mealType = const Value.absent(),
    this.weight = const Value.absent(),
  }) : time = Value(time);
  static Insertable<DietRecord> custom({
    Expression<int>? id,
    Expression<DateTime>? time,
    Expression<int>? calories,
    Expression<String>? foodName,
    Expression<String>? note,
    Expression<int>? mealType,
    Expression<double>? weight,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (time != null) 'time': time,
      if (calories != null) 'calories': calories,
      if (foodName != null) 'food_name': foodName,
      if (note != null) 'note': note,
      if (mealType != null) 'meal_type': mealType,
      if (weight != null) 'weight': weight,
    });
  }

  DietRecordsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? time,
    Value<int>? calories,
    Value<String?>? foodName,
    Value<String?>? note,
    Value<int>? mealType,
    Value<double>? weight,
  }) {
    return DietRecordsCompanion(
      id: id ?? this.id,
      time: time ?? this.time,
      calories: calories ?? this.calories,
      foodName: foodName ?? this.foodName,
      note: note ?? this.note,
      mealType: mealType ?? this.mealType,
      weight: weight ?? this.weight,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (time.present) {
      map['time'] = Variable<DateTime>(time.value);
    }
    if (calories.present) {
      map['calories'] = Variable<int>(calories.value);
    }
    if (foodName.present) {
      map['food_name'] = Variable<String>(foodName.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (mealType.present) {
      map['meal_type'] = Variable<int>(mealType.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DietRecordsCompanion(')
          ..write('id: $id, ')
          ..write('time: $time, ')
          ..write('calories: $calories, ')
          ..write('foodName: $foodName, ')
          ..write('note: $note, ')
          ..write('mealType: $mealType, ')
          ..write('weight: $weight')
          ..write(')'))
        .toString();
  }
}

class $MoodRecordsTable extends MoodRecords
    with TableInfo<$MoodRecordsTable, MoodRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MoodRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<DateTime> time = GeneratedColumn<DateTime>(
    'time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _moodMeta = const VerificationMeta('mood');
  @override
  late final GeneratedColumn<int> mood = GeneratedColumn<int>(
    'mood',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reasonsMeta = const VerificationMeta(
    'reasons',
  );
  @override
  late final GeneratedColumn<String> reasons = GeneratedColumn<String>(
    'reasons',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, time, mood, note, reasons];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mood_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<MoodRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('time')) {
      context.handle(
        _timeMeta,
        time.isAcceptableOrUnknown(data['time']!, _timeMeta),
      );
    } else if (isInserting) {
      context.missing(_timeMeta);
    }
    if (data.containsKey('mood')) {
      context.handle(
        _moodMeta,
        mood.isAcceptableOrUnknown(data['mood']!, _moodMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('reasons')) {
      context.handle(
        _reasonsMeta,
        reasons.isAcceptableOrUnknown(data['reasons']!, _reasonsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MoodRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MoodRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      time: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}time'],
      )!,
      mood: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mood'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      reasons: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reasons'],
      ),
    );
  }

  @override
  $MoodRecordsTable createAlias(String alias) {
    return $MoodRecordsTable(attachedDatabase, alias);
  }
}

class MoodRecord extends DataClass implements Insertable<MoodRecord> {
  final int id;
  final DateTime time;
  final int mood;
  final String? note;
  final String? reasons;
  const MoodRecord({
    required this.id,
    required this.time,
    required this.mood,
    this.note,
    this.reasons,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['time'] = Variable<DateTime>(time);
    map['mood'] = Variable<int>(mood);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || reasons != null) {
      map['reasons'] = Variable<String>(reasons);
    }
    return map;
  }

  MoodRecordsCompanion toCompanion(bool nullToAbsent) {
    return MoodRecordsCompanion(
      id: Value(id),
      time: Value(time),
      mood: Value(mood),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      reasons: reasons == null && nullToAbsent
          ? const Value.absent()
          : Value(reasons),
    );
  }

  factory MoodRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MoodRecord(
      id: serializer.fromJson<int>(json['id']),
      time: serializer.fromJson<DateTime>(json['time']),
      mood: serializer.fromJson<int>(json['mood']),
      note: serializer.fromJson<String?>(json['note']),
      reasons: serializer.fromJson<String?>(json['reasons']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'time': serializer.toJson<DateTime>(time),
      'mood': serializer.toJson<int>(mood),
      'note': serializer.toJson<String?>(note),
      'reasons': serializer.toJson<String?>(reasons),
    };
  }

  MoodRecord copyWith({
    int? id,
    DateTime? time,
    int? mood,
    Value<String?> note = const Value.absent(),
    Value<String?> reasons = const Value.absent(),
  }) => MoodRecord(
    id: id ?? this.id,
    time: time ?? this.time,
    mood: mood ?? this.mood,
    note: note.present ? note.value : this.note,
    reasons: reasons.present ? reasons.value : this.reasons,
  );
  MoodRecord copyWithCompanion(MoodRecordsCompanion data) {
    return MoodRecord(
      id: data.id.present ? data.id.value : this.id,
      time: data.time.present ? data.time.value : this.time,
      mood: data.mood.present ? data.mood.value : this.mood,
      note: data.note.present ? data.note.value : this.note,
      reasons: data.reasons.present ? data.reasons.value : this.reasons,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MoodRecord(')
          ..write('id: $id, ')
          ..write('time: $time, ')
          ..write('mood: $mood, ')
          ..write('note: $note, ')
          ..write('reasons: $reasons')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, time, mood, note, reasons);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MoodRecord &&
          other.id == this.id &&
          other.time == this.time &&
          other.mood == this.mood &&
          other.note == this.note &&
          other.reasons == this.reasons);
}

class MoodRecordsCompanion extends UpdateCompanion<MoodRecord> {
  final Value<int> id;
  final Value<DateTime> time;
  final Value<int> mood;
  final Value<String?> note;
  final Value<String?> reasons;
  const MoodRecordsCompanion({
    this.id = const Value.absent(),
    this.time = const Value.absent(),
    this.mood = const Value.absent(),
    this.note = const Value.absent(),
    this.reasons = const Value.absent(),
  });
  MoodRecordsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime time,
    this.mood = const Value.absent(),
    this.note = const Value.absent(),
    this.reasons = const Value.absent(),
  }) : time = Value(time);
  static Insertable<MoodRecord> custom({
    Expression<int>? id,
    Expression<DateTime>? time,
    Expression<int>? mood,
    Expression<String>? note,
    Expression<String>? reasons,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (time != null) 'time': time,
      if (mood != null) 'mood': mood,
      if (note != null) 'note': note,
      if (reasons != null) 'reasons': reasons,
    });
  }

  MoodRecordsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? time,
    Value<int>? mood,
    Value<String?>? note,
    Value<String?>? reasons,
  }) {
    return MoodRecordsCompanion(
      id: id ?? this.id,
      time: time ?? this.time,
      mood: mood ?? this.mood,
      note: note ?? this.note,
      reasons: reasons ?? this.reasons,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (time.present) {
      map['time'] = Variable<DateTime>(time.value);
    }
    if (mood.present) {
      map['mood'] = Variable<int>(mood.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (reasons.present) {
      map['reasons'] = Variable<String>(reasons.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MoodRecordsCompanion(')
          ..write('id: $id, ')
          ..write('time: $time, ')
          ..write('mood: $mood, ')
          ..write('note: $note, ')
          ..write('reasons: $reasons')
          ..write(')'))
        .toString();
  }
}

class $TrainingPlansTable extends TrainingPlans
    with TableInfo<$TrainingPlansTable, TrainingPlan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrainingPlansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _goalTypeMeta = const VerificationMeta(
    'goalType',
  );
  @override
  late final GeneratedColumn<int> goalType = GeneratedColumn<int>(
    'goal_type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _levelTypeMeta = const VerificationMeta(
    'levelType',
  );
  @override
  late final GeneratedColumn<int> levelType = GeneratedColumn<int>(
    'level_type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _planNameMeta = const VerificationMeta(
    'planName',
  );
  @override
  late final GeneratedColumn<String> planName = GeneratedColumn<String>(
    'plan_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _planDescMeta = const VerificationMeta(
    'planDesc',
  );
  @override
  late final GeneratedColumn<String> planDesc = GeneratedColumn<String>(
    'plan_desc',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _planTipsMeta = const VerificationMeta(
    'planTips',
  );
  @override
  late final GeneratedColumn<String> planTips = GeneratedColumn<String>(
    'plan_tips',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weeklyPlanJsonMeta = const VerificationMeta(
    'weeklyPlanJson',
  );
  @override
  late final GeneratedColumn<String> weeklyPlanJson = GeneratedColumn<String>(
    'weekly_plan_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _completedDaysMeta = const VerificationMeta(
    'completedDays',
  );
  @override
  late final GeneratedColumn<String> completedDays = GeneratedColumn<String>(
    'completed_days',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    goalType,
    levelType,
    planName,
    planDesc,
    planTips,
    weeklyPlanJson,
    createdAt,
    isActive,
    completedDays,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'training_plans';
  @override
  VerificationContext validateIntegrity(
    Insertable<TrainingPlan> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('goal_type')) {
      context.handle(
        _goalTypeMeta,
        goalType.isAcceptableOrUnknown(data['goal_type']!, _goalTypeMeta),
      );
    }
    if (data.containsKey('level_type')) {
      context.handle(
        _levelTypeMeta,
        levelType.isAcceptableOrUnknown(data['level_type']!, _levelTypeMeta),
      );
    }
    if (data.containsKey('plan_name')) {
      context.handle(
        _planNameMeta,
        planName.isAcceptableOrUnknown(data['plan_name']!, _planNameMeta),
      );
    }
    if (data.containsKey('plan_desc')) {
      context.handle(
        _planDescMeta,
        planDesc.isAcceptableOrUnknown(data['plan_desc']!, _planDescMeta),
      );
    }
    if (data.containsKey('plan_tips')) {
      context.handle(
        _planTipsMeta,
        planTips.isAcceptableOrUnknown(data['plan_tips']!, _planTipsMeta),
      );
    }
    if (data.containsKey('weekly_plan_json')) {
      context.handle(
        _weeklyPlanJsonMeta,
        weeklyPlanJson.isAcceptableOrUnknown(
          data['weekly_plan_json']!,
          _weeklyPlanJsonMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('completed_days')) {
      context.handle(
        _completedDaysMeta,
        completedDays.isAcceptableOrUnknown(
          data['completed_days']!,
          _completedDaysMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TrainingPlan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrainingPlan(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      goalType: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}goal_type'],
      )!,
      levelType: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level_type'],
      )!,
      planName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_name'],
      ),
      planDesc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_desc'],
      ),
      planTips: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_tips'],
      ),
      weeklyPlanJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}weekly_plan_json'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      completedDays: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}completed_days'],
      ),
    );
  }

  @override
  $TrainingPlansTable createAlias(String alias) {
    return $TrainingPlansTable(attachedDatabase, alias);
  }
}

class TrainingPlan extends DataClass implements Insertable<TrainingPlan> {
  final int id;
  final int goalType;
  final int levelType;
  final String? planName;
  final String? planDesc;
  final String? planTips;
  final String? weeklyPlanJson;
  final DateTime createdAt;
  final bool isActive;
  final String? completedDays;
  const TrainingPlan({
    required this.id,
    required this.goalType,
    required this.levelType,
    this.planName,
    this.planDesc,
    this.planTips,
    this.weeklyPlanJson,
    required this.createdAt,
    required this.isActive,
    this.completedDays,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['goal_type'] = Variable<int>(goalType);
    map['level_type'] = Variable<int>(levelType);
    if (!nullToAbsent || planName != null) {
      map['plan_name'] = Variable<String>(planName);
    }
    if (!nullToAbsent || planDesc != null) {
      map['plan_desc'] = Variable<String>(planDesc);
    }
    if (!nullToAbsent || planTips != null) {
      map['plan_tips'] = Variable<String>(planTips);
    }
    if (!nullToAbsent || weeklyPlanJson != null) {
      map['weekly_plan_json'] = Variable<String>(weeklyPlanJson);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || completedDays != null) {
      map['completed_days'] = Variable<String>(completedDays);
    }
    return map;
  }

  TrainingPlansCompanion toCompanion(bool nullToAbsent) {
    return TrainingPlansCompanion(
      id: Value(id),
      goalType: Value(goalType),
      levelType: Value(levelType),
      planName: planName == null && nullToAbsent
          ? const Value.absent()
          : Value(planName),
      planDesc: planDesc == null && nullToAbsent
          ? const Value.absent()
          : Value(planDesc),
      planTips: planTips == null && nullToAbsent
          ? const Value.absent()
          : Value(planTips),
      weeklyPlanJson: weeklyPlanJson == null && nullToAbsent
          ? const Value.absent()
          : Value(weeklyPlanJson),
      createdAt: Value(createdAt),
      isActive: Value(isActive),
      completedDays: completedDays == null && nullToAbsent
          ? const Value.absent()
          : Value(completedDays),
    );
  }

  factory TrainingPlan.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrainingPlan(
      id: serializer.fromJson<int>(json['id']),
      goalType: serializer.fromJson<int>(json['goalType']),
      levelType: serializer.fromJson<int>(json['levelType']),
      planName: serializer.fromJson<String?>(json['planName']),
      planDesc: serializer.fromJson<String?>(json['planDesc']),
      planTips: serializer.fromJson<String?>(json['planTips']),
      weeklyPlanJson: serializer.fromJson<String?>(json['weeklyPlanJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      completedDays: serializer.fromJson<String?>(json['completedDays']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'goalType': serializer.toJson<int>(goalType),
      'levelType': serializer.toJson<int>(levelType),
      'planName': serializer.toJson<String?>(planName),
      'planDesc': serializer.toJson<String?>(planDesc),
      'planTips': serializer.toJson<String?>(planTips),
      'weeklyPlanJson': serializer.toJson<String?>(weeklyPlanJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isActive': serializer.toJson<bool>(isActive),
      'completedDays': serializer.toJson<String?>(completedDays),
    };
  }

  TrainingPlan copyWith({
    int? id,
    int? goalType,
    int? levelType,
    Value<String?> planName = const Value.absent(),
    Value<String?> planDesc = const Value.absent(),
    Value<String?> planTips = const Value.absent(),
    Value<String?> weeklyPlanJson = const Value.absent(),
    DateTime? createdAt,
    bool? isActive,
    Value<String?> completedDays = const Value.absent(),
  }) => TrainingPlan(
    id: id ?? this.id,
    goalType: goalType ?? this.goalType,
    levelType: levelType ?? this.levelType,
    planName: planName.present ? planName.value : this.planName,
    planDesc: planDesc.present ? planDesc.value : this.planDesc,
    planTips: planTips.present ? planTips.value : this.planTips,
    weeklyPlanJson: weeklyPlanJson.present
        ? weeklyPlanJson.value
        : this.weeklyPlanJson,
    createdAt: createdAt ?? this.createdAt,
    isActive: isActive ?? this.isActive,
    completedDays: completedDays.present
        ? completedDays.value
        : this.completedDays,
  );
  TrainingPlan copyWithCompanion(TrainingPlansCompanion data) {
    return TrainingPlan(
      id: data.id.present ? data.id.value : this.id,
      goalType: data.goalType.present ? data.goalType.value : this.goalType,
      levelType: data.levelType.present ? data.levelType.value : this.levelType,
      planName: data.planName.present ? data.planName.value : this.planName,
      planDesc: data.planDesc.present ? data.planDesc.value : this.planDesc,
      planTips: data.planTips.present ? data.planTips.value : this.planTips,
      weeklyPlanJson: data.weeklyPlanJson.present
          ? data.weeklyPlanJson.value
          : this.weeklyPlanJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      completedDays: data.completedDays.present
          ? data.completedDays.value
          : this.completedDays,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrainingPlan(')
          ..write('id: $id, ')
          ..write('goalType: $goalType, ')
          ..write('levelType: $levelType, ')
          ..write('planName: $planName, ')
          ..write('planDesc: $planDesc, ')
          ..write('planTips: $planTips, ')
          ..write('weeklyPlanJson: $weeklyPlanJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('isActive: $isActive, ')
          ..write('completedDays: $completedDays')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    goalType,
    levelType,
    planName,
    planDesc,
    planTips,
    weeklyPlanJson,
    createdAt,
    isActive,
    completedDays,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrainingPlan &&
          other.id == this.id &&
          other.goalType == this.goalType &&
          other.levelType == this.levelType &&
          other.planName == this.planName &&
          other.planDesc == this.planDesc &&
          other.planTips == this.planTips &&
          other.weeklyPlanJson == this.weeklyPlanJson &&
          other.createdAt == this.createdAt &&
          other.isActive == this.isActive &&
          other.completedDays == this.completedDays);
}

class TrainingPlansCompanion extends UpdateCompanion<TrainingPlan> {
  final Value<int> id;
  final Value<int> goalType;
  final Value<int> levelType;
  final Value<String?> planName;
  final Value<String?> planDesc;
  final Value<String?> planTips;
  final Value<String?> weeklyPlanJson;
  final Value<DateTime> createdAt;
  final Value<bool> isActive;
  final Value<String?> completedDays;
  const TrainingPlansCompanion({
    this.id = const Value.absent(),
    this.goalType = const Value.absent(),
    this.levelType = const Value.absent(),
    this.planName = const Value.absent(),
    this.planDesc = const Value.absent(),
    this.planTips = const Value.absent(),
    this.weeklyPlanJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isActive = const Value.absent(),
    this.completedDays = const Value.absent(),
  });
  TrainingPlansCompanion.insert({
    this.id = const Value.absent(),
    this.goalType = const Value.absent(),
    this.levelType = const Value.absent(),
    this.planName = const Value.absent(),
    this.planDesc = const Value.absent(),
    this.planTips = const Value.absent(),
    this.weeklyPlanJson = const Value.absent(),
    required DateTime createdAt,
    this.isActive = const Value.absent(),
    this.completedDays = const Value.absent(),
  }) : createdAt = Value(createdAt);
  static Insertable<TrainingPlan> custom({
    Expression<int>? id,
    Expression<int>? goalType,
    Expression<int>? levelType,
    Expression<String>? planName,
    Expression<String>? planDesc,
    Expression<String>? planTips,
    Expression<String>? weeklyPlanJson,
    Expression<DateTime>? createdAt,
    Expression<bool>? isActive,
    Expression<String>? completedDays,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (goalType != null) 'goal_type': goalType,
      if (levelType != null) 'level_type': levelType,
      if (planName != null) 'plan_name': planName,
      if (planDesc != null) 'plan_desc': planDesc,
      if (planTips != null) 'plan_tips': planTips,
      if (weeklyPlanJson != null) 'weekly_plan_json': weeklyPlanJson,
      if (createdAt != null) 'created_at': createdAt,
      if (isActive != null) 'is_active': isActive,
      if (completedDays != null) 'completed_days': completedDays,
    });
  }

  TrainingPlansCompanion copyWith({
    Value<int>? id,
    Value<int>? goalType,
    Value<int>? levelType,
    Value<String?>? planName,
    Value<String?>? planDesc,
    Value<String?>? planTips,
    Value<String?>? weeklyPlanJson,
    Value<DateTime>? createdAt,
    Value<bool>? isActive,
    Value<String?>? completedDays,
  }) {
    return TrainingPlansCompanion(
      id: id ?? this.id,
      goalType: goalType ?? this.goalType,
      levelType: levelType ?? this.levelType,
      planName: planName ?? this.planName,
      planDesc: planDesc ?? this.planDesc,
      planTips: planTips ?? this.planTips,
      weeklyPlanJson: weeklyPlanJson ?? this.weeklyPlanJson,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      completedDays: completedDays ?? this.completedDays,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (goalType.present) {
      map['goal_type'] = Variable<int>(goalType.value);
    }
    if (levelType.present) {
      map['level_type'] = Variable<int>(levelType.value);
    }
    if (planName.present) {
      map['plan_name'] = Variable<String>(planName.value);
    }
    if (planDesc.present) {
      map['plan_desc'] = Variable<String>(planDesc.value);
    }
    if (planTips.present) {
      map['plan_tips'] = Variable<String>(planTips.value);
    }
    if (weeklyPlanJson.present) {
      map['weekly_plan_json'] = Variable<String>(weeklyPlanJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (completedDays.present) {
      map['completed_days'] = Variable<String>(completedDays.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrainingPlansCompanion(')
          ..write('id: $id, ')
          ..write('goalType: $goalType, ')
          ..write('levelType: $levelType, ')
          ..write('planName: $planName, ')
          ..write('planDesc: $planDesc, ')
          ..write('planTips: $planTips, ')
          ..write('weeklyPlanJson: $weeklyPlanJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('isActive: $isActive, ')
          ..write('completedDays: $completedDays')
          ..write(')'))
        .toString();
  }
}

class $SleepRecordsTable extends SleepRecords
    with TableInfo<$SleepRecordsTable, SleepRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SleepRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sleepTimeMeta = const VerificationMeta(
    'sleepTime',
  );
  @override
  late final GeneratedColumn<DateTime> sleepTime = GeneratedColumn<DateTime>(
    'sleep_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wakeTimeMeta = const VerificationMeta(
    'wakeTime',
  );
  @override
  late final GeneratedColumn<DateTime> wakeTime = GeneratedColumn<DateTime>(
    'wake_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMeta = const VerificationMeta(
    'duration',
  );
  @override
  late final GeneratedColumn<int> duration = GeneratedColumn<int>(
    'duration',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _qualityMeta = const VerificationMeta(
    'quality',
  );
  @override
  late final GeneratedColumn<int> quality = GeneratedColumn<int>(
    'quality',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _sleepScoreMeta = const VerificationMeta(
    'sleepScore',
  );
  @override
  late final GeneratedColumn<int> sleepScore = GeneratedColumn<int>(
    'sleep_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _heartRateMeta = const VerificationMeta(
    'heartRate',
  );
  @override
  late final GeneratedColumn<int> heartRate = GeneratedColumn<int>(
    'heart_rate',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sleepTime,
    wakeTime,
    duration,
    quality,
    sleepScore,
    heartRate,
    tags,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sleep_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<SleepRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sleep_time')) {
      context.handle(
        _sleepTimeMeta,
        sleepTime.isAcceptableOrUnknown(data['sleep_time']!, _sleepTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_sleepTimeMeta);
    }
    if (data.containsKey('wake_time')) {
      context.handle(
        _wakeTimeMeta,
        wakeTime.isAcceptableOrUnknown(data['wake_time']!, _wakeTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_wakeTimeMeta);
    }
    if (data.containsKey('duration')) {
      context.handle(
        _durationMeta,
        duration.isAcceptableOrUnknown(data['duration']!, _durationMeta),
      );
    }
    if (data.containsKey('quality')) {
      context.handle(
        _qualityMeta,
        quality.isAcceptableOrUnknown(data['quality']!, _qualityMeta),
      );
    }
    if (data.containsKey('sleep_score')) {
      context.handle(
        _sleepScoreMeta,
        sleepScore.isAcceptableOrUnknown(data['sleep_score']!, _sleepScoreMeta),
      );
    }
    if (data.containsKey('heart_rate')) {
      context.handle(
        _heartRateMeta,
        heartRate.isAcceptableOrUnknown(data['heart_rate']!, _heartRateMeta),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SleepRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SleepRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sleepTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sleep_time'],
      )!,
      wakeTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}wake_time'],
      )!,
      duration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration'],
      )!,
      quality: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quality'],
      )!,
      sleepScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sleep_score'],
      )!,
      heartRate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}heart_rate'],
      )!,
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $SleepRecordsTable createAlias(String alias) {
    return $SleepRecordsTable(attachedDatabase, alias);
  }
}

class SleepRecord extends DataClass implements Insertable<SleepRecord> {
  final int id;
  final DateTime sleepTime;
  final DateTime wakeTime;
  final int duration;
  final int quality;
  final int sleepScore;
  final int heartRate;
  final String? tags;
  final String? note;
  const SleepRecord({
    required this.id,
    required this.sleepTime,
    required this.wakeTime,
    required this.duration,
    required this.quality,
    required this.sleepScore,
    required this.heartRate,
    this.tags,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['sleep_time'] = Variable<DateTime>(sleepTime);
    map['wake_time'] = Variable<DateTime>(wakeTime);
    map['duration'] = Variable<int>(duration);
    map['quality'] = Variable<int>(quality);
    map['sleep_score'] = Variable<int>(sleepScore);
    map['heart_rate'] = Variable<int>(heartRate);
    if (!nullToAbsent || tags != null) {
      map['tags'] = Variable<String>(tags);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  SleepRecordsCompanion toCompanion(bool nullToAbsent) {
    return SleepRecordsCompanion(
      id: Value(id),
      sleepTime: Value(sleepTime),
      wakeTime: Value(wakeTime),
      duration: Value(duration),
      quality: Value(quality),
      sleepScore: Value(sleepScore),
      heartRate: Value(heartRate),
      tags: tags == null && nullToAbsent ? const Value.absent() : Value(tags),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory SleepRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SleepRecord(
      id: serializer.fromJson<int>(json['id']),
      sleepTime: serializer.fromJson<DateTime>(json['sleepTime']),
      wakeTime: serializer.fromJson<DateTime>(json['wakeTime']),
      duration: serializer.fromJson<int>(json['duration']),
      quality: serializer.fromJson<int>(json['quality']),
      sleepScore: serializer.fromJson<int>(json['sleepScore']),
      heartRate: serializer.fromJson<int>(json['heartRate']),
      tags: serializer.fromJson<String?>(json['tags']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sleepTime': serializer.toJson<DateTime>(sleepTime),
      'wakeTime': serializer.toJson<DateTime>(wakeTime),
      'duration': serializer.toJson<int>(duration),
      'quality': serializer.toJson<int>(quality),
      'sleepScore': serializer.toJson<int>(sleepScore),
      'heartRate': serializer.toJson<int>(heartRate),
      'tags': serializer.toJson<String?>(tags),
      'note': serializer.toJson<String?>(note),
    };
  }

  SleepRecord copyWith({
    int? id,
    DateTime? sleepTime,
    DateTime? wakeTime,
    int? duration,
    int? quality,
    int? sleepScore,
    int? heartRate,
    Value<String?> tags = const Value.absent(),
    Value<String?> note = const Value.absent(),
  }) => SleepRecord(
    id: id ?? this.id,
    sleepTime: sleepTime ?? this.sleepTime,
    wakeTime: wakeTime ?? this.wakeTime,
    duration: duration ?? this.duration,
    quality: quality ?? this.quality,
    sleepScore: sleepScore ?? this.sleepScore,
    heartRate: heartRate ?? this.heartRate,
    tags: tags.present ? tags.value : this.tags,
    note: note.present ? note.value : this.note,
  );
  SleepRecord copyWithCompanion(SleepRecordsCompanion data) {
    return SleepRecord(
      id: data.id.present ? data.id.value : this.id,
      sleepTime: data.sleepTime.present ? data.sleepTime.value : this.sleepTime,
      wakeTime: data.wakeTime.present ? data.wakeTime.value : this.wakeTime,
      duration: data.duration.present ? data.duration.value : this.duration,
      quality: data.quality.present ? data.quality.value : this.quality,
      sleepScore: data.sleepScore.present
          ? data.sleepScore.value
          : this.sleepScore,
      heartRate: data.heartRate.present ? data.heartRate.value : this.heartRate,
      tags: data.tags.present ? data.tags.value : this.tags,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SleepRecord(')
          ..write('id: $id, ')
          ..write('sleepTime: $sleepTime, ')
          ..write('wakeTime: $wakeTime, ')
          ..write('duration: $duration, ')
          ..write('quality: $quality, ')
          ..write('sleepScore: $sleepScore, ')
          ..write('heartRate: $heartRate, ')
          ..write('tags: $tags, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sleepTime,
    wakeTime,
    duration,
    quality,
    sleepScore,
    heartRate,
    tags,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SleepRecord &&
          other.id == this.id &&
          other.sleepTime == this.sleepTime &&
          other.wakeTime == this.wakeTime &&
          other.duration == this.duration &&
          other.quality == this.quality &&
          other.sleepScore == this.sleepScore &&
          other.heartRate == this.heartRate &&
          other.tags == this.tags &&
          other.note == this.note);
}

class SleepRecordsCompanion extends UpdateCompanion<SleepRecord> {
  final Value<int> id;
  final Value<DateTime> sleepTime;
  final Value<DateTime> wakeTime;
  final Value<int> duration;
  final Value<int> quality;
  final Value<int> sleepScore;
  final Value<int> heartRate;
  final Value<String?> tags;
  final Value<String?> note;
  const SleepRecordsCompanion({
    this.id = const Value.absent(),
    this.sleepTime = const Value.absent(),
    this.wakeTime = const Value.absent(),
    this.duration = const Value.absent(),
    this.quality = const Value.absent(),
    this.sleepScore = const Value.absent(),
    this.heartRate = const Value.absent(),
    this.tags = const Value.absent(),
    this.note = const Value.absent(),
  });
  SleepRecordsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime sleepTime,
    required DateTime wakeTime,
    this.duration = const Value.absent(),
    this.quality = const Value.absent(),
    this.sleepScore = const Value.absent(),
    this.heartRate = const Value.absent(),
    this.tags = const Value.absent(),
    this.note = const Value.absent(),
  }) : sleepTime = Value(sleepTime),
       wakeTime = Value(wakeTime);
  static Insertable<SleepRecord> custom({
    Expression<int>? id,
    Expression<DateTime>? sleepTime,
    Expression<DateTime>? wakeTime,
    Expression<int>? duration,
    Expression<int>? quality,
    Expression<int>? sleepScore,
    Expression<int>? heartRate,
    Expression<String>? tags,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sleepTime != null) 'sleep_time': sleepTime,
      if (wakeTime != null) 'wake_time': wakeTime,
      if (duration != null) 'duration': duration,
      if (quality != null) 'quality': quality,
      if (sleepScore != null) 'sleep_score': sleepScore,
      if (heartRate != null) 'heart_rate': heartRate,
      if (tags != null) 'tags': tags,
      if (note != null) 'note': note,
    });
  }

  SleepRecordsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? sleepTime,
    Value<DateTime>? wakeTime,
    Value<int>? duration,
    Value<int>? quality,
    Value<int>? sleepScore,
    Value<int>? heartRate,
    Value<String?>? tags,
    Value<String?>? note,
  }) {
    return SleepRecordsCompanion(
      id: id ?? this.id,
      sleepTime: sleepTime ?? this.sleepTime,
      wakeTime: wakeTime ?? this.wakeTime,
      duration: duration ?? this.duration,
      quality: quality ?? this.quality,
      sleepScore: sleepScore ?? this.sleepScore,
      heartRate: heartRate ?? this.heartRate,
      tags: tags ?? this.tags,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sleepTime.present) {
      map['sleep_time'] = Variable<DateTime>(sleepTime.value);
    }
    if (wakeTime.present) {
      map['wake_time'] = Variable<DateTime>(wakeTime.value);
    }
    if (duration.present) {
      map['duration'] = Variable<int>(duration.value);
    }
    if (quality.present) {
      map['quality'] = Variable<int>(quality.value);
    }
    if (sleepScore.present) {
      map['sleep_score'] = Variable<int>(sleepScore.value);
    }
    if (heartRate.present) {
      map['heart_rate'] = Variable<int>(heartRate.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SleepRecordsCompanion(')
          ..write('id: $id, ')
          ..write('sleepTime: $sleepTime, ')
          ..write('wakeTime: $wakeTime, ')
          ..write('duration: $duration, ')
          ..write('quality: $quality, ')
          ..write('sleepScore: $sleepScore, ')
          ..write('heartRate: $heartRate, ')
          ..write('tags: $tags, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $SocialFeedsTable extends SocialFeeds
    with TableInfo<$SocialFeedsTable, SocialFeed> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SocialFeedsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userNameMeta = const VerificationMeta(
    'userName',
  );
  @override
  late final GeneratedColumn<String> userName = GeneratedColumn<String>(
    'user_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _avatarResMeta = const VerificationMeta(
    'avatarRes',
  );
  @override
  late final GeneratedColumn<String> avatarRes = GeneratedColumn<String>(
    'avatar_res',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stepsMeta = const VerificationMeta('steps');
  @override
  late final GeneratedColumn<int> steps = GeneratedColumn<int>(
    'steps',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _caloriesMeta = const VerificationMeta(
    'calories',
  );
  @override
  late final GeneratedColumn<int> calories = GeneratedColumn<int>(
    'calories',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<DateTime> time = GeneratedColumn<DateTime>(
    'time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<int> type = GeneratedColumn<int>(
    'type',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _likeCountMeta = const VerificationMeta(
    'likeCount',
  );
  @override
  late final GeneratedColumn<int> likeCount = GeneratedColumn<int>(
    'like_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isMockMeta = const VerificationMeta('isMock');
  @override
  late final GeneratedColumn<bool> isMock = GeneratedColumn<bool>(
    'is_mock',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_mock" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userName,
    avatarRes,
    content,
    imagePath,
    steps,
    calories,
    time,
    type,
    likeCount,
    isMock,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'social_feeds';
  @override
  VerificationContext validateIntegrity(
    Insertable<SocialFeed> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_name')) {
      context.handle(
        _userNameMeta,
        userName.isAcceptableOrUnknown(data['user_name']!, _userNameMeta),
      );
    }
    if (data.containsKey('avatar_res')) {
      context.handle(
        _avatarResMeta,
        avatarRes.isAcceptableOrUnknown(data['avatar_res']!, _avatarResMeta),
      );
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    if (data.containsKey('steps')) {
      context.handle(
        _stepsMeta,
        steps.isAcceptableOrUnknown(data['steps']!, _stepsMeta),
      );
    }
    if (data.containsKey('calories')) {
      context.handle(
        _caloriesMeta,
        calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta),
      );
    }
    if (data.containsKey('time')) {
      context.handle(
        _timeMeta,
        time.isAcceptableOrUnknown(data['time']!, _timeMeta),
      );
    } else if (isInserting) {
      context.missing(_timeMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('like_count')) {
      context.handle(
        _likeCountMeta,
        likeCount.isAcceptableOrUnknown(data['like_count']!, _likeCountMeta),
      );
    }
    if (data.containsKey('is_mock')) {
      context.handle(
        _isMockMeta,
        isMock.isAcceptableOrUnknown(data['is_mock']!, _isMockMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SocialFeed map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SocialFeed(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_name'],
      ),
      avatarRes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_res'],
      ),
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      ),
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
      steps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}steps'],
      ),
      calories: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}calories'],
      ),
      time: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}time'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}type'],
      ),
      likeCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}like_count'],
      )!,
      isMock: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_mock'],
      )!,
    );
  }

  @override
  $SocialFeedsTable createAlias(String alias) {
    return $SocialFeedsTable(attachedDatabase, alias);
  }
}

class SocialFeed extends DataClass implements Insertable<SocialFeed> {
  final int id;
  final String? userName;
  final String? avatarRes;
  final String? content;
  final String? imagePath;
  final int? steps;
  final int? calories;
  final DateTime time;
  final int? type;
  final int likeCount;
  final bool isMock;
  const SocialFeed({
    required this.id,
    this.userName,
    this.avatarRes,
    this.content,
    this.imagePath,
    this.steps,
    this.calories,
    required this.time,
    this.type,
    required this.likeCount,
    required this.isMock,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || userName != null) {
      map['user_name'] = Variable<String>(userName);
    }
    if (!nullToAbsent || avatarRes != null) {
      map['avatar_res'] = Variable<String>(avatarRes);
    }
    if (!nullToAbsent || content != null) {
      map['content'] = Variable<String>(content);
    }
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    if (!nullToAbsent || steps != null) {
      map['steps'] = Variable<int>(steps);
    }
    if (!nullToAbsent || calories != null) {
      map['calories'] = Variable<int>(calories);
    }
    map['time'] = Variable<DateTime>(time);
    if (!nullToAbsent || type != null) {
      map['type'] = Variable<int>(type);
    }
    map['like_count'] = Variable<int>(likeCount);
    map['is_mock'] = Variable<bool>(isMock);
    return map;
  }

  SocialFeedsCompanion toCompanion(bool nullToAbsent) {
    return SocialFeedsCompanion(
      id: Value(id),
      userName: userName == null && nullToAbsent
          ? const Value.absent()
          : Value(userName),
      avatarRes: avatarRes == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarRes),
      content: content == null && nullToAbsent
          ? const Value.absent()
          : Value(content),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      steps: steps == null && nullToAbsent
          ? const Value.absent()
          : Value(steps),
      calories: calories == null && nullToAbsent
          ? const Value.absent()
          : Value(calories),
      time: Value(time),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      likeCount: Value(likeCount),
      isMock: Value(isMock),
    );
  }

  factory SocialFeed.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SocialFeed(
      id: serializer.fromJson<int>(json['id']),
      userName: serializer.fromJson<String?>(json['userName']),
      avatarRes: serializer.fromJson<String?>(json['avatarRes']),
      content: serializer.fromJson<String?>(json['content']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      steps: serializer.fromJson<int?>(json['steps']),
      calories: serializer.fromJson<int?>(json['calories']),
      time: serializer.fromJson<DateTime>(json['time']),
      type: serializer.fromJson<int?>(json['type']),
      likeCount: serializer.fromJson<int>(json['likeCount']),
      isMock: serializer.fromJson<bool>(json['isMock']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userName': serializer.toJson<String?>(userName),
      'avatarRes': serializer.toJson<String?>(avatarRes),
      'content': serializer.toJson<String?>(content),
      'imagePath': serializer.toJson<String?>(imagePath),
      'steps': serializer.toJson<int?>(steps),
      'calories': serializer.toJson<int?>(calories),
      'time': serializer.toJson<DateTime>(time),
      'type': serializer.toJson<int?>(type),
      'likeCount': serializer.toJson<int>(likeCount),
      'isMock': serializer.toJson<bool>(isMock),
    };
  }

  SocialFeed copyWith({
    int? id,
    Value<String?> userName = const Value.absent(),
    Value<String?> avatarRes = const Value.absent(),
    Value<String?> content = const Value.absent(),
    Value<String?> imagePath = const Value.absent(),
    Value<int?> steps = const Value.absent(),
    Value<int?> calories = const Value.absent(),
    DateTime? time,
    Value<int?> type = const Value.absent(),
    int? likeCount,
    bool? isMock,
  }) => SocialFeed(
    id: id ?? this.id,
    userName: userName.present ? userName.value : this.userName,
    avatarRes: avatarRes.present ? avatarRes.value : this.avatarRes,
    content: content.present ? content.value : this.content,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
    steps: steps.present ? steps.value : this.steps,
    calories: calories.present ? calories.value : this.calories,
    time: time ?? this.time,
    type: type.present ? type.value : this.type,
    likeCount: likeCount ?? this.likeCount,
    isMock: isMock ?? this.isMock,
  );
  SocialFeed copyWithCompanion(SocialFeedsCompanion data) {
    return SocialFeed(
      id: data.id.present ? data.id.value : this.id,
      userName: data.userName.present ? data.userName.value : this.userName,
      avatarRes: data.avatarRes.present ? data.avatarRes.value : this.avatarRes,
      content: data.content.present ? data.content.value : this.content,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      steps: data.steps.present ? data.steps.value : this.steps,
      calories: data.calories.present ? data.calories.value : this.calories,
      time: data.time.present ? data.time.value : this.time,
      type: data.type.present ? data.type.value : this.type,
      likeCount: data.likeCount.present ? data.likeCount.value : this.likeCount,
      isMock: data.isMock.present ? data.isMock.value : this.isMock,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SocialFeed(')
          ..write('id: $id, ')
          ..write('userName: $userName, ')
          ..write('avatarRes: $avatarRes, ')
          ..write('content: $content, ')
          ..write('imagePath: $imagePath, ')
          ..write('steps: $steps, ')
          ..write('calories: $calories, ')
          ..write('time: $time, ')
          ..write('type: $type, ')
          ..write('likeCount: $likeCount, ')
          ..write('isMock: $isMock')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userName,
    avatarRes,
    content,
    imagePath,
    steps,
    calories,
    time,
    type,
    likeCount,
    isMock,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SocialFeed &&
          other.id == this.id &&
          other.userName == this.userName &&
          other.avatarRes == this.avatarRes &&
          other.content == this.content &&
          other.imagePath == this.imagePath &&
          other.steps == this.steps &&
          other.calories == this.calories &&
          other.time == this.time &&
          other.type == this.type &&
          other.likeCount == this.likeCount &&
          other.isMock == this.isMock);
}

class SocialFeedsCompanion extends UpdateCompanion<SocialFeed> {
  final Value<int> id;
  final Value<String?> userName;
  final Value<String?> avatarRes;
  final Value<String?> content;
  final Value<String?> imagePath;
  final Value<int?> steps;
  final Value<int?> calories;
  final Value<DateTime> time;
  final Value<int?> type;
  final Value<int> likeCount;
  final Value<bool> isMock;
  const SocialFeedsCompanion({
    this.id = const Value.absent(),
    this.userName = const Value.absent(),
    this.avatarRes = const Value.absent(),
    this.content = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.steps = const Value.absent(),
    this.calories = const Value.absent(),
    this.time = const Value.absent(),
    this.type = const Value.absent(),
    this.likeCount = const Value.absent(),
    this.isMock = const Value.absent(),
  });
  SocialFeedsCompanion.insert({
    this.id = const Value.absent(),
    this.userName = const Value.absent(),
    this.avatarRes = const Value.absent(),
    this.content = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.steps = const Value.absent(),
    this.calories = const Value.absent(),
    required DateTime time,
    this.type = const Value.absent(),
    this.likeCount = const Value.absent(),
    this.isMock = const Value.absent(),
  }) : time = Value(time);
  static Insertable<SocialFeed> custom({
    Expression<int>? id,
    Expression<String>? userName,
    Expression<String>? avatarRes,
    Expression<String>? content,
    Expression<String>? imagePath,
    Expression<int>? steps,
    Expression<int>? calories,
    Expression<DateTime>? time,
    Expression<int>? type,
    Expression<int>? likeCount,
    Expression<bool>? isMock,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userName != null) 'user_name': userName,
      if (avatarRes != null) 'avatar_res': avatarRes,
      if (content != null) 'content': content,
      if (imagePath != null) 'image_path': imagePath,
      if (steps != null) 'steps': steps,
      if (calories != null) 'calories': calories,
      if (time != null) 'time': time,
      if (type != null) 'type': type,
      if (likeCount != null) 'like_count': likeCount,
      if (isMock != null) 'is_mock': isMock,
    });
  }

  SocialFeedsCompanion copyWith({
    Value<int>? id,
    Value<String?>? userName,
    Value<String?>? avatarRes,
    Value<String?>? content,
    Value<String?>? imagePath,
    Value<int?>? steps,
    Value<int?>? calories,
    Value<DateTime>? time,
    Value<int?>? type,
    Value<int>? likeCount,
    Value<bool>? isMock,
  }) {
    return SocialFeedsCompanion(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      avatarRes: avatarRes ?? this.avatarRes,
      content: content ?? this.content,
      imagePath: imagePath ?? this.imagePath,
      steps: steps ?? this.steps,
      calories: calories ?? this.calories,
      time: time ?? this.time,
      type: type ?? this.type,
      likeCount: likeCount ?? this.likeCount,
      isMock: isMock ?? this.isMock,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userName.present) {
      map['user_name'] = Variable<String>(userName.value);
    }
    if (avatarRes.present) {
      map['avatar_res'] = Variable<String>(avatarRes.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (steps.present) {
      map['steps'] = Variable<int>(steps.value);
    }
    if (calories.present) {
      map['calories'] = Variable<int>(calories.value);
    }
    if (time.present) {
      map['time'] = Variable<DateTime>(time.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    if (likeCount.present) {
      map['like_count'] = Variable<int>(likeCount.value);
    }
    if (isMock.present) {
      map['is_mock'] = Variable<bool>(isMock.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SocialFeedsCompanion(')
          ..write('id: $id, ')
          ..write('userName: $userName, ')
          ..write('avatarRes: $avatarRes, ')
          ..write('content: $content, ')
          ..write('imagePath: $imagePath, ')
          ..write('steps: $steps, ')
          ..write('calories: $calories, ')
          ..write('time: $time, ')
          ..write('type: $type, ')
          ..write('likeCount: $likeCount, ')
          ..write('isMock: $isMock')
          ..write(')'))
        .toString();
  }
}

class $ProfessionalWeightRecordsTable extends ProfessionalWeightRecords
    with TableInfo<$ProfessionalWeightRecordsTable, ProfessionalWeightRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfessionalWeightRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordDatetimeMeta = const VerificationMeta(
    'recordDatetime',
  );
  @override
  late final GeneratedColumn<DateTime> recordDatetime =
      GeneratedColumn<DateTime>(
        'record_datetime',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
    'weight',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyFatPercentageMeta = const VerificationMeta(
    'bodyFatPercentage',
  );
  @override
  late final GeneratedColumn<double> bodyFatPercentage =
      GeneratedColumn<double>(
        'body_fat_percentage',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _muscleMassMeta = const VerificationMeta(
    'muscleMass',
  );
  @override
  late final GeneratedColumn<double> muscleMass = GeneratedColumn<double>(
    'muscle_mass',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _boneMassMeta = const VerificationMeta(
    'boneMass',
  );
  @override
  late final GeneratedColumn<double> boneMass = GeneratedColumn<double>(
    'bone_mass',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bodyWaterMeta = const VerificationMeta(
    'bodyWater',
  );
  @override
  late final GeneratedColumn<double> bodyWater = GeneratedColumn<double>(
    'body_water',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _visceralFatLevelMeta = const VerificationMeta(
    'visceralFatLevel',
  );
  @override
  late final GeneratedColumn<int> visceralFatLevel = GeneratedColumn<int>(
    'visceral_fat_level',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _basalMetabolismMeta = const VerificationMeta(
    'basalMetabolism',
  );
  @override
  late final GeneratedColumn<int> basalMetabolism = GeneratedColumn<int>(
    'basal_metabolism',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _proteinRateMeta = const VerificationMeta(
    'proteinRate',
  );
  @override
  late final GeneratedColumn<double> proteinRate = GeneratedColumn<double>(
    'protein_rate',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _subcutaneousFatMeta = const VerificationMeta(
    'subcutaneousFat',
  );
  @override
  late final GeneratedColumn<double> subcutaneousFat = GeneratedColumn<double>(
    'subcutaneous_fat',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _measurementTimeTypeMeta =
      const VerificationMeta('measurementTimeType');
  @override
  late final GeneratedColumn<String> measurementTimeType =
      GeneratedColumn<String>(
        'measurement_time_type',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _measurementDeviceMeta = const VerificationMeta(
    'measurementDevice',
  );
  @override
  late final GeneratedColumn<String> measurementDevice =
      GeneratedColumn<String>(
        'measurement_device',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _roomTemperatureMeta = const VerificationMeta(
    'roomTemperature',
  );
  @override
  late final GeneratedColumn<double> roomTemperature = GeneratedColumn<double>(
    'room_temperature',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _humidityMeta = const VerificationMeta(
    'humidity',
  );
  @override
  late final GeneratedColumn<double> humidity = GeneratedColumn<double>(
    'humidity',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _menstrualCycleDayMeta = const VerificationMeta(
    'menstrualCycleDay',
  );
  @override
  late final GeneratedColumn<int> menstrualCycleDay = GeneratedColumn<int>(
    'menstrual_cycle_day',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sleepQualityMeta = const VerificationMeta(
    'sleepQuality',
  );
  @override
  late final GeneratedColumn<int> sleepQuality = GeneratedColumn<int>(
    'sleep_quality',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stressLevelMeta = const VerificationMeta(
    'stressLevel',
  );
  @override
  late final GeneratedColumn<int> stressLevel = GeneratedColumn<int>(
    'stress_level',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hydrationStatusMeta = const VerificationMeta(
    'hydrationStatus',
  );
  @override
  late final GeneratedColumn<String> hydrationStatus = GeneratedColumn<String>(
    'hydration_status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoUrlMeta = const VerificationMeta(
    'photoUrl',
  );
  @override
  late final GeneratedColumn<String> photoUrl = GeneratedColumn<String>(
    'photo_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _moodScoreMeta = const VerificationMeta(
    'moodScore',
  );
  @override
  late final GeneratedColumn<int> moodScore = GeneratedColumn<int>(
    'mood_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    recordDatetime,
    weight,
    bodyFatPercentage,
    muscleMass,
    boneMass,
    bodyWater,
    visceralFatLevel,
    basalMetabolism,
    proteinRate,
    subcutaneousFat,
    measurementTimeType,
    measurementDevice,
    roomTemperature,
    humidity,
    menstrualCycleDay,
    sleepQuality,
    stressLevel,
    hydrationStatus,
    notes,
    tags,
    photoUrl,
    moodScore,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'professional_weight_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProfessionalWeightRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('record_datetime')) {
      context.handle(
        _recordDatetimeMeta,
        recordDatetime.isAcceptableOrUnknown(
          data['record_datetime']!,
          _recordDatetimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recordDatetimeMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(
        _weightMeta,
        weight.isAcceptableOrUnknown(data['weight']!, _weightMeta),
      );
    } else if (isInserting) {
      context.missing(_weightMeta);
    }
    if (data.containsKey('body_fat_percentage')) {
      context.handle(
        _bodyFatPercentageMeta,
        bodyFatPercentage.isAcceptableOrUnknown(
          data['body_fat_percentage']!,
          _bodyFatPercentageMeta,
        ),
      );
    }
    if (data.containsKey('muscle_mass')) {
      context.handle(
        _muscleMassMeta,
        muscleMass.isAcceptableOrUnknown(data['muscle_mass']!, _muscleMassMeta),
      );
    }
    if (data.containsKey('bone_mass')) {
      context.handle(
        _boneMassMeta,
        boneMass.isAcceptableOrUnknown(data['bone_mass']!, _boneMassMeta),
      );
    }
    if (data.containsKey('body_water')) {
      context.handle(
        _bodyWaterMeta,
        bodyWater.isAcceptableOrUnknown(data['body_water']!, _bodyWaterMeta),
      );
    }
    if (data.containsKey('visceral_fat_level')) {
      context.handle(
        _visceralFatLevelMeta,
        visceralFatLevel.isAcceptableOrUnknown(
          data['visceral_fat_level']!,
          _visceralFatLevelMeta,
        ),
      );
    }
    if (data.containsKey('basal_metabolism')) {
      context.handle(
        _basalMetabolismMeta,
        basalMetabolism.isAcceptableOrUnknown(
          data['basal_metabolism']!,
          _basalMetabolismMeta,
        ),
      );
    }
    if (data.containsKey('protein_rate')) {
      context.handle(
        _proteinRateMeta,
        proteinRate.isAcceptableOrUnknown(
          data['protein_rate']!,
          _proteinRateMeta,
        ),
      );
    }
    if (data.containsKey('subcutaneous_fat')) {
      context.handle(
        _subcutaneousFatMeta,
        subcutaneousFat.isAcceptableOrUnknown(
          data['subcutaneous_fat']!,
          _subcutaneousFatMeta,
        ),
      );
    }
    if (data.containsKey('measurement_time_type')) {
      context.handle(
        _measurementTimeTypeMeta,
        measurementTimeType.isAcceptableOrUnknown(
          data['measurement_time_type']!,
          _measurementTimeTypeMeta,
        ),
      );
    }
    if (data.containsKey('measurement_device')) {
      context.handle(
        _measurementDeviceMeta,
        measurementDevice.isAcceptableOrUnknown(
          data['measurement_device']!,
          _measurementDeviceMeta,
        ),
      );
    }
    if (data.containsKey('room_temperature')) {
      context.handle(
        _roomTemperatureMeta,
        roomTemperature.isAcceptableOrUnknown(
          data['room_temperature']!,
          _roomTemperatureMeta,
        ),
      );
    }
    if (data.containsKey('humidity')) {
      context.handle(
        _humidityMeta,
        humidity.isAcceptableOrUnknown(data['humidity']!, _humidityMeta),
      );
    }
    if (data.containsKey('menstrual_cycle_day')) {
      context.handle(
        _menstrualCycleDayMeta,
        menstrualCycleDay.isAcceptableOrUnknown(
          data['menstrual_cycle_day']!,
          _menstrualCycleDayMeta,
        ),
      );
    }
    if (data.containsKey('sleep_quality')) {
      context.handle(
        _sleepQualityMeta,
        sleepQuality.isAcceptableOrUnknown(
          data['sleep_quality']!,
          _sleepQualityMeta,
        ),
      );
    }
    if (data.containsKey('stress_level')) {
      context.handle(
        _stressLevelMeta,
        stressLevel.isAcceptableOrUnknown(
          data['stress_level']!,
          _stressLevelMeta,
        ),
      );
    }
    if (data.containsKey('hydration_status')) {
      context.handle(
        _hydrationStatusMeta,
        hydrationStatus.isAcceptableOrUnknown(
          data['hydration_status']!,
          _hydrationStatusMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('photo_url')) {
      context.handle(
        _photoUrlMeta,
        photoUrl.isAcceptableOrUnknown(data['photo_url']!, _photoUrlMeta),
      );
    }
    if (data.containsKey('mood_score')) {
      context.handle(
        _moodScoreMeta,
        moodScore.isAcceptableOrUnknown(data['mood_score']!, _moodScoreMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProfessionalWeightRecord map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProfessionalWeightRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      recordDatetime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}record_datetime'],
      )!,
      weight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight'],
      )!,
      bodyFatPercentage: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}body_fat_percentage'],
      ),
      muscleMass: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}muscle_mass'],
      ),
      boneMass: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}bone_mass'],
      ),
      bodyWater: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}body_water'],
      ),
      visceralFatLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}visceral_fat_level'],
      ),
      basalMetabolism: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}basal_metabolism'],
      ),
      proteinRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein_rate'],
      ),
      subcutaneousFat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}subcutaneous_fat'],
      ),
      measurementTimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}measurement_time_type'],
      ),
      measurementDevice: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}measurement_device'],
      ),
      roomTemperature: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}room_temperature'],
      ),
      humidity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}humidity'],
      ),
      menstrualCycleDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}menstrual_cycle_day'],
      ),
      sleepQuality: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sleep_quality'],
      ),
      stressLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stress_level'],
      ),
      hydrationStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hydration_status'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      ),
      photoUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_url'],
      ),
      moodScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mood_score'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ProfessionalWeightRecordsTable createAlias(String alias) {
    return $ProfessionalWeightRecordsTable(attachedDatabase, alias);
  }
}

class ProfessionalWeightRecord extends DataClass
    implements Insertable<ProfessionalWeightRecord> {
  final int id;
  final String userId;
  final DateTime recordDatetime;
  final double weight;
  final double? bodyFatPercentage;
  final double? muscleMass;
  final double? boneMass;
  final double? bodyWater;
  final int? visceralFatLevel;
  final int? basalMetabolism;
  final double? proteinRate;
  final double? subcutaneousFat;
  final String? measurementTimeType;
  final String? measurementDevice;
  final double? roomTemperature;
  final double? humidity;
  final int? menstrualCycleDay;
  final int? sleepQuality;
  final int? stressLevel;
  final String? hydrationStatus;
  final String? notes;
  final String? tags;
  final String? photoUrl;
  final int? moodScore;
  final DateTime createdAt;
  const ProfessionalWeightRecord({
    required this.id,
    required this.userId,
    required this.recordDatetime,
    required this.weight,
    this.bodyFatPercentage,
    this.muscleMass,
    this.boneMass,
    this.bodyWater,
    this.visceralFatLevel,
    this.basalMetabolism,
    this.proteinRate,
    this.subcutaneousFat,
    this.measurementTimeType,
    this.measurementDevice,
    this.roomTemperature,
    this.humidity,
    this.menstrualCycleDay,
    this.sleepQuality,
    this.stressLevel,
    this.hydrationStatus,
    this.notes,
    this.tags,
    this.photoUrl,
    this.moodScore,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<String>(userId);
    map['record_datetime'] = Variable<DateTime>(recordDatetime);
    map['weight'] = Variable<double>(weight);
    if (!nullToAbsent || bodyFatPercentage != null) {
      map['body_fat_percentage'] = Variable<double>(bodyFatPercentage);
    }
    if (!nullToAbsent || muscleMass != null) {
      map['muscle_mass'] = Variable<double>(muscleMass);
    }
    if (!nullToAbsent || boneMass != null) {
      map['bone_mass'] = Variable<double>(boneMass);
    }
    if (!nullToAbsent || bodyWater != null) {
      map['body_water'] = Variable<double>(bodyWater);
    }
    if (!nullToAbsent || visceralFatLevel != null) {
      map['visceral_fat_level'] = Variable<int>(visceralFatLevel);
    }
    if (!nullToAbsent || basalMetabolism != null) {
      map['basal_metabolism'] = Variable<int>(basalMetabolism);
    }
    if (!nullToAbsent || proteinRate != null) {
      map['protein_rate'] = Variable<double>(proteinRate);
    }
    if (!nullToAbsent || subcutaneousFat != null) {
      map['subcutaneous_fat'] = Variable<double>(subcutaneousFat);
    }
    if (!nullToAbsent || measurementTimeType != null) {
      map['measurement_time_type'] = Variable<String>(measurementTimeType);
    }
    if (!nullToAbsent || measurementDevice != null) {
      map['measurement_device'] = Variable<String>(measurementDevice);
    }
    if (!nullToAbsent || roomTemperature != null) {
      map['room_temperature'] = Variable<double>(roomTemperature);
    }
    if (!nullToAbsent || humidity != null) {
      map['humidity'] = Variable<double>(humidity);
    }
    if (!nullToAbsent || menstrualCycleDay != null) {
      map['menstrual_cycle_day'] = Variable<int>(menstrualCycleDay);
    }
    if (!nullToAbsent || sleepQuality != null) {
      map['sleep_quality'] = Variable<int>(sleepQuality);
    }
    if (!nullToAbsent || stressLevel != null) {
      map['stress_level'] = Variable<int>(stressLevel);
    }
    if (!nullToAbsent || hydrationStatus != null) {
      map['hydration_status'] = Variable<String>(hydrationStatus);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || tags != null) {
      map['tags'] = Variable<String>(tags);
    }
    if (!nullToAbsent || photoUrl != null) {
      map['photo_url'] = Variable<String>(photoUrl);
    }
    if (!nullToAbsent || moodScore != null) {
      map['mood_score'] = Variable<int>(moodScore);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ProfessionalWeightRecordsCompanion toCompanion(bool nullToAbsent) {
    return ProfessionalWeightRecordsCompanion(
      id: Value(id),
      userId: Value(userId),
      recordDatetime: Value(recordDatetime),
      weight: Value(weight),
      bodyFatPercentage: bodyFatPercentage == null && nullToAbsent
          ? const Value.absent()
          : Value(bodyFatPercentage),
      muscleMass: muscleMass == null && nullToAbsent
          ? const Value.absent()
          : Value(muscleMass),
      boneMass: boneMass == null && nullToAbsent
          ? const Value.absent()
          : Value(boneMass),
      bodyWater: bodyWater == null && nullToAbsent
          ? const Value.absent()
          : Value(bodyWater),
      visceralFatLevel: visceralFatLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(visceralFatLevel),
      basalMetabolism: basalMetabolism == null && nullToAbsent
          ? const Value.absent()
          : Value(basalMetabolism),
      proteinRate: proteinRate == null && nullToAbsent
          ? const Value.absent()
          : Value(proteinRate),
      subcutaneousFat: subcutaneousFat == null && nullToAbsent
          ? const Value.absent()
          : Value(subcutaneousFat),
      measurementTimeType: measurementTimeType == null && nullToAbsent
          ? const Value.absent()
          : Value(measurementTimeType),
      measurementDevice: measurementDevice == null && nullToAbsent
          ? const Value.absent()
          : Value(measurementDevice),
      roomTemperature: roomTemperature == null && nullToAbsent
          ? const Value.absent()
          : Value(roomTemperature),
      humidity: humidity == null && nullToAbsent
          ? const Value.absent()
          : Value(humidity),
      menstrualCycleDay: menstrualCycleDay == null && nullToAbsent
          ? const Value.absent()
          : Value(menstrualCycleDay),
      sleepQuality: sleepQuality == null && nullToAbsent
          ? const Value.absent()
          : Value(sleepQuality),
      stressLevel: stressLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(stressLevel),
      hydrationStatus: hydrationStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(hydrationStatus),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      tags: tags == null && nullToAbsent ? const Value.absent() : Value(tags),
      photoUrl: photoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(photoUrl),
      moodScore: moodScore == null && nullToAbsent
          ? const Value.absent()
          : Value(moodScore),
      createdAt: Value(createdAt),
    );
  }

  factory ProfessionalWeightRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProfessionalWeightRecord(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      recordDatetime: serializer.fromJson<DateTime>(json['recordDatetime']),
      weight: serializer.fromJson<double>(json['weight']),
      bodyFatPercentage: serializer.fromJson<double?>(
        json['bodyFatPercentage'],
      ),
      muscleMass: serializer.fromJson<double?>(json['muscleMass']),
      boneMass: serializer.fromJson<double?>(json['boneMass']),
      bodyWater: serializer.fromJson<double?>(json['bodyWater']),
      visceralFatLevel: serializer.fromJson<int?>(json['visceralFatLevel']),
      basalMetabolism: serializer.fromJson<int?>(json['basalMetabolism']),
      proteinRate: serializer.fromJson<double?>(json['proteinRate']),
      subcutaneousFat: serializer.fromJson<double?>(json['subcutaneousFat']),
      measurementTimeType: serializer.fromJson<String?>(
        json['measurementTimeType'],
      ),
      measurementDevice: serializer.fromJson<String?>(
        json['measurementDevice'],
      ),
      roomTemperature: serializer.fromJson<double?>(json['roomTemperature']),
      humidity: serializer.fromJson<double?>(json['humidity']),
      menstrualCycleDay: serializer.fromJson<int?>(json['menstrualCycleDay']),
      sleepQuality: serializer.fromJson<int?>(json['sleepQuality']),
      stressLevel: serializer.fromJson<int?>(json['stressLevel']),
      hydrationStatus: serializer.fromJson<String?>(json['hydrationStatus']),
      notes: serializer.fromJson<String?>(json['notes']),
      tags: serializer.fromJson<String?>(json['tags']),
      photoUrl: serializer.fromJson<String?>(json['photoUrl']),
      moodScore: serializer.fromJson<int?>(json['moodScore']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<String>(userId),
      'recordDatetime': serializer.toJson<DateTime>(recordDatetime),
      'weight': serializer.toJson<double>(weight),
      'bodyFatPercentage': serializer.toJson<double?>(bodyFatPercentage),
      'muscleMass': serializer.toJson<double?>(muscleMass),
      'boneMass': serializer.toJson<double?>(boneMass),
      'bodyWater': serializer.toJson<double?>(bodyWater),
      'visceralFatLevel': serializer.toJson<int?>(visceralFatLevel),
      'basalMetabolism': serializer.toJson<int?>(basalMetabolism),
      'proteinRate': serializer.toJson<double?>(proteinRate),
      'subcutaneousFat': serializer.toJson<double?>(subcutaneousFat),
      'measurementTimeType': serializer.toJson<String?>(measurementTimeType),
      'measurementDevice': serializer.toJson<String?>(measurementDevice),
      'roomTemperature': serializer.toJson<double?>(roomTemperature),
      'humidity': serializer.toJson<double?>(humidity),
      'menstrualCycleDay': serializer.toJson<int?>(menstrualCycleDay),
      'sleepQuality': serializer.toJson<int?>(sleepQuality),
      'stressLevel': serializer.toJson<int?>(stressLevel),
      'hydrationStatus': serializer.toJson<String?>(hydrationStatus),
      'notes': serializer.toJson<String?>(notes),
      'tags': serializer.toJson<String?>(tags),
      'photoUrl': serializer.toJson<String?>(photoUrl),
      'moodScore': serializer.toJson<int?>(moodScore),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ProfessionalWeightRecord copyWith({
    int? id,
    String? userId,
    DateTime? recordDatetime,
    double? weight,
    Value<double?> bodyFatPercentage = const Value.absent(),
    Value<double?> muscleMass = const Value.absent(),
    Value<double?> boneMass = const Value.absent(),
    Value<double?> bodyWater = const Value.absent(),
    Value<int?> visceralFatLevel = const Value.absent(),
    Value<int?> basalMetabolism = const Value.absent(),
    Value<double?> proteinRate = const Value.absent(),
    Value<double?> subcutaneousFat = const Value.absent(),
    Value<String?> measurementTimeType = const Value.absent(),
    Value<String?> measurementDevice = const Value.absent(),
    Value<double?> roomTemperature = const Value.absent(),
    Value<double?> humidity = const Value.absent(),
    Value<int?> menstrualCycleDay = const Value.absent(),
    Value<int?> sleepQuality = const Value.absent(),
    Value<int?> stressLevel = const Value.absent(),
    Value<String?> hydrationStatus = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> tags = const Value.absent(),
    Value<String?> photoUrl = const Value.absent(),
    Value<int?> moodScore = const Value.absent(),
    DateTime? createdAt,
  }) => ProfessionalWeightRecord(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    recordDatetime: recordDatetime ?? this.recordDatetime,
    weight: weight ?? this.weight,
    bodyFatPercentage: bodyFatPercentage.present
        ? bodyFatPercentage.value
        : this.bodyFatPercentage,
    muscleMass: muscleMass.present ? muscleMass.value : this.muscleMass,
    boneMass: boneMass.present ? boneMass.value : this.boneMass,
    bodyWater: bodyWater.present ? bodyWater.value : this.bodyWater,
    visceralFatLevel: visceralFatLevel.present
        ? visceralFatLevel.value
        : this.visceralFatLevel,
    basalMetabolism: basalMetabolism.present
        ? basalMetabolism.value
        : this.basalMetabolism,
    proteinRate: proteinRate.present ? proteinRate.value : this.proteinRate,
    subcutaneousFat: subcutaneousFat.present
        ? subcutaneousFat.value
        : this.subcutaneousFat,
    measurementTimeType: measurementTimeType.present
        ? measurementTimeType.value
        : this.measurementTimeType,
    measurementDevice: measurementDevice.present
        ? measurementDevice.value
        : this.measurementDevice,
    roomTemperature: roomTemperature.present
        ? roomTemperature.value
        : this.roomTemperature,
    humidity: humidity.present ? humidity.value : this.humidity,
    menstrualCycleDay: menstrualCycleDay.present
        ? menstrualCycleDay.value
        : this.menstrualCycleDay,
    sleepQuality: sleepQuality.present ? sleepQuality.value : this.sleepQuality,
    stressLevel: stressLevel.present ? stressLevel.value : this.stressLevel,
    hydrationStatus: hydrationStatus.present
        ? hydrationStatus.value
        : this.hydrationStatus,
    notes: notes.present ? notes.value : this.notes,
    tags: tags.present ? tags.value : this.tags,
    photoUrl: photoUrl.present ? photoUrl.value : this.photoUrl,
    moodScore: moodScore.present ? moodScore.value : this.moodScore,
    createdAt: createdAt ?? this.createdAt,
  );
  ProfessionalWeightRecord copyWithCompanion(
    ProfessionalWeightRecordsCompanion data,
  ) {
    return ProfessionalWeightRecord(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      recordDatetime: data.recordDatetime.present
          ? data.recordDatetime.value
          : this.recordDatetime,
      weight: data.weight.present ? data.weight.value : this.weight,
      bodyFatPercentage: data.bodyFatPercentage.present
          ? data.bodyFatPercentage.value
          : this.bodyFatPercentage,
      muscleMass: data.muscleMass.present
          ? data.muscleMass.value
          : this.muscleMass,
      boneMass: data.boneMass.present ? data.boneMass.value : this.boneMass,
      bodyWater: data.bodyWater.present ? data.bodyWater.value : this.bodyWater,
      visceralFatLevel: data.visceralFatLevel.present
          ? data.visceralFatLevel.value
          : this.visceralFatLevel,
      basalMetabolism: data.basalMetabolism.present
          ? data.basalMetabolism.value
          : this.basalMetabolism,
      proteinRate: data.proteinRate.present
          ? data.proteinRate.value
          : this.proteinRate,
      subcutaneousFat: data.subcutaneousFat.present
          ? data.subcutaneousFat.value
          : this.subcutaneousFat,
      measurementTimeType: data.measurementTimeType.present
          ? data.measurementTimeType.value
          : this.measurementTimeType,
      measurementDevice: data.measurementDevice.present
          ? data.measurementDevice.value
          : this.measurementDevice,
      roomTemperature: data.roomTemperature.present
          ? data.roomTemperature.value
          : this.roomTemperature,
      humidity: data.humidity.present ? data.humidity.value : this.humidity,
      menstrualCycleDay: data.menstrualCycleDay.present
          ? data.menstrualCycleDay.value
          : this.menstrualCycleDay,
      sleepQuality: data.sleepQuality.present
          ? data.sleepQuality.value
          : this.sleepQuality,
      stressLevel: data.stressLevel.present
          ? data.stressLevel.value
          : this.stressLevel,
      hydrationStatus: data.hydrationStatus.present
          ? data.hydrationStatus.value
          : this.hydrationStatus,
      notes: data.notes.present ? data.notes.value : this.notes,
      tags: data.tags.present ? data.tags.value : this.tags,
      photoUrl: data.photoUrl.present ? data.photoUrl.value : this.photoUrl,
      moodScore: data.moodScore.present ? data.moodScore.value : this.moodScore,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProfessionalWeightRecord(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('recordDatetime: $recordDatetime, ')
          ..write('weight: $weight, ')
          ..write('bodyFatPercentage: $bodyFatPercentage, ')
          ..write('muscleMass: $muscleMass, ')
          ..write('boneMass: $boneMass, ')
          ..write('bodyWater: $bodyWater, ')
          ..write('visceralFatLevel: $visceralFatLevel, ')
          ..write('basalMetabolism: $basalMetabolism, ')
          ..write('proteinRate: $proteinRate, ')
          ..write('subcutaneousFat: $subcutaneousFat, ')
          ..write('measurementTimeType: $measurementTimeType, ')
          ..write('measurementDevice: $measurementDevice, ')
          ..write('roomTemperature: $roomTemperature, ')
          ..write('humidity: $humidity, ')
          ..write('menstrualCycleDay: $menstrualCycleDay, ')
          ..write('sleepQuality: $sleepQuality, ')
          ..write('stressLevel: $stressLevel, ')
          ..write('hydrationStatus: $hydrationStatus, ')
          ..write('notes: $notes, ')
          ..write('tags: $tags, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('moodScore: $moodScore, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    userId,
    recordDatetime,
    weight,
    bodyFatPercentage,
    muscleMass,
    boneMass,
    bodyWater,
    visceralFatLevel,
    basalMetabolism,
    proteinRate,
    subcutaneousFat,
    measurementTimeType,
    measurementDevice,
    roomTemperature,
    humidity,
    menstrualCycleDay,
    sleepQuality,
    stressLevel,
    hydrationStatus,
    notes,
    tags,
    photoUrl,
    moodScore,
    createdAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProfessionalWeightRecord &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.recordDatetime == this.recordDatetime &&
          other.weight == this.weight &&
          other.bodyFatPercentage == this.bodyFatPercentage &&
          other.muscleMass == this.muscleMass &&
          other.boneMass == this.boneMass &&
          other.bodyWater == this.bodyWater &&
          other.visceralFatLevel == this.visceralFatLevel &&
          other.basalMetabolism == this.basalMetabolism &&
          other.proteinRate == this.proteinRate &&
          other.subcutaneousFat == this.subcutaneousFat &&
          other.measurementTimeType == this.measurementTimeType &&
          other.measurementDevice == this.measurementDevice &&
          other.roomTemperature == this.roomTemperature &&
          other.humidity == this.humidity &&
          other.menstrualCycleDay == this.menstrualCycleDay &&
          other.sleepQuality == this.sleepQuality &&
          other.stressLevel == this.stressLevel &&
          other.hydrationStatus == this.hydrationStatus &&
          other.notes == this.notes &&
          other.tags == this.tags &&
          other.photoUrl == this.photoUrl &&
          other.moodScore == this.moodScore &&
          other.createdAt == this.createdAt);
}

class ProfessionalWeightRecordsCompanion
    extends UpdateCompanion<ProfessionalWeightRecord> {
  final Value<int> id;
  final Value<String> userId;
  final Value<DateTime> recordDatetime;
  final Value<double> weight;
  final Value<double?> bodyFatPercentage;
  final Value<double?> muscleMass;
  final Value<double?> boneMass;
  final Value<double?> bodyWater;
  final Value<int?> visceralFatLevel;
  final Value<int?> basalMetabolism;
  final Value<double?> proteinRate;
  final Value<double?> subcutaneousFat;
  final Value<String?> measurementTimeType;
  final Value<String?> measurementDevice;
  final Value<double?> roomTemperature;
  final Value<double?> humidity;
  final Value<int?> menstrualCycleDay;
  final Value<int?> sleepQuality;
  final Value<int?> stressLevel;
  final Value<String?> hydrationStatus;
  final Value<String?> notes;
  final Value<String?> tags;
  final Value<String?> photoUrl;
  final Value<int?> moodScore;
  final Value<DateTime> createdAt;
  const ProfessionalWeightRecordsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.recordDatetime = const Value.absent(),
    this.weight = const Value.absent(),
    this.bodyFatPercentage = const Value.absent(),
    this.muscleMass = const Value.absent(),
    this.boneMass = const Value.absent(),
    this.bodyWater = const Value.absent(),
    this.visceralFatLevel = const Value.absent(),
    this.basalMetabolism = const Value.absent(),
    this.proteinRate = const Value.absent(),
    this.subcutaneousFat = const Value.absent(),
    this.measurementTimeType = const Value.absent(),
    this.measurementDevice = const Value.absent(),
    this.roomTemperature = const Value.absent(),
    this.humidity = const Value.absent(),
    this.menstrualCycleDay = const Value.absent(),
    this.sleepQuality = const Value.absent(),
    this.stressLevel = const Value.absent(),
    this.hydrationStatus = const Value.absent(),
    this.notes = const Value.absent(),
    this.tags = const Value.absent(),
    this.photoUrl = const Value.absent(),
    this.moodScore = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ProfessionalWeightRecordsCompanion.insert({
    this.id = const Value.absent(),
    required String userId,
    required DateTime recordDatetime,
    required double weight,
    this.bodyFatPercentage = const Value.absent(),
    this.muscleMass = const Value.absent(),
    this.boneMass = const Value.absent(),
    this.bodyWater = const Value.absent(),
    this.visceralFatLevel = const Value.absent(),
    this.basalMetabolism = const Value.absent(),
    this.proteinRate = const Value.absent(),
    this.subcutaneousFat = const Value.absent(),
    this.measurementTimeType = const Value.absent(),
    this.measurementDevice = const Value.absent(),
    this.roomTemperature = const Value.absent(),
    this.humidity = const Value.absent(),
    this.menstrualCycleDay = const Value.absent(),
    this.sleepQuality = const Value.absent(),
    this.stressLevel = const Value.absent(),
    this.hydrationStatus = const Value.absent(),
    this.notes = const Value.absent(),
    this.tags = const Value.absent(),
    this.photoUrl = const Value.absent(),
    this.moodScore = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : userId = Value(userId),
       recordDatetime = Value(recordDatetime),
       weight = Value(weight);
  static Insertable<ProfessionalWeightRecord> custom({
    Expression<int>? id,
    Expression<String>? userId,
    Expression<DateTime>? recordDatetime,
    Expression<double>? weight,
    Expression<double>? bodyFatPercentage,
    Expression<double>? muscleMass,
    Expression<double>? boneMass,
    Expression<double>? bodyWater,
    Expression<int>? visceralFatLevel,
    Expression<int>? basalMetabolism,
    Expression<double>? proteinRate,
    Expression<double>? subcutaneousFat,
    Expression<String>? measurementTimeType,
    Expression<String>? measurementDevice,
    Expression<double>? roomTemperature,
    Expression<double>? humidity,
    Expression<int>? menstrualCycleDay,
    Expression<int>? sleepQuality,
    Expression<int>? stressLevel,
    Expression<String>? hydrationStatus,
    Expression<String>? notes,
    Expression<String>? tags,
    Expression<String>? photoUrl,
    Expression<int>? moodScore,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (recordDatetime != null) 'record_datetime': recordDatetime,
      if (weight != null) 'weight': weight,
      if (bodyFatPercentage != null) 'body_fat_percentage': bodyFatPercentage,
      if (muscleMass != null) 'muscle_mass': muscleMass,
      if (boneMass != null) 'bone_mass': boneMass,
      if (bodyWater != null) 'body_water': bodyWater,
      if (visceralFatLevel != null) 'visceral_fat_level': visceralFatLevel,
      if (basalMetabolism != null) 'basal_metabolism': basalMetabolism,
      if (proteinRate != null) 'protein_rate': proteinRate,
      if (subcutaneousFat != null) 'subcutaneous_fat': subcutaneousFat,
      if (measurementTimeType != null)
        'measurement_time_type': measurementTimeType,
      if (measurementDevice != null) 'measurement_device': measurementDevice,
      if (roomTemperature != null) 'room_temperature': roomTemperature,
      if (humidity != null) 'humidity': humidity,
      if (menstrualCycleDay != null) 'menstrual_cycle_day': menstrualCycleDay,
      if (sleepQuality != null) 'sleep_quality': sleepQuality,
      if (stressLevel != null) 'stress_level': stressLevel,
      if (hydrationStatus != null) 'hydration_status': hydrationStatus,
      if (notes != null) 'notes': notes,
      if (tags != null) 'tags': tags,
      if (photoUrl != null) 'photo_url': photoUrl,
      if (moodScore != null) 'mood_score': moodScore,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ProfessionalWeightRecordsCompanion copyWith({
    Value<int>? id,
    Value<String>? userId,
    Value<DateTime>? recordDatetime,
    Value<double>? weight,
    Value<double?>? bodyFatPercentage,
    Value<double?>? muscleMass,
    Value<double?>? boneMass,
    Value<double?>? bodyWater,
    Value<int?>? visceralFatLevel,
    Value<int?>? basalMetabolism,
    Value<double?>? proteinRate,
    Value<double?>? subcutaneousFat,
    Value<String?>? measurementTimeType,
    Value<String?>? measurementDevice,
    Value<double?>? roomTemperature,
    Value<double?>? humidity,
    Value<int?>? menstrualCycleDay,
    Value<int?>? sleepQuality,
    Value<int?>? stressLevel,
    Value<String?>? hydrationStatus,
    Value<String?>? notes,
    Value<String?>? tags,
    Value<String?>? photoUrl,
    Value<int?>? moodScore,
    Value<DateTime>? createdAt,
  }) {
    return ProfessionalWeightRecordsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      recordDatetime: recordDatetime ?? this.recordDatetime,
      weight: weight ?? this.weight,
      bodyFatPercentage: bodyFatPercentage ?? this.bodyFatPercentage,
      muscleMass: muscleMass ?? this.muscleMass,
      boneMass: boneMass ?? this.boneMass,
      bodyWater: bodyWater ?? this.bodyWater,
      visceralFatLevel: visceralFatLevel ?? this.visceralFatLevel,
      basalMetabolism: basalMetabolism ?? this.basalMetabolism,
      proteinRate: proteinRate ?? this.proteinRate,
      subcutaneousFat: subcutaneousFat ?? this.subcutaneousFat,
      measurementTimeType: measurementTimeType ?? this.measurementTimeType,
      measurementDevice: measurementDevice ?? this.measurementDevice,
      roomTemperature: roomTemperature ?? this.roomTemperature,
      humidity: humidity ?? this.humidity,
      menstrualCycleDay: menstrualCycleDay ?? this.menstrualCycleDay,
      sleepQuality: sleepQuality ?? this.sleepQuality,
      stressLevel: stressLevel ?? this.stressLevel,
      hydrationStatus: hydrationStatus ?? this.hydrationStatus,
      notes: notes ?? this.notes,
      tags: tags ?? this.tags,
      photoUrl: photoUrl ?? this.photoUrl,
      moodScore: moodScore ?? this.moodScore,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (recordDatetime.present) {
      map['record_datetime'] = Variable<DateTime>(recordDatetime.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (bodyFatPercentage.present) {
      map['body_fat_percentage'] = Variable<double>(bodyFatPercentage.value);
    }
    if (muscleMass.present) {
      map['muscle_mass'] = Variable<double>(muscleMass.value);
    }
    if (boneMass.present) {
      map['bone_mass'] = Variable<double>(boneMass.value);
    }
    if (bodyWater.present) {
      map['body_water'] = Variable<double>(bodyWater.value);
    }
    if (visceralFatLevel.present) {
      map['visceral_fat_level'] = Variable<int>(visceralFatLevel.value);
    }
    if (basalMetabolism.present) {
      map['basal_metabolism'] = Variable<int>(basalMetabolism.value);
    }
    if (proteinRate.present) {
      map['protein_rate'] = Variable<double>(proteinRate.value);
    }
    if (subcutaneousFat.present) {
      map['subcutaneous_fat'] = Variable<double>(subcutaneousFat.value);
    }
    if (measurementTimeType.present) {
      map['measurement_time_type'] = Variable<String>(
        measurementTimeType.value,
      );
    }
    if (measurementDevice.present) {
      map['measurement_device'] = Variable<String>(measurementDevice.value);
    }
    if (roomTemperature.present) {
      map['room_temperature'] = Variable<double>(roomTemperature.value);
    }
    if (humidity.present) {
      map['humidity'] = Variable<double>(humidity.value);
    }
    if (menstrualCycleDay.present) {
      map['menstrual_cycle_day'] = Variable<int>(menstrualCycleDay.value);
    }
    if (sleepQuality.present) {
      map['sleep_quality'] = Variable<int>(sleepQuality.value);
    }
    if (stressLevel.present) {
      map['stress_level'] = Variable<int>(stressLevel.value);
    }
    if (hydrationStatus.present) {
      map['hydration_status'] = Variable<String>(hydrationStatus.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (photoUrl.present) {
      map['photo_url'] = Variable<String>(photoUrl.value);
    }
    if (moodScore.present) {
      map['mood_score'] = Variable<int>(moodScore.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfessionalWeightRecordsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('recordDatetime: $recordDatetime, ')
          ..write('weight: $weight, ')
          ..write('bodyFatPercentage: $bodyFatPercentage, ')
          ..write('muscleMass: $muscleMass, ')
          ..write('boneMass: $boneMass, ')
          ..write('bodyWater: $bodyWater, ')
          ..write('visceralFatLevel: $visceralFatLevel, ')
          ..write('basalMetabolism: $basalMetabolism, ')
          ..write('proteinRate: $proteinRate, ')
          ..write('subcutaneousFat: $subcutaneousFat, ')
          ..write('measurementTimeType: $measurementTimeType, ')
          ..write('measurementDevice: $measurementDevice, ')
          ..write('roomTemperature: $roomTemperature, ')
          ..write('humidity: $humidity, ')
          ..write('menstrualCycleDay: $menstrualCycleDay, ')
          ..write('sleepQuality: $sleepQuality, ')
          ..write('stressLevel: $stressLevel, ')
          ..write('hydrationStatus: $hydrationStatus, ')
          ..write('notes: $notes, ')
          ..write('tags: $tags, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('moodScore: $moodScore, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $BloodPressureRecordsTable extends BloodPressureRecords
    with TableInfo<$BloodPressureRecordsTable, BloodPressureRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BloodPressureRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordDatetimeMeta = const VerificationMeta(
    'recordDatetime',
  );
  @override
  late final GeneratedColumn<DateTime> recordDatetime =
      GeneratedColumn<DateTime>(
        'record_datetime',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _systolicPressureMeta = const VerificationMeta(
    'systolicPressure',
  );
  @override
  late final GeneratedColumn<int> systolicPressure = GeneratedColumn<int>(
    'systolic_pressure',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _diastolicPressureMeta = const VerificationMeta(
    'diastolicPressure',
  );
  @override
  late final GeneratedColumn<int> diastolicPressure = GeneratedColumn<int>(
    'diastolic_pressure',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pulseRateMeta = const VerificationMeta(
    'pulseRate',
  );
  @override
  late final GeneratedColumn<int> pulseRate = GeneratedColumn<int>(
    'pulse_rate',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _meanArterialPressureMeta =
      const VerificationMeta('meanArterialPressure');
  @override
  late final GeneratedColumn<double> meanArterialPressure =
      GeneratedColumn<double>(
        'mean_arterial_pressure',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _measurementPositionMeta =
      const VerificationMeta('measurementPosition');
  @override
  late final GeneratedColumn<String> measurementPosition =
      GeneratedColumn<String>(
        'measurement_position',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _armUsedMeta = const VerificationMeta(
    'armUsed',
  );
  @override
  late final GeneratedColumn<String> armUsed = GeneratedColumn<String>(
    'arm_used',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cuffSizeMeta = const VerificationMeta(
    'cuffSize',
  );
  @override
  late final GeneratedColumn<String> cuffSize = GeneratedColumn<String>(
    'cuff_size',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceModelMeta = const VerificationMeta(
    'deviceModel',
  );
  @override
  late final GeneratedColumn<String> deviceModel = GeneratedColumn<String>(
    'device_model',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _measurementCountMeta = const VerificationMeta(
    'measurementCount',
  );
  @override
  late final GeneratedColumn<int> measurementCount = GeneratedColumn<int>(
    'measurement_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _beforeRestTimeMeta = const VerificationMeta(
    'beforeRestTime',
  );
  @override
  late final GeneratedColumn<int> beforeRestTime = GeneratedColumn<int>(
    'before_rest_time',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _caffeineIntakeHoursMeta =
      const VerificationMeta('caffeineIntakeHours');
  @override
  late final GeneratedColumn<double> caffeineIntakeHours =
      GeneratedColumn<double>(
        'caffeine_intake_hours',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _exerciseHoursBeforeMeta =
      const VerificationMeta('exerciseHoursBefore');
  @override
  late final GeneratedColumn<double> exerciseHoursBefore =
      GeneratedColumn<double>(
        'exercise_hours_before',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastMealHoursMeta = const VerificationMeta(
    'lastMealHours',
  );
  @override
  late final GeneratedColumn<double> lastMealHours = GeneratedColumn<double>(
    'last_meal_hours',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _smokingHoursBeforeMeta =
      const VerificationMeta('smokingHoursBefore');
  @override
  late final GeneratedColumn<double> smokingHoursBefore =
      GeneratedColumn<double>(
        'smoking_hours_before',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _alcoholHoursBeforeMeta =
      const VerificationMeta('alcoholHoursBefore');
  @override
  late final GeneratedColumn<double> alcoholHoursBefore =
      GeneratedColumn<double>(
        'alcohol_hours_before',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _symptomsMeta = const VerificationMeta(
    'symptoms',
  );
  @override
  late final GeneratedColumn<String> symptoms = GeneratedColumn<String>(
    'symptoms',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _medicationTakenMeta = const VerificationMeta(
    'medicationTaken',
  );
  @override
  late final GeneratedColumn<String> medicationTaken = GeneratedColumn<String>(
    'medication_taken',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sleepHoursMeta = const VerificationMeta(
    'sleepHours',
  );
  @override
  late final GeneratedColumn<double> sleepHours = GeneratedColumn<double>(
    'sleep_hours',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stressEventsMeta = const VerificationMeta(
    'stressEvents',
  );
  @override
  late final GeneratedColumn<String> stressEvents = GeneratedColumn<String>(
    'stress_events',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _roomTemperatureMeta = const VerificationMeta(
    'roomTemperature',
  );
  @override
  late final GeneratedColumn<double> roomTemperature = GeneratedColumn<double>(
    'room_temperature',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noiseLevelMeta = const VerificationMeta(
    'noiseLevel',
  );
  @override
  late final GeneratedColumn<String> noiseLevel = GeneratedColumn<String>(
    'noise_level',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    recordDatetime,
    systolicPressure,
    diastolicPressure,
    pulseRate,
    meanArterialPressure,
    measurementPosition,
    armUsed,
    cuffSize,
    deviceModel,
    measurementCount,
    beforeRestTime,
    caffeineIntakeHours,
    exerciseHoursBefore,
    lastMealHours,
    smokingHoursBefore,
    alcoholHoursBefore,
    symptoms,
    medicationTaken,
    sleepHours,
    stressEvents,
    roomTemperature,
    noiseLevel,
    notes,
    tags,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'blood_pressure_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<BloodPressureRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('record_datetime')) {
      context.handle(
        _recordDatetimeMeta,
        recordDatetime.isAcceptableOrUnknown(
          data['record_datetime']!,
          _recordDatetimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recordDatetimeMeta);
    }
    if (data.containsKey('systolic_pressure')) {
      context.handle(
        _systolicPressureMeta,
        systolicPressure.isAcceptableOrUnknown(
          data['systolic_pressure']!,
          _systolicPressureMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_systolicPressureMeta);
    }
    if (data.containsKey('diastolic_pressure')) {
      context.handle(
        _diastolicPressureMeta,
        diastolicPressure.isAcceptableOrUnknown(
          data['diastolic_pressure']!,
          _diastolicPressureMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_diastolicPressureMeta);
    }
    if (data.containsKey('pulse_rate')) {
      context.handle(
        _pulseRateMeta,
        pulseRate.isAcceptableOrUnknown(data['pulse_rate']!, _pulseRateMeta),
      );
    }
    if (data.containsKey('mean_arterial_pressure')) {
      context.handle(
        _meanArterialPressureMeta,
        meanArterialPressure.isAcceptableOrUnknown(
          data['mean_arterial_pressure']!,
          _meanArterialPressureMeta,
        ),
      );
    }
    if (data.containsKey('measurement_position')) {
      context.handle(
        _measurementPositionMeta,
        measurementPosition.isAcceptableOrUnknown(
          data['measurement_position']!,
          _measurementPositionMeta,
        ),
      );
    }
    if (data.containsKey('arm_used')) {
      context.handle(
        _armUsedMeta,
        armUsed.isAcceptableOrUnknown(data['arm_used']!, _armUsedMeta),
      );
    }
    if (data.containsKey('cuff_size')) {
      context.handle(
        _cuffSizeMeta,
        cuffSize.isAcceptableOrUnknown(data['cuff_size']!, _cuffSizeMeta),
      );
    }
    if (data.containsKey('device_model')) {
      context.handle(
        _deviceModelMeta,
        deviceModel.isAcceptableOrUnknown(
          data['device_model']!,
          _deviceModelMeta,
        ),
      );
    }
    if (data.containsKey('measurement_count')) {
      context.handle(
        _measurementCountMeta,
        measurementCount.isAcceptableOrUnknown(
          data['measurement_count']!,
          _measurementCountMeta,
        ),
      );
    }
    if (data.containsKey('before_rest_time')) {
      context.handle(
        _beforeRestTimeMeta,
        beforeRestTime.isAcceptableOrUnknown(
          data['before_rest_time']!,
          _beforeRestTimeMeta,
        ),
      );
    }
    if (data.containsKey('caffeine_intake_hours')) {
      context.handle(
        _caffeineIntakeHoursMeta,
        caffeineIntakeHours.isAcceptableOrUnknown(
          data['caffeine_intake_hours']!,
          _caffeineIntakeHoursMeta,
        ),
      );
    }
    if (data.containsKey('exercise_hours_before')) {
      context.handle(
        _exerciseHoursBeforeMeta,
        exerciseHoursBefore.isAcceptableOrUnknown(
          data['exercise_hours_before']!,
          _exerciseHoursBeforeMeta,
        ),
      );
    }
    if (data.containsKey('last_meal_hours')) {
      context.handle(
        _lastMealHoursMeta,
        lastMealHours.isAcceptableOrUnknown(
          data['last_meal_hours']!,
          _lastMealHoursMeta,
        ),
      );
    }
    if (data.containsKey('smoking_hours_before')) {
      context.handle(
        _smokingHoursBeforeMeta,
        smokingHoursBefore.isAcceptableOrUnknown(
          data['smoking_hours_before']!,
          _smokingHoursBeforeMeta,
        ),
      );
    }
    if (data.containsKey('alcohol_hours_before')) {
      context.handle(
        _alcoholHoursBeforeMeta,
        alcoholHoursBefore.isAcceptableOrUnknown(
          data['alcohol_hours_before']!,
          _alcoholHoursBeforeMeta,
        ),
      );
    }
    if (data.containsKey('symptoms')) {
      context.handle(
        _symptomsMeta,
        symptoms.isAcceptableOrUnknown(data['symptoms']!, _symptomsMeta),
      );
    }
    if (data.containsKey('medication_taken')) {
      context.handle(
        _medicationTakenMeta,
        medicationTaken.isAcceptableOrUnknown(
          data['medication_taken']!,
          _medicationTakenMeta,
        ),
      );
    }
    if (data.containsKey('sleep_hours')) {
      context.handle(
        _sleepHoursMeta,
        sleepHours.isAcceptableOrUnknown(data['sleep_hours']!, _sleepHoursMeta),
      );
    }
    if (data.containsKey('stress_events')) {
      context.handle(
        _stressEventsMeta,
        stressEvents.isAcceptableOrUnknown(
          data['stress_events']!,
          _stressEventsMeta,
        ),
      );
    }
    if (data.containsKey('room_temperature')) {
      context.handle(
        _roomTemperatureMeta,
        roomTemperature.isAcceptableOrUnknown(
          data['room_temperature']!,
          _roomTemperatureMeta,
        ),
      );
    }
    if (data.containsKey('noise_level')) {
      context.handle(
        _noiseLevelMeta,
        noiseLevel.isAcceptableOrUnknown(data['noise_level']!, _noiseLevelMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BloodPressureRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BloodPressureRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      recordDatetime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}record_datetime'],
      )!,
      systolicPressure: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}systolic_pressure'],
      )!,
      diastolicPressure: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}diastolic_pressure'],
      )!,
      pulseRate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pulse_rate'],
      ),
      meanArterialPressure: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}mean_arterial_pressure'],
      ),
      measurementPosition: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}measurement_position'],
      ),
      armUsed: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}arm_used'],
      ),
      cuffSize: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cuff_size'],
      ),
      deviceModel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_model'],
      ),
      measurementCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}measurement_count'],
      )!,
      beforeRestTime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}before_rest_time'],
      ),
      caffeineIntakeHours: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}caffeine_intake_hours'],
      ),
      exerciseHoursBefore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}exercise_hours_before'],
      ),
      lastMealHours: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}last_meal_hours'],
      ),
      smokingHoursBefore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}smoking_hours_before'],
      ),
      alcoholHoursBefore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}alcohol_hours_before'],
      ),
      symptoms: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}symptoms'],
      ),
      medicationTaken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}medication_taken'],
      ),
      sleepHours: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sleep_hours'],
      ),
      stressEvents: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stress_events'],
      ),
      roomTemperature: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}room_temperature'],
      ),
      noiseLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}noise_level'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BloodPressureRecordsTable createAlias(String alias) {
    return $BloodPressureRecordsTable(attachedDatabase, alias);
  }
}

class BloodPressureRecord extends DataClass
    implements Insertable<BloodPressureRecord> {
  final int id;
  final String userId;
  final DateTime recordDatetime;
  final int systolicPressure;
  final int diastolicPressure;
  final int? pulseRate;
  final double? meanArterialPressure;
  final String? measurementPosition;
  final String? armUsed;
  final String? cuffSize;
  final String? deviceModel;
  final int measurementCount;
  final int? beforeRestTime;
  final double? caffeineIntakeHours;
  final double? exerciseHoursBefore;
  final double? lastMealHours;
  final double? smokingHoursBefore;
  final double? alcoholHoursBefore;
  final String? symptoms;
  final String? medicationTaken;
  final double? sleepHours;
  final String? stressEvents;
  final double? roomTemperature;
  final String? noiseLevel;
  final String? notes;
  final String? tags;
  final DateTime createdAt;
  const BloodPressureRecord({
    required this.id,
    required this.userId,
    required this.recordDatetime,
    required this.systolicPressure,
    required this.diastolicPressure,
    this.pulseRate,
    this.meanArterialPressure,
    this.measurementPosition,
    this.armUsed,
    this.cuffSize,
    this.deviceModel,
    required this.measurementCount,
    this.beforeRestTime,
    this.caffeineIntakeHours,
    this.exerciseHoursBefore,
    this.lastMealHours,
    this.smokingHoursBefore,
    this.alcoholHoursBefore,
    this.symptoms,
    this.medicationTaken,
    this.sleepHours,
    this.stressEvents,
    this.roomTemperature,
    this.noiseLevel,
    this.notes,
    this.tags,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<String>(userId);
    map['record_datetime'] = Variable<DateTime>(recordDatetime);
    map['systolic_pressure'] = Variable<int>(systolicPressure);
    map['diastolic_pressure'] = Variable<int>(diastolicPressure);
    if (!nullToAbsent || pulseRate != null) {
      map['pulse_rate'] = Variable<int>(pulseRate);
    }
    if (!nullToAbsent || meanArterialPressure != null) {
      map['mean_arterial_pressure'] = Variable<double>(meanArterialPressure);
    }
    if (!nullToAbsent || measurementPosition != null) {
      map['measurement_position'] = Variable<String>(measurementPosition);
    }
    if (!nullToAbsent || armUsed != null) {
      map['arm_used'] = Variable<String>(armUsed);
    }
    if (!nullToAbsent || cuffSize != null) {
      map['cuff_size'] = Variable<String>(cuffSize);
    }
    if (!nullToAbsent || deviceModel != null) {
      map['device_model'] = Variable<String>(deviceModel);
    }
    map['measurement_count'] = Variable<int>(measurementCount);
    if (!nullToAbsent || beforeRestTime != null) {
      map['before_rest_time'] = Variable<int>(beforeRestTime);
    }
    if (!nullToAbsent || caffeineIntakeHours != null) {
      map['caffeine_intake_hours'] = Variable<double>(caffeineIntakeHours);
    }
    if (!nullToAbsent || exerciseHoursBefore != null) {
      map['exercise_hours_before'] = Variable<double>(exerciseHoursBefore);
    }
    if (!nullToAbsent || lastMealHours != null) {
      map['last_meal_hours'] = Variable<double>(lastMealHours);
    }
    if (!nullToAbsent || smokingHoursBefore != null) {
      map['smoking_hours_before'] = Variable<double>(smokingHoursBefore);
    }
    if (!nullToAbsent || alcoholHoursBefore != null) {
      map['alcohol_hours_before'] = Variable<double>(alcoholHoursBefore);
    }
    if (!nullToAbsent || symptoms != null) {
      map['symptoms'] = Variable<String>(symptoms);
    }
    if (!nullToAbsent || medicationTaken != null) {
      map['medication_taken'] = Variable<String>(medicationTaken);
    }
    if (!nullToAbsent || sleepHours != null) {
      map['sleep_hours'] = Variable<double>(sleepHours);
    }
    if (!nullToAbsent || stressEvents != null) {
      map['stress_events'] = Variable<String>(stressEvents);
    }
    if (!nullToAbsent || roomTemperature != null) {
      map['room_temperature'] = Variable<double>(roomTemperature);
    }
    if (!nullToAbsent || noiseLevel != null) {
      map['noise_level'] = Variable<String>(noiseLevel);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || tags != null) {
      map['tags'] = Variable<String>(tags);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BloodPressureRecordsCompanion toCompanion(bool nullToAbsent) {
    return BloodPressureRecordsCompanion(
      id: Value(id),
      userId: Value(userId),
      recordDatetime: Value(recordDatetime),
      systolicPressure: Value(systolicPressure),
      diastolicPressure: Value(diastolicPressure),
      pulseRate: pulseRate == null && nullToAbsent
          ? const Value.absent()
          : Value(pulseRate),
      meanArterialPressure: meanArterialPressure == null && nullToAbsent
          ? const Value.absent()
          : Value(meanArterialPressure),
      measurementPosition: measurementPosition == null && nullToAbsent
          ? const Value.absent()
          : Value(measurementPosition),
      armUsed: armUsed == null && nullToAbsent
          ? const Value.absent()
          : Value(armUsed),
      cuffSize: cuffSize == null && nullToAbsent
          ? const Value.absent()
          : Value(cuffSize),
      deviceModel: deviceModel == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceModel),
      measurementCount: Value(measurementCount),
      beforeRestTime: beforeRestTime == null && nullToAbsent
          ? const Value.absent()
          : Value(beforeRestTime),
      caffeineIntakeHours: caffeineIntakeHours == null && nullToAbsent
          ? const Value.absent()
          : Value(caffeineIntakeHours),
      exerciseHoursBefore: exerciseHoursBefore == null && nullToAbsent
          ? const Value.absent()
          : Value(exerciseHoursBefore),
      lastMealHours: lastMealHours == null && nullToAbsent
          ? const Value.absent()
          : Value(lastMealHours),
      smokingHoursBefore: smokingHoursBefore == null && nullToAbsent
          ? const Value.absent()
          : Value(smokingHoursBefore),
      alcoholHoursBefore: alcoholHoursBefore == null && nullToAbsent
          ? const Value.absent()
          : Value(alcoholHoursBefore),
      symptoms: symptoms == null && nullToAbsent
          ? const Value.absent()
          : Value(symptoms),
      medicationTaken: medicationTaken == null && nullToAbsent
          ? const Value.absent()
          : Value(medicationTaken),
      sleepHours: sleepHours == null && nullToAbsent
          ? const Value.absent()
          : Value(sleepHours),
      stressEvents: stressEvents == null && nullToAbsent
          ? const Value.absent()
          : Value(stressEvents),
      roomTemperature: roomTemperature == null && nullToAbsent
          ? const Value.absent()
          : Value(roomTemperature),
      noiseLevel: noiseLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(noiseLevel),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      tags: tags == null && nullToAbsent ? const Value.absent() : Value(tags),
      createdAt: Value(createdAt),
    );
  }

  factory BloodPressureRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BloodPressureRecord(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      recordDatetime: serializer.fromJson<DateTime>(json['recordDatetime']),
      systolicPressure: serializer.fromJson<int>(json['systolicPressure']),
      diastolicPressure: serializer.fromJson<int>(json['diastolicPressure']),
      pulseRate: serializer.fromJson<int?>(json['pulseRate']),
      meanArterialPressure: serializer.fromJson<double?>(
        json['meanArterialPressure'],
      ),
      measurementPosition: serializer.fromJson<String?>(
        json['measurementPosition'],
      ),
      armUsed: serializer.fromJson<String?>(json['armUsed']),
      cuffSize: serializer.fromJson<String?>(json['cuffSize']),
      deviceModel: serializer.fromJson<String?>(json['deviceModel']),
      measurementCount: serializer.fromJson<int>(json['measurementCount']),
      beforeRestTime: serializer.fromJson<int?>(json['beforeRestTime']),
      caffeineIntakeHours: serializer.fromJson<double?>(
        json['caffeineIntakeHours'],
      ),
      exerciseHoursBefore: serializer.fromJson<double?>(
        json['exerciseHoursBefore'],
      ),
      lastMealHours: serializer.fromJson<double?>(json['lastMealHours']),
      smokingHoursBefore: serializer.fromJson<double?>(
        json['smokingHoursBefore'],
      ),
      alcoholHoursBefore: serializer.fromJson<double?>(
        json['alcoholHoursBefore'],
      ),
      symptoms: serializer.fromJson<String?>(json['symptoms']),
      medicationTaken: serializer.fromJson<String?>(json['medicationTaken']),
      sleepHours: serializer.fromJson<double?>(json['sleepHours']),
      stressEvents: serializer.fromJson<String?>(json['stressEvents']),
      roomTemperature: serializer.fromJson<double?>(json['roomTemperature']),
      noiseLevel: serializer.fromJson<String?>(json['noiseLevel']),
      notes: serializer.fromJson<String?>(json['notes']),
      tags: serializer.fromJson<String?>(json['tags']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<String>(userId),
      'recordDatetime': serializer.toJson<DateTime>(recordDatetime),
      'systolicPressure': serializer.toJson<int>(systolicPressure),
      'diastolicPressure': serializer.toJson<int>(diastolicPressure),
      'pulseRate': serializer.toJson<int?>(pulseRate),
      'meanArterialPressure': serializer.toJson<double?>(meanArterialPressure),
      'measurementPosition': serializer.toJson<String?>(measurementPosition),
      'armUsed': serializer.toJson<String?>(armUsed),
      'cuffSize': serializer.toJson<String?>(cuffSize),
      'deviceModel': serializer.toJson<String?>(deviceModel),
      'measurementCount': serializer.toJson<int>(measurementCount),
      'beforeRestTime': serializer.toJson<int?>(beforeRestTime),
      'caffeineIntakeHours': serializer.toJson<double?>(caffeineIntakeHours),
      'exerciseHoursBefore': serializer.toJson<double?>(exerciseHoursBefore),
      'lastMealHours': serializer.toJson<double?>(lastMealHours),
      'smokingHoursBefore': serializer.toJson<double?>(smokingHoursBefore),
      'alcoholHoursBefore': serializer.toJson<double?>(alcoholHoursBefore),
      'symptoms': serializer.toJson<String?>(symptoms),
      'medicationTaken': serializer.toJson<String?>(medicationTaken),
      'sleepHours': serializer.toJson<double?>(sleepHours),
      'stressEvents': serializer.toJson<String?>(stressEvents),
      'roomTemperature': serializer.toJson<double?>(roomTemperature),
      'noiseLevel': serializer.toJson<String?>(noiseLevel),
      'notes': serializer.toJson<String?>(notes),
      'tags': serializer.toJson<String?>(tags),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  BloodPressureRecord copyWith({
    int? id,
    String? userId,
    DateTime? recordDatetime,
    int? systolicPressure,
    int? diastolicPressure,
    Value<int?> pulseRate = const Value.absent(),
    Value<double?> meanArterialPressure = const Value.absent(),
    Value<String?> measurementPosition = const Value.absent(),
    Value<String?> armUsed = const Value.absent(),
    Value<String?> cuffSize = const Value.absent(),
    Value<String?> deviceModel = const Value.absent(),
    int? measurementCount,
    Value<int?> beforeRestTime = const Value.absent(),
    Value<double?> caffeineIntakeHours = const Value.absent(),
    Value<double?> exerciseHoursBefore = const Value.absent(),
    Value<double?> lastMealHours = const Value.absent(),
    Value<double?> smokingHoursBefore = const Value.absent(),
    Value<double?> alcoholHoursBefore = const Value.absent(),
    Value<String?> symptoms = const Value.absent(),
    Value<String?> medicationTaken = const Value.absent(),
    Value<double?> sleepHours = const Value.absent(),
    Value<String?> stressEvents = const Value.absent(),
    Value<double?> roomTemperature = const Value.absent(),
    Value<String?> noiseLevel = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> tags = const Value.absent(),
    DateTime? createdAt,
  }) => BloodPressureRecord(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    recordDatetime: recordDatetime ?? this.recordDatetime,
    systolicPressure: systolicPressure ?? this.systolicPressure,
    diastolicPressure: diastolicPressure ?? this.diastolicPressure,
    pulseRate: pulseRate.present ? pulseRate.value : this.pulseRate,
    meanArterialPressure: meanArterialPressure.present
        ? meanArterialPressure.value
        : this.meanArterialPressure,
    measurementPosition: measurementPosition.present
        ? measurementPosition.value
        : this.measurementPosition,
    armUsed: armUsed.present ? armUsed.value : this.armUsed,
    cuffSize: cuffSize.present ? cuffSize.value : this.cuffSize,
    deviceModel: deviceModel.present ? deviceModel.value : this.deviceModel,
    measurementCount: measurementCount ?? this.measurementCount,
    beforeRestTime: beforeRestTime.present
        ? beforeRestTime.value
        : this.beforeRestTime,
    caffeineIntakeHours: caffeineIntakeHours.present
        ? caffeineIntakeHours.value
        : this.caffeineIntakeHours,
    exerciseHoursBefore: exerciseHoursBefore.present
        ? exerciseHoursBefore.value
        : this.exerciseHoursBefore,
    lastMealHours: lastMealHours.present
        ? lastMealHours.value
        : this.lastMealHours,
    smokingHoursBefore: smokingHoursBefore.present
        ? smokingHoursBefore.value
        : this.smokingHoursBefore,
    alcoholHoursBefore: alcoholHoursBefore.present
        ? alcoholHoursBefore.value
        : this.alcoholHoursBefore,
    symptoms: symptoms.present ? symptoms.value : this.symptoms,
    medicationTaken: medicationTaken.present
        ? medicationTaken.value
        : this.medicationTaken,
    sleepHours: sleepHours.present ? sleepHours.value : this.sleepHours,
    stressEvents: stressEvents.present ? stressEvents.value : this.stressEvents,
    roomTemperature: roomTemperature.present
        ? roomTemperature.value
        : this.roomTemperature,
    noiseLevel: noiseLevel.present ? noiseLevel.value : this.noiseLevel,
    notes: notes.present ? notes.value : this.notes,
    tags: tags.present ? tags.value : this.tags,
    createdAt: createdAt ?? this.createdAt,
  );
  BloodPressureRecord copyWithCompanion(BloodPressureRecordsCompanion data) {
    return BloodPressureRecord(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      recordDatetime: data.recordDatetime.present
          ? data.recordDatetime.value
          : this.recordDatetime,
      systolicPressure: data.systolicPressure.present
          ? data.systolicPressure.value
          : this.systolicPressure,
      diastolicPressure: data.diastolicPressure.present
          ? data.diastolicPressure.value
          : this.diastolicPressure,
      pulseRate: data.pulseRate.present ? data.pulseRate.value : this.pulseRate,
      meanArterialPressure: data.meanArterialPressure.present
          ? data.meanArterialPressure.value
          : this.meanArterialPressure,
      measurementPosition: data.measurementPosition.present
          ? data.measurementPosition.value
          : this.measurementPosition,
      armUsed: data.armUsed.present ? data.armUsed.value : this.armUsed,
      cuffSize: data.cuffSize.present ? data.cuffSize.value : this.cuffSize,
      deviceModel: data.deviceModel.present
          ? data.deviceModel.value
          : this.deviceModel,
      measurementCount: data.measurementCount.present
          ? data.measurementCount.value
          : this.measurementCount,
      beforeRestTime: data.beforeRestTime.present
          ? data.beforeRestTime.value
          : this.beforeRestTime,
      caffeineIntakeHours: data.caffeineIntakeHours.present
          ? data.caffeineIntakeHours.value
          : this.caffeineIntakeHours,
      exerciseHoursBefore: data.exerciseHoursBefore.present
          ? data.exerciseHoursBefore.value
          : this.exerciseHoursBefore,
      lastMealHours: data.lastMealHours.present
          ? data.lastMealHours.value
          : this.lastMealHours,
      smokingHoursBefore: data.smokingHoursBefore.present
          ? data.smokingHoursBefore.value
          : this.smokingHoursBefore,
      alcoholHoursBefore: data.alcoholHoursBefore.present
          ? data.alcoholHoursBefore.value
          : this.alcoholHoursBefore,
      symptoms: data.symptoms.present ? data.symptoms.value : this.symptoms,
      medicationTaken: data.medicationTaken.present
          ? data.medicationTaken.value
          : this.medicationTaken,
      sleepHours: data.sleepHours.present
          ? data.sleepHours.value
          : this.sleepHours,
      stressEvents: data.stressEvents.present
          ? data.stressEvents.value
          : this.stressEvents,
      roomTemperature: data.roomTemperature.present
          ? data.roomTemperature.value
          : this.roomTemperature,
      noiseLevel: data.noiseLevel.present
          ? data.noiseLevel.value
          : this.noiseLevel,
      notes: data.notes.present ? data.notes.value : this.notes,
      tags: data.tags.present ? data.tags.value : this.tags,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BloodPressureRecord(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('recordDatetime: $recordDatetime, ')
          ..write('systolicPressure: $systolicPressure, ')
          ..write('diastolicPressure: $diastolicPressure, ')
          ..write('pulseRate: $pulseRate, ')
          ..write('meanArterialPressure: $meanArterialPressure, ')
          ..write('measurementPosition: $measurementPosition, ')
          ..write('armUsed: $armUsed, ')
          ..write('cuffSize: $cuffSize, ')
          ..write('deviceModel: $deviceModel, ')
          ..write('measurementCount: $measurementCount, ')
          ..write('beforeRestTime: $beforeRestTime, ')
          ..write('caffeineIntakeHours: $caffeineIntakeHours, ')
          ..write('exerciseHoursBefore: $exerciseHoursBefore, ')
          ..write('lastMealHours: $lastMealHours, ')
          ..write('smokingHoursBefore: $smokingHoursBefore, ')
          ..write('alcoholHoursBefore: $alcoholHoursBefore, ')
          ..write('symptoms: $symptoms, ')
          ..write('medicationTaken: $medicationTaken, ')
          ..write('sleepHours: $sleepHours, ')
          ..write('stressEvents: $stressEvents, ')
          ..write('roomTemperature: $roomTemperature, ')
          ..write('noiseLevel: $noiseLevel, ')
          ..write('notes: $notes, ')
          ..write('tags: $tags, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    userId,
    recordDatetime,
    systolicPressure,
    diastolicPressure,
    pulseRate,
    meanArterialPressure,
    measurementPosition,
    armUsed,
    cuffSize,
    deviceModel,
    measurementCount,
    beforeRestTime,
    caffeineIntakeHours,
    exerciseHoursBefore,
    lastMealHours,
    smokingHoursBefore,
    alcoholHoursBefore,
    symptoms,
    medicationTaken,
    sleepHours,
    stressEvents,
    roomTemperature,
    noiseLevel,
    notes,
    tags,
    createdAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BloodPressureRecord &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.recordDatetime == this.recordDatetime &&
          other.systolicPressure == this.systolicPressure &&
          other.diastolicPressure == this.diastolicPressure &&
          other.pulseRate == this.pulseRate &&
          other.meanArterialPressure == this.meanArterialPressure &&
          other.measurementPosition == this.measurementPosition &&
          other.armUsed == this.armUsed &&
          other.cuffSize == this.cuffSize &&
          other.deviceModel == this.deviceModel &&
          other.measurementCount == this.measurementCount &&
          other.beforeRestTime == this.beforeRestTime &&
          other.caffeineIntakeHours == this.caffeineIntakeHours &&
          other.exerciseHoursBefore == this.exerciseHoursBefore &&
          other.lastMealHours == this.lastMealHours &&
          other.smokingHoursBefore == this.smokingHoursBefore &&
          other.alcoholHoursBefore == this.alcoholHoursBefore &&
          other.symptoms == this.symptoms &&
          other.medicationTaken == this.medicationTaken &&
          other.sleepHours == this.sleepHours &&
          other.stressEvents == this.stressEvents &&
          other.roomTemperature == this.roomTemperature &&
          other.noiseLevel == this.noiseLevel &&
          other.notes == this.notes &&
          other.tags == this.tags &&
          other.createdAt == this.createdAt);
}

class BloodPressureRecordsCompanion
    extends UpdateCompanion<BloodPressureRecord> {
  final Value<int> id;
  final Value<String> userId;
  final Value<DateTime> recordDatetime;
  final Value<int> systolicPressure;
  final Value<int> diastolicPressure;
  final Value<int?> pulseRate;
  final Value<double?> meanArterialPressure;
  final Value<String?> measurementPosition;
  final Value<String?> armUsed;
  final Value<String?> cuffSize;
  final Value<String?> deviceModel;
  final Value<int> measurementCount;
  final Value<int?> beforeRestTime;
  final Value<double?> caffeineIntakeHours;
  final Value<double?> exerciseHoursBefore;
  final Value<double?> lastMealHours;
  final Value<double?> smokingHoursBefore;
  final Value<double?> alcoholHoursBefore;
  final Value<String?> symptoms;
  final Value<String?> medicationTaken;
  final Value<double?> sleepHours;
  final Value<String?> stressEvents;
  final Value<double?> roomTemperature;
  final Value<String?> noiseLevel;
  final Value<String?> notes;
  final Value<String?> tags;
  final Value<DateTime> createdAt;
  const BloodPressureRecordsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.recordDatetime = const Value.absent(),
    this.systolicPressure = const Value.absent(),
    this.diastolicPressure = const Value.absent(),
    this.pulseRate = const Value.absent(),
    this.meanArterialPressure = const Value.absent(),
    this.measurementPosition = const Value.absent(),
    this.armUsed = const Value.absent(),
    this.cuffSize = const Value.absent(),
    this.deviceModel = const Value.absent(),
    this.measurementCount = const Value.absent(),
    this.beforeRestTime = const Value.absent(),
    this.caffeineIntakeHours = const Value.absent(),
    this.exerciseHoursBefore = const Value.absent(),
    this.lastMealHours = const Value.absent(),
    this.smokingHoursBefore = const Value.absent(),
    this.alcoholHoursBefore = const Value.absent(),
    this.symptoms = const Value.absent(),
    this.medicationTaken = const Value.absent(),
    this.sleepHours = const Value.absent(),
    this.stressEvents = const Value.absent(),
    this.roomTemperature = const Value.absent(),
    this.noiseLevel = const Value.absent(),
    this.notes = const Value.absent(),
    this.tags = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  BloodPressureRecordsCompanion.insert({
    this.id = const Value.absent(),
    required String userId,
    required DateTime recordDatetime,
    required int systolicPressure,
    required int diastolicPressure,
    this.pulseRate = const Value.absent(),
    this.meanArterialPressure = const Value.absent(),
    this.measurementPosition = const Value.absent(),
    this.armUsed = const Value.absent(),
    this.cuffSize = const Value.absent(),
    this.deviceModel = const Value.absent(),
    this.measurementCount = const Value.absent(),
    this.beforeRestTime = const Value.absent(),
    this.caffeineIntakeHours = const Value.absent(),
    this.exerciseHoursBefore = const Value.absent(),
    this.lastMealHours = const Value.absent(),
    this.smokingHoursBefore = const Value.absent(),
    this.alcoholHoursBefore = const Value.absent(),
    this.symptoms = const Value.absent(),
    this.medicationTaken = const Value.absent(),
    this.sleepHours = const Value.absent(),
    this.stressEvents = const Value.absent(),
    this.roomTemperature = const Value.absent(),
    this.noiseLevel = const Value.absent(),
    this.notes = const Value.absent(),
    this.tags = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : userId = Value(userId),
       recordDatetime = Value(recordDatetime),
       systolicPressure = Value(systolicPressure),
       diastolicPressure = Value(diastolicPressure);
  static Insertable<BloodPressureRecord> custom({
    Expression<int>? id,
    Expression<String>? userId,
    Expression<DateTime>? recordDatetime,
    Expression<int>? systolicPressure,
    Expression<int>? diastolicPressure,
    Expression<int>? pulseRate,
    Expression<double>? meanArterialPressure,
    Expression<String>? measurementPosition,
    Expression<String>? armUsed,
    Expression<String>? cuffSize,
    Expression<String>? deviceModel,
    Expression<int>? measurementCount,
    Expression<int>? beforeRestTime,
    Expression<double>? caffeineIntakeHours,
    Expression<double>? exerciseHoursBefore,
    Expression<double>? lastMealHours,
    Expression<double>? smokingHoursBefore,
    Expression<double>? alcoholHoursBefore,
    Expression<String>? symptoms,
    Expression<String>? medicationTaken,
    Expression<double>? sleepHours,
    Expression<String>? stressEvents,
    Expression<double>? roomTemperature,
    Expression<String>? noiseLevel,
    Expression<String>? notes,
    Expression<String>? tags,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (recordDatetime != null) 'record_datetime': recordDatetime,
      if (systolicPressure != null) 'systolic_pressure': systolicPressure,
      if (diastolicPressure != null) 'diastolic_pressure': diastolicPressure,
      if (pulseRate != null) 'pulse_rate': pulseRate,
      if (meanArterialPressure != null)
        'mean_arterial_pressure': meanArterialPressure,
      if (measurementPosition != null)
        'measurement_position': measurementPosition,
      if (armUsed != null) 'arm_used': armUsed,
      if (cuffSize != null) 'cuff_size': cuffSize,
      if (deviceModel != null) 'device_model': deviceModel,
      if (measurementCount != null) 'measurement_count': measurementCount,
      if (beforeRestTime != null) 'before_rest_time': beforeRestTime,
      if (caffeineIntakeHours != null)
        'caffeine_intake_hours': caffeineIntakeHours,
      if (exerciseHoursBefore != null)
        'exercise_hours_before': exerciseHoursBefore,
      if (lastMealHours != null) 'last_meal_hours': lastMealHours,
      if (smokingHoursBefore != null)
        'smoking_hours_before': smokingHoursBefore,
      if (alcoholHoursBefore != null)
        'alcohol_hours_before': alcoholHoursBefore,
      if (symptoms != null) 'symptoms': symptoms,
      if (medicationTaken != null) 'medication_taken': medicationTaken,
      if (sleepHours != null) 'sleep_hours': sleepHours,
      if (stressEvents != null) 'stress_events': stressEvents,
      if (roomTemperature != null) 'room_temperature': roomTemperature,
      if (noiseLevel != null) 'noise_level': noiseLevel,
      if (notes != null) 'notes': notes,
      if (tags != null) 'tags': tags,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  BloodPressureRecordsCompanion copyWith({
    Value<int>? id,
    Value<String>? userId,
    Value<DateTime>? recordDatetime,
    Value<int>? systolicPressure,
    Value<int>? diastolicPressure,
    Value<int?>? pulseRate,
    Value<double?>? meanArterialPressure,
    Value<String?>? measurementPosition,
    Value<String?>? armUsed,
    Value<String?>? cuffSize,
    Value<String?>? deviceModel,
    Value<int>? measurementCount,
    Value<int?>? beforeRestTime,
    Value<double?>? caffeineIntakeHours,
    Value<double?>? exerciseHoursBefore,
    Value<double?>? lastMealHours,
    Value<double?>? smokingHoursBefore,
    Value<double?>? alcoholHoursBefore,
    Value<String?>? symptoms,
    Value<String?>? medicationTaken,
    Value<double?>? sleepHours,
    Value<String?>? stressEvents,
    Value<double?>? roomTemperature,
    Value<String?>? noiseLevel,
    Value<String?>? notes,
    Value<String?>? tags,
    Value<DateTime>? createdAt,
  }) {
    return BloodPressureRecordsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      recordDatetime: recordDatetime ?? this.recordDatetime,
      systolicPressure: systolicPressure ?? this.systolicPressure,
      diastolicPressure: diastolicPressure ?? this.diastolicPressure,
      pulseRate: pulseRate ?? this.pulseRate,
      meanArterialPressure: meanArterialPressure ?? this.meanArterialPressure,
      measurementPosition: measurementPosition ?? this.measurementPosition,
      armUsed: armUsed ?? this.armUsed,
      cuffSize: cuffSize ?? this.cuffSize,
      deviceModel: deviceModel ?? this.deviceModel,
      measurementCount: measurementCount ?? this.measurementCount,
      beforeRestTime: beforeRestTime ?? this.beforeRestTime,
      caffeineIntakeHours: caffeineIntakeHours ?? this.caffeineIntakeHours,
      exerciseHoursBefore: exerciseHoursBefore ?? this.exerciseHoursBefore,
      lastMealHours: lastMealHours ?? this.lastMealHours,
      smokingHoursBefore: smokingHoursBefore ?? this.smokingHoursBefore,
      alcoholHoursBefore: alcoholHoursBefore ?? this.alcoholHoursBefore,
      symptoms: symptoms ?? this.symptoms,
      medicationTaken: medicationTaken ?? this.medicationTaken,
      sleepHours: sleepHours ?? this.sleepHours,
      stressEvents: stressEvents ?? this.stressEvents,
      roomTemperature: roomTemperature ?? this.roomTemperature,
      noiseLevel: noiseLevel ?? this.noiseLevel,
      notes: notes ?? this.notes,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (recordDatetime.present) {
      map['record_datetime'] = Variable<DateTime>(recordDatetime.value);
    }
    if (systolicPressure.present) {
      map['systolic_pressure'] = Variable<int>(systolicPressure.value);
    }
    if (diastolicPressure.present) {
      map['diastolic_pressure'] = Variable<int>(diastolicPressure.value);
    }
    if (pulseRate.present) {
      map['pulse_rate'] = Variable<int>(pulseRate.value);
    }
    if (meanArterialPressure.present) {
      map['mean_arterial_pressure'] = Variable<double>(
        meanArterialPressure.value,
      );
    }
    if (measurementPosition.present) {
      map['measurement_position'] = Variable<String>(measurementPosition.value);
    }
    if (armUsed.present) {
      map['arm_used'] = Variable<String>(armUsed.value);
    }
    if (cuffSize.present) {
      map['cuff_size'] = Variable<String>(cuffSize.value);
    }
    if (deviceModel.present) {
      map['device_model'] = Variable<String>(deviceModel.value);
    }
    if (measurementCount.present) {
      map['measurement_count'] = Variable<int>(measurementCount.value);
    }
    if (beforeRestTime.present) {
      map['before_rest_time'] = Variable<int>(beforeRestTime.value);
    }
    if (caffeineIntakeHours.present) {
      map['caffeine_intake_hours'] = Variable<double>(
        caffeineIntakeHours.value,
      );
    }
    if (exerciseHoursBefore.present) {
      map['exercise_hours_before'] = Variable<double>(
        exerciseHoursBefore.value,
      );
    }
    if (lastMealHours.present) {
      map['last_meal_hours'] = Variable<double>(lastMealHours.value);
    }
    if (smokingHoursBefore.present) {
      map['smoking_hours_before'] = Variable<double>(smokingHoursBefore.value);
    }
    if (alcoholHoursBefore.present) {
      map['alcohol_hours_before'] = Variable<double>(alcoholHoursBefore.value);
    }
    if (symptoms.present) {
      map['symptoms'] = Variable<String>(symptoms.value);
    }
    if (medicationTaken.present) {
      map['medication_taken'] = Variable<String>(medicationTaken.value);
    }
    if (sleepHours.present) {
      map['sleep_hours'] = Variable<double>(sleepHours.value);
    }
    if (stressEvents.present) {
      map['stress_events'] = Variable<String>(stressEvents.value);
    }
    if (roomTemperature.present) {
      map['room_temperature'] = Variable<double>(roomTemperature.value);
    }
    if (noiseLevel.present) {
      map['noise_level'] = Variable<String>(noiseLevel.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BloodPressureRecordsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('recordDatetime: $recordDatetime, ')
          ..write('systolicPressure: $systolicPressure, ')
          ..write('diastolicPressure: $diastolicPressure, ')
          ..write('pulseRate: $pulseRate, ')
          ..write('meanArterialPressure: $meanArterialPressure, ')
          ..write('measurementPosition: $measurementPosition, ')
          ..write('armUsed: $armUsed, ')
          ..write('cuffSize: $cuffSize, ')
          ..write('deviceModel: $deviceModel, ')
          ..write('measurementCount: $measurementCount, ')
          ..write('beforeRestTime: $beforeRestTime, ')
          ..write('caffeineIntakeHours: $caffeineIntakeHours, ')
          ..write('exerciseHoursBefore: $exerciseHoursBefore, ')
          ..write('lastMealHours: $lastMealHours, ')
          ..write('smokingHoursBefore: $smokingHoursBefore, ')
          ..write('alcoholHoursBefore: $alcoholHoursBefore, ')
          ..write('symptoms: $symptoms, ')
          ..write('medicationTaken: $medicationTaken, ')
          ..write('sleepHours: $sleepHours, ')
          ..write('stressEvents: $stressEvents, ')
          ..write('roomTemperature: $roomTemperature, ')
          ..write('noiseLevel: $noiseLevel, ')
          ..write('notes: $notes, ')
          ..write('tags: $tags, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $HeartRateRecordsTable extends HeartRateRecords
    with TableInfo<$HeartRateRecordsTable, HeartRateRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HeartRateRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordStartTimeMeta = const VerificationMeta(
    'recordStartTime',
  );
  @override
  late final GeneratedColumn<DateTime> recordStartTime =
      GeneratedColumn<DateTime>(
        'record_start_time',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _recordDurationMeta = const VerificationMeta(
    'recordDuration',
  );
  @override
  late final GeneratedColumn<int> recordDuration = GeneratedColumn<int>(
    'record_duration',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _avgHeartRateMeta = const VerificationMeta(
    'avgHeartRate',
  );
  @override
  late final GeneratedColumn<int> avgHeartRate = GeneratedColumn<int>(
    'avg_heart_rate',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _maxHeartRateMeta = const VerificationMeta(
    'maxHeartRate',
  );
  @override
  late final GeneratedColumn<int> maxHeartRate = GeneratedColumn<int>(
    'max_heart_rate',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _minHeartRateMeta = const VerificationMeta(
    'minHeartRate',
  );
  @override
  late final GeneratedColumn<int> minHeartRate = GeneratedColumn<int>(
    'min_heart_rate',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _restingHeartRateMeta = const VerificationMeta(
    'restingHeartRate',
  );
  @override
  late final GeneratedColumn<int> restingHeartRate = GeneratedColumn<int>(
    'resting_heart_rate',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rmssdMeta = const VerificationMeta('rmssd');
  @override
  late final GeneratedColumn<double> rmssd = GeneratedColumn<double>(
    'rmssd',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pnn50Meta = const VerificationMeta('pnn50');
  @override
  late final GeneratedColumn<double> pnn50 = GeneratedColumn<double>(
    'pnn50',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sdnnMeta = const VerificationMeta('sdnn');
  @override
  late final GeneratedColumn<double> sdnn = GeneratedColumn<double>(
    'sdnn',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stressIndexMeta = const VerificationMeta(
    'stressIndex',
  );
  @override
  late final GeneratedColumn<double> stressIndex = GeneratedColumn<double>(
    'stress_index',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _zone1TimeMeta = const VerificationMeta(
    'zone1Time',
  );
  @override
  late final GeneratedColumn<int> zone1Time = GeneratedColumn<int>(
    'zone1_time',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _zone2TimeMeta = const VerificationMeta(
    'zone2Time',
  );
  @override
  late final GeneratedColumn<int> zone2Time = GeneratedColumn<int>(
    'zone2_time',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _zone3TimeMeta = const VerificationMeta(
    'zone3Time',
  );
  @override
  late final GeneratedColumn<int> zone3Time = GeneratedColumn<int>(
    'zone3_time',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _zone4TimeMeta = const VerificationMeta(
    'zone4Time',
  );
  @override
  late final GeneratedColumn<int> zone4Time = GeneratedColumn<int>(
    'zone4_time',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _zone5TimeMeta = const VerificationMeta(
    'zone5Time',
  );
  @override
  late final GeneratedColumn<int> zone5Time = GeneratedColumn<int>(
    'zone5_time',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activityTypeMeta = const VerificationMeta(
    'activityType',
  );
  @override
  late final GeneratedColumn<String> activityType = GeneratedColumn<String>(
    'activity_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bodyPositionMeta = const VerificationMeta(
    'bodyPosition',
  );
  @override
  late final GeneratedColumn<String> bodyPosition = GeneratedColumn<String>(
    'body_position',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _breathingPatternMeta = const VerificationMeta(
    'breathingPattern',
  );
  @override
  late final GeneratedColumn<String> breathingPattern = GeneratedColumn<String>(
    'breathing_pattern',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _caffeineIntakeMeta = const VerificationMeta(
    'caffeineIntake',
  );
  @override
  late final GeneratedColumn<bool> caffeineIntake = GeneratedColumn<bool>(
    'caffeine_intake',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("caffeine_intake" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _alcoholIntakeMeta = const VerificationMeta(
    'alcoholIntake',
  );
  @override
  late final GeneratedColumn<bool> alcoholIntake = GeneratedColumn<bool>(
    'alcohol_intake',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("alcohol_intake" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _medicationTakenMeta = const VerificationMeta(
    'medicationTaken',
  );
  @override
  late final GeneratedColumn<String> medicationTaken = GeneratedColumn<String>(
    'medication_taken',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sleepHoursMeta = const VerificationMeta(
    'sleepHours',
  );
  @override
  late final GeneratedColumn<double> sleepHours = GeneratedColumn<double>(
    'sleep_hours',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stressEventsMeta = const VerificationMeta(
    'stressEvents',
  );
  @override
  late final GeneratedColumn<String> stressEvents = GeneratedColumn<String>(
    'stress_events',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceInfoMeta = const VerificationMeta(
    'deviceInfo',
  );
  @override
  late final GeneratedColumn<String> deviceInfo = GeneratedColumn<String>(
    'device_info',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rawDataUrlMeta = const VerificationMeta(
    'rawDataUrl',
  );
  @override
  late final GeneratedColumn<String> rawDataUrl = GeneratedColumn<String>(
    'raw_data_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    recordStartTime,
    recordDuration,
    avgHeartRate,
    maxHeartRate,
    minHeartRate,
    restingHeartRate,
    rmssd,
    pnn50,
    sdnn,
    stressIndex,
    zone1Time,
    zone2Time,
    zone3Time,
    zone4Time,
    zone5Time,
    activityType,
    bodyPosition,
    breathingPattern,
    caffeineIntake,
    alcoholIntake,
    medicationTaken,
    sleepHours,
    stressEvents,
    deviceInfo,
    rawDataUrl,
    notes,
    tags,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'heart_rate_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<HeartRateRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('record_start_time')) {
      context.handle(
        _recordStartTimeMeta,
        recordStartTime.isAcceptableOrUnknown(
          data['record_start_time']!,
          _recordStartTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recordStartTimeMeta);
    }
    if (data.containsKey('record_duration')) {
      context.handle(
        _recordDurationMeta,
        recordDuration.isAcceptableOrUnknown(
          data['record_duration']!,
          _recordDurationMeta,
        ),
      );
    }
    if (data.containsKey('avg_heart_rate')) {
      context.handle(
        _avgHeartRateMeta,
        avgHeartRate.isAcceptableOrUnknown(
          data['avg_heart_rate']!,
          _avgHeartRateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_avgHeartRateMeta);
    }
    if (data.containsKey('max_heart_rate')) {
      context.handle(
        _maxHeartRateMeta,
        maxHeartRate.isAcceptableOrUnknown(
          data['max_heart_rate']!,
          _maxHeartRateMeta,
        ),
      );
    }
    if (data.containsKey('min_heart_rate')) {
      context.handle(
        _minHeartRateMeta,
        minHeartRate.isAcceptableOrUnknown(
          data['min_heart_rate']!,
          _minHeartRateMeta,
        ),
      );
    }
    if (data.containsKey('resting_heart_rate')) {
      context.handle(
        _restingHeartRateMeta,
        restingHeartRate.isAcceptableOrUnknown(
          data['resting_heart_rate']!,
          _restingHeartRateMeta,
        ),
      );
    }
    if (data.containsKey('rmssd')) {
      context.handle(
        _rmssdMeta,
        rmssd.isAcceptableOrUnknown(data['rmssd']!, _rmssdMeta),
      );
    }
    if (data.containsKey('pnn50')) {
      context.handle(
        _pnn50Meta,
        pnn50.isAcceptableOrUnknown(data['pnn50']!, _pnn50Meta),
      );
    }
    if (data.containsKey('sdnn')) {
      context.handle(
        _sdnnMeta,
        sdnn.isAcceptableOrUnknown(data['sdnn']!, _sdnnMeta),
      );
    }
    if (data.containsKey('stress_index')) {
      context.handle(
        _stressIndexMeta,
        stressIndex.isAcceptableOrUnknown(
          data['stress_index']!,
          _stressIndexMeta,
        ),
      );
    }
    if (data.containsKey('zone1_time')) {
      context.handle(
        _zone1TimeMeta,
        zone1Time.isAcceptableOrUnknown(data['zone1_time']!, _zone1TimeMeta),
      );
    }
    if (data.containsKey('zone2_time')) {
      context.handle(
        _zone2TimeMeta,
        zone2Time.isAcceptableOrUnknown(data['zone2_time']!, _zone2TimeMeta),
      );
    }
    if (data.containsKey('zone3_time')) {
      context.handle(
        _zone3TimeMeta,
        zone3Time.isAcceptableOrUnknown(data['zone3_time']!, _zone3TimeMeta),
      );
    }
    if (data.containsKey('zone4_time')) {
      context.handle(
        _zone4TimeMeta,
        zone4Time.isAcceptableOrUnknown(data['zone4_time']!, _zone4TimeMeta),
      );
    }
    if (data.containsKey('zone5_time')) {
      context.handle(
        _zone5TimeMeta,
        zone5Time.isAcceptableOrUnknown(data['zone5_time']!, _zone5TimeMeta),
      );
    }
    if (data.containsKey('activity_type')) {
      context.handle(
        _activityTypeMeta,
        activityType.isAcceptableOrUnknown(
          data['activity_type']!,
          _activityTypeMeta,
        ),
      );
    }
    if (data.containsKey('body_position')) {
      context.handle(
        _bodyPositionMeta,
        bodyPosition.isAcceptableOrUnknown(
          data['body_position']!,
          _bodyPositionMeta,
        ),
      );
    }
    if (data.containsKey('breathing_pattern')) {
      context.handle(
        _breathingPatternMeta,
        breathingPattern.isAcceptableOrUnknown(
          data['breathing_pattern']!,
          _breathingPatternMeta,
        ),
      );
    }
    if (data.containsKey('caffeine_intake')) {
      context.handle(
        _caffeineIntakeMeta,
        caffeineIntake.isAcceptableOrUnknown(
          data['caffeine_intake']!,
          _caffeineIntakeMeta,
        ),
      );
    }
    if (data.containsKey('alcohol_intake')) {
      context.handle(
        _alcoholIntakeMeta,
        alcoholIntake.isAcceptableOrUnknown(
          data['alcohol_intake']!,
          _alcoholIntakeMeta,
        ),
      );
    }
    if (data.containsKey('medication_taken')) {
      context.handle(
        _medicationTakenMeta,
        medicationTaken.isAcceptableOrUnknown(
          data['medication_taken']!,
          _medicationTakenMeta,
        ),
      );
    }
    if (data.containsKey('sleep_hours')) {
      context.handle(
        _sleepHoursMeta,
        sleepHours.isAcceptableOrUnknown(data['sleep_hours']!, _sleepHoursMeta),
      );
    }
    if (data.containsKey('stress_events')) {
      context.handle(
        _stressEventsMeta,
        stressEvents.isAcceptableOrUnknown(
          data['stress_events']!,
          _stressEventsMeta,
        ),
      );
    }
    if (data.containsKey('device_info')) {
      context.handle(
        _deviceInfoMeta,
        deviceInfo.isAcceptableOrUnknown(data['device_info']!, _deviceInfoMeta),
      );
    }
    if (data.containsKey('raw_data_url')) {
      context.handle(
        _rawDataUrlMeta,
        rawDataUrl.isAcceptableOrUnknown(
          data['raw_data_url']!,
          _rawDataUrlMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HeartRateRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HeartRateRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      recordStartTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}record_start_time'],
      )!,
      recordDuration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}record_duration'],
      ),
      avgHeartRate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}avg_heart_rate'],
      )!,
      maxHeartRate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_heart_rate'],
      ),
      minHeartRate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}min_heart_rate'],
      ),
      restingHeartRate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}resting_heart_rate'],
      ),
      rmssd: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rmssd'],
      ),
      pnn50: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}pnn50'],
      ),
      sdnn: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sdnn'],
      ),
      stressIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}stress_index'],
      ),
      zone1Time: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}zone1_time'],
      ),
      zone2Time: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}zone2_time'],
      ),
      zone3Time: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}zone3_time'],
      ),
      zone4Time: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}zone4_time'],
      ),
      zone5Time: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}zone5_time'],
      ),
      activityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_type'],
      ),
      bodyPosition: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body_position'],
      ),
      breathingPattern: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}breathing_pattern'],
      ),
      caffeineIntake: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}caffeine_intake'],
      )!,
      alcoholIntake: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}alcohol_intake'],
      )!,
      medicationTaken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}medication_taken'],
      ),
      sleepHours: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sleep_hours'],
      ),
      stressEvents: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stress_events'],
      ),
      deviceInfo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_info'],
      ),
      rawDataUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_data_url'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $HeartRateRecordsTable createAlias(String alias) {
    return $HeartRateRecordsTable(attachedDatabase, alias);
  }
}

class HeartRateRecord extends DataClass implements Insertable<HeartRateRecord> {
  final int id;
  final String userId;
  final DateTime recordStartTime;
  final int? recordDuration;
  final int avgHeartRate;
  final int? maxHeartRate;
  final int? minHeartRate;
  final int? restingHeartRate;
  final double? rmssd;
  final double? pnn50;
  final double? sdnn;
  final double? stressIndex;
  final int? zone1Time;
  final int? zone2Time;
  final int? zone3Time;
  final int? zone4Time;
  final int? zone5Time;
  final String? activityType;
  final String? bodyPosition;
  final String? breathingPattern;
  final bool caffeineIntake;
  final bool alcoholIntake;
  final String? medicationTaken;
  final double? sleepHours;
  final String? stressEvents;
  final String? deviceInfo;
  final String? rawDataUrl;
  final String? notes;
  final String? tags;
  final DateTime createdAt;
  const HeartRateRecord({
    required this.id,
    required this.userId,
    required this.recordStartTime,
    this.recordDuration,
    required this.avgHeartRate,
    this.maxHeartRate,
    this.minHeartRate,
    this.restingHeartRate,
    this.rmssd,
    this.pnn50,
    this.sdnn,
    this.stressIndex,
    this.zone1Time,
    this.zone2Time,
    this.zone3Time,
    this.zone4Time,
    this.zone5Time,
    this.activityType,
    this.bodyPosition,
    this.breathingPattern,
    required this.caffeineIntake,
    required this.alcoholIntake,
    this.medicationTaken,
    this.sleepHours,
    this.stressEvents,
    this.deviceInfo,
    this.rawDataUrl,
    this.notes,
    this.tags,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<String>(userId);
    map['record_start_time'] = Variable<DateTime>(recordStartTime);
    if (!nullToAbsent || recordDuration != null) {
      map['record_duration'] = Variable<int>(recordDuration);
    }
    map['avg_heart_rate'] = Variable<int>(avgHeartRate);
    if (!nullToAbsent || maxHeartRate != null) {
      map['max_heart_rate'] = Variable<int>(maxHeartRate);
    }
    if (!nullToAbsent || minHeartRate != null) {
      map['min_heart_rate'] = Variable<int>(minHeartRate);
    }
    if (!nullToAbsent || restingHeartRate != null) {
      map['resting_heart_rate'] = Variable<int>(restingHeartRate);
    }
    if (!nullToAbsent || rmssd != null) {
      map['rmssd'] = Variable<double>(rmssd);
    }
    if (!nullToAbsent || pnn50 != null) {
      map['pnn50'] = Variable<double>(pnn50);
    }
    if (!nullToAbsent || sdnn != null) {
      map['sdnn'] = Variable<double>(sdnn);
    }
    if (!nullToAbsent || stressIndex != null) {
      map['stress_index'] = Variable<double>(stressIndex);
    }
    if (!nullToAbsent || zone1Time != null) {
      map['zone1_time'] = Variable<int>(zone1Time);
    }
    if (!nullToAbsent || zone2Time != null) {
      map['zone2_time'] = Variable<int>(zone2Time);
    }
    if (!nullToAbsent || zone3Time != null) {
      map['zone3_time'] = Variable<int>(zone3Time);
    }
    if (!nullToAbsent || zone4Time != null) {
      map['zone4_time'] = Variable<int>(zone4Time);
    }
    if (!nullToAbsent || zone5Time != null) {
      map['zone5_time'] = Variable<int>(zone5Time);
    }
    if (!nullToAbsent || activityType != null) {
      map['activity_type'] = Variable<String>(activityType);
    }
    if (!nullToAbsent || bodyPosition != null) {
      map['body_position'] = Variable<String>(bodyPosition);
    }
    if (!nullToAbsent || breathingPattern != null) {
      map['breathing_pattern'] = Variable<String>(breathingPattern);
    }
    map['caffeine_intake'] = Variable<bool>(caffeineIntake);
    map['alcohol_intake'] = Variable<bool>(alcoholIntake);
    if (!nullToAbsent || medicationTaken != null) {
      map['medication_taken'] = Variable<String>(medicationTaken);
    }
    if (!nullToAbsent || sleepHours != null) {
      map['sleep_hours'] = Variable<double>(sleepHours);
    }
    if (!nullToAbsent || stressEvents != null) {
      map['stress_events'] = Variable<String>(stressEvents);
    }
    if (!nullToAbsent || deviceInfo != null) {
      map['device_info'] = Variable<String>(deviceInfo);
    }
    if (!nullToAbsent || rawDataUrl != null) {
      map['raw_data_url'] = Variable<String>(rawDataUrl);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || tags != null) {
      map['tags'] = Variable<String>(tags);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  HeartRateRecordsCompanion toCompanion(bool nullToAbsent) {
    return HeartRateRecordsCompanion(
      id: Value(id),
      userId: Value(userId),
      recordStartTime: Value(recordStartTime),
      recordDuration: recordDuration == null && nullToAbsent
          ? const Value.absent()
          : Value(recordDuration),
      avgHeartRate: Value(avgHeartRate),
      maxHeartRate: maxHeartRate == null && nullToAbsent
          ? const Value.absent()
          : Value(maxHeartRate),
      minHeartRate: minHeartRate == null && nullToAbsent
          ? const Value.absent()
          : Value(minHeartRate),
      restingHeartRate: restingHeartRate == null && nullToAbsent
          ? const Value.absent()
          : Value(restingHeartRate),
      rmssd: rmssd == null && nullToAbsent
          ? const Value.absent()
          : Value(rmssd),
      pnn50: pnn50 == null && nullToAbsent
          ? const Value.absent()
          : Value(pnn50),
      sdnn: sdnn == null && nullToAbsent ? const Value.absent() : Value(sdnn),
      stressIndex: stressIndex == null && nullToAbsent
          ? const Value.absent()
          : Value(stressIndex),
      zone1Time: zone1Time == null && nullToAbsent
          ? const Value.absent()
          : Value(zone1Time),
      zone2Time: zone2Time == null && nullToAbsent
          ? const Value.absent()
          : Value(zone2Time),
      zone3Time: zone3Time == null && nullToAbsent
          ? const Value.absent()
          : Value(zone3Time),
      zone4Time: zone4Time == null && nullToAbsent
          ? const Value.absent()
          : Value(zone4Time),
      zone5Time: zone5Time == null && nullToAbsent
          ? const Value.absent()
          : Value(zone5Time),
      activityType: activityType == null && nullToAbsent
          ? const Value.absent()
          : Value(activityType),
      bodyPosition: bodyPosition == null && nullToAbsent
          ? const Value.absent()
          : Value(bodyPosition),
      breathingPattern: breathingPattern == null && nullToAbsent
          ? const Value.absent()
          : Value(breathingPattern),
      caffeineIntake: Value(caffeineIntake),
      alcoholIntake: Value(alcoholIntake),
      medicationTaken: medicationTaken == null && nullToAbsent
          ? const Value.absent()
          : Value(medicationTaken),
      sleepHours: sleepHours == null && nullToAbsent
          ? const Value.absent()
          : Value(sleepHours),
      stressEvents: stressEvents == null && nullToAbsent
          ? const Value.absent()
          : Value(stressEvents),
      deviceInfo: deviceInfo == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceInfo),
      rawDataUrl: rawDataUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(rawDataUrl),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      tags: tags == null && nullToAbsent ? const Value.absent() : Value(tags),
      createdAt: Value(createdAt),
    );
  }

  factory HeartRateRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HeartRateRecord(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      recordStartTime: serializer.fromJson<DateTime>(json['recordStartTime']),
      recordDuration: serializer.fromJson<int?>(json['recordDuration']),
      avgHeartRate: serializer.fromJson<int>(json['avgHeartRate']),
      maxHeartRate: serializer.fromJson<int?>(json['maxHeartRate']),
      minHeartRate: serializer.fromJson<int?>(json['minHeartRate']),
      restingHeartRate: serializer.fromJson<int?>(json['restingHeartRate']),
      rmssd: serializer.fromJson<double?>(json['rmssd']),
      pnn50: serializer.fromJson<double?>(json['pnn50']),
      sdnn: serializer.fromJson<double?>(json['sdnn']),
      stressIndex: serializer.fromJson<double?>(json['stressIndex']),
      zone1Time: serializer.fromJson<int?>(json['zone1Time']),
      zone2Time: serializer.fromJson<int?>(json['zone2Time']),
      zone3Time: serializer.fromJson<int?>(json['zone3Time']),
      zone4Time: serializer.fromJson<int?>(json['zone4Time']),
      zone5Time: serializer.fromJson<int?>(json['zone5Time']),
      activityType: serializer.fromJson<String?>(json['activityType']),
      bodyPosition: serializer.fromJson<String?>(json['bodyPosition']),
      breathingPattern: serializer.fromJson<String?>(json['breathingPattern']),
      caffeineIntake: serializer.fromJson<bool>(json['caffeineIntake']),
      alcoholIntake: serializer.fromJson<bool>(json['alcoholIntake']),
      medicationTaken: serializer.fromJson<String?>(json['medicationTaken']),
      sleepHours: serializer.fromJson<double?>(json['sleepHours']),
      stressEvents: serializer.fromJson<String?>(json['stressEvents']),
      deviceInfo: serializer.fromJson<String?>(json['deviceInfo']),
      rawDataUrl: serializer.fromJson<String?>(json['rawDataUrl']),
      notes: serializer.fromJson<String?>(json['notes']),
      tags: serializer.fromJson<String?>(json['tags']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<String>(userId),
      'recordStartTime': serializer.toJson<DateTime>(recordStartTime),
      'recordDuration': serializer.toJson<int?>(recordDuration),
      'avgHeartRate': serializer.toJson<int>(avgHeartRate),
      'maxHeartRate': serializer.toJson<int?>(maxHeartRate),
      'minHeartRate': serializer.toJson<int?>(minHeartRate),
      'restingHeartRate': serializer.toJson<int?>(restingHeartRate),
      'rmssd': serializer.toJson<double?>(rmssd),
      'pnn50': serializer.toJson<double?>(pnn50),
      'sdnn': serializer.toJson<double?>(sdnn),
      'stressIndex': serializer.toJson<double?>(stressIndex),
      'zone1Time': serializer.toJson<int?>(zone1Time),
      'zone2Time': serializer.toJson<int?>(zone2Time),
      'zone3Time': serializer.toJson<int?>(zone3Time),
      'zone4Time': serializer.toJson<int?>(zone4Time),
      'zone5Time': serializer.toJson<int?>(zone5Time),
      'activityType': serializer.toJson<String?>(activityType),
      'bodyPosition': serializer.toJson<String?>(bodyPosition),
      'breathingPattern': serializer.toJson<String?>(breathingPattern),
      'caffeineIntake': serializer.toJson<bool>(caffeineIntake),
      'alcoholIntake': serializer.toJson<bool>(alcoholIntake),
      'medicationTaken': serializer.toJson<String?>(medicationTaken),
      'sleepHours': serializer.toJson<double?>(sleepHours),
      'stressEvents': serializer.toJson<String?>(stressEvents),
      'deviceInfo': serializer.toJson<String?>(deviceInfo),
      'rawDataUrl': serializer.toJson<String?>(rawDataUrl),
      'notes': serializer.toJson<String?>(notes),
      'tags': serializer.toJson<String?>(tags),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  HeartRateRecord copyWith({
    int? id,
    String? userId,
    DateTime? recordStartTime,
    Value<int?> recordDuration = const Value.absent(),
    int? avgHeartRate,
    Value<int?> maxHeartRate = const Value.absent(),
    Value<int?> minHeartRate = const Value.absent(),
    Value<int?> restingHeartRate = const Value.absent(),
    Value<double?> rmssd = const Value.absent(),
    Value<double?> pnn50 = const Value.absent(),
    Value<double?> sdnn = const Value.absent(),
    Value<double?> stressIndex = const Value.absent(),
    Value<int?> zone1Time = const Value.absent(),
    Value<int?> zone2Time = const Value.absent(),
    Value<int?> zone3Time = const Value.absent(),
    Value<int?> zone4Time = const Value.absent(),
    Value<int?> zone5Time = const Value.absent(),
    Value<String?> activityType = const Value.absent(),
    Value<String?> bodyPosition = const Value.absent(),
    Value<String?> breathingPattern = const Value.absent(),
    bool? caffeineIntake,
    bool? alcoholIntake,
    Value<String?> medicationTaken = const Value.absent(),
    Value<double?> sleepHours = const Value.absent(),
    Value<String?> stressEvents = const Value.absent(),
    Value<String?> deviceInfo = const Value.absent(),
    Value<String?> rawDataUrl = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> tags = const Value.absent(),
    DateTime? createdAt,
  }) => HeartRateRecord(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    recordStartTime: recordStartTime ?? this.recordStartTime,
    recordDuration: recordDuration.present
        ? recordDuration.value
        : this.recordDuration,
    avgHeartRate: avgHeartRate ?? this.avgHeartRate,
    maxHeartRate: maxHeartRate.present ? maxHeartRate.value : this.maxHeartRate,
    minHeartRate: minHeartRate.present ? minHeartRate.value : this.minHeartRate,
    restingHeartRate: restingHeartRate.present
        ? restingHeartRate.value
        : this.restingHeartRate,
    rmssd: rmssd.present ? rmssd.value : this.rmssd,
    pnn50: pnn50.present ? pnn50.value : this.pnn50,
    sdnn: sdnn.present ? sdnn.value : this.sdnn,
    stressIndex: stressIndex.present ? stressIndex.value : this.stressIndex,
    zone1Time: zone1Time.present ? zone1Time.value : this.zone1Time,
    zone2Time: zone2Time.present ? zone2Time.value : this.zone2Time,
    zone3Time: zone3Time.present ? zone3Time.value : this.zone3Time,
    zone4Time: zone4Time.present ? zone4Time.value : this.zone4Time,
    zone5Time: zone5Time.present ? zone5Time.value : this.zone5Time,
    activityType: activityType.present ? activityType.value : this.activityType,
    bodyPosition: bodyPosition.present ? bodyPosition.value : this.bodyPosition,
    breathingPattern: breathingPattern.present
        ? breathingPattern.value
        : this.breathingPattern,
    caffeineIntake: caffeineIntake ?? this.caffeineIntake,
    alcoholIntake: alcoholIntake ?? this.alcoholIntake,
    medicationTaken: medicationTaken.present
        ? medicationTaken.value
        : this.medicationTaken,
    sleepHours: sleepHours.present ? sleepHours.value : this.sleepHours,
    stressEvents: stressEvents.present ? stressEvents.value : this.stressEvents,
    deviceInfo: deviceInfo.present ? deviceInfo.value : this.deviceInfo,
    rawDataUrl: rawDataUrl.present ? rawDataUrl.value : this.rawDataUrl,
    notes: notes.present ? notes.value : this.notes,
    tags: tags.present ? tags.value : this.tags,
    createdAt: createdAt ?? this.createdAt,
  );
  HeartRateRecord copyWithCompanion(HeartRateRecordsCompanion data) {
    return HeartRateRecord(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      recordStartTime: data.recordStartTime.present
          ? data.recordStartTime.value
          : this.recordStartTime,
      recordDuration: data.recordDuration.present
          ? data.recordDuration.value
          : this.recordDuration,
      avgHeartRate: data.avgHeartRate.present
          ? data.avgHeartRate.value
          : this.avgHeartRate,
      maxHeartRate: data.maxHeartRate.present
          ? data.maxHeartRate.value
          : this.maxHeartRate,
      minHeartRate: data.minHeartRate.present
          ? data.minHeartRate.value
          : this.minHeartRate,
      restingHeartRate: data.restingHeartRate.present
          ? data.restingHeartRate.value
          : this.restingHeartRate,
      rmssd: data.rmssd.present ? data.rmssd.value : this.rmssd,
      pnn50: data.pnn50.present ? data.pnn50.value : this.pnn50,
      sdnn: data.sdnn.present ? data.sdnn.value : this.sdnn,
      stressIndex: data.stressIndex.present
          ? data.stressIndex.value
          : this.stressIndex,
      zone1Time: data.zone1Time.present ? data.zone1Time.value : this.zone1Time,
      zone2Time: data.zone2Time.present ? data.zone2Time.value : this.zone2Time,
      zone3Time: data.zone3Time.present ? data.zone3Time.value : this.zone3Time,
      zone4Time: data.zone4Time.present ? data.zone4Time.value : this.zone4Time,
      zone5Time: data.zone5Time.present ? data.zone5Time.value : this.zone5Time,
      activityType: data.activityType.present
          ? data.activityType.value
          : this.activityType,
      bodyPosition: data.bodyPosition.present
          ? data.bodyPosition.value
          : this.bodyPosition,
      breathingPattern: data.breathingPattern.present
          ? data.breathingPattern.value
          : this.breathingPattern,
      caffeineIntake: data.caffeineIntake.present
          ? data.caffeineIntake.value
          : this.caffeineIntake,
      alcoholIntake: data.alcoholIntake.present
          ? data.alcoholIntake.value
          : this.alcoholIntake,
      medicationTaken: data.medicationTaken.present
          ? data.medicationTaken.value
          : this.medicationTaken,
      sleepHours: data.sleepHours.present
          ? data.sleepHours.value
          : this.sleepHours,
      stressEvents: data.stressEvents.present
          ? data.stressEvents.value
          : this.stressEvents,
      deviceInfo: data.deviceInfo.present
          ? data.deviceInfo.value
          : this.deviceInfo,
      rawDataUrl: data.rawDataUrl.present
          ? data.rawDataUrl.value
          : this.rawDataUrl,
      notes: data.notes.present ? data.notes.value : this.notes,
      tags: data.tags.present ? data.tags.value : this.tags,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HeartRateRecord(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('recordStartTime: $recordStartTime, ')
          ..write('recordDuration: $recordDuration, ')
          ..write('avgHeartRate: $avgHeartRate, ')
          ..write('maxHeartRate: $maxHeartRate, ')
          ..write('minHeartRate: $minHeartRate, ')
          ..write('restingHeartRate: $restingHeartRate, ')
          ..write('rmssd: $rmssd, ')
          ..write('pnn50: $pnn50, ')
          ..write('sdnn: $sdnn, ')
          ..write('stressIndex: $stressIndex, ')
          ..write('zone1Time: $zone1Time, ')
          ..write('zone2Time: $zone2Time, ')
          ..write('zone3Time: $zone3Time, ')
          ..write('zone4Time: $zone4Time, ')
          ..write('zone5Time: $zone5Time, ')
          ..write('activityType: $activityType, ')
          ..write('bodyPosition: $bodyPosition, ')
          ..write('breathingPattern: $breathingPattern, ')
          ..write('caffeineIntake: $caffeineIntake, ')
          ..write('alcoholIntake: $alcoholIntake, ')
          ..write('medicationTaken: $medicationTaken, ')
          ..write('sleepHours: $sleepHours, ')
          ..write('stressEvents: $stressEvents, ')
          ..write('deviceInfo: $deviceInfo, ')
          ..write('rawDataUrl: $rawDataUrl, ')
          ..write('notes: $notes, ')
          ..write('tags: $tags, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    userId,
    recordStartTime,
    recordDuration,
    avgHeartRate,
    maxHeartRate,
    minHeartRate,
    restingHeartRate,
    rmssd,
    pnn50,
    sdnn,
    stressIndex,
    zone1Time,
    zone2Time,
    zone3Time,
    zone4Time,
    zone5Time,
    activityType,
    bodyPosition,
    breathingPattern,
    caffeineIntake,
    alcoholIntake,
    medicationTaken,
    sleepHours,
    stressEvents,
    deviceInfo,
    rawDataUrl,
    notes,
    tags,
    createdAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HeartRateRecord &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.recordStartTime == this.recordStartTime &&
          other.recordDuration == this.recordDuration &&
          other.avgHeartRate == this.avgHeartRate &&
          other.maxHeartRate == this.maxHeartRate &&
          other.minHeartRate == this.minHeartRate &&
          other.restingHeartRate == this.restingHeartRate &&
          other.rmssd == this.rmssd &&
          other.pnn50 == this.pnn50 &&
          other.sdnn == this.sdnn &&
          other.stressIndex == this.stressIndex &&
          other.zone1Time == this.zone1Time &&
          other.zone2Time == this.zone2Time &&
          other.zone3Time == this.zone3Time &&
          other.zone4Time == this.zone4Time &&
          other.zone5Time == this.zone5Time &&
          other.activityType == this.activityType &&
          other.bodyPosition == this.bodyPosition &&
          other.breathingPattern == this.breathingPattern &&
          other.caffeineIntake == this.caffeineIntake &&
          other.alcoholIntake == this.alcoholIntake &&
          other.medicationTaken == this.medicationTaken &&
          other.sleepHours == this.sleepHours &&
          other.stressEvents == this.stressEvents &&
          other.deviceInfo == this.deviceInfo &&
          other.rawDataUrl == this.rawDataUrl &&
          other.notes == this.notes &&
          other.tags == this.tags &&
          other.createdAt == this.createdAt);
}

class HeartRateRecordsCompanion extends UpdateCompanion<HeartRateRecord> {
  final Value<int> id;
  final Value<String> userId;
  final Value<DateTime> recordStartTime;
  final Value<int?> recordDuration;
  final Value<int> avgHeartRate;
  final Value<int?> maxHeartRate;
  final Value<int?> minHeartRate;
  final Value<int?> restingHeartRate;
  final Value<double?> rmssd;
  final Value<double?> pnn50;
  final Value<double?> sdnn;
  final Value<double?> stressIndex;
  final Value<int?> zone1Time;
  final Value<int?> zone2Time;
  final Value<int?> zone3Time;
  final Value<int?> zone4Time;
  final Value<int?> zone5Time;
  final Value<String?> activityType;
  final Value<String?> bodyPosition;
  final Value<String?> breathingPattern;
  final Value<bool> caffeineIntake;
  final Value<bool> alcoholIntake;
  final Value<String?> medicationTaken;
  final Value<double?> sleepHours;
  final Value<String?> stressEvents;
  final Value<String?> deviceInfo;
  final Value<String?> rawDataUrl;
  final Value<String?> notes;
  final Value<String?> tags;
  final Value<DateTime> createdAt;
  const HeartRateRecordsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.recordStartTime = const Value.absent(),
    this.recordDuration = const Value.absent(),
    this.avgHeartRate = const Value.absent(),
    this.maxHeartRate = const Value.absent(),
    this.minHeartRate = const Value.absent(),
    this.restingHeartRate = const Value.absent(),
    this.rmssd = const Value.absent(),
    this.pnn50 = const Value.absent(),
    this.sdnn = const Value.absent(),
    this.stressIndex = const Value.absent(),
    this.zone1Time = const Value.absent(),
    this.zone2Time = const Value.absent(),
    this.zone3Time = const Value.absent(),
    this.zone4Time = const Value.absent(),
    this.zone5Time = const Value.absent(),
    this.activityType = const Value.absent(),
    this.bodyPosition = const Value.absent(),
    this.breathingPattern = const Value.absent(),
    this.caffeineIntake = const Value.absent(),
    this.alcoholIntake = const Value.absent(),
    this.medicationTaken = const Value.absent(),
    this.sleepHours = const Value.absent(),
    this.stressEvents = const Value.absent(),
    this.deviceInfo = const Value.absent(),
    this.rawDataUrl = const Value.absent(),
    this.notes = const Value.absent(),
    this.tags = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  HeartRateRecordsCompanion.insert({
    this.id = const Value.absent(),
    required String userId,
    required DateTime recordStartTime,
    this.recordDuration = const Value.absent(),
    required int avgHeartRate,
    this.maxHeartRate = const Value.absent(),
    this.minHeartRate = const Value.absent(),
    this.restingHeartRate = const Value.absent(),
    this.rmssd = const Value.absent(),
    this.pnn50 = const Value.absent(),
    this.sdnn = const Value.absent(),
    this.stressIndex = const Value.absent(),
    this.zone1Time = const Value.absent(),
    this.zone2Time = const Value.absent(),
    this.zone3Time = const Value.absent(),
    this.zone4Time = const Value.absent(),
    this.zone5Time = const Value.absent(),
    this.activityType = const Value.absent(),
    this.bodyPosition = const Value.absent(),
    this.breathingPattern = const Value.absent(),
    this.caffeineIntake = const Value.absent(),
    this.alcoholIntake = const Value.absent(),
    this.medicationTaken = const Value.absent(),
    this.sleepHours = const Value.absent(),
    this.stressEvents = const Value.absent(),
    this.deviceInfo = const Value.absent(),
    this.rawDataUrl = const Value.absent(),
    this.notes = const Value.absent(),
    this.tags = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : userId = Value(userId),
       recordStartTime = Value(recordStartTime),
       avgHeartRate = Value(avgHeartRate);
  static Insertable<HeartRateRecord> custom({
    Expression<int>? id,
    Expression<String>? userId,
    Expression<DateTime>? recordStartTime,
    Expression<int>? recordDuration,
    Expression<int>? avgHeartRate,
    Expression<int>? maxHeartRate,
    Expression<int>? minHeartRate,
    Expression<int>? restingHeartRate,
    Expression<double>? rmssd,
    Expression<double>? pnn50,
    Expression<double>? sdnn,
    Expression<double>? stressIndex,
    Expression<int>? zone1Time,
    Expression<int>? zone2Time,
    Expression<int>? zone3Time,
    Expression<int>? zone4Time,
    Expression<int>? zone5Time,
    Expression<String>? activityType,
    Expression<String>? bodyPosition,
    Expression<String>? breathingPattern,
    Expression<bool>? caffeineIntake,
    Expression<bool>? alcoholIntake,
    Expression<String>? medicationTaken,
    Expression<double>? sleepHours,
    Expression<String>? stressEvents,
    Expression<String>? deviceInfo,
    Expression<String>? rawDataUrl,
    Expression<String>? notes,
    Expression<String>? tags,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (recordStartTime != null) 'record_start_time': recordStartTime,
      if (recordDuration != null) 'record_duration': recordDuration,
      if (avgHeartRate != null) 'avg_heart_rate': avgHeartRate,
      if (maxHeartRate != null) 'max_heart_rate': maxHeartRate,
      if (minHeartRate != null) 'min_heart_rate': minHeartRate,
      if (restingHeartRate != null) 'resting_heart_rate': restingHeartRate,
      if (rmssd != null) 'rmssd': rmssd,
      if (pnn50 != null) 'pnn50': pnn50,
      if (sdnn != null) 'sdnn': sdnn,
      if (stressIndex != null) 'stress_index': stressIndex,
      if (zone1Time != null) 'zone1_time': zone1Time,
      if (zone2Time != null) 'zone2_time': zone2Time,
      if (zone3Time != null) 'zone3_time': zone3Time,
      if (zone4Time != null) 'zone4_time': zone4Time,
      if (zone5Time != null) 'zone5_time': zone5Time,
      if (activityType != null) 'activity_type': activityType,
      if (bodyPosition != null) 'body_position': bodyPosition,
      if (breathingPattern != null) 'breathing_pattern': breathingPattern,
      if (caffeineIntake != null) 'caffeine_intake': caffeineIntake,
      if (alcoholIntake != null) 'alcohol_intake': alcoholIntake,
      if (medicationTaken != null) 'medication_taken': medicationTaken,
      if (sleepHours != null) 'sleep_hours': sleepHours,
      if (stressEvents != null) 'stress_events': stressEvents,
      if (deviceInfo != null) 'device_info': deviceInfo,
      if (rawDataUrl != null) 'raw_data_url': rawDataUrl,
      if (notes != null) 'notes': notes,
      if (tags != null) 'tags': tags,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  HeartRateRecordsCompanion copyWith({
    Value<int>? id,
    Value<String>? userId,
    Value<DateTime>? recordStartTime,
    Value<int?>? recordDuration,
    Value<int>? avgHeartRate,
    Value<int?>? maxHeartRate,
    Value<int?>? minHeartRate,
    Value<int?>? restingHeartRate,
    Value<double?>? rmssd,
    Value<double?>? pnn50,
    Value<double?>? sdnn,
    Value<double?>? stressIndex,
    Value<int?>? zone1Time,
    Value<int?>? zone2Time,
    Value<int?>? zone3Time,
    Value<int?>? zone4Time,
    Value<int?>? zone5Time,
    Value<String?>? activityType,
    Value<String?>? bodyPosition,
    Value<String?>? breathingPattern,
    Value<bool>? caffeineIntake,
    Value<bool>? alcoholIntake,
    Value<String?>? medicationTaken,
    Value<double?>? sleepHours,
    Value<String?>? stressEvents,
    Value<String?>? deviceInfo,
    Value<String?>? rawDataUrl,
    Value<String?>? notes,
    Value<String?>? tags,
    Value<DateTime>? createdAt,
  }) {
    return HeartRateRecordsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      recordStartTime: recordStartTime ?? this.recordStartTime,
      recordDuration: recordDuration ?? this.recordDuration,
      avgHeartRate: avgHeartRate ?? this.avgHeartRate,
      maxHeartRate: maxHeartRate ?? this.maxHeartRate,
      minHeartRate: minHeartRate ?? this.minHeartRate,
      restingHeartRate: restingHeartRate ?? this.restingHeartRate,
      rmssd: rmssd ?? this.rmssd,
      pnn50: pnn50 ?? this.pnn50,
      sdnn: sdnn ?? this.sdnn,
      stressIndex: stressIndex ?? this.stressIndex,
      zone1Time: zone1Time ?? this.zone1Time,
      zone2Time: zone2Time ?? this.zone2Time,
      zone3Time: zone3Time ?? this.zone3Time,
      zone4Time: zone4Time ?? this.zone4Time,
      zone5Time: zone5Time ?? this.zone5Time,
      activityType: activityType ?? this.activityType,
      bodyPosition: bodyPosition ?? this.bodyPosition,
      breathingPattern: breathingPattern ?? this.breathingPattern,
      caffeineIntake: caffeineIntake ?? this.caffeineIntake,
      alcoholIntake: alcoholIntake ?? this.alcoholIntake,
      medicationTaken: medicationTaken ?? this.medicationTaken,
      sleepHours: sleepHours ?? this.sleepHours,
      stressEvents: stressEvents ?? this.stressEvents,
      deviceInfo: deviceInfo ?? this.deviceInfo,
      rawDataUrl: rawDataUrl ?? this.rawDataUrl,
      notes: notes ?? this.notes,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (recordStartTime.present) {
      map['record_start_time'] = Variable<DateTime>(recordStartTime.value);
    }
    if (recordDuration.present) {
      map['record_duration'] = Variable<int>(recordDuration.value);
    }
    if (avgHeartRate.present) {
      map['avg_heart_rate'] = Variable<int>(avgHeartRate.value);
    }
    if (maxHeartRate.present) {
      map['max_heart_rate'] = Variable<int>(maxHeartRate.value);
    }
    if (minHeartRate.present) {
      map['min_heart_rate'] = Variable<int>(minHeartRate.value);
    }
    if (restingHeartRate.present) {
      map['resting_heart_rate'] = Variable<int>(restingHeartRate.value);
    }
    if (rmssd.present) {
      map['rmssd'] = Variable<double>(rmssd.value);
    }
    if (pnn50.present) {
      map['pnn50'] = Variable<double>(pnn50.value);
    }
    if (sdnn.present) {
      map['sdnn'] = Variable<double>(sdnn.value);
    }
    if (stressIndex.present) {
      map['stress_index'] = Variable<double>(stressIndex.value);
    }
    if (zone1Time.present) {
      map['zone1_time'] = Variable<int>(zone1Time.value);
    }
    if (zone2Time.present) {
      map['zone2_time'] = Variable<int>(zone2Time.value);
    }
    if (zone3Time.present) {
      map['zone3_time'] = Variable<int>(zone3Time.value);
    }
    if (zone4Time.present) {
      map['zone4_time'] = Variable<int>(zone4Time.value);
    }
    if (zone5Time.present) {
      map['zone5_time'] = Variable<int>(zone5Time.value);
    }
    if (activityType.present) {
      map['activity_type'] = Variable<String>(activityType.value);
    }
    if (bodyPosition.present) {
      map['body_position'] = Variable<String>(bodyPosition.value);
    }
    if (breathingPattern.present) {
      map['breathing_pattern'] = Variable<String>(breathingPattern.value);
    }
    if (caffeineIntake.present) {
      map['caffeine_intake'] = Variable<bool>(caffeineIntake.value);
    }
    if (alcoholIntake.present) {
      map['alcohol_intake'] = Variable<bool>(alcoholIntake.value);
    }
    if (medicationTaken.present) {
      map['medication_taken'] = Variable<String>(medicationTaken.value);
    }
    if (sleepHours.present) {
      map['sleep_hours'] = Variable<double>(sleepHours.value);
    }
    if (stressEvents.present) {
      map['stress_events'] = Variable<String>(stressEvents.value);
    }
    if (deviceInfo.present) {
      map['device_info'] = Variable<String>(deviceInfo.value);
    }
    if (rawDataUrl.present) {
      map['raw_data_url'] = Variable<String>(rawDataUrl.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HeartRateRecordsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('recordStartTime: $recordStartTime, ')
          ..write('recordDuration: $recordDuration, ')
          ..write('avgHeartRate: $avgHeartRate, ')
          ..write('maxHeartRate: $maxHeartRate, ')
          ..write('minHeartRate: $minHeartRate, ')
          ..write('restingHeartRate: $restingHeartRate, ')
          ..write('rmssd: $rmssd, ')
          ..write('pnn50: $pnn50, ')
          ..write('sdnn: $sdnn, ')
          ..write('stressIndex: $stressIndex, ')
          ..write('zone1Time: $zone1Time, ')
          ..write('zone2Time: $zone2Time, ')
          ..write('zone3Time: $zone3Time, ')
          ..write('zone4Time: $zone4Time, ')
          ..write('zone5Time: $zone5Time, ')
          ..write('activityType: $activityType, ')
          ..write('bodyPosition: $bodyPosition, ')
          ..write('breathingPattern: $breathingPattern, ')
          ..write('caffeineIntake: $caffeineIntake, ')
          ..write('alcoholIntake: $alcoholIntake, ')
          ..write('medicationTaken: $medicationTaken, ')
          ..write('sleepHours: $sleepHours, ')
          ..write('stressEvents: $stressEvents, ')
          ..write('deviceInfo: $deviceInfo, ')
          ..write('rawDataUrl: $rawDataUrl, ')
          ..write('notes: $notes, ')
          ..write('tags: $tags, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $BloodGlucoseRecordsTable extends BloodGlucoseRecords
    with TableInfo<$BloodGlucoseRecordsTable, BloodGlucoseRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BloodGlucoseRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordDatetimeMeta = const VerificationMeta(
    'recordDatetime',
  );
  @override
  late final GeneratedColumn<DateTime> recordDatetime =
      GeneratedColumn<DateTime>(
        'record_datetime',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _glucoseValueMeta = const VerificationMeta(
    'glucoseValue',
  );
  @override
  late final GeneratedColumn<double> glucoseValue = GeneratedColumn<double>(
    'glucose_value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _glucoseUnitMeta = const VerificationMeta(
    'glucoseUnit',
  );
  @override
  late final GeneratedColumn<String> glucoseUnit = GeneratedColumn<String>(
    'glucose_unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('mmol/L'),
  );
  static const VerificationMeta _measurementTimingMeta = const VerificationMeta(
    'measurementTiming',
  );
  @override
  late final GeneratedColumn<String> measurementTiming =
      GeneratedColumn<String>(
        'measurement_timing',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _fastingHoursMeta = const VerificationMeta(
    'fastingHours',
  );
  @override
  late final GeneratedColumn<double> fastingHours = GeneratedColumn<double>(
    'fasting_hours',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mealRelationshipMeta = const VerificationMeta(
    'mealRelationship',
  );
  @override
  late final GeneratedColumn<String> mealRelationship = GeneratedColumn<String>(
    'meal_relationship',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastMealCarbsMeta = const VerificationMeta(
    'lastMealCarbs',
  );
  @override
  late final GeneratedColumn<double> lastMealCarbs = GeneratedColumn<double>(
    'last_meal_carbs',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastMealGiScoreMeta = const VerificationMeta(
    'lastMealGiScore',
  );
  @override
  late final GeneratedColumn<double> lastMealGiScore = GeneratedColumn<double>(
    'last_meal_gi_score',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mealCompositionMeta = const VerificationMeta(
    'mealComposition',
  );
  @override
  late final GeneratedColumn<String> mealComposition = GeneratedColumn<String>(
    'meal_composition',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _exerciseBeforeTestMeta =
      const VerificationMeta('exerciseBeforeTest');
  @override
  late final GeneratedColumn<String> exerciseBeforeTest =
      GeneratedColumn<String>(
        'exercise_before_test',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _exerciseIntensityMeta = const VerificationMeta(
    'exerciseIntensity',
  );
  @override
  late final GeneratedColumn<String> exerciseIntensity =
      GeneratedColumn<String>(
        'exercise_intensity',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _exerciseDurationMeta = const VerificationMeta(
    'exerciseDuration',
  );
  @override
  late final GeneratedColumn<int> exerciseDuration = GeneratedColumn<int>(
    'exercise_duration',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _insulinDoseMeta = const VerificationMeta(
    'insulinDose',
  );
  @override
  late final GeneratedColumn<double> insulinDose = GeneratedColumn<double>(
    'insulin_dose',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _insulinTimeBeforeMeta = const VerificationMeta(
    'insulinTimeBefore',
  );
  @override
  late final GeneratedColumn<int> insulinTimeBefore = GeneratedColumn<int>(
    'insulin_time_before',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _medicationListMeta = const VerificationMeta(
    'medicationList',
  );
  @override
  late final GeneratedColumn<String> medicationList = GeneratedColumn<String>(
    'medication_list',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _illnessStatusMeta = const VerificationMeta(
    'illnessStatus',
  );
  @override
  late final GeneratedColumn<String> illnessStatus = GeneratedColumn<String>(
    'illness_status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stressLevelMeta = const VerificationMeta(
    'stressLevel',
  );
  @override
  late final GeneratedColumn<int> stressLevel = GeneratedColumn<int>(
    'stress_level',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _menstrualCycleDayMeta = const VerificationMeta(
    'menstrualCycleDay',
  );
  @override
  late final GeneratedColumn<int> menstrualCycleDay = GeneratedColumn<int>(
    'menstrual_cycle_day',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sleepQualityMeta = const VerificationMeta(
    'sleepQuality',
  );
  @override
  late final GeneratedColumn<int> sleepQuality = GeneratedColumn<int>(
    'sleep_quality',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hypoglycemiaSymptomsMeta =
      const VerificationMeta('hypoglycemiaSymptoms');
  @override
  late final GeneratedColumn<String> hypoglycemiaSymptoms =
      GeneratedColumn<String>(
        'hypoglycemia_symptoms',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _hyperglycemiaSymptomsMeta =
      const VerificationMeta('hyperglycemiaSymptoms');
  @override
  late final GeneratedColumn<String> hyperglycemiaSymptoms =
      GeneratedColumn<String>(
        'hyperglycemia_symptoms',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _ketoneLevelMeta = const VerificationMeta(
    'ketoneLevel',
  );
  @override
  late final GeneratedColumn<double> ketoneLevel = GeneratedColumn<double>(
    'ketone_level',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceInfoMeta = const VerificationMeta(
    'deviceInfo',
  );
  @override
  late final GeneratedColumn<String> deviceInfo = GeneratedColumn<String>(
    'device_info',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    recordDatetime,
    glucoseValue,
    glucoseUnit,
    measurementTiming,
    fastingHours,
    mealRelationship,
    lastMealCarbs,
    lastMealGiScore,
    mealComposition,
    exerciseBeforeTest,
    exerciseIntensity,
    exerciseDuration,
    insulinDose,
    insulinTimeBefore,
    medicationList,
    illnessStatus,
    stressLevel,
    menstrualCycleDay,
    sleepQuality,
    hypoglycemiaSymptoms,
    hyperglycemiaSymptoms,
    ketoneLevel,
    notes,
    deviceInfo,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'blood_glucose_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<BloodGlucoseRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('record_datetime')) {
      context.handle(
        _recordDatetimeMeta,
        recordDatetime.isAcceptableOrUnknown(
          data['record_datetime']!,
          _recordDatetimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recordDatetimeMeta);
    }
    if (data.containsKey('glucose_value')) {
      context.handle(
        _glucoseValueMeta,
        glucoseValue.isAcceptableOrUnknown(
          data['glucose_value']!,
          _glucoseValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_glucoseValueMeta);
    }
    if (data.containsKey('glucose_unit')) {
      context.handle(
        _glucoseUnitMeta,
        glucoseUnit.isAcceptableOrUnknown(
          data['glucose_unit']!,
          _glucoseUnitMeta,
        ),
      );
    }
    if (data.containsKey('measurement_timing')) {
      context.handle(
        _measurementTimingMeta,
        measurementTiming.isAcceptableOrUnknown(
          data['measurement_timing']!,
          _measurementTimingMeta,
        ),
      );
    }
    if (data.containsKey('fasting_hours')) {
      context.handle(
        _fastingHoursMeta,
        fastingHours.isAcceptableOrUnknown(
          data['fasting_hours']!,
          _fastingHoursMeta,
        ),
      );
    }
    if (data.containsKey('meal_relationship')) {
      context.handle(
        _mealRelationshipMeta,
        mealRelationship.isAcceptableOrUnknown(
          data['meal_relationship']!,
          _mealRelationshipMeta,
        ),
      );
    }
    if (data.containsKey('last_meal_carbs')) {
      context.handle(
        _lastMealCarbsMeta,
        lastMealCarbs.isAcceptableOrUnknown(
          data['last_meal_carbs']!,
          _lastMealCarbsMeta,
        ),
      );
    }
    if (data.containsKey('last_meal_gi_score')) {
      context.handle(
        _lastMealGiScoreMeta,
        lastMealGiScore.isAcceptableOrUnknown(
          data['last_meal_gi_score']!,
          _lastMealGiScoreMeta,
        ),
      );
    }
    if (data.containsKey('meal_composition')) {
      context.handle(
        _mealCompositionMeta,
        mealComposition.isAcceptableOrUnknown(
          data['meal_composition']!,
          _mealCompositionMeta,
        ),
      );
    }
    if (data.containsKey('exercise_before_test')) {
      context.handle(
        _exerciseBeforeTestMeta,
        exerciseBeforeTest.isAcceptableOrUnknown(
          data['exercise_before_test']!,
          _exerciseBeforeTestMeta,
        ),
      );
    }
    if (data.containsKey('exercise_intensity')) {
      context.handle(
        _exerciseIntensityMeta,
        exerciseIntensity.isAcceptableOrUnknown(
          data['exercise_intensity']!,
          _exerciseIntensityMeta,
        ),
      );
    }
    if (data.containsKey('exercise_duration')) {
      context.handle(
        _exerciseDurationMeta,
        exerciseDuration.isAcceptableOrUnknown(
          data['exercise_duration']!,
          _exerciseDurationMeta,
        ),
      );
    }
    if (data.containsKey('insulin_dose')) {
      context.handle(
        _insulinDoseMeta,
        insulinDose.isAcceptableOrUnknown(
          data['insulin_dose']!,
          _insulinDoseMeta,
        ),
      );
    }
    if (data.containsKey('insulin_time_before')) {
      context.handle(
        _insulinTimeBeforeMeta,
        insulinTimeBefore.isAcceptableOrUnknown(
          data['insulin_time_before']!,
          _insulinTimeBeforeMeta,
        ),
      );
    }
    if (data.containsKey('medication_list')) {
      context.handle(
        _medicationListMeta,
        medicationList.isAcceptableOrUnknown(
          data['medication_list']!,
          _medicationListMeta,
        ),
      );
    }
    if (data.containsKey('illness_status')) {
      context.handle(
        _illnessStatusMeta,
        illnessStatus.isAcceptableOrUnknown(
          data['illness_status']!,
          _illnessStatusMeta,
        ),
      );
    }
    if (data.containsKey('stress_level')) {
      context.handle(
        _stressLevelMeta,
        stressLevel.isAcceptableOrUnknown(
          data['stress_level']!,
          _stressLevelMeta,
        ),
      );
    }
    if (data.containsKey('menstrual_cycle_day')) {
      context.handle(
        _menstrualCycleDayMeta,
        menstrualCycleDay.isAcceptableOrUnknown(
          data['menstrual_cycle_day']!,
          _menstrualCycleDayMeta,
        ),
      );
    }
    if (data.containsKey('sleep_quality')) {
      context.handle(
        _sleepQualityMeta,
        sleepQuality.isAcceptableOrUnknown(
          data['sleep_quality']!,
          _sleepQualityMeta,
        ),
      );
    }
    if (data.containsKey('hypoglycemia_symptoms')) {
      context.handle(
        _hypoglycemiaSymptomsMeta,
        hypoglycemiaSymptoms.isAcceptableOrUnknown(
          data['hypoglycemia_symptoms']!,
          _hypoglycemiaSymptomsMeta,
        ),
      );
    }
    if (data.containsKey('hyperglycemia_symptoms')) {
      context.handle(
        _hyperglycemiaSymptomsMeta,
        hyperglycemiaSymptoms.isAcceptableOrUnknown(
          data['hyperglycemia_symptoms']!,
          _hyperglycemiaSymptomsMeta,
        ),
      );
    }
    if (data.containsKey('ketone_level')) {
      context.handle(
        _ketoneLevelMeta,
        ketoneLevel.isAcceptableOrUnknown(
          data['ketone_level']!,
          _ketoneLevelMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('device_info')) {
      context.handle(
        _deviceInfoMeta,
        deviceInfo.isAcceptableOrUnknown(data['device_info']!, _deviceInfoMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BloodGlucoseRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BloodGlucoseRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      recordDatetime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}record_datetime'],
      )!,
      glucoseValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}glucose_value'],
      )!,
      glucoseUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}glucose_unit'],
      )!,
      measurementTiming: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}measurement_timing'],
      ),
      fastingHours: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fasting_hours'],
      ),
      mealRelationship: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meal_relationship'],
      ),
      lastMealCarbs: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}last_meal_carbs'],
      ),
      lastMealGiScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}last_meal_gi_score'],
      ),
      mealComposition: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meal_composition'],
      ),
      exerciseBeforeTest: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_before_test'],
      ),
      exerciseIntensity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_intensity'],
      ),
      exerciseDuration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exercise_duration'],
      ),
      insulinDose: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}insulin_dose'],
      ),
      insulinTimeBefore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}insulin_time_before'],
      ),
      medicationList: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}medication_list'],
      ),
      illnessStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}illness_status'],
      ),
      stressLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stress_level'],
      ),
      menstrualCycleDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}menstrual_cycle_day'],
      ),
      sleepQuality: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sleep_quality'],
      ),
      hypoglycemiaSymptoms: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hypoglycemia_symptoms'],
      ),
      hyperglycemiaSymptoms: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hyperglycemia_symptoms'],
      ),
      ketoneLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}ketone_level'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      deviceInfo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_info'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BloodGlucoseRecordsTable createAlias(String alias) {
    return $BloodGlucoseRecordsTable(attachedDatabase, alias);
  }
}

class BloodGlucoseRecord extends DataClass
    implements Insertable<BloodGlucoseRecord> {
  final int id;
  final String userId;
  final DateTime recordDatetime;
  final double glucoseValue;
  final String glucoseUnit;
  final String? measurementTiming;
  final double? fastingHours;
  final String? mealRelationship;
  final double? lastMealCarbs;
  final double? lastMealGiScore;
  final String? mealComposition;
  final String? exerciseBeforeTest;
  final String? exerciseIntensity;
  final int? exerciseDuration;
  final double? insulinDose;
  final int? insulinTimeBefore;
  final String? medicationList;
  final String? illnessStatus;
  final int? stressLevel;
  final int? menstrualCycleDay;
  final int? sleepQuality;
  final String? hypoglycemiaSymptoms;
  final String? hyperglycemiaSymptoms;
  final double? ketoneLevel;
  final String? notes;
  final String? deviceInfo;
  final DateTime createdAt;
  const BloodGlucoseRecord({
    required this.id,
    required this.userId,
    required this.recordDatetime,
    required this.glucoseValue,
    required this.glucoseUnit,
    this.measurementTiming,
    this.fastingHours,
    this.mealRelationship,
    this.lastMealCarbs,
    this.lastMealGiScore,
    this.mealComposition,
    this.exerciseBeforeTest,
    this.exerciseIntensity,
    this.exerciseDuration,
    this.insulinDose,
    this.insulinTimeBefore,
    this.medicationList,
    this.illnessStatus,
    this.stressLevel,
    this.menstrualCycleDay,
    this.sleepQuality,
    this.hypoglycemiaSymptoms,
    this.hyperglycemiaSymptoms,
    this.ketoneLevel,
    this.notes,
    this.deviceInfo,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<String>(userId);
    map['record_datetime'] = Variable<DateTime>(recordDatetime);
    map['glucose_value'] = Variable<double>(glucoseValue);
    map['glucose_unit'] = Variable<String>(glucoseUnit);
    if (!nullToAbsent || measurementTiming != null) {
      map['measurement_timing'] = Variable<String>(measurementTiming);
    }
    if (!nullToAbsent || fastingHours != null) {
      map['fasting_hours'] = Variable<double>(fastingHours);
    }
    if (!nullToAbsent || mealRelationship != null) {
      map['meal_relationship'] = Variable<String>(mealRelationship);
    }
    if (!nullToAbsent || lastMealCarbs != null) {
      map['last_meal_carbs'] = Variable<double>(lastMealCarbs);
    }
    if (!nullToAbsent || lastMealGiScore != null) {
      map['last_meal_gi_score'] = Variable<double>(lastMealGiScore);
    }
    if (!nullToAbsent || mealComposition != null) {
      map['meal_composition'] = Variable<String>(mealComposition);
    }
    if (!nullToAbsent || exerciseBeforeTest != null) {
      map['exercise_before_test'] = Variable<String>(exerciseBeforeTest);
    }
    if (!nullToAbsent || exerciseIntensity != null) {
      map['exercise_intensity'] = Variable<String>(exerciseIntensity);
    }
    if (!nullToAbsent || exerciseDuration != null) {
      map['exercise_duration'] = Variable<int>(exerciseDuration);
    }
    if (!nullToAbsent || insulinDose != null) {
      map['insulin_dose'] = Variable<double>(insulinDose);
    }
    if (!nullToAbsent || insulinTimeBefore != null) {
      map['insulin_time_before'] = Variable<int>(insulinTimeBefore);
    }
    if (!nullToAbsent || medicationList != null) {
      map['medication_list'] = Variable<String>(medicationList);
    }
    if (!nullToAbsent || illnessStatus != null) {
      map['illness_status'] = Variable<String>(illnessStatus);
    }
    if (!nullToAbsent || stressLevel != null) {
      map['stress_level'] = Variable<int>(stressLevel);
    }
    if (!nullToAbsent || menstrualCycleDay != null) {
      map['menstrual_cycle_day'] = Variable<int>(menstrualCycleDay);
    }
    if (!nullToAbsent || sleepQuality != null) {
      map['sleep_quality'] = Variable<int>(sleepQuality);
    }
    if (!nullToAbsent || hypoglycemiaSymptoms != null) {
      map['hypoglycemia_symptoms'] = Variable<String>(hypoglycemiaSymptoms);
    }
    if (!nullToAbsent || hyperglycemiaSymptoms != null) {
      map['hyperglycemia_symptoms'] = Variable<String>(hyperglycemiaSymptoms);
    }
    if (!nullToAbsent || ketoneLevel != null) {
      map['ketone_level'] = Variable<double>(ketoneLevel);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || deviceInfo != null) {
      map['device_info'] = Variable<String>(deviceInfo);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BloodGlucoseRecordsCompanion toCompanion(bool nullToAbsent) {
    return BloodGlucoseRecordsCompanion(
      id: Value(id),
      userId: Value(userId),
      recordDatetime: Value(recordDatetime),
      glucoseValue: Value(glucoseValue),
      glucoseUnit: Value(glucoseUnit),
      measurementTiming: measurementTiming == null && nullToAbsent
          ? const Value.absent()
          : Value(measurementTiming),
      fastingHours: fastingHours == null && nullToAbsent
          ? const Value.absent()
          : Value(fastingHours),
      mealRelationship: mealRelationship == null && nullToAbsent
          ? const Value.absent()
          : Value(mealRelationship),
      lastMealCarbs: lastMealCarbs == null && nullToAbsent
          ? const Value.absent()
          : Value(lastMealCarbs),
      lastMealGiScore: lastMealGiScore == null && nullToAbsent
          ? const Value.absent()
          : Value(lastMealGiScore),
      mealComposition: mealComposition == null && nullToAbsent
          ? const Value.absent()
          : Value(mealComposition),
      exerciseBeforeTest: exerciseBeforeTest == null && nullToAbsent
          ? const Value.absent()
          : Value(exerciseBeforeTest),
      exerciseIntensity: exerciseIntensity == null && nullToAbsent
          ? const Value.absent()
          : Value(exerciseIntensity),
      exerciseDuration: exerciseDuration == null && nullToAbsent
          ? const Value.absent()
          : Value(exerciseDuration),
      insulinDose: insulinDose == null && nullToAbsent
          ? const Value.absent()
          : Value(insulinDose),
      insulinTimeBefore: insulinTimeBefore == null && nullToAbsent
          ? const Value.absent()
          : Value(insulinTimeBefore),
      medicationList: medicationList == null && nullToAbsent
          ? const Value.absent()
          : Value(medicationList),
      illnessStatus: illnessStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(illnessStatus),
      stressLevel: stressLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(stressLevel),
      menstrualCycleDay: menstrualCycleDay == null && nullToAbsent
          ? const Value.absent()
          : Value(menstrualCycleDay),
      sleepQuality: sleepQuality == null && nullToAbsent
          ? const Value.absent()
          : Value(sleepQuality),
      hypoglycemiaSymptoms: hypoglycemiaSymptoms == null && nullToAbsent
          ? const Value.absent()
          : Value(hypoglycemiaSymptoms),
      hyperglycemiaSymptoms: hyperglycemiaSymptoms == null && nullToAbsent
          ? const Value.absent()
          : Value(hyperglycemiaSymptoms),
      ketoneLevel: ketoneLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(ketoneLevel),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      deviceInfo: deviceInfo == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceInfo),
      createdAt: Value(createdAt),
    );
  }

  factory BloodGlucoseRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BloodGlucoseRecord(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      recordDatetime: serializer.fromJson<DateTime>(json['recordDatetime']),
      glucoseValue: serializer.fromJson<double>(json['glucoseValue']),
      glucoseUnit: serializer.fromJson<String>(json['glucoseUnit']),
      measurementTiming: serializer.fromJson<String?>(
        json['measurementTiming'],
      ),
      fastingHours: serializer.fromJson<double?>(json['fastingHours']),
      mealRelationship: serializer.fromJson<String?>(json['mealRelationship']),
      lastMealCarbs: serializer.fromJson<double?>(json['lastMealCarbs']),
      lastMealGiScore: serializer.fromJson<double?>(json['lastMealGiScore']),
      mealComposition: serializer.fromJson<String?>(json['mealComposition']),
      exerciseBeforeTest: serializer.fromJson<String?>(
        json['exerciseBeforeTest'],
      ),
      exerciseIntensity: serializer.fromJson<String?>(
        json['exerciseIntensity'],
      ),
      exerciseDuration: serializer.fromJson<int?>(json['exerciseDuration']),
      insulinDose: serializer.fromJson<double?>(json['insulinDose']),
      insulinTimeBefore: serializer.fromJson<int?>(json['insulinTimeBefore']),
      medicationList: serializer.fromJson<String?>(json['medicationList']),
      illnessStatus: serializer.fromJson<String?>(json['illnessStatus']),
      stressLevel: serializer.fromJson<int?>(json['stressLevel']),
      menstrualCycleDay: serializer.fromJson<int?>(json['menstrualCycleDay']),
      sleepQuality: serializer.fromJson<int?>(json['sleepQuality']),
      hypoglycemiaSymptoms: serializer.fromJson<String?>(
        json['hypoglycemiaSymptoms'],
      ),
      hyperglycemiaSymptoms: serializer.fromJson<String?>(
        json['hyperglycemiaSymptoms'],
      ),
      ketoneLevel: serializer.fromJson<double?>(json['ketoneLevel']),
      notes: serializer.fromJson<String?>(json['notes']),
      deviceInfo: serializer.fromJson<String?>(json['deviceInfo']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<String>(userId),
      'recordDatetime': serializer.toJson<DateTime>(recordDatetime),
      'glucoseValue': serializer.toJson<double>(glucoseValue),
      'glucoseUnit': serializer.toJson<String>(glucoseUnit),
      'measurementTiming': serializer.toJson<String?>(measurementTiming),
      'fastingHours': serializer.toJson<double?>(fastingHours),
      'mealRelationship': serializer.toJson<String?>(mealRelationship),
      'lastMealCarbs': serializer.toJson<double?>(lastMealCarbs),
      'lastMealGiScore': serializer.toJson<double?>(lastMealGiScore),
      'mealComposition': serializer.toJson<String?>(mealComposition),
      'exerciseBeforeTest': serializer.toJson<String?>(exerciseBeforeTest),
      'exerciseIntensity': serializer.toJson<String?>(exerciseIntensity),
      'exerciseDuration': serializer.toJson<int?>(exerciseDuration),
      'insulinDose': serializer.toJson<double?>(insulinDose),
      'insulinTimeBefore': serializer.toJson<int?>(insulinTimeBefore),
      'medicationList': serializer.toJson<String?>(medicationList),
      'illnessStatus': serializer.toJson<String?>(illnessStatus),
      'stressLevel': serializer.toJson<int?>(stressLevel),
      'menstrualCycleDay': serializer.toJson<int?>(menstrualCycleDay),
      'sleepQuality': serializer.toJson<int?>(sleepQuality),
      'hypoglycemiaSymptoms': serializer.toJson<String?>(hypoglycemiaSymptoms),
      'hyperglycemiaSymptoms': serializer.toJson<String?>(
        hyperglycemiaSymptoms,
      ),
      'ketoneLevel': serializer.toJson<double?>(ketoneLevel),
      'notes': serializer.toJson<String?>(notes),
      'deviceInfo': serializer.toJson<String?>(deviceInfo),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  BloodGlucoseRecord copyWith({
    int? id,
    String? userId,
    DateTime? recordDatetime,
    double? glucoseValue,
    String? glucoseUnit,
    Value<String?> measurementTiming = const Value.absent(),
    Value<double?> fastingHours = const Value.absent(),
    Value<String?> mealRelationship = const Value.absent(),
    Value<double?> lastMealCarbs = const Value.absent(),
    Value<double?> lastMealGiScore = const Value.absent(),
    Value<String?> mealComposition = const Value.absent(),
    Value<String?> exerciseBeforeTest = const Value.absent(),
    Value<String?> exerciseIntensity = const Value.absent(),
    Value<int?> exerciseDuration = const Value.absent(),
    Value<double?> insulinDose = const Value.absent(),
    Value<int?> insulinTimeBefore = const Value.absent(),
    Value<String?> medicationList = const Value.absent(),
    Value<String?> illnessStatus = const Value.absent(),
    Value<int?> stressLevel = const Value.absent(),
    Value<int?> menstrualCycleDay = const Value.absent(),
    Value<int?> sleepQuality = const Value.absent(),
    Value<String?> hypoglycemiaSymptoms = const Value.absent(),
    Value<String?> hyperglycemiaSymptoms = const Value.absent(),
    Value<double?> ketoneLevel = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> deviceInfo = const Value.absent(),
    DateTime? createdAt,
  }) => BloodGlucoseRecord(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    recordDatetime: recordDatetime ?? this.recordDatetime,
    glucoseValue: glucoseValue ?? this.glucoseValue,
    glucoseUnit: glucoseUnit ?? this.glucoseUnit,
    measurementTiming: measurementTiming.present
        ? measurementTiming.value
        : this.measurementTiming,
    fastingHours: fastingHours.present ? fastingHours.value : this.fastingHours,
    mealRelationship: mealRelationship.present
        ? mealRelationship.value
        : this.mealRelationship,
    lastMealCarbs: lastMealCarbs.present
        ? lastMealCarbs.value
        : this.lastMealCarbs,
    lastMealGiScore: lastMealGiScore.present
        ? lastMealGiScore.value
        : this.lastMealGiScore,
    mealComposition: mealComposition.present
        ? mealComposition.value
        : this.mealComposition,
    exerciseBeforeTest: exerciseBeforeTest.present
        ? exerciseBeforeTest.value
        : this.exerciseBeforeTest,
    exerciseIntensity: exerciseIntensity.present
        ? exerciseIntensity.value
        : this.exerciseIntensity,
    exerciseDuration: exerciseDuration.present
        ? exerciseDuration.value
        : this.exerciseDuration,
    insulinDose: insulinDose.present ? insulinDose.value : this.insulinDose,
    insulinTimeBefore: insulinTimeBefore.present
        ? insulinTimeBefore.value
        : this.insulinTimeBefore,
    medicationList: medicationList.present
        ? medicationList.value
        : this.medicationList,
    illnessStatus: illnessStatus.present
        ? illnessStatus.value
        : this.illnessStatus,
    stressLevel: stressLevel.present ? stressLevel.value : this.stressLevel,
    menstrualCycleDay: menstrualCycleDay.present
        ? menstrualCycleDay.value
        : this.menstrualCycleDay,
    sleepQuality: sleepQuality.present ? sleepQuality.value : this.sleepQuality,
    hypoglycemiaSymptoms: hypoglycemiaSymptoms.present
        ? hypoglycemiaSymptoms.value
        : this.hypoglycemiaSymptoms,
    hyperglycemiaSymptoms: hyperglycemiaSymptoms.present
        ? hyperglycemiaSymptoms.value
        : this.hyperglycemiaSymptoms,
    ketoneLevel: ketoneLevel.present ? ketoneLevel.value : this.ketoneLevel,
    notes: notes.present ? notes.value : this.notes,
    deviceInfo: deviceInfo.present ? deviceInfo.value : this.deviceInfo,
    createdAt: createdAt ?? this.createdAt,
  );
  BloodGlucoseRecord copyWithCompanion(BloodGlucoseRecordsCompanion data) {
    return BloodGlucoseRecord(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      recordDatetime: data.recordDatetime.present
          ? data.recordDatetime.value
          : this.recordDatetime,
      glucoseValue: data.glucoseValue.present
          ? data.glucoseValue.value
          : this.glucoseValue,
      glucoseUnit: data.glucoseUnit.present
          ? data.glucoseUnit.value
          : this.glucoseUnit,
      measurementTiming: data.measurementTiming.present
          ? data.measurementTiming.value
          : this.measurementTiming,
      fastingHours: data.fastingHours.present
          ? data.fastingHours.value
          : this.fastingHours,
      mealRelationship: data.mealRelationship.present
          ? data.mealRelationship.value
          : this.mealRelationship,
      lastMealCarbs: data.lastMealCarbs.present
          ? data.lastMealCarbs.value
          : this.lastMealCarbs,
      lastMealGiScore: data.lastMealGiScore.present
          ? data.lastMealGiScore.value
          : this.lastMealGiScore,
      mealComposition: data.mealComposition.present
          ? data.mealComposition.value
          : this.mealComposition,
      exerciseBeforeTest: data.exerciseBeforeTest.present
          ? data.exerciseBeforeTest.value
          : this.exerciseBeforeTest,
      exerciseIntensity: data.exerciseIntensity.present
          ? data.exerciseIntensity.value
          : this.exerciseIntensity,
      exerciseDuration: data.exerciseDuration.present
          ? data.exerciseDuration.value
          : this.exerciseDuration,
      insulinDose: data.insulinDose.present
          ? data.insulinDose.value
          : this.insulinDose,
      insulinTimeBefore: data.insulinTimeBefore.present
          ? data.insulinTimeBefore.value
          : this.insulinTimeBefore,
      medicationList: data.medicationList.present
          ? data.medicationList.value
          : this.medicationList,
      illnessStatus: data.illnessStatus.present
          ? data.illnessStatus.value
          : this.illnessStatus,
      stressLevel: data.stressLevel.present
          ? data.stressLevel.value
          : this.stressLevel,
      menstrualCycleDay: data.menstrualCycleDay.present
          ? data.menstrualCycleDay.value
          : this.menstrualCycleDay,
      sleepQuality: data.sleepQuality.present
          ? data.sleepQuality.value
          : this.sleepQuality,
      hypoglycemiaSymptoms: data.hypoglycemiaSymptoms.present
          ? data.hypoglycemiaSymptoms.value
          : this.hypoglycemiaSymptoms,
      hyperglycemiaSymptoms: data.hyperglycemiaSymptoms.present
          ? data.hyperglycemiaSymptoms.value
          : this.hyperglycemiaSymptoms,
      ketoneLevel: data.ketoneLevel.present
          ? data.ketoneLevel.value
          : this.ketoneLevel,
      notes: data.notes.present ? data.notes.value : this.notes,
      deviceInfo: data.deviceInfo.present
          ? data.deviceInfo.value
          : this.deviceInfo,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BloodGlucoseRecord(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('recordDatetime: $recordDatetime, ')
          ..write('glucoseValue: $glucoseValue, ')
          ..write('glucoseUnit: $glucoseUnit, ')
          ..write('measurementTiming: $measurementTiming, ')
          ..write('fastingHours: $fastingHours, ')
          ..write('mealRelationship: $mealRelationship, ')
          ..write('lastMealCarbs: $lastMealCarbs, ')
          ..write('lastMealGiScore: $lastMealGiScore, ')
          ..write('mealComposition: $mealComposition, ')
          ..write('exerciseBeforeTest: $exerciseBeforeTest, ')
          ..write('exerciseIntensity: $exerciseIntensity, ')
          ..write('exerciseDuration: $exerciseDuration, ')
          ..write('insulinDose: $insulinDose, ')
          ..write('insulinTimeBefore: $insulinTimeBefore, ')
          ..write('medicationList: $medicationList, ')
          ..write('illnessStatus: $illnessStatus, ')
          ..write('stressLevel: $stressLevel, ')
          ..write('menstrualCycleDay: $menstrualCycleDay, ')
          ..write('sleepQuality: $sleepQuality, ')
          ..write('hypoglycemiaSymptoms: $hypoglycemiaSymptoms, ')
          ..write('hyperglycemiaSymptoms: $hyperglycemiaSymptoms, ')
          ..write('ketoneLevel: $ketoneLevel, ')
          ..write('notes: $notes, ')
          ..write('deviceInfo: $deviceInfo, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    userId,
    recordDatetime,
    glucoseValue,
    glucoseUnit,
    measurementTiming,
    fastingHours,
    mealRelationship,
    lastMealCarbs,
    lastMealGiScore,
    mealComposition,
    exerciseBeforeTest,
    exerciseIntensity,
    exerciseDuration,
    insulinDose,
    insulinTimeBefore,
    medicationList,
    illnessStatus,
    stressLevel,
    menstrualCycleDay,
    sleepQuality,
    hypoglycemiaSymptoms,
    hyperglycemiaSymptoms,
    ketoneLevel,
    notes,
    deviceInfo,
    createdAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BloodGlucoseRecord &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.recordDatetime == this.recordDatetime &&
          other.glucoseValue == this.glucoseValue &&
          other.glucoseUnit == this.glucoseUnit &&
          other.measurementTiming == this.measurementTiming &&
          other.fastingHours == this.fastingHours &&
          other.mealRelationship == this.mealRelationship &&
          other.lastMealCarbs == this.lastMealCarbs &&
          other.lastMealGiScore == this.lastMealGiScore &&
          other.mealComposition == this.mealComposition &&
          other.exerciseBeforeTest == this.exerciseBeforeTest &&
          other.exerciseIntensity == this.exerciseIntensity &&
          other.exerciseDuration == this.exerciseDuration &&
          other.insulinDose == this.insulinDose &&
          other.insulinTimeBefore == this.insulinTimeBefore &&
          other.medicationList == this.medicationList &&
          other.illnessStatus == this.illnessStatus &&
          other.stressLevel == this.stressLevel &&
          other.menstrualCycleDay == this.menstrualCycleDay &&
          other.sleepQuality == this.sleepQuality &&
          other.hypoglycemiaSymptoms == this.hypoglycemiaSymptoms &&
          other.hyperglycemiaSymptoms == this.hyperglycemiaSymptoms &&
          other.ketoneLevel == this.ketoneLevel &&
          other.notes == this.notes &&
          other.deviceInfo == this.deviceInfo &&
          other.createdAt == this.createdAt);
}

class BloodGlucoseRecordsCompanion extends UpdateCompanion<BloodGlucoseRecord> {
  final Value<int> id;
  final Value<String> userId;
  final Value<DateTime> recordDatetime;
  final Value<double> glucoseValue;
  final Value<String> glucoseUnit;
  final Value<String?> measurementTiming;
  final Value<double?> fastingHours;
  final Value<String?> mealRelationship;
  final Value<double?> lastMealCarbs;
  final Value<double?> lastMealGiScore;
  final Value<String?> mealComposition;
  final Value<String?> exerciseBeforeTest;
  final Value<String?> exerciseIntensity;
  final Value<int?> exerciseDuration;
  final Value<double?> insulinDose;
  final Value<int?> insulinTimeBefore;
  final Value<String?> medicationList;
  final Value<String?> illnessStatus;
  final Value<int?> stressLevel;
  final Value<int?> menstrualCycleDay;
  final Value<int?> sleepQuality;
  final Value<String?> hypoglycemiaSymptoms;
  final Value<String?> hyperglycemiaSymptoms;
  final Value<double?> ketoneLevel;
  final Value<String?> notes;
  final Value<String?> deviceInfo;
  final Value<DateTime> createdAt;
  const BloodGlucoseRecordsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.recordDatetime = const Value.absent(),
    this.glucoseValue = const Value.absent(),
    this.glucoseUnit = const Value.absent(),
    this.measurementTiming = const Value.absent(),
    this.fastingHours = const Value.absent(),
    this.mealRelationship = const Value.absent(),
    this.lastMealCarbs = const Value.absent(),
    this.lastMealGiScore = const Value.absent(),
    this.mealComposition = const Value.absent(),
    this.exerciseBeforeTest = const Value.absent(),
    this.exerciseIntensity = const Value.absent(),
    this.exerciseDuration = const Value.absent(),
    this.insulinDose = const Value.absent(),
    this.insulinTimeBefore = const Value.absent(),
    this.medicationList = const Value.absent(),
    this.illnessStatus = const Value.absent(),
    this.stressLevel = const Value.absent(),
    this.menstrualCycleDay = const Value.absent(),
    this.sleepQuality = const Value.absent(),
    this.hypoglycemiaSymptoms = const Value.absent(),
    this.hyperglycemiaSymptoms = const Value.absent(),
    this.ketoneLevel = const Value.absent(),
    this.notes = const Value.absent(),
    this.deviceInfo = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  BloodGlucoseRecordsCompanion.insert({
    this.id = const Value.absent(),
    required String userId,
    required DateTime recordDatetime,
    required double glucoseValue,
    this.glucoseUnit = const Value.absent(),
    this.measurementTiming = const Value.absent(),
    this.fastingHours = const Value.absent(),
    this.mealRelationship = const Value.absent(),
    this.lastMealCarbs = const Value.absent(),
    this.lastMealGiScore = const Value.absent(),
    this.mealComposition = const Value.absent(),
    this.exerciseBeforeTest = const Value.absent(),
    this.exerciseIntensity = const Value.absent(),
    this.exerciseDuration = const Value.absent(),
    this.insulinDose = const Value.absent(),
    this.insulinTimeBefore = const Value.absent(),
    this.medicationList = const Value.absent(),
    this.illnessStatus = const Value.absent(),
    this.stressLevel = const Value.absent(),
    this.menstrualCycleDay = const Value.absent(),
    this.sleepQuality = const Value.absent(),
    this.hypoglycemiaSymptoms = const Value.absent(),
    this.hyperglycemiaSymptoms = const Value.absent(),
    this.ketoneLevel = const Value.absent(),
    this.notes = const Value.absent(),
    this.deviceInfo = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : userId = Value(userId),
       recordDatetime = Value(recordDatetime),
       glucoseValue = Value(glucoseValue);
  static Insertable<BloodGlucoseRecord> custom({
    Expression<int>? id,
    Expression<String>? userId,
    Expression<DateTime>? recordDatetime,
    Expression<double>? glucoseValue,
    Expression<String>? glucoseUnit,
    Expression<String>? measurementTiming,
    Expression<double>? fastingHours,
    Expression<String>? mealRelationship,
    Expression<double>? lastMealCarbs,
    Expression<double>? lastMealGiScore,
    Expression<String>? mealComposition,
    Expression<String>? exerciseBeforeTest,
    Expression<String>? exerciseIntensity,
    Expression<int>? exerciseDuration,
    Expression<double>? insulinDose,
    Expression<int>? insulinTimeBefore,
    Expression<String>? medicationList,
    Expression<String>? illnessStatus,
    Expression<int>? stressLevel,
    Expression<int>? menstrualCycleDay,
    Expression<int>? sleepQuality,
    Expression<String>? hypoglycemiaSymptoms,
    Expression<String>? hyperglycemiaSymptoms,
    Expression<double>? ketoneLevel,
    Expression<String>? notes,
    Expression<String>? deviceInfo,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (recordDatetime != null) 'record_datetime': recordDatetime,
      if (glucoseValue != null) 'glucose_value': glucoseValue,
      if (glucoseUnit != null) 'glucose_unit': glucoseUnit,
      if (measurementTiming != null) 'measurement_timing': measurementTiming,
      if (fastingHours != null) 'fasting_hours': fastingHours,
      if (mealRelationship != null) 'meal_relationship': mealRelationship,
      if (lastMealCarbs != null) 'last_meal_carbs': lastMealCarbs,
      if (lastMealGiScore != null) 'last_meal_gi_score': lastMealGiScore,
      if (mealComposition != null) 'meal_composition': mealComposition,
      if (exerciseBeforeTest != null)
        'exercise_before_test': exerciseBeforeTest,
      if (exerciseIntensity != null) 'exercise_intensity': exerciseIntensity,
      if (exerciseDuration != null) 'exercise_duration': exerciseDuration,
      if (insulinDose != null) 'insulin_dose': insulinDose,
      if (insulinTimeBefore != null) 'insulin_time_before': insulinTimeBefore,
      if (medicationList != null) 'medication_list': medicationList,
      if (illnessStatus != null) 'illness_status': illnessStatus,
      if (stressLevel != null) 'stress_level': stressLevel,
      if (menstrualCycleDay != null) 'menstrual_cycle_day': menstrualCycleDay,
      if (sleepQuality != null) 'sleep_quality': sleepQuality,
      if (hypoglycemiaSymptoms != null)
        'hypoglycemia_symptoms': hypoglycemiaSymptoms,
      if (hyperglycemiaSymptoms != null)
        'hyperglycemia_symptoms': hyperglycemiaSymptoms,
      if (ketoneLevel != null) 'ketone_level': ketoneLevel,
      if (notes != null) 'notes': notes,
      if (deviceInfo != null) 'device_info': deviceInfo,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  BloodGlucoseRecordsCompanion copyWith({
    Value<int>? id,
    Value<String>? userId,
    Value<DateTime>? recordDatetime,
    Value<double>? glucoseValue,
    Value<String>? glucoseUnit,
    Value<String?>? measurementTiming,
    Value<double?>? fastingHours,
    Value<String?>? mealRelationship,
    Value<double?>? lastMealCarbs,
    Value<double?>? lastMealGiScore,
    Value<String?>? mealComposition,
    Value<String?>? exerciseBeforeTest,
    Value<String?>? exerciseIntensity,
    Value<int?>? exerciseDuration,
    Value<double?>? insulinDose,
    Value<int?>? insulinTimeBefore,
    Value<String?>? medicationList,
    Value<String?>? illnessStatus,
    Value<int?>? stressLevel,
    Value<int?>? menstrualCycleDay,
    Value<int?>? sleepQuality,
    Value<String?>? hypoglycemiaSymptoms,
    Value<String?>? hyperglycemiaSymptoms,
    Value<double?>? ketoneLevel,
    Value<String?>? notes,
    Value<String?>? deviceInfo,
    Value<DateTime>? createdAt,
  }) {
    return BloodGlucoseRecordsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      recordDatetime: recordDatetime ?? this.recordDatetime,
      glucoseValue: glucoseValue ?? this.glucoseValue,
      glucoseUnit: glucoseUnit ?? this.glucoseUnit,
      measurementTiming: measurementTiming ?? this.measurementTiming,
      fastingHours: fastingHours ?? this.fastingHours,
      mealRelationship: mealRelationship ?? this.mealRelationship,
      lastMealCarbs: lastMealCarbs ?? this.lastMealCarbs,
      lastMealGiScore: lastMealGiScore ?? this.lastMealGiScore,
      mealComposition: mealComposition ?? this.mealComposition,
      exerciseBeforeTest: exerciseBeforeTest ?? this.exerciseBeforeTest,
      exerciseIntensity: exerciseIntensity ?? this.exerciseIntensity,
      exerciseDuration: exerciseDuration ?? this.exerciseDuration,
      insulinDose: insulinDose ?? this.insulinDose,
      insulinTimeBefore: insulinTimeBefore ?? this.insulinTimeBefore,
      medicationList: medicationList ?? this.medicationList,
      illnessStatus: illnessStatus ?? this.illnessStatus,
      stressLevel: stressLevel ?? this.stressLevel,
      menstrualCycleDay: menstrualCycleDay ?? this.menstrualCycleDay,
      sleepQuality: sleepQuality ?? this.sleepQuality,
      hypoglycemiaSymptoms: hypoglycemiaSymptoms ?? this.hypoglycemiaSymptoms,
      hyperglycemiaSymptoms:
          hyperglycemiaSymptoms ?? this.hyperglycemiaSymptoms,
      ketoneLevel: ketoneLevel ?? this.ketoneLevel,
      notes: notes ?? this.notes,
      deviceInfo: deviceInfo ?? this.deviceInfo,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (recordDatetime.present) {
      map['record_datetime'] = Variable<DateTime>(recordDatetime.value);
    }
    if (glucoseValue.present) {
      map['glucose_value'] = Variable<double>(glucoseValue.value);
    }
    if (glucoseUnit.present) {
      map['glucose_unit'] = Variable<String>(glucoseUnit.value);
    }
    if (measurementTiming.present) {
      map['measurement_timing'] = Variable<String>(measurementTiming.value);
    }
    if (fastingHours.present) {
      map['fasting_hours'] = Variable<double>(fastingHours.value);
    }
    if (mealRelationship.present) {
      map['meal_relationship'] = Variable<String>(mealRelationship.value);
    }
    if (lastMealCarbs.present) {
      map['last_meal_carbs'] = Variable<double>(lastMealCarbs.value);
    }
    if (lastMealGiScore.present) {
      map['last_meal_gi_score'] = Variable<double>(lastMealGiScore.value);
    }
    if (mealComposition.present) {
      map['meal_composition'] = Variable<String>(mealComposition.value);
    }
    if (exerciseBeforeTest.present) {
      map['exercise_before_test'] = Variable<String>(exerciseBeforeTest.value);
    }
    if (exerciseIntensity.present) {
      map['exercise_intensity'] = Variable<String>(exerciseIntensity.value);
    }
    if (exerciseDuration.present) {
      map['exercise_duration'] = Variable<int>(exerciseDuration.value);
    }
    if (insulinDose.present) {
      map['insulin_dose'] = Variable<double>(insulinDose.value);
    }
    if (insulinTimeBefore.present) {
      map['insulin_time_before'] = Variable<int>(insulinTimeBefore.value);
    }
    if (medicationList.present) {
      map['medication_list'] = Variable<String>(medicationList.value);
    }
    if (illnessStatus.present) {
      map['illness_status'] = Variable<String>(illnessStatus.value);
    }
    if (stressLevel.present) {
      map['stress_level'] = Variable<int>(stressLevel.value);
    }
    if (menstrualCycleDay.present) {
      map['menstrual_cycle_day'] = Variable<int>(menstrualCycleDay.value);
    }
    if (sleepQuality.present) {
      map['sleep_quality'] = Variable<int>(sleepQuality.value);
    }
    if (hypoglycemiaSymptoms.present) {
      map['hypoglycemia_symptoms'] = Variable<String>(
        hypoglycemiaSymptoms.value,
      );
    }
    if (hyperglycemiaSymptoms.present) {
      map['hyperglycemia_symptoms'] = Variable<String>(
        hyperglycemiaSymptoms.value,
      );
    }
    if (ketoneLevel.present) {
      map['ketone_level'] = Variable<double>(ketoneLevel.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (deviceInfo.present) {
      map['device_info'] = Variable<String>(deviceInfo.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BloodGlucoseRecordsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('recordDatetime: $recordDatetime, ')
          ..write('glucoseValue: $glucoseValue, ')
          ..write('glucoseUnit: $glucoseUnit, ')
          ..write('measurementTiming: $measurementTiming, ')
          ..write('fastingHours: $fastingHours, ')
          ..write('mealRelationship: $mealRelationship, ')
          ..write('lastMealCarbs: $lastMealCarbs, ')
          ..write('lastMealGiScore: $lastMealGiScore, ')
          ..write('mealComposition: $mealComposition, ')
          ..write('exerciseBeforeTest: $exerciseBeforeTest, ')
          ..write('exerciseIntensity: $exerciseIntensity, ')
          ..write('exerciseDuration: $exerciseDuration, ')
          ..write('insulinDose: $insulinDose, ')
          ..write('insulinTimeBefore: $insulinTimeBefore, ')
          ..write('medicationList: $medicationList, ')
          ..write('illnessStatus: $illnessStatus, ')
          ..write('stressLevel: $stressLevel, ')
          ..write('menstrualCycleDay: $menstrualCycleDay, ')
          ..write('sleepQuality: $sleepQuality, ')
          ..write('hypoglycemiaSymptoms: $hypoglycemiaSymptoms, ')
          ..write('hyperglycemiaSymptoms: $hyperglycemiaSymptoms, ')
          ..write('ketoneLevel: $ketoneLevel, ')
          ..write('notes: $notes, ')
          ..write('deviceInfo: $deviceInfo, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $BloodLipidsRecordsTable extends BloodLipidsRecords
    with TableInfo<$BloodLipidsRecordsTable, BloodLipidsRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BloodLipidsRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordDatetimeMeta = const VerificationMeta(
    'recordDatetime',
  );
  @override
  late final GeneratedColumn<DateTime> recordDatetime =
      GeneratedColumn<DateTime>(
        'record_datetime',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _totalCholesterolMeta = const VerificationMeta(
    'totalCholesterol',
  );
  @override
  late final GeneratedColumn<double> totalCholesterol = GeneratedColumn<double>(
    'total_cholesterol',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _triglyceridesMeta = const VerificationMeta(
    'triglycerides',
  );
  @override
  late final GeneratedColumn<double> triglycerides = GeneratedColumn<double>(
    'triglycerides',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hdlCholesterolMeta = const VerificationMeta(
    'hdlCholesterol',
  );
  @override
  late final GeneratedColumn<double> hdlCholesterol = GeneratedColumn<double>(
    'hdl_cholesterol',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ldlCholesterolMeta = const VerificationMeta(
    'ldlCholesterol',
  );
  @override
  late final GeneratedColumn<double> ldlCholesterol = GeneratedColumn<double>(
    'ldl_cholesterol',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fastingStatusMeta = const VerificationMeta(
    'fastingStatus',
  );
  @override
  late final GeneratedColumn<bool> fastingStatus = GeneratedColumn<bool>(
    'fasting_status',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("fasting_status" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _lastMealTimeMeta = const VerificationMeta(
    'lastMealTime',
  );
  @override
  late final GeneratedColumn<DateTime> lastMealTime = GeneratedColumn<DateTime>(
    'last_meal_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceInfoMeta = const VerificationMeta(
    'deviceInfo',
  );
  @override
  late final GeneratedColumn<String> deviceInfo = GeneratedColumn<String>(
    'device_info',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _medicationTakenMeta = const VerificationMeta(
    'medicationTaken',
  );
  @override
  late final GeneratedColumn<String> medicationTaken = GeneratedColumn<String>(
    'medication_taken',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _symptomsMeta = const VerificationMeta(
    'symptoms',
  );
  @override
  late final GeneratedColumn<String> symptoms = GeneratedColumn<String>(
    'symptoms',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    recordDatetime,
    totalCholesterol,
    triglycerides,
    hdlCholesterol,
    ldlCholesterol,
    fastingStatus,
    lastMealTime,
    deviceInfo,
    medicationTaken,
    symptoms,
    notes,
    tags,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'blood_lipids_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<BloodLipidsRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('record_datetime')) {
      context.handle(
        _recordDatetimeMeta,
        recordDatetime.isAcceptableOrUnknown(
          data['record_datetime']!,
          _recordDatetimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recordDatetimeMeta);
    }
    if (data.containsKey('total_cholesterol')) {
      context.handle(
        _totalCholesterolMeta,
        totalCholesterol.isAcceptableOrUnknown(
          data['total_cholesterol']!,
          _totalCholesterolMeta,
        ),
      );
    }
    if (data.containsKey('triglycerides')) {
      context.handle(
        _triglyceridesMeta,
        triglycerides.isAcceptableOrUnknown(
          data['triglycerides']!,
          _triglyceridesMeta,
        ),
      );
    }
    if (data.containsKey('hdl_cholesterol')) {
      context.handle(
        _hdlCholesterolMeta,
        hdlCholesterol.isAcceptableOrUnknown(
          data['hdl_cholesterol']!,
          _hdlCholesterolMeta,
        ),
      );
    }
    if (data.containsKey('ldl_cholesterol')) {
      context.handle(
        _ldlCholesterolMeta,
        ldlCholesterol.isAcceptableOrUnknown(
          data['ldl_cholesterol']!,
          _ldlCholesterolMeta,
        ),
      );
    }
    if (data.containsKey('fasting_status')) {
      context.handle(
        _fastingStatusMeta,
        fastingStatus.isAcceptableOrUnknown(
          data['fasting_status']!,
          _fastingStatusMeta,
        ),
      );
    }
    if (data.containsKey('last_meal_time')) {
      context.handle(
        _lastMealTimeMeta,
        lastMealTime.isAcceptableOrUnknown(
          data['last_meal_time']!,
          _lastMealTimeMeta,
        ),
      );
    }
    if (data.containsKey('device_info')) {
      context.handle(
        _deviceInfoMeta,
        deviceInfo.isAcceptableOrUnknown(data['device_info']!, _deviceInfoMeta),
      );
    }
    if (data.containsKey('medication_taken')) {
      context.handle(
        _medicationTakenMeta,
        medicationTaken.isAcceptableOrUnknown(
          data['medication_taken']!,
          _medicationTakenMeta,
        ),
      );
    }
    if (data.containsKey('symptoms')) {
      context.handle(
        _symptomsMeta,
        symptoms.isAcceptableOrUnknown(data['symptoms']!, _symptomsMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BloodLipidsRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BloodLipidsRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      recordDatetime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}record_datetime'],
      )!,
      totalCholesterol: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_cholesterol'],
      ),
      triglycerides: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}triglycerides'],
      ),
      hdlCholesterol: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}hdl_cholesterol'],
      ),
      ldlCholesterol: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}ldl_cholesterol'],
      ),
      fastingStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}fasting_status'],
      )!,
      lastMealTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_meal_time'],
      ),
      deviceInfo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_info'],
      ),
      medicationTaken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}medication_taken'],
      ),
      symptoms: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}symptoms'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BloodLipidsRecordsTable createAlias(String alias) {
    return $BloodLipidsRecordsTable(attachedDatabase, alias);
  }
}

class BloodLipidsRecord extends DataClass
    implements Insertable<BloodLipidsRecord> {
  final int id;
  final String userId;
  final DateTime recordDatetime;
  final double? totalCholesterol;
  final double? triglycerides;
  final double? hdlCholesterol;
  final double? ldlCholesterol;
  final bool fastingStatus;
  final DateTime? lastMealTime;
  final String? deviceInfo;
  final String? medicationTaken;
  final String? symptoms;
  final String? notes;
  final String? tags;
  final DateTime createdAt;
  const BloodLipidsRecord({
    required this.id,
    required this.userId,
    required this.recordDatetime,
    this.totalCholesterol,
    this.triglycerides,
    this.hdlCholesterol,
    this.ldlCholesterol,
    required this.fastingStatus,
    this.lastMealTime,
    this.deviceInfo,
    this.medicationTaken,
    this.symptoms,
    this.notes,
    this.tags,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<String>(userId);
    map['record_datetime'] = Variable<DateTime>(recordDatetime);
    if (!nullToAbsent || totalCholesterol != null) {
      map['total_cholesterol'] = Variable<double>(totalCholesterol);
    }
    if (!nullToAbsent || triglycerides != null) {
      map['triglycerides'] = Variable<double>(triglycerides);
    }
    if (!nullToAbsent || hdlCholesterol != null) {
      map['hdl_cholesterol'] = Variable<double>(hdlCholesterol);
    }
    if (!nullToAbsent || ldlCholesterol != null) {
      map['ldl_cholesterol'] = Variable<double>(ldlCholesterol);
    }
    map['fasting_status'] = Variable<bool>(fastingStatus);
    if (!nullToAbsent || lastMealTime != null) {
      map['last_meal_time'] = Variable<DateTime>(lastMealTime);
    }
    if (!nullToAbsent || deviceInfo != null) {
      map['device_info'] = Variable<String>(deviceInfo);
    }
    if (!nullToAbsent || medicationTaken != null) {
      map['medication_taken'] = Variable<String>(medicationTaken);
    }
    if (!nullToAbsent || symptoms != null) {
      map['symptoms'] = Variable<String>(symptoms);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || tags != null) {
      map['tags'] = Variable<String>(tags);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BloodLipidsRecordsCompanion toCompanion(bool nullToAbsent) {
    return BloodLipidsRecordsCompanion(
      id: Value(id),
      userId: Value(userId),
      recordDatetime: Value(recordDatetime),
      totalCholesterol: totalCholesterol == null && nullToAbsent
          ? const Value.absent()
          : Value(totalCholesterol),
      triglycerides: triglycerides == null && nullToAbsent
          ? const Value.absent()
          : Value(triglycerides),
      hdlCholesterol: hdlCholesterol == null && nullToAbsent
          ? const Value.absent()
          : Value(hdlCholesterol),
      ldlCholesterol: ldlCholesterol == null && nullToAbsent
          ? const Value.absent()
          : Value(ldlCholesterol),
      fastingStatus: Value(fastingStatus),
      lastMealTime: lastMealTime == null && nullToAbsent
          ? const Value.absent()
          : Value(lastMealTime),
      deviceInfo: deviceInfo == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceInfo),
      medicationTaken: medicationTaken == null && nullToAbsent
          ? const Value.absent()
          : Value(medicationTaken),
      symptoms: symptoms == null && nullToAbsent
          ? const Value.absent()
          : Value(symptoms),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      tags: tags == null && nullToAbsent ? const Value.absent() : Value(tags),
      createdAt: Value(createdAt),
    );
  }

  factory BloodLipidsRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BloodLipidsRecord(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      recordDatetime: serializer.fromJson<DateTime>(json['recordDatetime']),
      totalCholesterol: serializer.fromJson<double?>(json['totalCholesterol']),
      triglycerides: serializer.fromJson<double?>(json['triglycerides']),
      hdlCholesterol: serializer.fromJson<double?>(json['hdlCholesterol']),
      ldlCholesterol: serializer.fromJson<double?>(json['ldlCholesterol']),
      fastingStatus: serializer.fromJson<bool>(json['fastingStatus']),
      lastMealTime: serializer.fromJson<DateTime?>(json['lastMealTime']),
      deviceInfo: serializer.fromJson<String?>(json['deviceInfo']),
      medicationTaken: serializer.fromJson<String?>(json['medicationTaken']),
      symptoms: serializer.fromJson<String?>(json['symptoms']),
      notes: serializer.fromJson<String?>(json['notes']),
      tags: serializer.fromJson<String?>(json['tags']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<String>(userId),
      'recordDatetime': serializer.toJson<DateTime>(recordDatetime),
      'totalCholesterol': serializer.toJson<double?>(totalCholesterol),
      'triglycerides': serializer.toJson<double?>(triglycerides),
      'hdlCholesterol': serializer.toJson<double?>(hdlCholesterol),
      'ldlCholesterol': serializer.toJson<double?>(ldlCholesterol),
      'fastingStatus': serializer.toJson<bool>(fastingStatus),
      'lastMealTime': serializer.toJson<DateTime?>(lastMealTime),
      'deviceInfo': serializer.toJson<String?>(deviceInfo),
      'medicationTaken': serializer.toJson<String?>(medicationTaken),
      'symptoms': serializer.toJson<String?>(symptoms),
      'notes': serializer.toJson<String?>(notes),
      'tags': serializer.toJson<String?>(tags),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  BloodLipidsRecord copyWith({
    int? id,
    String? userId,
    DateTime? recordDatetime,
    Value<double?> totalCholesterol = const Value.absent(),
    Value<double?> triglycerides = const Value.absent(),
    Value<double?> hdlCholesterol = const Value.absent(),
    Value<double?> ldlCholesterol = const Value.absent(),
    bool? fastingStatus,
    Value<DateTime?> lastMealTime = const Value.absent(),
    Value<String?> deviceInfo = const Value.absent(),
    Value<String?> medicationTaken = const Value.absent(),
    Value<String?> symptoms = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> tags = const Value.absent(),
    DateTime? createdAt,
  }) => BloodLipidsRecord(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    recordDatetime: recordDatetime ?? this.recordDatetime,
    totalCholesterol: totalCholesterol.present
        ? totalCholesterol.value
        : this.totalCholesterol,
    triglycerides: triglycerides.present
        ? triglycerides.value
        : this.triglycerides,
    hdlCholesterol: hdlCholesterol.present
        ? hdlCholesterol.value
        : this.hdlCholesterol,
    ldlCholesterol: ldlCholesterol.present
        ? ldlCholesterol.value
        : this.ldlCholesterol,
    fastingStatus: fastingStatus ?? this.fastingStatus,
    lastMealTime: lastMealTime.present ? lastMealTime.value : this.lastMealTime,
    deviceInfo: deviceInfo.present ? deviceInfo.value : this.deviceInfo,
    medicationTaken: medicationTaken.present
        ? medicationTaken.value
        : this.medicationTaken,
    symptoms: symptoms.present ? symptoms.value : this.symptoms,
    notes: notes.present ? notes.value : this.notes,
    tags: tags.present ? tags.value : this.tags,
    createdAt: createdAt ?? this.createdAt,
  );
  BloodLipidsRecord copyWithCompanion(BloodLipidsRecordsCompanion data) {
    return BloodLipidsRecord(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      recordDatetime: data.recordDatetime.present
          ? data.recordDatetime.value
          : this.recordDatetime,
      totalCholesterol: data.totalCholesterol.present
          ? data.totalCholesterol.value
          : this.totalCholesterol,
      triglycerides: data.triglycerides.present
          ? data.triglycerides.value
          : this.triglycerides,
      hdlCholesterol: data.hdlCholesterol.present
          ? data.hdlCholesterol.value
          : this.hdlCholesterol,
      ldlCholesterol: data.ldlCholesterol.present
          ? data.ldlCholesterol.value
          : this.ldlCholesterol,
      fastingStatus: data.fastingStatus.present
          ? data.fastingStatus.value
          : this.fastingStatus,
      lastMealTime: data.lastMealTime.present
          ? data.lastMealTime.value
          : this.lastMealTime,
      deviceInfo: data.deviceInfo.present
          ? data.deviceInfo.value
          : this.deviceInfo,
      medicationTaken: data.medicationTaken.present
          ? data.medicationTaken.value
          : this.medicationTaken,
      symptoms: data.symptoms.present ? data.symptoms.value : this.symptoms,
      notes: data.notes.present ? data.notes.value : this.notes,
      tags: data.tags.present ? data.tags.value : this.tags,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BloodLipidsRecord(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('recordDatetime: $recordDatetime, ')
          ..write('totalCholesterol: $totalCholesterol, ')
          ..write('triglycerides: $triglycerides, ')
          ..write('hdlCholesterol: $hdlCholesterol, ')
          ..write('ldlCholesterol: $ldlCholesterol, ')
          ..write('fastingStatus: $fastingStatus, ')
          ..write('lastMealTime: $lastMealTime, ')
          ..write('deviceInfo: $deviceInfo, ')
          ..write('medicationTaken: $medicationTaken, ')
          ..write('symptoms: $symptoms, ')
          ..write('notes: $notes, ')
          ..write('tags: $tags, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    recordDatetime,
    totalCholesterol,
    triglycerides,
    hdlCholesterol,
    ldlCholesterol,
    fastingStatus,
    lastMealTime,
    deviceInfo,
    medicationTaken,
    symptoms,
    notes,
    tags,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BloodLipidsRecord &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.recordDatetime == this.recordDatetime &&
          other.totalCholesterol == this.totalCholesterol &&
          other.triglycerides == this.triglycerides &&
          other.hdlCholesterol == this.hdlCholesterol &&
          other.ldlCholesterol == this.ldlCholesterol &&
          other.fastingStatus == this.fastingStatus &&
          other.lastMealTime == this.lastMealTime &&
          other.deviceInfo == this.deviceInfo &&
          other.medicationTaken == this.medicationTaken &&
          other.symptoms == this.symptoms &&
          other.notes == this.notes &&
          other.tags == this.tags &&
          other.createdAt == this.createdAt);
}

class BloodLipidsRecordsCompanion extends UpdateCompanion<BloodLipidsRecord> {
  final Value<int> id;
  final Value<String> userId;
  final Value<DateTime> recordDatetime;
  final Value<double?> totalCholesterol;
  final Value<double?> triglycerides;
  final Value<double?> hdlCholesterol;
  final Value<double?> ldlCholesterol;
  final Value<bool> fastingStatus;
  final Value<DateTime?> lastMealTime;
  final Value<String?> deviceInfo;
  final Value<String?> medicationTaken;
  final Value<String?> symptoms;
  final Value<String?> notes;
  final Value<String?> tags;
  final Value<DateTime> createdAt;
  const BloodLipidsRecordsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.recordDatetime = const Value.absent(),
    this.totalCholesterol = const Value.absent(),
    this.triglycerides = const Value.absent(),
    this.hdlCholesterol = const Value.absent(),
    this.ldlCholesterol = const Value.absent(),
    this.fastingStatus = const Value.absent(),
    this.lastMealTime = const Value.absent(),
    this.deviceInfo = const Value.absent(),
    this.medicationTaken = const Value.absent(),
    this.symptoms = const Value.absent(),
    this.notes = const Value.absent(),
    this.tags = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  BloodLipidsRecordsCompanion.insert({
    this.id = const Value.absent(),
    required String userId,
    required DateTime recordDatetime,
    this.totalCholesterol = const Value.absent(),
    this.triglycerides = const Value.absent(),
    this.hdlCholesterol = const Value.absent(),
    this.ldlCholesterol = const Value.absent(),
    this.fastingStatus = const Value.absent(),
    this.lastMealTime = const Value.absent(),
    this.deviceInfo = const Value.absent(),
    this.medicationTaken = const Value.absent(),
    this.symptoms = const Value.absent(),
    this.notes = const Value.absent(),
    this.tags = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : userId = Value(userId),
       recordDatetime = Value(recordDatetime);
  static Insertable<BloodLipidsRecord> custom({
    Expression<int>? id,
    Expression<String>? userId,
    Expression<DateTime>? recordDatetime,
    Expression<double>? totalCholesterol,
    Expression<double>? triglycerides,
    Expression<double>? hdlCholesterol,
    Expression<double>? ldlCholesterol,
    Expression<bool>? fastingStatus,
    Expression<DateTime>? lastMealTime,
    Expression<String>? deviceInfo,
    Expression<String>? medicationTaken,
    Expression<String>? symptoms,
    Expression<String>? notes,
    Expression<String>? tags,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (recordDatetime != null) 'record_datetime': recordDatetime,
      if (totalCholesterol != null) 'total_cholesterol': totalCholesterol,
      if (triglycerides != null) 'triglycerides': triglycerides,
      if (hdlCholesterol != null) 'hdl_cholesterol': hdlCholesterol,
      if (ldlCholesterol != null) 'ldl_cholesterol': ldlCholesterol,
      if (fastingStatus != null) 'fasting_status': fastingStatus,
      if (lastMealTime != null) 'last_meal_time': lastMealTime,
      if (deviceInfo != null) 'device_info': deviceInfo,
      if (medicationTaken != null) 'medication_taken': medicationTaken,
      if (symptoms != null) 'symptoms': symptoms,
      if (notes != null) 'notes': notes,
      if (tags != null) 'tags': tags,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  BloodLipidsRecordsCompanion copyWith({
    Value<int>? id,
    Value<String>? userId,
    Value<DateTime>? recordDatetime,
    Value<double?>? totalCholesterol,
    Value<double?>? triglycerides,
    Value<double?>? hdlCholesterol,
    Value<double?>? ldlCholesterol,
    Value<bool>? fastingStatus,
    Value<DateTime?>? lastMealTime,
    Value<String?>? deviceInfo,
    Value<String?>? medicationTaken,
    Value<String?>? symptoms,
    Value<String?>? notes,
    Value<String?>? tags,
    Value<DateTime>? createdAt,
  }) {
    return BloodLipidsRecordsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      recordDatetime: recordDatetime ?? this.recordDatetime,
      totalCholesterol: totalCholesterol ?? this.totalCholesterol,
      triglycerides: triglycerides ?? this.triglycerides,
      hdlCholesterol: hdlCholesterol ?? this.hdlCholesterol,
      ldlCholesterol: ldlCholesterol ?? this.ldlCholesterol,
      fastingStatus: fastingStatus ?? this.fastingStatus,
      lastMealTime: lastMealTime ?? this.lastMealTime,
      deviceInfo: deviceInfo ?? this.deviceInfo,
      medicationTaken: medicationTaken ?? this.medicationTaken,
      symptoms: symptoms ?? this.symptoms,
      notes: notes ?? this.notes,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (recordDatetime.present) {
      map['record_datetime'] = Variable<DateTime>(recordDatetime.value);
    }
    if (totalCholesterol.present) {
      map['total_cholesterol'] = Variable<double>(totalCholesterol.value);
    }
    if (triglycerides.present) {
      map['triglycerides'] = Variable<double>(triglycerides.value);
    }
    if (hdlCholesterol.present) {
      map['hdl_cholesterol'] = Variable<double>(hdlCholesterol.value);
    }
    if (ldlCholesterol.present) {
      map['ldl_cholesterol'] = Variable<double>(ldlCholesterol.value);
    }
    if (fastingStatus.present) {
      map['fasting_status'] = Variable<bool>(fastingStatus.value);
    }
    if (lastMealTime.present) {
      map['last_meal_time'] = Variable<DateTime>(lastMealTime.value);
    }
    if (deviceInfo.present) {
      map['device_info'] = Variable<String>(deviceInfo.value);
    }
    if (medicationTaken.present) {
      map['medication_taken'] = Variable<String>(medicationTaken.value);
    }
    if (symptoms.present) {
      map['symptoms'] = Variable<String>(symptoms.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BloodLipidsRecordsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('recordDatetime: $recordDatetime, ')
          ..write('totalCholesterol: $totalCholesterol, ')
          ..write('triglycerides: $triglycerides, ')
          ..write('hdlCholesterol: $hdlCholesterol, ')
          ..write('ldlCholesterol: $ldlCholesterol, ')
          ..write('fastingStatus: $fastingStatus, ')
          ..write('lastMealTime: $lastMealTime, ')
          ..write('deviceInfo: $deviceInfo, ')
          ..write('medicationTaken: $medicationTaken, ')
          ..write('symptoms: $symptoms, ')
          ..write('notes: $notes, ')
          ..write('tags: $tags, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ExerciseRecordsTable extends ExerciseRecords
    with TableInfo<$ExerciseRecordsTable, ExerciseRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExerciseRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
    'end_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMeta = const VerificationMeta(
    'duration',
  );
  @override
  late final GeneratedColumn<int> duration = GeneratedColumn<int>(
    'duration',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _exerciseTypeMeta = const VerificationMeta(
    'exerciseType',
  );
  @override
  late final GeneratedColumn<String> exerciseType = GeneratedColumn<String>(
    'exercise_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _exerciseNameMeta = const VerificationMeta(
    'exerciseName',
  );
  @override
  late final GeneratedColumn<String> exerciseName = GeneratedColumn<String>(
    'exercise_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _intensityMeta = const VerificationMeta(
    'intensity',
  );
  @override
  late final GeneratedColumn<String> intensity = GeneratedColumn<String>(
    'intensity',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weatherConditionMeta = const VerificationMeta(
    'weatherCondition',
  );
  @override
  late final GeneratedColumn<String> weatherCondition = GeneratedColumn<String>(
    'weather_condition',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _distanceMeta = const VerificationMeta(
    'distance',
  );
  @override
  late final GeneratedColumn<double> distance = GeneratedColumn<double>(
    'distance',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _averageSpeedMeta = const VerificationMeta(
    'averageSpeed',
  );
  @override
  late final GeneratedColumn<double> averageSpeed = GeneratedColumn<double>(
    'average_speed',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _maxSpeedMeta = const VerificationMeta(
    'maxSpeed',
  );
  @override
  late final GeneratedColumn<double> maxSpeed = GeneratedColumn<double>(
    'max_speed',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _routeDataMeta = const VerificationMeta(
    'routeData',
  );
  @override
  late final GeneratedColumn<String> routeData = GeneratedColumn<String>(
    'route_data',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _elevationMeta = const VerificationMeta(
    'elevation',
  );
  @override
  late final GeneratedColumn<double> elevation = GeneratedColumn<double>(
    'elevation',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _averageHeartRateMeta = const VerificationMeta(
    'averageHeartRate',
  );
  @override
  late final GeneratedColumn<int> averageHeartRate = GeneratedColumn<int>(
    'average_heart_rate',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _maxHeartRateMeta = const VerificationMeta(
    'maxHeartRate',
  );
  @override
  late final GeneratedColumn<int> maxHeartRate = GeneratedColumn<int>(
    'max_heart_rate',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _minHeartRateMeta = const VerificationMeta(
    'minHeartRate',
  );
  @override
  late final GeneratedColumn<int> minHeartRate = GeneratedColumn<int>(
    'min_heart_rate',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _restingHeartRateMeta = const VerificationMeta(
    'restingHeartRate',
  );
  @override
  late final GeneratedColumn<int> restingHeartRate = GeneratedColumn<int>(
    'resting_heart_rate',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hrZone1TimeMeta = const VerificationMeta(
    'hrZone1Time',
  );
  @override
  late final GeneratedColumn<int> hrZone1Time = GeneratedColumn<int>(
    'hr_zone1_time',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hrZone2TimeMeta = const VerificationMeta(
    'hrZone2Time',
  );
  @override
  late final GeneratedColumn<int> hrZone2Time = GeneratedColumn<int>(
    'hr_zone2_time',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hrZone3TimeMeta = const VerificationMeta(
    'hrZone3Time',
  );
  @override
  late final GeneratedColumn<int> hrZone3Time = GeneratedColumn<int>(
    'hr_zone3_time',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hrZone4TimeMeta = const VerificationMeta(
    'hrZone4Time',
  );
  @override
  late final GeneratedColumn<int> hrZone4Time = GeneratedColumn<int>(
    'hr_zone4_time',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hrZone5TimeMeta = const VerificationMeta(
    'hrZone5Time',
  );
  @override
  late final GeneratedColumn<int> hrZone5Time = GeneratedColumn<int>(
    'hr_zone5_time',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _exerciseSetsMeta = const VerificationMeta(
    'exerciseSets',
  );
  @override
  late final GeneratedColumn<String> exerciseSets = GeneratedColumn<String>(
    'exercise_sets',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalWeightMeta = const VerificationMeta(
    'totalWeight',
  );
  @override
  late final GeneratedColumn<double> totalWeight = GeneratedColumn<double>(
    'total_weight',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalRepsMeta = const VerificationMeta(
    'totalReps',
  );
  @override
  late final GeneratedColumn<int> totalReps = GeneratedColumn<int>(
    'total_reps',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _oneRepMaxMeta = const VerificationMeta(
    'oneRepMax',
  );
  @override
  late final GeneratedColumn<double> oneRepMax = GeneratedColumn<double>(
    'one_rep_max',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _caloriesBurnedMeta = const VerificationMeta(
    'caloriesBurned',
  );
  @override
  late final GeneratedColumn<int> caloriesBurned = GeneratedColumn<int>(
    'calories_burned',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stepsMeta = const VerificationMeta('steps');
  @override
  late final GeneratedColumn<int> steps = GeneratedColumn<int>(
    'steps',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _feelingMeta = const VerificationMeta(
    'feeling',
  );
  @override
  late final GeneratedColumn<String> feeling = GeneratedColumn<String>(
    'feeling',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _trainingLoadMeta = const VerificationMeta(
    'trainingLoad',
  );
  @override
  late final GeneratedColumn<double> trainingLoad = GeneratedColumn<double>(
    'training_load',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rpeScoreMeta = const VerificationMeta(
    'rpeScore',
  );
  @override
  late final GeneratedColumn<String> rpeScore = GeneratedColumn<String>(
    'rpe_score',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _trainingStressScoreMeta =
      const VerificationMeta('trainingStressScore');
  @override
  late final GeneratedColumn<double> trainingStressScore =
      GeneratedColumn<double>(
        'training_stress_score',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _averageCadenceMeta = const VerificationMeta(
    'averageCadence',
  );
  @override
  late final GeneratedColumn<int> averageCadence = GeneratedColumn<int>(
    'average_cadence',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _maxCadenceMeta = const VerificationMeta(
    'maxCadence',
  );
  @override
  late final GeneratedColumn<int> maxCadence = GeneratedColumn<int>(
    'max_cadence',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _strideLengthMeta = const VerificationMeta(
    'strideLength',
  );
  @override
  late final GeneratedColumn<double> strideLength = GeneratedColumn<double>(
    'stride_length',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _verticalRatioMeta = const VerificationMeta(
    'verticalRatio',
  );
  @override
  late final GeneratedColumn<double> verticalRatio = GeneratedColumn<double>(
    'vertical_ratio',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _groundContactTimeMeta = const VerificationMeta(
    'groundContactTime',
  );
  @override
  late final GeneratedColumn<double> groundContactTime =
      GeneratedColumn<double>(
        'ground_contact_time',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _temperatureMeta = const VerificationMeta(
    'temperature',
  );
  @override
  late final GeneratedColumn<double> temperature = GeneratedColumn<double>(
    'temperature',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _humidityMeta = const VerificationMeta(
    'humidity',
  );
  @override
  late final GeneratedColumn<double> humidity = GeneratedColumn<double>(
    'humidity',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sleepHoursLastNightMeta =
      const VerificationMeta('sleepHoursLastNight');
  @override
  late final GeneratedColumn<int> sleepHoursLastNight = GeneratedColumn<int>(
    'sleep_hours_last_night',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stressLevelMeta = const VerificationMeta(
    'stressLevel',
  );
  @override
  late final GeneratedColumn<int> stressLevel = GeneratedColumn<int>(
    'stress_level',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _energyLevelMeta = const VerificationMeta(
    'energyLevel',
  );
  @override
  late final GeneratedColumn<int> energyLevel = GeneratedColumn<int>(
    'energy_level',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _motivationLevelMeta = const VerificationMeta(
    'motivationLevel',
  );
  @override
  late final GeneratedColumn<int> motivationLevel = GeneratedColumn<int>(
    'motivation_level',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _equipmentMeta = const VerificationMeta(
    'equipment',
  );
  @override
  late final GeneratedColumn<String> equipment = GeneratedColumn<String>(
    'equipment',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _shoesMeta = const VerificationMeta('shoes');
  @override
  late final GeneratedColumn<String> shoes = GeneratedColumn<String>(
    'shoes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceInfoMeta = const VerificationMeta(
    'deviceInfo',
  );
  @override
  late final GeneratedColumn<String> deviceInfo = GeneratedColumn<String>(
    'device_info',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _goalsMeta = const VerificationMeta('goals');
  @override
  late final GeneratedColumn<String> goals = GeneratedColumn<String>(
    'goals',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _personalRecordMeta = const VerificationMeta(
    'personalRecord',
  );
  @override
  late final GeneratedColumn<bool> personalRecord = GeneratedColumn<bool>(
    'personal_record',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("personal_record" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _achievementsMeta = const VerificationMeta(
    'achievements',
  );
  @override
  late final GeneratedColumn<String> achievements = GeneratedColumn<String>(
    'achievements',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recoveryHeartRateMeta = const VerificationMeta(
    'recoveryHeartRate',
  );
  @override
  late final GeneratedColumn<int> recoveryHeartRate = GeneratedColumn<int>(
    'recovery_heart_rate',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recoveryScoreMeta = const VerificationMeta(
    'recoveryScore',
  );
  @override
  late final GeneratedColumn<double> recoveryScore = GeneratedColumn<double>(
    'recovery_score',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recoveryMetricsMeta = const VerificationMeta(
    'recoveryMetrics',
  );
  @override
  late final GeneratedColumn<String> recoveryMetrics = GeneratedColumn<String>(
    'recovery_metrics',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photosMeta = const VerificationMeta('photos');
  @override
  late final GeneratedColumn<String> photos = GeneratedColumn<String>(
    'photos',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    startTime,
    endTime,
    duration,
    exerciseType,
    exerciseName,
    intensity,
    location,
    weatherCondition,
    distance,
    averageSpeed,
    maxSpeed,
    routeData,
    elevation,
    averageHeartRate,
    maxHeartRate,
    minHeartRate,
    restingHeartRate,
    hrZone1Time,
    hrZone2Time,
    hrZone3Time,
    hrZone4Time,
    hrZone5Time,
    exerciseSets,
    totalWeight,
    totalReps,
    oneRepMax,
    caloriesBurned,
    steps,
    feeling,
    trainingLoad,
    rpeScore,
    trainingStressScore,
    averageCadence,
    maxCadence,
    strideLength,
    verticalRatio,
    groundContactTime,
    temperature,
    humidity,
    sleepHoursLastNight,
    stressLevel,
    energyLevel,
    motivationLevel,
    equipment,
    shoes,
    deviceInfo,
    goals,
    personalRecord,
    achievements,
    recoveryHeartRate,
    recoveryScore,
    recoveryMetrics,
    notes,
    tags,
    photos,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercise_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExerciseRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    }
    if (data.containsKey('duration')) {
      context.handle(
        _durationMeta,
        duration.isAcceptableOrUnknown(data['duration']!, _durationMeta),
      );
    }
    if (data.containsKey('exercise_type')) {
      context.handle(
        _exerciseTypeMeta,
        exerciseType.isAcceptableOrUnknown(
          data['exercise_type']!,
          _exerciseTypeMeta,
        ),
      );
    }
    if (data.containsKey('exercise_name')) {
      context.handle(
        _exerciseNameMeta,
        exerciseName.isAcceptableOrUnknown(
          data['exercise_name']!,
          _exerciseNameMeta,
        ),
      );
    }
    if (data.containsKey('intensity')) {
      context.handle(
        _intensityMeta,
        intensity.isAcceptableOrUnknown(data['intensity']!, _intensityMeta),
      );
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    }
    if (data.containsKey('weather_condition')) {
      context.handle(
        _weatherConditionMeta,
        weatherCondition.isAcceptableOrUnknown(
          data['weather_condition']!,
          _weatherConditionMeta,
        ),
      );
    }
    if (data.containsKey('distance')) {
      context.handle(
        _distanceMeta,
        distance.isAcceptableOrUnknown(data['distance']!, _distanceMeta),
      );
    }
    if (data.containsKey('average_speed')) {
      context.handle(
        _averageSpeedMeta,
        averageSpeed.isAcceptableOrUnknown(
          data['average_speed']!,
          _averageSpeedMeta,
        ),
      );
    }
    if (data.containsKey('max_speed')) {
      context.handle(
        _maxSpeedMeta,
        maxSpeed.isAcceptableOrUnknown(data['max_speed']!, _maxSpeedMeta),
      );
    }
    if (data.containsKey('route_data')) {
      context.handle(
        _routeDataMeta,
        routeData.isAcceptableOrUnknown(data['route_data']!, _routeDataMeta),
      );
    }
    if (data.containsKey('elevation')) {
      context.handle(
        _elevationMeta,
        elevation.isAcceptableOrUnknown(data['elevation']!, _elevationMeta),
      );
    }
    if (data.containsKey('average_heart_rate')) {
      context.handle(
        _averageHeartRateMeta,
        averageHeartRate.isAcceptableOrUnknown(
          data['average_heart_rate']!,
          _averageHeartRateMeta,
        ),
      );
    }
    if (data.containsKey('max_heart_rate')) {
      context.handle(
        _maxHeartRateMeta,
        maxHeartRate.isAcceptableOrUnknown(
          data['max_heart_rate']!,
          _maxHeartRateMeta,
        ),
      );
    }
    if (data.containsKey('min_heart_rate')) {
      context.handle(
        _minHeartRateMeta,
        minHeartRate.isAcceptableOrUnknown(
          data['min_heart_rate']!,
          _minHeartRateMeta,
        ),
      );
    }
    if (data.containsKey('resting_heart_rate')) {
      context.handle(
        _restingHeartRateMeta,
        restingHeartRate.isAcceptableOrUnknown(
          data['resting_heart_rate']!,
          _restingHeartRateMeta,
        ),
      );
    }
    if (data.containsKey('hr_zone1_time')) {
      context.handle(
        _hrZone1TimeMeta,
        hrZone1Time.isAcceptableOrUnknown(
          data['hr_zone1_time']!,
          _hrZone1TimeMeta,
        ),
      );
    }
    if (data.containsKey('hr_zone2_time')) {
      context.handle(
        _hrZone2TimeMeta,
        hrZone2Time.isAcceptableOrUnknown(
          data['hr_zone2_time']!,
          _hrZone2TimeMeta,
        ),
      );
    }
    if (data.containsKey('hr_zone3_time')) {
      context.handle(
        _hrZone3TimeMeta,
        hrZone3Time.isAcceptableOrUnknown(
          data['hr_zone3_time']!,
          _hrZone3TimeMeta,
        ),
      );
    }
    if (data.containsKey('hr_zone4_time')) {
      context.handle(
        _hrZone4TimeMeta,
        hrZone4Time.isAcceptableOrUnknown(
          data['hr_zone4_time']!,
          _hrZone4TimeMeta,
        ),
      );
    }
    if (data.containsKey('hr_zone5_time')) {
      context.handle(
        _hrZone5TimeMeta,
        hrZone5Time.isAcceptableOrUnknown(
          data['hr_zone5_time']!,
          _hrZone5TimeMeta,
        ),
      );
    }
    if (data.containsKey('exercise_sets')) {
      context.handle(
        _exerciseSetsMeta,
        exerciseSets.isAcceptableOrUnknown(
          data['exercise_sets']!,
          _exerciseSetsMeta,
        ),
      );
    }
    if (data.containsKey('total_weight')) {
      context.handle(
        _totalWeightMeta,
        totalWeight.isAcceptableOrUnknown(
          data['total_weight']!,
          _totalWeightMeta,
        ),
      );
    }
    if (data.containsKey('total_reps')) {
      context.handle(
        _totalRepsMeta,
        totalReps.isAcceptableOrUnknown(data['total_reps']!, _totalRepsMeta),
      );
    }
    if (data.containsKey('one_rep_max')) {
      context.handle(
        _oneRepMaxMeta,
        oneRepMax.isAcceptableOrUnknown(data['one_rep_max']!, _oneRepMaxMeta),
      );
    }
    if (data.containsKey('calories_burned')) {
      context.handle(
        _caloriesBurnedMeta,
        caloriesBurned.isAcceptableOrUnknown(
          data['calories_burned']!,
          _caloriesBurnedMeta,
        ),
      );
    }
    if (data.containsKey('steps')) {
      context.handle(
        _stepsMeta,
        steps.isAcceptableOrUnknown(data['steps']!, _stepsMeta),
      );
    }
    if (data.containsKey('feeling')) {
      context.handle(
        _feelingMeta,
        feeling.isAcceptableOrUnknown(data['feeling']!, _feelingMeta),
      );
    }
    if (data.containsKey('training_load')) {
      context.handle(
        _trainingLoadMeta,
        trainingLoad.isAcceptableOrUnknown(
          data['training_load']!,
          _trainingLoadMeta,
        ),
      );
    }
    if (data.containsKey('rpe_score')) {
      context.handle(
        _rpeScoreMeta,
        rpeScore.isAcceptableOrUnknown(data['rpe_score']!, _rpeScoreMeta),
      );
    }
    if (data.containsKey('training_stress_score')) {
      context.handle(
        _trainingStressScoreMeta,
        trainingStressScore.isAcceptableOrUnknown(
          data['training_stress_score']!,
          _trainingStressScoreMeta,
        ),
      );
    }
    if (data.containsKey('average_cadence')) {
      context.handle(
        _averageCadenceMeta,
        averageCadence.isAcceptableOrUnknown(
          data['average_cadence']!,
          _averageCadenceMeta,
        ),
      );
    }
    if (data.containsKey('max_cadence')) {
      context.handle(
        _maxCadenceMeta,
        maxCadence.isAcceptableOrUnknown(data['max_cadence']!, _maxCadenceMeta),
      );
    }
    if (data.containsKey('stride_length')) {
      context.handle(
        _strideLengthMeta,
        strideLength.isAcceptableOrUnknown(
          data['stride_length']!,
          _strideLengthMeta,
        ),
      );
    }
    if (data.containsKey('vertical_ratio')) {
      context.handle(
        _verticalRatioMeta,
        verticalRatio.isAcceptableOrUnknown(
          data['vertical_ratio']!,
          _verticalRatioMeta,
        ),
      );
    }
    if (data.containsKey('ground_contact_time')) {
      context.handle(
        _groundContactTimeMeta,
        groundContactTime.isAcceptableOrUnknown(
          data['ground_contact_time']!,
          _groundContactTimeMeta,
        ),
      );
    }
    if (data.containsKey('temperature')) {
      context.handle(
        _temperatureMeta,
        temperature.isAcceptableOrUnknown(
          data['temperature']!,
          _temperatureMeta,
        ),
      );
    }
    if (data.containsKey('humidity')) {
      context.handle(
        _humidityMeta,
        humidity.isAcceptableOrUnknown(data['humidity']!, _humidityMeta),
      );
    }
    if (data.containsKey('sleep_hours_last_night')) {
      context.handle(
        _sleepHoursLastNightMeta,
        sleepHoursLastNight.isAcceptableOrUnknown(
          data['sleep_hours_last_night']!,
          _sleepHoursLastNightMeta,
        ),
      );
    }
    if (data.containsKey('stress_level')) {
      context.handle(
        _stressLevelMeta,
        stressLevel.isAcceptableOrUnknown(
          data['stress_level']!,
          _stressLevelMeta,
        ),
      );
    }
    if (data.containsKey('energy_level')) {
      context.handle(
        _energyLevelMeta,
        energyLevel.isAcceptableOrUnknown(
          data['energy_level']!,
          _energyLevelMeta,
        ),
      );
    }
    if (data.containsKey('motivation_level')) {
      context.handle(
        _motivationLevelMeta,
        motivationLevel.isAcceptableOrUnknown(
          data['motivation_level']!,
          _motivationLevelMeta,
        ),
      );
    }
    if (data.containsKey('equipment')) {
      context.handle(
        _equipmentMeta,
        equipment.isAcceptableOrUnknown(data['equipment']!, _equipmentMeta),
      );
    }
    if (data.containsKey('shoes')) {
      context.handle(
        _shoesMeta,
        shoes.isAcceptableOrUnknown(data['shoes']!, _shoesMeta),
      );
    }
    if (data.containsKey('device_info')) {
      context.handle(
        _deviceInfoMeta,
        deviceInfo.isAcceptableOrUnknown(data['device_info']!, _deviceInfoMeta),
      );
    }
    if (data.containsKey('goals')) {
      context.handle(
        _goalsMeta,
        goals.isAcceptableOrUnknown(data['goals']!, _goalsMeta),
      );
    }
    if (data.containsKey('personal_record')) {
      context.handle(
        _personalRecordMeta,
        personalRecord.isAcceptableOrUnknown(
          data['personal_record']!,
          _personalRecordMeta,
        ),
      );
    }
    if (data.containsKey('achievements')) {
      context.handle(
        _achievementsMeta,
        achievements.isAcceptableOrUnknown(
          data['achievements']!,
          _achievementsMeta,
        ),
      );
    }
    if (data.containsKey('recovery_heart_rate')) {
      context.handle(
        _recoveryHeartRateMeta,
        recoveryHeartRate.isAcceptableOrUnknown(
          data['recovery_heart_rate']!,
          _recoveryHeartRateMeta,
        ),
      );
    }
    if (data.containsKey('recovery_score')) {
      context.handle(
        _recoveryScoreMeta,
        recoveryScore.isAcceptableOrUnknown(
          data['recovery_score']!,
          _recoveryScoreMeta,
        ),
      );
    }
    if (data.containsKey('recovery_metrics')) {
      context.handle(
        _recoveryMetricsMeta,
        recoveryMetrics.isAcceptableOrUnknown(
          data['recovery_metrics']!,
          _recoveryMetricsMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('photos')) {
      context.handle(
        _photosMeta,
        photos.isAcceptableOrUnknown(data['photos']!, _photosMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExerciseRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExerciseRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_time'],
      )!,
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_time'],
      ),
      duration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration'],
      ),
      exerciseType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_type'],
      ),
      exerciseName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_name'],
      ),
      intensity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}intensity'],
      ),
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      ),
      weatherCondition: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}weather_condition'],
      ),
      distance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}distance'],
      ),
      averageSpeed: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}average_speed'],
      ),
      maxSpeed: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}max_speed'],
      ),
      routeData: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}route_data'],
      ),
      elevation: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}elevation'],
      ),
      averageHeartRate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}average_heart_rate'],
      ),
      maxHeartRate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_heart_rate'],
      ),
      minHeartRate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}min_heart_rate'],
      ),
      restingHeartRate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}resting_heart_rate'],
      ),
      hrZone1Time: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hr_zone1_time'],
      ),
      hrZone2Time: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hr_zone2_time'],
      ),
      hrZone3Time: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hr_zone3_time'],
      ),
      hrZone4Time: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hr_zone4_time'],
      ),
      hrZone5Time: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hr_zone5_time'],
      ),
      exerciseSets: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_sets'],
      ),
      totalWeight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_weight'],
      ),
      totalReps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_reps'],
      ),
      oneRepMax: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}one_rep_max'],
      ),
      caloriesBurned: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}calories_burned'],
      ),
      steps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}steps'],
      ),
      feeling: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}feeling'],
      ),
      trainingLoad: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}training_load'],
      ),
      rpeScore: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rpe_score'],
      ),
      trainingStressScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}training_stress_score'],
      ),
      averageCadence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}average_cadence'],
      ),
      maxCadence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_cadence'],
      ),
      strideLength: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}stride_length'],
      ),
      verticalRatio: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}vertical_ratio'],
      ),
      groundContactTime: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}ground_contact_time'],
      ),
      temperature: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}temperature'],
      ),
      humidity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}humidity'],
      ),
      sleepHoursLastNight: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sleep_hours_last_night'],
      ),
      stressLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stress_level'],
      ),
      energyLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}energy_level'],
      ),
      motivationLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}motivation_level'],
      ),
      equipment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}equipment'],
      ),
      shoes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shoes'],
      ),
      deviceInfo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_info'],
      ),
      goals: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goals'],
      ),
      personalRecord: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}personal_record'],
      )!,
      achievements: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}achievements'],
      ),
      recoveryHeartRate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recovery_heart_rate'],
      ),
      recoveryScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}recovery_score'],
      ),
      recoveryMetrics: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recovery_metrics'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      ),
      photos: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photos'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ExerciseRecordsTable createAlias(String alias) {
    return $ExerciseRecordsTable(attachedDatabase, alias);
  }
}

class ExerciseRecord extends DataClass implements Insertable<ExerciseRecord> {
  final int id;
  final String userId;
  final DateTime startTime;
  final DateTime? endTime;
  final int? duration;
  final String? exerciseType;
  final String? exerciseName;
  final String? intensity;
  final String? location;
  final String? weatherCondition;
  final double? distance;
  final double? averageSpeed;
  final double? maxSpeed;
  final String? routeData;
  final double? elevation;
  final int? averageHeartRate;
  final int? maxHeartRate;
  final int? minHeartRate;
  final int? restingHeartRate;
  final int? hrZone1Time;
  final int? hrZone2Time;
  final int? hrZone3Time;
  final int? hrZone4Time;
  final int? hrZone5Time;
  final String? exerciseSets;
  final double? totalWeight;
  final int? totalReps;
  final double? oneRepMax;
  final int? caloriesBurned;
  final int? steps;
  final String? feeling;
  final double? trainingLoad;
  final String? rpeScore;
  final double? trainingStressScore;
  final int? averageCadence;
  final int? maxCadence;
  final double? strideLength;
  final double? verticalRatio;
  final double? groundContactTime;
  final double? temperature;
  final double? humidity;
  final int? sleepHoursLastNight;
  final int? stressLevel;
  final int? energyLevel;
  final int? motivationLevel;
  final String? equipment;
  final String? shoes;
  final String? deviceInfo;
  final String? goals;
  final bool personalRecord;
  final String? achievements;
  final int? recoveryHeartRate;
  final double? recoveryScore;
  final String? recoveryMetrics;
  final String? notes;
  final String? tags;
  final String? photos;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ExerciseRecord({
    required this.id,
    required this.userId,
    required this.startTime,
    this.endTime,
    this.duration,
    this.exerciseType,
    this.exerciseName,
    this.intensity,
    this.location,
    this.weatherCondition,
    this.distance,
    this.averageSpeed,
    this.maxSpeed,
    this.routeData,
    this.elevation,
    this.averageHeartRate,
    this.maxHeartRate,
    this.minHeartRate,
    this.restingHeartRate,
    this.hrZone1Time,
    this.hrZone2Time,
    this.hrZone3Time,
    this.hrZone4Time,
    this.hrZone5Time,
    this.exerciseSets,
    this.totalWeight,
    this.totalReps,
    this.oneRepMax,
    this.caloriesBurned,
    this.steps,
    this.feeling,
    this.trainingLoad,
    this.rpeScore,
    this.trainingStressScore,
    this.averageCadence,
    this.maxCadence,
    this.strideLength,
    this.verticalRatio,
    this.groundContactTime,
    this.temperature,
    this.humidity,
    this.sleepHoursLastNight,
    this.stressLevel,
    this.energyLevel,
    this.motivationLevel,
    this.equipment,
    this.shoes,
    this.deviceInfo,
    this.goals,
    required this.personalRecord,
    this.achievements,
    this.recoveryHeartRate,
    this.recoveryScore,
    this.recoveryMetrics,
    this.notes,
    this.tags,
    this.photos,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<String>(userId);
    map['start_time'] = Variable<DateTime>(startTime);
    if (!nullToAbsent || endTime != null) {
      map['end_time'] = Variable<DateTime>(endTime);
    }
    if (!nullToAbsent || duration != null) {
      map['duration'] = Variable<int>(duration);
    }
    if (!nullToAbsent || exerciseType != null) {
      map['exercise_type'] = Variable<String>(exerciseType);
    }
    if (!nullToAbsent || exerciseName != null) {
      map['exercise_name'] = Variable<String>(exerciseName);
    }
    if (!nullToAbsent || intensity != null) {
      map['intensity'] = Variable<String>(intensity);
    }
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    if (!nullToAbsent || weatherCondition != null) {
      map['weather_condition'] = Variable<String>(weatherCondition);
    }
    if (!nullToAbsent || distance != null) {
      map['distance'] = Variable<double>(distance);
    }
    if (!nullToAbsent || averageSpeed != null) {
      map['average_speed'] = Variable<double>(averageSpeed);
    }
    if (!nullToAbsent || maxSpeed != null) {
      map['max_speed'] = Variable<double>(maxSpeed);
    }
    if (!nullToAbsent || routeData != null) {
      map['route_data'] = Variable<String>(routeData);
    }
    if (!nullToAbsent || elevation != null) {
      map['elevation'] = Variable<double>(elevation);
    }
    if (!nullToAbsent || averageHeartRate != null) {
      map['average_heart_rate'] = Variable<int>(averageHeartRate);
    }
    if (!nullToAbsent || maxHeartRate != null) {
      map['max_heart_rate'] = Variable<int>(maxHeartRate);
    }
    if (!nullToAbsent || minHeartRate != null) {
      map['min_heart_rate'] = Variable<int>(minHeartRate);
    }
    if (!nullToAbsent || restingHeartRate != null) {
      map['resting_heart_rate'] = Variable<int>(restingHeartRate);
    }
    if (!nullToAbsent || hrZone1Time != null) {
      map['hr_zone1_time'] = Variable<int>(hrZone1Time);
    }
    if (!nullToAbsent || hrZone2Time != null) {
      map['hr_zone2_time'] = Variable<int>(hrZone2Time);
    }
    if (!nullToAbsent || hrZone3Time != null) {
      map['hr_zone3_time'] = Variable<int>(hrZone3Time);
    }
    if (!nullToAbsent || hrZone4Time != null) {
      map['hr_zone4_time'] = Variable<int>(hrZone4Time);
    }
    if (!nullToAbsent || hrZone5Time != null) {
      map['hr_zone5_time'] = Variable<int>(hrZone5Time);
    }
    if (!nullToAbsent || exerciseSets != null) {
      map['exercise_sets'] = Variable<String>(exerciseSets);
    }
    if (!nullToAbsent || totalWeight != null) {
      map['total_weight'] = Variable<double>(totalWeight);
    }
    if (!nullToAbsent || totalReps != null) {
      map['total_reps'] = Variable<int>(totalReps);
    }
    if (!nullToAbsent || oneRepMax != null) {
      map['one_rep_max'] = Variable<double>(oneRepMax);
    }
    if (!nullToAbsent || caloriesBurned != null) {
      map['calories_burned'] = Variable<int>(caloriesBurned);
    }
    if (!nullToAbsent || steps != null) {
      map['steps'] = Variable<int>(steps);
    }
    if (!nullToAbsent || feeling != null) {
      map['feeling'] = Variable<String>(feeling);
    }
    if (!nullToAbsent || trainingLoad != null) {
      map['training_load'] = Variable<double>(trainingLoad);
    }
    if (!nullToAbsent || rpeScore != null) {
      map['rpe_score'] = Variable<String>(rpeScore);
    }
    if (!nullToAbsent || trainingStressScore != null) {
      map['training_stress_score'] = Variable<double>(trainingStressScore);
    }
    if (!nullToAbsent || averageCadence != null) {
      map['average_cadence'] = Variable<int>(averageCadence);
    }
    if (!nullToAbsent || maxCadence != null) {
      map['max_cadence'] = Variable<int>(maxCadence);
    }
    if (!nullToAbsent || strideLength != null) {
      map['stride_length'] = Variable<double>(strideLength);
    }
    if (!nullToAbsent || verticalRatio != null) {
      map['vertical_ratio'] = Variable<double>(verticalRatio);
    }
    if (!nullToAbsent || groundContactTime != null) {
      map['ground_contact_time'] = Variable<double>(groundContactTime);
    }
    if (!nullToAbsent || temperature != null) {
      map['temperature'] = Variable<double>(temperature);
    }
    if (!nullToAbsent || humidity != null) {
      map['humidity'] = Variable<double>(humidity);
    }
    if (!nullToAbsent || sleepHoursLastNight != null) {
      map['sleep_hours_last_night'] = Variable<int>(sleepHoursLastNight);
    }
    if (!nullToAbsent || stressLevel != null) {
      map['stress_level'] = Variable<int>(stressLevel);
    }
    if (!nullToAbsent || energyLevel != null) {
      map['energy_level'] = Variable<int>(energyLevel);
    }
    if (!nullToAbsent || motivationLevel != null) {
      map['motivation_level'] = Variable<int>(motivationLevel);
    }
    if (!nullToAbsent || equipment != null) {
      map['equipment'] = Variable<String>(equipment);
    }
    if (!nullToAbsent || shoes != null) {
      map['shoes'] = Variable<String>(shoes);
    }
    if (!nullToAbsent || deviceInfo != null) {
      map['device_info'] = Variable<String>(deviceInfo);
    }
    if (!nullToAbsent || goals != null) {
      map['goals'] = Variable<String>(goals);
    }
    map['personal_record'] = Variable<bool>(personalRecord);
    if (!nullToAbsent || achievements != null) {
      map['achievements'] = Variable<String>(achievements);
    }
    if (!nullToAbsent || recoveryHeartRate != null) {
      map['recovery_heart_rate'] = Variable<int>(recoveryHeartRate);
    }
    if (!nullToAbsent || recoveryScore != null) {
      map['recovery_score'] = Variable<double>(recoveryScore);
    }
    if (!nullToAbsent || recoveryMetrics != null) {
      map['recovery_metrics'] = Variable<String>(recoveryMetrics);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || tags != null) {
      map['tags'] = Variable<String>(tags);
    }
    if (!nullToAbsent || photos != null) {
      map['photos'] = Variable<String>(photos);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ExerciseRecordsCompanion toCompanion(bool nullToAbsent) {
    return ExerciseRecordsCompanion(
      id: Value(id),
      userId: Value(userId),
      startTime: Value(startTime),
      endTime: endTime == null && nullToAbsent
          ? const Value.absent()
          : Value(endTime),
      duration: duration == null && nullToAbsent
          ? const Value.absent()
          : Value(duration),
      exerciseType: exerciseType == null && nullToAbsent
          ? const Value.absent()
          : Value(exerciseType),
      exerciseName: exerciseName == null && nullToAbsent
          ? const Value.absent()
          : Value(exerciseName),
      intensity: intensity == null && nullToAbsent
          ? const Value.absent()
          : Value(intensity),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      weatherCondition: weatherCondition == null && nullToAbsent
          ? const Value.absent()
          : Value(weatherCondition),
      distance: distance == null && nullToAbsent
          ? const Value.absent()
          : Value(distance),
      averageSpeed: averageSpeed == null && nullToAbsent
          ? const Value.absent()
          : Value(averageSpeed),
      maxSpeed: maxSpeed == null && nullToAbsent
          ? const Value.absent()
          : Value(maxSpeed),
      routeData: routeData == null && nullToAbsent
          ? const Value.absent()
          : Value(routeData),
      elevation: elevation == null && nullToAbsent
          ? const Value.absent()
          : Value(elevation),
      averageHeartRate: averageHeartRate == null && nullToAbsent
          ? const Value.absent()
          : Value(averageHeartRate),
      maxHeartRate: maxHeartRate == null && nullToAbsent
          ? const Value.absent()
          : Value(maxHeartRate),
      minHeartRate: minHeartRate == null && nullToAbsent
          ? const Value.absent()
          : Value(minHeartRate),
      restingHeartRate: restingHeartRate == null && nullToAbsent
          ? const Value.absent()
          : Value(restingHeartRate),
      hrZone1Time: hrZone1Time == null && nullToAbsent
          ? const Value.absent()
          : Value(hrZone1Time),
      hrZone2Time: hrZone2Time == null && nullToAbsent
          ? const Value.absent()
          : Value(hrZone2Time),
      hrZone3Time: hrZone3Time == null && nullToAbsent
          ? const Value.absent()
          : Value(hrZone3Time),
      hrZone4Time: hrZone4Time == null && nullToAbsent
          ? const Value.absent()
          : Value(hrZone4Time),
      hrZone5Time: hrZone5Time == null && nullToAbsent
          ? const Value.absent()
          : Value(hrZone5Time),
      exerciseSets: exerciseSets == null && nullToAbsent
          ? const Value.absent()
          : Value(exerciseSets),
      totalWeight: totalWeight == null && nullToAbsent
          ? const Value.absent()
          : Value(totalWeight),
      totalReps: totalReps == null && nullToAbsent
          ? const Value.absent()
          : Value(totalReps),
      oneRepMax: oneRepMax == null && nullToAbsent
          ? const Value.absent()
          : Value(oneRepMax),
      caloriesBurned: caloriesBurned == null && nullToAbsent
          ? const Value.absent()
          : Value(caloriesBurned),
      steps: steps == null && nullToAbsent
          ? const Value.absent()
          : Value(steps),
      feeling: feeling == null && nullToAbsent
          ? const Value.absent()
          : Value(feeling),
      trainingLoad: trainingLoad == null && nullToAbsent
          ? const Value.absent()
          : Value(trainingLoad),
      rpeScore: rpeScore == null && nullToAbsent
          ? const Value.absent()
          : Value(rpeScore),
      trainingStressScore: trainingStressScore == null && nullToAbsent
          ? const Value.absent()
          : Value(trainingStressScore),
      averageCadence: averageCadence == null && nullToAbsent
          ? const Value.absent()
          : Value(averageCadence),
      maxCadence: maxCadence == null && nullToAbsent
          ? const Value.absent()
          : Value(maxCadence),
      strideLength: strideLength == null && nullToAbsent
          ? const Value.absent()
          : Value(strideLength),
      verticalRatio: verticalRatio == null && nullToAbsent
          ? const Value.absent()
          : Value(verticalRatio),
      groundContactTime: groundContactTime == null && nullToAbsent
          ? const Value.absent()
          : Value(groundContactTime),
      temperature: temperature == null && nullToAbsent
          ? const Value.absent()
          : Value(temperature),
      humidity: humidity == null && nullToAbsent
          ? const Value.absent()
          : Value(humidity),
      sleepHoursLastNight: sleepHoursLastNight == null && nullToAbsent
          ? const Value.absent()
          : Value(sleepHoursLastNight),
      stressLevel: stressLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(stressLevel),
      energyLevel: energyLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(energyLevel),
      motivationLevel: motivationLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(motivationLevel),
      equipment: equipment == null && nullToAbsent
          ? const Value.absent()
          : Value(equipment),
      shoes: shoes == null && nullToAbsent
          ? const Value.absent()
          : Value(shoes),
      deviceInfo: deviceInfo == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceInfo),
      goals: goals == null && nullToAbsent
          ? const Value.absent()
          : Value(goals),
      personalRecord: Value(personalRecord),
      achievements: achievements == null && nullToAbsent
          ? const Value.absent()
          : Value(achievements),
      recoveryHeartRate: recoveryHeartRate == null && nullToAbsent
          ? const Value.absent()
          : Value(recoveryHeartRate),
      recoveryScore: recoveryScore == null && nullToAbsent
          ? const Value.absent()
          : Value(recoveryScore),
      recoveryMetrics: recoveryMetrics == null && nullToAbsent
          ? const Value.absent()
          : Value(recoveryMetrics),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      tags: tags == null && nullToAbsent ? const Value.absent() : Value(tags),
      photos: photos == null && nullToAbsent
          ? const Value.absent()
          : Value(photos),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ExerciseRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExerciseRecord(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime?>(json['endTime']),
      duration: serializer.fromJson<int?>(json['duration']),
      exerciseType: serializer.fromJson<String?>(json['exerciseType']),
      exerciseName: serializer.fromJson<String?>(json['exerciseName']),
      intensity: serializer.fromJson<String?>(json['intensity']),
      location: serializer.fromJson<String?>(json['location']),
      weatherCondition: serializer.fromJson<String?>(json['weatherCondition']),
      distance: serializer.fromJson<double?>(json['distance']),
      averageSpeed: serializer.fromJson<double?>(json['averageSpeed']),
      maxSpeed: serializer.fromJson<double?>(json['maxSpeed']),
      routeData: serializer.fromJson<String?>(json['routeData']),
      elevation: serializer.fromJson<double?>(json['elevation']),
      averageHeartRate: serializer.fromJson<int?>(json['averageHeartRate']),
      maxHeartRate: serializer.fromJson<int?>(json['maxHeartRate']),
      minHeartRate: serializer.fromJson<int?>(json['minHeartRate']),
      restingHeartRate: serializer.fromJson<int?>(json['restingHeartRate']),
      hrZone1Time: serializer.fromJson<int?>(json['hrZone1Time']),
      hrZone2Time: serializer.fromJson<int?>(json['hrZone2Time']),
      hrZone3Time: serializer.fromJson<int?>(json['hrZone3Time']),
      hrZone4Time: serializer.fromJson<int?>(json['hrZone4Time']),
      hrZone5Time: serializer.fromJson<int?>(json['hrZone5Time']),
      exerciseSets: serializer.fromJson<String?>(json['exerciseSets']),
      totalWeight: serializer.fromJson<double?>(json['totalWeight']),
      totalReps: serializer.fromJson<int?>(json['totalReps']),
      oneRepMax: serializer.fromJson<double?>(json['oneRepMax']),
      caloriesBurned: serializer.fromJson<int?>(json['caloriesBurned']),
      steps: serializer.fromJson<int?>(json['steps']),
      feeling: serializer.fromJson<String?>(json['feeling']),
      trainingLoad: serializer.fromJson<double?>(json['trainingLoad']),
      rpeScore: serializer.fromJson<String?>(json['rpeScore']),
      trainingStressScore: serializer.fromJson<double?>(
        json['trainingStressScore'],
      ),
      averageCadence: serializer.fromJson<int?>(json['averageCadence']),
      maxCadence: serializer.fromJson<int?>(json['maxCadence']),
      strideLength: serializer.fromJson<double?>(json['strideLength']),
      verticalRatio: serializer.fromJson<double?>(json['verticalRatio']),
      groundContactTime: serializer.fromJson<double?>(
        json['groundContactTime'],
      ),
      temperature: serializer.fromJson<double?>(json['temperature']),
      humidity: serializer.fromJson<double?>(json['humidity']),
      sleepHoursLastNight: serializer.fromJson<int?>(
        json['sleepHoursLastNight'],
      ),
      stressLevel: serializer.fromJson<int?>(json['stressLevel']),
      energyLevel: serializer.fromJson<int?>(json['energyLevel']),
      motivationLevel: serializer.fromJson<int?>(json['motivationLevel']),
      equipment: serializer.fromJson<String?>(json['equipment']),
      shoes: serializer.fromJson<String?>(json['shoes']),
      deviceInfo: serializer.fromJson<String?>(json['deviceInfo']),
      goals: serializer.fromJson<String?>(json['goals']),
      personalRecord: serializer.fromJson<bool>(json['personalRecord']),
      achievements: serializer.fromJson<String?>(json['achievements']),
      recoveryHeartRate: serializer.fromJson<int?>(json['recoveryHeartRate']),
      recoveryScore: serializer.fromJson<double?>(json['recoveryScore']),
      recoveryMetrics: serializer.fromJson<String?>(json['recoveryMetrics']),
      notes: serializer.fromJson<String?>(json['notes']),
      tags: serializer.fromJson<String?>(json['tags']),
      photos: serializer.fromJson<String?>(json['photos']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<String>(userId),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime?>(endTime),
      'duration': serializer.toJson<int?>(duration),
      'exerciseType': serializer.toJson<String?>(exerciseType),
      'exerciseName': serializer.toJson<String?>(exerciseName),
      'intensity': serializer.toJson<String?>(intensity),
      'location': serializer.toJson<String?>(location),
      'weatherCondition': serializer.toJson<String?>(weatherCondition),
      'distance': serializer.toJson<double?>(distance),
      'averageSpeed': serializer.toJson<double?>(averageSpeed),
      'maxSpeed': serializer.toJson<double?>(maxSpeed),
      'routeData': serializer.toJson<String?>(routeData),
      'elevation': serializer.toJson<double?>(elevation),
      'averageHeartRate': serializer.toJson<int?>(averageHeartRate),
      'maxHeartRate': serializer.toJson<int?>(maxHeartRate),
      'minHeartRate': serializer.toJson<int?>(minHeartRate),
      'restingHeartRate': serializer.toJson<int?>(restingHeartRate),
      'hrZone1Time': serializer.toJson<int?>(hrZone1Time),
      'hrZone2Time': serializer.toJson<int?>(hrZone2Time),
      'hrZone3Time': serializer.toJson<int?>(hrZone3Time),
      'hrZone4Time': serializer.toJson<int?>(hrZone4Time),
      'hrZone5Time': serializer.toJson<int?>(hrZone5Time),
      'exerciseSets': serializer.toJson<String?>(exerciseSets),
      'totalWeight': serializer.toJson<double?>(totalWeight),
      'totalReps': serializer.toJson<int?>(totalReps),
      'oneRepMax': serializer.toJson<double?>(oneRepMax),
      'caloriesBurned': serializer.toJson<int?>(caloriesBurned),
      'steps': serializer.toJson<int?>(steps),
      'feeling': serializer.toJson<String?>(feeling),
      'trainingLoad': serializer.toJson<double?>(trainingLoad),
      'rpeScore': serializer.toJson<String?>(rpeScore),
      'trainingStressScore': serializer.toJson<double?>(trainingStressScore),
      'averageCadence': serializer.toJson<int?>(averageCadence),
      'maxCadence': serializer.toJson<int?>(maxCadence),
      'strideLength': serializer.toJson<double?>(strideLength),
      'verticalRatio': serializer.toJson<double?>(verticalRatio),
      'groundContactTime': serializer.toJson<double?>(groundContactTime),
      'temperature': serializer.toJson<double?>(temperature),
      'humidity': serializer.toJson<double?>(humidity),
      'sleepHoursLastNight': serializer.toJson<int?>(sleepHoursLastNight),
      'stressLevel': serializer.toJson<int?>(stressLevel),
      'energyLevel': serializer.toJson<int?>(energyLevel),
      'motivationLevel': serializer.toJson<int?>(motivationLevel),
      'equipment': serializer.toJson<String?>(equipment),
      'shoes': serializer.toJson<String?>(shoes),
      'deviceInfo': serializer.toJson<String?>(deviceInfo),
      'goals': serializer.toJson<String?>(goals),
      'personalRecord': serializer.toJson<bool>(personalRecord),
      'achievements': serializer.toJson<String?>(achievements),
      'recoveryHeartRate': serializer.toJson<int?>(recoveryHeartRate),
      'recoveryScore': serializer.toJson<double?>(recoveryScore),
      'recoveryMetrics': serializer.toJson<String?>(recoveryMetrics),
      'notes': serializer.toJson<String?>(notes),
      'tags': serializer.toJson<String?>(tags),
      'photos': serializer.toJson<String?>(photos),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ExerciseRecord copyWith({
    int? id,
    String? userId,
    DateTime? startTime,
    Value<DateTime?> endTime = const Value.absent(),
    Value<int?> duration = const Value.absent(),
    Value<String?> exerciseType = const Value.absent(),
    Value<String?> exerciseName = const Value.absent(),
    Value<String?> intensity = const Value.absent(),
    Value<String?> location = const Value.absent(),
    Value<String?> weatherCondition = const Value.absent(),
    Value<double?> distance = const Value.absent(),
    Value<double?> averageSpeed = const Value.absent(),
    Value<double?> maxSpeed = const Value.absent(),
    Value<String?> routeData = const Value.absent(),
    Value<double?> elevation = const Value.absent(),
    Value<int?> averageHeartRate = const Value.absent(),
    Value<int?> maxHeartRate = const Value.absent(),
    Value<int?> minHeartRate = const Value.absent(),
    Value<int?> restingHeartRate = const Value.absent(),
    Value<int?> hrZone1Time = const Value.absent(),
    Value<int?> hrZone2Time = const Value.absent(),
    Value<int?> hrZone3Time = const Value.absent(),
    Value<int?> hrZone4Time = const Value.absent(),
    Value<int?> hrZone5Time = const Value.absent(),
    Value<String?> exerciseSets = const Value.absent(),
    Value<double?> totalWeight = const Value.absent(),
    Value<int?> totalReps = const Value.absent(),
    Value<double?> oneRepMax = const Value.absent(),
    Value<int?> caloriesBurned = const Value.absent(),
    Value<int?> steps = const Value.absent(),
    Value<String?> feeling = const Value.absent(),
    Value<double?> trainingLoad = const Value.absent(),
    Value<String?> rpeScore = const Value.absent(),
    Value<double?> trainingStressScore = const Value.absent(),
    Value<int?> averageCadence = const Value.absent(),
    Value<int?> maxCadence = const Value.absent(),
    Value<double?> strideLength = const Value.absent(),
    Value<double?> verticalRatio = const Value.absent(),
    Value<double?> groundContactTime = const Value.absent(),
    Value<double?> temperature = const Value.absent(),
    Value<double?> humidity = const Value.absent(),
    Value<int?> sleepHoursLastNight = const Value.absent(),
    Value<int?> stressLevel = const Value.absent(),
    Value<int?> energyLevel = const Value.absent(),
    Value<int?> motivationLevel = const Value.absent(),
    Value<String?> equipment = const Value.absent(),
    Value<String?> shoes = const Value.absent(),
    Value<String?> deviceInfo = const Value.absent(),
    Value<String?> goals = const Value.absent(),
    bool? personalRecord,
    Value<String?> achievements = const Value.absent(),
    Value<int?> recoveryHeartRate = const Value.absent(),
    Value<double?> recoveryScore = const Value.absent(),
    Value<String?> recoveryMetrics = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> tags = const Value.absent(),
    Value<String?> photos = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ExerciseRecord(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    startTime: startTime ?? this.startTime,
    endTime: endTime.present ? endTime.value : this.endTime,
    duration: duration.present ? duration.value : this.duration,
    exerciseType: exerciseType.present ? exerciseType.value : this.exerciseType,
    exerciseName: exerciseName.present ? exerciseName.value : this.exerciseName,
    intensity: intensity.present ? intensity.value : this.intensity,
    location: location.present ? location.value : this.location,
    weatherCondition: weatherCondition.present
        ? weatherCondition.value
        : this.weatherCondition,
    distance: distance.present ? distance.value : this.distance,
    averageSpeed: averageSpeed.present ? averageSpeed.value : this.averageSpeed,
    maxSpeed: maxSpeed.present ? maxSpeed.value : this.maxSpeed,
    routeData: routeData.present ? routeData.value : this.routeData,
    elevation: elevation.present ? elevation.value : this.elevation,
    averageHeartRate: averageHeartRate.present
        ? averageHeartRate.value
        : this.averageHeartRate,
    maxHeartRate: maxHeartRate.present ? maxHeartRate.value : this.maxHeartRate,
    minHeartRate: minHeartRate.present ? minHeartRate.value : this.minHeartRate,
    restingHeartRate: restingHeartRate.present
        ? restingHeartRate.value
        : this.restingHeartRate,
    hrZone1Time: hrZone1Time.present ? hrZone1Time.value : this.hrZone1Time,
    hrZone2Time: hrZone2Time.present ? hrZone2Time.value : this.hrZone2Time,
    hrZone3Time: hrZone3Time.present ? hrZone3Time.value : this.hrZone3Time,
    hrZone4Time: hrZone4Time.present ? hrZone4Time.value : this.hrZone4Time,
    hrZone5Time: hrZone5Time.present ? hrZone5Time.value : this.hrZone5Time,
    exerciseSets: exerciseSets.present ? exerciseSets.value : this.exerciseSets,
    totalWeight: totalWeight.present ? totalWeight.value : this.totalWeight,
    totalReps: totalReps.present ? totalReps.value : this.totalReps,
    oneRepMax: oneRepMax.present ? oneRepMax.value : this.oneRepMax,
    caloriesBurned: caloriesBurned.present
        ? caloriesBurned.value
        : this.caloriesBurned,
    steps: steps.present ? steps.value : this.steps,
    feeling: feeling.present ? feeling.value : this.feeling,
    trainingLoad: trainingLoad.present ? trainingLoad.value : this.trainingLoad,
    rpeScore: rpeScore.present ? rpeScore.value : this.rpeScore,
    trainingStressScore: trainingStressScore.present
        ? trainingStressScore.value
        : this.trainingStressScore,
    averageCadence: averageCadence.present
        ? averageCadence.value
        : this.averageCadence,
    maxCadence: maxCadence.present ? maxCadence.value : this.maxCadence,
    strideLength: strideLength.present ? strideLength.value : this.strideLength,
    verticalRatio: verticalRatio.present
        ? verticalRatio.value
        : this.verticalRatio,
    groundContactTime: groundContactTime.present
        ? groundContactTime.value
        : this.groundContactTime,
    temperature: temperature.present ? temperature.value : this.temperature,
    humidity: humidity.present ? humidity.value : this.humidity,
    sleepHoursLastNight: sleepHoursLastNight.present
        ? sleepHoursLastNight.value
        : this.sleepHoursLastNight,
    stressLevel: stressLevel.present ? stressLevel.value : this.stressLevel,
    energyLevel: energyLevel.present ? energyLevel.value : this.energyLevel,
    motivationLevel: motivationLevel.present
        ? motivationLevel.value
        : this.motivationLevel,
    equipment: equipment.present ? equipment.value : this.equipment,
    shoes: shoes.present ? shoes.value : this.shoes,
    deviceInfo: deviceInfo.present ? deviceInfo.value : this.deviceInfo,
    goals: goals.present ? goals.value : this.goals,
    personalRecord: personalRecord ?? this.personalRecord,
    achievements: achievements.present ? achievements.value : this.achievements,
    recoveryHeartRate: recoveryHeartRate.present
        ? recoveryHeartRate.value
        : this.recoveryHeartRate,
    recoveryScore: recoveryScore.present
        ? recoveryScore.value
        : this.recoveryScore,
    recoveryMetrics: recoveryMetrics.present
        ? recoveryMetrics.value
        : this.recoveryMetrics,
    notes: notes.present ? notes.value : this.notes,
    tags: tags.present ? tags.value : this.tags,
    photos: photos.present ? photos.value : this.photos,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ExerciseRecord copyWithCompanion(ExerciseRecordsCompanion data) {
    return ExerciseRecord(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      duration: data.duration.present ? data.duration.value : this.duration,
      exerciseType: data.exerciseType.present
          ? data.exerciseType.value
          : this.exerciseType,
      exerciseName: data.exerciseName.present
          ? data.exerciseName.value
          : this.exerciseName,
      intensity: data.intensity.present ? data.intensity.value : this.intensity,
      location: data.location.present ? data.location.value : this.location,
      weatherCondition: data.weatherCondition.present
          ? data.weatherCondition.value
          : this.weatherCondition,
      distance: data.distance.present ? data.distance.value : this.distance,
      averageSpeed: data.averageSpeed.present
          ? data.averageSpeed.value
          : this.averageSpeed,
      maxSpeed: data.maxSpeed.present ? data.maxSpeed.value : this.maxSpeed,
      routeData: data.routeData.present ? data.routeData.value : this.routeData,
      elevation: data.elevation.present ? data.elevation.value : this.elevation,
      averageHeartRate: data.averageHeartRate.present
          ? data.averageHeartRate.value
          : this.averageHeartRate,
      maxHeartRate: data.maxHeartRate.present
          ? data.maxHeartRate.value
          : this.maxHeartRate,
      minHeartRate: data.minHeartRate.present
          ? data.minHeartRate.value
          : this.minHeartRate,
      restingHeartRate: data.restingHeartRate.present
          ? data.restingHeartRate.value
          : this.restingHeartRate,
      hrZone1Time: data.hrZone1Time.present
          ? data.hrZone1Time.value
          : this.hrZone1Time,
      hrZone2Time: data.hrZone2Time.present
          ? data.hrZone2Time.value
          : this.hrZone2Time,
      hrZone3Time: data.hrZone3Time.present
          ? data.hrZone3Time.value
          : this.hrZone3Time,
      hrZone4Time: data.hrZone4Time.present
          ? data.hrZone4Time.value
          : this.hrZone4Time,
      hrZone5Time: data.hrZone5Time.present
          ? data.hrZone5Time.value
          : this.hrZone5Time,
      exerciseSets: data.exerciseSets.present
          ? data.exerciseSets.value
          : this.exerciseSets,
      totalWeight: data.totalWeight.present
          ? data.totalWeight.value
          : this.totalWeight,
      totalReps: data.totalReps.present ? data.totalReps.value : this.totalReps,
      oneRepMax: data.oneRepMax.present ? data.oneRepMax.value : this.oneRepMax,
      caloriesBurned: data.caloriesBurned.present
          ? data.caloriesBurned.value
          : this.caloriesBurned,
      steps: data.steps.present ? data.steps.value : this.steps,
      feeling: data.feeling.present ? data.feeling.value : this.feeling,
      trainingLoad: data.trainingLoad.present
          ? data.trainingLoad.value
          : this.trainingLoad,
      rpeScore: data.rpeScore.present ? data.rpeScore.value : this.rpeScore,
      trainingStressScore: data.trainingStressScore.present
          ? data.trainingStressScore.value
          : this.trainingStressScore,
      averageCadence: data.averageCadence.present
          ? data.averageCadence.value
          : this.averageCadence,
      maxCadence: data.maxCadence.present
          ? data.maxCadence.value
          : this.maxCadence,
      strideLength: data.strideLength.present
          ? data.strideLength.value
          : this.strideLength,
      verticalRatio: data.verticalRatio.present
          ? data.verticalRatio.value
          : this.verticalRatio,
      groundContactTime: data.groundContactTime.present
          ? data.groundContactTime.value
          : this.groundContactTime,
      temperature: data.temperature.present
          ? data.temperature.value
          : this.temperature,
      humidity: data.humidity.present ? data.humidity.value : this.humidity,
      sleepHoursLastNight: data.sleepHoursLastNight.present
          ? data.sleepHoursLastNight.value
          : this.sleepHoursLastNight,
      stressLevel: data.stressLevel.present
          ? data.stressLevel.value
          : this.stressLevel,
      energyLevel: data.energyLevel.present
          ? data.energyLevel.value
          : this.energyLevel,
      motivationLevel: data.motivationLevel.present
          ? data.motivationLevel.value
          : this.motivationLevel,
      equipment: data.equipment.present ? data.equipment.value : this.equipment,
      shoes: data.shoes.present ? data.shoes.value : this.shoes,
      deviceInfo: data.deviceInfo.present
          ? data.deviceInfo.value
          : this.deviceInfo,
      goals: data.goals.present ? data.goals.value : this.goals,
      personalRecord: data.personalRecord.present
          ? data.personalRecord.value
          : this.personalRecord,
      achievements: data.achievements.present
          ? data.achievements.value
          : this.achievements,
      recoveryHeartRate: data.recoveryHeartRate.present
          ? data.recoveryHeartRate.value
          : this.recoveryHeartRate,
      recoveryScore: data.recoveryScore.present
          ? data.recoveryScore.value
          : this.recoveryScore,
      recoveryMetrics: data.recoveryMetrics.present
          ? data.recoveryMetrics.value
          : this.recoveryMetrics,
      notes: data.notes.present ? data.notes.value : this.notes,
      tags: data.tags.present ? data.tags.value : this.tags,
      photos: data.photos.present ? data.photos.value : this.photos,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseRecord(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('duration: $duration, ')
          ..write('exerciseType: $exerciseType, ')
          ..write('exerciseName: $exerciseName, ')
          ..write('intensity: $intensity, ')
          ..write('location: $location, ')
          ..write('weatherCondition: $weatherCondition, ')
          ..write('distance: $distance, ')
          ..write('averageSpeed: $averageSpeed, ')
          ..write('maxSpeed: $maxSpeed, ')
          ..write('routeData: $routeData, ')
          ..write('elevation: $elevation, ')
          ..write('averageHeartRate: $averageHeartRate, ')
          ..write('maxHeartRate: $maxHeartRate, ')
          ..write('minHeartRate: $minHeartRate, ')
          ..write('restingHeartRate: $restingHeartRate, ')
          ..write('hrZone1Time: $hrZone1Time, ')
          ..write('hrZone2Time: $hrZone2Time, ')
          ..write('hrZone3Time: $hrZone3Time, ')
          ..write('hrZone4Time: $hrZone4Time, ')
          ..write('hrZone5Time: $hrZone5Time, ')
          ..write('exerciseSets: $exerciseSets, ')
          ..write('totalWeight: $totalWeight, ')
          ..write('totalReps: $totalReps, ')
          ..write('oneRepMax: $oneRepMax, ')
          ..write('caloriesBurned: $caloriesBurned, ')
          ..write('steps: $steps, ')
          ..write('feeling: $feeling, ')
          ..write('trainingLoad: $trainingLoad, ')
          ..write('rpeScore: $rpeScore, ')
          ..write('trainingStressScore: $trainingStressScore, ')
          ..write('averageCadence: $averageCadence, ')
          ..write('maxCadence: $maxCadence, ')
          ..write('strideLength: $strideLength, ')
          ..write('verticalRatio: $verticalRatio, ')
          ..write('groundContactTime: $groundContactTime, ')
          ..write('temperature: $temperature, ')
          ..write('humidity: $humidity, ')
          ..write('sleepHoursLastNight: $sleepHoursLastNight, ')
          ..write('stressLevel: $stressLevel, ')
          ..write('energyLevel: $energyLevel, ')
          ..write('motivationLevel: $motivationLevel, ')
          ..write('equipment: $equipment, ')
          ..write('shoes: $shoes, ')
          ..write('deviceInfo: $deviceInfo, ')
          ..write('goals: $goals, ')
          ..write('personalRecord: $personalRecord, ')
          ..write('achievements: $achievements, ')
          ..write('recoveryHeartRate: $recoveryHeartRate, ')
          ..write('recoveryScore: $recoveryScore, ')
          ..write('recoveryMetrics: $recoveryMetrics, ')
          ..write('notes: $notes, ')
          ..write('tags: $tags, ')
          ..write('photos: $photos, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    userId,
    startTime,
    endTime,
    duration,
    exerciseType,
    exerciseName,
    intensity,
    location,
    weatherCondition,
    distance,
    averageSpeed,
    maxSpeed,
    routeData,
    elevation,
    averageHeartRate,
    maxHeartRate,
    minHeartRate,
    restingHeartRate,
    hrZone1Time,
    hrZone2Time,
    hrZone3Time,
    hrZone4Time,
    hrZone5Time,
    exerciseSets,
    totalWeight,
    totalReps,
    oneRepMax,
    caloriesBurned,
    steps,
    feeling,
    trainingLoad,
    rpeScore,
    trainingStressScore,
    averageCadence,
    maxCadence,
    strideLength,
    verticalRatio,
    groundContactTime,
    temperature,
    humidity,
    sleepHoursLastNight,
    stressLevel,
    energyLevel,
    motivationLevel,
    equipment,
    shoes,
    deviceInfo,
    goals,
    personalRecord,
    achievements,
    recoveryHeartRate,
    recoveryScore,
    recoveryMetrics,
    notes,
    tags,
    photos,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExerciseRecord &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.duration == this.duration &&
          other.exerciseType == this.exerciseType &&
          other.exerciseName == this.exerciseName &&
          other.intensity == this.intensity &&
          other.location == this.location &&
          other.weatherCondition == this.weatherCondition &&
          other.distance == this.distance &&
          other.averageSpeed == this.averageSpeed &&
          other.maxSpeed == this.maxSpeed &&
          other.routeData == this.routeData &&
          other.elevation == this.elevation &&
          other.averageHeartRate == this.averageHeartRate &&
          other.maxHeartRate == this.maxHeartRate &&
          other.minHeartRate == this.minHeartRate &&
          other.restingHeartRate == this.restingHeartRate &&
          other.hrZone1Time == this.hrZone1Time &&
          other.hrZone2Time == this.hrZone2Time &&
          other.hrZone3Time == this.hrZone3Time &&
          other.hrZone4Time == this.hrZone4Time &&
          other.hrZone5Time == this.hrZone5Time &&
          other.exerciseSets == this.exerciseSets &&
          other.totalWeight == this.totalWeight &&
          other.totalReps == this.totalReps &&
          other.oneRepMax == this.oneRepMax &&
          other.caloriesBurned == this.caloriesBurned &&
          other.steps == this.steps &&
          other.feeling == this.feeling &&
          other.trainingLoad == this.trainingLoad &&
          other.rpeScore == this.rpeScore &&
          other.trainingStressScore == this.trainingStressScore &&
          other.averageCadence == this.averageCadence &&
          other.maxCadence == this.maxCadence &&
          other.strideLength == this.strideLength &&
          other.verticalRatio == this.verticalRatio &&
          other.groundContactTime == this.groundContactTime &&
          other.temperature == this.temperature &&
          other.humidity == this.humidity &&
          other.sleepHoursLastNight == this.sleepHoursLastNight &&
          other.stressLevel == this.stressLevel &&
          other.energyLevel == this.energyLevel &&
          other.motivationLevel == this.motivationLevel &&
          other.equipment == this.equipment &&
          other.shoes == this.shoes &&
          other.deviceInfo == this.deviceInfo &&
          other.goals == this.goals &&
          other.personalRecord == this.personalRecord &&
          other.achievements == this.achievements &&
          other.recoveryHeartRate == this.recoveryHeartRate &&
          other.recoveryScore == this.recoveryScore &&
          other.recoveryMetrics == this.recoveryMetrics &&
          other.notes == this.notes &&
          other.tags == this.tags &&
          other.photos == this.photos &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ExerciseRecordsCompanion extends UpdateCompanion<ExerciseRecord> {
  final Value<int> id;
  final Value<String> userId;
  final Value<DateTime> startTime;
  final Value<DateTime?> endTime;
  final Value<int?> duration;
  final Value<String?> exerciseType;
  final Value<String?> exerciseName;
  final Value<String?> intensity;
  final Value<String?> location;
  final Value<String?> weatherCondition;
  final Value<double?> distance;
  final Value<double?> averageSpeed;
  final Value<double?> maxSpeed;
  final Value<String?> routeData;
  final Value<double?> elevation;
  final Value<int?> averageHeartRate;
  final Value<int?> maxHeartRate;
  final Value<int?> minHeartRate;
  final Value<int?> restingHeartRate;
  final Value<int?> hrZone1Time;
  final Value<int?> hrZone2Time;
  final Value<int?> hrZone3Time;
  final Value<int?> hrZone4Time;
  final Value<int?> hrZone5Time;
  final Value<String?> exerciseSets;
  final Value<double?> totalWeight;
  final Value<int?> totalReps;
  final Value<double?> oneRepMax;
  final Value<int?> caloriesBurned;
  final Value<int?> steps;
  final Value<String?> feeling;
  final Value<double?> trainingLoad;
  final Value<String?> rpeScore;
  final Value<double?> trainingStressScore;
  final Value<int?> averageCadence;
  final Value<int?> maxCadence;
  final Value<double?> strideLength;
  final Value<double?> verticalRatio;
  final Value<double?> groundContactTime;
  final Value<double?> temperature;
  final Value<double?> humidity;
  final Value<int?> sleepHoursLastNight;
  final Value<int?> stressLevel;
  final Value<int?> energyLevel;
  final Value<int?> motivationLevel;
  final Value<String?> equipment;
  final Value<String?> shoes;
  final Value<String?> deviceInfo;
  final Value<String?> goals;
  final Value<bool> personalRecord;
  final Value<String?> achievements;
  final Value<int?> recoveryHeartRate;
  final Value<double?> recoveryScore;
  final Value<String?> recoveryMetrics;
  final Value<String?> notes;
  final Value<String?> tags;
  final Value<String?> photos;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ExerciseRecordsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.duration = const Value.absent(),
    this.exerciseType = const Value.absent(),
    this.exerciseName = const Value.absent(),
    this.intensity = const Value.absent(),
    this.location = const Value.absent(),
    this.weatherCondition = const Value.absent(),
    this.distance = const Value.absent(),
    this.averageSpeed = const Value.absent(),
    this.maxSpeed = const Value.absent(),
    this.routeData = const Value.absent(),
    this.elevation = const Value.absent(),
    this.averageHeartRate = const Value.absent(),
    this.maxHeartRate = const Value.absent(),
    this.minHeartRate = const Value.absent(),
    this.restingHeartRate = const Value.absent(),
    this.hrZone1Time = const Value.absent(),
    this.hrZone2Time = const Value.absent(),
    this.hrZone3Time = const Value.absent(),
    this.hrZone4Time = const Value.absent(),
    this.hrZone5Time = const Value.absent(),
    this.exerciseSets = const Value.absent(),
    this.totalWeight = const Value.absent(),
    this.totalReps = const Value.absent(),
    this.oneRepMax = const Value.absent(),
    this.caloriesBurned = const Value.absent(),
    this.steps = const Value.absent(),
    this.feeling = const Value.absent(),
    this.trainingLoad = const Value.absent(),
    this.rpeScore = const Value.absent(),
    this.trainingStressScore = const Value.absent(),
    this.averageCadence = const Value.absent(),
    this.maxCadence = const Value.absent(),
    this.strideLength = const Value.absent(),
    this.verticalRatio = const Value.absent(),
    this.groundContactTime = const Value.absent(),
    this.temperature = const Value.absent(),
    this.humidity = const Value.absent(),
    this.sleepHoursLastNight = const Value.absent(),
    this.stressLevel = const Value.absent(),
    this.energyLevel = const Value.absent(),
    this.motivationLevel = const Value.absent(),
    this.equipment = const Value.absent(),
    this.shoes = const Value.absent(),
    this.deviceInfo = const Value.absent(),
    this.goals = const Value.absent(),
    this.personalRecord = const Value.absent(),
    this.achievements = const Value.absent(),
    this.recoveryHeartRate = const Value.absent(),
    this.recoveryScore = const Value.absent(),
    this.recoveryMetrics = const Value.absent(),
    this.notes = const Value.absent(),
    this.tags = const Value.absent(),
    this.photos = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ExerciseRecordsCompanion.insert({
    this.id = const Value.absent(),
    required String userId,
    required DateTime startTime,
    this.endTime = const Value.absent(),
    this.duration = const Value.absent(),
    this.exerciseType = const Value.absent(),
    this.exerciseName = const Value.absent(),
    this.intensity = const Value.absent(),
    this.location = const Value.absent(),
    this.weatherCondition = const Value.absent(),
    this.distance = const Value.absent(),
    this.averageSpeed = const Value.absent(),
    this.maxSpeed = const Value.absent(),
    this.routeData = const Value.absent(),
    this.elevation = const Value.absent(),
    this.averageHeartRate = const Value.absent(),
    this.maxHeartRate = const Value.absent(),
    this.minHeartRate = const Value.absent(),
    this.restingHeartRate = const Value.absent(),
    this.hrZone1Time = const Value.absent(),
    this.hrZone2Time = const Value.absent(),
    this.hrZone3Time = const Value.absent(),
    this.hrZone4Time = const Value.absent(),
    this.hrZone5Time = const Value.absent(),
    this.exerciseSets = const Value.absent(),
    this.totalWeight = const Value.absent(),
    this.totalReps = const Value.absent(),
    this.oneRepMax = const Value.absent(),
    this.caloriesBurned = const Value.absent(),
    this.steps = const Value.absent(),
    this.feeling = const Value.absent(),
    this.trainingLoad = const Value.absent(),
    this.rpeScore = const Value.absent(),
    this.trainingStressScore = const Value.absent(),
    this.averageCadence = const Value.absent(),
    this.maxCadence = const Value.absent(),
    this.strideLength = const Value.absent(),
    this.verticalRatio = const Value.absent(),
    this.groundContactTime = const Value.absent(),
    this.temperature = const Value.absent(),
    this.humidity = const Value.absent(),
    this.sleepHoursLastNight = const Value.absent(),
    this.stressLevel = const Value.absent(),
    this.energyLevel = const Value.absent(),
    this.motivationLevel = const Value.absent(),
    this.equipment = const Value.absent(),
    this.shoes = const Value.absent(),
    this.deviceInfo = const Value.absent(),
    this.goals = const Value.absent(),
    this.personalRecord = const Value.absent(),
    this.achievements = const Value.absent(),
    this.recoveryHeartRate = const Value.absent(),
    this.recoveryScore = const Value.absent(),
    this.recoveryMetrics = const Value.absent(),
    this.notes = const Value.absent(),
    this.tags = const Value.absent(),
    this.photos = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : userId = Value(userId),
       startTime = Value(startTime);
  static Insertable<ExerciseRecord> custom({
    Expression<int>? id,
    Expression<String>? userId,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<int>? duration,
    Expression<String>? exerciseType,
    Expression<String>? exerciseName,
    Expression<String>? intensity,
    Expression<String>? location,
    Expression<String>? weatherCondition,
    Expression<double>? distance,
    Expression<double>? averageSpeed,
    Expression<double>? maxSpeed,
    Expression<String>? routeData,
    Expression<double>? elevation,
    Expression<int>? averageHeartRate,
    Expression<int>? maxHeartRate,
    Expression<int>? minHeartRate,
    Expression<int>? restingHeartRate,
    Expression<int>? hrZone1Time,
    Expression<int>? hrZone2Time,
    Expression<int>? hrZone3Time,
    Expression<int>? hrZone4Time,
    Expression<int>? hrZone5Time,
    Expression<String>? exerciseSets,
    Expression<double>? totalWeight,
    Expression<int>? totalReps,
    Expression<double>? oneRepMax,
    Expression<int>? caloriesBurned,
    Expression<int>? steps,
    Expression<String>? feeling,
    Expression<double>? trainingLoad,
    Expression<String>? rpeScore,
    Expression<double>? trainingStressScore,
    Expression<int>? averageCadence,
    Expression<int>? maxCadence,
    Expression<double>? strideLength,
    Expression<double>? verticalRatio,
    Expression<double>? groundContactTime,
    Expression<double>? temperature,
    Expression<double>? humidity,
    Expression<int>? sleepHoursLastNight,
    Expression<int>? stressLevel,
    Expression<int>? energyLevel,
    Expression<int>? motivationLevel,
    Expression<String>? equipment,
    Expression<String>? shoes,
    Expression<String>? deviceInfo,
    Expression<String>? goals,
    Expression<bool>? personalRecord,
    Expression<String>? achievements,
    Expression<int>? recoveryHeartRate,
    Expression<double>? recoveryScore,
    Expression<String>? recoveryMetrics,
    Expression<String>? notes,
    Expression<String>? tags,
    Expression<String>? photos,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (duration != null) 'duration': duration,
      if (exerciseType != null) 'exercise_type': exerciseType,
      if (exerciseName != null) 'exercise_name': exerciseName,
      if (intensity != null) 'intensity': intensity,
      if (location != null) 'location': location,
      if (weatherCondition != null) 'weather_condition': weatherCondition,
      if (distance != null) 'distance': distance,
      if (averageSpeed != null) 'average_speed': averageSpeed,
      if (maxSpeed != null) 'max_speed': maxSpeed,
      if (routeData != null) 'route_data': routeData,
      if (elevation != null) 'elevation': elevation,
      if (averageHeartRate != null) 'average_heart_rate': averageHeartRate,
      if (maxHeartRate != null) 'max_heart_rate': maxHeartRate,
      if (minHeartRate != null) 'min_heart_rate': minHeartRate,
      if (restingHeartRate != null) 'resting_heart_rate': restingHeartRate,
      if (hrZone1Time != null) 'hr_zone1_time': hrZone1Time,
      if (hrZone2Time != null) 'hr_zone2_time': hrZone2Time,
      if (hrZone3Time != null) 'hr_zone3_time': hrZone3Time,
      if (hrZone4Time != null) 'hr_zone4_time': hrZone4Time,
      if (hrZone5Time != null) 'hr_zone5_time': hrZone5Time,
      if (exerciseSets != null) 'exercise_sets': exerciseSets,
      if (totalWeight != null) 'total_weight': totalWeight,
      if (totalReps != null) 'total_reps': totalReps,
      if (oneRepMax != null) 'one_rep_max': oneRepMax,
      if (caloriesBurned != null) 'calories_burned': caloriesBurned,
      if (steps != null) 'steps': steps,
      if (feeling != null) 'feeling': feeling,
      if (trainingLoad != null) 'training_load': trainingLoad,
      if (rpeScore != null) 'rpe_score': rpeScore,
      if (trainingStressScore != null)
        'training_stress_score': trainingStressScore,
      if (averageCadence != null) 'average_cadence': averageCadence,
      if (maxCadence != null) 'max_cadence': maxCadence,
      if (strideLength != null) 'stride_length': strideLength,
      if (verticalRatio != null) 'vertical_ratio': verticalRatio,
      if (groundContactTime != null) 'ground_contact_time': groundContactTime,
      if (temperature != null) 'temperature': temperature,
      if (humidity != null) 'humidity': humidity,
      if (sleepHoursLastNight != null)
        'sleep_hours_last_night': sleepHoursLastNight,
      if (stressLevel != null) 'stress_level': stressLevel,
      if (energyLevel != null) 'energy_level': energyLevel,
      if (motivationLevel != null) 'motivation_level': motivationLevel,
      if (equipment != null) 'equipment': equipment,
      if (shoes != null) 'shoes': shoes,
      if (deviceInfo != null) 'device_info': deviceInfo,
      if (goals != null) 'goals': goals,
      if (personalRecord != null) 'personal_record': personalRecord,
      if (achievements != null) 'achievements': achievements,
      if (recoveryHeartRate != null) 'recovery_heart_rate': recoveryHeartRate,
      if (recoveryScore != null) 'recovery_score': recoveryScore,
      if (recoveryMetrics != null) 'recovery_metrics': recoveryMetrics,
      if (notes != null) 'notes': notes,
      if (tags != null) 'tags': tags,
      if (photos != null) 'photos': photos,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ExerciseRecordsCompanion copyWith({
    Value<int>? id,
    Value<String>? userId,
    Value<DateTime>? startTime,
    Value<DateTime?>? endTime,
    Value<int?>? duration,
    Value<String?>? exerciseType,
    Value<String?>? exerciseName,
    Value<String?>? intensity,
    Value<String?>? location,
    Value<String?>? weatherCondition,
    Value<double?>? distance,
    Value<double?>? averageSpeed,
    Value<double?>? maxSpeed,
    Value<String?>? routeData,
    Value<double?>? elevation,
    Value<int?>? averageHeartRate,
    Value<int?>? maxHeartRate,
    Value<int?>? minHeartRate,
    Value<int?>? restingHeartRate,
    Value<int?>? hrZone1Time,
    Value<int?>? hrZone2Time,
    Value<int?>? hrZone3Time,
    Value<int?>? hrZone4Time,
    Value<int?>? hrZone5Time,
    Value<String?>? exerciseSets,
    Value<double?>? totalWeight,
    Value<int?>? totalReps,
    Value<double?>? oneRepMax,
    Value<int?>? caloriesBurned,
    Value<int?>? steps,
    Value<String?>? feeling,
    Value<double?>? trainingLoad,
    Value<String?>? rpeScore,
    Value<double?>? trainingStressScore,
    Value<int?>? averageCadence,
    Value<int?>? maxCadence,
    Value<double?>? strideLength,
    Value<double?>? verticalRatio,
    Value<double?>? groundContactTime,
    Value<double?>? temperature,
    Value<double?>? humidity,
    Value<int?>? sleepHoursLastNight,
    Value<int?>? stressLevel,
    Value<int?>? energyLevel,
    Value<int?>? motivationLevel,
    Value<String?>? equipment,
    Value<String?>? shoes,
    Value<String?>? deviceInfo,
    Value<String?>? goals,
    Value<bool>? personalRecord,
    Value<String?>? achievements,
    Value<int?>? recoveryHeartRate,
    Value<double?>? recoveryScore,
    Value<String?>? recoveryMetrics,
    Value<String?>? notes,
    Value<String?>? tags,
    Value<String?>? photos,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ExerciseRecordsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      duration: duration ?? this.duration,
      exerciseType: exerciseType ?? this.exerciseType,
      exerciseName: exerciseName ?? this.exerciseName,
      intensity: intensity ?? this.intensity,
      location: location ?? this.location,
      weatherCondition: weatherCondition ?? this.weatherCondition,
      distance: distance ?? this.distance,
      averageSpeed: averageSpeed ?? this.averageSpeed,
      maxSpeed: maxSpeed ?? this.maxSpeed,
      routeData: routeData ?? this.routeData,
      elevation: elevation ?? this.elevation,
      averageHeartRate: averageHeartRate ?? this.averageHeartRate,
      maxHeartRate: maxHeartRate ?? this.maxHeartRate,
      minHeartRate: minHeartRate ?? this.minHeartRate,
      restingHeartRate: restingHeartRate ?? this.restingHeartRate,
      hrZone1Time: hrZone1Time ?? this.hrZone1Time,
      hrZone2Time: hrZone2Time ?? this.hrZone2Time,
      hrZone3Time: hrZone3Time ?? this.hrZone3Time,
      hrZone4Time: hrZone4Time ?? this.hrZone4Time,
      hrZone5Time: hrZone5Time ?? this.hrZone5Time,
      exerciseSets: exerciseSets ?? this.exerciseSets,
      totalWeight: totalWeight ?? this.totalWeight,
      totalReps: totalReps ?? this.totalReps,
      oneRepMax: oneRepMax ?? this.oneRepMax,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      steps: steps ?? this.steps,
      feeling: feeling ?? this.feeling,
      trainingLoad: trainingLoad ?? this.trainingLoad,
      rpeScore: rpeScore ?? this.rpeScore,
      trainingStressScore: trainingStressScore ?? this.trainingStressScore,
      averageCadence: averageCadence ?? this.averageCadence,
      maxCadence: maxCadence ?? this.maxCadence,
      strideLength: strideLength ?? this.strideLength,
      verticalRatio: verticalRatio ?? this.verticalRatio,
      groundContactTime: groundContactTime ?? this.groundContactTime,
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      sleepHoursLastNight: sleepHoursLastNight ?? this.sleepHoursLastNight,
      stressLevel: stressLevel ?? this.stressLevel,
      energyLevel: energyLevel ?? this.energyLevel,
      motivationLevel: motivationLevel ?? this.motivationLevel,
      equipment: equipment ?? this.equipment,
      shoes: shoes ?? this.shoes,
      deviceInfo: deviceInfo ?? this.deviceInfo,
      goals: goals ?? this.goals,
      personalRecord: personalRecord ?? this.personalRecord,
      achievements: achievements ?? this.achievements,
      recoveryHeartRate: recoveryHeartRate ?? this.recoveryHeartRate,
      recoveryScore: recoveryScore ?? this.recoveryScore,
      recoveryMetrics: recoveryMetrics ?? this.recoveryMetrics,
      notes: notes ?? this.notes,
      tags: tags ?? this.tags,
      photos: photos ?? this.photos,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (duration.present) {
      map['duration'] = Variable<int>(duration.value);
    }
    if (exerciseType.present) {
      map['exercise_type'] = Variable<String>(exerciseType.value);
    }
    if (exerciseName.present) {
      map['exercise_name'] = Variable<String>(exerciseName.value);
    }
    if (intensity.present) {
      map['intensity'] = Variable<String>(intensity.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (weatherCondition.present) {
      map['weather_condition'] = Variable<String>(weatherCondition.value);
    }
    if (distance.present) {
      map['distance'] = Variable<double>(distance.value);
    }
    if (averageSpeed.present) {
      map['average_speed'] = Variable<double>(averageSpeed.value);
    }
    if (maxSpeed.present) {
      map['max_speed'] = Variable<double>(maxSpeed.value);
    }
    if (routeData.present) {
      map['route_data'] = Variable<String>(routeData.value);
    }
    if (elevation.present) {
      map['elevation'] = Variable<double>(elevation.value);
    }
    if (averageHeartRate.present) {
      map['average_heart_rate'] = Variable<int>(averageHeartRate.value);
    }
    if (maxHeartRate.present) {
      map['max_heart_rate'] = Variable<int>(maxHeartRate.value);
    }
    if (minHeartRate.present) {
      map['min_heart_rate'] = Variable<int>(minHeartRate.value);
    }
    if (restingHeartRate.present) {
      map['resting_heart_rate'] = Variable<int>(restingHeartRate.value);
    }
    if (hrZone1Time.present) {
      map['hr_zone1_time'] = Variable<int>(hrZone1Time.value);
    }
    if (hrZone2Time.present) {
      map['hr_zone2_time'] = Variable<int>(hrZone2Time.value);
    }
    if (hrZone3Time.present) {
      map['hr_zone3_time'] = Variable<int>(hrZone3Time.value);
    }
    if (hrZone4Time.present) {
      map['hr_zone4_time'] = Variable<int>(hrZone4Time.value);
    }
    if (hrZone5Time.present) {
      map['hr_zone5_time'] = Variable<int>(hrZone5Time.value);
    }
    if (exerciseSets.present) {
      map['exercise_sets'] = Variable<String>(exerciseSets.value);
    }
    if (totalWeight.present) {
      map['total_weight'] = Variable<double>(totalWeight.value);
    }
    if (totalReps.present) {
      map['total_reps'] = Variable<int>(totalReps.value);
    }
    if (oneRepMax.present) {
      map['one_rep_max'] = Variable<double>(oneRepMax.value);
    }
    if (caloriesBurned.present) {
      map['calories_burned'] = Variable<int>(caloriesBurned.value);
    }
    if (steps.present) {
      map['steps'] = Variable<int>(steps.value);
    }
    if (feeling.present) {
      map['feeling'] = Variable<String>(feeling.value);
    }
    if (trainingLoad.present) {
      map['training_load'] = Variable<double>(trainingLoad.value);
    }
    if (rpeScore.present) {
      map['rpe_score'] = Variable<String>(rpeScore.value);
    }
    if (trainingStressScore.present) {
      map['training_stress_score'] = Variable<double>(
        trainingStressScore.value,
      );
    }
    if (averageCadence.present) {
      map['average_cadence'] = Variable<int>(averageCadence.value);
    }
    if (maxCadence.present) {
      map['max_cadence'] = Variable<int>(maxCadence.value);
    }
    if (strideLength.present) {
      map['stride_length'] = Variable<double>(strideLength.value);
    }
    if (verticalRatio.present) {
      map['vertical_ratio'] = Variable<double>(verticalRatio.value);
    }
    if (groundContactTime.present) {
      map['ground_contact_time'] = Variable<double>(groundContactTime.value);
    }
    if (temperature.present) {
      map['temperature'] = Variable<double>(temperature.value);
    }
    if (humidity.present) {
      map['humidity'] = Variable<double>(humidity.value);
    }
    if (sleepHoursLastNight.present) {
      map['sleep_hours_last_night'] = Variable<int>(sleepHoursLastNight.value);
    }
    if (stressLevel.present) {
      map['stress_level'] = Variable<int>(stressLevel.value);
    }
    if (energyLevel.present) {
      map['energy_level'] = Variable<int>(energyLevel.value);
    }
    if (motivationLevel.present) {
      map['motivation_level'] = Variable<int>(motivationLevel.value);
    }
    if (equipment.present) {
      map['equipment'] = Variable<String>(equipment.value);
    }
    if (shoes.present) {
      map['shoes'] = Variable<String>(shoes.value);
    }
    if (deviceInfo.present) {
      map['device_info'] = Variable<String>(deviceInfo.value);
    }
    if (goals.present) {
      map['goals'] = Variable<String>(goals.value);
    }
    if (personalRecord.present) {
      map['personal_record'] = Variable<bool>(personalRecord.value);
    }
    if (achievements.present) {
      map['achievements'] = Variable<String>(achievements.value);
    }
    if (recoveryHeartRate.present) {
      map['recovery_heart_rate'] = Variable<int>(recoveryHeartRate.value);
    }
    if (recoveryScore.present) {
      map['recovery_score'] = Variable<double>(recoveryScore.value);
    }
    if (recoveryMetrics.present) {
      map['recovery_metrics'] = Variable<String>(recoveryMetrics.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (photos.present) {
      map['photos'] = Variable<String>(photos.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseRecordsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('duration: $duration, ')
          ..write('exerciseType: $exerciseType, ')
          ..write('exerciseName: $exerciseName, ')
          ..write('intensity: $intensity, ')
          ..write('location: $location, ')
          ..write('weatherCondition: $weatherCondition, ')
          ..write('distance: $distance, ')
          ..write('averageSpeed: $averageSpeed, ')
          ..write('maxSpeed: $maxSpeed, ')
          ..write('routeData: $routeData, ')
          ..write('elevation: $elevation, ')
          ..write('averageHeartRate: $averageHeartRate, ')
          ..write('maxHeartRate: $maxHeartRate, ')
          ..write('minHeartRate: $minHeartRate, ')
          ..write('restingHeartRate: $restingHeartRate, ')
          ..write('hrZone1Time: $hrZone1Time, ')
          ..write('hrZone2Time: $hrZone2Time, ')
          ..write('hrZone3Time: $hrZone3Time, ')
          ..write('hrZone4Time: $hrZone4Time, ')
          ..write('hrZone5Time: $hrZone5Time, ')
          ..write('exerciseSets: $exerciseSets, ')
          ..write('totalWeight: $totalWeight, ')
          ..write('totalReps: $totalReps, ')
          ..write('oneRepMax: $oneRepMax, ')
          ..write('caloriesBurned: $caloriesBurned, ')
          ..write('steps: $steps, ')
          ..write('feeling: $feeling, ')
          ..write('trainingLoad: $trainingLoad, ')
          ..write('rpeScore: $rpeScore, ')
          ..write('trainingStressScore: $trainingStressScore, ')
          ..write('averageCadence: $averageCadence, ')
          ..write('maxCadence: $maxCadence, ')
          ..write('strideLength: $strideLength, ')
          ..write('verticalRatio: $verticalRatio, ')
          ..write('groundContactTime: $groundContactTime, ')
          ..write('temperature: $temperature, ')
          ..write('humidity: $humidity, ')
          ..write('sleepHoursLastNight: $sleepHoursLastNight, ')
          ..write('stressLevel: $stressLevel, ')
          ..write('energyLevel: $energyLevel, ')
          ..write('motivationLevel: $motivationLevel, ')
          ..write('equipment: $equipment, ')
          ..write('shoes: $shoes, ')
          ..write('deviceInfo: $deviceInfo, ')
          ..write('goals: $goals, ')
          ..write('personalRecord: $personalRecord, ')
          ..write('achievements: $achievements, ')
          ..write('recoveryHeartRate: $recoveryHeartRate, ')
          ..write('recoveryScore: $recoveryScore, ')
          ..write('recoveryMetrics: $recoveryMetrics, ')
          ..write('notes: $notes, ')
          ..write('tags: $tags, ')
          ..write('photos: $photos, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $FastingRecordsTable extends FastingRecords
    with TableInfo<$FastingRecordsTable, FastingRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FastingRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _planTypeMeta = const VerificationMeta(
    'planType',
  );
  @override
  late final GeneratedColumn<String> planType = GeneratedColumn<String>(
    'plan_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
    'end_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMeta = const VerificationMeta(
    'duration',
  );
  @override
  late final GeneratedColumn<int> duration = GeneratedColumn<int>(
    'duration',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetHoursMeta = const VerificationMeta(
    'targetHours',
  );
  @override
  late final GeneratedColumn<int> targetHours = GeneratedColumn<int>(
    'target_hours',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    planType,
    startTime,
    endTime,
    duration,
    targetHours,
    status,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fasting_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<FastingRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('plan_type')) {
      context.handle(
        _planTypeMeta,
        planType.isAcceptableOrUnknown(data['plan_type']!, _planTypeMeta),
      );
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    }
    if (data.containsKey('duration')) {
      context.handle(
        _durationMeta,
        duration.isAcceptableOrUnknown(data['duration']!, _durationMeta),
      );
    }
    if (data.containsKey('target_hours')) {
      context.handle(
        _targetHoursMeta,
        targetHours.isAcceptableOrUnknown(
          data['target_hours']!,
          _targetHoursMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FastingRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FastingRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      planType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_type'],
      ),
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_time'],
      )!,
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_time'],
      ),
      duration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration'],
      ),
      targetHours: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_hours'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}status'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $FastingRecordsTable createAlias(String alias) {
    return $FastingRecordsTable(attachedDatabase, alias);
  }
}

class FastingRecord extends DataClass implements Insertable<FastingRecord> {
  final int id;
  final String userId;
  final String? planType;
  final DateTime startTime;
  final DateTime? endTime;
  final int? duration;
  final int? targetHours;
  final int status;
  final String? notes;
  final DateTime createdAt;
  const FastingRecord({
    required this.id,
    required this.userId,
    this.planType,
    required this.startTime,
    this.endTime,
    this.duration,
    this.targetHours,
    required this.status,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || planType != null) {
      map['plan_type'] = Variable<String>(planType);
    }
    map['start_time'] = Variable<DateTime>(startTime);
    if (!nullToAbsent || endTime != null) {
      map['end_time'] = Variable<DateTime>(endTime);
    }
    if (!nullToAbsent || duration != null) {
      map['duration'] = Variable<int>(duration);
    }
    if (!nullToAbsent || targetHours != null) {
      map['target_hours'] = Variable<int>(targetHours);
    }
    map['status'] = Variable<int>(status);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FastingRecordsCompanion toCompanion(bool nullToAbsent) {
    return FastingRecordsCompanion(
      id: Value(id),
      userId: Value(userId),
      planType: planType == null && nullToAbsent
          ? const Value.absent()
          : Value(planType),
      startTime: Value(startTime),
      endTime: endTime == null && nullToAbsent
          ? const Value.absent()
          : Value(endTime),
      duration: duration == null && nullToAbsent
          ? const Value.absent()
          : Value(duration),
      targetHours: targetHours == null && nullToAbsent
          ? const Value.absent()
          : Value(targetHours),
      status: Value(status),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory FastingRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FastingRecord(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      planType: serializer.fromJson<String?>(json['planType']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime?>(json['endTime']),
      duration: serializer.fromJson<int?>(json['duration']),
      targetHours: serializer.fromJson<int?>(json['targetHours']),
      status: serializer.fromJson<int>(json['status']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<String>(userId),
      'planType': serializer.toJson<String?>(planType),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime?>(endTime),
      'duration': serializer.toJson<int?>(duration),
      'targetHours': serializer.toJson<int?>(targetHours),
      'status': serializer.toJson<int>(status),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  FastingRecord copyWith({
    int? id,
    String? userId,
    Value<String?> planType = const Value.absent(),
    DateTime? startTime,
    Value<DateTime?> endTime = const Value.absent(),
    Value<int?> duration = const Value.absent(),
    Value<int?> targetHours = const Value.absent(),
    int? status,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
  }) => FastingRecord(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    planType: planType.present ? planType.value : this.planType,
    startTime: startTime ?? this.startTime,
    endTime: endTime.present ? endTime.value : this.endTime,
    duration: duration.present ? duration.value : this.duration,
    targetHours: targetHours.present ? targetHours.value : this.targetHours,
    status: status ?? this.status,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  FastingRecord copyWithCompanion(FastingRecordsCompanion data) {
    return FastingRecord(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      planType: data.planType.present ? data.planType.value : this.planType,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      duration: data.duration.present ? data.duration.value : this.duration,
      targetHours: data.targetHours.present
          ? data.targetHours.value
          : this.targetHours,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FastingRecord(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('planType: $planType, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('duration: $duration, ')
          ..write('targetHours: $targetHours, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    planType,
    startTime,
    endTime,
    duration,
    targetHours,
    status,
    notes,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FastingRecord &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.planType == this.planType &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.duration == this.duration &&
          other.targetHours == this.targetHours &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class FastingRecordsCompanion extends UpdateCompanion<FastingRecord> {
  final Value<int> id;
  final Value<String> userId;
  final Value<String?> planType;
  final Value<DateTime> startTime;
  final Value<DateTime?> endTime;
  final Value<int?> duration;
  final Value<int?> targetHours;
  final Value<int> status;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  const FastingRecordsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.planType = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.duration = const Value.absent(),
    this.targetHours = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  FastingRecordsCompanion.insert({
    this.id = const Value.absent(),
    required String userId,
    this.planType = const Value.absent(),
    required DateTime startTime,
    this.endTime = const Value.absent(),
    this.duration = const Value.absent(),
    this.targetHours = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : userId = Value(userId),
       startTime = Value(startTime);
  static Insertable<FastingRecord> custom({
    Expression<int>? id,
    Expression<String>? userId,
    Expression<String>? planType,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<int>? duration,
    Expression<int>? targetHours,
    Expression<int>? status,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (planType != null) 'plan_type': planType,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (duration != null) 'duration': duration,
      if (targetHours != null) 'target_hours': targetHours,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  FastingRecordsCompanion copyWith({
    Value<int>? id,
    Value<String>? userId,
    Value<String?>? planType,
    Value<DateTime>? startTime,
    Value<DateTime?>? endTime,
    Value<int?>? duration,
    Value<int?>? targetHours,
    Value<int>? status,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
  }) {
    return FastingRecordsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      planType: planType ?? this.planType,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      duration: duration ?? this.duration,
      targetHours: targetHours ?? this.targetHours,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (planType.present) {
      map['plan_type'] = Variable<String>(planType.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (duration.present) {
      map['duration'] = Variable<int>(duration.value);
    }
    if (targetHours.present) {
      map['target_hours'] = Variable<int>(targetHours.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FastingRecordsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('planType: $planType, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('duration: $duration, ')
          ..write('targetHours: $targetHours, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $UserSettingsTable extends UserSettings
    with TableInfo<$UserSettingsTable, UserSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $UserSettingsTable createAlias(String alias) {
    return $UserSettingsTable(attachedDatabase, alias);
  }
}

class UserSetting extends DataClass implements Insertable<UserSetting> {
  final int id;
  final String key;
  final String value;
  const UserSetting({required this.id, required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  UserSettingsCompanion toCompanion(bool nullToAbsent) {
    return UserSettingsCompanion(
      id: Value(id),
      key: Value(key),
      value: Value(value),
    );
  }

  factory UserSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserSetting(
      id: serializer.fromJson<int>(json['id']),
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  UserSetting copyWith({int? id, String? key, String? value}) => UserSetting(
    id: id ?? this.id,
    key: key ?? this.key,
    value: value ?? this.value,
  );
  UserSetting copyWithCompanion(UserSettingsCompanion data) {
    return UserSetting(
      id: data.id.present ? data.id.value : this.id,
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserSetting(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserSetting &&
          other.id == this.id &&
          other.key == this.key &&
          other.value == this.value);
}

class UserSettingsCompanion extends UpdateCompanion<UserSetting> {
  final Value<int> id;
  final Value<String> key;
  final Value<String> value;
  const UserSettingsCompanion({
    this.id = const Value.absent(),
    this.key = const Value.absent(),
    this.value = const Value.absent(),
  });
  UserSettingsCompanion.insert({
    this.id = const Value.absent(),
    required String key,
    required String value,
  }) : key = Value(key),
       value = Value(value);
  static Insertable<UserSetting> custom({
    Expression<int>? id,
    Expression<String>? key,
    Expression<String>? value,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (key != null) 'key': key,
      if (value != null) 'value': value,
    });
  }

  UserSettingsCompanion copyWith({
    Value<int>? id,
    Value<String>? key,
    Value<String>? value,
  }) {
    return UserSettingsCompanion(
      id: id ?? this.id,
      key: key ?? this.key,
      value: value ?? this.value,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserSettingsCompanion(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }
}

class $PeriodRecordsTable extends PeriodRecords
    with TableInfo<$PeriodRecordsTable, PeriodRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PeriodRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationDaysMeta = const VerificationMeta(
    'durationDays',
  );
  @override
  late final GeneratedColumn<int> durationDays = GeneratedColumn<int>(
    'duration_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(5),
  );
  static const VerificationMeta _cycleDaysMeta = const VerificationMeta(
    'cycleDays',
  );
  @override
  late final GeneratedColumn<int> cycleDays = GeneratedColumn<int>(
    'cycle_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(28),
  );
  static const VerificationMeta _symptomsMeta = const VerificationMeta(
    'symptoms',
  );
  @override
  late final GeneratedColumn<String> symptoms = GeneratedColumn<String>(
    'symptoms',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    startDate,
    durationDays,
    cycleDays,
    symptoms,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'period_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<PeriodRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('duration_days')) {
      context.handle(
        _durationDaysMeta,
        durationDays.isAcceptableOrUnknown(
          data['duration_days']!,
          _durationDaysMeta,
        ),
      );
    }
    if (data.containsKey('cycle_days')) {
      context.handle(
        _cycleDaysMeta,
        cycleDays.isAcceptableOrUnknown(data['cycle_days']!, _cycleDaysMeta),
      );
    }
    if (data.containsKey('symptoms')) {
      context.handle(
        _symptomsMeta,
        symptoms.isAcceptableOrUnknown(data['symptoms']!, _symptomsMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PeriodRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PeriodRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      durationDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_days'],
      )!,
      cycleDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cycle_days'],
      )!,
      symptoms: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}symptoms'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $PeriodRecordsTable createAlias(String alias) {
    return $PeriodRecordsTable(attachedDatabase, alias);
  }
}

class PeriodRecord extends DataClass implements Insertable<PeriodRecord> {
  final String id;
  final DateTime startDate;
  final int durationDays;
  final int cycleDays;
  final String? symptoms;
  final String? note;
  const PeriodRecord({
    required this.id,
    required this.startDate,
    required this.durationDays,
    required this.cycleDays,
    this.symptoms,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['start_date'] = Variable<DateTime>(startDate);
    map['duration_days'] = Variable<int>(durationDays);
    map['cycle_days'] = Variable<int>(cycleDays);
    if (!nullToAbsent || symptoms != null) {
      map['symptoms'] = Variable<String>(symptoms);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  PeriodRecordsCompanion toCompanion(bool nullToAbsent) {
    return PeriodRecordsCompanion(
      id: Value(id),
      startDate: Value(startDate),
      durationDays: Value(durationDays),
      cycleDays: Value(cycleDays),
      symptoms: symptoms == null && nullToAbsent
          ? const Value.absent()
          : Value(symptoms),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory PeriodRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PeriodRecord(
      id: serializer.fromJson<String>(json['id']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      durationDays: serializer.fromJson<int>(json['durationDays']),
      cycleDays: serializer.fromJson<int>(json['cycleDays']),
      symptoms: serializer.fromJson<String?>(json['symptoms']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'startDate': serializer.toJson<DateTime>(startDate),
      'durationDays': serializer.toJson<int>(durationDays),
      'cycleDays': serializer.toJson<int>(cycleDays),
      'symptoms': serializer.toJson<String?>(symptoms),
      'note': serializer.toJson<String?>(note),
    };
  }

  PeriodRecord copyWith({
    String? id,
    DateTime? startDate,
    int? durationDays,
    int? cycleDays,
    Value<String?> symptoms = const Value.absent(),
    Value<String?> note = const Value.absent(),
  }) => PeriodRecord(
    id: id ?? this.id,
    startDate: startDate ?? this.startDate,
    durationDays: durationDays ?? this.durationDays,
    cycleDays: cycleDays ?? this.cycleDays,
    symptoms: symptoms.present ? symptoms.value : this.symptoms,
    note: note.present ? note.value : this.note,
  );
  PeriodRecord copyWithCompanion(PeriodRecordsCompanion data) {
    return PeriodRecord(
      id: data.id.present ? data.id.value : this.id,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      durationDays: data.durationDays.present
          ? data.durationDays.value
          : this.durationDays,
      cycleDays: data.cycleDays.present ? data.cycleDays.value : this.cycleDays,
      symptoms: data.symptoms.present ? data.symptoms.value : this.symptoms,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PeriodRecord(')
          ..write('id: $id, ')
          ..write('startDate: $startDate, ')
          ..write('durationDays: $durationDays, ')
          ..write('cycleDays: $cycleDays, ')
          ..write('symptoms: $symptoms, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, startDate, durationDays, cycleDays, symptoms, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PeriodRecord &&
          other.id == this.id &&
          other.startDate == this.startDate &&
          other.durationDays == this.durationDays &&
          other.cycleDays == this.cycleDays &&
          other.symptoms == this.symptoms &&
          other.note == this.note);
}

class PeriodRecordsCompanion extends UpdateCompanion<PeriodRecord> {
  final Value<String> id;
  final Value<DateTime> startDate;
  final Value<int> durationDays;
  final Value<int> cycleDays;
  final Value<String?> symptoms;
  final Value<String?> note;
  final Value<int> rowid;
  const PeriodRecordsCompanion({
    this.id = const Value.absent(),
    this.startDate = const Value.absent(),
    this.durationDays = const Value.absent(),
    this.cycleDays = const Value.absent(),
    this.symptoms = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PeriodRecordsCompanion.insert({
    required String id,
    required DateTime startDate,
    this.durationDays = const Value.absent(),
    this.cycleDays = const Value.absent(),
    this.symptoms = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       startDate = Value(startDate);
  static Insertable<PeriodRecord> custom({
    Expression<String>? id,
    Expression<DateTime>? startDate,
    Expression<int>? durationDays,
    Expression<int>? cycleDays,
    Expression<String>? symptoms,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startDate != null) 'start_date': startDate,
      if (durationDays != null) 'duration_days': durationDays,
      if (cycleDays != null) 'cycle_days': cycleDays,
      if (symptoms != null) 'symptoms': symptoms,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PeriodRecordsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? startDate,
    Value<int>? durationDays,
    Value<int>? cycleDays,
    Value<String?>? symptoms,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return PeriodRecordsCompanion(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      durationDays: durationDays ?? this.durationDays,
      cycleDays: cycleDays ?? this.cycleDays,
      symptoms: symptoms ?? this.symptoms,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (durationDays.present) {
      map['duration_days'] = Variable<int>(durationDays.value);
    }
    if (cycleDays.present) {
      map['cycle_days'] = Variable<int>(cycleDays.value);
    }
    if (symptoms.present) {
      map['symptoms'] = Variable<String>(symptoms.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PeriodRecordsCompanion(')
          ..write('id: $id, ')
          ..write('startDate: $startDate, ')
          ..write('durationDays: $durationDays, ')
          ..write('cycleDays: $cycleDays, ')
          ..write('symptoms: $symptoms, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VitalRecordsTable extends VitalRecords
    with TableInfo<$VitalRecordsTable, VitalRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VitalRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _value1Meta = const VerificationMeta('value1');
  @override
  late final GeneratedColumn<double> value1 = GeneratedColumn<double>(
    'value1',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _value2Meta = const VerificationMeta('value2');
  @override
  late final GeneratedColumn<double> value2 = GeneratedColumn<double>(
    'value2',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<DateTime> time = GeneratedColumn<DateTime>(
    'time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, type, value1, value2, time];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vital_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<VitalRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('value1')) {
      context.handle(
        _value1Meta,
        value1.isAcceptableOrUnknown(data['value1']!, _value1Meta),
      );
    } else if (isInserting) {
      context.missing(_value1Meta);
    }
    if (data.containsKey('value2')) {
      context.handle(
        _value2Meta,
        value2.isAcceptableOrUnknown(data['value2']!, _value2Meta),
      );
    }
    if (data.containsKey('time')) {
      context.handle(
        _timeMeta,
        time.isAcceptableOrUnknown(data['time']!, _timeMeta),
      );
    } else if (isInserting) {
      context.missing(_timeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VitalRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VitalRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      value1: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}value1'],
      )!,
      value2: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}value2'],
      ),
      time: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}time'],
      )!,
    );
  }

  @override
  $VitalRecordsTable createAlias(String alias) {
    return $VitalRecordsTable(attachedDatabase, alias);
  }
}

class VitalRecord extends DataClass implements Insertable<VitalRecord> {
  final int id;
  final String type;
  final double value1;
  final double? value2;
  final DateTime time;
  const VitalRecord({
    required this.id,
    required this.type,
    required this.value1,
    this.value2,
    required this.time,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type'] = Variable<String>(type);
    map['value1'] = Variable<double>(value1);
    if (!nullToAbsent || value2 != null) {
      map['value2'] = Variable<double>(value2);
    }
    map['time'] = Variable<DateTime>(time);
    return map;
  }

  VitalRecordsCompanion toCompanion(bool nullToAbsent) {
    return VitalRecordsCompanion(
      id: Value(id),
      type: Value(type),
      value1: Value(value1),
      value2: value2 == null && nullToAbsent
          ? const Value.absent()
          : Value(value2),
      time: Value(time),
    );
  }

  factory VitalRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VitalRecord(
      id: serializer.fromJson<int>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      value1: serializer.fromJson<double>(json['value1']),
      value2: serializer.fromJson<double?>(json['value2']),
      time: serializer.fromJson<DateTime>(json['time']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(type),
      'value1': serializer.toJson<double>(value1),
      'value2': serializer.toJson<double?>(value2),
      'time': serializer.toJson<DateTime>(time),
    };
  }

  VitalRecord copyWith({
    int? id,
    String? type,
    double? value1,
    Value<double?> value2 = const Value.absent(),
    DateTime? time,
  }) => VitalRecord(
    id: id ?? this.id,
    type: type ?? this.type,
    value1: value1 ?? this.value1,
    value2: value2.present ? value2.value : this.value2,
    time: time ?? this.time,
  );
  VitalRecord copyWithCompanion(VitalRecordsCompanion data) {
    return VitalRecord(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      value1: data.value1.present ? data.value1.value : this.value1,
      value2: data.value2.present ? data.value2.value : this.value2,
      time: data.time.present ? data.time.value : this.time,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VitalRecord(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('value1: $value1, ')
          ..write('value2: $value2, ')
          ..write('time: $time')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, type, value1, value2, time);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VitalRecord &&
          other.id == this.id &&
          other.type == this.type &&
          other.value1 == this.value1 &&
          other.value2 == this.value2 &&
          other.time == this.time);
}

class VitalRecordsCompanion extends UpdateCompanion<VitalRecord> {
  final Value<int> id;
  final Value<String> type;
  final Value<double> value1;
  final Value<double?> value2;
  final Value<DateTime> time;
  const VitalRecordsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.value1 = const Value.absent(),
    this.value2 = const Value.absent(),
    this.time = const Value.absent(),
  });
  VitalRecordsCompanion.insert({
    this.id = const Value.absent(),
    required String type,
    required double value1,
    this.value2 = const Value.absent(),
    required DateTime time,
  }) : type = Value(type),
       value1 = Value(value1),
       time = Value(time);
  static Insertable<VitalRecord> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<double>? value1,
    Expression<double>? value2,
    Expression<DateTime>? time,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (value1 != null) 'value1': value1,
      if (value2 != null) 'value2': value2,
      if (time != null) 'time': time,
    });
  }

  VitalRecordsCompanion copyWith({
    Value<int>? id,
    Value<String>? type,
    Value<double>? value1,
    Value<double?>? value2,
    Value<DateTime>? time,
  }) {
    return VitalRecordsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      value1: value1 ?? this.value1,
      value2: value2 ?? this.value2,
      time: time ?? this.time,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (value1.present) {
      map['value1'] = Variable<double>(value1.value);
    }
    if (value2.present) {
      map['value2'] = Variable<double>(value2.value);
    }
    if (time.present) {
      map['time'] = Variable<DateTime>(time.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VitalRecordsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('value1: $value1, ')
          ..write('value2: $value2, ')
          ..write('time: $time')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $StepCountsTable stepCounts = $StepCountsTable(this);
  late final $StepPerDaysTable stepPerDays = $StepPerDaysTable(this);
  late final $TargetsTable targets = $TargetsTable(this);
  late final $WaterRecordsTable waterRecords = $WaterRecordsTable(this);
  late final $DietRecordsTable dietRecords = $DietRecordsTable(this);
  late final $MoodRecordsTable moodRecords = $MoodRecordsTable(this);
  late final $TrainingPlansTable trainingPlans = $TrainingPlansTable(this);
  late final $SleepRecordsTable sleepRecords = $SleepRecordsTable(this);
  late final $SocialFeedsTable socialFeeds = $SocialFeedsTable(this);
  late final $ProfessionalWeightRecordsTable professionalWeightRecords =
      $ProfessionalWeightRecordsTable(this);
  late final $BloodPressureRecordsTable bloodPressureRecords =
      $BloodPressureRecordsTable(this);
  late final $HeartRateRecordsTable heartRateRecords = $HeartRateRecordsTable(
    this,
  );
  late final $BloodGlucoseRecordsTable bloodGlucoseRecords =
      $BloodGlucoseRecordsTable(this);
  late final $BloodLipidsRecordsTable bloodLipidsRecords =
      $BloodLipidsRecordsTable(this);
  late final $ExerciseRecordsTable exerciseRecords = $ExerciseRecordsTable(
    this,
  );
  late final $FastingRecordsTable fastingRecords = $FastingRecordsTable(this);
  late final $UserSettingsTable userSettings = $UserSettingsTable(this);
  late final $PeriodRecordsTable periodRecords = $PeriodRecordsTable(this);
  late final $VitalRecordsTable vitalRecords = $VitalRecordsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    stepCounts,
    stepPerDays,
    targets,
    waterRecords,
    dietRecords,
    moodRecords,
    trainingPlans,
    sleepRecords,
    socialFeeds,
    professionalWeightRecords,
    bloodPressureRecords,
    heartRateRecords,
    bloodGlucoseRecords,
    bloodLipidsRecords,
    exerciseRecords,
    fastingRecords,
    userSettings,
    periodRecords,
    vitalRecords,
  ];
}

typedef $$StepCountsTableCreateCompanionBuilder =
    StepCountsCompanion Function({
      Value<int> id,
      required DateTime startTime,
      Value<int> useTime,
      Value<int> stepsNum,
      Value<int> type,
      Value<int> subType,
      Value<String?> speed,
      Value<String?> cstatus,
      Value<String?> cal,
      Value<String?> sync1,
      Value<String?> sync2,
      Value<String?> distance,
    });
typedef $$StepCountsTableUpdateCompanionBuilder =
    StepCountsCompanion Function({
      Value<int> id,
      Value<DateTime> startTime,
      Value<int> useTime,
      Value<int> stepsNum,
      Value<int> type,
      Value<int> subType,
      Value<String?> speed,
      Value<String?> cstatus,
      Value<String?> cal,
      Value<String?> sync1,
      Value<String?> sync2,
      Value<String?> distance,
    });

class $$StepCountsTableFilterComposer
    extends Composer<_$AppDatabase, $StepCountsTable> {
  $$StepCountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get useTime => $composableBuilder(
    column: $table.useTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stepsNum => $composableBuilder(
    column: $table.stepsNum,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get subType => $composableBuilder(
    column: $table.subType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get speed => $composableBuilder(
    column: $table.speed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cstatus => $composableBuilder(
    column: $table.cstatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cal => $composableBuilder(
    column: $table.cal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sync1 => $composableBuilder(
    column: $table.sync1,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sync2 => $composableBuilder(
    column: $table.sync2,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get distance => $composableBuilder(
    column: $table.distance,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StepCountsTableOrderingComposer
    extends Composer<_$AppDatabase, $StepCountsTable> {
  $$StepCountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get useTime => $composableBuilder(
    column: $table.useTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stepsNum => $composableBuilder(
    column: $table.stepsNum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get subType => $composableBuilder(
    column: $table.subType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get speed => $composableBuilder(
    column: $table.speed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cstatus => $composableBuilder(
    column: $table.cstatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cal => $composableBuilder(
    column: $table.cal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sync1 => $composableBuilder(
    column: $table.sync1,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sync2 => $composableBuilder(
    column: $table.sync2,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get distance => $composableBuilder(
    column: $table.distance,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StepCountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StepCountsTable> {
  $$StepCountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<int> get useTime =>
      $composableBuilder(column: $table.useTime, builder: (column) => column);

  GeneratedColumn<int> get stepsNum =>
      $composableBuilder(column: $table.stepsNum, builder: (column) => column);

  GeneratedColumn<int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get subType =>
      $composableBuilder(column: $table.subType, builder: (column) => column);

  GeneratedColumn<String> get speed =>
      $composableBuilder(column: $table.speed, builder: (column) => column);

  GeneratedColumn<String> get cstatus =>
      $composableBuilder(column: $table.cstatus, builder: (column) => column);

  GeneratedColumn<String> get cal =>
      $composableBuilder(column: $table.cal, builder: (column) => column);

  GeneratedColumn<String> get sync1 =>
      $composableBuilder(column: $table.sync1, builder: (column) => column);

  GeneratedColumn<String> get sync2 =>
      $composableBuilder(column: $table.sync2, builder: (column) => column);

  GeneratedColumn<String> get distance =>
      $composableBuilder(column: $table.distance, builder: (column) => column);
}

class $$StepCountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StepCountsTable,
          StepCount,
          $$StepCountsTableFilterComposer,
          $$StepCountsTableOrderingComposer,
          $$StepCountsTableAnnotationComposer,
          $$StepCountsTableCreateCompanionBuilder,
          $$StepCountsTableUpdateCompanionBuilder,
          (
            StepCount,
            BaseReferences<_$AppDatabase, $StepCountsTable, StepCount>,
          ),
          StepCount,
          PrefetchHooks Function()
        > {
  $$StepCountsTableTableManager(_$AppDatabase db, $StepCountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StepCountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StepCountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StepCountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> startTime = const Value.absent(),
                Value<int> useTime = const Value.absent(),
                Value<int> stepsNum = const Value.absent(),
                Value<int> type = const Value.absent(),
                Value<int> subType = const Value.absent(),
                Value<String?> speed = const Value.absent(),
                Value<String?> cstatus = const Value.absent(),
                Value<String?> cal = const Value.absent(),
                Value<String?> sync1 = const Value.absent(),
                Value<String?> sync2 = const Value.absent(),
                Value<String?> distance = const Value.absent(),
              }) => StepCountsCompanion(
                id: id,
                startTime: startTime,
                useTime: useTime,
                stepsNum: stepsNum,
                type: type,
                subType: subType,
                speed: speed,
                cstatus: cstatus,
                cal: cal,
                sync1: sync1,
                sync2: sync2,
                distance: distance,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime startTime,
                Value<int> useTime = const Value.absent(),
                Value<int> stepsNum = const Value.absent(),
                Value<int> type = const Value.absent(),
                Value<int> subType = const Value.absent(),
                Value<String?> speed = const Value.absent(),
                Value<String?> cstatus = const Value.absent(),
                Value<String?> cal = const Value.absent(),
                Value<String?> sync1 = const Value.absent(),
                Value<String?> sync2 = const Value.absent(),
                Value<String?> distance = const Value.absent(),
              }) => StepCountsCompanion.insert(
                id: id,
                startTime: startTime,
                useTime: useTime,
                stepsNum: stepsNum,
                type: type,
                subType: subType,
                speed: speed,
                cstatus: cstatus,
                cal: cal,
                sync1: sync1,
                sync2: sync2,
                distance: distance,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StepCountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StepCountsTable,
      StepCount,
      $$StepCountsTableFilterComposer,
      $$StepCountsTableOrderingComposer,
      $$StepCountsTableAnnotationComposer,
      $$StepCountsTableCreateCompanionBuilder,
      $$StepCountsTableUpdateCompanionBuilder,
      (StepCount, BaseReferences<_$AppDatabase, $StepCountsTable, StepCount>),
      StepCount,
      PrefetchHooks Function()
    >;
typedef $$StepPerDaysTableCreateCompanionBuilder =
    StepPerDaysCompanion Function({
      Value<int> id,
      required String date,
      required DateTime time,
      Value<int> stepCount,
      Value<int> state,
      Value<int> backup1,
    });
typedef $$StepPerDaysTableUpdateCompanionBuilder =
    StepPerDaysCompanion Function({
      Value<int> id,
      Value<String> date,
      Value<DateTime> time,
      Value<int> stepCount,
      Value<int> state,
      Value<int> backup1,
    });

class $$StepPerDaysTableFilterComposer
    extends Composer<_$AppDatabase, $StepPerDaysTable> {
  $$StepPerDaysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stepCount => $composableBuilder(
    column: $table.stepCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get backup1 => $composableBuilder(
    column: $table.backup1,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StepPerDaysTableOrderingComposer
    extends Composer<_$AppDatabase, $StepPerDaysTable> {
  $$StepPerDaysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stepCount => $composableBuilder(
    column: $table.stepCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get backup1 => $composableBuilder(
    column: $table.backup1,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StepPerDaysTableAnnotationComposer
    extends Composer<_$AppDatabase, $StepPerDaysTable> {
  $$StepPerDaysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get time =>
      $composableBuilder(column: $table.time, builder: (column) => column);

  GeneratedColumn<int> get stepCount =>
      $composableBuilder(column: $table.stepCount, builder: (column) => column);

  GeneratedColumn<int> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<int> get backup1 =>
      $composableBuilder(column: $table.backup1, builder: (column) => column);
}

class $$StepPerDaysTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StepPerDaysTable,
          StepPerDay,
          $$StepPerDaysTableFilterComposer,
          $$StepPerDaysTableOrderingComposer,
          $$StepPerDaysTableAnnotationComposer,
          $$StepPerDaysTableCreateCompanionBuilder,
          $$StepPerDaysTableUpdateCompanionBuilder,
          (
            StepPerDay,
            BaseReferences<_$AppDatabase, $StepPerDaysTable, StepPerDay>,
          ),
          StepPerDay,
          PrefetchHooks Function()
        > {
  $$StepPerDaysTableTableManager(_$AppDatabase db, $StepPerDaysTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StepPerDaysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StepPerDaysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StepPerDaysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<DateTime> time = const Value.absent(),
                Value<int> stepCount = const Value.absent(),
                Value<int> state = const Value.absent(),
                Value<int> backup1 = const Value.absent(),
              }) => StepPerDaysCompanion(
                id: id,
                date: date,
                time: time,
                stepCount: stepCount,
                state: state,
                backup1: backup1,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String date,
                required DateTime time,
                Value<int> stepCount = const Value.absent(),
                Value<int> state = const Value.absent(),
                Value<int> backup1 = const Value.absent(),
              }) => StepPerDaysCompanion.insert(
                id: id,
                date: date,
                time: time,
                stepCount: stepCount,
                state: state,
                backup1: backup1,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StepPerDaysTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StepPerDaysTable,
      StepPerDay,
      $$StepPerDaysTableFilterComposer,
      $$StepPerDaysTableOrderingComposer,
      $$StepPerDaysTableAnnotationComposer,
      $$StepPerDaysTableCreateCompanionBuilder,
      $$StepPerDaysTableUpdateCompanionBuilder,
      (
        StepPerDay,
        BaseReferences<_$AppDatabase, $StepPerDaysTable, StepPerDay>,
      ),
      StepPerDay,
      PrefetchHooks Function()
    >;
typedef $$TargetsTableCreateCompanionBuilder =
    TargetsCompanion Function({
      Value<int> id,
      Value<String?> targetName,
      Value<String?> targetHint,
      Value<int> targetAllTimes,
      Value<int> targetFinishTimes,
      Value<bool> isLoop,
      Value<String?> achieveDataList,
      required DateTime startTime,
      required DateTime lastTime,
      required DateTime targetTime,
      Value<int> targetType,
      Value<String?> targetSync1,
      Value<String?> targetSync2,
      Value<String?> targetSync3,
      Value<String?> targetSync4,
    });
typedef $$TargetsTableUpdateCompanionBuilder =
    TargetsCompanion Function({
      Value<int> id,
      Value<String?> targetName,
      Value<String?> targetHint,
      Value<int> targetAllTimes,
      Value<int> targetFinishTimes,
      Value<bool> isLoop,
      Value<String?> achieveDataList,
      Value<DateTime> startTime,
      Value<DateTime> lastTime,
      Value<DateTime> targetTime,
      Value<int> targetType,
      Value<String?> targetSync1,
      Value<String?> targetSync2,
      Value<String?> targetSync3,
      Value<String?> targetSync4,
    });

class $$TargetsTableFilterComposer
    extends Composer<_$AppDatabase, $TargetsTable> {
  $$TargetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetName => $composableBuilder(
    column: $table.targetName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetHint => $composableBuilder(
    column: $table.targetHint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetAllTimes => $composableBuilder(
    column: $table.targetAllTimes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetFinishTimes => $composableBuilder(
    column: $table.targetFinishTimes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isLoop => $composableBuilder(
    column: $table.isLoop,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get achieveDataList => $composableBuilder(
    column: $table.achieveDataList,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastTime => $composableBuilder(
    column: $table.lastTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get targetTime => $composableBuilder(
    column: $table.targetTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetType => $composableBuilder(
    column: $table.targetType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetSync1 => $composableBuilder(
    column: $table.targetSync1,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetSync2 => $composableBuilder(
    column: $table.targetSync2,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetSync3 => $composableBuilder(
    column: $table.targetSync3,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetSync4 => $composableBuilder(
    column: $table.targetSync4,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TargetsTableOrderingComposer
    extends Composer<_$AppDatabase, $TargetsTable> {
  $$TargetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetName => $composableBuilder(
    column: $table.targetName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetHint => $composableBuilder(
    column: $table.targetHint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetAllTimes => $composableBuilder(
    column: $table.targetAllTimes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetFinishTimes => $composableBuilder(
    column: $table.targetFinishTimes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isLoop => $composableBuilder(
    column: $table.isLoop,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get achieveDataList => $composableBuilder(
    column: $table.achieveDataList,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastTime => $composableBuilder(
    column: $table.lastTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get targetTime => $composableBuilder(
    column: $table.targetTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetType => $composableBuilder(
    column: $table.targetType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetSync1 => $composableBuilder(
    column: $table.targetSync1,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetSync2 => $composableBuilder(
    column: $table.targetSync2,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetSync3 => $composableBuilder(
    column: $table.targetSync3,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetSync4 => $composableBuilder(
    column: $table.targetSync4,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TargetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TargetsTable> {
  $$TargetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get targetName => $composableBuilder(
    column: $table.targetName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetHint => $composableBuilder(
    column: $table.targetHint,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetAllTimes => $composableBuilder(
    column: $table.targetAllTimes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetFinishTimes => $composableBuilder(
    column: $table.targetFinishTimes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isLoop =>
      $composableBuilder(column: $table.isLoop, builder: (column) => column);

  GeneratedColumn<String> get achieveDataList => $composableBuilder(
    column: $table.achieveDataList,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get lastTime =>
      $composableBuilder(column: $table.lastTime, builder: (column) => column);

  GeneratedColumn<DateTime> get targetTime => $composableBuilder(
    column: $table.targetTime,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetType => $composableBuilder(
    column: $table.targetType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetSync1 => $composableBuilder(
    column: $table.targetSync1,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetSync2 => $composableBuilder(
    column: $table.targetSync2,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetSync3 => $composableBuilder(
    column: $table.targetSync3,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetSync4 => $composableBuilder(
    column: $table.targetSync4,
    builder: (column) => column,
  );
}

class $$TargetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TargetsTable,
          Target,
          $$TargetsTableFilterComposer,
          $$TargetsTableOrderingComposer,
          $$TargetsTableAnnotationComposer,
          $$TargetsTableCreateCompanionBuilder,
          $$TargetsTableUpdateCompanionBuilder,
          (Target, BaseReferences<_$AppDatabase, $TargetsTable, Target>),
          Target,
          PrefetchHooks Function()
        > {
  $$TargetsTableTableManager(_$AppDatabase db, $TargetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TargetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TargetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TargetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> targetName = const Value.absent(),
                Value<String?> targetHint = const Value.absent(),
                Value<int> targetAllTimes = const Value.absent(),
                Value<int> targetFinishTimes = const Value.absent(),
                Value<bool> isLoop = const Value.absent(),
                Value<String?> achieveDataList = const Value.absent(),
                Value<DateTime> startTime = const Value.absent(),
                Value<DateTime> lastTime = const Value.absent(),
                Value<DateTime> targetTime = const Value.absent(),
                Value<int> targetType = const Value.absent(),
                Value<String?> targetSync1 = const Value.absent(),
                Value<String?> targetSync2 = const Value.absent(),
                Value<String?> targetSync3 = const Value.absent(),
                Value<String?> targetSync4 = const Value.absent(),
              }) => TargetsCompanion(
                id: id,
                targetName: targetName,
                targetHint: targetHint,
                targetAllTimes: targetAllTimes,
                targetFinishTimes: targetFinishTimes,
                isLoop: isLoop,
                achieveDataList: achieveDataList,
                startTime: startTime,
                lastTime: lastTime,
                targetTime: targetTime,
                targetType: targetType,
                targetSync1: targetSync1,
                targetSync2: targetSync2,
                targetSync3: targetSync3,
                targetSync4: targetSync4,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> targetName = const Value.absent(),
                Value<String?> targetHint = const Value.absent(),
                Value<int> targetAllTimes = const Value.absent(),
                Value<int> targetFinishTimes = const Value.absent(),
                Value<bool> isLoop = const Value.absent(),
                Value<String?> achieveDataList = const Value.absent(),
                required DateTime startTime,
                required DateTime lastTime,
                required DateTime targetTime,
                Value<int> targetType = const Value.absent(),
                Value<String?> targetSync1 = const Value.absent(),
                Value<String?> targetSync2 = const Value.absent(),
                Value<String?> targetSync3 = const Value.absent(),
                Value<String?> targetSync4 = const Value.absent(),
              }) => TargetsCompanion.insert(
                id: id,
                targetName: targetName,
                targetHint: targetHint,
                targetAllTimes: targetAllTimes,
                targetFinishTimes: targetFinishTimes,
                isLoop: isLoop,
                achieveDataList: achieveDataList,
                startTime: startTime,
                lastTime: lastTime,
                targetTime: targetTime,
                targetType: targetType,
                targetSync1: targetSync1,
                targetSync2: targetSync2,
                targetSync3: targetSync3,
                targetSync4: targetSync4,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TargetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TargetsTable,
      Target,
      $$TargetsTableFilterComposer,
      $$TargetsTableOrderingComposer,
      $$TargetsTableAnnotationComposer,
      $$TargetsTableCreateCompanionBuilder,
      $$TargetsTableUpdateCompanionBuilder,
      (Target, BaseReferences<_$AppDatabase, $TargetsTable, Target>),
      Target,
      PrefetchHooks Function()
    >;
typedef $$WaterRecordsTableCreateCompanionBuilder =
    WaterRecordsCompanion Function({
      Value<int> id,
      required DateTime time,
      Value<int> amount,
      Value<String?> note,
      Value<String> waterType,
    });
typedef $$WaterRecordsTableUpdateCompanionBuilder =
    WaterRecordsCompanion Function({
      Value<int> id,
      Value<DateTime> time,
      Value<int> amount,
      Value<String?> note,
      Value<String> waterType,
    });

class $$WaterRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $WaterRecordsTable> {
  $$WaterRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get waterType => $composableBuilder(
    column: $table.waterType,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WaterRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $WaterRecordsTable> {
  $$WaterRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get waterType => $composableBuilder(
    column: $table.waterType,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WaterRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WaterRecordsTable> {
  $$WaterRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get time =>
      $composableBuilder(column: $table.time, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get waterType =>
      $composableBuilder(column: $table.waterType, builder: (column) => column);
}

class $$WaterRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WaterRecordsTable,
          WaterRecord,
          $$WaterRecordsTableFilterComposer,
          $$WaterRecordsTableOrderingComposer,
          $$WaterRecordsTableAnnotationComposer,
          $$WaterRecordsTableCreateCompanionBuilder,
          $$WaterRecordsTableUpdateCompanionBuilder,
          (
            WaterRecord,
            BaseReferences<_$AppDatabase, $WaterRecordsTable, WaterRecord>,
          ),
          WaterRecord,
          PrefetchHooks Function()
        > {
  $$WaterRecordsTableTableManager(_$AppDatabase db, $WaterRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WaterRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WaterRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WaterRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> time = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String> waterType = const Value.absent(),
              }) => WaterRecordsCompanion(
                id: id,
                time: time,
                amount: amount,
                note: note,
                waterType: waterType,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime time,
                Value<int> amount = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String> waterType = const Value.absent(),
              }) => WaterRecordsCompanion.insert(
                id: id,
                time: time,
                amount: amount,
                note: note,
                waterType: waterType,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WaterRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WaterRecordsTable,
      WaterRecord,
      $$WaterRecordsTableFilterComposer,
      $$WaterRecordsTableOrderingComposer,
      $$WaterRecordsTableAnnotationComposer,
      $$WaterRecordsTableCreateCompanionBuilder,
      $$WaterRecordsTableUpdateCompanionBuilder,
      (
        WaterRecord,
        BaseReferences<_$AppDatabase, $WaterRecordsTable, WaterRecord>,
      ),
      WaterRecord,
      PrefetchHooks Function()
    >;
typedef $$DietRecordsTableCreateCompanionBuilder =
    DietRecordsCompanion Function({
      Value<int> id,
      required DateTime time,
      Value<int> calories,
      Value<String?> foodName,
      Value<String?> note,
      Value<int> mealType,
      Value<double> weight,
    });
typedef $$DietRecordsTableUpdateCompanionBuilder =
    DietRecordsCompanion Function({
      Value<int> id,
      Value<DateTime> time,
      Value<int> calories,
      Value<String?> foodName,
      Value<String?> note,
      Value<int> mealType,
      Value<double> weight,
    });

class $$DietRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $DietRecordsTable> {
  $$DietRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get foodName => $composableBuilder(
    column: $table.foodName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mealType => $composableBuilder(
    column: $table.mealType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DietRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $DietRecordsTable> {
  $$DietRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get foodName => $composableBuilder(
    column: $table.foodName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mealType => $composableBuilder(
    column: $table.mealType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DietRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DietRecordsTable> {
  $$DietRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get time =>
      $composableBuilder(column: $table.time, builder: (column) => column);

  GeneratedColumn<int> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);

  GeneratedColumn<String> get foodName =>
      $composableBuilder(column: $table.foodName, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get mealType =>
      $composableBuilder(column: $table.mealType, builder: (column) => column);

  GeneratedColumn<double> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);
}

class $$DietRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DietRecordsTable,
          DietRecord,
          $$DietRecordsTableFilterComposer,
          $$DietRecordsTableOrderingComposer,
          $$DietRecordsTableAnnotationComposer,
          $$DietRecordsTableCreateCompanionBuilder,
          $$DietRecordsTableUpdateCompanionBuilder,
          (
            DietRecord,
            BaseReferences<_$AppDatabase, $DietRecordsTable, DietRecord>,
          ),
          DietRecord,
          PrefetchHooks Function()
        > {
  $$DietRecordsTableTableManager(_$AppDatabase db, $DietRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DietRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DietRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DietRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> time = const Value.absent(),
                Value<int> calories = const Value.absent(),
                Value<String?> foodName = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> mealType = const Value.absent(),
                Value<double> weight = const Value.absent(),
              }) => DietRecordsCompanion(
                id: id,
                time: time,
                calories: calories,
                foodName: foodName,
                note: note,
                mealType: mealType,
                weight: weight,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime time,
                Value<int> calories = const Value.absent(),
                Value<String?> foodName = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> mealType = const Value.absent(),
                Value<double> weight = const Value.absent(),
              }) => DietRecordsCompanion.insert(
                id: id,
                time: time,
                calories: calories,
                foodName: foodName,
                note: note,
                mealType: mealType,
                weight: weight,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DietRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DietRecordsTable,
      DietRecord,
      $$DietRecordsTableFilterComposer,
      $$DietRecordsTableOrderingComposer,
      $$DietRecordsTableAnnotationComposer,
      $$DietRecordsTableCreateCompanionBuilder,
      $$DietRecordsTableUpdateCompanionBuilder,
      (
        DietRecord,
        BaseReferences<_$AppDatabase, $DietRecordsTable, DietRecord>,
      ),
      DietRecord,
      PrefetchHooks Function()
    >;
typedef $$MoodRecordsTableCreateCompanionBuilder =
    MoodRecordsCompanion Function({
      Value<int> id,
      required DateTime time,
      Value<int> mood,
      Value<String?> note,
      Value<String?> reasons,
    });
typedef $$MoodRecordsTableUpdateCompanionBuilder =
    MoodRecordsCompanion Function({
      Value<int> id,
      Value<DateTime> time,
      Value<int> mood,
      Value<String?> note,
      Value<String?> reasons,
    });

class $$MoodRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $MoodRecordsTable> {
  $$MoodRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reasons => $composableBuilder(
    column: $table.reasons,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MoodRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $MoodRecordsTable> {
  $$MoodRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reasons => $composableBuilder(
    column: $table.reasons,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MoodRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MoodRecordsTable> {
  $$MoodRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get time =>
      $composableBuilder(column: $table.time, builder: (column) => column);

  GeneratedColumn<int> get mood =>
      $composableBuilder(column: $table.mood, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get reasons =>
      $composableBuilder(column: $table.reasons, builder: (column) => column);
}

class $$MoodRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MoodRecordsTable,
          MoodRecord,
          $$MoodRecordsTableFilterComposer,
          $$MoodRecordsTableOrderingComposer,
          $$MoodRecordsTableAnnotationComposer,
          $$MoodRecordsTableCreateCompanionBuilder,
          $$MoodRecordsTableUpdateCompanionBuilder,
          (
            MoodRecord,
            BaseReferences<_$AppDatabase, $MoodRecordsTable, MoodRecord>,
          ),
          MoodRecord,
          PrefetchHooks Function()
        > {
  $$MoodRecordsTableTableManager(_$AppDatabase db, $MoodRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MoodRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MoodRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MoodRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> time = const Value.absent(),
                Value<int> mood = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> reasons = const Value.absent(),
              }) => MoodRecordsCompanion(
                id: id,
                time: time,
                mood: mood,
                note: note,
                reasons: reasons,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime time,
                Value<int> mood = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> reasons = const Value.absent(),
              }) => MoodRecordsCompanion.insert(
                id: id,
                time: time,
                mood: mood,
                note: note,
                reasons: reasons,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MoodRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MoodRecordsTable,
      MoodRecord,
      $$MoodRecordsTableFilterComposer,
      $$MoodRecordsTableOrderingComposer,
      $$MoodRecordsTableAnnotationComposer,
      $$MoodRecordsTableCreateCompanionBuilder,
      $$MoodRecordsTableUpdateCompanionBuilder,
      (
        MoodRecord,
        BaseReferences<_$AppDatabase, $MoodRecordsTable, MoodRecord>,
      ),
      MoodRecord,
      PrefetchHooks Function()
    >;
typedef $$TrainingPlansTableCreateCompanionBuilder =
    TrainingPlansCompanion Function({
      Value<int> id,
      Value<int> goalType,
      Value<int> levelType,
      Value<String?> planName,
      Value<String?> planDesc,
      Value<String?> planTips,
      Value<String?> weeklyPlanJson,
      required DateTime createdAt,
      Value<bool> isActive,
      Value<String?> completedDays,
    });
typedef $$TrainingPlansTableUpdateCompanionBuilder =
    TrainingPlansCompanion Function({
      Value<int> id,
      Value<int> goalType,
      Value<int> levelType,
      Value<String?> planName,
      Value<String?> planDesc,
      Value<String?> planTips,
      Value<String?> weeklyPlanJson,
      Value<DateTime> createdAt,
      Value<bool> isActive,
      Value<String?> completedDays,
    });

class $$TrainingPlansTableFilterComposer
    extends Composer<_$AppDatabase, $TrainingPlansTable> {
  $$TrainingPlansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get goalType => $composableBuilder(
    column: $table.goalType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get levelType => $composableBuilder(
    column: $table.levelType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get planName => $composableBuilder(
    column: $table.planName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get planDesc => $composableBuilder(
    column: $table.planDesc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get planTips => $composableBuilder(
    column: $table.planTips,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weeklyPlanJson => $composableBuilder(
    column: $table.weeklyPlanJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get completedDays => $composableBuilder(
    column: $table.completedDays,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TrainingPlansTableOrderingComposer
    extends Composer<_$AppDatabase, $TrainingPlansTable> {
  $$TrainingPlansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get goalType => $composableBuilder(
    column: $table.goalType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get levelType => $composableBuilder(
    column: $table.levelType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get planName => $composableBuilder(
    column: $table.planName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get planDesc => $composableBuilder(
    column: $table.planDesc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get planTips => $composableBuilder(
    column: $table.planTips,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weeklyPlanJson => $composableBuilder(
    column: $table.weeklyPlanJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get completedDays => $composableBuilder(
    column: $table.completedDays,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TrainingPlansTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrainingPlansTable> {
  $$TrainingPlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get goalType =>
      $composableBuilder(column: $table.goalType, builder: (column) => column);

  GeneratedColumn<int> get levelType =>
      $composableBuilder(column: $table.levelType, builder: (column) => column);

  GeneratedColumn<String> get planName =>
      $composableBuilder(column: $table.planName, builder: (column) => column);

  GeneratedColumn<String> get planDesc =>
      $composableBuilder(column: $table.planDesc, builder: (column) => column);

  GeneratedColumn<String> get planTips =>
      $composableBuilder(column: $table.planTips, builder: (column) => column);

  GeneratedColumn<String> get weeklyPlanJson => $composableBuilder(
    column: $table.weeklyPlanJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get completedDays => $composableBuilder(
    column: $table.completedDays,
    builder: (column) => column,
  );
}

class $$TrainingPlansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TrainingPlansTable,
          TrainingPlan,
          $$TrainingPlansTableFilterComposer,
          $$TrainingPlansTableOrderingComposer,
          $$TrainingPlansTableAnnotationComposer,
          $$TrainingPlansTableCreateCompanionBuilder,
          $$TrainingPlansTableUpdateCompanionBuilder,
          (
            TrainingPlan,
            BaseReferences<_$AppDatabase, $TrainingPlansTable, TrainingPlan>,
          ),
          TrainingPlan,
          PrefetchHooks Function()
        > {
  $$TrainingPlansTableTableManager(_$AppDatabase db, $TrainingPlansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrainingPlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrainingPlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrainingPlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> goalType = const Value.absent(),
                Value<int> levelType = const Value.absent(),
                Value<String?> planName = const Value.absent(),
                Value<String?> planDesc = const Value.absent(),
                Value<String?> planTips = const Value.absent(),
                Value<String?> weeklyPlanJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String?> completedDays = const Value.absent(),
              }) => TrainingPlansCompanion(
                id: id,
                goalType: goalType,
                levelType: levelType,
                planName: planName,
                planDesc: planDesc,
                planTips: planTips,
                weeklyPlanJson: weeklyPlanJson,
                createdAt: createdAt,
                isActive: isActive,
                completedDays: completedDays,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> goalType = const Value.absent(),
                Value<int> levelType = const Value.absent(),
                Value<String?> planName = const Value.absent(),
                Value<String?> planDesc = const Value.absent(),
                Value<String?> planTips = const Value.absent(),
                Value<String?> weeklyPlanJson = const Value.absent(),
                required DateTime createdAt,
                Value<bool> isActive = const Value.absent(),
                Value<String?> completedDays = const Value.absent(),
              }) => TrainingPlansCompanion.insert(
                id: id,
                goalType: goalType,
                levelType: levelType,
                planName: planName,
                planDesc: planDesc,
                planTips: planTips,
                weeklyPlanJson: weeklyPlanJson,
                createdAt: createdAt,
                isActive: isActive,
                completedDays: completedDays,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TrainingPlansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TrainingPlansTable,
      TrainingPlan,
      $$TrainingPlansTableFilterComposer,
      $$TrainingPlansTableOrderingComposer,
      $$TrainingPlansTableAnnotationComposer,
      $$TrainingPlansTableCreateCompanionBuilder,
      $$TrainingPlansTableUpdateCompanionBuilder,
      (
        TrainingPlan,
        BaseReferences<_$AppDatabase, $TrainingPlansTable, TrainingPlan>,
      ),
      TrainingPlan,
      PrefetchHooks Function()
    >;
typedef $$SleepRecordsTableCreateCompanionBuilder =
    SleepRecordsCompanion Function({
      Value<int> id,
      required DateTime sleepTime,
      required DateTime wakeTime,
      Value<int> duration,
      Value<int> quality,
      Value<int> sleepScore,
      Value<int> heartRate,
      Value<String?> tags,
      Value<String?> note,
    });
typedef $$SleepRecordsTableUpdateCompanionBuilder =
    SleepRecordsCompanion Function({
      Value<int> id,
      Value<DateTime> sleepTime,
      Value<DateTime> wakeTime,
      Value<int> duration,
      Value<int> quality,
      Value<int> sleepScore,
      Value<int> heartRate,
      Value<String?> tags,
      Value<String?> note,
    });

class $$SleepRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $SleepRecordsTable> {
  $$SleepRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get sleepTime => $composableBuilder(
    column: $table.sleepTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get wakeTime => $composableBuilder(
    column: $table.wakeTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quality => $composableBuilder(
    column: $table.quality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sleepScore => $composableBuilder(
    column: $table.sleepScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get heartRate => $composableBuilder(
    column: $table.heartRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SleepRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $SleepRecordsTable> {
  $$SleepRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get sleepTime => $composableBuilder(
    column: $table.sleepTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get wakeTime => $composableBuilder(
    column: $table.wakeTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quality => $composableBuilder(
    column: $table.quality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sleepScore => $composableBuilder(
    column: $table.sleepScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get heartRate => $composableBuilder(
    column: $table.heartRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SleepRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SleepRecordsTable> {
  $$SleepRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get sleepTime =>
      $composableBuilder(column: $table.sleepTime, builder: (column) => column);

  GeneratedColumn<DateTime> get wakeTime =>
      $composableBuilder(column: $table.wakeTime, builder: (column) => column);

  GeneratedColumn<int> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumn<int> get quality =>
      $composableBuilder(column: $table.quality, builder: (column) => column);

  GeneratedColumn<int> get sleepScore => $composableBuilder(
    column: $table.sleepScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get heartRate =>
      $composableBuilder(column: $table.heartRate, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$SleepRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SleepRecordsTable,
          SleepRecord,
          $$SleepRecordsTableFilterComposer,
          $$SleepRecordsTableOrderingComposer,
          $$SleepRecordsTableAnnotationComposer,
          $$SleepRecordsTableCreateCompanionBuilder,
          $$SleepRecordsTableUpdateCompanionBuilder,
          (
            SleepRecord,
            BaseReferences<_$AppDatabase, $SleepRecordsTable, SleepRecord>,
          ),
          SleepRecord,
          PrefetchHooks Function()
        > {
  $$SleepRecordsTableTableManager(_$AppDatabase db, $SleepRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SleepRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SleepRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SleepRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> sleepTime = const Value.absent(),
                Value<DateTime> wakeTime = const Value.absent(),
                Value<int> duration = const Value.absent(),
                Value<int> quality = const Value.absent(),
                Value<int> sleepScore = const Value.absent(),
                Value<int> heartRate = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => SleepRecordsCompanion(
                id: id,
                sleepTime: sleepTime,
                wakeTime: wakeTime,
                duration: duration,
                quality: quality,
                sleepScore: sleepScore,
                heartRate: heartRate,
                tags: tags,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime sleepTime,
                required DateTime wakeTime,
                Value<int> duration = const Value.absent(),
                Value<int> quality = const Value.absent(),
                Value<int> sleepScore = const Value.absent(),
                Value<int> heartRate = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => SleepRecordsCompanion.insert(
                id: id,
                sleepTime: sleepTime,
                wakeTime: wakeTime,
                duration: duration,
                quality: quality,
                sleepScore: sleepScore,
                heartRate: heartRate,
                tags: tags,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SleepRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SleepRecordsTable,
      SleepRecord,
      $$SleepRecordsTableFilterComposer,
      $$SleepRecordsTableOrderingComposer,
      $$SleepRecordsTableAnnotationComposer,
      $$SleepRecordsTableCreateCompanionBuilder,
      $$SleepRecordsTableUpdateCompanionBuilder,
      (
        SleepRecord,
        BaseReferences<_$AppDatabase, $SleepRecordsTable, SleepRecord>,
      ),
      SleepRecord,
      PrefetchHooks Function()
    >;
typedef $$SocialFeedsTableCreateCompanionBuilder =
    SocialFeedsCompanion Function({
      Value<int> id,
      Value<String?> userName,
      Value<String?> avatarRes,
      Value<String?> content,
      Value<String?> imagePath,
      Value<int?> steps,
      Value<int?> calories,
      required DateTime time,
      Value<int?> type,
      Value<int> likeCount,
      Value<bool> isMock,
    });
typedef $$SocialFeedsTableUpdateCompanionBuilder =
    SocialFeedsCompanion Function({
      Value<int> id,
      Value<String?> userName,
      Value<String?> avatarRes,
      Value<String?> content,
      Value<String?> imagePath,
      Value<int?> steps,
      Value<int?> calories,
      Value<DateTime> time,
      Value<int?> type,
      Value<int> likeCount,
      Value<bool> isMock,
    });

class $$SocialFeedsTableFilterComposer
    extends Composer<_$AppDatabase, $SocialFeedsTable> {
  $$SocialFeedsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userName => $composableBuilder(
    column: $table.userName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarRes => $composableBuilder(
    column: $table.avatarRes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get steps => $composableBuilder(
    column: $table.steps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get likeCount => $composableBuilder(
    column: $table.likeCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isMock => $composableBuilder(
    column: $table.isMock,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SocialFeedsTableOrderingComposer
    extends Composer<_$AppDatabase, $SocialFeedsTable> {
  $$SocialFeedsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userName => $composableBuilder(
    column: $table.userName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarRes => $composableBuilder(
    column: $table.avatarRes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get steps => $composableBuilder(
    column: $table.steps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get likeCount => $composableBuilder(
    column: $table.likeCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isMock => $composableBuilder(
    column: $table.isMock,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SocialFeedsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SocialFeedsTable> {
  $$SocialFeedsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userName =>
      $composableBuilder(column: $table.userName, builder: (column) => column);

  GeneratedColumn<String> get avatarRes =>
      $composableBuilder(column: $table.avatarRes, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<int> get steps =>
      $composableBuilder(column: $table.steps, builder: (column) => column);

  GeneratedColumn<int> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);

  GeneratedColumn<DateTime> get time =>
      $composableBuilder(column: $table.time, builder: (column) => column);

  GeneratedColumn<int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get likeCount =>
      $composableBuilder(column: $table.likeCount, builder: (column) => column);

  GeneratedColumn<bool> get isMock =>
      $composableBuilder(column: $table.isMock, builder: (column) => column);
}

class $$SocialFeedsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SocialFeedsTable,
          SocialFeed,
          $$SocialFeedsTableFilterComposer,
          $$SocialFeedsTableOrderingComposer,
          $$SocialFeedsTableAnnotationComposer,
          $$SocialFeedsTableCreateCompanionBuilder,
          $$SocialFeedsTableUpdateCompanionBuilder,
          (
            SocialFeed,
            BaseReferences<_$AppDatabase, $SocialFeedsTable, SocialFeed>,
          ),
          SocialFeed,
          PrefetchHooks Function()
        > {
  $$SocialFeedsTableTableManager(_$AppDatabase db, $SocialFeedsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SocialFeedsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SocialFeedsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SocialFeedsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> userName = const Value.absent(),
                Value<String?> avatarRes = const Value.absent(),
                Value<String?> content = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<int?> steps = const Value.absent(),
                Value<int?> calories = const Value.absent(),
                Value<DateTime> time = const Value.absent(),
                Value<int?> type = const Value.absent(),
                Value<int> likeCount = const Value.absent(),
                Value<bool> isMock = const Value.absent(),
              }) => SocialFeedsCompanion(
                id: id,
                userName: userName,
                avatarRes: avatarRes,
                content: content,
                imagePath: imagePath,
                steps: steps,
                calories: calories,
                time: time,
                type: type,
                likeCount: likeCount,
                isMock: isMock,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> userName = const Value.absent(),
                Value<String?> avatarRes = const Value.absent(),
                Value<String?> content = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<int?> steps = const Value.absent(),
                Value<int?> calories = const Value.absent(),
                required DateTime time,
                Value<int?> type = const Value.absent(),
                Value<int> likeCount = const Value.absent(),
                Value<bool> isMock = const Value.absent(),
              }) => SocialFeedsCompanion.insert(
                id: id,
                userName: userName,
                avatarRes: avatarRes,
                content: content,
                imagePath: imagePath,
                steps: steps,
                calories: calories,
                time: time,
                type: type,
                likeCount: likeCount,
                isMock: isMock,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SocialFeedsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SocialFeedsTable,
      SocialFeed,
      $$SocialFeedsTableFilterComposer,
      $$SocialFeedsTableOrderingComposer,
      $$SocialFeedsTableAnnotationComposer,
      $$SocialFeedsTableCreateCompanionBuilder,
      $$SocialFeedsTableUpdateCompanionBuilder,
      (
        SocialFeed,
        BaseReferences<_$AppDatabase, $SocialFeedsTable, SocialFeed>,
      ),
      SocialFeed,
      PrefetchHooks Function()
    >;
typedef $$ProfessionalWeightRecordsTableCreateCompanionBuilder =
    ProfessionalWeightRecordsCompanion Function({
      Value<int> id,
      required String userId,
      required DateTime recordDatetime,
      required double weight,
      Value<double?> bodyFatPercentage,
      Value<double?> muscleMass,
      Value<double?> boneMass,
      Value<double?> bodyWater,
      Value<int?> visceralFatLevel,
      Value<int?> basalMetabolism,
      Value<double?> proteinRate,
      Value<double?> subcutaneousFat,
      Value<String?> measurementTimeType,
      Value<String?> measurementDevice,
      Value<double?> roomTemperature,
      Value<double?> humidity,
      Value<int?> menstrualCycleDay,
      Value<int?> sleepQuality,
      Value<int?> stressLevel,
      Value<String?> hydrationStatus,
      Value<String?> notes,
      Value<String?> tags,
      Value<String?> photoUrl,
      Value<int?> moodScore,
      Value<DateTime> createdAt,
    });
typedef $$ProfessionalWeightRecordsTableUpdateCompanionBuilder =
    ProfessionalWeightRecordsCompanion Function({
      Value<int> id,
      Value<String> userId,
      Value<DateTime> recordDatetime,
      Value<double> weight,
      Value<double?> bodyFatPercentage,
      Value<double?> muscleMass,
      Value<double?> boneMass,
      Value<double?> bodyWater,
      Value<int?> visceralFatLevel,
      Value<int?> basalMetabolism,
      Value<double?> proteinRate,
      Value<double?> subcutaneousFat,
      Value<String?> measurementTimeType,
      Value<String?> measurementDevice,
      Value<double?> roomTemperature,
      Value<double?> humidity,
      Value<int?> menstrualCycleDay,
      Value<int?> sleepQuality,
      Value<int?> stressLevel,
      Value<String?> hydrationStatus,
      Value<String?> notes,
      Value<String?> tags,
      Value<String?> photoUrl,
      Value<int?> moodScore,
      Value<DateTime> createdAt,
    });

class $$ProfessionalWeightRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $ProfessionalWeightRecordsTable> {
  $$ProfessionalWeightRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recordDatetime => $composableBuilder(
    column: $table.recordDatetime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bodyFatPercentage => $composableBuilder(
    column: $table.bodyFatPercentage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get muscleMass => $composableBuilder(
    column: $table.muscleMass,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get boneMass => $composableBuilder(
    column: $table.boneMass,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bodyWater => $composableBuilder(
    column: $table.bodyWater,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get visceralFatLevel => $composableBuilder(
    column: $table.visceralFatLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get basalMetabolism => $composableBuilder(
    column: $table.basalMetabolism,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get proteinRate => $composableBuilder(
    column: $table.proteinRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get subcutaneousFat => $composableBuilder(
    column: $table.subcutaneousFat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get measurementTimeType => $composableBuilder(
    column: $table.measurementTimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get measurementDevice => $composableBuilder(
    column: $table.measurementDevice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get roomTemperature => $composableBuilder(
    column: $table.roomTemperature,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get humidity => $composableBuilder(
    column: $table.humidity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get menstrualCycleDay => $composableBuilder(
    column: $table.menstrualCycleDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sleepQuality => $composableBuilder(
    column: $table.sleepQuality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stressLevel => $composableBuilder(
    column: $table.stressLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hydrationStatus => $composableBuilder(
    column: $table.hydrationStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoUrl => $composableBuilder(
    column: $table.photoUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get moodScore => $composableBuilder(
    column: $table.moodScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProfessionalWeightRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfessionalWeightRecordsTable> {
  $$ProfessionalWeightRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recordDatetime => $composableBuilder(
    column: $table.recordDatetime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bodyFatPercentage => $composableBuilder(
    column: $table.bodyFatPercentage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get muscleMass => $composableBuilder(
    column: $table.muscleMass,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get boneMass => $composableBuilder(
    column: $table.boneMass,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bodyWater => $composableBuilder(
    column: $table.bodyWater,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get visceralFatLevel => $composableBuilder(
    column: $table.visceralFatLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get basalMetabolism => $composableBuilder(
    column: $table.basalMetabolism,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get proteinRate => $composableBuilder(
    column: $table.proteinRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get subcutaneousFat => $composableBuilder(
    column: $table.subcutaneousFat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get measurementTimeType => $composableBuilder(
    column: $table.measurementTimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get measurementDevice => $composableBuilder(
    column: $table.measurementDevice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get roomTemperature => $composableBuilder(
    column: $table.roomTemperature,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get humidity => $composableBuilder(
    column: $table.humidity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get menstrualCycleDay => $composableBuilder(
    column: $table.menstrualCycleDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sleepQuality => $composableBuilder(
    column: $table.sleepQuality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stressLevel => $composableBuilder(
    column: $table.stressLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hydrationStatus => $composableBuilder(
    column: $table.hydrationStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoUrl => $composableBuilder(
    column: $table.photoUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get moodScore => $composableBuilder(
    column: $table.moodScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProfessionalWeightRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfessionalWeightRecordsTable> {
  $$ProfessionalWeightRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get recordDatetime => $composableBuilder(
    column: $table.recordDatetime,
    builder: (column) => column,
  );

  GeneratedColumn<double> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<double> get bodyFatPercentage => $composableBuilder(
    column: $table.bodyFatPercentage,
    builder: (column) => column,
  );

  GeneratedColumn<double> get muscleMass => $composableBuilder(
    column: $table.muscleMass,
    builder: (column) => column,
  );

  GeneratedColumn<double> get boneMass =>
      $composableBuilder(column: $table.boneMass, builder: (column) => column);

  GeneratedColumn<double> get bodyWater =>
      $composableBuilder(column: $table.bodyWater, builder: (column) => column);

  GeneratedColumn<int> get visceralFatLevel => $composableBuilder(
    column: $table.visceralFatLevel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get basalMetabolism => $composableBuilder(
    column: $table.basalMetabolism,
    builder: (column) => column,
  );

  GeneratedColumn<double> get proteinRate => $composableBuilder(
    column: $table.proteinRate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get subcutaneousFat => $composableBuilder(
    column: $table.subcutaneousFat,
    builder: (column) => column,
  );

  GeneratedColumn<String> get measurementTimeType => $composableBuilder(
    column: $table.measurementTimeType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get measurementDevice => $composableBuilder(
    column: $table.measurementDevice,
    builder: (column) => column,
  );

  GeneratedColumn<double> get roomTemperature => $composableBuilder(
    column: $table.roomTemperature,
    builder: (column) => column,
  );

  GeneratedColumn<double> get humidity =>
      $composableBuilder(column: $table.humidity, builder: (column) => column);

  GeneratedColumn<int> get menstrualCycleDay => $composableBuilder(
    column: $table.menstrualCycleDay,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sleepQuality => $composableBuilder(
    column: $table.sleepQuality,
    builder: (column) => column,
  );

  GeneratedColumn<int> get stressLevel => $composableBuilder(
    column: $table.stressLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get hydrationStatus => $composableBuilder(
    column: $table.hydrationStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<String> get photoUrl =>
      $composableBuilder(column: $table.photoUrl, builder: (column) => column);

  GeneratedColumn<int> get moodScore =>
      $composableBuilder(column: $table.moodScore, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ProfessionalWeightRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfessionalWeightRecordsTable,
          ProfessionalWeightRecord,
          $$ProfessionalWeightRecordsTableFilterComposer,
          $$ProfessionalWeightRecordsTableOrderingComposer,
          $$ProfessionalWeightRecordsTableAnnotationComposer,
          $$ProfessionalWeightRecordsTableCreateCompanionBuilder,
          $$ProfessionalWeightRecordsTableUpdateCompanionBuilder,
          (
            ProfessionalWeightRecord,
            BaseReferences<
              _$AppDatabase,
              $ProfessionalWeightRecordsTable,
              ProfessionalWeightRecord
            >,
          ),
          ProfessionalWeightRecord,
          PrefetchHooks Function()
        > {
  $$ProfessionalWeightRecordsTableTableManager(
    _$AppDatabase db,
    $ProfessionalWeightRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfessionalWeightRecordsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ProfessionalWeightRecordsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ProfessionalWeightRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<DateTime> recordDatetime = const Value.absent(),
                Value<double> weight = const Value.absent(),
                Value<double?> bodyFatPercentage = const Value.absent(),
                Value<double?> muscleMass = const Value.absent(),
                Value<double?> boneMass = const Value.absent(),
                Value<double?> bodyWater = const Value.absent(),
                Value<int?> visceralFatLevel = const Value.absent(),
                Value<int?> basalMetabolism = const Value.absent(),
                Value<double?> proteinRate = const Value.absent(),
                Value<double?> subcutaneousFat = const Value.absent(),
                Value<String?> measurementTimeType = const Value.absent(),
                Value<String?> measurementDevice = const Value.absent(),
                Value<double?> roomTemperature = const Value.absent(),
                Value<double?> humidity = const Value.absent(),
                Value<int?> menstrualCycleDay = const Value.absent(),
                Value<int?> sleepQuality = const Value.absent(),
                Value<int?> stressLevel = const Value.absent(),
                Value<String?> hydrationStatus = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<String?> photoUrl = const Value.absent(),
                Value<int?> moodScore = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ProfessionalWeightRecordsCompanion(
                id: id,
                userId: userId,
                recordDatetime: recordDatetime,
                weight: weight,
                bodyFatPercentage: bodyFatPercentage,
                muscleMass: muscleMass,
                boneMass: boneMass,
                bodyWater: bodyWater,
                visceralFatLevel: visceralFatLevel,
                basalMetabolism: basalMetabolism,
                proteinRate: proteinRate,
                subcutaneousFat: subcutaneousFat,
                measurementTimeType: measurementTimeType,
                measurementDevice: measurementDevice,
                roomTemperature: roomTemperature,
                humidity: humidity,
                menstrualCycleDay: menstrualCycleDay,
                sleepQuality: sleepQuality,
                stressLevel: stressLevel,
                hydrationStatus: hydrationStatus,
                notes: notes,
                tags: tags,
                photoUrl: photoUrl,
                moodScore: moodScore,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String userId,
                required DateTime recordDatetime,
                required double weight,
                Value<double?> bodyFatPercentage = const Value.absent(),
                Value<double?> muscleMass = const Value.absent(),
                Value<double?> boneMass = const Value.absent(),
                Value<double?> bodyWater = const Value.absent(),
                Value<int?> visceralFatLevel = const Value.absent(),
                Value<int?> basalMetabolism = const Value.absent(),
                Value<double?> proteinRate = const Value.absent(),
                Value<double?> subcutaneousFat = const Value.absent(),
                Value<String?> measurementTimeType = const Value.absent(),
                Value<String?> measurementDevice = const Value.absent(),
                Value<double?> roomTemperature = const Value.absent(),
                Value<double?> humidity = const Value.absent(),
                Value<int?> menstrualCycleDay = const Value.absent(),
                Value<int?> sleepQuality = const Value.absent(),
                Value<int?> stressLevel = const Value.absent(),
                Value<String?> hydrationStatus = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<String?> photoUrl = const Value.absent(),
                Value<int?> moodScore = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ProfessionalWeightRecordsCompanion.insert(
                id: id,
                userId: userId,
                recordDatetime: recordDatetime,
                weight: weight,
                bodyFatPercentage: bodyFatPercentage,
                muscleMass: muscleMass,
                boneMass: boneMass,
                bodyWater: bodyWater,
                visceralFatLevel: visceralFatLevel,
                basalMetabolism: basalMetabolism,
                proteinRate: proteinRate,
                subcutaneousFat: subcutaneousFat,
                measurementTimeType: measurementTimeType,
                measurementDevice: measurementDevice,
                roomTemperature: roomTemperature,
                humidity: humidity,
                menstrualCycleDay: menstrualCycleDay,
                sleepQuality: sleepQuality,
                stressLevel: stressLevel,
                hydrationStatus: hydrationStatus,
                notes: notes,
                tags: tags,
                photoUrl: photoUrl,
                moodScore: moodScore,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProfessionalWeightRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProfessionalWeightRecordsTable,
      ProfessionalWeightRecord,
      $$ProfessionalWeightRecordsTableFilterComposer,
      $$ProfessionalWeightRecordsTableOrderingComposer,
      $$ProfessionalWeightRecordsTableAnnotationComposer,
      $$ProfessionalWeightRecordsTableCreateCompanionBuilder,
      $$ProfessionalWeightRecordsTableUpdateCompanionBuilder,
      (
        ProfessionalWeightRecord,
        BaseReferences<
          _$AppDatabase,
          $ProfessionalWeightRecordsTable,
          ProfessionalWeightRecord
        >,
      ),
      ProfessionalWeightRecord,
      PrefetchHooks Function()
    >;
typedef $$BloodPressureRecordsTableCreateCompanionBuilder =
    BloodPressureRecordsCompanion Function({
      Value<int> id,
      required String userId,
      required DateTime recordDatetime,
      required int systolicPressure,
      required int diastolicPressure,
      Value<int?> pulseRate,
      Value<double?> meanArterialPressure,
      Value<String?> measurementPosition,
      Value<String?> armUsed,
      Value<String?> cuffSize,
      Value<String?> deviceModel,
      Value<int> measurementCount,
      Value<int?> beforeRestTime,
      Value<double?> caffeineIntakeHours,
      Value<double?> exerciseHoursBefore,
      Value<double?> lastMealHours,
      Value<double?> smokingHoursBefore,
      Value<double?> alcoholHoursBefore,
      Value<String?> symptoms,
      Value<String?> medicationTaken,
      Value<double?> sleepHours,
      Value<String?> stressEvents,
      Value<double?> roomTemperature,
      Value<String?> noiseLevel,
      Value<String?> notes,
      Value<String?> tags,
      Value<DateTime> createdAt,
    });
typedef $$BloodPressureRecordsTableUpdateCompanionBuilder =
    BloodPressureRecordsCompanion Function({
      Value<int> id,
      Value<String> userId,
      Value<DateTime> recordDatetime,
      Value<int> systolicPressure,
      Value<int> diastolicPressure,
      Value<int?> pulseRate,
      Value<double?> meanArterialPressure,
      Value<String?> measurementPosition,
      Value<String?> armUsed,
      Value<String?> cuffSize,
      Value<String?> deviceModel,
      Value<int> measurementCount,
      Value<int?> beforeRestTime,
      Value<double?> caffeineIntakeHours,
      Value<double?> exerciseHoursBefore,
      Value<double?> lastMealHours,
      Value<double?> smokingHoursBefore,
      Value<double?> alcoholHoursBefore,
      Value<String?> symptoms,
      Value<String?> medicationTaken,
      Value<double?> sleepHours,
      Value<String?> stressEvents,
      Value<double?> roomTemperature,
      Value<String?> noiseLevel,
      Value<String?> notes,
      Value<String?> tags,
      Value<DateTime> createdAt,
    });

class $$BloodPressureRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $BloodPressureRecordsTable> {
  $$BloodPressureRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recordDatetime => $composableBuilder(
    column: $table.recordDatetime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get systolicPressure => $composableBuilder(
    column: $table.systolicPressure,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get diastolicPressure => $composableBuilder(
    column: $table.diastolicPressure,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pulseRate => $composableBuilder(
    column: $table.pulseRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get meanArterialPressure => $composableBuilder(
    column: $table.meanArterialPressure,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get measurementPosition => $composableBuilder(
    column: $table.measurementPosition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get armUsed => $composableBuilder(
    column: $table.armUsed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cuffSize => $composableBuilder(
    column: $table.cuffSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceModel => $composableBuilder(
    column: $table.deviceModel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get measurementCount => $composableBuilder(
    column: $table.measurementCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get beforeRestTime => $composableBuilder(
    column: $table.beforeRestTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get caffeineIntakeHours => $composableBuilder(
    column: $table.caffeineIntakeHours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get exerciseHoursBefore => $composableBuilder(
    column: $table.exerciseHoursBefore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lastMealHours => $composableBuilder(
    column: $table.lastMealHours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get smokingHoursBefore => $composableBuilder(
    column: $table.smokingHoursBefore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get alcoholHoursBefore => $composableBuilder(
    column: $table.alcoholHoursBefore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get symptoms => $composableBuilder(
    column: $table.symptoms,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get medicationTaken => $composableBuilder(
    column: $table.medicationTaken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get sleepHours => $composableBuilder(
    column: $table.sleepHours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stressEvents => $composableBuilder(
    column: $table.stressEvents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get roomTemperature => $composableBuilder(
    column: $table.roomTemperature,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get noiseLevel => $composableBuilder(
    column: $table.noiseLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BloodPressureRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $BloodPressureRecordsTable> {
  $$BloodPressureRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recordDatetime => $composableBuilder(
    column: $table.recordDatetime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get systolicPressure => $composableBuilder(
    column: $table.systolicPressure,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get diastolicPressure => $composableBuilder(
    column: $table.diastolicPressure,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pulseRate => $composableBuilder(
    column: $table.pulseRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get meanArterialPressure => $composableBuilder(
    column: $table.meanArterialPressure,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get measurementPosition => $composableBuilder(
    column: $table.measurementPosition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get armUsed => $composableBuilder(
    column: $table.armUsed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cuffSize => $composableBuilder(
    column: $table.cuffSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceModel => $composableBuilder(
    column: $table.deviceModel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get measurementCount => $composableBuilder(
    column: $table.measurementCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get beforeRestTime => $composableBuilder(
    column: $table.beforeRestTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get caffeineIntakeHours => $composableBuilder(
    column: $table.caffeineIntakeHours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get exerciseHoursBefore => $composableBuilder(
    column: $table.exerciseHoursBefore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lastMealHours => $composableBuilder(
    column: $table.lastMealHours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get smokingHoursBefore => $composableBuilder(
    column: $table.smokingHoursBefore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get alcoholHoursBefore => $composableBuilder(
    column: $table.alcoholHoursBefore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get symptoms => $composableBuilder(
    column: $table.symptoms,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get medicationTaken => $composableBuilder(
    column: $table.medicationTaken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sleepHours => $composableBuilder(
    column: $table.sleepHours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stressEvents => $composableBuilder(
    column: $table.stressEvents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get roomTemperature => $composableBuilder(
    column: $table.roomTemperature,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get noiseLevel => $composableBuilder(
    column: $table.noiseLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BloodPressureRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BloodPressureRecordsTable> {
  $$BloodPressureRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get recordDatetime => $composableBuilder(
    column: $table.recordDatetime,
    builder: (column) => column,
  );

  GeneratedColumn<int> get systolicPressure => $composableBuilder(
    column: $table.systolicPressure,
    builder: (column) => column,
  );

  GeneratedColumn<int> get diastolicPressure => $composableBuilder(
    column: $table.diastolicPressure,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pulseRate =>
      $composableBuilder(column: $table.pulseRate, builder: (column) => column);

  GeneratedColumn<double> get meanArterialPressure => $composableBuilder(
    column: $table.meanArterialPressure,
    builder: (column) => column,
  );

  GeneratedColumn<String> get measurementPosition => $composableBuilder(
    column: $table.measurementPosition,
    builder: (column) => column,
  );

  GeneratedColumn<String> get armUsed =>
      $composableBuilder(column: $table.armUsed, builder: (column) => column);

  GeneratedColumn<String> get cuffSize =>
      $composableBuilder(column: $table.cuffSize, builder: (column) => column);

  GeneratedColumn<String> get deviceModel => $composableBuilder(
    column: $table.deviceModel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get measurementCount => $composableBuilder(
    column: $table.measurementCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get beforeRestTime => $composableBuilder(
    column: $table.beforeRestTime,
    builder: (column) => column,
  );

  GeneratedColumn<double> get caffeineIntakeHours => $composableBuilder(
    column: $table.caffeineIntakeHours,
    builder: (column) => column,
  );

  GeneratedColumn<double> get exerciseHoursBefore => $composableBuilder(
    column: $table.exerciseHoursBefore,
    builder: (column) => column,
  );

  GeneratedColumn<double> get lastMealHours => $composableBuilder(
    column: $table.lastMealHours,
    builder: (column) => column,
  );

  GeneratedColumn<double> get smokingHoursBefore => $composableBuilder(
    column: $table.smokingHoursBefore,
    builder: (column) => column,
  );

  GeneratedColumn<double> get alcoholHoursBefore => $composableBuilder(
    column: $table.alcoholHoursBefore,
    builder: (column) => column,
  );

  GeneratedColumn<String> get symptoms =>
      $composableBuilder(column: $table.symptoms, builder: (column) => column);

  GeneratedColumn<String> get medicationTaken => $composableBuilder(
    column: $table.medicationTaken,
    builder: (column) => column,
  );

  GeneratedColumn<double> get sleepHours => $composableBuilder(
    column: $table.sleepHours,
    builder: (column) => column,
  );

  GeneratedColumn<String> get stressEvents => $composableBuilder(
    column: $table.stressEvents,
    builder: (column) => column,
  );

  GeneratedColumn<double> get roomTemperature => $composableBuilder(
    column: $table.roomTemperature,
    builder: (column) => column,
  );

  GeneratedColumn<String> get noiseLevel => $composableBuilder(
    column: $table.noiseLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$BloodPressureRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BloodPressureRecordsTable,
          BloodPressureRecord,
          $$BloodPressureRecordsTableFilterComposer,
          $$BloodPressureRecordsTableOrderingComposer,
          $$BloodPressureRecordsTableAnnotationComposer,
          $$BloodPressureRecordsTableCreateCompanionBuilder,
          $$BloodPressureRecordsTableUpdateCompanionBuilder,
          (
            BloodPressureRecord,
            BaseReferences<
              _$AppDatabase,
              $BloodPressureRecordsTable,
              BloodPressureRecord
            >,
          ),
          BloodPressureRecord,
          PrefetchHooks Function()
        > {
  $$BloodPressureRecordsTableTableManager(
    _$AppDatabase db,
    $BloodPressureRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BloodPressureRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BloodPressureRecordsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$BloodPressureRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<DateTime> recordDatetime = const Value.absent(),
                Value<int> systolicPressure = const Value.absent(),
                Value<int> diastolicPressure = const Value.absent(),
                Value<int?> pulseRate = const Value.absent(),
                Value<double?> meanArterialPressure = const Value.absent(),
                Value<String?> measurementPosition = const Value.absent(),
                Value<String?> armUsed = const Value.absent(),
                Value<String?> cuffSize = const Value.absent(),
                Value<String?> deviceModel = const Value.absent(),
                Value<int> measurementCount = const Value.absent(),
                Value<int?> beforeRestTime = const Value.absent(),
                Value<double?> caffeineIntakeHours = const Value.absent(),
                Value<double?> exerciseHoursBefore = const Value.absent(),
                Value<double?> lastMealHours = const Value.absent(),
                Value<double?> smokingHoursBefore = const Value.absent(),
                Value<double?> alcoholHoursBefore = const Value.absent(),
                Value<String?> symptoms = const Value.absent(),
                Value<String?> medicationTaken = const Value.absent(),
                Value<double?> sleepHours = const Value.absent(),
                Value<String?> stressEvents = const Value.absent(),
                Value<double?> roomTemperature = const Value.absent(),
                Value<String?> noiseLevel = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => BloodPressureRecordsCompanion(
                id: id,
                userId: userId,
                recordDatetime: recordDatetime,
                systolicPressure: systolicPressure,
                diastolicPressure: diastolicPressure,
                pulseRate: pulseRate,
                meanArterialPressure: meanArterialPressure,
                measurementPosition: measurementPosition,
                armUsed: armUsed,
                cuffSize: cuffSize,
                deviceModel: deviceModel,
                measurementCount: measurementCount,
                beforeRestTime: beforeRestTime,
                caffeineIntakeHours: caffeineIntakeHours,
                exerciseHoursBefore: exerciseHoursBefore,
                lastMealHours: lastMealHours,
                smokingHoursBefore: smokingHoursBefore,
                alcoholHoursBefore: alcoholHoursBefore,
                symptoms: symptoms,
                medicationTaken: medicationTaken,
                sleepHours: sleepHours,
                stressEvents: stressEvents,
                roomTemperature: roomTemperature,
                noiseLevel: noiseLevel,
                notes: notes,
                tags: tags,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String userId,
                required DateTime recordDatetime,
                required int systolicPressure,
                required int diastolicPressure,
                Value<int?> pulseRate = const Value.absent(),
                Value<double?> meanArterialPressure = const Value.absent(),
                Value<String?> measurementPosition = const Value.absent(),
                Value<String?> armUsed = const Value.absent(),
                Value<String?> cuffSize = const Value.absent(),
                Value<String?> deviceModel = const Value.absent(),
                Value<int> measurementCount = const Value.absent(),
                Value<int?> beforeRestTime = const Value.absent(),
                Value<double?> caffeineIntakeHours = const Value.absent(),
                Value<double?> exerciseHoursBefore = const Value.absent(),
                Value<double?> lastMealHours = const Value.absent(),
                Value<double?> smokingHoursBefore = const Value.absent(),
                Value<double?> alcoholHoursBefore = const Value.absent(),
                Value<String?> symptoms = const Value.absent(),
                Value<String?> medicationTaken = const Value.absent(),
                Value<double?> sleepHours = const Value.absent(),
                Value<String?> stressEvents = const Value.absent(),
                Value<double?> roomTemperature = const Value.absent(),
                Value<String?> noiseLevel = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => BloodPressureRecordsCompanion.insert(
                id: id,
                userId: userId,
                recordDatetime: recordDatetime,
                systolicPressure: systolicPressure,
                diastolicPressure: diastolicPressure,
                pulseRate: pulseRate,
                meanArterialPressure: meanArterialPressure,
                measurementPosition: measurementPosition,
                armUsed: armUsed,
                cuffSize: cuffSize,
                deviceModel: deviceModel,
                measurementCount: measurementCount,
                beforeRestTime: beforeRestTime,
                caffeineIntakeHours: caffeineIntakeHours,
                exerciseHoursBefore: exerciseHoursBefore,
                lastMealHours: lastMealHours,
                smokingHoursBefore: smokingHoursBefore,
                alcoholHoursBefore: alcoholHoursBefore,
                symptoms: symptoms,
                medicationTaken: medicationTaken,
                sleepHours: sleepHours,
                stressEvents: stressEvents,
                roomTemperature: roomTemperature,
                noiseLevel: noiseLevel,
                notes: notes,
                tags: tags,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BloodPressureRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BloodPressureRecordsTable,
      BloodPressureRecord,
      $$BloodPressureRecordsTableFilterComposer,
      $$BloodPressureRecordsTableOrderingComposer,
      $$BloodPressureRecordsTableAnnotationComposer,
      $$BloodPressureRecordsTableCreateCompanionBuilder,
      $$BloodPressureRecordsTableUpdateCompanionBuilder,
      (
        BloodPressureRecord,
        BaseReferences<
          _$AppDatabase,
          $BloodPressureRecordsTable,
          BloodPressureRecord
        >,
      ),
      BloodPressureRecord,
      PrefetchHooks Function()
    >;
typedef $$HeartRateRecordsTableCreateCompanionBuilder =
    HeartRateRecordsCompanion Function({
      Value<int> id,
      required String userId,
      required DateTime recordStartTime,
      Value<int?> recordDuration,
      required int avgHeartRate,
      Value<int?> maxHeartRate,
      Value<int?> minHeartRate,
      Value<int?> restingHeartRate,
      Value<double?> rmssd,
      Value<double?> pnn50,
      Value<double?> sdnn,
      Value<double?> stressIndex,
      Value<int?> zone1Time,
      Value<int?> zone2Time,
      Value<int?> zone3Time,
      Value<int?> zone4Time,
      Value<int?> zone5Time,
      Value<String?> activityType,
      Value<String?> bodyPosition,
      Value<String?> breathingPattern,
      Value<bool> caffeineIntake,
      Value<bool> alcoholIntake,
      Value<String?> medicationTaken,
      Value<double?> sleepHours,
      Value<String?> stressEvents,
      Value<String?> deviceInfo,
      Value<String?> rawDataUrl,
      Value<String?> notes,
      Value<String?> tags,
      Value<DateTime> createdAt,
    });
typedef $$HeartRateRecordsTableUpdateCompanionBuilder =
    HeartRateRecordsCompanion Function({
      Value<int> id,
      Value<String> userId,
      Value<DateTime> recordStartTime,
      Value<int?> recordDuration,
      Value<int> avgHeartRate,
      Value<int?> maxHeartRate,
      Value<int?> minHeartRate,
      Value<int?> restingHeartRate,
      Value<double?> rmssd,
      Value<double?> pnn50,
      Value<double?> sdnn,
      Value<double?> stressIndex,
      Value<int?> zone1Time,
      Value<int?> zone2Time,
      Value<int?> zone3Time,
      Value<int?> zone4Time,
      Value<int?> zone5Time,
      Value<String?> activityType,
      Value<String?> bodyPosition,
      Value<String?> breathingPattern,
      Value<bool> caffeineIntake,
      Value<bool> alcoholIntake,
      Value<String?> medicationTaken,
      Value<double?> sleepHours,
      Value<String?> stressEvents,
      Value<String?> deviceInfo,
      Value<String?> rawDataUrl,
      Value<String?> notes,
      Value<String?> tags,
      Value<DateTime> createdAt,
    });

class $$HeartRateRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $HeartRateRecordsTable> {
  $$HeartRateRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recordStartTime => $composableBuilder(
    column: $table.recordStartTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recordDuration => $composableBuilder(
    column: $table.recordDuration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get avgHeartRate => $composableBuilder(
    column: $table.avgHeartRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxHeartRate => $composableBuilder(
    column: $table.maxHeartRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minHeartRate => $composableBuilder(
    column: $table.minHeartRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get restingHeartRate => $composableBuilder(
    column: $table.restingHeartRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rmssd => $composableBuilder(
    column: $table.rmssd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pnn50 => $composableBuilder(
    column: $table.pnn50,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get sdnn => $composableBuilder(
    column: $table.sdnn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get stressIndex => $composableBuilder(
    column: $table.stressIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get zone1Time => $composableBuilder(
    column: $table.zone1Time,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get zone2Time => $composableBuilder(
    column: $table.zone2Time,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get zone3Time => $composableBuilder(
    column: $table.zone3Time,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get zone4Time => $composableBuilder(
    column: $table.zone4Time,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get zone5Time => $composableBuilder(
    column: $table.zone5Time,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activityType => $composableBuilder(
    column: $table.activityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bodyPosition => $composableBuilder(
    column: $table.bodyPosition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get breathingPattern => $composableBuilder(
    column: $table.breathingPattern,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get caffeineIntake => $composableBuilder(
    column: $table.caffeineIntake,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get alcoholIntake => $composableBuilder(
    column: $table.alcoholIntake,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get medicationTaken => $composableBuilder(
    column: $table.medicationTaken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get sleepHours => $composableBuilder(
    column: $table.sleepHours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stressEvents => $composableBuilder(
    column: $table.stressEvents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceInfo => $composableBuilder(
    column: $table.deviceInfo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawDataUrl => $composableBuilder(
    column: $table.rawDataUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HeartRateRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $HeartRateRecordsTable> {
  $$HeartRateRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recordStartTime => $composableBuilder(
    column: $table.recordStartTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recordDuration => $composableBuilder(
    column: $table.recordDuration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get avgHeartRate => $composableBuilder(
    column: $table.avgHeartRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxHeartRate => $composableBuilder(
    column: $table.maxHeartRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minHeartRate => $composableBuilder(
    column: $table.minHeartRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get restingHeartRate => $composableBuilder(
    column: $table.restingHeartRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rmssd => $composableBuilder(
    column: $table.rmssd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pnn50 => $composableBuilder(
    column: $table.pnn50,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sdnn => $composableBuilder(
    column: $table.sdnn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get stressIndex => $composableBuilder(
    column: $table.stressIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get zone1Time => $composableBuilder(
    column: $table.zone1Time,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get zone2Time => $composableBuilder(
    column: $table.zone2Time,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get zone3Time => $composableBuilder(
    column: $table.zone3Time,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get zone4Time => $composableBuilder(
    column: $table.zone4Time,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get zone5Time => $composableBuilder(
    column: $table.zone5Time,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activityType => $composableBuilder(
    column: $table.activityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bodyPosition => $composableBuilder(
    column: $table.bodyPosition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get breathingPattern => $composableBuilder(
    column: $table.breathingPattern,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get caffeineIntake => $composableBuilder(
    column: $table.caffeineIntake,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get alcoholIntake => $composableBuilder(
    column: $table.alcoholIntake,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get medicationTaken => $composableBuilder(
    column: $table.medicationTaken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sleepHours => $composableBuilder(
    column: $table.sleepHours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stressEvents => $composableBuilder(
    column: $table.stressEvents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceInfo => $composableBuilder(
    column: $table.deviceInfo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawDataUrl => $composableBuilder(
    column: $table.rawDataUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HeartRateRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HeartRateRecordsTable> {
  $$HeartRateRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get recordStartTime => $composableBuilder(
    column: $table.recordStartTime,
    builder: (column) => column,
  );

  GeneratedColumn<int> get recordDuration => $composableBuilder(
    column: $table.recordDuration,
    builder: (column) => column,
  );

  GeneratedColumn<int> get avgHeartRate => $composableBuilder(
    column: $table.avgHeartRate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maxHeartRate => $composableBuilder(
    column: $table.maxHeartRate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get minHeartRate => $composableBuilder(
    column: $table.minHeartRate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get restingHeartRate => $composableBuilder(
    column: $table.restingHeartRate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get rmssd =>
      $composableBuilder(column: $table.rmssd, builder: (column) => column);

  GeneratedColumn<double> get pnn50 =>
      $composableBuilder(column: $table.pnn50, builder: (column) => column);

  GeneratedColumn<double> get sdnn =>
      $composableBuilder(column: $table.sdnn, builder: (column) => column);

  GeneratedColumn<double> get stressIndex => $composableBuilder(
    column: $table.stressIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get zone1Time =>
      $composableBuilder(column: $table.zone1Time, builder: (column) => column);

  GeneratedColumn<int> get zone2Time =>
      $composableBuilder(column: $table.zone2Time, builder: (column) => column);

  GeneratedColumn<int> get zone3Time =>
      $composableBuilder(column: $table.zone3Time, builder: (column) => column);

  GeneratedColumn<int> get zone4Time =>
      $composableBuilder(column: $table.zone4Time, builder: (column) => column);

  GeneratedColumn<int> get zone5Time =>
      $composableBuilder(column: $table.zone5Time, builder: (column) => column);

  GeneratedColumn<String> get activityType => $composableBuilder(
    column: $table.activityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bodyPosition => $composableBuilder(
    column: $table.bodyPosition,
    builder: (column) => column,
  );

  GeneratedColumn<String> get breathingPattern => $composableBuilder(
    column: $table.breathingPattern,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get caffeineIntake => $composableBuilder(
    column: $table.caffeineIntake,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get alcoholIntake => $composableBuilder(
    column: $table.alcoholIntake,
    builder: (column) => column,
  );

  GeneratedColumn<String> get medicationTaken => $composableBuilder(
    column: $table.medicationTaken,
    builder: (column) => column,
  );

  GeneratedColumn<double> get sleepHours => $composableBuilder(
    column: $table.sleepHours,
    builder: (column) => column,
  );

  GeneratedColumn<String> get stressEvents => $composableBuilder(
    column: $table.stressEvents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deviceInfo => $composableBuilder(
    column: $table.deviceInfo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rawDataUrl => $composableBuilder(
    column: $table.rawDataUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$HeartRateRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HeartRateRecordsTable,
          HeartRateRecord,
          $$HeartRateRecordsTableFilterComposer,
          $$HeartRateRecordsTableOrderingComposer,
          $$HeartRateRecordsTableAnnotationComposer,
          $$HeartRateRecordsTableCreateCompanionBuilder,
          $$HeartRateRecordsTableUpdateCompanionBuilder,
          (
            HeartRateRecord,
            BaseReferences<
              _$AppDatabase,
              $HeartRateRecordsTable,
              HeartRateRecord
            >,
          ),
          HeartRateRecord,
          PrefetchHooks Function()
        > {
  $$HeartRateRecordsTableTableManager(
    _$AppDatabase db,
    $HeartRateRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HeartRateRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HeartRateRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HeartRateRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<DateTime> recordStartTime = const Value.absent(),
                Value<int?> recordDuration = const Value.absent(),
                Value<int> avgHeartRate = const Value.absent(),
                Value<int?> maxHeartRate = const Value.absent(),
                Value<int?> minHeartRate = const Value.absent(),
                Value<int?> restingHeartRate = const Value.absent(),
                Value<double?> rmssd = const Value.absent(),
                Value<double?> pnn50 = const Value.absent(),
                Value<double?> sdnn = const Value.absent(),
                Value<double?> stressIndex = const Value.absent(),
                Value<int?> zone1Time = const Value.absent(),
                Value<int?> zone2Time = const Value.absent(),
                Value<int?> zone3Time = const Value.absent(),
                Value<int?> zone4Time = const Value.absent(),
                Value<int?> zone5Time = const Value.absent(),
                Value<String?> activityType = const Value.absent(),
                Value<String?> bodyPosition = const Value.absent(),
                Value<String?> breathingPattern = const Value.absent(),
                Value<bool> caffeineIntake = const Value.absent(),
                Value<bool> alcoholIntake = const Value.absent(),
                Value<String?> medicationTaken = const Value.absent(),
                Value<double?> sleepHours = const Value.absent(),
                Value<String?> stressEvents = const Value.absent(),
                Value<String?> deviceInfo = const Value.absent(),
                Value<String?> rawDataUrl = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => HeartRateRecordsCompanion(
                id: id,
                userId: userId,
                recordStartTime: recordStartTime,
                recordDuration: recordDuration,
                avgHeartRate: avgHeartRate,
                maxHeartRate: maxHeartRate,
                minHeartRate: minHeartRate,
                restingHeartRate: restingHeartRate,
                rmssd: rmssd,
                pnn50: pnn50,
                sdnn: sdnn,
                stressIndex: stressIndex,
                zone1Time: zone1Time,
                zone2Time: zone2Time,
                zone3Time: zone3Time,
                zone4Time: zone4Time,
                zone5Time: zone5Time,
                activityType: activityType,
                bodyPosition: bodyPosition,
                breathingPattern: breathingPattern,
                caffeineIntake: caffeineIntake,
                alcoholIntake: alcoholIntake,
                medicationTaken: medicationTaken,
                sleepHours: sleepHours,
                stressEvents: stressEvents,
                deviceInfo: deviceInfo,
                rawDataUrl: rawDataUrl,
                notes: notes,
                tags: tags,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String userId,
                required DateTime recordStartTime,
                Value<int?> recordDuration = const Value.absent(),
                required int avgHeartRate,
                Value<int?> maxHeartRate = const Value.absent(),
                Value<int?> minHeartRate = const Value.absent(),
                Value<int?> restingHeartRate = const Value.absent(),
                Value<double?> rmssd = const Value.absent(),
                Value<double?> pnn50 = const Value.absent(),
                Value<double?> sdnn = const Value.absent(),
                Value<double?> stressIndex = const Value.absent(),
                Value<int?> zone1Time = const Value.absent(),
                Value<int?> zone2Time = const Value.absent(),
                Value<int?> zone3Time = const Value.absent(),
                Value<int?> zone4Time = const Value.absent(),
                Value<int?> zone5Time = const Value.absent(),
                Value<String?> activityType = const Value.absent(),
                Value<String?> bodyPosition = const Value.absent(),
                Value<String?> breathingPattern = const Value.absent(),
                Value<bool> caffeineIntake = const Value.absent(),
                Value<bool> alcoholIntake = const Value.absent(),
                Value<String?> medicationTaken = const Value.absent(),
                Value<double?> sleepHours = const Value.absent(),
                Value<String?> stressEvents = const Value.absent(),
                Value<String?> deviceInfo = const Value.absent(),
                Value<String?> rawDataUrl = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => HeartRateRecordsCompanion.insert(
                id: id,
                userId: userId,
                recordStartTime: recordStartTime,
                recordDuration: recordDuration,
                avgHeartRate: avgHeartRate,
                maxHeartRate: maxHeartRate,
                minHeartRate: minHeartRate,
                restingHeartRate: restingHeartRate,
                rmssd: rmssd,
                pnn50: pnn50,
                sdnn: sdnn,
                stressIndex: stressIndex,
                zone1Time: zone1Time,
                zone2Time: zone2Time,
                zone3Time: zone3Time,
                zone4Time: zone4Time,
                zone5Time: zone5Time,
                activityType: activityType,
                bodyPosition: bodyPosition,
                breathingPattern: breathingPattern,
                caffeineIntake: caffeineIntake,
                alcoholIntake: alcoholIntake,
                medicationTaken: medicationTaken,
                sleepHours: sleepHours,
                stressEvents: stressEvents,
                deviceInfo: deviceInfo,
                rawDataUrl: rawDataUrl,
                notes: notes,
                tags: tags,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HeartRateRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HeartRateRecordsTable,
      HeartRateRecord,
      $$HeartRateRecordsTableFilterComposer,
      $$HeartRateRecordsTableOrderingComposer,
      $$HeartRateRecordsTableAnnotationComposer,
      $$HeartRateRecordsTableCreateCompanionBuilder,
      $$HeartRateRecordsTableUpdateCompanionBuilder,
      (
        HeartRateRecord,
        BaseReferences<_$AppDatabase, $HeartRateRecordsTable, HeartRateRecord>,
      ),
      HeartRateRecord,
      PrefetchHooks Function()
    >;
typedef $$BloodGlucoseRecordsTableCreateCompanionBuilder =
    BloodGlucoseRecordsCompanion Function({
      Value<int> id,
      required String userId,
      required DateTime recordDatetime,
      required double glucoseValue,
      Value<String> glucoseUnit,
      Value<String?> measurementTiming,
      Value<double?> fastingHours,
      Value<String?> mealRelationship,
      Value<double?> lastMealCarbs,
      Value<double?> lastMealGiScore,
      Value<String?> mealComposition,
      Value<String?> exerciseBeforeTest,
      Value<String?> exerciseIntensity,
      Value<int?> exerciseDuration,
      Value<double?> insulinDose,
      Value<int?> insulinTimeBefore,
      Value<String?> medicationList,
      Value<String?> illnessStatus,
      Value<int?> stressLevel,
      Value<int?> menstrualCycleDay,
      Value<int?> sleepQuality,
      Value<String?> hypoglycemiaSymptoms,
      Value<String?> hyperglycemiaSymptoms,
      Value<double?> ketoneLevel,
      Value<String?> notes,
      Value<String?> deviceInfo,
      Value<DateTime> createdAt,
    });
typedef $$BloodGlucoseRecordsTableUpdateCompanionBuilder =
    BloodGlucoseRecordsCompanion Function({
      Value<int> id,
      Value<String> userId,
      Value<DateTime> recordDatetime,
      Value<double> glucoseValue,
      Value<String> glucoseUnit,
      Value<String?> measurementTiming,
      Value<double?> fastingHours,
      Value<String?> mealRelationship,
      Value<double?> lastMealCarbs,
      Value<double?> lastMealGiScore,
      Value<String?> mealComposition,
      Value<String?> exerciseBeforeTest,
      Value<String?> exerciseIntensity,
      Value<int?> exerciseDuration,
      Value<double?> insulinDose,
      Value<int?> insulinTimeBefore,
      Value<String?> medicationList,
      Value<String?> illnessStatus,
      Value<int?> stressLevel,
      Value<int?> menstrualCycleDay,
      Value<int?> sleepQuality,
      Value<String?> hypoglycemiaSymptoms,
      Value<String?> hyperglycemiaSymptoms,
      Value<double?> ketoneLevel,
      Value<String?> notes,
      Value<String?> deviceInfo,
      Value<DateTime> createdAt,
    });

class $$BloodGlucoseRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $BloodGlucoseRecordsTable> {
  $$BloodGlucoseRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recordDatetime => $composableBuilder(
    column: $table.recordDatetime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get glucoseValue => $composableBuilder(
    column: $table.glucoseValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get glucoseUnit => $composableBuilder(
    column: $table.glucoseUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get measurementTiming => $composableBuilder(
    column: $table.measurementTiming,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fastingHours => $composableBuilder(
    column: $table.fastingHours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mealRelationship => $composableBuilder(
    column: $table.mealRelationship,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lastMealCarbs => $composableBuilder(
    column: $table.lastMealCarbs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lastMealGiScore => $composableBuilder(
    column: $table.lastMealGiScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mealComposition => $composableBuilder(
    column: $table.mealComposition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseBeforeTest => $composableBuilder(
    column: $table.exerciseBeforeTest,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseIntensity => $composableBuilder(
    column: $table.exerciseIntensity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get exerciseDuration => $composableBuilder(
    column: $table.exerciseDuration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get insulinDose => $composableBuilder(
    column: $table.insulinDose,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get insulinTimeBefore => $composableBuilder(
    column: $table.insulinTimeBefore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get medicationList => $composableBuilder(
    column: $table.medicationList,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get illnessStatus => $composableBuilder(
    column: $table.illnessStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stressLevel => $composableBuilder(
    column: $table.stressLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get menstrualCycleDay => $composableBuilder(
    column: $table.menstrualCycleDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sleepQuality => $composableBuilder(
    column: $table.sleepQuality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hypoglycemiaSymptoms => $composableBuilder(
    column: $table.hypoglycemiaSymptoms,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hyperglycemiaSymptoms => $composableBuilder(
    column: $table.hyperglycemiaSymptoms,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get ketoneLevel => $composableBuilder(
    column: $table.ketoneLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceInfo => $composableBuilder(
    column: $table.deviceInfo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BloodGlucoseRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $BloodGlucoseRecordsTable> {
  $$BloodGlucoseRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recordDatetime => $composableBuilder(
    column: $table.recordDatetime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get glucoseValue => $composableBuilder(
    column: $table.glucoseValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get glucoseUnit => $composableBuilder(
    column: $table.glucoseUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get measurementTiming => $composableBuilder(
    column: $table.measurementTiming,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fastingHours => $composableBuilder(
    column: $table.fastingHours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mealRelationship => $composableBuilder(
    column: $table.mealRelationship,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lastMealCarbs => $composableBuilder(
    column: $table.lastMealCarbs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lastMealGiScore => $composableBuilder(
    column: $table.lastMealGiScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mealComposition => $composableBuilder(
    column: $table.mealComposition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseBeforeTest => $composableBuilder(
    column: $table.exerciseBeforeTest,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseIntensity => $composableBuilder(
    column: $table.exerciseIntensity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get exerciseDuration => $composableBuilder(
    column: $table.exerciseDuration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get insulinDose => $composableBuilder(
    column: $table.insulinDose,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get insulinTimeBefore => $composableBuilder(
    column: $table.insulinTimeBefore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get medicationList => $composableBuilder(
    column: $table.medicationList,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get illnessStatus => $composableBuilder(
    column: $table.illnessStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stressLevel => $composableBuilder(
    column: $table.stressLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get menstrualCycleDay => $composableBuilder(
    column: $table.menstrualCycleDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sleepQuality => $composableBuilder(
    column: $table.sleepQuality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hypoglycemiaSymptoms => $composableBuilder(
    column: $table.hypoglycemiaSymptoms,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hyperglycemiaSymptoms => $composableBuilder(
    column: $table.hyperglycemiaSymptoms,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get ketoneLevel => $composableBuilder(
    column: $table.ketoneLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceInfo => $composableBuilder(
    column: $table.deviceInfo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BloodGlucoseRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BloodGlucoseRecordsTable> {
  $$BloodGlucoseRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get recordDatetime => $composableBuilder(
    column: $table.recordDatetime,
    builder: (column) => column,
  );

  GeneratedColumn<double> get glucoseValue => $composableBuilder(
    column: $table.glucoseValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get glucoseUnit => $composableBuilder(
    column: $table.glucoseUnit,
    builder: (column) => column,
  );

  GeneratedColumn<String> get measurementTiming => $composableBuilder(
    column: $table.measurementTiming,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fastingHours => $composableBuilder(
    column: $table.fastingHours,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mealRelationship => $composableBuilder(
    column: $table.mealRelationship,
    builder: (column) => column,
  );

  GeneratedColumn<double> get lastMealCarbs => $composableBuilder(
    column: $table.lastMealCarbs,
    builder: (column) => column,
  );

  GeneratedColumn<double> get lastMealGiScore => $composableBuilder(
    column: $table.lastMealGiScore,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mealComposition => $composableBuilder(
    column: $table.mealComposition,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exerciseBeforeTest => $composableBuilder(
    column: $table.exerciseBeforeTest,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exerciseIntensity => $composableBuilder(
    column: $table.exerciseIntensity,
    builder: (column) => column,
  );

  GeneratedColumn<int> get exerciseDuration => $composableBuilder(
    column: $table.exerciseDuration,
    builder: (column) => column,
  );

  GeneratedColumn<double> get insulinDose => $composableBuilder(
    column: $table.insulinDose,
    builder: (column) => column,
  );

  GeneratedColumn<int> get insulinTimeBefore => $composableBuilder(
    column: $table.insulinTimeBefore,
    builder: (column) => column,
  );

  GeneratedColumn<String> get medicationList => $composableBuilder(
    column: $table.medicationList,
    builder: (column) => column,
  );

  GeneratedColumn<String> get illnessStatus => $composableBuilder(
    column: $table.illnessStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get stressLevel => $composableBuilder(
    column: $table.stressLevel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get menstrualCycleDay => $composableBuilder(
    column: $table.menstrualCycleDay,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sleepQuality => $composableBuilder(
    column: $table.sleepQuality,
    builder: (column) => column,
  );

  GeneratedColumn<String> get hypoglycemiaSymptoms => $composableBuilder(
    column: $table.hypoglycemiaSymptoms,
    builder: (column) => column,
  );

  GeneratedColumn<String> get hyperglycemiaSymptoms => $composableBuilder(
    column: $table.hyperglycemiaSymptoms,
    builder: (column) => column,
  );

  GeneratedColumn<double> get ketoneLevel => $composableBuilder(
    column: $table.ketoneLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get deviceInfo => $composableBuilder(
    column: $table.deviceInfo,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$BloodGlucoseRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BloodGlucoseRecordsTable,
          BloodGlucoseRecord,
          $$BloodGlucoseRecordsTableFilterComposer,
          $$BloodGlucoseRecordsTableOrderingComposer,
          $$BloodGlucoseRecordsTableAnnotationComposer,
          $$BloodGlucoseRecordsTableCreateCompanionBuilder,
          $$BloodGlucoseRecordsTableUpdateCompanionBuilder,
          (
            BloodGlucoseRecord,
            BaseReferences<
              _$AppDatabase,
              $BloodGlucoseRecordsTable,
              BloodGlucoseRecord
            >,
          ),
          BloodGlucoseRecord,
          PrefetchHooks Function()
        > {
  $$BloodGlucoseRecordsTableTableManager(
    _$AppDatabase db,
    $BloodGlucoseRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BloodGlucoseRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BloodGlucoseRecordsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$BloodGlucoseRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<DateTime> recordDatetime = const Value.absent(),
                Value<double> glucoseValue = const Value.absent(),
                Value<String> glucoseUnit = const Value.absent(),
                Value<String?> measurementTiming = const Value.absent(),
                Value<double?> fastingHours = const Value.absent(),
                Value<String?> mealRelationship = const Value.absent(),
                Value<double?> lastMealCarbs = const Value.absent(),
                Value<double?> lastMealGiScore = const Value.absent(),
                Value<String?> mealComposition = const Value.absent(),
                Value<String?> exerciseBeforeTest = const Value.absent(),
                Value<String?> exerciseIntensity = const Value.absent(),
                Value<int?> exerciseDuration = const Value.absent(),
                Value<double?> insulinDose = const Value.absent(),
                Value<int?> insulinTimeBefore = const Value.absent(),
                Value<String?> medicationList = const Value.absent(),
                Value<String?> illnessStatus = const Value.absent(),
                Value<int?> stressLevel = const Value.absent(),
                Value<int?> menstrualCycleDay = const Value.absent(),
                Value<int?> sleepQuality = const Value.absent(),
                Value<String?> hypoglycemiaSymptoms = const Value.absent(),
                Value<String?> hyperglycemiaSymptoms = const Value.absent(),
                Value<double?> ketoneLevel = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> deviceInfo = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => BloodGlucoseRecordsCompanion(
                id: id,
                userId: userId,
                recordDatetime: recordDatetime,
                glucoseValue: glucoseValue,
                glucoseUnit: glucoseUnit,
                measurementTiming: measurementTiming,
                fastingHours: fastingHours,
                mealRelationship: mealRelationship,
                lastMealCarbs: lastMealCarbs,
                lastMealGiScore: lastMealGiScore,
                mealComposition: mealComposition,
                exerciseBeforeTest: exerciseBeforeTest,
                exerciseIntensity: exerciseIntensity,
                exerciseDuration: exerciseDuration,
                insulinDose: insulinDose,
                insulinTimeBefore: insulinTimeBefore,
                medicationList: medicationList,
                illnessStatus: illnessStatus,
                stressLevel: stressLevel,
                menstrualCycleDay: menstrualCycleDay,
                sleepQuality: sleepQuality,
                hypoglycemiaSymptoms: hypoglycemiaSymptoms,
                hyperglycemiaSymptoms: hyperglycemiaSymptoms,
                ketoneLevel: ketoneLevel,
                notes: notes,
                deviceInfo: deviceInfo,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String userId,
                required DateTime recordDatetime,
                required double glucoseValue,
                Value<String> glucoseUnit = const Value.absent(),
                Value<String?> measurementTiming = const Value.absent(),
                Value<double?> fastingHours = const Value.absent(),
                Value<String?> mealRelationship = const Value.absent(),
                Value<double?> lastMealCarbs = const Value.absent(),
                Value<double?> lastMealGiScore = const Value.absent(),
                Value<String?> mealComposition = const Value.absent(),
                Value<String?> exerciseBeforeTest = const Value.absent(),
                Value<String?> exerciseIntensity = const Value.absent(),
                Value<int?> exerciseDuration = const Value.absent(),
                Value<double?> insulinDose = const Value.absent(),
                Value<int?> insulinTimeBefore = const Value.absent(),
                Value<String?> medicationList = const Value.absent(),
                Value<String?> illnessStatus = const Value.absent(),
                Value<int?> stressLevel = const Value.absent(),
                Value<int?> menstrualCycleDay = const Value.absent(),
                Value<int?> sleepQuality = const Value.absent(),
                Value<String?> hypoglycemiaSymptoms = const Value.absent(),
                Value<String?> hyperglycemiaSymptoms = const Value.absent(),
                Value<double?> ketoneLevel = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> deviceInfo = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => BloodGlucoseRecordsCompanion.insert(
                id: id,
                userId: userId,
                recordDatetime: recordDatetime,
                glucoseValue: glucoseValue,
                glucoseUnit: glucoseUnit,
                measurementTiming: measurementTiming,
                fastingHours: fastingHours,
                mealRelationship: mealRelationship,
                lastMealCarbs: lastMealCarbs,
                lastMealGiScore: lastMealGiScore,
                mealComposition: mealComposition,
                exerciseBeforeTest: exerciseBeforeTest,
                exerciseIntensity: exerciseIntensity,
                exerciseDuration: exerciseDuration,
                insulinDose: insulinDose,
                insulinTimeBefore: insulinTimeBefore,
                medicationList: medicationList,
                illnessStatus: illnessStatus,
                stressLevel: stressLevel,
                menstrualCycleDay: menstrualCycleDay,
                sleepQuality: sleepQuality,
                hypoglycemiaSymptoms: hypoglycemiaSymptoms,
                hyperglycemiaSymptoms: hyperglycemiaSymptoms,
                ketoneLevel: ketoneLevel,
                notes: notes,
                deviceInfo: deviceInfo,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BloodGlucoseRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BloodGlucoseRecordsTable,
      BloodGlucoseRecord,
      $$BloodGlucoseRecordsTableFilterComposer,
      $$BloodGlucoseRecordsTableOrderingComposer,
      $$BloodGlucoseRecordsTableAnnotationComposer,
      $$BloodGlucoseRecordsTableCreateCompanionBuilder,
      $$BloodGlucoseRecordsTableUpdateCompanionBuilder,
      (
        BloodGlucoseRecord,
        BaseReferences<
          _$AppDatabase,
          $BloodGlucoseRecordsTable,
          BloodGlucoseRecord
        >,
      ),
      BloodGlucoseRecord,
      PrefetchHooks Function()
    >;
typedef $$BloodLipidsRecordsTableCreateCompanionBuilder =
    BloodLipidsRecordsCompanion Function({
      Value<int> id,
      required String userId,
      required DateTime recordDatetime,
      Value<double?> totalCholesterol,
      Value<double?> triglycerides,
      Value<double?> hdlCholesterol,
      Value<double?> ldlCholesterol,
      Value<bool> fastingStatus,
      Value<DateTime?> lastMealTime,
      Value<String?> deviceInfo,
      Value<String?> medicationTaken,
      Value<String?> symptoms,
      Value<String?> notes,
      Value<String?> tags,
      Value<DateTime> createdAt,
    });
typedef $$BloodLipidsRecordsTableUpdateCompanionBuilder =
    BloodLipidsRecordsCompanion Function({
      Value<int> id,
      Value<String> userId,
      Value<DateTime> recordDatetime,
      Value<double?> totalCholesterol,
      Value<double?> triglycerides,
      Value<double?> hdlCholesterol,
      Value<double?> ldlCholesterol,
      Value<bool> fastingStatus,
      Value<DateTime?> lastMealTime,
      Value<String?> deviceInfo,
      Value<String?> medicationTaken,
      Value<String?> symptoms,
      Value<String?> notes,
      Value<String?> tags,
      Value<DateTime> createdAt,
    });

class $$BloodLipidsRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $BloodLipidsRecordsTable> {
  $$BloodLipidsRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recordDatetime => $composableBuilder(
    column: $table.recordDatetime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalCholesterol => $composableBuilder(
    column: $table.totalCholesterol,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get triglycerides => $composableBuilder(
    column: $table.triglycerides,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hdlCholesterol => $composableBuilder(
    column: $table.hdlCholesterol,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get ldlCholesterol => $composableBuilder(
    column: $table.ldlCholesterol,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get fastingStatus => $composableBuilder(
    column: $table.fastingStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastMealTime => $composableBuilder(
    column: $table.lastMealTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceInfo => $composableBuilder(
    column: $table.deviceInfo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get medicationTaken => $composableBuilder(
    column: $table.medicationTaken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get symptoms => $composableBuilder(
    column: $table.symptoms,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BloodLipidsRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $BloodLipidsRecordsTable> {
  $$BloodLipidsRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recordDatetime => $composableBuilder(
    column: $table.recordDatetime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalCholesterol => $composableBuilder(
    column: $table.totalCholesterol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get triglycerides => $composableBuilder(
    column: $table.triglycerides,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hdlCholesterol => $composableBuilder(
    column: $table.hdlCholesterol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get ldlCholesterol => $composableBuilder(
    column: $table.ldlCholesterol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get fastingStatus => $composableBuilder(
    column: $table.fastingStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastMealTime => $composableBuilder(
    column: $table.lastMealTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceInfo => $composableBuilder(
    column: $table.deviceInfo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get medicationTaken => $composableBuilder(
    column: $table.medicationTaken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get symptoms => $composableBuilder(
    column: $table.symptoms,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BloodLipidsRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BloodLipidsRecordsTable> {
  $$BloodLipidsRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get recordDatetime => $composableBuilder(
    column: $table.recordDatetime,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalCholesterol => $composableBuilder(
    column: $table.totalCholesterol,
    builder: (column) => column,
  );

  GeneratedColumn<double> get triglycerides => $composableBuilder(
    column: $table.triglycerides,
    builder: (column) => column,
  );

  GeneratedColumn<double> get hdlCholesterol => $composableBuilder(
    column: $table.hdlCholesterol,
    builder: (column) => column,
  );

  GeneratedColumn<double> get ldlCholesterol => $composableBuilder(
    column: $table.ldlCholesterol,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get fastingStatus => $composableBuilder(
    column: $table.fastingStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastMealTime => $composableBuilder(
    column: $table.lastMealTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deviceInfo => $composableBuilder(
    column: $table.deviceInfo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get medicationTaken => $composableBuilder(
    column: $table.medicationTaken,
    builder: (column) => column,
  );

  GeneratedColumn<String> get symptoms =>
      $composableBuilder(column: $table.symptoms, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$BloodLipidsRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BloodLipidsRecordsTable,
          BloodLipidsRecord,
          $$BloodLipidsRecordsTableFilterComposer,
          $$BloodLipidsRecordsTableOrderingComposer,
          $$BloodLipidsRecordsTableAnnotationComposer,
          $$BloodLipidsRecordsTableCreateCompanionBuilder,
          $$BloodLipidsRecordsTableUpdateCompanionBuilder,
          (
            BloodLipidsRecord,
            BaseReferences<
              _$AppDatabase,
              $BloodLipidsRecordsTable,
              BloodLipidsRecord
            >,
          ),
          BloodLipidsRecord,
          PrefetchHooks Function()
        > {
  $$BloodLipidsRecordsTableTableManager(
    _$AppDatabase db,
    $BloodLipidsRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BloodLipidsRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BloodLipidsRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BloodLipidsRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<DateTime> recordDatetime = const Value.absent(),
                Value<double?> totalCholesterol = const Value.absent(),
                Value<double?> triglycerides = const Value.absent(),
                Value<double?> hdlCholesterol = const Value.absent(),
                Value<double?> ldlCholesterol = const Value.absent(),
                Value<bool> fastingStatus = const Value.absent(),
                Value<DateTime?> lastMealTime = const Value.absent(),
                Value<String?> deviceInfo = const Value.absent(),
                Value<String?> medicationTaken = const Value.absent(),
                Value<String?> symptoms = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => BloodLipidsRecordsCompanion(
                id: id,
                userId: userId,
                recordDatetime: recordDatetime,
                totalCholesterol: totalCholesterol,
                triglycerides: triglycerides,
                hdlCholesterol: hdlCholesterol,
                ldlCholesterol: ldlCholesterol,
                fastingStatus: fastingStatus,
                lastMealTime: lastMealTime,
                deviceInfo: deviceInfo,
                medicationTaken: medicationTaken,
                symptoms: symptoms,
                notes: notes,
                tags: tags,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String userId,
                required DateTime recordDatetime,
                Value<double?> totalCholesterol = const Value.absent(),
                Value<double?> triglycerides = const Value.absent(),
                Value<double?> hdlCholesterol = const Value.absent(),
                Value<double?> ldlCholesterol = const Value.absent(),
                Value<bool> fastingStatus = const Value.absent(),
                Value<DateTime?> lastMealTime = const Value.absent(),
                Value<String?> deviceInfo = const Value.absent(),
                Value<String?> medicationTaken = const Value.absent(),
                Value<String?> symptoms = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => BloodLipidsRecordsCompanion.insert(
                id: id,
                userId: userId,
                recordDatetime: recordDatetime,
                totalCholesterol: totalCholesterol,
                triglycerides: triglycerides,
                hdlCholesterol: hdlCholesterol,
                ldlCholesterol: ldlCholesterol,
                fastingStatus: fastingStatus,
                lastMealTime: lastMealTime,
                deviceInfo: deviceInfo,
                medicationTaken: medicationTaken,
                symptoms: symptoms,
                notes: notes,
                tags: tags,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BloodLipidsRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BloodLipidsRecordsTable,
      BloodLipidsRecord,
      $$BloodLipidsRecordsTableFilterComposer,
      $$BloodLipidsRecordsTableOrderingComposer,
      $$BloodLipidsRecordsTableAnnotationComposer,
      $$BloodLipidsRecordsTableCreateCompanionBuilder,
      $$BloodLipidsRecordsTableUpdateCompanionBuilder,
      (
        BloodLipidsRecord,
        BaseReferences<
          _$AppDatabase,
          $BloodLipidsRecordsTable,
          BloodLipidsRecord
        >,
      ),
      BloodLipidsRecord,
      PrefetchHooks Function()
    >;
typedef $$ExerciseRecordsTableCreateCompanionBuilder =
    ExerciseRecordsCompanion Function({
      Value<int> id,
      required String userId,
      required DateTime startTime,
      Value<DateTime?> endTime,
      Value<int?> duration,
      Value<String?> exerciseType,
      Value<String?> exerciseName,
      Value<String?> intensity,
      Value<String?> location,
      Value<String?> weatherCondition,
      Value<double?> distance,
      Value<double?> averageSpeed,
      Value<double?> maxSpeed,
      Value<String?> routeData,
      Value<double?> elevation,
      Value<int?> averageHeartRate,
      Value<int?> maxHeartRate,
      Value<int?> minHeartRate,
      Value<int?> restingHeartRate,
      Value<int?> hrZone1Time,
      Value<int?> hrZone2Time,
      Value<int?> hrZone3Time,
      Value<int?> hrZone4Time,
      Value<int?> hrZone5Time,
      Value<String?> exerciseSets,
      Value<double?> totalWeight,
      Value<int?> totalReps,
      Value<double?> oneRepMax,
      Value<int?> caloriesBurned,
      Value<int?> steps,
      Value<String?> feeling,
      Value<double?> trainingLoad,
      Value<String?> rpeScore,
      Value<double?> trainingStressScore,
      Value<int?> averageCadence,
      Value<int?> maxCadence,
      Value<double?> strideLength,
      Value<double?> verticalRatio,
      Value<double?> groundContactTime,
      Value<double?> temperature,
      Value<double?> humidity,
      Value<int?> sleepHoursLastNight,
      Value<int?> stressLevel,
      Value<int?> energyLevel,
      Value<int?> motivationLevel,
      Value<String?> equipment,
      Value<String?> shoes,
      Value<String?> deviceInfo,
      Value<String?> goals,
      Value<bool> personalRecord,
      Value<String?> achievements,
      Value<int?> recoveryHeartRate,
      Value<double?> recoveryScore,
      Value<String?> recoveryMetrics,
      Value<String?> notes,
      Value<String?> tags,
      Value<String?> photos,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$ExerciseRecordsTableUpdateCompanionBuilder =
    ExerciseRecordsCompanion Function({
      Value<int> id,
      Value<String> userId,
      Value<DateTime> startTime,
      Value<DateTime?> endTime,
      Value<int?> duration,
      Value<String?> exerciseType,
      Value<String?> exerciseName,
      Value<String?> intensity,
      Value<String?> location,
      Value<String?> weatherCondition,
      Value<double?> distance,
      Value<double?> averageSpeed,
      Value<double?> maxSpeed,
      Value<String?> routeData,
      Value<double?> elevation,
      Value<int?> averageHeartRate,
      Value<int?> maxHeartRate,
      Value<int?> minHeartRate,
      Value<int?> restingHeartRate,
      Value<int?> hrZone1Time,
      Value<int?> hrZone2Time,
      Value<int?> hrZone3Time,
      Value<int?> hrZone4Time,
      Value<int?> hrZone5Time,
      Value<String?> exerciseSets,
      Value<double?> totalWeight,
      Value<int?> totalReps,
      Value<double?> oneRepMax,
      Value<int?> caloriesBurned,
      Value<int?> steps,
      Value<String?> feeling,
      Value<double?> trainingLoad,
      Value<String?> rpeScore,
      Value<double?> trainingStressScore,
      Value<int?> averageCadence,
      Value<int?> maxCadence,
      Value<double?> strideLength,
      Value<double?> verticalRatio,
      Value<double?> groundContactTime,
      Value<double?> temperature,
      Value<double?> humidity,
      Value<int?> sleepHoursLastNight,
      Value<int?> stressLevel,
      Value<int?> energyLevel,
      Value<int?> motivationLevel,
      Value<String?> equipment,
      Value<String?> shoes,
      Value<String?> deviceInfo,
      Value<String?> goals,
      Value<bool> personalRecord,
      Value<String?> achievements,
      Value<int?> recoveryHeartRate,
      Value<double?> recoveryScore,
      Value<String?> recoveryMetrics,
      Value<String?> notes,
      Value<String?> tags,
      Value<String?> photos,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$ExerciseRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $ExerciseRecordsTable> {
  $$ExerciseRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseType => $composableBuilder(
    column: $table.exerciseType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get intensity => $composableBuilder(
    column: $table.intensity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weatherCondition => $composableBuilder(
    column: $table.weatherCondition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get distance => $composableBuilder(
    column: $table.distance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get averageSpeed => $composableBuilder(
    column: $table.averageSpeed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get maxSpeed => $composableBuilder(
    column: $table.maxSpeed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get routeData => $composableBuilder(
    column: $table.routeData,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get elevation => $composableBuilder(
    column: $table.elevation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get averageHeartRate => $composableBuilder(
    column: $table.averageHeartRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxHeartRate => $composableBuilder(
    column: $table.maxHeartRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minHeartRate => $composableBuilder(
    column: $table.minHeartRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get restingHeartRate => $composableBuilder(
    column: $table.restingHeartRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hrZone1Time => $composableBuilder(
    column: $table.hrZone1Time,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hrZone2Time => $composableBuilder(
    column: $table.hrZone2Time,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hrZone3Time => $composableBuilder(
    column: $table.hrZone3Time,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hrZone4Time => $composableBuilder(
    column: $table.hrZone4Time,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hrZone5Time => $composableBuilder(
    column: $table.hrZone5Time,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseSets => $composableBuilder(
    column: $table.exerciseSets,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalWeight => $composableBuilder(
    column: $table.totalWeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalReps => $composableBuilder(
    column: $table.totalReps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get oneRepMax => $composableBuilder(
    column: $table.oneRepMax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get caloriesBurned => $composableBuilder(
    column: $table.caloriesBurned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get steps => $composableBuilder(
    column: $table.steps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get feeling => $composableBuilder(
    column: $table.feeling,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get trainingLoad => $composableBuilder(
    column: $table.trainingLoad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rpeScore => $composableBuilder(
    column: $table.rpeScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get trainingStressScore => $composableBuilder(
    column: $table.trainingStressScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get averageCadence => $composableBuilder(
    column: $table.averageCadence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxCadence => $composableBuilder(
    column: $table.maxCadence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get strideLength => $composableBuilder(
    column: $table.strideLength,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get verticalRatio => $composableBuilder(
    column: $table.verticalRatio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get groundContactTime => $composableBuilder(
    column: $table.groundContactTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get humidity => $composableBuilder(
    column: $table.humidity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sleepHoursLastNight => $composableBuilder(
    column: $table.sleepHoursLastNight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stressLevel => $composableBuilder(
    column: $table.stressLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get energyLevel => $composableBuilder(
    column: $table.energyLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get motivationLevel => $composableBuilder(
    column: $table.motivationLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get equipment => $composableBuilder(
    column: $table.equipment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shoes => $composableBuilder(
    column: $table.shoes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceInfo => $composableBuilder(
    column: $table.deviceInfo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goals => $composableBuilder(
    column: $table.goals,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get personalRecord => $composableBuilder(
    column: $table.personalRecord,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get achievements => $composableBuilder(
    column: $table.achievements,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recoveryHeartRate => $composableBuilder(
    column: $table.recoveryHeartRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get recoveryScore => $composableBuilder(
    column: $table.recoveryScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recoveryMetrics => $composableBuilder(
    column: $table.recoveryMetrics,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photos => $composableBuilder(
    column: $table.photos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExerciseRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExerciseRecordsTable> {
  $$ExerciseRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseType => $composableBuilder(
    column: $table.exerciseType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get intensity => $composableBuilder(
    column: $table.intensity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weatherCondition => $composableBuilder(
    column: $table.weatherCondition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get distance => $composableBuilder(
    column: $table.distance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get averageSpeed => $composableBuilder(
    column: $table.averageSpeed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get maxSpeed => $composableBuilder(
    column: $table.maxSpeed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get routeData => $composableBuilder(
    column: $table.routeData,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get elevation => $composableBuilder(
    column: $table.elevation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get averageHeartRate => $composableBuilder(
    column: $table.averageHeartRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxHeartRate => $composableBuilder(
    column: $table.maxHeartRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minHeartRate => $composableBuilder(
    column: $table.minHeartRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get restingHeartRate => $composableBuilder(
    column: $table.restingHeartRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hrZone1Time => $composableBuilder(
    column: $table.hrZone1Time,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hrZone2Time => $composableBuilder(
    column: $table.hrZone2Time,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hrZone3Time => $composableBuilder(
    column: $table.hrZone3Time,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hrZone4Time => $composableBuilder(
    column: $table.hrZone4Time,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hrZone5Time => $composableBuilder(
    column: $table.hrZone5Time,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseSets => $composableBuilder(
    column: $table.exerciseSets,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalWeight => $composableBuilder(
    column: $table.totalWeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalReps => $composableBuilder(
    column: $table.totalReps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get oneRepMax => $composableBuilder(
    column: $table.oneRepMax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get caloriesBurned => $composableBuilder(
    column: $table.caloriesBurned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get steps => $composableBuilder(
    column: $table.steps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get feeling => $composableBuilder(
    column: $table.feeling,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get trainingLoad => $composableBuilder(
    column: $table.trainingLoad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rpeScore => $composableBuilder(
    column: $table.rpeScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get trainingStressScore => $composableBuilder(
    column: $table.trainingStressScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get averageCadence => $composableBuilder(
    column: $table.averageCadence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxCadence => $composableBuilder(
    column: $table.maxCadence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get strideLength => $composableBuilder(
    column: $table.strideLength,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get verticalRatio => $composableBuilder(
    column: $table.verticalRatio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get groundContactTime => $composableBuilder(
    column: $table.groundContactTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get humidity => $composableBuilder(
    column: $table.humidity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sleepHoursLastNight => $composableBuilder(
    column: $table.sleepHoursLastNight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stressLevel => $composableBuilder(
    column: $table.stressLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get energyLevel => $composableBuilder(
    column: $table.energyLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get motivationLevel => $composableBuilder(
    column: $table.motivationLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get equipment => $composableBuilder(
    column: $table.equipment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shoes => $composableBuilder(
    column: $table.shoes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceInfo => $composableBuilder(
    column: $table.deviceInfo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goals => $composableBuilder(
    column: $table.goals,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get personalRecord => $composableBuilder(
    column: $table.personalRecord,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get achievements => $composableBuilder(
    column: $table.achievements,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recoveryHeartRate => $composableBuilder(
    column: $table.recoveryHeartRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get recoveryScore => $composableBuilder(
    column: $table.recoveryScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recoveryMetrics => $composableBuilder(
    column: $table.recoveryMetrics,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photos => $composableBuilder(
    column: $table.photos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExerciseRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExerciseRecordsTable> {
  $$ExerciseRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<int> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumn<String> get exerciseType => $composableBuilder(
    column: $table.exerciseType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get intensity =>
      $composableBuilder(column: $table.intensity, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<String> get weatherCondition => $composableBuilder(
    column: $table.weatherCondition,
    builder: (column) => column,
  );

  GeneratedColumn<double> get distance =>
      $composableBuilder(column: $table.distance, builder: (column) => column);

  GeneratedColumn<double> get averageSpeed => $composableBuilder(
    column: $table.averageSpeed,
    builder: (column) => column,
  );

  GeneratedColumn<double> get maxSpeed =>
      $composableBuilder(column: $table.maxSpeed, builder: (column) => column);

  GeneratedColumn<String> get routeData =>
      $composableBuilder(column: $table.routeData, builder: (column) => column);

  GeneratedColumn<double> get elevation =>
      $composableBuilder(column: $table.elevation, builder: (column) => column);

  GeneratedColumn<int> get averageHeartRate => $composableBuilder(
    column: $table.averageHeartRate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maxHeartRate => $composableBuilder(
    column: $table.maxHeartRate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get minHeartRate => $composableBuilder(
    column: $table.minHeartRate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get restingHeartRate => $composableBuilder(
    column: $table.restingHeartRate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get hrZone1Time => $composableBuilder(
    column: $table.hrZone1Time,
    builder: (column) => column,
  );

  GeneratedColumn<int> get hrZone2Time => $composableBuilder(
    column: $table.hrZone2Time,
    builder: (column) => column,
  );

  GeneratedColumn<int> get hrZone3Time => $composableBuilder(
    column: $table.hrZone3Time,
    builder: (column) => column,
  );

  GeneratedColumn<int> get hrZone4Time => $composableBuilder(
    column: $table.hrZone4Time,
    builder: (column) => column,
  );

  GeneratedColumn<int> get hrZone5Time => $composableBuilder(
    column: $table.hrZone5Time,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exerciseSets => $composableBuilder(
    column: $table.exerciseSets,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalWeight => $composableBuilder(
    column: $table.totalWeight,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalReps =>
      $composableBuilder(column: $table.totalReps, builder: (column) => column);

  GeneratedColumn<double> get oneRepMax =>
      $composableBuilder(column: $table.oneRepMax, builder: (column) => column);

  GeneratedColumn<int> get caloriesBurned => $composableBuilder(
    column: $table.caloriesBurned,
    builder: (column) => column,
  );

  GeneratedColumn<int> get steps =>
      $composableBuilder(column: $table.steps, builder: (column) => column);

  GeneratedColumn<String> get feeling =>
      $composableBuilder(column: $table.feeling, builder: (column) => column);

  GeneratedColumn<double> get trainingLoad => $composableBuilder(
    column: $table.trainingLoad,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rpeScore =>
      $composableBuilder(column: $table.rpeScore, builder: (column) => column);

  GeneratedColumn<double> get trainingStressScore => $composableBuilder(
    column: $table.trainingStressScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get averageCadence => $composableBuilder(
    column: $table.averageCadence,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maxCadence => $composableBuilder(
    column: $table.maxCadence,
    builder: (column) => column,
  );

  GeneratedColumn<double> get strideLength => $composableBuilder(
    column: $table.strideLength,
    builder: (column) => column,
  );

  GeneratedColumn<double> get verticalRatio => $composableBuilder(
    column: $table.verticalRatio,
    builder: (column) => column,
  );

  GeneratedColumn<double> get groundContactTime => $composableBuilder(
    column: $table.groundContactTime,
    builder: (column) => column,
  );

  GeneratedColumn<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => column,
  );

  GeneratedColumn<double> get humidity =>
      $composableBuilder(column: $table.humidity, builder: (column) => column);

  GeneratedColumn<int> get sleepHoursLastNight => $composableBuilder(
    column: $table.sleepHoursLastNight,
    builder: (column) => column,
  );

  GeneratedColumn<int> get stressLevel => $composableBuilder(
    column: $table.stressLevel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get energyLevel => $composableBuilder(
    column: $table.energyLevel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get motivationLevel => $composableBuilder(
    column: $table.motivationLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get equipment =>
      $composableBuilder(column: $table.equipment, builder: (column) => column);

  GeneratedColumn<String> get shoes =>
      $composableBuilder(column: $table.shoes, builder: (column) => column);

  GeneratedColumn<String> get deviceInfo => $composableBuilder(
    column: $table.deviceInfo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get goals =>
      $composableBuilder(column: $table.goals, builder: (column) => column);

  GeneratedColumn<bool> get personalRecord => $composableBuilder(
    column: $table.personalRecord,
    builder: (column) => column,
  );

  GeneratedColumn<String> get achievements => $composableBuilder(
    column: $table.achievements,
    builder: (column) => column,
  );

  GeneratedColumn<int> get recoveryHeartRate => $composableBuilder(
    column: $table.recoveryHeartRate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get recoveryScore => $composableBuilder(
    column: $table.recoveryScore,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recoveryMetrics => $composableBuilder(
    column: $table.recoveryMetrics,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<String> get photos =>
      $composableBuilder(column: $table.photos, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ExerciseRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExerciseRecordsTable,
          ExerciseRecord,
          $$ExerciseRecordsTableFilterComposer,
          $$ExerciseRecordsTableOrderingComposer,
          $$ExerciseRecordsTableAnnotationComposer,
          $$ExerciseRecordsTableCreateCompanionBuilder,
          $$ExerciseRecordsTableUpdateCompanionBuilder,
          (
            ExerciseRecord,
            BaseReferences<
              _$AppDatabase,
              $ExerciseRecordsTable,
              ExerciseRecord
            >,
          ),
          ExerciseRecord,
          PrefetchHooks Function()
        > {
  $$ExerciseRecordsTableTableManager(
    _$AppDatabase db,
    $ExerciseRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExerciseRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExerciseRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExerciseRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<DateTime> startTime = const Value.absent(),
                Value<DateTime?> endTime = const Value.absent(),
                Value<int?> duration = const Value.absent(),
                Value<String?> exerciseType = const Value.absent(),
                Value<String?> exerciseName = const Value.absent(),
                Value<String?> intensity = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<String?> weatherCondition = const Value.absent(),
                Value<double?> distance = const Value.absent(),
                Value<double?> averageSpeed = const Value.absent(),
                Value<double?> maxSpeed = const Value.absent(),
                Value<String?> routeData = const Value.absent(),
                Value<double?> elevation = const Value.absent(),
                Value<int?> averageHeartRate = const Value.absent(),
                Value<int?> maxHeartRate = const Value.absent(),
                Value<int?> minHeartRate = const Value.absent(),
                Value<int?> restingHeartRate = const Value.absent(),
                Value<int?> hrZone1Time = const Value.absent(),
                Value<int?> hrZone2Time = const Value.absent(),
                Value<int?> hrZone3Time = const Value.absent(),
                Value<int?> hrZone4Time = const Value.absent(),
                Value<int?> hrZone5Time = const Value.absent(),
                Value<String?> exerciseSets = const Value.absent(),
                Value<double?> totalWeight = const Value.absent(),
                Value<int?> totalReps = const Value.absent(),
                Value<double?> oneRepMax = const Value.absent(),
                Value<int?> caloriesBurned = const Value.absent(),
                Value<int?> steps = const Value.absent(),
                Value<String?> feeling = const Value.absent(),
                Value<double?> trainingLoad = const Value.absent(),
                Value<String?> rpeScore = const Value.absent(),
                Value<double?> trainingStressScore = const Value.absent(),
                Value<int?> averageCadence = const Value.absent(),
                Value<int?> maxCadence = const Value.absent(),
                Value<double?> strideLength = const Value.absent(),
                Value<double?> verticalRatio = const Value.absent(),
                Value<double?> groundContactTime = const Value.absent(),
                Value<double?> temperature = const Value.absent(),
                Value<double?> humidity = const Value.absent(),
                Value<int?> sleepHoursLastNight = const Value.absent(),
                Value<int?> stressLevel = const Value.absent(),
                Value<int?> energyLevel = const Value.absent(),
                Value<int?> motivationLevel = const Value.absent(),
                Value<String?> equipment = const Value.absent(),
                Value<String?> shoes = const Value.absent(),
                Value<String?> deviceInfo = const Value.absent(),
                Value<String?> goals = const Value.absent(),
                Value<bool> personalRecord = const Value.absent(),
                Value<String?> achievements = const Value.absent(),
                Value<int?> recoveryHeartRate = const Value.absent(),
                Value<double?> recoveryScore = const Value.absent(),
                Value<String?> recoveryMetrics = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<String?> photos = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ExerciseRecordsCompanion(
                id: id,
                userId: userId,
                startTime: startTime,
                endTime: endTime,
                duration: duration,
                exerciseType: exerciseType,
                exerciseName: exerciseName,
                intensity: intensity,
                location: location,
                weatherCondition: weatherCondition,
                distance: distance,
                averageSpeed: averageSpeed,
                maxSpeed: maxSpeed,
                routeData: routeData,
                elevation: elevation,
                averageHeartRate: averageHeartRate,
                maxHeartRate: maxHeartRate,
                minHeartRate: minHeartRate,
                restingHeartRate: restingHeartRate,
                hrZone1Time: hrZone1Time,
                hrZone2Time: hrZone2Time,
                hrZone3Time: hrZone3Time,
                hrZone4Time: hrZone4Time,
                hrZone5Time: hrZone5Time,
                exerciseSets: exerciseSets,
                totalWeight: totalWeight,
                totalReps: totalReps,
                oneRepMax: oneRepMax,
                caloriesBurned: caloriesBurned,
                steps: steps,
                feeling: feeling,
                trainingLoad: trainingLoad,
                rpeScore: rpeScore,
                trainingStressScore: trainingStressScore,
                averageCadence: averageCadence,
                maxCadence: maxCadence,
                strideLength: strideLength,
                verticalRatio: verticalRatio,
                groundContactTime: groundContactTime,
                temperature: temperature,
                humidity: humidity,
                sleepHoursLastNight: sleepHoursLastNight,
                stressLevel: stressLevel,
                energyLevel: energyLevel,
                motivationLevel: motivationLevel,
                equipment: equipment,
                shoes: shoes,
                deviceInfo: deviceInfo,
                goals: goals,
                personalRecord: personalRecord,
                achievements: achievements,
                recoveryHeartRate: recoveryHeartRate,
                recoveryScore: recoveryScore,
                recoveryMetrics: recoveryMetrics,
                notes: notes,
                tags: tags,
                photos: photos,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String userId,
                required DateTime startTime,
                Value<DateTime?> endTime = const Value.absent(),
                Value<int?> duration = const Value.absent(),
                Value<String?> exerciseType = const Value.absent(),
                Value<String?> exerciseName = const Value.absent(),
                Value<String?> intensity = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<String?> weatherCondition = const Value.absent(),
                Value<double?> distance = const Value.absent(),
                Value<double?> averageSpeed = const Value.absent(),
                Value<double?> maxSpeed = const Value.absent(),
                Value<String?> routeData = const Value.absent(),
                Value<double?> elevation = const Value.absent(),
                Value<int?> averageHeartRate = const Value.absent(),
                Value<int?> maxHeartRate = const Value.absent(),
                Value<int?> minHeartRate = const Value.absent(),
                Value<int?> restingHeartRate = const Value.absent(),
                Value<int?> hrZone1Time = const Value.absent(),
                Value<int?> hrZone2Time = const Value.absent(),
                Value<int?> hrZone3Time = const Value.absent(),
                Value<int?> hrZone4Time = const Value.absent(),
                Value<int?> hrZone5Time = const Value.absent(),
                Value<String?> exerciseSets = const Value.absent(),
                Value<double?> totalWeight = const Value.absent(),
                Value<int?> totalReps = const Value.absent(),
                Value<double?> oneRepMax = const Value.absent(),
                Value<int?> caloriesBurned = const Value.absent(),
                Value<int?> steps = const Value.absent(),
                Value<String?> feeling = const Value.absent(),
                Value<double?> trainingLoad = const Value.absent(),
                Value<String?> rpeScore = const Value.absent(),
                Value<double?> trainingStressScore = const Value.absent(),
                Value<int?> averageCadence = const Value.absent(),
                Value<int?> maxCadence = const Value.absent(),
                Value<double?> strideLength = const Value.absent(),
                Value<double?> verticalRatio = const Value.absent(),
                Value<double?> groundContactTime = const Value.absent(),
                Value<double?> temperature = const Value.absent(),
                Value<double?> humidity = const Value.absent(),
                Value<int?> sleepHoursLastNight = const Value.absent(),
                Value<int?> stressLevel = const Value.absent(),
                Value<int?> energyLevel = const Value.absent(),
                Value<int?> motivationLevel = const Value.absent(),
                Value<String?> equipment = const Value.absent(),
                Value<String?> shoes = const Value.absent(),
                Value<String?> deviceInfo = const Value.absent(),
                Value<String?> goals = const Value.absent(),
                Value<bool> personalRecord = const Value.absent(),
                Value<String?> achievements = const Value.absent(),
                Value<int?> recoveryHeartRate = const Value.absent(),
                Value<double?> recoveryScore = const Value.absent(),
                Value<String?> recoveryMetrics = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<String?> photos = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ExerciseRecordsCompanion.insert(
                id: id,
                userId: userId,
                startTime: startTime,
                endTime: endTime,
                duration: duration,
                exerciseType: exerciseType,
                exerciseName: exerciseName,
                intensity: intensity,
                location: location,
                weatherCondition: weatherCondition,
                distance: distance,
                averageSpeed: averageSpeed,
                maxSpeed: maxSpeed,
                routeData: routeData,
                elevation: elevation,
                averageHeartRate: averageHeartRate,
                maxHeartRate: maxHeartRate,
                minHeartRate: minHeartRate,
                restingHeartRate: restingHeartRate,
                hrZone1Time: hrZone1Time,
                hrZone2Time: hrZone2Time,
                hrZone3Time: hrZone3Time,
                hrZone4Time: hrZone4Time,
                hrZone5Time: hrZone5Time,
                exerciseSets: exerciseSets,
                totalWeight: totalWeight,
                totalReps: totalReps,
                oneRepMax: oneRepMax,
                caloriesBurned: caloriesBurned,
                steps: steps,
                feeling: feeling,
                trainingLoad: trainingLoad,
                rpeScore: rpeScore,
                trainingStressScore: trainingStressScore,
                averageCadence: averageCadence,
                maxCadence: maxCadence,
                strideLength: strideLength,
                verticalRatio: verticalRatio,
                groundContactTime: groundContactTime,
                temperature: temperature,
                humidity: humidity,
                sleepHoursLastNight: sleepHoursLastNight,
                stressLevel: stressLevel,
                energyLevel: energyLevel,
                motivationLevel: motivationLevel,
                equipment: equipment,
                shoes: shoes,
                deviceInfo: deviceInfo,
                goals: goals,
                personalRecord: personalRecord,
                achievements: achievements,
                recoveryHeartRate: recoveryHeartRate,
                recoveryScore: recoveryScore,
                recoveryMetrics: recoveryMetrics,
                notes: notes,
                tags: tags,
                photos: photos,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExerciseRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExerciseRecordsTable,
      ExerciseRecord,
      $$ExerciseRecordsTableFilterComposer,
      $$ExerciseRecordsTableOrderingComposer,
      $$ExerciseRecordsTableAnnotationComposer,
      $$ExerciseRecordsTableCreateCompanionBuilder,
      $$ExerciseRecordsTableUpdateCompanionBuilder,
      (
        ExerciseRecord,
        BaseReferences<_$AppDatabase, $ExerciseRecordsTable, ExerciseRecord>,
      ),
      ExerciseRecord,
      PrefetchHooks Function()
    >;
typedef $$FastingRecordsTableCreateCompanionBuilder =
    FastingRecordsCompanion Function({
      Value<int> id,
      required String userId,
      Value<String?> planType,
      required DateTime startTime,
      Value<DateTime?> endTime,
      Value<int?> duration,
      Value<int?> targetHours,
      Value<int> status,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });
typedef $$FastingRecordsTableUpdateCompanionBuilder =
    FastingRecordsCompanion Function({
      Value<int> id,
      Value<String> userId,
      Value<String?> planType,
      Value<DateTime> startTime,
      Value<DateTime?> endTime,
      Value<int?> duration,
      Value<int?> targetHours,
      Value<int> status,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });

class $$FastingRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $FastingRecordsTable> {
  $$FastingRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get planType => $composableBuilder(
    column: $table.planType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetHours => $composableBuilder(
    column: $table.targetHours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FastingRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $FastingRecordsTable> {
  $$FastingRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get planType => $composableBuilder(
    column: $table.planType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetHours => $composableBuilder(
    column: $table.targetHours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FastingRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FastingRecordsTable> {
  $$FastingRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get planType =>
      $composableBuilder(column: $table.planType, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<int> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumn<int> get targetHours => $composableBuilder(
    column: $table.targetHours,
    builder: (column) => column,
  );

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$FastingRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FastingRecordsTable,
          FastingRecord,
          $$FastingRecordsTableFilterComposer,
          $$FastingRecordsTableOrderingComposer,
          $$FastingRecordsTableAnnotationComposer,
          $$FastingRecordsTableCreateCompanionBuilder,
          $$FastingRecordsTableUpdateCompanionBuilder,
          (
            FastingRecord,
            BaseReferences<_$AppDatabase, $FastingRecordsTable, FastingRecord>,
          ),
          FastingRecord,
          PrefetchHooks Function()
        > {
  $$FastingRecordsTableTableManager(
    _$AppDatabase db,
    $FastingRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FastingRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FastingRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FastingRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String?> planType = const Value.absent(),
                Value<DateTime> startTime = const Value.absent(),
                Value<DateTime?> endTime = const Value.absent(),
                Value<int?> duration = const Value.absent(),
                Value<int?> targetHours = const Value.absent(),
                Value<int> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => FastingRecordsCompanion(
                id: id,
                userId: userId,
                planType: planType,
                startTime: startTime,
                endTime: endTime,
                duration: duration,
                targetHours: targetHours,
                status: status,
                notes: notes,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String userId,
                Value<String?> planType = const Value.absent(),
                required DateTime startTime,
                Value<DateTime?> endTime = const Value.absent(),
                Value<int?> duration = const Value.absent(),
                Value<int?> targetHours = const Value.absent(),
                Value<int> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => FastingRecordsCompanion.insert(
                id: id,
                userId: userId,
                planType: planType,
                startTime: startTime,
                endTime: endTime,
                duration: duration,
                targetHours: targetHours,
                status: status,
                notes: notes,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FastingRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FastingRecordsTable,
      FastingRecord,
      $$FastingRecordsTableFilterComposer,
      $$FastingRecordsTableOrderingComposer,
      $$FastingRecordsTableAnnotationComposer,
      $$FastingRecordsTableCreateCompanionBuilder,
      $$FastingRecordsTableUpdateCompanionBuilder,
      (
        FastingRecord,
        BaseReferences<_$AppDatabase, $FastingRecordsTable, FastingRecord>,
      ),
      FastingRecord,
      PrefetchHooks Function()
    >;
typedef $$UserSettingsTableCreateCompanionBuilder =
    UserSettingsCompanion Function({
      Value<int> id,
      required String key,
      required String value,
    });
typedef $$UserSettingsTableUpdateCompanionBuilder =
    UserSettingsCompanion Function({
      Value<int> id,
      Value<String> key,
      Value<String> value,
    });

class $$UserSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $UserSettingsTable> {
  $$UserSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $UserSettingsTable> {
  $$UserSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserSettingsTable> {
  $$UserSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$UserSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserSettingsTable,
          UserSetting,
          $$UserSettingsTableFilterComposer,
          $$UserSettingsTableOrderingComposer,
          $$UserSettingsTableAnnotationComposer,
          $$UserSettingsTableCreateCompanionBuilder,
          $$UserSettingsTableUpdateCompanionBuilder,
          (
            UserSetting,
            BaseReferences<_$AppDatabase, $UserSettingsTable, UserSetting>,
          ),
          UserSetting,
          PrefetchHooks Function()
        > {
  $$UserSettingsTableTableManager(_$AppDatabase db, $UserSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
              }) => UserSettingsCompanion(id: id, key: key, value: value),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String key,
                required String value,
              }) =>
                  UserSettingsCompanion.insert(id: id, key: key, value: value),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserSettingsTable,
      UserSetting,
      $$UserSettingsTableFilterComposer,
      $$UserSettingsTableOrderingComposer,
      $$UserSettingsTableAnnotationComposer,
      $$UserSettingsTableCreateCompanionBuilder,
      $$UserSettingsTableUpdateCompanionBuilder,
      (
        UserSetting,
        BaseReferences<_$AppDatabase, $UserSettingsTable, UserSetting>,
      ),
      UserSetting,
      PrefetchHooks Function()
    >;
typedef $$PeriodRecordsTableCreateCompanionBuilder =
    PeriodRecordsCompanion Function({
      required String id,
      required DateTime startDate,
      Value<int> durationDays,
      Value<int> cycleDays,
      Value<String?> symptoms,
      Value<String?> note,
      Value<int> rowid,
    });
typedef $$PeriodRecordsTableUpdateCompanionBuilder =
    PeriodRecordsCompanion Function({
      Value<String> id,
      Value<DateTime> startDate,
      Value<int> durationDays,
      Value<int> cycleDays,
      Value<String?> symptoms,
      Value<String?> note,
      Value<int> rowid,
    });

class $$PeriodRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $PeriodRecordsTable> {
  $$PeriodRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationDays => $composableBuilder(
    column: $table.durationDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cycleDays => $composableBuilder(
    column: $table.cycleDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get symptoms => $composableBuilder(
    column: $table.symptoms,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PeriodRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $PeriodRecordsTable> {
  $$PeriodRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationDays => $composableBuilder(
    column: $table.durationDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cycleDays => $composableBuilder(
    column: $table.cycleDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get symptoms => $composableBuilder(
    column: $table.symptoms,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PeriodRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PeriodRecordsTable> {
  $$PeriodRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<int> get durationDays => $composableBuilder(
    column: $table.durationDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cycleDays =>
      $composableBuilder(column: $table.cycleDays, builder: (column) => column);

  GeneratedColumn<String> get symptoms =>
      $composableBuilder(column: $table.symptoms, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$PeriodRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PeriodRecordsTable,
          PeriodRecord,
          $$PeriodRecordsTableFilterComposer,
          $$PeriodRecordsTableOrderingComposer,
          $$PeriodRecordsTableAnnotationComposer,
          $$PeriodRecordsTableCreateCompanionBuilder,
          $$PeriodRecordsTableUpdateCompanionBuilder,
          (
            PeriodRecord,
            BaseReferences<_$AppDatabase, $PeriodRecordsTable, PeriodRecord>,
          ),
          PeriodRecord,
          PrefetchHooks Function()
        > {
  $$PeriodRecordsTableTableManager(_$AppDatabase db, $PeriodRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PeriodRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PeriodRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PeriodRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<int> durationDays = const Value.absent(),
                Value<int> cycleDays = const Value.absent(),
                Value<String?> symptoms = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PeriodRecordsCompanion(
                id: id,
                startDate: startDate,
                durationDays: durationDays,
                cycleDays: cycleDays,
                symptoms: symptoms,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime startDate,
                Value<int> durationDays = const Value.absent(),
                Value<int> cycleDays = const Value.absent(),
                Value<String?> symptoms = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PeriodRecordsCompanion.insert(
                id: id,
                startDate: startDate,
                durationDays: durationDays,
                cycleDays: cycleDays,
                symptoms: symptoms,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PeriodRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PeriodRecordsTable,
      PeriodRecord,
      $$PeriodRecordsTableFilterComposer,
      $$PeriodRecordsTableOrderingComposer,
      $$PeriodRecordsTableAnnotationComposer,
      $$PeriodRecordsTableCreateCompanionBuilder,
      $$PeriodRecordsTableUpdateCompanionBuilder,
      (
        PeriodRecord,
        BaseReferences<_$AppDatabase, $PeriodRecordsTable, PeriodRecord>,
      ),
      PeriodRecord,
      PrefetchHooks Function()
    >;
typedef $$VitalRecordsTableCreateCompanionBuilder =
    VitalRecordsCompanion Function({
      Value<int> id,
      required String type,
      required double value1,
      Value<double?> value2,
      required DateTime time,
    });
typedef $$VitalRecordsTableUpdateCompanionBuilder =
    VitalRecordsCompanion Function({
      Value<int> id,
      Value<String> type,
      Value<double> value1,
      Value<double?> value2,
      Value<DateTime> time,
    });

class $$VitalRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $VitalRecordsTable> {
  $$VitalRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get value1 => $composableBuilder(
    column: $table.value1,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get value2 => $composableBuilder(
    column: $table.value2,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VitalRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $VitalRecordsTable> {
  $$VitalRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get value1 => $composableBuilder(
    column: $table.value1,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get value2 => $composableBuilder(
    column: $table.value2,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VitalRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VitalRecordsTable> {
  $$VitalRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get value1 =>
      $composableBuilder(column: $table.value1, builder: (column) => column);

  GeneratedColumn<double> get value2 =>
      $composableBuilder(column: $table.value2, builder: (column) => column);

  GeneratedColumn<DateTime> get time =>
      $composableBuilder(column: $table.time, builder: (column) => column);
}

class $$VitalRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VitalRecordsTable,
          VitalRecord,
          $$VitalRecordsTableFilterComposer,
          $$VitalRecordsTableOrderingComposer,
          $$VitalRecordsTableAnnotationComposer,
          $$VitalRecordsTableCreateCompanionBuilder,
          $$VitalRecordsTableUpdateCompanionBuilder,
          (
            VitalRecord,
            BaseReferences<_$AppDatabase, $VitalRecordsTable, VitalRecord>,
          ),
          VitalRecord,
          PrefetchHooks Function()
        > {
  $$VitalRecordsTableTableManager(_$AppDatabase db, $VitalRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VitalRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VitalRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VitalRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<double> value1 = const Value.absent(),
                Value<double?> value2 = const Value.absent(),
                Value<DateTime> time = const Value.absent(),
              }) => VitalRecordsCompanion(
                id: id,
                type: type,
                value1: value1,
                value2: value2,
                time: time,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String type,
                required double value1,
                Value<double?> value2 = const Value.absent(),
                required DateTime time,
              }) => VitalRecordsCompanion.insert(
                id: id,
                type: type,
                value1: value1,
                value2: value2,
                time: time,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VitalRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VitalRecordsTable,
      VitalRecord,
      $$VitalRecordsTableFilterComposer,
      $$VitalRecordsTableOrderingComposer,
      $$VitalRecordsTableAnnotationComposer,
      $$VitalRecordsTableCreateCompanionBuilder,
      $$VitalRecordsTableUpdateCompanionBuilder,
      (
        VitalRecord,
        BaseReferences<_$AppDatabase, $VitalRecordsTable, VitalRecord>,
      ),
      VitalRecord,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$StepCountsTableTableManager get stepCounts =>
      $$StepCountsTableTableManager(_db, _db.stepCounts);
  $$StepPerDaysTableTableManager get stepPerDays =>
      $$StepPerDaysTableTableManager(_db, _db.stepPerDays);
  $$TargetsTableTableManager get targets =>
      $$TargetsTableTableManager(_db, _db.targets);
  $$WaterRecordsTableTableManager get waterRecords =>
      $$WaterRecordsTableTableManager(_db, _db.waterRecords);
  $$DietRecordsTableTableManager get dietRecords =>
      $$DietRecordsTableTableManager(_db, _db.dietRecords);
  $$MoodRecordsTableTableManager get moodRecords =>
      $$MoodRecordsTableTableManager(_db, _db.moodRecords);
  $$TrainingPlansTableTableManager get trainingPlans =>
      $$TrainingPlansTableTableManager(_db, _db.trainingPlans);
  $$SleepRecordsTableTableManager get sleepRecords =>
      $$SleepRecordsTableTableManager(_db, _db.sleepRecords);
  $$SocialFeedsTableTableManager get socialFeeds =>
      $$SocialFeedsTableTableManager(_db, _db.socialFeeds);
  $$ProfessionalWeightRecordsTableTableManager get professionalWeightRecords =>
      $$ProfessionalWeightRecordsTableTableManager(
        _db,
        _db.professionalWeightRecords,
      );
  $$BloodPressureRecordsTableTableManager get bloodPressureRecords =>
      $$BloodPressureRecordsTableTableManager(_db, _db.bloodPressureRecords);
  $$HeartRateRecordsTableTableManager get heartRateRecords =>
      $$HeartRateRecordsTableTableManager(_db, _db.heartRateRecords);
  $$BloodGlucoseRecordsTableTableManager get bloodGlucoseRecords =>
      $$BloodGlucoseRecordsTableTableManager(_db, _db.bloodGlucoseRecords);
  $$BloodLipidsRecordsTableTableManager get bloodLipidsRecords =>
      $$BloodLipidsRecordsTableTableManager(_db, _db.bloodLipidsRecords);
  $$ExerciseRecordsTableTableManager get exerciseRecords =>
      $$ExerciseRecordsTableTableManager(_db, _db.exerciseRecords);
  $$FastingRecordsTableTableManager get fastingRecords =>
      $$FastingRecordsTableTableManager(_db, _db.fastingRecords);
  $$UserSettingsTableTableManager get userSettings =>
      $$UserSettingsTableTableManager(_db, _db.userSettings);
  $$PeriodRecordsTableTableManager get periodRecords =>
      $$PeriodRecordsTableTableManager(_db, _db.periodRecords);
  $$VitalRecordsTableTableManager get vitalRecords =>
      $$VitalRecordsTableTableManager(_db, _db.vitalRecords);
}
