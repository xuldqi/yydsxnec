// 计时器页 (OtterLife 治愈极简温润风格)
// 包含:
// 1. 倒计时 (场景选择: 煮面、呼吸放松、训练组歇、敷面膜、午间小憩、专注番茄 + 快速增减时长)
// 2. 运动秒表 (分段计次、最佳圈速标记、重置复位)

import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CountTimeScreen extends ConsumerStatefulWidget {
  final String? type;
  final String? goal;
  const CountTimeScreen({super.key, this.type, this.goal});

  @override
  ConsumerState<CountTimeScreen> createState() => _CountTimeScreenState();
}

class _CountTimeScreenState extends ConsumerState<CountTimeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedTabIndex = 0; // 0: 倒计时, 1: 秒表

  // ── 秒表属性 ──────────────────────────────────────────────────────────
  Timer? _stopwatchTimer;
  Duration _stopwatchElapsed = Duration.zero;
  bool _stopwatchRunning = false;
  final List<Duration> _laps = [];

  // ── 倒计时属性 ────────────────────────────────────────────────────────
  Timer? _countdownTimer;
  int _totalCountdownSeconds = 300; // 默认 5分钟 (煮面)
  int _remainingSeconds = 300;
  bool _countdownRunning = false;
  String _currentPresetName = '煮面';
  Color _currentPresetColor = const Color(0xFFEA580C);
  IconData _currentPresetIcon = Icons.ramen_dining_rounded;

  final List<Map<String, dynamic>> _presets = [
    {
      'name': '煮面',
      'desc': '5分钟',
      'seconds': 300,
      'icon': Icons.ramen_dining_rounded,
      'color': const Color(0xFFEA580C),
    },
    {
      'name': '呼吸放松',
      'desc': '3分钟',
      'seconds': 180,
      'icon': Icons.self_improvement_rounded,
      'color': const Color(0xFF10B981),
    },
    {
      'name': '训练组歇',
      'desc': '90秒',
      'seconds': 90,
      'icon': Icons.fitness_center_rounded,
      'color': const Color(0xFF8D5B4C),
    },
    {
      'name': '敷面膜',
      'desc': '15分钟',
      'seconds': 900,
      'icon': Icons.face_retouching_natural_rounded,
      'color': const Color(0xFFEC4899),
    },
    {
      'name': '午间小憩',
      'desc': '30分钟',
      'seconds': 1800,
      'icon': Icons.bedtime_rounded,
      'color': const Color(0xFF6366F1),
    },
    {
      'name': '专注番茄',
      'desc': '25分钟',
      'seconds': 1500,
      'icon': Icons.timer_rounded,
      'color': const Color(0xFFE11D48),
    },
  ];

  @override
  void initState() {
    super.initState();
    if (widget.type != null) {
      final query = widget.type!;
      final match = _presets.firstWhere(
        (p) => p['name'] == query,
        orElse: () => {},
      );
      if (match.isNotEmpty) {
        _currentPresetName = match['name'] as String;
        _totalCountdownSeconds = match['seconds'] as int;
        _remainingSeconds = _totalCountdownSeconds;
        _currentPresetColor = match['color'] as Color;
        _currentPresetIcon = match['icon'] as IconData;
        _selectedTabIndex = 0;
      } else if (query == 'stopwatch' ||
          query == '秒表' ||
          query == '户外跑' ||
          query == 'running' ||
          query == 'sport') {
        _selectedTabIndex = 1;
      }
    }
  }

  @override
  void dispose() {
    _stopwatchTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  // ── 秒表控制逻辑 ──────────────────────────────────────────────────────
  void _toggleStopwatch() {
    if (_stopwatchRunning) {
      _stopwatchTimer?.cancel();
      setState(() => _stopwatchRunning = false);
    } else {
      setState(() => _stopwatchRunning = true);
      _stopwatchTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
        if (!mounted) return;
        setState(() {
          _stopwatchElapsed += const Duration(milliseconds: 100);
        });
      });
    }
  }

  void _recordLap() {
    if (_stopwatchElapsed > Duration.zero) {
      setState(() {
        _laps.insert(0, _stopwatchElapsed);
      });
    }
  }

  void _resetStopwatch() {
    _stopwatchTimer?.cancel();
    setState(() {
      _stopwatchRunning = false;
      _stopwatchElapsed = Duration.zero;
      _laps.clear();
    });
  }

  // ── 倒计时控制逻辑 ────────────────────────────────────────────────────
  void _selectPreset(Map<String, dynamic> p) {
    _countdownTimer?.cancel();
    setState(() {
      _currentPresetName = p['name'] as String;
      _totalCountdownSeconds = p['seconds'] as int;
      _remainingSeconds = _totalCountdownSeconds;
      _currentPresetColor = p['color'] as Color;
      _currentPresetIcon = p['icon'] as IconData;
      _countdownRunning = false;
    });
  }

  void _adjustTime(int deltaSeconds) {
    _countdownTimer?.cancel();
    setState(() {
      _countdownRunning = false;
      final newRemaining = (_remainingSeconds + deltaSeconds).clamp(10, 7200);
      _remainingSeconds = newRemaining;
      if (newRemaining > _totalCountdownSeconds) {
        _totalCountdownSeconds = newRemaining;
      }
    });
  }

  void _toggleCountdown() {
    if (_countdownRunning) {
      _countdownTimer?.cancel();
      setState(() => _countdownRunning = false);
    } else {
      if (_remainingSeconds <= 0) {
        _remainingSeconds = _totalCountdownSeconds;
      }
      setState(() => _countdownRunning = true);
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) return;
        if (_remainingSeconds > 0) {
          setState(() => _remainingSeconds--);
        } else {
          timer.cancel();
          setState(() => _countdownRunning = false);
          _showTimeUpDialog();
        }
      });
    }
  }

  void _resetCountdown() {
    _countdownTimer?.cancel();
    setState(() {
      _countdownRunning = false;
      _remainingSeconds = _totalCountdownSeconds;
    });
  }

  void _showTimeUpDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFFFAF3EE),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFECE4D8), width: 1.5),
              ),
              child: const Icon(
                Icons.alarm_on_rounded,
                color: Color(0xFF8D5B4C),
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '「$_currentPresetName」已完成',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2D2522),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '计时倒计时已结束，请进行下一步安排~',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF8C7E77),
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8D5B4C),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  '知道了',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatStopwatch(Duration d) {
    final mins = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final secs = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final millis = (d.inMilliseconds.remainder(1000) ~/ 100).toString();
    return '$mins:$secs.$millis';
  }

  String _formatCountdown(int totalSecs) {
    final mins = (totalSecs ~/ 60).toString().padLeft(2, '0');
    final secs = (totalSecs % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  // ── 构建界面 ──────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F8),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildCustomAppBar(context),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _selectedTabIndex == 0
                    ? _buildCountdownView()
                    : _buildStopwatchView(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── 顶部导航栏 (返回键 + 暖色胶囊分段器) ───────────────────────────────
  Widget _buildCustomAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/sport');
              }
            },
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFECE4D8), width: 1.0),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x067A533E),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: Color(0xFF2D2522),
              ),
            ),
          ),
          // 胶囊选项卡
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFE8E0D7),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTabPill(index: 0, title: '倒计时'),
                _buildTabPill(index: 1, title: '运动秒表'),
              ],
            ),
          ),
          // 占位对称保持居中
          const SizedBox(width: 42),
        ],
      ),
    );
  }

  Widget _buildTabPill({required int index, required String title}) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTabIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? const [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected ? const Color(0xFF8D5B4C) : const Color(0xFF7D726D),
          ),
        ),
      ),
    );
  }

  // ── 1. 倒计时视图 ─────────────────────────────────────────────────────
  Widget _buildCountdownView() {
    final progress = _totalCountdownSeconds > 0
        ? (_remainingSeconds / _totalCountdownSeconds).clamp(0.0, 1.0)
        : 0.0;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 计时场景列表 (横向卡片)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 4, bottom: 10),
                child: Text(
                  '选择计时场景',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2D2522),
                  ),
                ),
              ),
              SizedBox(
                height: 72,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _presets.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final p = _presets[index];
                    final isSelected = _currentPresetName == p['name'];
                    return GestureDetector(
                      onTap: () => _selectPreset(p),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFFAF3EE)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF8D5B4C)
                                : const Color(0xFFECE4D8),
                            width: isSelected ? 1.6 : 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isSelected
                                  ? const Color(0x128D5B4C)
                                  : const Color(0x067A533E),
                              blurRadius: isSelected ? 10 : 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: (p['color'] as Color)
                                    .withValues(alpha: isSelected ? 0.2 : 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                p['icon'] as IconData,
                                size: 20,
                                color: p['color'] as Color,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  p['name'] as String,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isSelected
                                        ? FontWeight.w800
                                        : FontWeight.w600,
                                    color: isSelected
                                        ? const Color(0xFF8D5B4C)
                                        : const Color(0xFF2D2522),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  p['desc'] as String,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: isSelected
                                        ? const Color(0xFF8D5B4C)
                                            .withValues(alpha: 0.8)
                                        : const Color(0xFF8C7E77),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // 核心倒计时表盘卡片
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: const Color(0xFFECE4D8), width: 1.0),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x087A533E),
                  blurRadius: 18,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // 环形进度
                SizedBox(
                  width: 230,
                  height: 230,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        size: const Size(230, 230),
                        painter: _TimerRingPainter(
                          progress: progress,
                          trackColor: const Color(0xFFF1EBE4),
                          progressColor: _currentPresetColor,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: _currentPresetColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _currentPresetIcon,
                                  size: 14,
                                  color: _currentPresetColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _currentPresetName,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: _currentPresetColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _formatCountdown(_remainingSeconds),
                            style: const TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -1.0,
                              fontFeatures: [FontFeature.tabularFigures()],
                              color: Color(0xFF2D2522),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _countdownRunning
                                      ? const Color(0xFF10B981)
                                      : const Color(0xFFB8ACA4),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _countdownRunning
                                    ? '进行中'
                                    : (_remainingSeconds == _totalCountdownSeconds
                                        ? '就绪'
                                        : '已暂停'),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF8C7E77),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 快速加减时长调节按钮
                Wrap(
                  spacing: 8,
                  children: [
                    _buildTimeAdjustChip('-1分', () => _adjustTime(-60)),
                    _buildTimeAdjustChip('+1分', () => _adjustTime(60)),
                    _buildTimeAdjustChip('+5分', () => _adjustTime(300)),
                    _buildTimeAdjustChip('+10分', () => _adjustTime(600)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 底部控制按钮组
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 重置按钮
              GestureDetector(
                onTap: _resetCountdown,
                child: Container(
                  height: 54,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: const Color(0xFFECE4D8), width: 1.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x067A533E),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.refresh_rounded,
                          size: 19, color: Color(0xFF7D726D)),
                      SizedBox(width: 6),
                      Text(
                        '重置',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2D2522),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 14),

              // 主开始/暂停按钮
              Expanded(
                child: GestureDetector(
                  onTap: _toggleCountdown,
                  child: Container(
                    height: 54,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8D5B4C),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x288D5B4C),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _countdownRunning
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          size: 24,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _countdownRunning ? '暂停计时' : '开始计时',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeAdjustChip(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFFAF7F5),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFECE4D8), width: 0.8),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF8D5B4C),
          ),
        ),
      ),
    );
  }

  // ── 2. 运动秒表视图 ───────────────────────────────────────────────────
  Widget _buildStopwatchView() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: const Color(0xFFECE4D8), width: 1.0),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x087A533E),
                  blurRadius: 18,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // 运行状态指示
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _stopwatchRunning
                            ? const Color(0xFF10B981)
                            : const Color(0xFFB8ACA4),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _stopwatchRunning
                          ? '秒表运行中'
                          : (_stopwatchElapsed == Duration.zero ? '就绪' : '已暂停'),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF8C7E77),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // 巨大数字时间显示
                Text(
                  _formatStopwatch(_stopwatchElapsed),
                  style: const TextStyle(
                    fontSize: 54,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1.0,
                    fontFeatures: [FontFeature.tabularFigures()],
                    color: Color(0xFF2D2522),
                  ),
                ),

                const SizedBox(height: 28),

                // 控制按钮组
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 计次 / 复位
                    GestureDetector(
                      onTap: _stopwatchRunning ? _recordLap : _resetStopwatch,
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 26),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAF7F5),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: const Color(0xFFECE4D8), width: 1.0),
                        ),
                        child: Center(
                          child: Text(
                            _stopwatchRunning ? '分段计次' : '复位清零',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2D2522),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 14),

                    // 开始 / 暂停
                    GestureDetector(
                      onTap: _toggleStopwatch,
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 36),
                        decoration: BoxDecoration(
                          color: _stopwatchRunning
                              ? const Color(0xFFDC2626)
                              : const Color(0xFF8D5B4C),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: (_stopwatchRunning
                                      ? const Color(0xFFDC2626)
                                      : const Color(0xFF8D5B4C))
                                  .withValues(alpha: 0.25),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _stopwatchRunning
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                                size: 20,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _stopwatchRunning ? '暂停' : '启动',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // 计次记录列表
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 24),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFECE4D8), width: 1.0),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x067A533E),
                  blurRadius: 12,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: _laps.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.timer_outlined,
                          size: 42,
                          color: Color(0xFFD6CBC3),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '暂无计次记录',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF8C7E77),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '启动秒表后点击「分段计次」记录圈速',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFFB8ACA4),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: _laps.length,
                    separatorBuilder: (_, _) =>
                        const Divider(height: 1, color: Color(0xFFF1EBE4)),
                    itemBuilder: (context, idx) {
                      final lapNum = _laps.length - idx;
                      final lapTime = _laps[idx];

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFAF3EE),
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: const Color(0xFFECE4D8), width: 0.8),
                              ),
                              child: Center(
                                child: Text(
                                  '#$lapNum',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF8D5B4C),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '分段 $lapNum',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2D2522),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              _formatStopwatch(lapTime),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                fontFeatures: [FontFeature.tabularFigures()],
                                color: Color(0xFF2D2522),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}

// ── 倒计时平滑进度环绘制器 ──────────────────────────────────────────────
class _TimerRingPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color progressColor;

  _TimerRingPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 16) / 2;
    const strokeWidth = 10.0;

    // 底环
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, trackPaint);

    // 进度环
    if (progress > 0) {
      final progressPaint = Paint()
        ..color = progressColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      final sweepAngle = 2 * math.pi * progress;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _TimerRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.trackColor != trackColor;
  }
}
