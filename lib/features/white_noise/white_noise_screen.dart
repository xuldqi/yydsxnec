// 白噪音页 (对应 Android WhiteNoiseActivity + item_white_noise)
// audioplayers 播放 4 个 wav，呼吸圆环动画，时间选择器

import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/app_l10n_ext.dart';

class WhiteNoise {
  final String id, name, asset, description;
  final Color color;
  final IconData icon;
  const WhiteNoise({required this.id, required this.name, required this.asset, required this.description,
    required this.color, required this.icon});
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

  static const _noises = <WhiteNoise>[
    WhiteNoise(id: 'rain', name: '雨声', asset: 'audio/noise_rain.mp3',
      description: '柔和雨滴声，助眠放松', color: AppColors.info, icon: Icons.umbrella_rounded),
    WhiteNoise(id: 'fire', name: '壁炉', asset: 'audio/noise_fire.mp3',
      description: '篝火燃烧的温暖声音', color: AppColors.warning, icon: Icons.local_fire_department_rounded),
    WhiteNoise(id: 'waves', name: '海浪', asset: 'audio/noise_waves.mp3',
      description: '轻柔海浪拍岸声', color: AppColors.sportOther, icon: Icons.waves_rounded),
    WhiteNoise(id: 'wind', name: '风声', asset: 'audio/noise_wind.mp3',
      description: '微风轻拂的白噪音', color: AppColors.sportOther, icon: Icons.air_rounded),
  ];

  @override
  void initState() {
    super.initState();
    _player.setReleaseMode(ReleaseMode.loop);
    _player.onPlayerComplete.listen((_) {
      if (_looping) _player.play(AssetSource(_current!.asset));
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
    return Scaffold(
      backgroundColor: _current?.color ?? AppColors.sportOther,
      body: SafeArea(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
              title: Text(l.whiteNoise, style: const TextStyle(color: Colors.white)),
            ),
            if (_current != null) Expanded(child: _buildPlaying(l)) else Expanded(child: _buildSelector(l)),
          ],
        ),
      ),
    );
  }

  Widget _buildSelector(AppL10nStrings l) {
    return ListView(
      padding: const EdgeInsets.all(AppDimens.spacingLg),
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Center(
            child: Column(
              children: [
                Text('🌙', style: TextStyle(fontSize: 56)),
                SizedBox(height: 12),
                Text('选择一种声音，开始放松',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                SizedBox(height: 4),
                Text('白噪音可帮助集中注意力或入眠',
                  style: TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
        ),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.1,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: _noises.map((n) => _NoiseCard(noise: n, onTap: () => _toggle(n))).toList(),
        ),
        const SizedBox(height: 20),
        if (_current == null) Container(
          padding: const EdgeInsets.all(AppDimens.spacingSm),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.lightbulb_outline_rounded, color: Colors.white70, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(l.whiteNoiseSubtitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlaying(AppL10nStrings l) {
    final noise = _current!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.spacingLg),
      child: Column(
        children: [
          const SizedBox(height: 40),
          // 声波动画
          SizedBox(
            width: 220, height: 220,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 220, height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                Container(
                  width: 160, height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                ),
                Container(
                  width: 100, height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.3),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(noise.icon, size: 48, color: noise.color),
                ),
                // 装饰圆环
                Positioned.fill(
                  child: CustomPaint(
                    painter: _WaveRingPainter(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text(noise.name,
            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(noise.description, style: const TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 24),
          // 计时
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.timer_rounded, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text('${l.playDuration}: ${_format(_elapsed)}',
                  style: const TextStyle(color: Colors.white, fontSize: 14)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // 控制
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ControlBtn(
                icon: Icons.stop_rounded,
                label: l.stop,
                onTap: _stop,
              ),
              _ControlBtn(
                icon: _expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                label: _expanded ? l.collapse : l.more,
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
            const SizedBox(height: 24),
            // 音量
            Container(
              padding: const EdgeInsets.all(AppDimens.spacingMd),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.volume_down_rounded, color: Colors.white, size: 20),
                      Expanded(
                        child: Slider(
                          value: _volume,
                          onChanged: _setVolume,
                          activeColor: Colors.white,
                          inactiveColor: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                      const Icon(Icons.volume_up_rounded, color: Colors.white, size: 20),
                    ],
                  ),
                  const Divider(color: Colors.white24, height: 24),
                  Text(l.sleepTimer, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
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
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        labelStyle: TextStyle(
                          color: sel ? noise.color : Colors.white,
                          fontSize: 12,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // 切换声音
            Wrap(
              spacing: 8,
              children: _noises.where((n) => n.id != noise.id).map((n) {
                return ActionChip(
                  avatar: Icon(n.icon, color: Colors.white, size: 16),
                  label: Text(n.name, style: const TextStyle(color: Colors.white, fontSize: 12)),
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  onPressed: () => _toggle(n),
                );
              }).toList(),
            ),
          ],
          const SizedBox(height: 40),
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
      ..strokeWidth = 1.5
      ..color = Colors.white.withValues(alpha: 0.2);
    for (int i = 0; i < 3; i++) {
      canvas.drawCircle(center, 110 + i * 30, paint);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _NoiseCard extends StatelessWidget {
  final WhiteNoise noise;
  final VoidCallback onTap;
  const _NoiseCard({required this.noise, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.radiusCard),
      child: Container(
        padding: const EdgeInsets.all(AppDimens.spacingMd),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(AppDimens.radiusCard),
          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(noise.icon, color: Colors.white, size: 36),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(noise.name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(noise.description, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
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
  const _ControlBtn({required this.icon, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
