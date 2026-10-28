import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

// --- 数据模型 ---
class DailyHealthRecord {
  final String dateStr; // e.g., '2023-10-27'
  
  // 原有打卡数据
  final int waterMl;
  final String mood; // '开心', '平静', '焦虑', '压力' 等
  final int poopCount;
  final int sleepMins;
  final int dietCalories;
  
  // 新增 OtterLife 对齐数据
  final int goalCompleted; // 完成的目标数
  final int hrv; // 心率变异性，单位 毫秒 (e.g., 39)
  final int bloodOxygen; // 血氧，单位 % (e.g., 99)
  final String stressLevel; // 压力等级

  DailyHealthRecord({
    required this.dateStr,
    this.waterMl = 0,
    this.mood = '平静',
    this.poopCount = 0,
    this.sleepMins = 0,
    this.dietCalories = 0,
    this.goalCompleted = 0,
    this.hrv = 39,
    this.bloodOxygen = 99,
    this.stressLevel = '适中',
  });

  DailyHealthRecord copyWith({
    String? dateStr,
    int? waterMl,
    String? mood,
    int? poopCount,
    int? sleepMins,
    int? dietCalories,
    int? goalCompleted,
    int? hrv,
    int? bloodOxygen,
    String? stressLevel,
  }) {
    return DailyHealthRecord(
      dateStr: dateStr ?? this.dateStr,
      waterMl: waterMl ?? this.waterMl,
      mood: mood ?? this.mood,
      poopCount: poopCount ?? this.poopCount,
      sleepMins: sleepMins ?? this.sleepMins,
      dietCalories: dietCalories ?? this.dietCalories,
      goalCompleted: goalCompleted ?? this.goalCompleted,
      hrv: hrv ?? this.hrv,
      bloodOxygen: bloodOxygen ?? this.bloodOxygen,
      stressLevel: stressLevel ?? this.stressLevel,
    );
  }

  Map<String, dynamic> toJson() => {
    'dateStr': dateStr,
    'waterMl': waterMl,
    'mood': mood,
    'poopCount': poopCount,
    'sleepMins': sleepMins,
    'dietCalories': dietCalories,
    'goalCompleted': goalCompleted,
    'hrv': hrv,
    'bloodOxygen': bloodOxygen,
    'stressLevel': stressLevel,
  };

  factory DailyHealthRecord.fromJson(Map<String, dynamic> json) {
    return DailyHealthRecord(
      dateStr: json['dateStr'] ?? '',
      waterMl: json['waterMl'] ?? 0,
      mood: json['mood'] ?? '平静',
      poopCount: json['poopCount'] ?? 0,
      sleepMins: json['sleepMins'] ?? 0,
      dietCalories: json['dietCalories'] ?? 0,
      goalCompleted: json['goalCompleted'] ?? 0,
      hrv: json['hrv'] ?? 39,
      bloodOxygen: json['bloodOxygen'] ?? 99,
      stressLevel: json['stressLevel'] ?? '适中',
    );
  }
}

// --- Provider ---
final dailyHealthProvider = StateNotifierProvider<DailyHealthNotifier, AsyncValue<DailyHealthRecord>>((ref) {
  return DailyHealthNotifier();
});

class DailyHealthNotifier extends StateNotifier<AsyncValue<DailyHealthRecord>> {
  DailyHealthNotifier() : super(const AsyncValue.loading()) {
    _loadTodayRecord();
  }

  String get _todayStr => DateFormat('yyyy-MM-dd').format(DateTime.now());
  String get _prefKey => 'health_record_$_todayStr';

  Future<void> _loadTodayRecord() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_prefKey);
      if (jsonStr != null) {
        final record = DailyHealthRecord.fromJson(jsonDecode(jsonStr));
        state = AsyncValue.data(record);
      } else {
        // Create new record for today
        state = AsyncValue.data(DailyHealthRecord(dateStr: _todayStr));
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> _saveRecord(DailyHealthRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, jsonEncode(record.toJson()));
    state = AsyncValue.data(record);
  }

  // --- 更新操作 ---

  Future<void> addWater(int amount) async {
    if (state.valueOrNull == null) return;
    final current = state.value!;
    final updated = current.copyWith(waterMl: current.waterMl + amount);
    await _saveRecord(updated);
  }

  Future<void> setMood(String newMood) async {
    if (state.valueOrNull == null) return;
    final current = state.value!;
    final updated = current.copyWith(mood: newMood);
    await _saveRecord(updated);
  }
  
  Future<void> setStressLevel(String newStress) async {
    if (state.valueOrNull == null) return;
    final current = state.value!;
    final updated = current.copyWith(stressLevel: newStress);
    await _saveRecord(updated);
  }

  Future<void> addPoop() async {
    if (state.valueOrNull == null) return;
    final current = state.value!;
    final updated = current.copyWith(poopCount: current.poopCount + 1);
    await _saveRecord(updated);
  }

  Future<void> setSleep(int mins) async {
    if (state.valueOrNull == null) return;
    final current = state.value!;
    final updated = current.copyWith(sleepMins: mins);
    await _saveRecord(updated);
  }

  Future<void> addCalories(int amount) async {
    if (state.valueOrNull == null) return;
    final current = state.value!;
    final updated = current.copyWith(dietCalories: current.dietCalories + amount);
    await _saveRecord(updated);
  }
  
  Future<void> incrementGoal() async {
    if (state.valueOrNull == null) return;
    final current = state.value!;
    final updated = current.copyWith(goalCompleted: (current.goalCompleted + 1).clamp(0, 4));
    await _saveRecord(updated);
  }

  Future<void> updateHrv(int hrv) async {
    if (state.valueOrNull == null) return;
    final current = state.value!;
    final updated = current.copyWith(hrv: hrv);
    await _saveRecord(updated);
  }

  Future<void> updateBloodOxygen(int spo2) async {
    if (state.valueOrNull == null) return;
    final current = state.value!;
    final updated = current.copyWith(bloodOxygen: spo2);
    await _saveRecord(updated);
  }
}
