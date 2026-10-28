import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/database/app_database.dart';
import '../../core/services/database_provider.dart';

class WeeklyReportData {
  final List<double> dailySteps; // 7 days (index 0 is 6 days ago, index 6 is today)
  final List<double> dailyCalories;
  final List<double> dailyWeight;
  final List<double> dailySleepMins;
  
  final int totalSteps;
  final int totalCalories;
  final double avgWeight;
  final int avgSleepMins;
  
  final int bestSteps;
  final int bestCalories;
  final double bestWeight; // lowest
  final int bestSleepMins; // max

  WeeklyReportData({
    required this.dailySteps,
    required this.dailyCalories,
    required this.dailyWeight,
    required this.dailySleepMins,
    required this.totalSteps,
    required this.totalCalories,
    required this.avgWeight,
    required this.avgSleepMins,
    required this.bestSteps,
    required this.bestCalories,
    required this.bestWeight,
    required this.bestSleepMins,
  });
}

final weeklyReportProvider = FutureProvider.autoDispose<WeeklyReportData>((ref) async {
  final db = ref.watch(databaseProvider);
  
  // Fetch data for the last 7 days.
  final now = DateTime.now();
  final List<String> daysKeys = [];
  for (int i = 6; i >= 0; i--) {
    final d = now.subtract(Duration(days: i));
    daysKeys.add(DateFormat('yyyy-MM-dd').format(d));
  }
  
  // 1. Fetch data
  final steps = await db.getStepCountsLastDays(7);
  final exercises = await db.getExerciseRecordsLastDays(7);
  final weights = await db.getWeightRecordsLastDays(7);
  final sleeps = await db.getSleepRecordsLastDays(7);

  // Maps
  final stepsMap = <String, double>{};
  for (final s in steps) {
    final key = DateFormat('yyyy-MM-dd').format(s.startTime);
    stepsMap[key] = (stepsMap[key] ?? 0.0) + s.stepsNum.toDouble();
  }
  
  final calsMap = <String, double>{};
  for (final e in exercises) {
    final key = DateFormat('yyyy-MM-dd').format(e.startTime);
    calsMap[key] = (calsMap[key] ?? 0.0) + (e.caloriesBurned?.toDouble() ?? 0.0);
  }
  
  final weightsMap = <String, double>{};
  for (final w in weights) {
    final key = DateFormat('yyyy-MM-dd').format(w.recordDatetime);
    weightsMap[key] = w.weight; // Take the latest weight for that day
  }
  
  final sleepsMap = <String, double>{};
  for (final s in sleeps) {
    final key = DateFormat('yyyy-MM-dd').format(s.wakeTime); // Use end time as the day of sleep
    final dur = s.wakeTime.difference(s.sleepTime).inMinutes.toDouble();
    sleepsMap[key] = (sleepsMap[key] ?? 0.0) + dur;
  }
  
  // Build Lists
  final dailySteps = <double>[];
  final dailyCalories = <double>[];
  final dailyWeight = <double>[];
  final dailySleepMins = <double>[];
  
  double lastKnownWeight = weights.isNotEmpty ? weights.last.weight : 0.0;
  
  for (final key in daysKeys) {
    dailySteps.add(stepsMap[key] ?? 0.0);
    dailyCalories.add(calsMap[key] ?? 0.0);
    
    if (weightsMap.containsKey(key)) {
       lastKnownWeight = weightsMap[key]!;
    }
    dailyWeight.add(lastKnownWeight);
    dailySleepMins.add(sleepsMap[key] ?? 0.0);
  }
  
  // Stats
  final totalSteps = dailySteps.fold(0.0, (a, b) => a + b).toInt();
  final bestSteps = dailySteps.isEmpty ? 0 : dailySteps.reduce((a, b) => a > b ? a : b).toInt();
  
  final totalCalories = dailyCalories.fold(0.0, (a, b) => a + b).toInt();
  final bestCalories = dailyCalories.isEmpty ? 0 : dailyCalories.reduce((a, b) => a > b ? a : b).toInt();
  
  final avgWeight = dailyWeight.fold(0.0, (a, b) => a + b) / (dailyWeight.where((w) => w > 0).length > 0 ? dailyWeight.where((w) => w > 0).length : 1);
  final bestWeight = dailyWeight.isEmpty ? 0.0 : dailyWeight.where((w) => w > 0).fold(9999.0, (a, b) => a < b ? a : b);
  final bw = bestWeight == 9999.0 ? 0.0 : bestWeight;
  
  final totalSleep = dailySleepMins.fold(0.0, (a, b) => a + b).toInt();
  final bestSleepMins = dailySleepMins.isEmpty ? 0 : dailySleepMins.reduce((a, b) => a > b ? a : b).toInt();
  final validSleepDays = dailySleepMins.where((s) => s > 0).length;
  final avgSleepMins = validSleepDays > 0 ? totalSleep ~/ validSleepDays : 0;
  
  return WeeklyReportData(
    dailySteps: dailySteps,
    dailyCalories: dailyCalories,
    dailyWeight: dailyWeight,
    dailySleepMins: dailySleepMins,
    totalSteps: totalSteps,
    totalCalories: totalCalories,
    avgWeight: avgWeight.isNaN ? 0.0 : avgWeight,
    avgSleepMins: avgSleepMins,
    bestSteps: bestSteps,
    bestCalories: bestCalories,
    bestWeight: bw,
    bestSleepMins: bestSleepMins,
  );
});
