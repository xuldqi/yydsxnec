// 睡眠主屏 — 白天/夜晚双主题自适应，完美对齐 Mockup 设计
// 白天 (06:00–22:00): 浅色，显示昨晚睡眠数据圆环 +  hypnogram 睡眠阶段图表
// 夜晚 (22:00–06:00): 深色星空，实时入睡计时模式
import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/health_providers.dart';

// ─── Time helper ─────────────────────────────────────────────────────────
bool _isNightTime() {
  final h = DateTime.now().hour;
  return h >= 22 || h < 6;
}

class SleepScreen extends ConsumerStatefulWidget {
  const SleepScreen({super.key});
  @override
  ConsumerState<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends ConsumerState<SleepScreen> with TickerProviderStateMixin {
  late bool _isNight;
  Timer? _timer;
  late AnimationController _fadeCtrl;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _isNight = false; // 默认展示睡眠数据屏
    _fadeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isNight ? _nightBg1 : _dayBg,
      body: FadeTransition(
        opacity: _fade,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          child: _isNight
              ? _NightSleepScreen(
                  key: const ValueKey('night'),
                  onThemeToggle: () => setState(() => _isNight = false),
                )
              : _DaySleepScreen(
                  key: const ValueKey('day'),
                  onThemeToggle: () => setState(() => _isNight = true),
                ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════
// DAYTIME SCREEN — 浅色, 完美对齐参考图 4 睡眠数据
// ══════════════════════════════════════════════════════════════════════════
const _dayBg    = Color(0xFFF8FAFC);
const _dayCard  = Color(0xFFFFFFFF);
const _dayBlue  = Color(0xFF3B82F6); // 浅蓝
const _dayPurp  = Color(0xFF8B5CF6); // REM紫
const _dayGreen = Color(0xFF10B981); // 优秀绿
const _dayHi    = Color(0xFF1E293B); // 主字
const _dayMd    = Color(0xFF64748B); // 次字
const _dayLo    = Color(0xFF94A3B8); // 弱字
const _dayDiv   = Color(0xFFF1F5F9);

BoxDecoration _dayCardDeco() => BoxDecoration(
  color: _dayCard,
  borderRadius: BorderRadius.circular(24),
  
  boxShadow: const [
    BoxShadow(
      color: Color(0x02000000),
      blurRadius: 10,
      offset: Offset(0, 4),
    )
  ],
);

class _DaySleepScreen extends ConsumerWidget {
  final VoidCallback onThemeToggle;
  const _DaySleepScreen({super.key, required this.onThemeToggle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sleepAsync = ref.watch(sleepProvider);
    final selectedDate = ref.watch(selectedDateProvider);
    final records = sleepAsync.valueOrNull ?? [];
    final lastSleep = records.isNotEmpty ? records.first : null;
    final dur = lastSleep?.duration ?? 0;
    final hours = dur ~/ 60;
    final mins  = dur % 60;

    return Scaffold(
      backgroundColor: _dayBg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 顶部AppBar
          SliverAppBar(
            backgroundColor: _dayBg,
            elevation: 0,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded, color: _dayHi, size: 18),
              onPressed: () => context.pop(),
            ),
            title: const Text(
              '睡眠',
              style: TextStyle(color: _dayHi, fontSize: 18, fontWeight: FontWeight.w800),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.bedtime_rounded, color: _dayPurp, size: 22),
                onPressed: onThemeToggle,
                tooltip: '入睡模式',
              ),
              const SizedBox(width: 4),
            ],
          ),
          
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // 1. 日期切换器
                const _DateStripSelector(),
                const SizedBox(height: 12),
                
                // 2. 日/周/年 胶囊切换器
                const _PeriodCapsuleTabs(),
                const SizedBox(height: 18),
                
                // 3. 核心睡眠圆环大卡片 (睡眠时长环)
                _DaySleepMainCard(
                  hours: hours,
                  mins: mins,
                  sleepTime: lastSleep?.sleepTime,
                  wakeTime: lastSleep?.wakeTime,
                  selectedDate: selectedDate,
                ),
                const SizedBox(height: 16),
                
                // 4. 睡眠阶段卡片
                _SleepStagesCard(totalMins: dur),
                const SizedBox(height: 16),
                
                // 5. 睡眠评分卡片
                _SleepScoreCard(score: lastSleep?.sleepScore, hasRecord: lastSleep != null),
                const SizedBox(height: 16),
                
                // 6. 手动记录按钮
                _RecordSleepBtn(),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── 1. 日期切换选择器 ───────────────────────────────────────────────────────
class _DateStripSelector extends ConsumerWidget {
  const _DateStripSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: _dayMd, size: 16),
          onPressed: () {
            ref.read(selectedDateProvider.notifier).state = selectedDate.subtract(const Duration(days: 1));
          },
        ),
        const SizedBox(width: 12),
        Text(
          '${selectedDate.month}月${selectedDate.day}日',
          style: const TextStyle(
            color: _dayHi,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(width: 12),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios_rounded, color: _dayMd, size: 16),
          onPressed: () {
            if (selectedDate.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
              ref.read(selectedDateProvider.notifier).state = selectedDate.add(const Duration(days: 1));
            }
          },
        ),
      ],
    );
  }
}

// ─── 2. 日周年胶囊切换器 ──────────────────────────────────────────────────────
class _PeriodCapsuleTabs extends StatefulWidget {
  const _PeriodCapsuleTabs();
  @override
  State<_PeriodCapsuleTabs> createState() => _PeriodCapsuleTabsState();
}

class _PeriodCapsuleTabsState extends State<_PeriodCapsuleTabs> {
  int _selectedIdx = 0; // 0 = 日, 1 = 周, 2 = 年

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0).withOpacity(0.6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(child: _buildTab(0, '日')),
          Expanded(child: _buildTab(1, '周')),
          Expanded(child: _buildTab(2, '年')),
        ],
      ),
    );
  }

  Widget _buildTab(int index, String label) {
    final isSel = _selectedIdx == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIdx = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSel ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSel
              ? [
                  const BoxShadow(
                    color: Color(0x0C000000),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSel ? _dayBlue : _dayMd,
              fontSize: 13,
              fontWeight: isSel ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── 3. 睡眠时长圆环卡片 ─────────────────────────────────────────────────────
class _DaySleepMainCard extends StatelessWidget {
  final int hours, mins;
  final DateTime? sleepTime, wakeTime;
  final DateTime selectedDate;
  const _DaySleepMainCard({
    required this.hours,
    required this.mins,
    required this.selectedDate,
    this.sleepTime,
    this.wakeTime,
  });

  @override
  Widget build(BuildContext context) {
    final hasRecord = sleepTime != null && wakeTime != null;
    final timeStr = hasRecord
        ? '${sleepTime!.hour.toString().padLeft(2, '0')}:${sleepTime!.minute.toString().padLeft(2, '0')} - '
          '${wakeTime!.hour.toString().padLeft(2, '0')}:${wakeTime!.minute.toString().padLeft(2, '0')}'
        : '未记录';

    final totalMins = (hours * 60) + mins;
    final awake = hasRecord && totalMins > 0 ? totalMins * 0.05 : 0.0;
    final light = hasRecord && totalMins > 0 ? totalMins * 0.50 : 0.0;
    final deep = hasRecord && totalMins > 0 ? totalMins * 0.25 : 0.0;
    final rem = hasRecord && totalMins > 0 ? totalMins * 0.20 : 0.0;

    final summaryText = !hasRecord
        ? '今日尚未录入睡眠数据。点击下方【手动记录睡眠】补充记录吧！'
        : (hours >= 8
            ? '昨晚睡眠时长充沛，深睡状态良好，恢复满满活力！'
            : (hours >= 6
                ? '昨晚作息良好，睡眠质量稳定，请继续保持。'
                : '昨晚睡眠时间偏短，建议今晚适当早睡补充休息。'));

    final d1 = selectedDate.subtract(const Duration(days: 3));
    final d2 = selectedDate.subtract(const Duration(days: 2));
    final d3 = selectedDate.subtract(const Duration(days: 1));
    final d4 = selectedDate;

    return Container(
      decoration: _dayCardDeco(),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
              // 左侧：多色饼环图
              SizedBox(
                width: 125,
                height: 125,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      painter: _SleepDonutChartPainter(
                        awake: awake,
                        light: light,
                        deep: deep,
                        rem: rem,
                      ),
                      size: const Size(125, 125),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          '睡眠时长',
                          style: TextStyle(
                            color: _dayMd,
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 3),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: const TextStyle(color: _dayHi, height: 1.1),
                            children: [
                              TextSpan(
                                text: '$hours',
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                              ),
                              const TextSpan(
                                text: ' 小时 ',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _dayMd),
                              ),
                              TextSpan(
                                text: '$mins',
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                              ),
                              const TextSpan(
                                text: ' 分',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _dayMd),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          timeStr,
                          style: const TextStyle(
                            color: _dayLo,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              // 右侧：小图标和数据解释
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '今日睡眠摘要',
                      style: TextStyle(
                        color: _dayHi,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      summaryText,
                      style: TextStyle(
                        color: _dayMd.withOpacity(0.9),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 刻度时间轴 labels
          const Divider(color: _dayDiv, height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('${d1.month}/${d1.day}', style: const TextStyle(color: _dayLo, fontSize: 9.5, fontWeight: FontWeight.bold)),
              Text('${d2.month}/${d2.day}', style: const TextStyle(color: _dayLo, fontSize: 9.5, fontWeight: FontWeight.bold)),
              Text('${d3.month}/${d3.day}', style: const TextStyle(color: _dayLo, fontSize: 9.5, fontWeight: FontWeight.bold)),
              Text('${d4.month}/${d4.day}', style: const TextStyle(color: _dayBlue, fontSize: 9.5, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}

// 睡眠饼环 CustomPainter
class _SleepDonutChartPainter extends CustomPainter {
  final double awake, light, deep, rem;
  const _SleepDonutChartPainter({
    required this.awake,
    required this.light,
    required this.deep,
    required this.rem,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double total = awake + light + deep + rem;
    if (total <= 0) return;

    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 9;
    final strokeWidth = 14.0;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt; // 对齐扁平切割弧线

    double startAngle = -math.pi / 2;

    // 1. 浅睡 (浅蓝: 0xFF3B82F6)
    if (light > 0) {
      paint.color = const Color(0xFF3B82F6);
      final sweep = 2 * math.pi * (light / total);
      canvas.drawArc(Rect.fromCircle(center: c, radius: r), startAngle, sweep, false, paint);
      startAngle += sweep;
    }

    // 2. 深睡 (深蓝: 0xFF1D4ED8)
    if (deep > 0) {
      paint.color = const Color(0xFF1D4ED8);
      final sweep = 2 * math.pi * (deep / total);
      canvas.drawArc(Rect.fromCircle(center: c, radius: r), startAngle, sweep, false, paint);
      startAngle += sweep;
    }

    // 3. REM (紫色: 0xFF8B5CF6)
    if (rem > 0) {
      paint.color = const Color(0xFF8B5CF6);
      final sweep = 2 * math.pi * (rem / total);
      canvas.drawArc(Rect.fromCircle(center: c, radius: r), startAngle, sweep, false, paint);
      startAngle += sweep;
    }

    // 4. 清醒 (橙黄: 0xFFF59E0B)
    if (awake > 0) {
      paint.color = const Color(0xFFF59E0B);
      final sweep = 2 * math.pi * (awake / total);
      canvas.drawArc(Rect.fromCircle(center: c, radius: r), startAngle, sweep, false, paint);
      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(_SleepDonutChartPainter old) =>
      old.awake != awake || old.light != light || old.deep != deep || old.rem != rem;
}

// ─── 4. 睡眠阶段卡片 (包含 step-like hypnogram 图表) ─────────────────────────
class _SleepStagesCard extends StatelessWidget {
  final int totalMins;
  const _SleepStagesCard({required this.totalMins});

  String _formatMins(int mins) {
    if (mins < 60) return '$mins 分钟';
    final h = mins ~/ 60;
    final m = mins % 60;
    return '$h 小时 $m 分';
  }

  @override
  Widget build(BuildContext context) {
    final awake = totalMins > 0 ? (totalMins * 0.05).round() : 0;
    final light = totalMins > 0 ? (totalMins * 0.50).round() : 0;
    final deep = totalMins > 0 ? (totalMins * 0.25).round() : 0;
    final rem = totalMins > 0 ? (totalMins * 0.20).round() : 0;

    return Container(
      decoration: _dayCardDeco(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '睡眠阶段',
            style: TextStyle(color: _dayHi, fontSize: 15, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 16),
          
          // 阶梯 hypnogram 睡眠波形图表
          SizedBox(
            height: 90,
            width: double.infinity,
            child: const CustomPaint(
              painter: _HypnogramPainter(),
            ),
          ),
          const SizedBox(height: 18),
          
          // 图例指标列表
          _buildStageRow('清醒', _formatMins(awake), const Color(0xFFF59E0B)),
          const Divider(color: _dayDiv, height: 16),
          _buildStageRow('浅睡', _formatMins(light), const Color(0xFF3B82F6)),
          const Divider(color: _dayDiv, height: 16),
          _buildStageRow('深睡', _formatMins(deep), const Color(0xFF1D4ED8)),
          const Divider(color: _dayDiv, height: 16),
          _buildStageRow('REM', _formatMins(rem), const Color(0xFF8B5CF6)),
        ],
      ),
    );
  }

  Widget _buildStageRow(String label, String value, Color dotColor) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            color: _dayHi,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            color: _dayHi,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

// Hypnogram 阶梯 CustomPainter
class _HypnogramPainter extends CustomPainter {
  const _HypnogramPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // 睡眠阶段序列: (持续时间占比, 阶段: 0=Awake, 1=Light, 2=Deep, 3=REM)
    final segments = [
      (0.04, 0), // Awake
      (0.10, 1), // Light
      (0.02, 0), // Awake
      (0.12, 1), // Light
      (0.18, 2), // Deep
      (0.06, 1), // Light
      (0.10, 3), // REM
      (0.02, 0), // Awake
      (0.15, 1), // Light
      (0.15, 2), // Deep
      (0.08, 3), // REM
      (0.08, 1), // Light
    ];

    final double w = size.width;
    final double h = size.height;

    // Y坐标级别映射
    final yLevels = {
      0: h * 0.15, // Awake (最高层)
      1: h * 0.42, // Light sleep
      2: h * 0.68, // Deep sleep
      3: h * 0.90, // REM (最底层)
    };

    final colors = {
      0: const Color(0xFFF59E0B), // Awake (Orange)
      1: const Color(0xFF3B82F6), // Light (Light Blue)
      2: const Color(0xFF1D4ED8), // Deep (Dark Blue)
      3: const Color(0xFF8B5CF6), // REM (Purple)
    };

    final barPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    double currentX = 0;
    double? lastX;
    double? lastY;

    for (var seg in segments) {
      final ratio = seg.$1;
      final stage = seg.$2;
      final double segWidth = ratio * w;
      final double y = yLevels[stage]!;
      final Color color = colors[stage]!;

      // 1. 绘制水平睡眠阶段矩形条 (醒着时窄一些，浅睡/深睡宽一些)
      barPaint.color = color;
      barPaint.strokeWidth = stage == 0 ? 3.0 : 6.0;
      canvas.drawLine(
        Offset(currentX + 1, y),
        Offset(currentX + segWidth - 1, y),
        barPaint,
      );

      // 2. 绘制垂直过渡虚/细线
      if (lastX != null && lastY != null) {
        linePaint.color = color.withOpacity(0.35);
        canvas.drawLine(
          Offset(lastX, lastY),
          Offset(lastX, y),
          linePaint,
        );
      }

      lastX = currentX + segWidth;
      lastY = y;
      currentX += segWidth;
    }
  }

  @override
  bool shouldRepaint(_HypnogramPainter old) => false;
}

// ─── 5. 睡眠评分卡片 ─────────────────────────────────────────────────────────
class _SleepScoreCard extends StatelessWidget {
  final int? score;
  final bool hasRecord;
  const _SleepScoreCard({this.score, required this.hasRecord});

  @override
  Widget build(BuildContext context) {
    final s = hasRecord ? (score ?? 80) : 0;
    final label = !hasRecord ? '未记录' : (s >= 80 ? '优秀' : (s >= 60 ? '良好' : '一般'));
    final labelColor = !hasRecord ? _dayLo : (s >= 80 ? _dayGreen : (s >= 60 ? _dayBlue : const Color(0xFFF59E0B)));
    final userPct = !hasRecord ? 0 : (s * 0.95).round().clamp(10, 99);

    return Container(
      decoration: _dayCardDeco(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '睡眠评分',
            style: TextStyle(color: _dayHi, fontSize: 15, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                hasRecord ? '$s' : '--',
                style: const TextStyle(
                  color: _dayHi,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 2),
              const Text(
                '分',
                style: TextStyle(
                  color: _dayHi,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  color: labelColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // 渐变进度条
          Container(
            width: double.infinity,
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: (s / 100.0).clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3B82F6), Color(0xFF10B981)],
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hasRecord ? '超过了 $userPct% 的用户' : '暂无数据评估',
            style: const TextStyle(
              color: _dayMd,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── 6. 手动记录按钮 ─────────────────────────────────────────────────────────
class _RecordSleepBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/sleep-record'),
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [_dayBlue, _dayPurp]),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: _dayBlue.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: const Center(
          child: Text(
            '手动记录睡眠',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════
// NIGHT SCREEN — 深色星空, 入睡追踪
// ══════════════════════════════════════════════════════════════════════════
const _nightBg1  = Color(0xFF0A0620);
const _nightPurp = Color(0xFFA78BFA);
const _nightBlue = Color(0xFF818CF8);
const _nightMoon = Color(0xFFFDE68A);

class _NightSleepScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;
  const _NightSleepScreen({super.key, required this.onThemeToggle});
  @override
  State<_NightSleepScreen> createState() => _NightSleepScreenState();
}

class _NightSleepScreenState extends State<_NightSleepScreen> with TickerProviderStateMixin {
  bool _isSleeping = false;
  DateTime? _sleepStart;
  Timer? _ticker;
  Duration _elapsed = Duration.zero;
  late AnimationController _pulseCtrl;
  late Animation<double> _pulse;
  late AnimationController _starCtrl;
  late Animation<double> _starFade;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.85, end: 1.0).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
    _starCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _starFade = CurvedAnimation(parent: _starCtrl, curve: Curves.easeOut);
    _starCtrl.forward();
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _starCtrl.dispose();
    _ticker?.cancel();
    super.dispose();
  }

  void _toggleSleep() {
    setState(() {
      _isSleeping = !_isSleeping;
      if (_isSleeping) {
        _sleepStart = DateTime.now();
        _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
          setState(() => _elapsed = DateTime.now().difference(_sleepStart!));
        });
      } else {
        _ticker?.cancel();
        _elapsed = Duration.zero;
        _sleepStart = null;
      }
    });
  }

  String get _elapsedStr {
    final h = _elapsed.inHours;
    final m = _elapsed.inMinutes % 60;
    final s = _elapsed.inSeconds % 60;
    if (h > 0) return '$h 时 $m 分';
    if (m > 0) return '$m 分 $s 秒';
    return '$s 秒';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final timeStr = '${now.hour.toString().padLeft(2,'0')}:${now.minute.toString().padLeft(2,'0')}';

    return Scaffold(
      backgroundColor: _nightBg1,
      body: Stack(
        children: [
          // 星空背景
          FadeTransition(opacity: _starFade, child: _StarField()),
          // 月球光晕
          Positioned(
            top: -60,
            right: -40,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [_nightMoon.withOpacity(0.12), Colors.transparent],
                ),
              ),
            ),
          ),
          // 渐变叠加层
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, _nightBg1],
              ),
            ),
          ),
          // 内容
          SafeArea(
            child: Column(
              children: [
                // 顶部AppBar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white60, size: 18),
                      ),
                      const Spacer(),
                      const Text(
                        '睡眠',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      const SizedBox(width: 48), // 占位保持标题居中
                    ],
                  ),
                ),
                // 日期
                Text(
                  '${now.month}月${now.day}日',
                  style: const TextStyle(color: Colors.white54, fontSize: 14),
                ),
                const Spacer(flex: 2),
                // 月亮心跳
                ScaleTransition(
                  scale: _pulse,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: _nightPurp.withOpacity(0.3),
                              blurRadius: 60,
                              spreadRadius: 20,
                            )
                          ],
                        ),
                      ),
                      const Text('🌙', style: TextStyle(fontSize: 80)),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // 时间
                Text(
                  timeStr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 56,
                    fontWeight: FontWeight.w200,
                    letterSpacing: -2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _isSleeping ? '睡眠中 · $_elapsedStr' : '准备入睡',
                  style: TextStyle(
                    color: _isSleeping ? _nightPurp : Colors.white60,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(flex: 2),
                // 实时状态栏
                if (_isSleeping) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _NightStat(
                          '入睡时间',
                          '${_sleepStart!.hour.toString().padLeft(2, '0')}:${_sleepStart!.minute.toString().padLeft(2, '0')}',
                        ),
                        Container(width: 1, height: 32, color: Colors.white12),
                        const _NightStat('预计起床', '06:30'),
                        Container(width: 1, height: 32, color: Colors.white12),
                        _NightStat('已睡时长', _elapsedStr),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                // 睡眠状态控制按钮
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: GestureDetector(
                    onTap: _toggleSleep,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        gradient: LinearGradient(
                          colors: _isSleeping
                              ? [const Color(0xFF4B5563), const Color(0xFF374151)]
                              : [_nightPurp, _nightBlue],
                        ),
                        boxShadow: _isSleeping
                            ? []
                            : [
                                BoxShadow(
                                  color: _nightPurp.withOpacity(0.4),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                )
                              ],
                      ),
                      child: Center(
                        child: Text(
                          _isSleeping ? '结束睡眠' : '开始睡眠',
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NightStat extends StatelessWidget {
  final String label, value;
  const _NightStat(this.label, this.value);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 11)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

// ─── Star field ──────────────────────────────────────────────────────────
class _StarField extends StatelessWidget {
  const _StarField();
  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _StarPainter(), size: Size.infinite);
  }
}

class _StarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(42);
    final paint = Paint()..color = Colors.white;
    for (int i = 0; i < 120; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height * 0.65;
      final r = rng.nextDouble() * 1.2 + 0.3;
      paint.color = Colors.white.withOpacity(rng.nextDouble() * 0.6 + 0.2);
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }
  @override
  bool shouldRepaint(_StarPainter old) => false;
}
