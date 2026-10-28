import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

import '../models/relax_audio_preset.dart';
import 'ohos_native_service.dart';
import 'relax_audio_notification_service.dart';

class RelaxAudioController extends ChangeNotifier {
  RelaxAudioController._() {
    _selectedPreset = RelaxAudioPresets.all.first;
    if (!OhosNativeService.isOhos) {
      _player.setVolume(_volume);
      _playerStateSubscription = _player.playerStateStream.listen((_) {
        notifyListeners();
      });
    }
    _notificationActionSubscription = RelaxAudioNotificationService.actions
        .listen(_handleNotificationAction);
  }

  static final RelaxAudioController instance = RelaxAudioController._();

  final AudioPlayer _player = AudioPlayer();
  StreamSubscription<PlayerState>? _playerStateSubscription;
  late final StreamSubscription<String> _notificationActionSubscription;
  Timer? _sleepTimer;

  late RelaxAudioPreset _selectedPreset;
  int _remainingSeconds = 0;
  bool _isPreparing = false;
  bool _hasActiveSource = false;
  bool _ohosPlaying = false;
  String? _loadedPresetId;
  double _volume = 0.58;

  RelaxAudioPreset get selectedPreset => _selectedPreset;
  int get remainingSeconds => _remainingSeconds;
  bool get isPreparing => _isPreparing;
  bool get isPlaying => OhosNativeService.isOhos ? _ohosPlaying : _player.playing;
  bool get hasActiveSource => _hasActiveSource;
  bool get canStop => _hasActiveSource || isPlaying;
  double get volume => _volume;

  Future<void> togglePlay() async {
    if (OhosNativeService.isOhos) {
      if (_ohosPlaying) {
        await OhosNativeService.pauseWhiteNoise();
        unawaited(OhosNativeService.stopAudioBackgroundTask());
        _ohosPlaying = false;
        unawaited(_showPlaybackNotification(isPlaying: false));
        notifyListeners();
        return;
      }
      _isPreparing = true;
      notifyListeners();
      try {
        final assetPath = _selectedPreset.assetPaths.first;
        final ok = await OhosNativeService.playWhiteNoise(assetPath);
        if (ok) {
          await OhosNativeService.setWhiteNoiseVolume(_volume);
          unawaited(OhosNativeService.startAudioBackgroundTask());
          _ohosPlaying = true;
          _hasActiveSource = true;
          _loadedPresetId = _selectedPreset.id;
          unawaited(_showPlaybackNotification(isPlaying: true));
        }
      } finally {
        _isPreparing = false;
        notifyListeners();
      }
      return;
    }

    if (_player.playing) {
      await _player.pause();
      unawaited(_showPlaybackNotification(isPlaying: false));
      notifyListeners();
      return;
    }

    _isPreparing = true;
    notifyListeners();
    try {
      if (_loadedPresetId != _selectedPreset.id) {
        await _loadSelectedPreset();
      }
      _hasActiveSource = true;
      _isPreparing = false;
      notifyListeners();
      unawaited(OhosNativeService.startAudioBackgroundTask());
      unawaited(
        _player.play().catchError((Object error, StackTrace stackTrace) {
          _isPreparing = false;
          notifyListeners();
        }),
      );
      unawaited(_showPlaybackNotification(isPlaying: true));
    } finally {
      _isPreparing = false;
      notifyListeners();
    }
  }

  Future<void> pause() async {
    if (OhosNativeService.isOhos) {
      await OhosNativeService.pauseWhiteNoise();
      unawaited(OhosNativeService.stopAudioBackgroundTask());
      _ohosPlaying = false;
      unawaited(_showPlaybackNotification(isPlaying: false));
      notifyListeners();
      return;
    }
    if (!_player.playing) return;
    await _player.pause();
    unawaited(OhosNativeService.stopAudioBackgroundTask());
    unawaited(_showPlaybackNotification(isPlaying: false));
    notifyListeners();
  }

  Future<void> selectPreset(RelaxAudioPreset preset) async {
    final wasPlaying = isPlaying;
    if (OhosNativeService.isOhos) {
      if (wasPlaying) await OhosNativeService.stopWhiteNoise();
      _ohosPlaying = false;
    } else {
      if (wasPlaying) await _player.stop();
    }
    _selectedPreset = preset;
    _hasActiveSource = false;
    _loadedPresetId = null;
    notifyListeners();
    if (wasPlaying) await togglePlay();
  }

  Future<void> stop() async {
    _sleepTimer?.cancel();
    if (OhosNativeService.isOhos) {
      await OhosNativeService.stopWhiteNoise();
      _ohosPlaying = false;
    } else {
      await _player.stop();
    }
    await OhosNativeService.stopAudioBackgroundTask();
    await RelaxAudioNotificationService.cancel();
    _loadedPresetId = null;
    _remainingSeconds = 0;
    _hasActiveSource = false;
    notifyListeners();
  }

  Future<void> setVolume(double value) async {
    _volume = value;
    notifyListeners();
    if (OhosNativeService.isOhos) {
      await OhosNativeService.setWhiteNoiseVolume(value);
    } else {
      await _player.setVolume(value);
    }
  }

  void setSleepTimer(int minutes) {
    _sleepTimer?.cancel();
    if (minutes <= 0) {
      _remainingSeconds = 0;
      notifyListeners();
      return;
    }

    _remainingSeconds = minutes * 60;
    notifyListeners();
    _sleepTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_remainingSeconds <= 1) {
        timer.cancel();
        await stop();
        return;
      }
      _remainingSeconds--;
      notifyListeners();
    });
  }

  Future<void> _loadSelectedPreset() async {
    await _player.setLoopMode(LoopMode.all);
    await _player.setAudioSource(
      ConcatenatingAudioSource(
        children: _selectedPreset.assetPaths
            .map((assetPath) => AudioSource.asset(assetPath))
            .toList(),
      ),
    );
    await _player.setVolume(_volume);
    _loadedPresetId = _selectedPreset.id;
    _hasActiveSource = true;
  }

  Future<void> _showPlaybackNotification({required bool isPlaying}) async {
    final granted =
        await RelaxAudioNotificationService.requestPermissionIfNeeded();
    if (!granted) return;
    await RelaxAudioNotificationService.showPlayback(
      soundName: _selectedPreset.title,
      isPlaying: isPlaying,
    );
  }

  Future<void> _handleNotificationAction(String action) async {
    switch (action) {
      case RelaxAudioNotificationService.actionToggle:
        if (isPlaying) {
          await pause();
        } else {
          await togglePlay();
        }
        break;
      case RelaxAudioNotificationService.actionStop:
        await stop();
        break;
    }
  }

  @override
  void dispose() {
    _sleepTimer?.cancel();
    _playerStateSubscription?.cancel();
    _notificationActionSubscription.cancel();
    RelaxAudioNotificationService.cancel();
    _player.dispose();
    super.dispose();
  }
}
