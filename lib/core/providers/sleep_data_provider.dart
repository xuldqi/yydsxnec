import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/audio_monitor_service.dart';
import '../services/movement_monitor_service.dart';

class SleepDataPoint {
  final DateTime time;
  final String phase; // 'Awake', 'REM', 'Light', 'Deep'

  SleepDataPoint(this.time, this.phase);

  Map<String, dynamic> toJson() => {
    'time': time.toIso8601String(),
    'phase': phase,
  };

  factory SleepDataPoint.fromJson(Map<String, dynamic> json) =>
      SleepDataPoint(DateTime.parse(json['time']), json['phase']);
}

class SleepSession {
  final List<SleepDataPoint> dataPoints;
  final List<String> snoreSnippets;
  final int snoreMinutes;
  final List<String> tags;

  SleepSession({
    required this.dataPoints,
    this.snoreSnippets = const [],
    this.snoreMinutes = 0,
    this.tags = const [],
  });

  Map<String, dynamic> toJson() => {
    'dataPoints': dataPoints.map((dp) => dp.toJson()).toList(),
    'snoreSnippets': snoreSnippets,
    'snoreMinutes': snoreMinutes,
    'tags': tags,
  };

  factory SleepSession.fromJson(Map<String, dynamic> json) => SleepSession(
    dataPoints: (json['dataPoints'] as List)
        .map((e) => SleepDataPoint.fromJson(e))
        .toList(),
    snoreSnippets:
        (json['snoreSnippets'] as List?)?.map((e) => e as String).toList() ??
        [],
    snoreMinutes: json['snoreMinutes'] ?? 0,
    tags: (json['tags'] as List?)?.map((e) => e as String).toList() ?? [],
  );

  Duration get duration {
    if (dataPoints.isEmpty) return Duration.zero;
    return dataPoints.last.time.difference(dataPoints.first.time);
  }
}

class SleepDataProvider with ChangeNotifier {
  List<SleepDataPoint> _recentSleepData = [];
  List<SleepSession> _history = [];
  bool _isDemoHistory = false;

  // Forest Growth System State
  int _forestLevel = 1;
  int _forestExp = 0;

  // Settings
  int _targetSleepHours = 7;
  int _targetSleepMinutes = 30;
  int _suggestedBedTimeHour = 23;
  int _suggestedBedTimeMinute = 30;
  int _bedTimeReminderMinutes = 30; // 0 means disabled

  List<SleepDataPoint> get recentSleepData => _recentSleepData;
  List<SleepSession> get history => _history;
  bool get isDemoHistory => _isDemoHistory;
  int get forestLevel => _forestLevel;
  int get forestExp => _forestExp;

  int get targetSleepHours => _targetSleepHours;
  int get targetSleepMinutes => _targetSleepMinutes;
  int get suggestedBedTimeHour => _suggestedBedTimeHour;
  int get suggestedBedTimeMinute => _suggestedBedTimeMinute;
  int get bedTimeReminderMinutes => _bedTimeReminderMinutes;

  int get expForNextLevel => _forestLevel * 100;

  SleepDataProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _forestLevel = prefs.getInt('forestLevel') ?? 1;
    _forestExp = prefs.getInt('forestExp') ?? 0;

    _targetSleepHours = prefs.getInt('targetSleepHours') ?? 7;
    _targetSleepMinutes = prefs.getInt('targetSleepMinutes') ?? 30;
    _suggestedBedTimeHour = prefs.getInt('suggestedBedTimeHour') ?? 23;
    _suggestedBedTimeMinute = prefs.getInt('suggestedBedTimeMinute') ?? 30;
    _bedTimeReminderMinutes = prefs.getInt('bedTimeReminderMinutes') ?? 30;
    _isDemoHistory = prefs.getBool('isDemoHistory') ?? false;

    final historyStr = prefs.getString('sleepHistory');
    if (historyStr != null) {
      try {
        final List decoded = jsonDecode(historyStr);
        _history = decoded.map((e) => SleepSession.fromJson(e)).toList();
        // Discard corrupt history with unrealistic >16h sleep times
        if (_history.any((s) => s.duration.inHours > 16)) {
          _history.clear();
          _isDemoHistory = false;
        }
        if (_history.isNotEmpty) {
          _recentSleepData = _history.last.dataPoints;
        }
      } catch (e) {
        debugPrint("Error loading sleep data: $e");
        _isDemoHistory = false;
      }
    } else {
      // History is empty, generate realistic demo data for initial presentation
      _generateDemoHistory();
      _isDemoHistory = true;
      await _saveData();
    }
    notifyListeners();
  }

  void _generateDemoHistory() {
    final random = Random();
    final now = DateTime.now();

    for (int d = 14; d >= 1; d--) {
      final date = now.subtract(Duration(days: d));
      // Start sleep at around 23:00 - 00:30
      final startHour = random.nextBool() ? 23 : 0;
      final startMin = random.nextInt(60);
      final startTime = DateTime(
        date.year,
        date.month,
        date.day,
        startHour,
        startMin,
      );

      // End sleep at around 06:30 - 08:30 the next morning
      final wakeDate = startHour == 23
          ? date.add(const Duration(days: 1))
          : date;
      final endHour = 6 + random.nextInt(3); // 6, 7, 8
      final endMin = random.nextInt(60);
      final endTime = DateTime(
        wakeDate.year,
        wakeDate.month,
        wakeDate.day,
        endHour,
        endMin,
      );

      // Generate some pre-sleep tags
      List<String> tags = [];
      if (random.nextDouble() < 0.4) tags.add('caffeine');
      if (random.nextDouble() < 0.25) tags.add('alcohol');
      if (random.nextDouble() < 0.4) tags.add('exercise');
      if (random.nextDouble() < 0.3) tags.add('late_meal');
      if (random.nextDouble() < 0.5) tags.add('screen_time');
      if (random.nextDouble() < 0.3) tags.add('meditation');

      // Calculate sleep score impact based on tags
      double scoreBase = 75.0 + random.nextInt(15); // 75 - 90
      if (tags.contains('caffeine')) scoreBase -= 8;
      if (tags.contains('alcohol')) scoreBase -= 10;
      if (tags.contains('late_meal')) scoreBase -= 5;
      if (tags.contains('screen_time')) scoreBase -= 6;
      if (tags.contains('exercise')) scoreBase += 5;
      if (tags.contains('meditation')) scoreBase += 6;
      scoreBase = scoreBase.clamp(45, 98);

      // Generate sleep phases based on the score
      final List<SleepDataPoint> points = [];
      final totalMinutes = endTime.difference(startTime).inMinutes;
      final pointCount = totalMinutes ~/ 15;

      for (int i = 0; i <= pointCount; i++) {
        final pointTime = startTime.add(Duration(minutes: i * 15));
        String phase;
        final cyclePosition = i % 6; // 90 min cycles (6 * 15m = 90m)

        if (i == 0 || i == pointCount) {
          phase = 'Awake';
        } else {
          switch (cyclePosition) {
            case 0:
              phase = scoreBase > 75 ? 'Deep' : 'Light';
              break;
            case 1:
              phase = 'Light';
              break;
            case 2:
              phase = 'REM';
              break;
            case 3:
              phase = scoreBase > 65 ? 'Deep' : 'Awake';
              break;
            case 4:
              phase = 'Light';
              break;
            case 5:
              phase = 'REM';
              break;
            default:
              phase = 'Light';
          }
        }
        points.add(SleepDataPoint(pointTime, phase));
      }

      final List<String> snippets = [];

      _history.add(
        SleepSession(
          dataPoints: points,
          snoreSnippets: snippets,
          snoreMinutes: snippets.length * 5 ~/ 60,
          tags: tags,
        ),
      );

      _addExp(totalMinutes);
    }

    if (_history.isNotEmpty) {
      _recentSleepData = _history.last.dataPoints;
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('forestLevel', _forestLevel);
    await prefs.setInt('forestExp', _forestExp);

    await prefs.setInt('targetSleepHours', _targetSleepHours);
    await prefs.setInt('targetSleepMinutes', _targetSleepMinutes);
    await prefs.setInt('suggestedBedTimeHour', _suggestedBedTimeHour);
    await prefs.setInt('suggestedBedTimeMinute', _suggestedBedTimeMinute);
    await prefs.setInt('bedTimeReminderMinutes', _bedTimeReminderMinutes);
    await prefs.setBool('isDemoHistory', _isDemoHistory);

    final historyStr = jsonEncode(_history.map((e) => e.toJson()).toList());
    await prefs.setString('sleepHistory', historyStr);
  }

  Future<void> updateSettings({
    int? targetHours,
    int? targetMinutes,
    int? bedTimeHour,
    int? bedTimeMinute,
    int? reminderMinutes,
  }) async {
    if (targetHours != null) _targetSleepHours = targetHours;
    if (targetMinutes != null) _targetSleepMinutes = targetMinutes;
    if (bedTimeHour != null) _suggestedBedTimeHour = bedTimeHour;
    if (bedTimeMinute != null) _suggestedBedTimeMinute = bedTimeMinute;
    if (reminderMinutes != null) _bedTimeReminderMinutes = reminderMinutes;

    await _saveData();
    notifyListeners();
  }

  /// Finishes the sleep session using real data from the monitors
  Future<void> finishSleepSession(
    SnoreSnippetSource audioService,
    SleepPhaseSource movementService, {
    List<String> tags = const [],
  }) async {
    if (_isDemoHistory) {
      _history.clear();
      _isDemoHistory = false;
    }
    _recentSleepData.clear();

    final startTime =
        movementService.startTime ??
        DateTime.now().subtract(const Duration(hours: 8));
    final phases = movementService.sleepPhases;

    DateTime currentTime = startTime;
    if (phases.isEmpty) {
      // Fallback if stopped immediately
      _recentSleepData.add(SleepDataPoint(currentTime, 'Awake'));
    } else {
      final sampleInterval = movementService.sampleInterval;
      for (final phase in phases) {
        _recentSleepData.add(SleepDataPoint(currentTime, phase));
        currentTime = currentTime.add(sampleInterval);
      }
    }

    // Get snippets from AudioMonitorService
    final snippets = audioService.snippets;
    final snippetPaths = snippets.map((e) => e.path).toList();

    // Add to history
    _history.add(
      SleepSession(
        dataPoints: List.from(_recentSleepData),
        snoreSnippets: snippetPaths,
        snoreMinutes: snippets.length * 5 ~/ 60, // Rough estimate
        tags: tags,
      ),
    );

    // EXP is based on duration
    int totalMinutesSlept = totalSleepDuration.inMinutes;
    _addExp(totalMinutesSlept);

    await _saveData();
    notifyListeners();
  }

  /// Adds EXP based on sleep duration
  void _addExp(int minutesSlept) {
    int expGained = minutesSlept * 2;
    _forestExp += expGained;

    while (_forestExp >= expForNextLevel) {
      _forestExp -= expForNextLevel;
      _forestLevel++;
    }
  }

  List<DateTime> calculateOptimalWakeTimes(
    DateTime bedTime,
    int cyclesToCalculate,
  ) {
    List<DateTime> optimalTimes = [];
    DateTime sleepOnset = bedTime.add(const Duration(minutes: 14));
    for (int i = 1; i <= cyclesToCalculate; i++) {
      optimalTimes.add(sleepOnset.add(Duration(minutes: 90 * i)));
    }
    return optimalTimes;
  }

  Duration get totalSleepDuration {
    if (_recentSleepData.isEmpty) return Duration.zero;
    return _recentSleepData.last.time.difference(_recentSleepData.first.time);
  }

  int get sleepScore {
    if (_recentSleepData.isEmpty) return 0;
    int deepSec = getPhaseDuration('Deep').inSeconds;
    int awakeSec = getPhaseDuration('Awake').inSeconds;
    int totalSec = totalSleepDuration.inSeconds;
    if (totalSec == 0) return 0;

    double score = 70 + (deepSec / totalSec * 50) - (awakeSec / totalSec * 30);
    return score.clamp(0, 100).toInt();
  }

  Duration getPhaseDuration(String targetPhase) {
    if (_recentSleepData.isEmpty) return Duration.zero;
    int totalSeconds = 0;
    for (int i = 0; i < _recentSleepData.length - 1; i++) {
      if (_recentSleepData[i].phase == targetPhase) {
        totalSeconds += _recentSleepData[i + 1].time
            .difference(_recentSleepData[i].time)
            .inSeconds;
      }
    }
    return Duration(seconds: totalSeconds);
  }
}
