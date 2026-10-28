import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weight_log.dart';

class WeightStorageService {
  static const String _weightLogsKey = 'weight_logs';
  SharedPreferences? _prefs;

  Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<List<WeightLog>> getWeightLogs() async {
    final p = await prefs;
    final String? data = p.getString(_weightLogsKey);
    if (data == null) return [];
    try {
      final List<dynamic> list = jsonDecode(data) as List<dynamic>;
      return list.map((item) => WeightLog.fromMap(item as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveWeightLog(WeightLog log) async {
    final list = await getWeightLogs();
    list.insert(0, log);
    await _saveList(list);
  }

  Future<void> updateWeightLog(WeightLog log) async {
    final list = await getWeightLogs();
    final idx = list.indexWhere((item) => item.id == log.id);
    if (idx != -1) {
      list[idx] = log;
      await _saveList(list);
    }
  }

  Future<void> deleteWeightLog(String id) async {
    final list = await getWeightLogs();
    list.removeWhere((item) => item.id == id);
    await _saveList(list);
  }

  Future<void> _saveList(List<WeightLog> list) async {
    final p = await prefs;
    final String data = jsonEncode(list.map((item) => item.toMap()).toList());
    await p.setString(_weightLogsKey, data);
  }
}
