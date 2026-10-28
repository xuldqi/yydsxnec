import '../models/drink_record.dart';
import '../models/nutrition.dart';

class DrinkStatisticsService {
  DateTime startDateByPeriod(DateTime now, String period) {
    switch (period) {
      case '今日':
        return DateTime(now.year, now.month, now.day);
      case '本月':
        return DateTime(now.year, now.month, 1);
      case '本年':
        return DateTime(now.year, 1, 1);
      case '本周':
      default:
        final today = DateTime(now.year, now.month, now.day);
        return today.subtract(Duration(days: now.weekday - 1));
    }
  }

  Nutrition aggregateNutrition(Iterable<DrinkRecord> records) {
    var total = Nutrition();
    for (final record in records) {
      total =
          total +
          Nutrition(
            sugar: record.sugar,
            fat: record.fat,
            protein: record.protein,
            caffeine: record.caffeine,
            calories: record.calories,
          );
    }
    return total;
  }

  double totalVolume(Iterable<DrinkRecord> records) {
    return records.fold(0, (sum, record) => sum + record.volume);
  }

  int goalRatePercent({
    required double totalVolume,
    required DateTime now,
    required DateTime periodStart,
    double dailyGoal = 2000,
  }) {
    final days = now.difference(periodStart).inDays + 1;
    final goal = days * dailyGoal;
    if (goal <= 0) return 0;
    return ((totalVolume / goal) * 100).clamp(0, 100).round();
  }

  Map<String, int> categoryCount(Iterable<DrinkRecord> records) {
    final map = <String, int>{};
    for (final record in records) {
      map.update(record.category, (value) => value + 1, ifAbsent: () => 1);
    }
    return map;
  }

  List<double> weeklyVolumeSeries({
    required Iterable<DrinkRecord> records,
    required DateTime now,
    int days = 7,
  }) {
    final data = List<double>.filled(days, 0);
    for (final record in records) {
      final diff = now.difference(record.recordTime).inDays;
      if (diff >= 0 && diff < days) {
        final index = days - 1 - diff;
        data[index] += record.volume;
      }
    }
    return data;
  }
}
