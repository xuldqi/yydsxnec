// 计时器页 (对应 Android CountTimeActivity + SubMiaoBiaoFragment + SubCountTimeFragment)
// 包含: 1. 秒表计时 (记次、暂停、复位)
//       2. 倒计时 (预设: 煮面、呼吸放松、训练组歇、敷面膜、小憩 + 自定义时长)

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';

class CountTimeScreen extends ConsumerStatefulWidget {
  final String? type;
  final String? goal;
  const CountTimeScreen({super.key, this.type, this.goal});

  @override
  ConsumerState<CountTimeScreen> createState() => _CountTimeScreenState();
}

class _CountTimeScreenState extends ConsumerState<CountTimeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // --- 秒表属性 (SubMiaoBiaoFragment) ---
  Timer? _stopwatchTimer;
  Duration _stopwatchElapsed = Duration.zero;
  bool _stopwatchRunning = false;
  final List<Duration> _laps = [];

  // --- 倒计时属性 (SubCountTimeFragment) ---
  Timer? _countdownTimer;
  int _totalCountdownSeconds = 300; // 默认 5分钟 (如煮面)
  int _remainingSeconds = 300;
  bool _countdownRunning = false;
  String _currentPresetName = '煮面';

  final List<Map<String, dynamic>> _presets = [
    {'name': '煮面', 'seconds': 300, 'icon': Icons.ramen_dining},
    {'name': '呼吸放松', 'seconds': 180, 'icon': Icons.self_improvement},
    {'name': '训练组歇', 'seconds': 90, 'icon': Icons.fitness_center},
    {'name': '敷面膜', 'seconds': 900, 'icon': Icons.face_retouching_natural},
    {'name': '午间小憩', 'seconds': 1800, 'icon': Icons.bedtime},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _stopwatchTimer?.cancel();
    _countdownTimer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  // --- 秒表逻辑 ---
  void _toggleStopwatch() {
    if (_stopwatchRunning) {
      _stopwatchTimer?.cancel();
      setState(() => _stopwatchRunning = false);
    } else {
      setState(() => _stopwatchRunning = true);
      _stopwatchTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
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

  // --- 倒计时逻辑 ---
  void _selectPreset(String name, int seconds) {
    _countdownTimer?.cancel();
    setState(() {
      _currentPresetName = name;
      _totalCountdownSeconds = seconds;
      _remainingSeconds = seconds;
      _countdownRunning = false;
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
        title: Row(
          children: [
            const Icon(Icons.alarm_on, color: AppColors.primary, size: 28),
            const SizedBox(width: 8),
            Text('「$_currentPresetName」时间到！'),
          ],
        ),
        content: const Text('倒计时已顺利结束，请进行下一步安排~'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('好的', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('多功能计时器', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF111827),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: const Color(0xFF6B7280),
          indicatorColor: AppColors.primary,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          tabs: const [
            Tab(text: '倒计时 (煮面/放松等)'),
            Tab(text: '秒表计时'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCountdownTab(),
          _buildStopwatchTab(),
        ],
      ),
    );
  }

  // --- 1. 倒计时 Tab ---
  Widget _buildCountdownTab() {
    final progress = _totalCountdownSeconds > 0
        ? (_remainingSeconds / _totalCountdownSeconds).clamp(0.0, 1.0)
        : 0.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // 快捷预设场景列表 (煮面 / 呼吸放松 / 训练组歇等)
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '日常预设场景',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[700]),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _presets.map((p) {
              final isSelected = _currentPresetName == p['name'];
              return ChoiceChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(p['icon'] as IconData, size: 16, color: isSelected ? Colors.white : AppColors.primary),
                    const SizedBox(width: 6),
                    Text(p['name'] as String),
                  ],
                ),
                selected: isSelected,
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF374151),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                backgroundColor: Colors.white,
                onSelected: (_) => _selectPreset(p['name'] as String, p['seconds'] as int),
              );
            }).toList(),
          ),

          const SizedBox(height: 36),

          // 圆环倒计时表盘
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 230,
                height: 230,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 10,
                  backgroundColor: const Color(0xFFE5E7EB),
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _currentPresetName,
                    style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _formatCountdown(_remainingSeconds),
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      fontFeatures: [FontFeature.tabularFigures()],
                      color: Color(0xFF111827),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 40),

          // 操作按钮组
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _resetCountdown,
                icon: const Icon(Icons.refresh),
                label: const Text('重置'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF374151),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
              ),
              const SizedBox(width: 20),
              ElevatedButton.icon(
                onPressed: _toggleCountdown,
                icon: Icon(_countdownRunning ? Icons.pause : Icons.play_arrow),
                label: Text(_countdownRunning ? '暂停' : '开始'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- 2. 秒表计时 Tab ---
  Widget _buildStopwatchTab() {
    return Column(
      children: [
        const SizedBox(height: 36),
        Text(
          _formatDuration(_stopwatchElapsed),
          style: const TextStyle(
            fontSize: 54,
            fontWeight: FontWeight.bold,
            fontFeatures: [FontFeature.tabularFigures()],
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 28),

        // 控制按钮
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _stopwatchRunning ? _recordLap : _resetStopwatch,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF374151),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: Text(_stopwatchRunning ? '计次' : '复位'),
            ),
            const SizedBox(width: 24),
            ElevatedButton.icon(
              onPressed: _toggleStopwatch,
              icon: Icon(_stopwatchRunning ? Icons.pause : Icons.play_arrow),
              label: Text(_stopwatchRunning ? '暂停' : '开始'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _stopwatchRunning ? const Color(0xFFEF4444) : AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),
        const Divider(height: 1),

        // 计次记录列表
        Expanded(
          child: _laps.isEmpty
              ? const Center(child: Text('暂无计次记录', style: TextStyle(color: Colors.grey)))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _laps.length,
                  separatorBuilder: (context, idx) => const Divider(height: 1),
                  itemBuilder: (context, idx) {
                    final lapIndex = _laps.length - idx;
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 14,
                        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                        child: Text('$lapIndex', style: const TextStyle(fontSize: 12, color: AppColors.primary)),
                      ),
                      title: Text('第 $lapIndex 次记录'),
                      trailing: Text(
                        _formatDuration(_laps[idx]),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
