import 'dart:convert';

import '../core/constants/app_constants.dart';
import '../models/exercise_record.dart';
import '../models/fasting_plan.dart';
import '../models/fasting_session.dart';
import '../models/food_record.dart';
import '../models/water_record.dart';
import '../models/week_plan.dart';
import '../models/weight_record.dart';
import '../repositories/exercise_repository.dart';
import '../repositories/fasting_repository.dart';
import '../repositories/food_record_repository.dart';
import '../repositories/water_repository.dart';
import '../repositories/week_plan_repository.dart';
import '../repositories/weight_repository.dart';

class DataExportService {
  DataExportService({
    required FastingRepository fastingRepository,
    required WaterRepository waterRepository,
    required WeightRepository weightRepository,
    required ExerciseRepository exerciseRepository,
    required FoodRecordRepository foodRecordRepository,
    required WeekPlanRepository weekPlanRepository,
  }) : _fastingRepository = fastingRepository,
       _waterRepository = waterRepository,
       _weightRepository = weightRepository,
       _exerciseRepository = exerciseRepository,
       _foodRecordRepository = foodRecordRepository,
       _weekPlanRepository = weekPlanRepository;

  final FastingRepository _fastingRepository;
  final WaterRepository _waterRepository;
  final WeightRepository _weightRepository;
  final ExerciseRepository _exerciseRepository;
  final FoodRecordRepository _foodRecordRepository;
  final WeekPlanRepository _weekPlanRepository;

  Future<LightFastingBackup> createBackup() async {
    await _ensureInitialized();

    final fastingPlans = await _fastingRepository.getAllPlans();
    final fastingSessions = await _fastingRepository.getAllSessions();
    final waterRecords = await _waterRepository.getAllRecords();
    final weightRecords = await _weightRepository.getAllRecords();
    final exerciseRecords = await _exerciseRepository.getAllRecords();
    final foodRecords = await _foodRecordRepository.getAllRecords();
    final weekPlans = await _weekPlanRepository.getAllPlans();

    return LightFastingBackup(
      exportedAt: DateTime.now(),
      data: {
        'fastingPlans': fastingPlans.map((item) => item.toJson()).toList(),
        'fastingSessions': fastingSessions
            .map((item) => item.toJson())
            .toList(),
        'waterRecords': waterRecords.map((item) => item.toJson()).toList(),
        'weightRecords': weightRecords.map((item) => item.toJson()).toList(),
        'exerciseRecords': exerciseRecords
            .map((item) => item.toJson())
            .toList(),
        'foodRecords': foodRecords.map((item) => item.toJson()).toList(),
        'weekPlans': weekPlans.map((item) => item.toJson()).toList(),
      },
    );
  }

  Future<String> createBackupJson() async {
    final backup = await createBackup();
    return encodeBackup(backup);
  }

  String encodeBackup(LightFastingBackup backup) {
    return const JsonEncoder.withIndent('  ').convert(backup.toJson());
  }

  Future<String> createCsvReport() async {
    await _ensureInitialized();

    final buffer = StringBuffer();
    _writeFastingSessionsCsv(buffer, await _fastingRepository.getAllSessions());
    _writeWaterCsv(buffer, await _waterRepository.getAllRecords());
    _writeWeightCsv(buffer, await _weightRepository.getAllRecords());
    _writeExerciseCsv(buffer, await _exerciseRepository.getAllRecords());
    _writeFoodCsv(buffer, await _foodRecordRepository.getAllRecords());
    _writeWeekPlansCsv(buffer, await _weekPlanRepository.getAllPlans());
    return buffer.toString();
  }

  Future<DataImportResult> restoreFromJson(String rawJson) async {
    await _ensureInitialized();

    final decoded = jsonDecode(rawJson);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('备份内容不是有效的 JSON 对象');
    }

    final data = decoded['data'];
    if (data is! Map<String, dynamic>) {
      throw const FormatException('备份文件缺少 data 字段');
    }

    final fastingPlans = _decodeList(
      data,
      'fastingPlans',
    ).map((item) => FastingPlan.fromJson(item)).toList();
    final fastingSessions = _decodeList(
      data,
      'fastingSessions',
    ).map((item) => FastingSession.fromJson(item)).toList();
    final waterRecords = _decodeList(
      data,
      'waterRecords',
    ).map((item) => WaterRecord.fromJson(item)).toList();
    final weightRecords = _decodeList(
      data,
      'weightRecords',
    ).map((item) => WeightRecord.fromJson(item)).toList();
    final exerciseRecords = _decodeList(
      data,
      'exerciseRecords',
    ).map((item) => ExerciseRecord.fromJson(item)).toList();
    final foodRecords = _decodeList(
      data,
      'foodRecords',
    ).map((item) => FoodRecord.fromJson(item)).toList();
    final weekPlans = _decodeList(
      data,
      'weekPlans',
    ).map((item) => WeekPlan.fromJson(item)).toList();

    await Future.wait([
      _waterRepository.clearAllRecords(),
      _weightRepository.clearAllRecords(),
      _exerciseRepository.clearAllRecords(),
      _foodRecordRepository.clearAllRecords(),
      _weekPlanRepository.clearAllPlans(),
    ]);
    await _fastingRepository.clearAllData();

    final counts = <String, int>{};

    for (final plan in fastingPlans) {
      await _fastingRepository.savePlan(plan);
    }
    if (fastingPlans.isEmpty) {
      await _fastingRepository.initializePresetPlans();
    }
    counts['断食方案'] = fastingPlans.length;

    for (final session in fastingSessions) {
      await _fastingRepository.saveSession(session);
    }
    counts['断食记录'] = fastingSessions.length;

    for (final record in waterRecords) {
      await _waterRepository.addRecord(record);
    }
    counts['饮水记录'] = waterRecords.length;

    for (final record in weightRecords) {
      await _weightRepository.addRecord(record);
    }
    counts['体重记录'] = weightRecords.length;

    for (final record in exerciseRecords) {
      await _exerciseRepository.addRecord(record);
    }
    counts['运动记录'] = exerciseRecords.length;

    for (final record in foodRecords) {
      await _foodRecordRepository.addRecord(record);
    }
    counts['饮食记录'] = foodRecords.length;

    for (final plan in weekPlans) {
      await _weekPlanRepository.savePlan(plan);
    }
    counts['周计划'] = weekPlans.length;

    return DataImportResult(counts: counts);
  }

  Future<void> _ensureInitialized() async {
    await Future.wait([
      _waterRepository.init(),
      _weightRepository.init(),
      _exerciseRepository.init(),
      _foodRecordRepository.init(),
      _weekPlanRepository.init(),
    ]);
  }

  List<Map<String, dynamic>> _decodeList(
    Map<String, dynamic> data,
    String key,
  ) {
    final value = data[key];
    if (value == null) return const [];
    if (value is! List) {
      throw FormatException('$key 字段格式不正确');
    }

    return value.map((item) {
      if (item is Map<String, dynamic>) return item;
      if (item is Map) {
        return item.map((key, value) => MapEntry(key.toString(), value));
      }
      throw FormatException('$key 中存在无效记录');
    }).toList();
  }

  void _writeFastingSessionsCsv(
    StringBuffer buffer,
    List<FastingSession> records,
  ) {
    _writeSection(buffer, 'fasting_sessions', [
      'id',
      'planId',
      'startTime',
      'endTime',
      'status',
      'fastingHours',
      'eatingHours',
      'successRate',
      'notes',
    ]);
    for (final item in records) {
      _writeRow(buffer, [
        item.id,
        item.planId,
        item.startTime.toIso8601String(),
        item.endTime?.toIso8601String() ?? '',
        item.status.name,
        item.fastingHours,
        item.eatingHours,
        item.successRate.toStringAsFixed(1),
        item.notes ?? '',
      ]);
    }
    buffer.writeln();
  }

  void _writeWaterCsv(StringBuffer buffer, List<WaterRecord> records) {
    _writeSection(buffer, 'water_records', [
      'id',
      'recordTime',
      'amountMl',
      'type',
      'temperature',
      'isReminder',
      'notes',
    ]);
    for (final item in records) {
      _writeRow(buffer, [
        item.id,
        item.recordTime.toIso8601String(),
        item.amount,
        item.type.name,
        item.temperature,
        item.isReminder,
        item.notes ?? '',
      ]);
    }
    buffer.writeln();
  }

  void _writeWeightCsv(StringBuffer buffer, List<WeightRecord> records) {
    _writeSection(buffer, 'weight_records', [
      'id',
      'recordTime',
      'weightKg',
      'bmi',
      'bodyFat',
      'muscleMass',
      'waterPercentage',
      'isTarget',
      'notes',
    ]);
    for (final item in records) {
      _writeRow(buffer, [
        item.id,
        item.recordTime.toIso8601String(),
        item.weight,
        item.bmi,
        item.bodyFat,
        item.muscleMass,
        item.waterPercentage,
        item.isTarget,
        item.notes ?? '',
      ]);
    }
    buffer.writeln();
  }

  void _writeExerciseCsv(StringBuffer buffer, List<ExerciseRecord> records) {
    _writeSection(buffer, 'exercise_records', [
      'id',
      'recordTime',
      'type',
      'durationMinutes',
      'calories',
      'distanceKm',
      'intensity',
      'notes',
    ]);
    for (final item in records) {
      _writeRow(buffer, [
        item.id,
        item.recordTime.toIso8601String(),
        item.type.name,
        item.durationMinutes,
        item.calories ?? item.estimatedCalories.toStringAsFixed(1),
        item.distance ?? '',
        item.intensity,
        item.notes ?? '',
      ]);
    }
    buffer.writeln();
  }

  void _writeFoodCsv(StringBuffer buffer, List<FoodRecord> records) {
    _writeSection(buffer, 'food_records', [
      'id',
      'recordTime',
      'foodName',
      'mealType',
      'quantity',
      'unit',
      'calories',
      'notes',
    ]);
    for (final item in records) {
      _writeRow(buffer, [
        item.id,
        item.recordTime.toIso8601String(),
        item.foodName,
        item.mealTypeDisplayName,
        item.quantity,
        item.unit,
        item.totalCalories.toStringAsFixed(1),
        item.notes ?? '',
      ]);
    }
    buffer.writeln();
  }

  void _writeWeekPlansCsv(StringBuffer buffer, List<WeekPlan> records) {
    _writeSection(buffer, 'week_plans', [
      'id',
      'name',
      'planId',
      'fastingDays',
      'restDays',
      'lowCalorieDays',
      'isActive',
      'notes',
    ]);
    for (final item in records) {
      _writeRow(buffer, [
        item.id,
        item.name,
        item.planId,
        item.fastingDays.join('|'),
        item.restDays.join('|'),
        item.lowCalorieDays.join('|'),
        item.isActive,
        item.notes ?? '',
      ]);
    }
  }

  void _writeSection(
    StringBuffer buffer,
    String sectionName,
    List<String> headers,
  ) {
    buffer.writeln('# $sectionName');
    _writeRow(buffer, headers);
  }

  void _writeRow(StringBuffer buffer, List<Object?> values) {
    buffer.writeln(values.map(_escapeCsvValue).join(','));
  }

  String _escapeCsvValue(Object? value) {
    final text = value?.toString() ?? '';
    final needsQuotes =
        text.contains(',') ||
        text.contains('"') ||
        text.contains('\n') ||
        text.contains('\r');
    final escaped = text.replaceAll('"', '""');
    return needsQuotes ? '"$escaped"' : escaped;
  }
}

class LightFastingBackup {
  const LightFastingBackup({required this.exportedAt, required this.data});

  final DateTime exportedAt;
  final Map<String, List<Map<String, dynamic>>> data;

  Map<String, dynamic> toJson() {
    return {
      'app': AppConstants.appName,
      'appVersion': AppConstants.appVersion,
      'backupVersion': 1,
      'exportedAt': exportedAt.toIso8601String(),
      'summary': summary,
      'data': data,
    };
  }

  Map<String, int> get summary {
    return data.map((key, value) => MapEntry(key, value.length));
  }

  int get totalCount {
    return summary.values.fold(0, (sum, count) => sum + count);
  }
}

class DataImportResult {
  const DataImportResult({required this.counts});

  final Map<String, int> counts;

  int get totalCount {
    return counts.values.fold(0, (sum, count) => sum + count);
  }

  String get description {
    return counts.entries
        .map((entry) => '${entry.key}${entry.value}条')
        .join('、');
  }
}
