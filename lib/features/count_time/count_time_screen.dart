// 计时器页 (OtterLife 治愈极简温润风格)
// 包含:
// 1. 倒计时 (场景选择: 内置预设 + 自定义创建计时、快速增减时长)
// 2. 运动秒表 (分段计次、最佳圈速标记、重置复位)

import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'count_time_presets_provider.dart';

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
  String _currentPresetId = 'default_noodle';
  String _currentPresetName = '煮面';
  Color _currentPresetColor = const Color(0xFFEA580C);
  IconData _currentPresetIcon = Icons.ramen_dining_rounded;

  @override
  void initState() {
    super.initState();
    if (widget.type != null) {
      final query = widget.type!;
      if (query == 'stopwatch' ||
          query == '秒表' ||
          query == '户外跑' ||
          query == 'running' ||
          query == 'sport') {
        _selectedTabIndex = 1;
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _applyInitialType();
      if (widget.type == 'create') {
        _showCreateCustomPresetSheet(context);
      }
    });
  }

  void _applyInitialType() {
    if (widget.type == null) return;
    final query = widget.type!;
    final presets = ref.read(countTimePresetsProvider);
    final match = presets.where((p) => p.name == query || p.id == query).firstOrNull;
    if (match != null) {
      _selectPreset(match);
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
  void _selectPreset(CountTimePreset p) {
    _countdownTimer?.cancel();
    setState(() {
      _currentPresetId = p.id;
      _currentPresetName = p.name;
      _totalCountdownSeconds = p.seconds;
      _remainingSeconds = _totalCountdownSeconds;
      _currentPresetColor = p.color;
      _currentPresetIcon = p.iconData;
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

  // ── 创建自定义计时 BottomSheet ──────────────────────────────────────
  void _showCreateCustomPresetSheet(BuildContext context) {
    final nameController = TextEditingController(text: '');
    int selectedMinutes = 10;
    String selectedIconKey = 'timer';
    Color selectedColor = const Color(0xFF8D5B4C);

    final iconOptions = [
      {'key': 'timer', 'icon': Icons.timer_rounded, 'label': '计时'},
      {'key': 'coffee', 'icon': Icons.coffee_rounded, 'label': '咖啡'},
      {'key': 'book', 'icon': Icons.menu_book_rounded, 'label': '阅读'},
      {'key': 'fitness', 'icon': Icons.fitness_center_rounded, 'label': '健身'},
      {'key': 'run', 'icon': Icons.directions_run_rounded, 'label': '跑步'},
      {'key': 'relax', 'icon': Icons.self_improvement_rounded, 'label': '冥想'},
      {'key': 'spa', 'icon': Icons.spa_rounded, 'label': '护肤'},
      {'key': 'nap', 'icon': Icons.bedtime_rounded, 'label': '小憩'},
      {'key': 'fire', 'icon': Icons.local_fire_department_rounded, 'label': '燃脂'},
      {'key': 'music', 'icon': Icons.music_note_rounded, 'label': '音乐'},
    ];

    final colorOptions = [
      const Color(0xFF8D5B4C), // 暖焦糖
      const Color(0xFFEA580C), // 落日橙
      const Color(0xFF10B981), // 清新绿
      const Color(0xFF0EA5E9), // 晴空蓝
      const Color(0xFF6366F1), // 丁香紫
      const Color(0xFFEC4899), // 柔和粉
      const Color(0xFFF59E0B), // 活力琥珀
    ];

    final quickNameSuggestions = [
      '冥想拉伸',
      '平板支撑',
      '自律阅读',
      '眼部休息',
      '背单词',
      '泡茶',
      'HIIT间歇',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Container(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 顶部抓手与标题
                    Center(
                      child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2D9D0),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '创建自定义计时',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF2D2522),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(sheetCtx).pop(),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF3EFEA),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close_rounded,
                                size: 18, color: Color(0xFF7D726D)),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // 1. 计时名称输入
                    const Text(
                      '计时名称',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF7D726D),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAF7F5),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: const Color(0xFFECE4D8), width: 1.0),
                      ),
                      child: TextField(
                        controller: nameController,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D2522),
                        ),
                        decoration: const InputDecoration(
                          hintText: '如：冥想、平板支撑、背单词...',
                          hintStyle: TextStyle(
                              fontSize: 14, color: Color(0xFFB8ACA4)),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // 快速灵感标签
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: quickNameSuggestions.map((tag) {
                        return GestureDetector(
                          onTap: () {
                            setSheetState(() {
                              nameController.text = tag;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF6F2ED),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: const Color(0xFFECE4D8), width: 0.8),
                            ),
                            child: Text(
                              tag,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF7D726D),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 20),

                    // 2. 计时时长设定
                    const Text(
                      '计时时长 (分钟)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF7D726D),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        // 减按钮
                        GestureDetector(
                          onTap: () {
                            if (selectedMinutes > 1) {
                              setSheetState(() => selectedMinutes--);
                            }
                          },
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFAF7F5),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                  color: const Color(0xFFECE4D8), width: 1.0),
                            ),
                            child: const Icon(Icons.remove_rounded,
                                color: Color(0xFF2D2522)),
                          ),
                        ),
                        const SizedBox(width: 14),
                        // 当前数值大字
                        Expanded(
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFAF3EE),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                  color: const Color(0xFF8D5B4C)
                                      .withValues(alpha: 0.3),
                                  width: 1.0),
                            ),
                            child: Center(
                              child: Text(
                                '$selectedMinutes 分钟',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF8D5B4C),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        // 加按钮
                        GestureDetector(
                          onTap: () {
                            if (selectedMinutes < 120) {
                              setSheetState(() => selectedMinutes++);
                            }
                          },
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFAF7F5),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                  color: const Color(0xFFECE4D8), width: 1.0),
                            ),
                            child: const Icon(Icons.add_rounded,
                                color: Color(0xFF2D2522)),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // 常用时长快捷选
                    Wrap(
                      spacing: 8,
                      children: [1, 3, 5, 10, 15, 20, 30, 45, 60].map((m) {
                        final isAct = selectedMinutes == m;
                        return GestureDetector(
                          onTap: () => setSheetState(() => selectedMinutes = m),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: isAct
                                  ? const Color(0xFF8D5B4C)
                                  : const Color(0xFFFAF7F5),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isAct
                                    ? const Color(0xFF8D5B4C)
                                    : const Color(0xFFECE4D8),
                                width: 0.8,
                              ),
                            ),
                            child: Text(
                              '$m分',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isAct
                                    ? Colors.white
                                    : const Color(0xFF7D726D),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 20),

                    // 3. 图标选择
                    const Text(
                      '场景图标',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF7D726D),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 52,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: iconOptions.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 8),
                        itemBuilder: (ctx, idx) {
                          final opt = iconOptions[idx];
                          final isSel = selectedIconKey == opt['key'];
                          return GestureDetector(
                            onTap: () => setSheetState(() =>
                                selectedIconKey = opt['key'] as String),
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: isSel
                                    ? selectedColor.withValues(alpha: 0.15)
                                    : const Color(0xFFFAF7F5),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSel
                                      ? selectedColor
                                      : const Color(0xFFECE4D8),
                                  width: isSel ? 1.8 : 1.0,
                                ),
                              ),
                              child: Icon(
                                opt['icon'] as IconData,
                                size: 22,
                                color: isSel
                                    ? selectedColor
                                    : const Color(0xFF7D726D),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 18),

                    // 4. 颜色选择
                    const Text(
                      '主题颜色',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF7D726D),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: colorOptions.map((c) {
                        final isSel = selectedColor == c;
                        return GestureDetector(
                          onTap: () => setSheetState(() => selectedColor = c),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: c,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSel ? Colors.white : Colors.transparent,
                                width: 2.5,
                              ),
                              boxShadow: [
                                if (isSel)
                                  BoxShadow(
                                    color: c.withValues(alpha: 0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                              ],
                            ),
                            child: isSel
                                ? const Icon(Icons.check_rounded,
                                    size: 18, color: Colors.white)
                                : null,
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 26),

                    // 保存并应用
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () async {
                          final name = nameController.text.trim().isEmpty
                              ? '$selectedMinutes分钟计时'
                              : nameController.text.trim();
                          final totalSecs = selectedMinutes * 60;

                          final newPreset = await ref
                              .read(countTimePresetsProvider.notifier)
                              .addPreset(
                                name: name,
                                seconds: totalSecs,
                                iconKey: selectedIconKey,
                                color: selectedColor,
                              );

                          if (sheetCtx.mounted) {
                            Navigator.of(sheetCtx).pop();
                          }

                          _selectPreset(newPreset);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8D5B4C),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          '保存并开始计时',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ── 删除自定义预设确认框 ──────────────────────────────────────────────
  void _confirmDeleteCustomPreset(CountTimePreset preset) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          '删除计时预设',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF2D2522),
          ),
        ),
        content: Text(
          '确定要删除自定义计时「${preset.name}」吗？',
          style: const TextStyle(fontSize: 14, color: Color(0xFF7D726D)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              '取消',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF7D726D),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await ref
                  .read(countTimePresetsProvider.notifier)
                  .deletePreset(preset.id);
              final remaining = ref.read(countTimePresetsProvider);
              if (_currentPresetId == preset.id && remaining.isNotEmpty) {
                _selectPreset(remaining.first);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            child: const Text('删除', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
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
            color: isSelected
                ? const Color(0xFF8D5B4C)
                : const Color(0xFF7D726D),
          ),
        ),
      ),
    );
  }

  // ── 1. 倒计时视图 ─────────────────────────────────────────────────────
  Widget _buildCountdownView() {
    final presets = ref.watch(countTimePresetsProvider);

    final progress = _totalCountdownSeconds > 0
        ? (_remainingSeconds / _totalCountdownSeconds).clamp(0.0, 1.0)
        : 0.0;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 计时场景列表 (横向卡片，支持左右滑动 + 自定义新建)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '选择计时场景',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2D2522),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _showCreateCustomPresetSheet(context),
                      child: Row(
                        children: const [
                          Icon(Icons.add_circle_outline_rounded,
                              size: 15, color: Color(0xFF8D5B4C)),
                          SizedBox(width: 3),
                          Text(
                            '自定义',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF8D5B4C),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 72,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: presets.length + 1, // +1 for the "+ 自定义" tile
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    // 最后一个展示 "+ 自定义"
                    if (index == presets.length) {
                      return GestureDetector(
                        onTap: () => _showCreateCustomPresetSheet(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: const Color(0xFF8D5B4C)
                                  .withValues(alpha: 0.4),
                              width: 1.0,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x067A533E),
                                blurRadius: 6,
                                offset: Offset(0, 2),
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
                                  color: const Color(0xFF8D5B4C)
                                      .withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.add_rounded,
                                  size: 22,
                                  color: Color(0xFF8D5B4C),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    '自定义',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF8D5B4C),
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    '新建计时',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF8C7E77),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    final p = presets[index];
                    final isSelected =
                        _currentPresetId == p.id || _currentPresetName == p.name;
                    return GestureDetector(
                      onTap: () => _selectPreset(p),
                      onLongPress: p.isCustom
                          ? () => _confirmDeleteCustomPreset(p)
                          : null,
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
                                color: p.color
                                    .withValues(alpha: isSelected ? 0.2 : 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                p.iconData,
                                size: 20,
                                color: p.color,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      p.name,
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
                                    if (p.isCustom) ...[
                                      const SizedBox(width: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4, vertical: 1),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF8D5B4C)
                                              .withValues(alpha: 0.12),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: const Text(
                                          '自定',
                                          style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF8D5B4C),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  p.desc,
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
                            if (p.isCustom) ...[
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () => _confirmDeleteCustomPreset(p),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Icon(
                                    Icons.close_rounded,
                                    size: 14,
                                    color: const Color(0xFFB8ACA4),
                                  ),
                                ),
                              ),
                            ],
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
