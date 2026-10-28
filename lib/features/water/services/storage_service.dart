import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/drink_record.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;

  // 初始化SharedPreferences
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // 确保SharedPreferences已初始化
  Future<SharedPreferences> get prefs async {
    if (_prefs == null) {
      await init();
    }
    return _prefs!;
  }

  // 存储键名常量
  static const String keyCurrentUserId = 'current_user_id';
  static const String keyIsFirstLaunch = 'is_first_launch';
  static const String keyLoginType = 'login_type';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguage = 'language';
  static const String keyNotificationEnabled = 'notification_enabled';
  static const String keyLastSyncTime = 'last_sync_time';
  static const String keyOfflineRecords = 'offline_records';
  static const String keyUserPreferences = 'user_preferences_';
  static const String keyDailyGoals = 'daily_goals_';
  static const String keyHealthSettings = 'health_settings_';
  static const String keyAppSettings = 'app_settings';
  static const String keyBackupData = 'backup_data';

  // 用户相关存储
  Future<bool> setCurrentUserId(String userId) async {
    final prefs = await this.prefs;
    return await prefs.setString(keyCurrentUserId, userId);
  }

  Future<String?> getCurrentUserId() async {
    final prefs = await this.prefs;
    return prefs.getString(keyCurrentUserId);
  }

  Future<bool> clearCurrentUserId() async {
    final prefs = await this.prefs;
    return await prefs.remove(keyCurrentUserId);
  }

  // 登录相关存储
  Future<bool> setLoginType(String loginType) async {
    final prefs = await this.prefs;
    return await prefs.setString(keyLoginType, loginType);
  }

  Future<String?> getLoginType() async {
    final prefs = await this.prefs;
    return prefs.getString(keyLoginType);
  }

  // 首次启动标记
  Future<bool> setFirstLaunch(bool isFirst) async {
    final prefs = await this.prefs;
    return await prefs.setBool(keyIsFirstLaunch, isFirst);
  }

  Future<bool> isFirstLaunch() async {
    final prefs = await this.prefs;
    return prefs.getBool(keyIsFirstLaunch) ?? true;
  }

  // 主题设置
  Future<bool> setThemeMode(String themeMode) async {
    final prefs = await this.prefs;
    return await prefs.setString(keyThemeMode, themeMode);
  }

  Future<String> getThemeMode() async {
    final prefs = await this.prefs;
    return prefs.getString(keyThemeMode) ?? 'system';
  }

  // 语言设置
  Future<bool> setLanguage(String language) async {
    final prefs = await this.prefs;
    return await prefs.setString(keyLanguage, language);
  }

  Future<String> getLanguage() async {
    final prefs = await this.prefs;
    return prefs.getString(keyLanguage) ?? 'zh_CN';
  }

  // 通知设置
  Future<bool> setNotificationEnabled(bool enabled) async {
    final prefs = await this.prefs;
    return await prefs.setBool(keyNotificationEnabled, enabled);
  }

  Future<bool> isNotificationEnabled() async {
    final prefs = await this.prefs;
    return prefs.getBool(keyNotificationEnabled) ?? true;
  }

  // 同步时间
  Future<bool> setLastSyncTime(DateTime time) async {
    final prefs = await this.prefs;
    return await prefs.setInt(keyLastSyncTime, time.millisecondsSinceEpoch);
  }

  Future<DateTime?> getLastSyncTime() async {
    final prefs = await this.prefs;
    final timestamp = prefs.getInt(keyLastSyncTime);
    return timestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(timestamp)
        : null;
  }

  // 用户偏好设置存储
  Future<bool> setUserPreferences(
    String userId,
    UserPreferences preferences,
  ) async {
    final prefs = await this.prefs;
    final json = jsonEncode(preferences.toMap());
    return await prefs.setString('$keyUserPreferences$userId', json);
  }

  Future<UserPreferences?> getUserPreferences(String userId) async {
    final prefs = await this.prefs;
    final json = prefs.getString('$keyUserPreferences$userId');
    if (json != null) {
      try {
        final map = jsonDecode(json) as Map<String, dynamic>;
        return UserPreferences.fromMap(map);
      } catch (e) {
        // Error parsing user preferences: $e
        return null;
      }
    }
    return null;
  }

  // 每日目标设置
  Future<bool> setDailyGoals(String userId, Map<String, dynamic> goals) async {
    final prefs = await this.prefs;
    final json = jsonEncode(goals);
    return await prefs.setString('$keyDailyGoals$userId', json);
  }

  Future<Map<String, dynamic>?> getDailyGoals(String userId) async {
    final prefs = await this.prefs;
    final json = prefs.getString('$keyDailyGoals$userId');
    if (json != null) {
      try {
        return jsonDecode(json) as Map<String, dynamic>;
      } catch (e) {
        // Error parsing daily goals: $e
        return null;
      }
    }
    return null;
  }

  // 健康设置
  Future<bool> setHealthSettings(
    String userId,
    Map<String, dynamic> settings,
  ) async {
    final prefs = await this.prefs;
    final json = jsonEncode(settings);
    return await prefs.setString('$keyHealthSettings$userId', json);
  }

  Future<Map<String, dynamic>?> getHealthSettings(String userId) async {
    final prefs = await this.prefs;
    final json = prefs.getString('$keyHealthSettings$userId');
    if (json != null) {
      try {
        return jsonDecode(json) as Map<String, dynamic>;
      } catch (e) {
        // Error parsing health settings: $e
        return null;
      }
    }
    return null;
  }

  // 应用设置
  Future<bool> setAppSettings(Map<String, dynamic> settings) async {
    final prefs = await this.prefs;
    final json = jsonEncode(settings);
    return await prefs.setString(keyAppSettings, json);
  }

  Future<Map<String, dynamic>?> getAppSettings() async {
    final prefs = await this.prefs;
    final json = prefs.getString(keyAppSettings);
    if (json != null) {
      try {
        return jsonDecode(json) as Map<String, dynamic>;
      } catch (e) {
        // Error parsing app settings: $e
        return null;
      }
    }
    return null;
  }

  // 离线记录存储（用于网络不可用时临时存储）
  Future<bool> addOfflineRecord(DrinkRecord record) async {
    final prefs = await this.prefs;
    final existingRecords = await getOfflineRecords();
    existingRecords.add(record);

    final jsonList = existingRecords
        .map((record) => jsonEncode(record.toMap()))
        .toList();
    return await prefs.setStringList(keyOfflineRecords, jsonList);
  }

  Future<List<DrinkRecord>> getOfflineRecords() async {
    final prefs = await this.prefs;
    final jsonList = prefs.getStringList(keyOfflineRecords) ?? [];

    final records = <DrinkRecord>[];
    for (final json in jsonList) {
      try {
        final map = jsonDecode(json) as Map<String, dynamic>;
        records.add(DrinkRecord.fromMap(map));
      } catch (e) {
        // Error parsing offline record: $e
      }
    }
    return records;
  }

  Future<bool> clearOfflineRecords() async {
    final prefs = await this.prefs;
    return await prefs.remove(keyOfflineRecords);
  }

  // 数据备份
  Future<bool> backupData(Map<String, dynamic> data) async {
    final prefs = await this.prefs;
    final json = jsonEncode(data);
    return await prefs.setString(keyBackupData, json);
  }

  Future<Map<String, dynamic>?> getBackupData() async {
    final prefs = await this.prefs;
    final json = prefs.getString(keyBackupData);
    if (json != null) {
      try {
        return jsonDecode(json) as Map<String, dynamic>;
      } catch (e) {
        // Error parsing backup data: $e
        return null;
      }
    }
    return null;
  }

  // 缓存管理
  Future<bool> setCacheData(
    String key,
    Map<String, dynamic> data, {
    Duration? expiry,
  }) async {
    final prefs = await this.prefs;
    final cacheData = {
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'expiry': expiry?.inMilliseconds,
    };
    final json = jsonEncode(cacheData);
    return await prefs.setString('cache_$key', json);
  }

  Future<Map<String, dynamic>?> getCacheData(String key) async {
    final prefs = await this.prefs;
    final json = prefs.getString('cache_$key');
    if (json != null) {
      try {
        final cacheData = jsonDecode(json) as Map<String, dynamic>;
        final timestamp = cacheData['timestamp'] as int;
        final expiry = cacheData['expiry'] as int?;

        if (expiry != null) {
          final expiryTime = DateTime.fromMillisecondsSinceEpoch(
            timestamp + expiry,
          );
          if (DateTime.now().isAfter(expiryTime)) {
            // 缓存已过期，删除并返回null
            await prefs.remove('cache_$key');
            return null;
          }
        }

        return cacheData['data'] as Map<String, dynamic>;
      } catch (e) {
        // Error parsing cache data: $e
        return null;
      }
    }
    return null;
  }

  Future<bool> clearCache(String key) async {
    final prefs = await this.prefs;
    return await prefs.remove('cache_$key');
  }

  Future<bool> clearAllCache() async {
    final prefs = await this.prefs;
    final keys = prefs
        .getKeys()
        .where((key) => key.startsWith('cache_'))
        .toList();
    for (final key in keys) {
      await prefs.remove(key);
    }
    return true;
  }

  // 清空所有数据
  Future<bool> clearAllData() async {
    final prefs = await this.prefs;
    return await prefs.clear();
  }

  // 获取存储使用情况
  Future<Map<String, dynamic>> getStorageInfo() async {
    final prefs = await this.prefs;
    final keys = prefs.getKeys();
    int totalSize = 0;

    for (final key in keys) {
      final value = prefs.get(key);
      if (value is String) {
        totalSize += value.length;
      }
    }

    return {
      'totalKeys': keys.length,
      'estimatedSize': totalSize,
      'keys': keys.toList(),
    };
  }

  // 数据导出
  Future<Map<String, dynamic>> exportAllData() async {
    final prefs = await this.prefs;
    final keys = prefs.getKeys();
    final data = <String, dynamic>{};

    for (final key in keys) {
      data[key] = prefs.get(key);
    }

    return {
      'exportTime': DateTime.now().toIso8601String(),
      'version': '1.0',
      'data': data,
    };
  }

  // 数据导入
  Future<bool> importData(Map<String, dynamic> importData) async {
    try {
      final prefs = await this.prefs;
      final data = importData['data'] as Map<String, dynamic>;

      for (final entry in data.entries) {
        final key = entry.key;
        final value = entry.value;

        if (value is String) {
          await prefs.setString(key, value);
        } else if (value is int) {
          await prefs.setInt(key, value);
        } else if (value is double) {
          await prefs.setDouble(key, value);
        } else if (value is bool) {
          await prefs.setBool(key, value);
        } else if (value is List<String>) {
          await prefs.setStringList(key, value);
        }
      }

      return true;
    } catch (e) {
      // Error importing data: $e
      return false;
    }
  }
}
