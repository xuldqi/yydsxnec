// 白噪音页 (全面覆盖 7 大常用自然分类，每类精选 2 款 MP3 音频，总共 14 款轻量音频)

import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_dimens.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/app_l10n_ext.dart';

class SoundCategory {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final List<WhiteNoise> sounds;

  const SoundCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.sounds,
  });
}

class WhiteNoise {
  final String id;
  final String categoryId;
  final String categoryName;
  final String name;
  final String asset;
  final String description;
  final Color color;
  final IconData icon;

  const WhiteNoise({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.name,
    required this.asset,
    required this.description,
    required this.color,
    required this.icon,
  });
}

class WhiteNoiseScreen extends StatefulWidget {
  const WhiteNoiseScreen({super.key});
  @override
  State<WhiteNoiseScreen> createState() => _WhiteNoiseScreenState();
}

class _WhiteNoiseScreenState extends State<WhiteNoiseScreen> {
  final _player = AudioPlayer();
  WhiteNoise? _current;
  Timer? _sleepTimer;
  Duration _sleepAfter = Duration.zero;
  Duration _elapsed = Duration.zero;
  Timer? _ticker;
  bool _looping = true;
  double _volume = 0.7;
  bool _expanded = false;
  String _selectedCategoryFilter = 'all';

  // 7 大核心白噪音分类，每一类严格精选 2 个高质压缩 MP3
  static const _categories = <SoundCategory>[
    SoundCategory(
      id: 'rain',
      name: '雨声',
      icon: Icons.water_drop_rounded,
      color: Color(0xFF3B6B80),
      sounds: [
        WhiteNoise(
          id: 'rain_a',
          categoryId: 'rain',
          categoryName: '雨声',
          name: '细雨绵绵',
          asset: 'audio/noise_rain_a.mp3',
          description: '窗外细雨，助眠沉浸',
          color: Color(0xFF3B6B80),
          icon: Icons.umbrella_rounded,
        ),
        WhiteNoise(
          id: 'rain_b',
          categoryId: 'rain',
          categoryName: '雨声',
          name: '屋檐听雨',
          asset: 'audio/noise_rain_b.mp3',
          description: '檐下落雨，舒缓放松',
          color: Color(0xFF3B6B80),
          icon: Icons.grain_rounded,
        ),
      ],
    ),
    SoundCategory(
      id: 'forest',
      name: '森林',
      icon: Icons.forest_rounded,
      color: Color(0xFF436B3E),
      sounds: [
        WhiteNoise(
          id: 'forest_a',
          categoryId: 'forest',
          categoryName: '森林',
          name: '晨光林间',
          asset: 'audio/noise_forest_a.mp3',
          description: '清晨鸟鸣，自然生机',
          color: Color(0xFF436B3E),
          icon: Icons.park_rounded,
        ),
        WhiteNoise(
          id: 'forest_b',
          categoryId: 'forest',
          categoryName: '森林',
          name: '幽谷清音',
          asset: 'audio/noise_forest_b.mp3',
          description: '空山回响，宁静治愈',
          color: Color(0xFF436B3E),
          icon: Icons.eco_rounded,
        ),
      ],
    ),
    SoundCategory(
      id: 'ocean',
      name: '海洋',
      icon: Icons.waves_rounded,
      color: Color(0xFF286E8A),
      sounds: [
        WhiteNoise(
          id: 'ocean_a',
          categoryId: 'ocean',
          categoryName: '海洋',
          name: '舒缓浪花',
          asset: 'audio/noise_ocean_a.mp3',
          description: '细浪拍岸，节奏抚慰',
          color: Color(0xFF286E8A),
          icon: Icons.tsunami_rounded,
        ),
        WhiteNoise(
          id: 'ocean_b',
          categoryId: 'ocean',
          categoryName: '海洋',
          name: '潮汐起伏',
          asset: 'audio/noise_ocean_b.mp3',
          description: '深海呼吸，平和释压',
          color: Color(0xFF286E8A),
          icon: Icons.water_rounded,
        ),
      ],
    ),
    SoundCategory(
      id: 'fire',
      name: '壁炉',
      icon: Icons.local_fire_department_rounded,
      color: Color(0xFFC05621),
      sounds: [
        WhiteNoise(
          id: 'fire_a',
          categoryId: 'fire',
          categoryName: '壁炉',
          name: '炉火柴响',
          asset: 'audio/noise_fire_a.mp3',
          description: '木柴微响，温暖安心',
          color: Color(0xFFC05621),
          icon: Icons.fireplace_rounded,
        ),
        WhiteNoise(
          id: 'fire_b',
          categoryId: 'fire',
          categoryName: '壁炉',
          name: '晚风篝火',
          asset: 'audio/noise_fire_b.mp3',
          description: '夜幕营火，围炉夜话',
          color: Color(0xFFC05621),
          icon: Icons.whatshot_rounded,
        ),
      ],
    ),
    SoundCategory(
      id: 'wind',
      name: '微风',
      icon: Icons.air_rounded,
      color: Color(0xFF4A7C72),
      sounds: [
        WhiteNoise(
          id: 'wind_a',
          categoryId: 'wind',
          categoryName: '微风',
          name: '山野清风',
          asset: 'audio/noise_wind_a.mp3',
          description: '林梢微拂，心旷神怡',
          color: Color(0xFF4A7C72),
          icon: Icons.air_rounded,
        ),
        WhiteNoise(
          id: 'wind_b',
          categoryId: 'wind',
          categoryName: '微风',
          name: '窗畔流风',
          asset: 'audio/noise_wind_b.mp3',
          description: '柔风徐徐，安抚心绪',
          color: Color(0xFF4A7C72),
          icon: Icons.wind_power_rounded,
        ),
      ],
    ),
    SoundCategory(
      id: 'white_noise',
      name: '白噪',
      icon: Icons.graphic_eq_rounded,
      color: Color(0xFF5A6B7C),
      sounds: [
        WhiteNoise(
          id: 'white_a',
          categoryId: 'white_noise',
          categoryName: '白噪',
          name: '纯净白噪',
          asset: 'audio/noise_white_a.mp3',
          description: '全频均衡，屏蔽杂音',
          color: Color(0xFF5A6B7C),
          icon: Icons.blur_on_rounded,
        ),
        WhiteNoise(
          id: 'white_b',
          categoryId: 'white_noise',
          categoryName: '白噪',
          name: '沉思褐噪',
          asset: 'audio/noise_white_b.mp3',
          description: '低频平稳，高效专注',
          color: Color(0xFF5A6B7C),
          icon: Icons.grain_rounded,
        ),
      ],
    ),
    SoundCategory(
      id: 'sleep',
      name: '助眠',
      icon: Icons.bedtime_rounded,
      color: Color(0xFF56528A),
      sounds: [
        WhiteNoise(
          id: 'sleep_a',
          categoryId: 'sleep',
          categoryName: '助眠',
          name: '夏夜蝉鸣',
          asset: 'audio/noise_sleep_a.mp3',
          description: '静谧夏夜，甜美入梦',
          color: Color(0xFF56528A),
          icon: Icons.nights_stay_rounded,
        ),
        WhiteNoise(
          id: 'sleep_b',
          categoryId: 'sleep',
          categoryName: '助眠',
          name: '空灵安神',
          asset: 'audio/noise_sleep_b.mp3',
          description: '深层冥想，舒缓身心',
          color: Color(0xFF56528A),
          icon: Icons.spa_rounded,
        ),
      ],
    ),
  ];

  static List<WhiteNoise> get _allSounds =>
      _categories.expand((c) => c.sounds).toList();

  @override
  void initState() {
    super.initState();
    _player.setReleaseMode(ReleaseMode.loop);
    _player.onPlayerComplete.listen((_) {
      if (_looping && _current != null) {
        _player.play(AssetSource(_current!.asset));
      }
    });
  }

  @override
  void dispose() {
    _player.dispose();
    _sleepTimer?.cancel();
    _ticker?.cancel();
    super.dispose();
  }

  Future<void> _toggle(WhiteNoise noise) async {
    if (_current?.id == noise.id) {
      await _stop();
      return;
    }
    await _player.stop();
    setState(() {
      _current = noise;
      _elapsed = Duration.zero;
    });
    await _player.setVolume(_volume);
    await _player.play(AssetSource(noise.asset));
    _startTicker();
    _scheduleStop();
  }

  Future<void> _stop() async {
    await _player.stop();
    _sleepTimer?.cancel();
    _ticker?.cancel();
    setState(() {
      _current = null;
      _elapsed = Duration.zero;
    });
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _elapsed += const Duration(seconds: 1);
      });
    });
  }

  Future<void> _setVolume(double v) async {
    setState(() => _volume = v);
    await _player.setVolume(v);
  }

  void _scheduleStop() {
    _sleepTimer?.cancel();
    if (_sleepAfter.inSeconds == 0) return;
    _sleepTimer = Timer(_sleepAfter, () {
      if (mounted) _stop();
    });
  }

  String _format(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    if (h > 0) return '${h}h ${m}m';
    if (m > 0) return '${m}m ${s}s';
    return '${s}s';
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context).s;
    final activeBg = _current?.color ?? const Color(0xFF2C3E50);

    return Scaffold(
      backgroundColor: activeBg,
      body: SafeArea(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
              title: Text(
                _current == null ? l.whiteNoise : '${_current!.categoryName} · ${_current!.name}',
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
              ),
              actions: [
                if (_current != null)
                  TextButton.icon(
                    onPressed: _stop,
                    icon: const Icon(Icons.stop_circle_outlined, color: Colors.white70, size: 20),
                    label: const Text('退出播放', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  ),
              ],
            ),
            if (_current != null)
              Expanded(child: _buildPlaying(l))
            else
              Expanded(child: _buildSelector(l)),
          ],
        ),
      ),
    );
  }

  Widget _buildSelector(AppL10nStrings l) {
    final filteredCategories = _selectedCategoryFilter == 'all'
        ? _categories
        : _categories.where((c) => c.id == _selectedCategoryFilter).toList();

    return Column(
      children: [
        // 顶部简明导言
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: Column(
            children: [
              Text(
                '选择声音，沉浸放松',
                style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 4),
              Text(
                '7 大常用自然分类，每类精选 2 款高质音效',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ),

        // 分类快捷标签导航 (全部、雨声、森林、海洋、壁炉、微风、白噪、助眠)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _buildCategoryChip('all', '全部', Icons.grid_view_rounded),
              ..._categories.map((c) => _buildCategoryChip(c.id, c.name, c.icon)),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // 分类声音列表
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            itemCount: filteredCategories.length,
            itemBuilder: (context, index) {
              final cat = filteredCategories[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 分类标题
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: cat.color.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(cat.icon, color: Colors.white, size: 16),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          cat.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '2 款音频',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // 该分类下的 2 个音频卡片
                    Row(
                      children: cat.sounds.map((sound) {
                        final isPlaying = _current?.id == sound.id;
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: _SoundCard(
                              sound: sound,
                              isPlaying: isPlaying,
                              onTap: () => _toggle(sound),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(String id, String label, IconData icon) {
    final isSelected = _selectedCategoryFilter == id;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        avatar: Icon(
          icon,
          size: 15,
          color: isSelected ? Colors.black87 : Colors.white70,
        ),
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black87 : Colors.white,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        onSelected: (_) {
          setState(() {
            _selectedCategoryFilter = id;
          });
        },
        backgroundColor: Colors.white.withValues(alpha: 0.12),
        selectedColor: Colors.white,
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide.none,
      ),
    );
  }

  Widget _buildPlaying(AppL10nStrings l) {
    final sound = _current!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.spacingLg),
      child: Column(
        children: [
          const SizedBox(height: 24),
          // 声波核心动效
          SizedBox(
            width: 200,
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                ),
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.25),
                        blurRadius: 24,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Icon(sound.icon, size: 44, color: sound.color),
                ),
                Positioned.fill(
                  child: CustomPaint(
                    painter: _WaveRingPainter(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Text(
            sound.name,
            style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            '${sound.categoryName} · ${sound.description}',
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 20),

          // 播放计时
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.timer_rounded, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Text(
                  '${l.playDuration}: ${_format(_elapsed)}',
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 控制按钮组
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ControlBtn(
                icon: Icons.stop_rounded,
                label: l.stop,
                onTap: _stop,
              ),
              _ControlBtn(
                icon: _expanded ? Icons.expand_less_rounded : Icons.tune_rounded,
                label: _expanded ? l.collapse : '调节',
                onTap: () => setState(() => _expanded = !_expanded),
              ),
              _ControlBtn(
                icon: _looping ? Icons.loop_rounded : Icons.repeat_one_rounded,
                label: _looping ? l.looping : l.singlePlay,
                onTap: () => setState(() => _looping = !_looping),
              ),
            ],
          ),

          if (_expanded) ...[
            const SizedBox(height: 20),
            // 音量与定时器面板
            Container(
              padding: const EdgeInsets.all(AppDimens.spacingMd),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.volume_down_rounded, color: Colors.white70, size: 18),
                      Expanded(
                        child: Slider(
                          value: _volume,
                          onChanged: _setVolume,
                          activeColor: Colors.white,
                          inactiveColor: Colors.white.withValues(alpha: 0.25),
                        ),
                      ),
                      const Icon(Icons.volume_up_rounded, color: Colors.white70, size: 18),
                    ],
                  ),
                  const Divider(color: Colors.white12, height: 20),
                  Text(
                    l.sleepTimer,
                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [0, 5, 10, 15, 30, 60].map((m) {
                      final sel = _sleepAfter.inMinutes == m;
                      return ChoiceChip(
                        label: Text(m == 0 ? l.noLimit : '$m${l.minute}'),
                        selected: sel,
                        onSelected: (_) {
                          setState(() => _sleepAfter = Duration(minutes: m));
                          _scheduleStop();
                        },
                        selectedColor: Colors.white,
                        backgroundColor: Colors.white.withValues(alpha: 0.15),
                        labelStyle: TextStyle(
                          color: sel ? sound.color : Colors.white,
                          fontSize: 12,
                          fontWeight: sel ? FontWeight.w600 : FontWeight.normal,
                        ),
                        side: BorderSide.none,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),

          // 快速切换同一分类或其它声音
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '切换声音 (7 类共 14 款)',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _allSounds.map((s) {
              final isCurrent = s.id == sound.id;
              return ActionChip(
                avatar: Icon(
                  s.icon,
                  color: isCurrent ? sound.color : Colors.white,
                  size: 15,
                ),
                label: Text(
                  '${s.categoryName}·${s.name}',
                  style: TextStyle(
                    color: isCurrent ? sound.color : Colors.white,
                    fontSize: 12,
                    fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                backgroundColor: isCurrent ? Colors.white : Colors.white.withValues(alpha: 0.16),
                side: BorderSide.none,
                onPressed: () => _toggle(s),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _WaveRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = Colors.white.withValues(alpha: 0.18);
    for (int i = 0; i < 3; i++) {
      canvas.drawCircle(center, 90 + i * 26, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _SoundCard extends StatelessWidget {
  final WhiteNoise sound;
  final bool isPlaying;
  final VoidCallback onTap;

  const _SoundCard({
    required this.sound,
    required this.isPlaying,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isPlaying
              ? Colors.white.withValues(alpha: 0.28)
              : Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isPlaying ? Colors.white : Colors.white.withValues(alpha: 0.1),
            width: isPlaying ? 1.5 : 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  sound.icon,
                  color: Colors.white,
                  size: 20,
                ),
                const Spacer(),
                Icon(
                  isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              sound.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              sound.description,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 11,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _ControlBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ControlBtn({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(height: 3),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
