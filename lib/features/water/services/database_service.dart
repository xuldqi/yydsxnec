import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';
import '../models/drink_record.dart';
import '../models/nutrition.dart';
import '../models/achievement.dart';
import '../models/brand.dart';
import 'record_change_notifier.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;
  static const String _databaseName = 'milktea_note.db';
  static const int _databaseVersion = 5;

  // 表名常量
  static const String tableUsers = 'users';
  static const String tableDrinkRecords = 'drink_records';
  static const String tableUserPreferences = 'user_preferences';
  static const String tableReminderTimes = 'reminder_times';
  static const String tableCustomBrands = 'custom_brands';
  static const String tableCustomBrandProducts = 'custom_brand_products';
  static const String tableAchievements = 'achievements';
  static const String tableCheckIns = 'check_ins';

  // 获取数据库实例
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // 初始化数据库
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // 创建数据库表
  Future<void> _onCreate(Database db, int version) async {
    // 创建用户表
    await db.execute('''
      CREATE TABLE $tableUsers (
        id TEXT PRIMARY KEY,
        name TEXT,
        avatar TEXT,
        email TEXT,
        phone TEXT,
        birthday INTEGER,
        gender TEXT,
        height REAL,
        weight REAL,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');

    // 创建用户偏好设置表
    await db.execute('''
      CREATE TABLE $tableUserPreferences (
        user_id TEXT PRIMARY KEY,
        daily_water_goal REAL DEFAULT 2000.0,
        max_daily_sugar REAL DEFAULT 50.0,
        max_daily_caffeine REAL DEFAULT 400.0,
        enable_reminders INTEGER DEFAULT 1,
        enable_health_warnings INTEGER DEFAULT 1,
        theme TEXT DEFAULT 'system',
        language TEXT DEFAULT 'zh_CN',
        enable_data_sync INTEGER DEFAULT 0,
        enable_analytics INTEGER DEFAULT 1,
        theme_color TEXT DEFAULT '#000000',
        display_preference TEXT DEFAULT 'both',
        background_image TEXT,
        background_opacity REAL DEFAULT 0.3,
        monthly_budget REAL DEFAULT 0.0,
        declaration TEXT DEFAULT '今天也要好好喝水',
        declaration_text_color TEXT DEFAULT '#D97706',
        declaration_bg_color TEXT DEFAULT '#FEF3C7',
        weekly_water_goal REAL DEFAULT 14000.0,
        max_weekly_sugar REAL DEFAULT 350.0,
        max_weekly_caffeine REAL DEFAULT 2800.0,
        FOREIGN KEY (user_id) REFERENCES $tableUsers (id) ON DELETE CASCADE
      )
    ''');

    // 创建提醒时间表
    await db.execute('''
      CREATE TABLE $tableReminderTimes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT NOT NULL,
        hour INTEGER NOT NULL,
        minute INTEGER NOT NULL,
        enabled INTEGER DEFAULT 1,
        message TEXT,
        calendar_event_id INTEGER,
        FOREIGN KEY (user_id) REFERENCES $tableUsers (id) ON DELETE CASCADE
      )
    ''');

    // 创建饮品记录表
    await db.execute('''
      CREATE TABLE $tableDrinkRecords (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        category TEXT NOT NULL,
        volume REAL NOT NULL,
        size TEXT NOT NULL,
        sugar REAL DEFAULT 0.0,
        fat REAL DEFAULT 0.0,
        protein REAL DEFAULT 0.0,
        caffeine REAL DEFAULT 0.0,
        calories REAL DEFAULT 0.0,
        image_path TEXT,
        record_time INTEGER NOT NULL,
        notes TEXT,
        user_id TEXT NOT NULL,
        brand TEXT,
        price REAL,
        FOREIGN KEY (user_id) REFERENCES $tableUsers (id) ON DELETE CASCADE
      )
    ''');

    // 创建自定义品牌表
    await db.execute('''
      CREATE TABLE $tableCustomBrands (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        logo TEXT,
        user_id TEXT NOT NULL
      )
    ''');

    // 创建自定义品牌产品表
    await db.execute('''
      CREATE TABLE $tableCustomBrandProducts (
        id TEXT PRIMARY KEY,
        brand_id TEXT NOT NULL,
        name TEXT NOT NULL,
        calories REAL DEFAULT 0.0,
        volume REAL DEFAULT 0.0,
        caffeine REAL DEFAULT 0.0,
        description TEXT,
        FOREIGN KEY (brand_id) REFERENCES $tableCustomBrands (id) ON DELETE CASCADE
      )
    ''');

    // 创建成就进度表
    await db.execute('''
      CREATE TABLE $tableAchievements (
        id TEXT PRIMARY KEY,
        name TEXT,
        description TEXT,
        icon TEXT,
        target INTEGER,
        current INTEGER,
        completed INTEGER,
        completed_at INTEGER,
        category TEXT,
        user_id TEXT NOT NULL
      )
    ''');

    // 创建控糖打卡表
    await db.execute('''
      CREATE TABLE $tableCheckIns (
        date_str TEXT,
        user_id TEXT NOT NULL,
        PRIMARY KEY (date_str, user_id)
      )
    ''');

    // 创建索引
    await db.execute(
      'CREATE INDEX idx_drink_records_user_id ON $tableDrinkRecords (user_id)',
    );
    await db.execute(
      'CREATE INDEX idx_drink_records_record_time ON $tableDrinkRecords (record_time)',
    );
    await db.execute(
      'CREATE INDEX idx_drink_records_category ON $tableDrinkRecords (category)',
    );
    await db.execute(
      'CREATE INDEX idx_custom_brands_user_id ON $tableCustomBrands (user_id)',
    );
    await db.execute(
      'CREATE INDEX idx_custom_brand_products_brand_id ON $tableCustomBrandProducts (brand_id)',
    );
    await db.execute(
      'CREATE INDEX idx_achievements_user_id ON $tableAchievements (user_id)',
    );
    await db.execute(
      'CREATE INDEX idx_check_ins_user_id ON $tableCheckIns (user_id)',
    );
  }

  // 数据库升级
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        'CREATE INDEX IF NOT EXISTS idx_drink_records_user_id ON $tableDrinkRecords (user_id)',
      );
      await db.execute(
        'CREATE INDEX IF NOT EXISTS idx_drink_records_record_time ON $tableDrinkRecords (record_time)',
      );
      await db.execute(
        'CREATE INDEX IF NOT EXISTS idx_drink_records_category ON $tableDrinkRecords (category)',
      );
    }
    if (oldVersion < 3) {
      // 升级到版本 3
      try {
        await db.execute(
          'ALTER TABLE $tableDrinkRecords ADD COLUMN brand TEXT',
        );
      } catch (_) {}
      try {
        await db.execute(
          'ALTER TABLE $tableDrinkRecords ADD COLUMN price REAL',
        );
      } catch (_) {}

      try {
        await db.execute(
          'ALTER TABLE $tableUserPreferences ADD COLUMN theme_color TEXT DEFAULT \'#000000\'',
        );
      } catch (_) {}
      try {
        await db.execute(
          'ALTER TABLE $tableUserPreferences ADD COLUMN display_preference TEXT DEFAULT \'both\'',
        );
      } catch (_) {}
      try {
        await db.execute(
          'ALTER TABLE $tableUserPreferences ADD COLUMN background_image TEXT',
        );
      } catch (_) {}
      try {
        await db.execute(
          'ALTER TABLE $tableUserPreferences ADD COLUMN background_opacity REAL DEFAULT 0.3',
        );
      } catch (_) {}
      try {
        await db.execute(
          'ALTER TABLE $tableUserPreferences ADD COLUMN monthly_budget REAL DEFAULT 0.0',
        );
      } catch (_) {}

      // 创建新表
      await db.execute('''
        CREATE TABLE IF NOT EXISTS $tableCustomBrands (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          logo TEXT,
          user_id TEXT NOT NULL
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS $tableCustomBrandProducts (
          id TEXT PRIMARY KEY,
          brand_id TEXT NOT NULL,
          name TEXT NOT NULL,
          calories REAL DEFAULT 0.0,
          volume REAL DEFAULT 0.0,
          caffeine REAL DEFAULT 0.0,
          description TEXT,
          FOREIGN KEY (brand_id) REFERENCES $tableCustomBrands (id) ON DELETE CASCADE
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS $tableAchievements (
          id TEXT PRIMARY KEY,
          name TEXT,
          description TEXT,
          icon TEXT,
          target INTEGER,
          current INTEGER,
          completed INTEGER,
          completed_at INTEGER,
          category TEXT,
          user_id TEXT NOT NULL
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS $tableCheckIns (
          date_str TEXT,
          user_id TEXT NOT NULL,
          PRIMARY KEY (date_str, user_id)
        )
      ''');

      // 创建相应索引
      await db.execute(
        'CREATE INDEX IF NOT EXISTS idx_custom_brands_user_id ON $tableCustomBrands (user_id)',
      );
      await db.execute(
        'CREATE INDEX IF NOT EXISTS idx_custom_brand_products_brand_id ON $tableCustomBrandProducts (brand_id)',
      );
      await db.execute(
        'CREATE INDEX IF NOT EXISTS idx_achievements_user_id ON $tableAchievements (user_id)',
      );
      await db.execute(
        'CREATE INDEX IF NOT EXISTS idx_check_ins_user_id ON $tableCheckIns (user_id)',
      );
    }
    if (oldVersion < 4) {
      try {
        await db.execute(
          "ALTER TABLE $tableUserPreferences ADD COLUMN declaration TEXT DEFAULT '今天也要好好喝水'",
        );
      } catch (_) {}
      try {
        await db.execute(
          "ALTER TABLE $tableUserPreferences ADD COLUMN declaration_text_color TEXT DEFAULT '#D97706'",
        );
      } catch (_) {}
      try {
        await db.execute(
          "ALTER TABLE $tableUserPreferences ADD COLUMN declaration_bg_color TEXT DEFAULT '#FEF3C7'",
        );
      } catch (_) {}
      try {
        await db.execute(
          "ALTER TABLE $tableUserPreferences ADD COLUMN weekly_water_goal REAL DEFAULT 14000.0",
        );
      } catch (_) {}
      try {
        await db.execute(
          "ALTER TABLE $tableUserPreferences ADD COLUMN max_weekly_sugar REAL DEFAULT 350.0",
        );
      } catch (_) {}
      try {
        await db.execute(
          "ALTER TABLE $tableUserPreferences ADD COLUMN max_weekly_caffeine REAL DEFAULT 2800.0",
        );
      } catch (_) {}
    }
    if (oldVersion < 5) {
      try {
        await db.execute(
          'ALTER TABLE $tableReminderTimes ADD COLUMN calendar_event_id INTEGER',
        );
      } catch (_) {}
    }
  }

  // 用户相关操作
  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert(tableUsers, user.toDbMap());
  }

  Future<User?> getUser(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableUsers,
      where: 'id = ?',
      whereArgs: [userId],
    );

    if (maps.isNotEmpty) {
      final userMap = Map<String, dynamic>.from(maps.first);
      // 获取用户偏好设置
      final preferences = await getUserPreferences(userId);
      userMap['preferences'] = preferences.toMap();
      return User.fromDbMap(userMap);
    }
    return null;
  }

  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update(
      tableUsers,
      user.toDbMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUser(String userId) async {
    final db = await database;
    return await db.delete(tableUsers, where: 'id = ?', whereArgs: [userId]);
  }

  // 用户偏好设置操作
  Future<int> insertUserPreferences(
    String userId,
    UserPreferences preferences,
  ) async {
    final db = await database;
    final map = preferences.toDbMap();
    map['user_id'] = userId;
    return await db.insert(
      tableUserPreferences,
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<UserPreferences> getUserPreferences(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableUserPreferences,
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    UserPreferences preferences;
    if (maps.isNotEmpty) {
      preferences = UserPreferences.fromDbMap(maps.first);
    } else {
      preferences = UserPreferences();
    }

    // 获取提醒时间
    final reminderTimes = await getReminderTimes(userId);
    return preferences.copyWith(reminderTimes: reminderTimes);
  }

  Future<int> updateUserPreferences(
    String userId,
    UserPreferences preferences,
  ) async {
    final db = await database;
    final map = preferences.toDbMap();
    map['user_id'] = userId;
    final rows = await db.update(
      tableUserPreferences,
      map,
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    if (rows == 0) {
      return insertUserPreferences(userId, preferences);
    }
    return rows;
  }

  // 提醒时间操作
  Future<int> insertReminderTime(
    String userId,
    ReminderTime reminderTime,
  ) async {
    final db = await database;
    final map = reminderTime.toDbMap();
    map['user_id'] = userId;
    return await db.insert(tableReminderTimes, map);
  }

  Future<void> replaceReminderTimes(
    String userId,
    List<ReminderTime> reminderTimes,
  ) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete(
        tableReminderTimes,
        where: 'user_id = ?',
        whereArgs: [userId],
      );
      for (final reminderTime in reminderTimes) {
        final map = reminderTime.toDbMap();
        map['user_id'] = userId;
        await txn.insert(tableReminderTimes, map);
      }
    });
  }

  Future<List<ReminderTime>> getReminderTimes(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableReminderTimes,
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'hour, minute',
    );

    return List.generate(maps.length, (i) {
      return ReminderTime.fromMap(maps[i]);
    });
  }

  Future<int> updateReminderTime(int id, ReminderTime reminderTime) async {
    final db = await database;
    return await db.update(
      tableReminderTimes,
      reminderTime.toDbMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteReminderTime(int id) async {
    final db = await database;
    return await db.delete(
      tableReminderTimes,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 饮品记录操作
  Future<int> insertDrinkRecord(DrinkRecord record) async {
    final db = await database;
    final id = await db.insert(tableDrinkRecords, record.toDbMap());
    RecordChangeNotifier.notifyChanged();
    return id;
  }

  Future<DrinkRecord?> getDrinkRecord(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableDrinkRecords,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return DrinkRecord.fromDbMap(maps.first);
    }
    return null;
  }

  Future<List<DrinkRecord>> getDrinkRecords({
    String? userId,
    DateTime? startDate,
    DateTime? endDate,
    String? category,
    int? limit,
    int? offset,
  }) async {
    final db = await database;
    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (userId != null) {
      whereClause += 'user_id = ?';
      whereArgs.add(userId);
    }

    if (startDate != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += 'record_time >= ?';
      whereArgs.add(startDate.millisecondsSinceEpoch);
    }

    if (endDate != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += 'record_time <= ?';
      whereArgs.add(endDate.millisecondsSinceEpoch);
    }

    if (category != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += 'category = ?';
      whereArgs.add(category);
    }

    final List<Map<String, dynamic>> maps = await db.query(
      tableDrinkRecords,
      where: whereClause.isNotEmpty ? whereClause : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
      orderBy: 'record_time DESC, id DESC',
      limit: limit,
      offset: offset,
    );

    return List.generate(maps.length, (i) {
      return DrinkRecord.fromDbMap(maps[i]);
    });
  }

  Future<int> updateDrinkRecord(DrinkRecord record) async {
    final db = await database;
    final count = await db.update(
      tableDrinkRecords,
      record.toDbMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
    if (count > 0) RecordChangeNotifier.notifyChanged();
    return count;
  }

  Future<int> deleteDrinkRecord(int id) async {
    final db = await database;
    final count = await db.delete(
      tableDrinkRecords,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (count > 0) RecordChangeNotifier.notifyChanged();
    return count;
  }

  // 统计查询
  Future<DailyNutritionStats> getDailyStats(
    String userId,
    DateTime date,
  ) async {
    final db = await database;
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final List<Map<String, dynamic>> maps = await db.query(
      tableDrinkRecords,
      where: 'user_id = ? AND record_time >= ? AND record_time < ?',
      whereArgs: [
        userId,
        startOfDay.millisecondsSinceEpoch,
        endOfDay.millisecondsSinceEpoch,
      ],
    );

    double totalVolume = 0;
    Nutrition totalNutrition = Nutrition();
    Set<String> categories = {};

    for (final map in maps) {
      final record = DrinkRecord.fromDbMap(map);
      totalVolume += record.volume;
      categories.add(record.category);

      totalNutrition =
          totalNutrition +
          Nutrition(
            sugar: record.sugar,
            fat: record.fat,
            protein: record.protein,
            caffeine: record.caffeine,
            calories: record.calories,
          );
    }

    return DailyNutritionStats(
      date: date,
      totalNutrition: totalNutrition,
      drinkCount: maps.length,
      totalVolume: totalVolume,
      categories: categories.toList(),
    );
  }

  Future<List<Map<String, dynamic>>> getCategoryStats(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final db = await database;
    return await db.rawQuery(
      '''
      SELECT 
        category,
        COUNT(*) as count,
        SUM(volume) as total_volume,
        SUM(calories) as total_calories,
        SUM(sugar) as total_sugar,
        SUM(caffeine) as total_caffeine
      FROM $tableDrinkRecords 
      WHERE user_id = ? AND record_time >= ? AND record_time <= ?
      GROUP BY category
      ORDER BY count DESC
    ''',
      [
        userId,
        startDate.millisecondsSinceEpoch,
        endDate.millisecondsSinceEpoch,
      ],
    );
  }

  // 清空所有数据
  Future<void> clearAllData() async {
    final db = await database;
    final deletedRecords = await db.delete(tableDrinkRecords);
    await db.delete(tableReminderTimes);
    await db.delete(tableUserPreferences);
    await db.delete(tableUsers);
    await db.delete(tableAchievements);
    await db.delete(tableCheckIns);
    await db.delete(tableCustomBrandProducts);
    await db.delete(tableCustomBrands);
    if (deletedRecords > 0) RecordChangeNotifier.notifyChanged();
  }

  Future<Map<String, dynamic>> exportAllData() async {
    final db = await database;
    const tables = [
      tableUsers,
      tableUserPreferences,
      tableReminderTimes,
      tableDrinkRecords,
      tableCustomBrands,
      tableCustomBrandProducts,
      tableAchievements,
      tableCheckIns,
    ];

    final data = <String, dynamic>{};
    for (final table in tables) {
      data[table] = await db.query(table);
    }
    return data;
  }

  // --- 控糖打卡 (Check-ins) ---
  Future<int> insertCheckIn(String userId, String dateStr) async {
    final db = await database;
    return await db.insert(tableCheckIns, {
      'date_str': dateStr,
      'user_id': userId,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<List<String>> getCheckInDates(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableCheckIns,
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) => maps[i]['date_str'] as String);
  }

  Future<int> deleteCheckIn(String userId, String dateStr) async {
    final db = await database;
    return await db.delete(
      tableCheckIns,
      where: 'user_id = ? AND date_str = ?',
      whereArgs: [userId, dateStr],
    );
  }

  // --- 成就系统 (Achievements) ---
  Future<List<Achievement>> getAchievements(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableAchievements,
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) => Achievement.fromMap(maps[i]));
  }

  Future<void> saveAchievements(String userId, List<Achievement> list) async {
    final db = await database;
    final batch = db.batch();
    for (final a in list) {
      batch.insert(
        tableAchievements,
        a.toDbMap(userId),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<void> deleteAchievementsExcept(
    String userId,
    Set<String> achievementIds,
  ) async {
    final db = await database;
    if (achievementIds.isEmpty) {
      await db.delete(
        tableAchievements,
        where: 'user_id = ?',
        whereArgs: [userId],
      );
      return;
    }

    final placeholders = List.filled(achievementIds.length, '?').join(',');
    await db.delete(
      tableAchievements,
      where: 'user_id = ? AND id NOT IN ($placeholders)',
      whereArgs: [userId, ...achievementIds],
    );
  }

  Future<int> updateAchievement(String userId, Achievement a) async {
    final db = await database;
    return await db.update(
      tableAchievements,
      a.toDbMap(userId),
      where: 'user_id = ? AND id = ?',
      whereArgs: [userId, a.id],
    );
  }

  // --- 自定义品牌与产品 (Custom Brands & Products) ---
  Future<int> insertCustomBrand(String userId, BrandPreset brand) async {
    final db = await database;
    await db.insert(tableCustomBrands, {
      'id': brand.id,
      'name': brand.name,
      'logo': brand.logo,
      'user_id': userId,
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    await db.delete(
      tableCustomBrandProducts,
      where: 'brand_id = ?',
      whereArgs: [brand.id],
    );

    final batch = db.batch();
    for (final p in brand.products) {
      final productId = '${brand.id}_${p.name}';
      batch.insert(tableCustomBrandProducts, {
        'id': productId,
        'brand_id': brand.id,
        'name': p.name,
        'calories': p.calories,
        'volume': p.volume,
        'caffeine': p.caffeine,
        'description': p.description,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
    return 1;
  }

  Future<List<BrandPreset>> getCustomBrands(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> brandMaps = await db.query(
      tableCustomBrands,
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    List<BrandPreset> list = [];
    for (final bMap in brandMaps) {
      final brandId = bMap['id'] as String;
      final List<Map<String, dynamic>> productMaps = await db.query(
        tableCustomBrandProducts,
        where: 'brand_id = ?',
        whereArgs: [brandId],
      );

      final products = productMaps
          .map(
            (pMap) => ProductPreset(
              name: pMap['name'] as String,
              calories: (pMap['calories'] as num?)?.toDouble() ?? 0.0,
              volume: (pMap['volume'] as num?)?.toDouble() ?? 0.0,
              caffeine: (pMap['caffeine'] as num?)?.toDouble() ?? 0.0,
              description: pMap['description'] as String?,
            ),
          )
          .toList();

      list.add(
        BrandPreset(
          id: brandId,
          name: bMap['name'] as String,
          logo: bMap['logo'] as String? ?? '🥤',
          products: products,
          isCustom: true,
        ),
      );
    }
    return list;
  }

  Future<int> deleteCustomBrand(String brandId) async {
    final db = await database;
    // On cascade delete will clear products from custom_brand_products
    await db.delete(
      tableCustomBrandProducts,
      where: 'brand_id = ?',
      whereArgs: [brandId],
    );
    return await db.delete(
      tableCustomBrands,
      where: 'id = ?',
      whereArgs: [brandId],
    );
  }

  // 关闭数据库
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
