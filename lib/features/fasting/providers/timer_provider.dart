import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/fasting_session.dart';
import '../core/constants/app_constants.dart';
import 'fasting_provider.dart';

// 实时计时器数据模型
class FastingTimerData {
  final Duration elapsedTime;
  final Duration remainingTime;
  final double progressPercentage;
  final bool isActive;
  final bool isOvertime;
  final bool isEatingWindow;
  final DateTime? startTime;
  final DateTime? plannedEndTime;
  final Duration? remainingEatingWindow;

  const FastingTimerData({
    required this.elapsedTime,
    required this.remainingTime,
    required this.progressPercentage,
    required this.isActive,
    required this.isOvertime,
    required this.isEatingWindow,
    this.startTime,
    this.plannedEndTime,
    this.remainingEatingWindow,
  });

  factory FastingTimerData.empty() {
    return const FastingTimerData(
      elapsedTime: Duration.zero,
      remainingTime: Duration.zero,
      progressPercentage: 0.0,
      isActive: false,
      isOvertime: false,
      isEatingWindow: false,
    );
  }

  factory FastingTimerData.fromSession(FastingSession session) {
    final now = DateTime.now();
    final elapsedDuration = now.difference(session.startTime);
    final plannedEndTime =
        session.plannedEndTime ??
        session.startTime.add(Duration(hours: session.fastingHours));
    final eatingWindowEnd = plannedEndTime.add(
      Duration(hours: session.eatingHours),
    );
    final plannedDuration = plannedEndTime.difference(session.startTime);
    final remainingDuration = plannedEndTime.difference(now);

    final progressPercentage =
        (elapsedDuration.inSeconds / plannedDuration.inSeconds * 100).clamp(
          0.0,
          100.0,
        );

    final isOvertime = now.isAfter(plannedEndTime);
    final isEatingWindow =
        now.isAfter(plannedEndTime) && now.isBefore(eatingWindowEnd);
    final Duration? remainingEatingWindow = isEatingWindow
        ? eatingWindowEnd.difference(now)
        : null;

    return FastingTimerData(
      elapsedTime: elapsedDuration,
      remainingTime: remainingDuration.isNegative
          ? Duration.zero
          : remainingDuration,
      progressPercentage: progressPercentage,
      isActive: session.status == FastingStatus.active,
      isOvertime: isOvertime,
      isEatingWindow: isEatingWindow,
      startTime: session.startTime,
      plannedEndTime: plannedEndTime,
      remainingEatingWindow: remainingEatingWindow,
    );
  }

  String get elapsedTimeFormatted {
    final hours = elapsedTime.inHours;
    final minutes = elapsedTime.inMinutes.remainder(60);
    final seconds = elapsedTime.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  String get remainingTimeFormatted {
    if (isEatingWindow) {
      return '进食窗口';
    }
    if (isOvertime || remainingTime.inSeconds <= 0) {
      return '断食完成';
    }

    final hours = remainingTime.inHours;
    final minutes = remainingTime.inMinutes.remainder(60);

    if (hours > 0) {
      return '$hours小时$minutes分钟';
    } else {
      return '$minutes分钟';
    }
  }

  String get progressText {
    if (isEatingWindow) {
      return '正在进食窗口';
    } else if (isOvertime) {
      return '断食已完成，等待结束';
    } else if (progressPercentage >= 100) {
      return '目标已达成';
    } else {
      return '进度 ${progressPercentage.toStringAsFixed(1)}%';
    }
  }
}

// 实时计时器Provider
final fastingTimerProvider =
    StateNotifierProvider<FastingTimerNotifier, FastingTimerData>((ref) {
      return FastingTimerNotifier(ref);
    });

class FastingTimerNotifier extends StateNotifier<FastingTimerData> {
  final Ref _ref;
  Timer? _timer;
  FastingSession? _currentSession;

  FastingTimerNotifier(this._ref) : super(FastingTimerData.empty()) {
    _startListening();
  }

  void _startListening() {
    // 监听活跃的断食会话
    _ref.listen<FastingSession?>(activeFastingSessionProvider, (
      previous,
      next,
    ) {
      _onSessionChanged(next);
    });

    // 立即检查当前会话
    final currentSession = _ref.read(activeFastingSessionProvider);
    _onSessionChanged(currentSession);
  }

  void _onSessionChanged(FastingSession? session) {
    _currentSession = session;

    if (session != null && session.status == FastingStatus.active) {
      _startTimer();
    } else {
      _stopTimer();
      state = FastingTimerData.empty();
    }
  }

  void _startTimer() {
    _stopTimer(); // 确保没有重复的计时器

    // 立即更新一次
    _updateTimer();

    // 每秒更新一次
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTimer();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _updateTimer() {
    final session = _currentSession;
    if (session != null && session.status == FastingStatus.active) {
      state = FastingTimerData.fromSession(session);

      // 检查是否需要自动结束
      if (session.shouldAutoEnd(DateTime.now())) {
        _autoEndFasting(session.id);
      }
    }
  }

  void _autoEndFasting(String sessionId) {
    // 自动结束断食
    final fastingNotifier = _ref.read(fastingSessionsProvider.notifier);
    fastingNotifier.endFasting(sessionId);
  }

  // 手动刷新
  void refresh() {
    if (_currentSession != null) {
      _updateTimer();
    }
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}

// 格式化时间的工具函数
String formatDurationForTimer(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final seconds = duration.inSeconds.remainder(60);

  if (hours > 0) {
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  } else {
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

// 简化的计时器数据Provider（用于简单的UI组件）
final simpleTimerProvider = Provider<String>((ref) {
  final timerData = ref.watch(fastingTimerProvider);
  if (!timerData.isActive) {
    return '--:--';
  }
  return timerData.elapsedTimeFormatted;
});

// 进度百分比Provider
final fastingProgressProvider = Provider<double>((ref) {
  final timerData = ref.watch(fastingTimerProvider);
  return timerData.progressPercentage / 100.0;
});

// 是否超时Provider
final isOvertimeProvider = Provider<bool>((ref) {
  final timerData = ref.watch(fastingTimerProvider);
  return timerData.isOvertime;
});
