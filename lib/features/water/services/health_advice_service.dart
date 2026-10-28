import 'database_service.dart';

class HealthAdvice {
  final String type; // 'warning' | 'info' | 'success'
  final String title;
  final String message;
  final String icon;

  HealthAdvice({
    required this.type,
    required this.title,
    required this.message,
    required this.icon,
  });
}

class HealthAdviceService {
  static final HealthAdviceService _instance = HealthAdviceService._internal();
  factory HealthAdviceService() => _instance;
  HealthAdviceService._internal();

  final DatabaseService _db = DatabaseService();

  // 生成今日健康建议（最多3条）
  Future<List<HealthAdvice>> generateTodayHealthAdvice(String userId) async {
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final endOfToday = startOfToday.add(const Duration(days: 1));

    final records = await _db.getDrinkRecords(
      userId: userId,
      startDate: startOfToday,
      endDate: endOfToday,
    );
    final preferences = await _db.getUserPreferences(userId);

    List<HealthAdvice> adviceList = [];

    // 默认提醒线（未设置时使用标准）
    final double sugarGoal = preferences.maxDailySugar;
    final double caffeineGoal = preferences.maxDailyCaffeine;

    if (records.isEmpty) {
      // 如果今天没有记录任何饮品，给出喝水提醒
      adviceList.add(
        HealthAdvice(
          type: 'info',
          title: '还没有记录',
          message: '今天还没有喝水记录，可以先补一杯水。',
          icon: '💧',
        ),
      );

      // 时间段贴心提醒
      final timeAdvice = _getTimeBasedAdvice();
      if (timeAdvice != null) {
        adviceList.add(timeAdvice);
      }
      return adviceList;
    }

    // 统计今日数据
    double totalSugar = 0.0;
    double totalCaffeine = 0.0;
    double totalCalories = 0.0;

    for (var r in records) {
      totalSugar += r.sugar;
      totalCaffeine += r.caffeine;
      totalCalories += r.calories;
    }

    // 1. 卡路里建议
    if (totalCalories > 0) {
      if (totalCalories > 400) {
        final runningMinutes = (totalCalories / 10).round();
        adviceList.add(
          HealthAdvice(
            type: 'warning',
            title: '卡路里摄入偏高',
            message:
                '今日卡路里摄入已达 ${totalCalories.toStringAsFixed(0)} kcal，建议通过慢跑约 $runningMinutes 分钟来消耗它。',
            icon: '🏃',
          ),
        );
      } else {
        adviceList.add(
          HealthAdvice(
            type: 'success',
            title: '卡路里控制良好',
            message:
                '今日摄入卡路里为 ${totalCalories.toStringAsFixed(0)} kcal，属于温和范围。',
            icon: '💪',
          ),
        );
      }
    }

    // 2. 糖分预警
    if (sugarGoal > 0) {
      final ratio = totalSugar / sugarGoal;
      if (ratio >= 1.0) {
        adviceList.add(
          HealthAdvice(
            type: 'warning',
            title: '糖分摄入超标',
            message:
                '今日糖分已摄入 ${totalSugar.toStringAsFixed(0)}g，超过了你设置的提醒线 ${sugarGoal.toStringAsFixed(0)}g。',
            icon: '🚫',
          ),
        );
      } else if (ratio >= 0.8) {
        adviceList.add(
          HealthAdvice(
            type: 'warning',
            title: '糖分接近上限',
            message:
                '今日已摄入 ${totalSugar.toStringAsFixed(0)}g 糖分，快要达到设定的每日上限了，注意防范。',
            icon: '⚠️',
          ),
        );
      }
    }

    // 3. 咖啡因提醒
    if (caffeineGoal > 0) {
      final ratio = totalCaffeine / caffeineGoal;
      if (ratio >= 1.0) {
        adviceList.add(
          HealthAdvice(
            type: 'warning',
            title: '咖啡因摄入超标',
            message:
                '今日已摄入 ${totalCaffeine.toStringAsFixed(0)}mg 咖啡因，建议避免后续再饮用茶或咖啡以防失眠。',
            icon: '☕',
          ),
        );
      } else if (ratio >= 0.8) {
        adviceList.add(
          HealthAdvice(
            type: 'warning',
            title: '咖啡因接近上限',
            message:
                '今日咖啡因摄入已达 ${totalCaffeine.toStringAsFixed(0)}mg，请适量减少晚间的提神饮品。',
            icon: '⚠️',
          ),
        );
      }
    }

    // 4. 时间段建议
    final timeAdvice = _getTimeBasedAdvice();
    if (timeAdvice != null) {
      adviceList.add(timeAdvice);
    }

    return adviceList.take(3).toList();
  }

  // 时间提醒
  HealthAdvice? _getTimeBasedAdvice() {
    final hour = DateTime.now().hour;
    if (hour >= 20 || hour < 6) {
      return HealthAdvice(
        type: 'info',
        title: '时间段建议',
        message: '晚上8点后建议选择无咖啡因或低咖啡因饮品，避免咖啡因干扰深度睡眠状态。',
        icon: '🌙',
      );
    }
    return null;
  }
}
