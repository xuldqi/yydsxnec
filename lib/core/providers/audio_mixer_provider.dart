import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/notification_service.dart';

class SavedPreset {
  final String id;
  final String name;
  final String soundscapeId;
  final Map<int, double> stemVolumes;

  SavedPreset({
    required this.id,
    required this.name,
    required this.soundscapeId,
    required this.stemVolumes,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'soundscapeId': soundscapeId,
    'stemVolumes': stemVolumes.map(
      (key, value) => MapEntry(key.toString(), value),
    ),
  };

  factory SavedPreset.fromJson(Map<String, dynamic> json) => SavedPreset(
    id: json['id'],
    name: json['name'],
    soundscapeId: json['soundscapeId'],
    stemVolumes: (json['stemVolumes'] as Map<String, dynamic>).map(
      (key, value) => MapEntry(int.parse(key), value as double),
    ),
  );
}

class StemState {
  final int index;
  final String name;
  final List<String> assetPaths;
  final AudioPlayer player;
  double volume;

  StemState({
    required this.index,
    required this.name,
    required this.assetPaths,
    required this.player,
    this.volume = 0.5,
  });
}

class Soundscape {
  final String id;
  final String title;
  final String folderPath;
  final List<StemState> stems;

  Soundscape({
    required this.id,
    required this.title,
    required this.folderPath,
    required this.stems,
  });
}

// Friendly Chinese names for numbered tracks in each soundscape
const Map<String, Map<int, String>> _trackNames = {
  'fire': {
    1: '柴火劈裂声',
    2: '微弱火苗声',
    3: '旺盛燃烧声',
    4: '火焰噼啪声',
    5: '深沉炭火声',
    6: '炉火轰鸣声',
    7: '余烬低鸣声',
    8: '篝火摇曳声',
    9: '远处篝火声',
  },
  'rain': {
    1: '轻柔细雨声',
    2: '叶上雨滴声',
    3: '窗边雨声',
    4: '林间中雨声',
    5: '远处雷鸣声',
    6: '屋檐水滴声',
    7: '暴雨声',
    8: '雨后溪流声',
    9: '泥土雨声',
  },
  'wind': {
    1: '微风轻拂声',
    2: '树叶沙沙声',
    3: '山谷风声',
    4: '草原风声',
    5: '海岸劲风声',
    6: '低鸣风声',
    7: '深林风声',
    8: '呼啸大风声',
    9: '夜风轻语声',
  },
  'japanese_garden': {
    0: '水流声',
    1: '竹管滴水',
    2: '风铃声',
    3: '鸟鸣声',
    4: '蝉鸣声',
    5: '虫鸣声',
    6: '石砾水声',
    7: '远处钟声',
    8: '微风拂叶',
    9: '雨滴落石',
  },
  'frog': {
    0: '蛙鸣主调',
    1: '深沉蛙声',
    2: '水面涟漪',
    5: '夜虫声',
    6: '雨夜氛围',
    7: '远处蛙鸣',
    8: '池塘水声',
    9: '蛙鸣回响',
  },
  'meadow': {
    0: '溪流声',
    1: '草地风声',
    2: '鸟鸣声',
    3: '虫鸣声',
    4: '远处水声',
    5: '草丛沙沙',
    6: '蜜蜂嗡嗡',
    7: '田野风声',
    8: '溪流激流',
    9: '晨露滴落',
  },
  'palm_night': {
    0: '夜晚氛围',
    1: '棕榈叶沙沙',
    2: '虫鸣声',
    3: '远处海浪',
    4: '夜风声',
    5: '椰树摇曳',
    6: '夜鸟啼鸣',
    7: '热带蛙声',
    8: '海风声',
    9: '夜雨声',
  },
  'enchanted_forest': {
    0: '魔法氛围',
    1: '神秘风声',
    2: '精灵铃声',
    3: '丛林鸟鸣',
    4: '神秘水声',
    5: '回响远声',
    6: '枯叶簌簌',
    7: '深林低鸣',
    8: '精灵低语',
    9: '远古钟鸣',
  },
  'piano': {
    0: '主旋律',
    1: '和弦声',
    2: '低音键',
    3: '高音泛音',
    4: '踏板共鸣',
    5: '柔音变奏',
    6: '琶音流淌',
    7: '强音织体',
    8: '轻柔尾音',
    9: '远场混响',
  },
  'old_tape': {
    0: '磁带底噪',
    1: '低频嗡嗡',
    2: '沙沙声',
    3: '音乐旋律',
    4: '氛围气息',
    5: '磁带嘶声',
    6: '远场人声',
    7: '磁带颤抖',
    8: '老式电台',
    9: '静电噪音',
  },
  'singing_bowls': {
    0: '基础共鸣',
    2: '高频泛音',
    3: '中频颂钵',
    4: '低沉共鸣',
    5: '余韵回响',
    6: '深沉共振',
    7: '清脆钵声',
    8: '渐弱尾音',
    9: '远场共鸣',
  },
  'tidal': {
    0: '潮汐主调',
    1: '海浪冲击',
    2: '退潮声',
    3: '远海浪声',
    4: '海面风声',
    5: '海岸拍石',
    6: '浪花飞溅',
    7: '深海低频',
    8: '海湾回响',
    9: '远洋涌浪',
  },
  'ocean_noise': {
    2: '海浪低频',
    3: '中频海浪',
    4: '高频浪花',
    5: '海岸击石',
    6: '远海涌浪',
    7: '海风声',
    8: '海面波纹',
    9: '深海回响',
  },
  'downtempo': {
    0: '鼓点节奏',
    1: '低音贝斯',
    2: '合成器垫',
    3: '旋律线',
    4: '氛围铺底',
    5: '打击乐器',
    6: '环境采样',
    7: '人声哼唱',
    8: '效果音',
    9: '尾声渐弱',
  },
};

class AudioMixerProvider with ChangeNotifier {
  Soundscape? _currentSoundscape;
  bool _isPlaying = false;
  Timer? _sleepTimer;
  StreamSubscription<String>? _notificationActionSub;
  int _remainingTimerSeconds = 0;
  bool _isLoading = false;
  List<SavedPreset> _savedPresets = [];

  bool get isPlaying => _isPlaying;
  bool get isLoading => _isLoading;
  Soundscape? get currentSoundscape => _currentSoundscape;
  int get remainingTimerSeconds => _remainingTimerSeconds;
  List<SavedPreset> get savedPresets => _savedPresets;

  AudioMixerProvider() {
    _loadPresets();
    _notificationActionSub = NotificationService().actionStream.listen(
      _handleNotificationAction,
    );
  }

  Future<void> _handleNotificationAction(String actionId) async {
    if (actionId == sleepAidToggleAction) {
      await togglePlay();
    } else if (actionId == sleepAidStopAction) {
      await stopAll();
    }
  }

  Future<void> _loadPresets() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final str = prefs.getString('saved_presets');
      if (str != null) {
        final List decoded = jsonDecode(str);
        _savedPresets = decoded.map((e) => SavedPreset.fromJson(e)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading presets: $e');
    }
  }

  Future<void> _savePresets() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final str = jsonEncode(_savedPresets.map((e) => e.toJson()).toList());
      await prefs.setString('saved_presets', str);
    } catch (e) {
      debugPrint('Error saving presets: $e');
    }
  }

  // Categories for soundscapes
  final List<Map<String, String>> categories = [
    {'id': 'all', 'name': '全部'},
    {'id': 'rain', 'name': '🌧️ 雨声'},
    {'id': 'water', 'name': '🌊 水声'},
    {'id': 'nature', 'name': '🌲 自然'},
    {'id': 'warm', 'name': '🔥 温暖'},
    {'id': 'vibe', 'name': '🎵 氛围'},
    {'id': 'special', 'name': '🍼 特殊'},
  ];

  final List<Map<String, String>> availableSoundscapes = [
    {
      'id': 'ocean',
      'title': '海浪',
      'folder': 'assets/audio/mynoise/OCEAN',
      'category': 'water',
    },
    {
      'id': 'rain',
      'title': '雷雨',
      'folder': 'assets/audio/mynoise/RAINNOISE',
      'category': 'rain',
    },
    {
      'id': 'fire',
      'title': '篝火',
      'folder': 'assets/audio/mynoise/FIRENOISE',
      'category': 'warm',
    },
    {
      'id': 'wind',
      'title': '微风',
      'folder': 'assets/audio/mynoise/WINDNOISE',
      'category': 'nature',
    },
    {
      'id': 'forest',
      'title': '森林',
      'folder': 'assets/audio/mynoise/FOREST',
      'category': 'nature',
    },
    {
      'id': 'waterfall',
      'title': '瀑布',
      'folder': 'assets/audio/mynoise/WATERFALL',
      'category': 'water',
    },
    {
      'id': 'thunder',
      'title': '雷暴',
      'folder': 'assets/audio/mynoise/THUNDER',
      'category': 'rain',
    },
    {
      'id': 'tibet',
      'title': '西藏诵经',
      'folder': 'assets/audio/mynoise/TIBET',
      'category': 'vibe',
    },
    {
      'id': 'bamboo',
      'title': '竹林',
      'folder': 'assets/audio/mynoise/BAMBOOGARDEN',
      'category': 'nature',
    },
    {
      'id': 'japanese_garden',
      'title': '日式庭院',
      'folder': 'assets/audio/mynoise/JAPANESEGARDEN',
      'category': 'nature',
    },
    {
      'id': 'frog',
      'title': '蛙声池塘',
      'folder': 'assets/audio/mynoise/FROGGYPOND',
      'category': 'nature',
    },
    {
      'id': 'white_noise',
      'title': '白噪音',
      'folder': 'assets/audio/mynoise/WHITENOISE',
      'category': 'vibe',
    },
    {
      'id': 'binaural',
      'title': '双耳节拍',
      'folder': 'assets/audio/mynoise/BINAURAL',
      'category': 'vibe',
    },
    {
      'id': 'baby_shush',
      'title': '婴儿嘘声',
      'folder': 'assets/audio/mynoise/BABYSLEEPSHUSH',
      'category': 'special',
    },
    {
      'id': 'camping_rain',
      'title': '露营雨声',
      'folder': 'assets/audio/mynoise/CAMPINGRAINNOISE',
      'category': 'rain',
    },
    {
      'id': 'meadow',
      'title': '草地溪流',
      'folder': 'assets/audio/mynoise/MEADOWCREEK',
      'category': 'water',
    },
    {
      'id': 'rain3',
      'title': '绵绵细雨',
      'folder': 'assets/audio/mynoise/RAIN3',
      'category': 'rain',
    },
    {
      'id': 'rain4',
      'title': '倾盆大雨',
      'folder': 'assets/audio/mynoise/RAIN4',
      'category': 'rain',
    },
    {
      'id': 'winter',
      'title': '冬日雪景',
      'folder': 'assets/audio/mynoise/WINTER',
      'category': 'special',
    },
    {
      'id': 'palm_night',
      'title': '夜晚棕榈',
      'folder': 'assets/audio/mynoise/PALMGARDENATNIGHT',
      'category': 'nature',
    },
    {
      'id': 'deep_ocean',
      'title': '深海',
      'folder': 'assets/audio/mynoise/DEEPOCEAN',
      'category': 'water',
    },
    {
      'id': 'deep_relax',
      'title': '深度放松',
      'folder': 'assets/audio/mynoise/DEEPRELAXINGAMBIENT',
      'category': 'special',
    },
    {
      'id': 'enchanted_forest',
      'title': '魔法森林',
      'folder': 'assets/audio/mynoise/ENCHANTEDFOREST',
      'category': 'nature',
    },
    {
      'id': 'cabin',
      'title': '木屋壁炉',
      'folder': 'assets/audio/mynoise/CABIN',
      'category': 'warm',
    },
    {
      'id': 'cabin_noise',
      'title': '小屋噪音',
      'folder': 'assets/audio/mynoise/CABINNOISE',
      'category': 'warm',
    },
    {
      'id': 'sauna',
      'title': '桑拿蒸汽',
      'folder': 'assets/audio/mynoise/SAUNA',
      'category': 'warm',
    },
    {
      'id': 'piano',
      'title': '钢琴',
      'folder': 'assets/audio/mynoise/PIANO',
      'category': 'vibe',
    },
    {
      'id': 'old_tape',
      'title': '老式录音机',
      'folder': 'assets/audio/mynoise/OLDTAPE',
      'category': 'vibe',
    },
    {
      'id': 'singing_bowls',
      'title': '颂钵',
      'folder': 'assets/audio/mynoise/SINGINGBOWLSDRONE',
      'category': 'vibe',
    },
    {
      'id': 'tidal',
      'title': '潮汐',
      'folder': 'assets/audio/mynoise/TIDALNOISE',
      'category': 'water',
    },
    {
      'id': 'ocean_noise',
      'title': '海浪噪音',
      'folder': 'assets/audio/mynoise/OCEANNOISE',
      'category': 'water',
    },
    {
      'id': 'deep_voice',
      'title': '深沉共鸣',
      'folder': 'assets/audio/mynoise/DEEPVOICE',
      'category': 'special',
    },
    {
      'id': 'downtempo',
      'title': '慢节奏背景乐',
      'folder': 'assets/audio/mynoise/DOWNTEMPOBACKGROUNDM',
      'category': 'vibe',
    },
  ];

  Future<void> loadSoundscape(String id) async {
    // Allow reloading the same soundscape (removed early return)
    _isLoading = true;
    notifyListeners();

    // Stop and dispose old soundscape
    await stopAll();
    _disposeCurrentSoundscape();

    final config = availableSoundscapes.firstWhere((s) => s['id'] == id);
    final folderPath = config['folder']!;
    final title = config['title']!;

    // Read all assets
    final assetManifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final List<String> allAssets = assetManifest.listAssets();

    // Filter assets for this folder
    final audioPaths =
        allAssets
            .where((key) => key.startsWith(folderPath) && key.endsWith('.mp3'))
            .toList()
          ..sort();

    // Group by stem index
    Map<int, List<String>> stemFiles = {};

    for (var path in audioPaths) {
      final fileName = path.split('/').last;
      final parts = fileName.split('_');
      if (parts.isNotEmpty) {
        final index = int.tryParse(parts[0]);
        if (index != null) {
          stemFiles.putIfAbsent(index, () => []).add(path);
        }
      }
    }

    // Get friendly name lookup for this soundscape
    final nameMap = _trackNames[id] ?? {};

    List<StemState> stems = [];
    List<Future<void>> futures = [];

    for (var entry in stemFiles.entries) {
      final index = entry.key;
      final paths = entry.value..sort();

      // Determine name: use friendly name map, else parse from filename (Ocean), else fallback
      String name;
      if (nameMap.containsKey(index)) {
        name = nameMap[index]!;
      } else {
        // Try to extract Chinese name from filename (e.g. "0_冰河湖风_Jokulsarlon_a.mp3")
        final fileName = paths.first.split('/').last;
        final parts = fileName.split('_');
        if (parts.length >= 2) {
          final candidate = parts[1];
          // Check if it looks like Chinese (not "音轨X" style which is a fallback)
          name = candidate;
        } else {
          name = '音轨 $index';
        }
      }

      final player = AudioPlayer();
      final audioSources = paths.map((p) => AudioSource.asset(p)).toList();
      final playlist = ConcatenatingAudioSource(children: audioSources);

      futures.add(
        (() async {
          await player.setAudioSource(playlist);
          await player.setLoopMode(LoopMode.all);
          await player.setVolume(0.5);
        })(),
      );

      stems.add(
        StemState(
          index: index,
          name: name,
          assetPaths: paths,
          player: player,
          volume: 0.5,
        ),
      );
    }

    await Future.wait(futures);

    stems.sort((a, b) => a.index.compareTo(b.index));

    _currentSoundscape = Soundscape(
      id: id,
      title: title,
      folderPath: folderPath,
      stems: stems,
    );

    _isPlaying = true;
    _isLoading = false;
    notifyListeners();

    for (var stem in stems) {
      stem.player.play();
    }
    await _syncSleepAidNotification();
  }

  Future<void> loadPreset(SavedPreset preset) async {
    await loadSoundscape(preset.soundscapeId);
    if (_currentSoundscape == null) return;

    for (var stem in _currentSoundscape!.stems) {
      if (preset.stemVolumes.containsKey(stem.index)) {
        final volume = preset.stemVolumes[stem.index]!;
        stem.volume = volume;
        await stem.player.setVolume(volume);
      }
    }
    notifyListeners();
  }

  Future<void> saveCurrentMix(String name) async {
    if (_currentSoundscape == null) return;

    final Map<int, double> volumes = {};
    for (var stem in _currentSoundscape!.stems) {
      volumes[stem.index] = stem.volume;
    }

    final newPreset = SavedPreset(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      soundscapeId: _currentSoundscape!.id,
      stemVolumes: volumes,
    );

    _savedPresets.add(newPreset);
    notifyListeners();
    await _savePresets();
  }

  Future<void> deletePreset(String id) async {
    _savedPresets.removeWhere((p) => p.id == id);
    notifyListeners();
    await _savePresets();
  }

  Future<void> setStemVolume(int stemIndex, double volume) async {
    if (_currentSoundscape == null) return;

    final stem = _currentSoundscape!.stems.firstWhere(
      (s) => s.index == stemIndex,
    );
    stem.volume = volume;
    await stem.player.setVolume(volume);

    notifyListeners();
  }

  Future<void> togglePlay() async {
    if (_currentSoundscape == null) return;

    _isPlaying = !_isPlaying;
    for (var stem in _currentSoundscape!.stems) {
      if (_isPlaying) {
        stem.player.play();
      } else {
        stem.player.pause();
      }
    }
    notifyListeners();
    await _syncSleepAidNotification();
  }

  Future<void> stopAll() async {
    _isPlaying = false;
    if (_currentSoundscape != null) {
      for (var stem in _currentSoundscape!.stems) {
        await stem.player.pause();
      }
    }
    notifyListeners();
    await NotificationService().cancelSleepAidNotification();
  }

  void _disposeCurrentSoundscape() {
    if (_currentSoundscape != null) {
      for (var stem in _currentSoundscape!.stems) {
        stem.player.dispose();
      }
      _currentSoundscape = null;
    }
  }

  void setSleepTimer(int minutes) {
    _sleepTimer?.cancel();
    if (minutes <= 0) {
      _remainingTimerSeconds = 0;
      notifyListeners();
      _syncSleepAidNotification();
      return;
    }

    _remainingTimerSeconds = minutes * 60;
    _sleepTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _remainingTimerSeconds--;
      if (_remainingTimerSeconds <= 0) {
        _sleepTimer?.cancel();
        stopAll();
      }
      notifyListeners();
      if (_remainingTimerSeconds % 60 == 0 || _remainingTimerSeconds <= 10) {
        _syncSleepAidNotification();
      }
    });
    notifyListeners();
    _syncSleepAidNotification();
  }

  Future<void> _syncSleepAidNotification() async {
    final current = _currentSoundscape;
    if (current == null) return;
    await NotificationService().showSleepAidNotification(
      title: current.title,
      isPlaying: _isPlaying,
      remainingTimerSeconds: _remainingTimerSeconds,
    );
  }

  @override
  void dispose() {
    _sleepTimer?.cancel();
    _notificationActionSub?.cancel();
    NotificationService().cancelSleepAidNotification();
    _disposeCurrentSoundscape();
    super.dispose();
  }
}
