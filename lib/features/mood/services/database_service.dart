import 'dart:convert';
import '../models/emotion_record.dart';
import 'dart:async';
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';

import 'mood_records_storage_io.dart'
    if (dart.library.html) 'mood_records_storage_web.dart'
    as file_storage;

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static const String _moodRecordsKey = 'mood_records';
  static const String _moodRecordsBackupKey = 'mood_records_backup';

  SharedPreferences? _prefs;
  bool _migratedFromPrefs = false;
  List<Map<String, dynamic>> _memoryEmotionRecords = [];

  Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // 用于测试：重置缓存，避免不同用例之间的 mock SharedPreferences 串扰
  void resetCachedPrefsForTesting() {
    _prefs = null;
    _migratedFromPrefs = false;
  }

  // 情绪记录操作 - 移动端用文件存储更可靠，Web 用 SharedPreferences
  Future<void> insertEmotionRecord(Map<String, dynamic> record) async {
    final records = await getEmotionRecords();
    records.add(record);
    await _writeRecords(records);
  }

  Future<List<Map<String, dynamic>>> getEmotionRecords() async {
    if (!_migratedFromPrefs) {
      await _migrateFromSharedPreferences();
    }

    final prefsRecords = await _getEmotionRecordsFromPrefs(_moodRecordsKey);
    final backupRecords = await _getEmotionRecordsFromPrefs(_moodRecordsBackupKey);

    if (kIsWeb) {
      final merged = _mergeRecords([
        _memoryEmotionRecords,
        prefsRecords,
        backupRecords,
      ]);
      _memoryEmotionRecords = merged;
      return merged;
    }

    var fileRecords = <Map<String, dynamic>>[];
    try {
      fileRecords = await file_storage.readEmotionRecords();
    } catch (e) {
      debugPrint('getEmotionRecords (file) error: $e');
    }

    final merged = _mergeRecords([
      _memoryEmotionRecords,
      fileRecords,
      prefsRecords,
      backupRecords,
    ]);
    _memoryEmotionRecords = merged;

    // 文件/备份任一路短暂丢数据时，读到合并结果后立即回填，避免统计页下一次再空。
    if (merged.isNotEmpty) {
      unawaited(_persistEmotionRecordBackup(merged));
      if (!kIsWeb) {
        unawaited(_persistEmotionRecordFile(merged));
      }
    }
    return merged;
  }

  Future<List<Map<String, dynamic>>> _getEmotionRecordsFromPrefs(
    String key,
  ) async {
    final p = await prefs;
    final String? data = p.getString(key);
    if (data == null || data.isEmpty) return [];
    try {
      final List<dynamic> decoded = jsonDecode(data);
      final list = decoded.map((e) => Map<String, dynamic>.from(e)).toList();
      return _normalizeRecords(list);
    } catch (e) {
      return [];
    }
  }

  Future<void> _migrateFromSharedPreferences() async {
    _migratedFromPrefs = true;
    if (kIsWeb) return;
    try {
      final p = await prefs;
      final String? data = p.getString(_moodRecordsKey);
      if (data != null && data.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(data);
        final list = decoded.map((e) => Map<String, dynamic>.from(e)).toList();
        if (list.isNotEmpty) {
          await file_storage.writeEmotionRecords(list);
          await p.setString(_moodRecordsBackupKey, jsonEncode(list));
          await p.remove(_moodRecordsKey);
        }
      }
    } catch (_) {}
  }

  Future<void> _writeRecords(List<Map<String, dynamic>> records) async {
    final normalized = _normalizeRecords(records);
    _memoryEmotionRecords = normalized;
    if (kIsWeb) {
      await _persistEmotionRecordPrefs(_moodRecordsKey, normalized);
      return;
    }
    await _persistEmotionRecordBackup(normalized);
    await _persistEmotionRecordFile(normalized);
  }

  Future<void> _persistEmotionRecordPrefs(
    String key,
    List<Map<String, dynamic>> records,
  ) async {
    final p = await prefs;
    final ok = await p.setString(key, jsonEncode(_normalizeRecords(records)));
    if (!ok) throw Exception('SharedPreferences 写入失败');
  }

  Future<void> _persistEmotionRecordBackup(
    List<Map<String, dynamic>> records,
  ) async {
    try {
      await _persistEmotionRecordPrefs(_moodRecordsBackupKey, records);
    } catch (e) {
      debugPrint('persist mood records backup error: $e');
    }
  }

  Future<void> _persistEmotionRecordFile(
    List<Map<String, dynamic>> records,
  ) async {
    try {
      await file_storage.writeEmotionRecords(_normalizeRecords(records));
    } catch (e) {
      debugPrint('persist mood records file error: $e');
    }
  }

  List<Map<String, dynamic>> _mergeRecords(
    List<List<Map<String, dynamic>>> sources,
  ) {
    final byId = <String, Map<String, dynamic>>{};
    for (final source in sources) {
      for (final record in _normalizeRecords(source)) {
        final id = record['id']?.toString();
        if (id == null || id.isEmpty) continue;
        byId[id] = record;
      }
    }
    return _normalizeRecords(byId.values.toList());
  }

  List<Map<String, dynamic>> _normalizeRecords(
    List<Map<String, dynamic>> records,
  ) {
    final valid = records
        .where((r) {
          try {
            return r['id'] != null && r['createdAt'] != null;
          } catch (_) {
            return false;
          }
        })
        .map((r) => Map<String, dynamic>.from(r))
        .toList();
    valid.sort((a, b) {
      final tA = _parseRecordTime(a);
      final tB = _parseRecordTime(b);
      return tB.compareTo(tA);
    });
    return valid;
  }

  static DateTime _parseRecordTime(Map<String, dynamic> r) {
    try {
      final v = r['createdAt'];
      if (v == null) return DateTime(0);
      if (v is DateTime) return v;
      return DateTime.parse(v.toString());
    } catch (_) {
      return DateTime(0);
    }
  }

  Future<void> deleteEmotionRecord(String id) async {
    final records = await getEmotionRecords();
    records.removeWhere((r) => r['id'] == id);
    await _writeRecords(records);
  }

  Future<void> updateEmotionRecord(Map<String, dynamic> updatedRecord) async {
    final records = await getEmotionRecords();
    final index = records.indexWhere((r) => r['id'] == updatedRecord['id']);
    if (index != -1) {
      records[index] = updatedRecord;
      await _writeRecords(records);
    }
  }

  Future<Map<String, int>> getMoodCounts() async {
    final records = await getEmotionRecords();
    Map<String, int> counts = {};
    for (var record in records) {
      String mood = record['mood'] ?? '未知';
      counts[mood] = (counts[mood] ?? 0) + 1;
    }
    return counts;
  }

  // 设置操作
  Future<Map<String, dynamic>?> getSettings() async {
    final p = await prefs;
    final String? data = p.getString('app_settings');
    if (data == null || data.isEmpty) {
      return {
        'id': 1,
        'darkMode': 0,
        'notificationsEnabled': 0,
        'reminderHour': 20,
        'reminderMinute': 0,
        'appLockEnabled': 0,
        'appLockPin': '',
        'lockTimeoutSeconds': 300,
        'cycleMoodAnalysisEnabled': 0,
      };
    }
    try {
      return Map<String, dynamic>.from(jsonDecode(data));
    } catch (e) {
      return {
        'id': 1,
        'darkMode': 0,
        'notificationsEnabled': 0,
        'reminderHour': 20,
        'reminderMinute': 0,
        'appLockEnabled': 0,
        'appLockPin': '',
        'lockTimeoutSeconds': 300,
        'cycleMoodAnalysisEnabled': 0,
      };
    }
  }

  Future<void> updateSettings(Map<String, dynamic> settings) async {
    final p = await prefs;
    await p.setString('app_settings', jsonEncode(settings));
  }

  Future<List<String>> getCustomEmotions() async {
    final p = await prefs;
    final data = p.getString('custom_emotions');
    if (data == null || data.isEmpty) return [];
    try {
      final list = jsonDecode(data) as List<dynamic>;
      return list
          .map((e) => e.toString().trim())
          .where((s) => s.isNotEmpty)
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveCustomEmotions(List<String> emotions) async {
    final p = await prefs;
    await p.setString('custom_emotions', jsonEncode(emotions));
  }

  /// 情绪小测试结果：保存与读取（仅用 SharedPreferences，与心情记录分离）
  static const String _testResultsKey = 'emotion_test_results';
  static const int _maxTestResults = 50;

  Future<List<Map<String, dynamic>>> getTestResults() async {
    final p = await prefs;
    final data = p.getString(_testResultsKey);
    if (data == null || data.isEmpty) return [];
    try {
      final list = jsonDecode(data) as List<dynamic>;
      return list.map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> addTestResult(Map<String, dynamic> result) async {
    final list = await getTestResults();
    list.insert(0, result);
    if (list.length > _maxTestResults) list.length = _maxTestResults;
    final p = await prefs;
    await p.setString(_testResultsKey, jsonEncode(list));
  }

  Future<void> deleteTestResult({
    required String assessmentId,
    required DateTime createdAt,
  }) async {
    final list = await getTestResults();
    final targetMillis = createdAt.millisecondsSinceEpoch;

    final index = list.indexWhere((item) {
      final itemId =
          item['assessmentId']?.toString() ??
          item['testName']?.toString() ??
          '';
      final itemCreatedAt = DateTime.tryParse(
        item['createdAt']?.toString() ?? '',
      );
      if (itemCreatedAt == null) return false;
      return itemId == assessmentId &&
          itemCreatedAt.millisecondsSinceEpoch == targetMillis;
    });

    if (index != -1) {
      list.removeAt(index);
      final p = await prefs;
      await p.setString(_testResultsKey, jsonEncode(list));
    }
  }

  /// 通用数据存储方法
  Future<dynamic> getData(String key) async {
    final p = await prefs;
    final data = p.getString(key);
    if (data == null || data.isEmpty) return null;
    try {
      return jsonDecode(data);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveData(String key, dynamic data) async {
    final p = await prefs;
    await p.setString(key, jsonEncode(data));
  }

  Future<void> removeData(String key) async {
    final p = await prefs;
    await p.remove(key);
  }

  Future<Map<String, dynamic>> getDataEntriesByPrefix(String prefix) async {
    final p = await prefs;
    final matched = <String, dynamic>{};
    for (final key in p.getKeys()) {
      if (!key.startsWith(prefix)) continue;
      final data = p.getString(key);
      if (data == null || data.isEmpty) continue;
      try {
        matched[key] = jsonDecode(data);
      } catch (_) {}
    }
    return matched;
  }
}
