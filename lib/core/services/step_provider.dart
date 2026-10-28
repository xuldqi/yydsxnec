import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import '../../core/services/database_provider.dart';
import '../../core/services/health_providers.dart';
import '../../core/services/foreground_task_handler.dart';

/// 今日步数状态
class StepState {
  final int todaySteps;
  final int goal;
  final double calories;
  final double distanceKm;
  final bool isAvailable;

  const StepState({
    this.todaySteps = 0,
    this.goal = 10000,
    this.calories = 0,
    this.distanceKm = 0,
    this.isAvailable = true,
  });

  double get progress => (todaySteps / goal).clamp(0.0, 1.0);
  int get remaining => (goal - todaySteps).clamp(0, goal);

  StepState copyWith({
    int? todaySteps,
    int? goal,
    double? calories,
    double? distanceKm,
    bool? isAvailable,
  }) {
    return StepState(
      todaySteps: todaySteps ?? this.todaySteps,
      goal: goal ?? this.goal,
      calories: calories ?? this.calories,
      distanceKm: distanceKm ?? this.distanceKm,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}

/// 步数 Provider（核心计步逻辑）
class StepNotifier extends AsyncNotifier<StepState> {
  StreamSubscription<StepCount>? _stepSubscription;
  StreamSubscription<PedestrianStatus>? _statusSubscription;

  // 系统累计步数基准（每天0点重置时记录的系统步数）
  int _baseStepCount = 0;
  // 当前系统累计步数
  int _currentSystemSteps = 0;

  static const _keyBase = 'step_base_';
  static const _keyDate = 'step_base_date';
  static const _keyGoal = 'step_goal';

  @override
  Future<StepState> build() async {
    ref.onDispose(() {
      _stepSubscription?.cancel();
      _statusSubscription?.cancel();
    });

    final selectedDate = ref.watch(selectedDateProvider);
    final now = DateTime.now();
    final isToday = selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day;
        
    final goal = await _loadGoal();

    if (isToday) {
      await _initBase();
      _startListening();
      return StepState(goal: goal, todaySteps: _currentSystemSteps > 0 ? (_currentSystemSteps - _baseStepCount).clamp(0, 99999) : 0);
    } else {
      // Historical date
      _stepSubscription?.cancel();
      _statusSubscription?.cancel();
      final db = ref.read(databaseProvider);
      final record = await db.getStepCountByDate(selectedDate);
      final steps = record?.stepsNum ?? 0;
      final calories = double.tryParse(record?.cal ?? '0') ?? 0;
      return StepState(
        goal: goal,
        todaySteps: steps,
        calories: calories,
        distanceKm: _calcDistance(steps),
        isAvailable: false, // Don't show live pedometer status for past dates
      );
    }
  }

  /// 初始化今日步数基准
  Future<void> _initBase() async {
    final prefs = await SharedPreferences.getInstance();
    final today = _dateKey(DateTime.now());
    final savedDate = prefs.getString(_keyDate) ?? '';

    if (savedDate != today) {
      // 新的一天，重置基准（等第一个步数事件来时再记录）
      _baseStepCount = -1; // -1 表示还未初始化
      await prefs.setString(_keyDate, today);
    } else {
      _baseStepCount = prefs.getInt('$_keyBase$today') ?? -1;
    }
  }

  /// 开始监听传感器
  Future<void> _startListening() async {
    final isMobile = !kIsWeb && (Platform.isIOS || Platform.isAndroid);
    if (!isMobile) {
      Stream.periodic(const Duration(seconds: 3), (i) => 4500 + i * 10).listen((steps) {
        _processSteps(steps);
      });
      return;
    }

    if (Platform.isAndroid) {
      if (await Permission.activityRecognition.request().isGranted) {
        // Also request notification permission for foreground service
        await Permission.notification.request();

        ForegroundTaskService.init();
        await ForegroundTaskService.startService();

        FlutterForegroundTask.addTaskDataCallback((data) {
          if (data is int) {
            _processStepsDirectly(data);
          }
        });
      } else {
        _setUnavailable();
      }
    } else {
      // iOS fallback
      try {
        _stepSubscription = Pedometer.stepCountStream.listen(
          (event) => _processSteps(event.steps),
          onError: (_) => _setUnavailable(),
          cancelOnError: false,
        );
      } catch (_) {
        _setUnavailable();
      }
    }
  }

  void _processStepsDirectly(int todaySteps) async {
    final selectedDate = ref.read(selectedDateProvider);
    final now = DateTime.now();
    final isToday = selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day;

    final calories = _calcCalories(todaySteps);
    
    try {
      final db = ref.read(databaseProvider);
      await db.saveDailySteps(todaySteps, calories);
    } catch (_) {}

    if (isToday) {
      final current = state.valueOrNull ?? const StepState();
      state = AsyncData(current.copyWith(
        todaySteps: todaySteps,
        calories: calories,
        distanceKm: _calcDistance(todaySteps),
        isAvailable: true,
      ));
    }
  }

  void _processSteps(int steps) async {
    final selectedDate = ref.read(selectedDateProvider);
    final now = DateTime.now();
    final isToday = selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day;
        
    _currentSystemSteps = steps;

    // 首次获取步数，记录基准
    if (_baseStepCount == -1) {
      _baseStepCount = _currentSystemSteps;
      final prefs = await SharedPreferences.getInstance();
      final today = _dateKey(DateTime.now());
      await prefs.setInt('$_keyBase$today', _baseStepCount);
    }

    final todaySteps = (_currentSystemSteps - _baseStepCount).clamp(0, 99999);
    final calories = _calcCalories(todaySteps);
    
    // 同步到 SQLite 数据库
    try {
      final db = ref.read(databaseProvider);
      await db.saveDailySteps(todaySteps, calories);
    } catch (_) {
      // 忽略数据库保存错误，不阻塞主流程
    }

    // Only update state if we are currently looking at today
    if (isToday) {
      final current = state.valueOrNull ?? const StepState();
      state = AsyncData(current.copyWith(
        todaySteps: todaySteps,
        calories: calories,
        distanceKm: _calcDistance(todaySteps),
        isAvailable: true,
      ));
    }
  }

  void _setUnavailable() {
    state = AsyncData((state.valueOrNull ?? const StepState())
        .copyWith(isAvailable: false));
  }

  /// 设置每日目标
  Future<void> setGoal(int goal) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyGoal, goal);
    final current = state.valueOrNull ?? const StepState();
    state = AsyncData(current.copyWith(goal: goal));
  }

  Future<int> _loadGoal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyGoal) ?? 10000;
  }

  /// 卡路里计算（体重70kg，步行MET≈3.5）
  double _calcCalories(int steps) => steps * 0.04;

  /// 距离计算（步长约0.7m）
  double _calcDistance(int steps) => steps * 0.0007;

  String _dateKey(DateTime d) => '${d.year}-${d.month}-${d.day}';
}

final stepProvider = AsyncNotifierProvider<StepNotifier, StepState>(
  StepNotifier.new,
);
