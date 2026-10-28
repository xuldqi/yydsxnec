import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../database/app_database.dart';
import 'database_provider.dart';
import 'step_provider.dart' as step_svc;

final selectedDateProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

// ── 喝水 Provider ────────────────────────────────────────────────

class WaterState {
  final List<WaterRecord> records;
  final int todayTotal;
  final int goal;

  const WaterState({
    this.records = const [],
    this.todayTotal = 0,
    this.goal = 2000,
  });

  double get progress => (todayTotal / goal).clamp(0.0, 1.0);
  int get remaining => (goal - todayTotal).clamp(0, goal);

  WaterState copyWith({
    List<WaterRecord>? records,
    int? todayTotal,
    int? goal,
  }) =>
      WaterState(
        records: records ?? this.records,
        todayTotal: todayTotal ?? this.todayTotal,
        goal: goal ?? this.goal,
      );
}

class WaterNotifier extends AsyncNotifier<WaterState> {
  @override
  Future<WaterState> build() async {
    return _load();
  }

  Future<WaterState> _load() async {
    final selectedDate = ref.watch(selectedDateProvider);
    final db = ref.read(databaseProvider);
    final records = await db.getWaterRecordsByDate(selectedDate);
    final total = records.fold(0, (sum, r) => sum + r.amount);
    final goal = state.valueOrNull?.goal ?? 2000;
    return WaterState(records: records, todayTotal: total, goal: goal);
  }

  Future<void> addWater(int ml, {String type = '水', DateTime? time}) async {
    final db = ref.read(databaseProvider);
    await db.insertWaterRecord(WaterRecordsCompanion.insert(
      time: time ?? DateTime.now(),
      amount: Value(ml),
      waterType: Value(type),
    ));
    state = AsyncData(await _load());
  }

  Future<void> updateWater(WaterRecord record) async {
    final db = ref.read(databaseProvider);
    await db.updateWaterRecord(record);
    state = AsyncData(await _load());
  }

  Future<void> setGoal(int goal) async {
    final current = state.valueOrNull ?? const WaterState();
    state = AsyncData(current.copyWith(goal: goal));
  }
}

final waterProvider = AsyncNotifierProvider<WaterNotifier, WaterState>(
  WaterNotifier.new,
);

// ── 体重 Provider ────────────────────────────────────────────────

class WeightNotifier extends AsyncNotifier<List<ProfessionalWeightRecord>> {
  @override
  Future<List<ProfessionalWeightRecord>> build() async {
    final selectedDate = ref.watch(selectedDateProvider);
    final db = ref.read(databaseProvider);
    final records = await db.getWeightRecordsLastDays(30);
    // Filter out records that are from after the selected date
    // We want the most recent weight before or on selectedDate
    final filtered = records.where((r) {
      final rDate = DateTime(r.recordDatetime.year, r.recordDatetime.month, r.recordDatetime.day);
      return rDate.isBefore(selectedDate) || rDate.isAtSameMomentAs(selectedDate);
    }).toList();
    return filtered;
  }

  Future<void> addWeight(double kg, {DateTime? time}) async {
    final db = ref.read(databaseProvider);
    await db.insertWeightRecord(ProfessionalWeightRecordsCompanion.insert(
      userId: 'default_user',
      recordDatetime: time ?? DateTime.now(),
      weight: kg,
    ));
    state = AsyncData(await db.getWeightRecordsLastDays(30));
  }
}

final weightProvider = AsyncNotifierProvider<WeightNotifier, List<ProfessionalWeightRecord>>(
  WeightNotifier.new,
);

// ── 睡眠 Provider ────────────────────────────────────────────────

class SleepNotifier extends AsyncNotifier<List<SleepRecord>> {
  @override
  Future<List<SleepRecord>> build() async {
    final selectedDate = ref.watch(selectedDateProvider);
    final db = ref.read(databaseProvider);
    final records = await db.getSleepRecordsLastDays(30);
    return records.where((r) {
      // Sleep usually spans two days, we map to wake time's date
      final wDate = DateTime(r.wakeTime.year, r.wakeTime.month, r.wakeTime.day);
      return wDate.isAtSameMomentAs(selectedDate);
    }).toList();
  }

  Future<void> addSleep({
    required DateTime bedTime,
    required DateTime wakeTime,
    int deepMinutes = 0,
    int lightMinutes = 0,
    int remMinutes = 0,
  }) async {
    final db = ref.read(databaseProvider);
    final duration = wakeTime.difference(bedTime).inMinutes;
    final score = _calcScore(deepMinutes, lightMinutes, remMinutes, duration);
    await db.insertSleepRecord(SleepRecordsCompanion.insert(
      sleepTime: bedTime,
      wakeTime: wakeTime,
      duration: Value(duration),
      sleepScore: Value(score),
    ));
    state = AsyncData(await db.getSleepRecordsLastDays(7));
  }

  int _calcScore(int deep, int light, int rem, int total) {
    if (total == 0) return 0;
    final deepRatio = deep / total;
    final score = (deepRatio * 50 + (total / 480) * 50).clamp(0, 100);
    return score.toInt();
  }
}

final sleepProvider = AsyncNotifierProvider<SleepNotifier, List<SleepRecord>>(
  SleepNotifier.new,
);

// ── 运动记录 Provider ─────────────────────────────────────────────

class SportNotifier extends AsyncNotifier<List<ExerciseRecord>> {
  @override
  Future<List<ExerciseRecord>> build() async {
    final selectedDate = ref.watch(selectedDateProvider);
    final db = ref.read(databaseProvider);
    try {
      final records = await db.getExerciseRecordsLastDays(30);
      return records.where((r) {
        final sDate = DateTime(r.startTime.year, r.startTime.month, r.startTime.day);
        return sDate.isAtSameMomentAs(selectedDate);
      }).toList();
    } catch (_) {
      // Table may not exist yet on first launch before migration
      return [];
    }
  }

  Future<void> addSession({
    required String type,
    required DateTime start,
    required DateTime end,
    double distanceKm = 0,
    double calories = 0,
    int steps = 0,
  }) async {
    final db = ref.read(databaseProvider);
    await db.insertExerciseRecord(ExerciseRecordsCompanion.insert(
      userId: 'default_user',
      startTime: start,
      endTime: Value(end),
      exerciseType: Value(type),
      duration: Value(end.difference(start).inSeconds),
      distance: Value(distanceKm),
      caloriesBurned: Value(calories.toInt()),
      steps: Value(steps),
    ));
    state = AsyncData(await db.getExerciseRecordsLastDays(30));
  }
}

final sportProvider = AsyncNotifierProvider<SportNotifier, List<ExerciseRecord>>(
  SportNotifier.new,
);

// ── Dashboard / Health Viz Providers ───────────────────────────────

final healthVizTabProvider = StateProvider<int>((ref) => 0); // 0:日, 1:周, 2:月, 3:年

final aggregatedStepsProvider = FutureProvider<List<StepCount>>((ref) async {
  final tab = ref.watch(healthVizTabProvider);
  final db = ref.read(databaseProvider);
  int days = 1;
  if (tab == 1) days = 7;
  if (tab == 2) days = 30;
  if (tab == 3) days = 365;
  return db.getStepCountsLastDays(days);
});

final aggregatedSleepProvider = FutureProvider<List<SleepRecord>>((ref) async {
  final tab = ref.watch(healthVizTabProvider);
  final db = ref.read(databaseProvider);
  int days = 1;
  if (tab == 1) days = 7;
  if (tab == 2) days = 30;
  if (tab == 3) days = 365;
  return db.getSleepRecordsLastDays(days);
});

final aggregatedWeightProvider = FutureProvider<List<ProfessionalWeightRecord>>((ref) async {
  final tab = ref.watch(healthVizTabProvider);
  final db = ref.read(databaseProvider);
  int days = 1;
  if (tab == 1) days = 7;
  if (tab == 2) days = 30;
  if (tab == 3) days = 365;
  return db.getWeightRecordsLastDays(days);
});
