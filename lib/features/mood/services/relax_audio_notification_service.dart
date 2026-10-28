import 'dart:async';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

import 'ohos_native_service.dart';

class RelaxAudioNotificationService {
  static const int _notificationId = 2101;
  static const String actionToggle = 'relax_audio_toggle';
  static const String actionStop = 'relax_audio_stop';
  static const String _channelId = 'relax_audio_playback';
  static const String _channelName = '白噪音播放';

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  static final StreamController<String> _actionController =
      StreamController<String>.broadcast();

  static bool _initialized = false;

  static Stream<String> get actions => _actionController.stream;

  static Future<void> init() async {
    if (_initialized) return;
    if (OhosNativeService.isOhos) {
      _initialized = true;
      return;
    }

    const android = AndroidInitializationSettings('@mipmap/launcher_icon');
    const darwin = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const settings = InitializationSettings(
      android: android,
      iOS: darwin,
      macOS: darwin,
    );
    await _plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: _handleResponse,
    );

    if (Platform.isAndroid) {
      final androidPlugin = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      if (androidPlugin != null) {
        const channel = AndroidNotificationChannel(
          _channelId,
          _channelName,
          description: '控制正在播放的白噪音',
          importance: Importance.low,
          playSound: false,
          enableVibration: false,
          showBadge: false,
        );
        await androidPlugin.createNotificationChannel(channel);
      }
    }

    _initialized = true;
  }

  static void _handleResponse(NotificationResponse response) {
    handleNotificationResponse(response);
  }

  static void handleNotificationResponse(NotificationResponse response) {
    final actionId = response.actionId;
    if (actionId == actionToggle || actionId == actionStop) {
      _actionController.add(actionId!);
    }
  }

  static Future<bool> requestPermissionIfNeeded() async {
    if (OhosNativeService.isOhos) {
      if (await OhosNativeService.areNotificationsEnabled()) return true;
      return OhosNativeService.requestNotificationPermission();
    }
    await init();
    if (Platform.isAndroid) {
      var granted = (await Permission.notification.status).isGranted;
      if (!granted) {
        granted = (await Permission.notification.request()).isGranted;
      }
      if (!granted) {
        final androidPlugin = _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
        final pluginGranted = await androidPlugin
            ?.requestNotificationsPermission();
        granted = pluginGranted == true;
      }
      return granted;
    }
    if (Platform.isIOS) {
      final iosPlugin = _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      return await iosPlugin?.requestPermissions(alert: true) ?? true;
    }
    if (Platform.isMacOS) {
      final macPlugin = _plugin
          .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin
          >();
      return await macPlugin?.requestPermissions(alert: true) ?? true;
    }
    return true;
  }

  static Future<void> showPlayback({
    required String soundName,
    required bool isPlaying,
  }) async {
    if (OhosNativeService.isOhos) {
      await OhosNativeService.showNotification(
        id: _notificationId,
        title: '白噪音空间',
        body: isPlaying ? '正在播放：$soundName' : '已暂停：$soundName',
        ongoing: isPlaying,
        slot: 'audio',
      );
      return;
    }
    await init();

    final androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: '控制正在播放的白噪音',
      importance: Importance.low,
      priority: Priority.low,
      playSound: false,
      enableVibration: false,
      ongoing: isPlaying,
      autoCancel: false,
      onlyAlertOnce: true,
      showWhen: false,
      category: AndroidNotificationCategory.transport,
      actions: [
        AndroidNotificationAction(
          actionToggle,
          isPlaying ? '暂停' : '继续',
          showsUserInterface: true,
          cancelNotification: false,
        ),
        const AndroidNotificationAction(
          actionStop,
          '停止',
          showsUserInterface: true,
          cancelNotification: true,
        ),
      ],
    );
    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentSound: false,
      presentBadge: false,
      presentBanner: true,
      presentList: true,
    );
    final details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: darwinDetails,
    );

    await _plugin.show(id: _notificationId, title: '白噪音空间', body: isPlaying ? '正在播放：$soundName' : '已暂停：$soundName', notificationDetails: details,
      payload: 'relax_audio',
    );
  }

  static Future<void> cancel() async {
    if (OhosNativeService.isOhos) {
      await OhosNativeService.cancelNotification(_notificationId);
      return;
    }
    await _plugin.cancel(id: _notificationId);
  }
}
