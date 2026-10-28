import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:just_audio/just_audio.dart';
import '../services/notification_service.dart';

class AlarmSoundOption {
  final String name;
  final String assetPath;

  const AlarmSoundOption({required this.name, required this.assetPath});
}

class AlarmProvider with ChangeNotifier {
  int _hour24 = 7;
  int _minute = 30;
  bool _smartWakeEnabled = true;
  bool _isLoading = true;

  // Sound and Volume Settings
  String _selectedAlarmSound = 'assets/audio/mynoise/BAMBOOGARDEN/0_竹叶_竹叶_a.mp3';
  String _selectedAlarmSoundName = '竹林清风';
  double _alarmVolume = 0.8;
  bool _isAlarmPlaying = false;
  AudioPlayer? _alarmPlayer;

  final List<AlarmSoundOption> soundOptions = const [
    AlarmSoundOption(name: '竹林清风', assetPath: 'assets/audio/mynoise/BAMBOOGARDEN/0_竹叶_竹叶_a.mp3'),
    AlarmSoundOption(name: '晨鸟歌唱', assetPath: 'assets/audio/mynoise/FOREST/5_鸟鸣_Birds_a.mp3'),
    AlarmSoundOption(name: '幽静溪流', assetPath: 'assets/audio/mynoise/FOREST/2_水声_Water_a.mp3'),
    AlarmSoundOption(name: '舒缓雨声', assetPath: 'assets/audio/mynoise/FOREST/8_雨声_Rain_a.mp3'),
  ];

  int get hour24 => _hour24;
  int get minute => _minute;
  bool get smartWakeEnabled => _smartWakeEnabled;
  bool get isLoading => _isLoading;

  String get selectedAlarmSound => _selectedAlarmSound;
  String get selectedAlarmSoundName => _selectedAlarmSoundName;
  double get alarmVolume => _alarmVolume;
  bool get isAlarmPlaying => _isAlarmPlaying;

  AlarmProvider() {
    _loadAlarm();
  }

  Future<void> _loadAlarm() async {
    final prefs = await SharedPreferences.getInstance();
    _hour24 = prefs.getInt('alarm_hour') ?? 7;
    _minute = prefs.getInt('alarm_minute') ?? 30;
    _smartWakeEnabled = prefs.getBool('smart_wake') ?? true;
    _selectedAlarmSound = prefs.getString('alarm_sound') ?? 'assets/audio/mynoise/BAMBOOGARDEN/0_竹叶_竹叶_a.mp3';
    _selectedAlarmSoundName = prefs.getString('alarm_sound_name') ?? '竹林清风';
    _alarmVolume = prefs.getDouble('alarm_volume') ?? 0.8;
    
    _isLoading = false;
    notifyListeners();
    _rescheduleAlarm();
  }

  Future<void> setWakeUpTime(int hour, int min) async {
    _hour24 = hour;
    _minute = min;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('alarm_hour', hour);
    await prefs.setInt('alarm_minute', min);
    await _rescheduleAlarm();
  }

  Future<void> toggleSmartWake(bool value) async {
    _smartWakeEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('smart_wake', value);
    await _rescheduleAlarm();
  }

  Future<void> setAlarmSound(String assetPath, String name) async {
    _selectedAlarmSound = assetPath;
    _selectedAlarmSoundName = name;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('alarm_sound', assetPath);
    await prefs.setString('alarm_sound_name', name);
  }

  Future<void> setAlarmVolume(double volume) async {
    _alarmVolume = volume;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('alarm_volume', volume);
    if (_isAlarmPlaying && _alarmPlayer != null) {
      await _alarmPlayer!.setVolume(volume);
    }
  }

  Future<void> playAlarm() async {
    if (_isAlarmPlaying) return;
    _isAlarmPlaying = true;
    notifyListeners();

    try {
      _alarmPlayer ??= AudioPlayer();
      await _alarmPlayer!.setAsset(_selectedAlarmSound);
      await _alarmPlayer!.setLoopMode(LoopMode.all);
      await _alarmPlayer!.setVolume(_alarmVolume);
      await _alarmPlayer!.play();
    } catch (e) {
      debugPrint("Error playing alarm: $e");
    }
  }

  Future<void> stopAlarm() async {
    if (!_isAlarmPlaying) return;
    _isAlarmPlaying = false;
    notifyListeners();

    try {
      if (_alarmPlayer != null) {
        await _alarmPlayer!.stop();
        await _alarmPlayer!.dispose();
        _alarmPlayer = null;
      }
    } catch (e) {
      debugPrint("Error stopping alarm: $e");
    }
  }

  Future<void> snooze(int minutes) async {
    await stopAlarm();
    final snoozeTime = DateTime.now().add(Duration(minutes: minutes));
    final String timeStr = '${snoozeTime.hour.toString().padLeft(2, '0')}:${snoozeTime.minute.toString().padLeft(2, '0')}';
    
    await NotificationService().scheduleAlarm(
      snoozeTime,
      1,
      '⏰ 贪睡时间到了',
      '再不起床要迟到了！($timeStr)',
    );
  }

  Future<void> _rescheduleAlarm() async {
    // Schedule for the next occurrence of this time
    final now = DateTime.now();
    DateTime scheduledTime = DateTime(now.year, now.month, now.day, _hour24, _minute);
    if (scheduledTime.isBefore(now)) {
      // If time has passed today, schedule for tomorrow
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    // Example logic for smart wake: wake up to 30 mins early
    final actualWakeTime = _smartWakeEnabled 
        ? scheduledTime.subtract(const Duration(minutes: 30)) 
        : scheduledTime;

    final String timeStr = '${_hour24.toString().padLeft(2, '0')}:${_minute.toString().padLeft(2, '0')}';
    
    await NotificationService().scheduleAlarm(
      actualWakeTime,
      1, // unique ID for alarm
      '⏰ 起床时间到了',
      _smartWakeEnabled 
          ? '现在是处于浅睡阶段的最佳唤醒时间，早安！($timeStr)' 
          : '设定的闹钟时间到了，早安！',
    );
  }

  @override
  void dispose() {
    _alarmPlayer?.dispose();
    super.dispose();
  }
}
