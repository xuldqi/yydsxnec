import 'dart:io';

import 'package:flutter/services.dart';

class OhosNativeService {
  OhosNativeService._();

  static const MethodChannel _channel = MethodChannel('com.bear.emoon/ohos');

  static bool get isOhos {
    try {
      final os = Platform.operatingSystem.toLowerCase();
      return os == 'ohos' || os == 'openharmony';
    } catch (_) {
      return false;
    }
  }

  static Future<bool> areNotificationsEnabled() async {
    if (!isOhos) return true;
    try {
      return await _channel.invokeMethod<bool>('areNotificationsEnabled') ??
          false;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> requestNotificationPermission() async {
    if (!isOhos) return true;
    try {
      return await _channel.invokeMethod<bool>(
            'requestNotificationPermission',
          ) ??
          false;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> showNotification({
    required int id,
    required String title,
    required String body,
    bool ongoing = false,
    String slot = 'content',
  }) async {
    if (!isOhos) return false;
    try {
      return await _channel.invokeMethod<bool>('showNotification', {
            'id': id,
            'title': title,
            'body': body,
            'ongoing': ongoing,
            'slot': slot,
          }) ??
          false;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> cancelNotification(int id) async {
    if (!isOhos) return false;
    try {
      return await _channel.invokeMethod<bool>('cancelNotification', {
            'id': id,
          }) ??
          true;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> scheduleReminder({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    bool repeatDaily = false,
    DateTime? scheduledAt,
  }) async {
    if (!isOhos) return false;
    try {
      return await _channel.invokeMethod<bool>('scheduleReminder', {
            'id': id,
            'title': title,
            'body': body,
            'hour': hour,
            'minute': minute,
            'repeatDaily': repeatDaily,
            if (scheduledAt != null) ...{
              'year': scheduledAt.year,
              'month': scheduledAt.month,
              'day': scheduledAt.day,
              'second': scheduledAt.second,
            },
          }) ??
          false;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> cancelReminder(int id) async {
    if (!isOhos) return false;
    try {
      return await _channel.invokeMethod<bool>('cancelReminder', {'id': id}) ??
          true;
    } catch (_) {
      return false;
    }
  }

  static Future<int?> addCalendarEvent({
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    if (!isOhos) return null;
    try {
      return await _channel.invokeMethod<int>('addCalendarEvent', {
        'title': title,
        'body': body,
        'hour': hour,
        'minute': minute,
      });
    } catch (e) {
      return null;
    }
  }

  static Future<bool> removeCalendarEvent({required int eventId}) async {
    if (!isOhos) return false;
    try {
      return await _channel.invokeMethod<bool>('removeCalendarEvent', {
            'eventId': eventId,
          }) ??
          false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> startAudioBackgroundTask() async {
    if (!isOhos) return false;
    try {
      return await _channel.invokeMethod<bool>('startAudioBackgroundTask') ??
          false;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> stopAudioBackgroundTask() async {
    if (!isOhos) return false;
    try {
      return await _channel.invokeMethod<bool>('stopAudioBackgroundTask') ??
          false;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> playWhiteNoise(String assetPath) async {
    if (!isOhos) return false;
    try {
      return await _channel.invokeMethod<bool>('playWhiteNoise', {
            'assetPath': assetPath,
          }) ??
          false;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> pauseWhiteNoise() async {
    if (!isOhos) return false;
    try {
      return await _channel.invokeMethod<bool>('pauseWhiteNoise') ?? false;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> stopWhiteNoise() async {
    if (!isOhos) return false;
    try {
      return await _channel.invokeMethod<bool>('stopWhiteNoise') ?? false;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> setWhiteNoiseVolume(double volume) async {
    if (!isOhos) return false;
    try {
      return await _channel.invokeMethod<bool>('setWhiteNoiseVolume', {
            'volume': volume,
          }) ??
          false;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> shareFile(
    String filePath, {
    String mimeType = '*/*',
  }) async {
    if (!isOhos) return false;
    try {
      return await _channel.invokeMethod<bool>('shareFile', {
            'filePath': filePath,
            'mimeType': mimeType,
          }) ??
          false;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> saveDocument(String filename, String content) async {
    if (!isOhos) return false;
    try {
      return await _channel.invokeMethod<bool>('saveDocument', {
            'filename': filename,
            'content': content,
          }) ??
          false;
    } catch (_) {
      return false;
    }
  }

  static Future<String?> startRecording() async {
    if (!isOhos) return null;
    try {
      return await _channel.invokeMethod<String>('startRecording');
    } catch (_) {
      return null;
    }
  }

  static Future<String?> stopRecording() async {
    if (!isOhos) return null;
    try {
      return await _channel.invokeMethod<String>('stopRecording');
    } catch (_) {
      return null;
    }
  }

  static Future<bool> playAudioFile(String filePath) async {
    if (!isOhos) return false;
    try {
      return await _channel.invokeMethod<bool>('playAudioFile', {
            'filePath': filePath,
          }) ??
          false;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> stopAudioFile() async {
    if (!isOhos) return false;
    try {
      return await _channel.invokeMethod<bool>('stopAudioFile') ?? false;
    } catch (_) {
      return false;
    }
  }
}
