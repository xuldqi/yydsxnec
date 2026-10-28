import 'package:home_widget/home_widget.dart';
import '../core/constants/app_constants.dart';
import '../models/fasting_session.dart';

class WidgetService {
  static const String appGroupId = 'group.com.lightfasting'; // For iOS
  static const String androidWidgetName = 'FastingWidgetProvider';

  static Future<void> initialize() async {
    await HomeWidget.setAppGroupId(appGroupId);
  }

  static Future<void> updateFastingWidget(FastingSession? activeSession) async {
    if (activeSession == null || activeSession.status != FastingStatus.active) {
      await HomeWidget.saveWidgetData<String>('status_text', '未开始');
      await HomeWidget.saveWidgetData<int>('start_time', 0);
      await HomeWidget.saveWidgetData<int>('end_time', 0);
      await HomeWidget.saveWidgetData<double>('progress', 0.0);
    } else {
      final now = DateTime.now();

      // Calculate progress
      final startTime = activeSession.startTime;
      final endTime =
          activeSession.endTime ??
          startTime.add(Duration(hours: activeSession.fastingHours));

      final totalSeconds = endTime.difference(startTime).inSeconds;
      final elapsedSeconds = now.difference(startTime).inSeconds;
      final progress = totalSeconds > 0
          ? (elapsedSeconds / totalSeconds).clamp(0.0, 1.0)
          : 0.0;

      await HomeWidget.saveWidgetData<String>('status_text', '断食中');
      await HomeWidget.saveWidgetData<int>(
        'start_time',
        startTime.millisecondsSinceEpoch,
      );
      await HomeWidget.saveWidgetData<int>(
        'end_time',
        endTime.millisecondsSinceEpoch,
      );
      await HomeWidget.saveWidgetData<double>('progress', progress);
    }

    await HomeWidget.updateWidget(
      androidName: androidWidgetName,
      iOSName: 'FastingWidget',
    );
  }
}
