import 'dart:async';
import 'dart:io';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(StepTaskHandler());
}

class StepTaskHandler extends TaskHandler {
  StreamSubscription<StepCount>? _stepSubscription;
  int _baseStepCount = -1;
  int _currentSteps = 0;

  static const _keyBase = 'step_base_';
  static const _keyDate = 'step_base_date';

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    final prefs = await SharedPreferences.getInstance();
    final today = _dateKey(DateTime.now());
    final savedDate = prefs.getString(_keyDate) ?? '';

    if (savedDate != today) {
      _baseStepCount = -1;
      await prefs.setString(_keyDate, today);
    } else {
      _baseStepCount = prefs.getInt('$_keyBase$today') ?? -1;
    }

    if (Platform.isAndroid || Platform.isIOS) {
      try {
        _stepSubscription = Pedometer.stepCountStream.listen((event) async {
          _currentSteps = event.steps;

          if (_baseStepCount == -1) {
            _baseStepCount = _currentSteps;
            await prefs.setInt('$_keyBase$today', _baseStepCount);
          }

          final todaySteps = (_currentSteps - _baseStepCount).clamp(0, 99999);

          FlutterForegroundTask.updateService(
            notificationTitle: '微刻运动',
            notificationText: '今日步数: $todaySteps 步',
          );
          
          FlutterForegroundTask.sendDataToMain(todaySteps);
        });
      } catch (e) {
        FlutterForegroundTask.updateService(
          notificationTitle: '微刻运动',
          notificationText: '无法获取步数权限',
        );
      }
    }
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    // Periodic tasks if needed
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    _stepSubscription?.cancel();
  }

  String _dateKey(DateTime d) => '${d.year}-${d.month}-${d.day}';
}

class ForegroundTaskService {
  static void init() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'health_step_channel',
        channelName: '计步服务',
        channelDescription: '在后台保持计步服务运行',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(5000),
        autoRunOnBoot: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  static Future<void> startService() async {
    if (await FlutterForegroundTask.isRunningService) {
      return;
    }
    await FlutterForegroundTask.startService(
      notificationTitle: '微刻运动',
      notificationText: '正在准备计步服务...',
      callback: startCallback,
    );
  }
}
