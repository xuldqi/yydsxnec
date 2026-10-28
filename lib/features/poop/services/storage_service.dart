import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/poop_log.dart';

class PoopStorageService {
  static const String _poopLogsKey = 'poop_logs';
  SharedPreferences? _prefs;

  Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<List<PoopLog>> getPoopLogs() async {
    final p = await prefs;
    final String? data = p.getString(_poopLogsKey);
    if (data == null) return [];
    try {
      final List<dynamic> list = jsonDecode(data) as List<dynamic>;
      return list.map((item) => PoopLog.fromMap(item as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> savePoopLog(PoopLog log) async {
    final list = await getPoopLogs();
    list.insert(0, log);
    await _saveList(list);
  }

  Future<void> updatePoopLog(PoopLog log) async {
    final list = await getPoopLogs();
    final idx = list.indexWhere((item) => item.id == log.id);
    if (idx != -1) {
      list[idx] = log;
      await _saveList(list);
    }
  }

  Future<void> deletePoopLog(String id) async {
    final list = await getPoopLogs();
    list.removeWhere((item) => item.id == id);
    await _saveList(list);
  }

  Future<void> _saveList(List<PoopLog> list) async {
    final p = await prefs;
    final String data = jsonEncode(list.map((item) => item.toMap()).toList());
    await p.setString(_poopLogsKey, data);
  }
}
