import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  StepCounts,
  StepPerDays,
  Targets,
  WaterRecords,
  DietRecords,
  MoodRecords,
  TrainingPlans,
  SleepRecords,
  SocialFeeds,
  ProfessionalWeightRecords,
  BloodPressureRecords,
  HeartRateRecords,
  BloodGlucoseRecords,
  BloodLipidsRecords,
  ExerciseRecords,
  FastingRecords,
  UserSettings,
  PeriodRecords,
  VitalRecords,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'steps_health_db');
  }

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Recreate all tables on any upgrade to ensure new tables exist
        await m.createAll();
      },
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }

  // ── Water DAO ──
  Future<List<WaterRecord>> getTodayWaterRecords() {
    return getWaterRecordsByDate(DateTime.now());
  }

  Future<List<WaterRecord>> getWaterRecordsByDate(DateTime date) {
    final dayStart = DateTime(date.year, date.month, date.day);
    final dayEnd = dayStart.add(const Duration(days: 1));
    return (select(waterRecords)
          ..where((t) => t.time.isBetweenValues(dayStart, dayEnd))
          ..orderBy([(t) => OrderingTerm(expression: t.time, mode: OrderingMode.asc)]))
        .get();
  }

  Future<int> insertWaterRecord(WaterRecordsCompanion record) {
    return into(waterRecords).insert(record);
  }

  Future<void> deleteWaterRecord(int id) {
    return (delete(waterRecords)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<void> updateWaterRecord(WaterRecord record) {
    return update(waterRecords).replace(record);
  }

  // ── Weight DAO ──
  Future<List<ProfessionalWeightRecord>> getWeightRecordsLastDays(int days) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return (select(professionalWeightRecords)
          ..where((t) => t.recordDatetime.isBiggerOrEqualValue(cutoff))
          ..orderBy([(t) => OrderingTerm(expression: t.recordDatetime, mode: OrderingMode.asc)]))
        .get();
  }

  Future<int> insertWeightRecord(ProfessionalWeightRecordsCompanion record) {
    return into(professionalWeightRecords).insert(record);
  }

  Future<void> deleteProfessionalWeightRecord(int id) {
    return (delete(professionalWeightRecords)..where((tbl) => tbl.id.equals(id))).go();
  }

  // ── Sleep DAO ──
  Future<List<SleepRecord>> getSleepRecordsLastDays(int days) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return (select(sleepRecords)
          ..where((t) => t.sleepTime.isBiggerOrEqualValue(cutoff))
          ..orderBy([(t) => OrderingTerm(expression: t.sleepTime, mode: OrderingMode.asc)]))
        .get();
  }

  Future<int> insertSleepRecord(SleepRecordsCompanion record) {
    return into(sleepRecords).insert(record);
  }

  // ── Exercise DAO ──
  Future<List<ExerciseRecord>> getExerciseRecordsLastDays(int days) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return (select(exerciseRecords)
          ..where((t) => t.startTime.isBiggerOrEqualValue(cutoff))
          ..orderBy([(t) => OrderingTerm(expression: t.startTime, mode: OrderingMode.asc)]))
        .get();
  }

  Future<int> insertExerciseRecord(ExerciseRecordsCompanion record) {
    return into(exerciseRecords).insert(record);
  }

  Future<void> deleteExerciseRecord(int id) {
    return (delete(exerciseRecords)..where((tbl) => tbl.id.equals(id))).go();
  }

  // ── Fasting DAO ──
  Future<List<FastingRecord>> getFastingRecords() {
    return (select(fastingRecords)
          ..orderBy([(t) => OrderingTerm(expression: t.startTime, mode: OrderingMode.desc)]))
        .get();
  }

  Future<int> insertFastingRecord(FastingRecordsCompanion record) {
    return into(fastingRecords).insert(record);
  }

  Future<bool> updateFastingRecord(FastingRecord record) {
    return update(fastingRecords).replace(record);
  }

  // ── Mood DAO ──
  Future<List<MoodRecord>> getMoodRecordsLastDays(int days) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return (select(moodRecords)
          ..where((t) => t.time.isBiggerOrEqualValue(cutoff))
          ..orderBy([(t) => OrderingTerm(expression: t.time, mode: OrderingMode.desc)]))
        .get();
  }

  Future<int> insertMoodRecord(MoodRecordsCompanion record) {
    return into(moodRecords).insert(record);
  }

  Future<int> deleteMoodRecord(int id) {
    return (delete(moodRecords)..where((t) => t.id.equals(id))).go();
  }

  // ── Period DAO ──
  Future<List<PeriodRecord>> getPeriodRecords() {
    return (select(periodRecords)
          ..orderBy([(t) => OrderingTerm(expression: t.startDate, mode: OrderingMode.desc)]))
        .get();
  }

  Future<int> insertPeriodRecord(PeriodRecordsCompanion record) {
    return into(periodRecords).insert(record);
  }

  Future<int> deletePeriodRecord(String id) {
    return (delete(periodRecords)..where((t) => t.id.equals(id))).go();
  }

  // ── Step DAO ──
  Future<List<StepCount>> getStepCountsLastDays(int days) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return (select(stepCounts)
          ..where((t) => t.startTime.isBiggerOrEqualValue(cutoff))
          ..orderBy([(t) => OrderingTerm(expression: t.startTime, mode: OrderingMode.desc)]))
        .get();
  }

  Future<StepCount?> getStepCountByDate(DateTime date) async {
    final dayStart = DateTime(date.year, date.month, date.day);
    final dayEnd = dayStart.add(const Duration(days: 1));
    final records = await (select(stepCounts)
          ..where((t) => t.startTime.isBetweenValues(dayStart, dayEnd)))
        .get();
    return records.isNotEmpty ? records.first : null;
  }

  Future<int> insertStepCount(StepCountsCompanion record) {
    return into(stepCounts).insert(record);
  }

  Future<void> saveDailySteps(int steps, double calories) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final existing = await (select(stepCounts)
          ..where((t) => t.startTime.isBiggerOrEqualValue(today)))
        .get();
        
    if (existing.isNotEmpty) {
      await update(stepCounts).replace(existing.first.copyWith(
        stepsNum: steps,
        cal: Value(calories.toStringAsFixed(2)),
      ));
    } else {
      await into(stepCounts).insert(StepCountsCompanion.insert(
        startTime: today,
        stepsNum: Value(steps),
        cal: Value(calories.toStringAsFixed(2)),
      ));
    }
  }

  // ── Vital Records DAO ──
  Future<List<VitalRecord>> getVitalRecordsByType(String type) {
    return (select(vitalRecords)
          ..where((t) => t.type.equals(type))
          ..orderBy([(t) => OrderingTerm(expression: t.time, mode: OrderingMode.desc)]))
        .get();
  }

  Future<int> insertVitalRecord(VitalRecordsCompanion entry) {
    return into(vitalRecords).insert(entry);
  }

  Future<void> deleteVitalRecord(int id) {
    return (delete(vitalRecords)..where((t) => t.id.equals(id))).go();
  }
}
