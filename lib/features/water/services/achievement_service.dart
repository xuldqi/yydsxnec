import '../models/achievement.dart';
import '../models/drink_record.dart';
import '../models/user.dart';
import 'database_service.dart';

class AchievementService {
  static final AchievementService _instance = AchievementService._internal();
  factory AchievementService() => _instance;
  AchievementService._internal();

  final DatabaseService _db = DatabaseService();

  // 默认初始成就列表
  final List<Achievement> _defaultAchievements = [
    Achievement(
      id: 'first_record',
      name: '第一杯',
      description: '完成首次记录',
      icon: '🎉',
      target: 1,
      current: 0,
      completed: false,
      category: AchievementCategory.record,
    ),
    Achievement(
      id: 'record_7_days',
      name: '坚持一周',
      description: '连续记录7天',
      icon: '📅',
      target: 7,
      current: 0,
      completed: false,
      category: AchievementCategory.record,
    ),
    Achievement(
      id: 'record_30_days',
      name: '月度坚持',
      description: '连续记录30天',
      icon: '🗓️',
      target: 30,
      current: 0,
      completed: false,
      category: AchievementCategory.record,
    ),
    Achievement(
      id: 'water_goal_7_days',
      name: '一周达标',
      description: '连续达标7天',
      icon: '💧',
      target: 7,
      current: 0,
      completed: false,
      category: AchievementCategory.streak,
    ),
    Achievement(
      id: 'water_goal_30_days',
      name: '月度达标',
      description: '连续达标30天',
      icon: '⭐',
      target: 30,
      current: 0,
      completed: false,
      category: AchievementCategory.streak,
    ),
    Achievement(
      id: 'plain_water_7_days',
      name: '清水一周',
      description: '连续饮水7天',
      icon: '🥛',
      target: 7,
      current: 0,
      completed: false,
      category: AchievementCategory.goal,
    ),
    Achievement(
      id: 'water_record_20',
      name: '补水常客',
      description: '记录水类20次',
      icon: '🌿',
      target: 20,
      current: 0,
      completed: false,
      category: AchievementCategory.goal,
    ),
    Achievement(
      id: 'drink_type_5',
      name: '饮品地图',
      description: '记录5类饮品',
      icon: '🧭',
      target: 5,
      current: 0,
      completed: false,
      category: AchievementCategory.explore,
    ),
    Achievement(
      id: 'brand_5',
      name: '品牌收藏',
      description: '记录5个品牌',
      icon: '🏷️',
      target: 5,
      current: 0,
      completed: false,
      category: AchievementCategory.explore,
    ),
  ];

  Set<String> get _activeAchievementIds =>
      _defaultAchievements.map((achievement) => achievement.id).toSet();

  // 核心检测方法：扫描用户数据并更新成就进度
  Future<List<String>> checkAndUnlockAchievements(String userId) async {
    // 1. 获取所有现有成就进度
    List<Achievement> userAchievements = await _db.getAchievements(userId);
    if (userAchievements.isEmpty) {
      userAchievements = List.from(_defaultAchievements);
      await _db.saveAchievements(userId, userAchievements);
    } else {
      userAchievements = _syncAchievementDefinitions(userAchievements);
      await _db.deleteAchievementsExcept(userId, _activeAchievementIds);
    }

    // 2. 获取用户记录和数据
    final records = await _db.getDrinkRecords(userId: userId);
    final preferences = await _db.getUserPreferences(userId);

    // 3. 计算各个统计值
    final consecutiveRecordDays = _calculateConsecutiveRecordDays(records);
    final consecutiveWaterGoalDays = _calculateConsecutiveWaterGoalDays(
      records,
      preferences,
    );
    final consecutivePlainWaterDays = _calculateConsecutivePlainWaterDays(
      records,
    );
    final plainWaterRecordCount = _calculatePlainWaterRecordCount(records);
    final uniqueCategoriesCount = _calculateUniqueCategories(records);
    final uniqueBrandsCount = _calculateUniqueBrands(records);

    List<String> newlyUnlockedIds = [];
    List<Achievement> updatedList = [];

    final now = DateTime.now();

    for (var a in userAchievements) {
      if (a.completed) {
        updatedList.add(a);
        continue;
      }

      int current = 0;
      switch (a.id) {
        case 'first_record':
          current = records.isNotEmpty ? 1 : 0;
          break;
        case 'record_7_days':
          current = consecutiveRecordDays;
          break;
        case 'record_30_days':
          current = consecutiveRecordDays;
          break;
        case 'water_goal_7_days':
        case 'water_goal_30_days':
          current = consecutiveWaterGoalDays;
          break;
        case 'plain_water_7_days':
          current = consecutivePlainWaterDays;
          break;
        case 'water_record_20':
          current = plainWaterRecordCount;
          break;
        case 'drink_type_5':
          current = uniqueCategoriesCount;
          break;
        case 'brand_5':
          current = uniqueBrandsCount;
          break;
      }

      final isCompleted = current >= a.target;
      if (isCompleted) {
        newlyUnlockedIds.add(a.id);
        updatedList.add(
          a.copyWith(current: a.target, completed: true, completedAt: now),
        );
      } else {
        updatedList.add(
          a.copyWith(current: current > a.target ? a.target : current),
        );
      }
    }

    // 保存更改
    await _db.saveAchievements(userId, updatedList);
    return newlyUnlockedIds;
  }

  List<Achievement> _syncAchievementDefinitions(List<Achievement> existing) {
    final defaultsById = {
      for (final item in _defaultAchievements) item.id: item,
    };
    final syncedById = <String, Achievement>{};

    for (final achievement in existing) {
      final latest = defaultsById[achievement.id];
      if (latest == null) continue;
      syncedById[achievement.id] = achievement.copyWith(
        name: latest.name,
        description: latest.description,
        icon: latest.icon,
        target: latest.target,
        category: latest.category,
      );
    }

    for (final achievement in _defaultAchievements) {
      syncedById.putIfAbsent(achievement.id, () => achievement);
    }

    return _defaultAchievements
        .map((achievement) => syncedById[achievement.id]!)
        .toList();
  }

  // 计算连续记录天数
  int _calculateConsecutiveRecordDays(List<DrinkRecord> records) {
    final Set<String> activeDates = {};
    for (var r in records) {
      final t = r.recordTime;
      activeDates.add('${t.year}-${t.month}-${t.day}');
    }

    if (activeDates.isEmpty) return 0;

    int consecutive = 0;
    final today = DateTime.now();
    for (int i = 0; i < 365; i++) {
      final checkDate = today.subtract(Duration(days: i));
      final dateStr = '${checkDate.year}-${checkDate.month}-${checkDate.day}';
      if (activeDates.contains(dateStr)) {
        consecutive++;
      } else {
        break;
      }
    }
    return consecutive;
  }

  // 计算连续达到每日喝水目标的天数
  int _calculateConsecutiveWaterGoalDays(
    List<DrinkRecord> records,
    UserPreferences preferences,
  ) {
    if (records.isEmpty) return 0;

    int consecutive = 0;
    final today = DateTime.now();

    for (int i = 0; i < 365; i++) {
      final checkDate = today.subtract(Duration(days: i));
      final start = DateTime(checkDate.year, checkDate.month, checkDate.day);
      final end = start.add(const Duration(days: 1));

      final dayRecords = records.where(
        (r) => !r.recordTime.isBefore(start) && r.recordTime.isBefore(end),
      );
      final totalVolume = dayRecords.fold<double>(
        0,
        (sum, record) => sum + record.volume,
      );

      if (totalVolume >= preferences.dailyWaterGoal) {
        consecutive++;
      } else {
        break;
      }
    }
    return consecutive;
  }

  // 计算连续有白水记录的天数
  int _calculateConsecutivePlainWaterDays(List<DrinkRecord> records) {
    if (records.isEmpty) return 0;

    int consecutive = 0;
    final today = DateTime.now();

    for (int i = 0; i < 365; i++) {
      final checkDate = today.subtract(Duration(days: i));
      final start = DateTime(checkDate.year, checkDate.month, checkDate.day);
      final end = start.add(const Duration(days: 1));
      final hasPlainWater = records.any(
        (record) =>
            !record.recordTime.isBefore(start) &&
            record.recordTime.isBefore(end) &&
            _isPlainWater(record),
      );

      if (hasPlainWater) {
        consecutive++;
      } else {
        break;
      }
    }

    return consecutive;
  }

  int _calculatePlainWaterRecordCount(List<DrinkRecord> records) {
    return records.where(_isPlainWater).length;
  }

  int _calculateUniqueCategories(List<DrinkRecord> records) {
    final categories = <String>{};
    for (final record in records) {
      final category = record.category.trim();
      if (category.isNotEmpty) {
        categories.add(category);
      }
    }
    return categories.length;
  }

  // 计算不同品牌的个数
  int _calculateUniqueBrands(List<DrinkRecord> records) {
    final Set<String> brands = {};
    for (var r in records) {
      if (r.brand != null && r.brand!.trim().isNotEmpty) {
        brands.add(r.brand!.trim());
      }
    }
    return brands.length;
  }

  bool _isPlainWater(DrinkRecord record) {
    final name = record.name.trim();
    final category = record.category.trim();
    return category == '白开水' ||
        category == '水' ||
        name == '水' ||
        name == '白开水' ||
        name == '瓶装水' ||
        name == '矿泉水' ||
        name == '纯净水';
  }
}
