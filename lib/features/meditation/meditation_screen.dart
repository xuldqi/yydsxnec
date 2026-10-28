import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/app_l10n_ext.dart';

class MeditationScene {
  final String id, name, description;
  final int minutes;
  final Color color;
  final IconData icon;
  const MeditationScene(
      {required this.id,
      required this.name,
      required this.description,
      required this.minutes,
      required this.color,
      required this.icon});
}

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});
  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen>
    with TickerProviderStateMixin {
  late final AnimationController _breathCtrl;
  Timer? _timer;
  MeditationScene? _activeScene;
  Duration _remaining = Duration.zero;
  Duration _total = Duration.zero;
  bool _running = false;
  bool _paused = false;

  static const _scenes = <MeditationScene>[
    MeditationScene(
        id: 'breath',
        name: '呼吸练习',
        description: '专注于呼吸节奏',
        minutes: 5,
        color: Color(0xFF6366F1),
        icon: Icons.air_rounded),
    MeditationScene(
        id: 'body',
        name: '身体扫描',
        description: '感受身体每一部分',
        minutes: 10,
        color: Color(0xFF0EA5E9),
        icon: Icons.accessibility_new_rounded),
    MeditationScene(
        id: 'sleep',
        name: '睡前冥想',
        description: '帮助入睡',
        minutes: 15,
        color: Color(0xFF818CF8),
        icon: Icons.bedtime_rounded),
    MeditationScene(
        id: 'focus',
        name: '专注冥想',
        description: '提升专注力',
        minutes: 8,
        color: Color(0xFF10B981),
        icon: Icons.center_focus_strong_rounded),
    MeditationScene(
        id: 'morning',
        name: '晨间冥想',
        description: '开启美好一天',
        minutes: 5,
        color: Color(0xFFF59E0B),
        icon: Icons.wb_sunny_rounded),
    MeditationScene(
        id: 'free',
        name: '自由冥想',
        description: '不计时',
        minutes: 0,
        color: Color(0xFFEC4899),
        icon: Icons.self_improvement_rounded),
  ];

  @override
  void initState() {
    super.initState();
    _breathCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _breathCtrl.dispose();
    super.dispose();
  }

  void _start(MeditationScene scene) {
    setState(() {
      _activeScene = scene;
      _total = Duration(minutes: scene.minutes);
      _remaining = _total;
      _running = true;
      _paused = false;
    });

    if (scene.minutes > 0) {
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (!_paused) {
          setState(() {
            if (_remaining.inSeconds > 0) {
              _remaining -= const Duration(seconds: 1);
            } else {
              _timer?.cancel();
              _running = false;
              _showDoneDialog();
            }
          });
        }
      });
    }
  }

  void _stop() {
    _timer?.cancel();
    setState(() {
      _running = false;
      _paused = false;
    });
  }

  void _togglePause() {
    setState(() => _paused = !_paused);
  }

  void _showDoneDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Row(children: [
          Icon(Icons.check_circle, color: Color(0xFF10B981), size: 28),
          SizedBox(width: 12),
          Text('冥想完成', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E1B4B))),
        ]),
        content: const Text('恭喜您完成本次冥想，坚持就是胜利！', style: TextStyle(color: Color(0xFF64748B))),
        actions: [
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFF6366F1)),
            onPressed: () => Navigator.pop(context),
            child: const Text('好的'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context).s;
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F8),
      body: Container(
        decoration: BoxDecoration(
          gradient: _running
              ? LinearGradient(
                  colors: [_activeScene?.color ?? const Color(0xFF6366F1), const Color(0xFF1E1B4B)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)
              : const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFEFEBFA), Color(0xFFF3F4F8), Color(0xFFEBEFF9)],
                ),
        ),
        child: SafeArea(
          child: _running ? _buildRunningView(l) : _buildSceneList(l),
        ),
      ),
    );
  }

  Widget _buildSceneList(AppL10nStrings l) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('放松冥想', style: TextStyle(color: Color(0xFF1E1B4B), fontWeight: FontWeight.w900, fontSize: 24)),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined, color: Color(0xFF6366F1)),
              onPressed: () => _showSettings(),
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Container(
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(color: Color(0x0A000000), blurRadius: 16, offset: Offset(0, 4)),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _breathCtrl,
                    builder: (_, __) => Container(
                      width: 80 + _breathCtrl.value * 30,
                      height: 80 + _breathCtrl.value * 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                      ),
                    ),
                  ),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.self_improvement_rounded, size: 36, color: Color(0xFF6366F1)),
                      SizedBox(height: 8),
                      Text('深呼吸，专注于当下', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E1B4B))),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 110),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 1.1,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final s = _scenes[index];
                return GestureDetector(
                  onTap: () => _start(s),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: const [
                        BoxShadow(color: Color(0x0A000000), blurRadius: 14, offset: Offset(0, 4)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: s.color.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(s.icon, color: s.color, size: 22),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1B4B))),
                            const SizedBox(height: 2),
                            Text(s.description, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                            const SizedBox(height: 4),
                            Text(s.minutes > 0 ? '${s.minutes} 分钟' : '自由', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: s.color)),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: _scenes.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRunningView(AppL10nStrings l) {
    final s = _activeScene!;
    final mins = _remaining.inMinutes;
    final secs = _remaining.inSeconds % 60;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: _stop),
              Text(s.name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(width: 48),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation: _breathCtrl,
                  builder: (_, __) => Container(
                    width: 200 + _breathCtrl.value * 50,
                    height: 200 + _breathCtrl.value * 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (s.minutes > 0)
                      Text(
                        '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}',
                        style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Colors.white),
                      )
                    else
                      const Icon(Icons.self_improvement, size: 64, color: Colors.white),
                    const SizedBox(height: 12),
                    Text(_paused ? '已暂停' : '深呼吸...', style: const TextStyle(color: Colors.white70, fontSize: 16)),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 60),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                onPressed: _togglePause,
                backgroundColor: Colors.white,
                child: Icon(_paused ? Icons.play_arrow : Icons.pause, color: s.color),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('冥想设置', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1B4B))),
            SizedBox(height: 16),
            ListTile(leading: Icon(Icons.volume_up, color: Color(0xFF6366F1)), title: Text('背景音乐'), trailing: Switch(value: true, onChanged: null)),
            ListTile(leading: Icon(Icons.vibration, color: Color(0xFF6366F1)), title: Text('震动提醒'), trailing: Switch(value: true, onChanged: null)),
          ],
        ),
      ),
    );
  }
}
