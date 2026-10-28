import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/services/step_provider.dart' as step_svc;
import '../../core/services/daily_health_provider.dart';
import '../../core/services/health_providers.dart';
import '../vital_signs/widgets/measure_bottom_sheet.dart';
import '../fasting/providers/fasting_provider.dart';
import '../fasting/providers/timer_provider.dart';
import '../diet/diet_screen.dart';

class StepsScreen extends ConsumerStatefulWidget {
  const StepsScreen({super.key});

  @override
  ConsumerState<StepsScreen> createState() => _StepsScreenState();
}

class _StepsScreenState extends ConsumerState<StepsScreen> {
  int _selectedDayIndex = 6; // 0..6, 6 is today

  @override
  Widget build(BuildContext context) {
    final stepAsync = ref.watch(step_svc.stepProvider);
    final steps = stepAsync.valueOrNull?.todaySteps ?? 6820;

    final healthAsync = ref.watch(dailyHealthProvider);
    final record = healthAsync.valueOrNull ??
        DailyHealthRecord(
          dateStr: DateFormat('yyyy-MM-dd').format(DateTime.now()),
          waterMl: 1250,
          sleepMins: 465,
          dietCalories: 1420,
          mood: '平静',
          hrv: 42,
          bloodOxygen: 99,
          stressLevel: '轻松',
        );

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F8),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEFEBFA), Color(0xFFF3F4F8), Color(0xFFEBEFF9)],
            stops: [0.0, 0.35, 1.0],
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            color: const Color(0xFF6366F1),
            backgroundColor: Colors.white,
            onRefresh: () async {
              await Future.delayed(const Duration(milliseconds: 600));
              setState(() {});
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10)
                  .copyWith(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopHeader(context),
                  const SizedBox(height: 14),
                  _buildCalendarStrip(context),
                  const SizedBox(height: 16),
                  _buildPlanBanner(context, steps),
                  const SizedBox(height: 18),
                  _buildHabitCardsStream(context, steps, record),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── 1. Top Header (OtterLife Header with Streak & Avatar) ───────────────────
  Widget _buildTopHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '今天',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1E1B4B),
                letterSpacing: -0.5,
              ),
            ),
            Text(
              DateFormat('M月d日 EEEE', 'zh').format(DateTime.now()),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('🔥 已连续打卡 7 天！状态绝佳，保持住哦~'),
                    duration: Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFF7ED), Color(0xFFFFEDD5)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFFDBA74)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0A000000),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: const [
                    Icon(Icons.local_fire_department_rounded, size: 15, color: Color(0xFFEA580C)),
                    SizedBox(width: 4),
                    Text(
                      '连续 7 天',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFC2410C),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () => context.push('/profile'),
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0F000000),
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    )
                  ],
                  border: Border.all(color: Colors.white.withValues(alpha: 0.9), width: 1.5),
                ),
                child: const Icon(Icons.person_rounded, color: Color(0xFF6366F1), size: 22),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── 2. Calendar Strip (Week View) ───────────────────────────────────────────
  Widget _buildCalendarStrip(BuildContext context) {
    final now = DateTime.now();
    final weekDays = ['一', '二', '三', '四', '五', '六', '日'];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      height: 86,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(7, (index) {
          final date = now.subtract(Duration(days: 6 - index));
          final isSelected = index == _selectedDayIndex;
          final isToday = index == 6;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDayIndex = index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 42,
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF818CF8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isSelected ? null : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '周${weekDays[date.weekday - 1]}',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white.withValues(alpha: 0.85) : const Color(0xFF94A3B8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: isSelected ? Colors.white : const Color(0xFF1E1B4B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? Colors.white
                          : (isToday ? const Color(0xFF6366F1) : const Color(0xFFCBD5E1)),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  // ── 3. Plan / Goal Hero Banner (OtterLife 目标计划横幅) ─────────────────────
  Widget _buildPlanBanner(BuildContext context, int steps) {
    final progress = (steps / 10000).clamp(0.0, 1.0);
    return GestureDetector(
      onTap: () => context.push('/goal'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Color(0x06000000),
              blurRadius: 16,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: Color(0xFFDCFCE7),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.track_changes_rounded,
                color: Color(0xFF16A34A),
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '目标计划',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E1B4B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '今日步数 ${(progress * 100).toInt()}% · 剩 ${(10000 - steps).clamp(0, 10000)} 步',
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 4,
                      backgroundColor: const Color(0xFFF1F5F9),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF00C853),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              height: 34,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF00C853),
                borderRadius: BorderRadius.circular(17),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x3300C853),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  '新计划',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── 4. Interactive Habit Cards Flow (OtterLife 大气网格卡片) ─────────────────
  Widget _buildHabitCardsStream(BuildContext context, int steps, DailyHealthRecord record) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            '每日行动',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E1B4B),
              letterSpacing: -0.3,
            ),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  _buildFastingCard(context),
                  const SizedBox(height: 14),
                  _buildNutrientsCard(context),
                  const SizedBox(height: 14),
                  _buildStepsCard(context, steps),
                  const SizedBox(height: 14),
                  _buildSleepCard(context, record),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                children: [
                  _buildDietCard(context, record),
                  const SizedBox(height: 14),
                  _buildWeightCard(context),
                  const SizedBox(height: 14),
                  _buildWaterCard(context, record),
                  const SizedBox(height: 14),
                  _buildVitalSignsCard(context, record),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Card: Fasting (轻断食) ──────────────────────────────────────────────────
  Widget _buildFastingCard(BuildContext context) {
    final activeSession = ref.watch(activeFastingSessionProvider);
    final timer = ref.watch(fastingTimerProvider);
    final isActive = activeSession != null;

    final elapsedH = timer.elapsedTime.inHours;
    final elapsedM = timer.elapsedTime.inMinutes % 60;
    final remainH = timer.remainingTime.inHours;
    final remainM = timer.remainingTime.inMinutes % 60;

    return _buildActionCard(
      title: '轻断食',
      icon: Icons.timer_outlined,
      iconColor: const Color(0xFFF97316),
      badgeBgColor: const Color(0xFFFFF7ED),
      subtitle: '当前状态',
      onTap: () => context.push('/fasting'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isActive ? '${elapsedH}h ${elapsedM}m' : '未开始',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E1B4B),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isActive
                ? (timer.isOvertime ? '已达成目标' : '剩 ${remainH}h ${remainM}m')
                : '16:8 方案',
            style: const TextStyle(fontSize: 11.5, color: Color(0xFF94A3B8)),
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () => context.push('/fasting'),
            child: Container(
              width: double.infinity,
              height: 38,
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFFF97316) : const Color(0xFF00C853),
                borderRadius: BorderRadius.circular(19),
                boxShadow: [
                  BoxShadow(
                    color: (isActive ? const Color(0xFFF97316) : const Color(0xFF00C853)).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  isActive ? '计时器' : '开始断食',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Card: Diet (摄入) ───────────────────────────────────────────────────────
  Widget _buildDietCard(BuildContext context, DailyHealthRecord record) {
    final dietAsync = ref.watch(dietProvider);
    final totalCalories = dietAsync.valueOrNull?.totalCal.round() ?? record.dietCalories;
    final goalCalories = (dietAsync.valueOrNull?.goal ?? 2000).round();
    final remaining = (goalCalories - totalCalories).clamp(0, goalCalories);

    return _buildActionCard(
      title: '摄入',
      icon: Icons.restaurant_rounded,
      iconColor: const Color(0xFFEF4444),
      badgeBgColor: const Color(0xFFFEF2F2),
      subtitle: '还能吃',
      onTap: () => context.push('/diet'),
      onQuickAdd: () => context.push('/diet'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                NumberFormat('#,###').format(remaining),
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E1B4B),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                '千卡',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            totalCalories > 0 ? '已摄入 $totalCalories 千卡' : '尚无记录',
            style: const TextStyle(fontSize: 11.5, color: Color(0xFF94A3B8)),
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () => context.push('/diet'),
            child: Container(
              width: double.infinity,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(19),
              ),
              child: const Center(
                child: Text(
                  '记一餐',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFDC2626),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Card: Nutrients (营养素) ─────────────────────────────────────────────────
  Widget _buildNutrientsCard(BuildContext context) {
    return _buildActionCard(
      title: '营养素',
      icon: Icons.pie_chart_rounded,
      iconColor: const Color(0xFF0284C7),
      badgeBgColor: const Color(0xFFE0F2FE),
      subtitle: '三项比例',
      onTap: () => context.push('/diet'),
      onQuickAdd: () => context.push('/diet'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMacroRow('蛋白质', '0%', const Color(0xFF10B981)),
          const SizedBox(height: 8),
          _buildMacroRow('脂肪', '0%', const Color(0xFFF59E0B)),
          const SizedBox(height: 8),
          _buildMacroRow('碳水', '0%', const Color(0xFF38BDF8)),
        ],
      ),
    );
  }

  Widget _buildMacroRow(String label, String percent, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
            Text(percent, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF1E1B4B))),
          ],
        ),
        const SizedBox(height: 3),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: Container(
            height: 4,
            width: double.infinity,
            color: color.withValues(alpha: 0.2),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.05,
              child: Container(color: color),
            ),
          ),
        ),
      ],
    );
  }

  // ── Card: Weight (体重) ─────────────────────────────────────────────────────
  Widget _buildWeightCard(BuildContext context) {
    return _buildActionCard(
      title: '体重',
      icon: Icons.monitor_weight_outlined,
      iconColor: const Color(0xFF10B981),
      badgeBgColor: const Color(0xFFDCFCE7),
      subtitle: '最新数据',
      onTap: () => context.push('/goal'),
      onQuickAdd: () => context.push('/goal'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            '--',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E1B4B),
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 4),
          Text(
            '暂无数据',
            style: TextStyle(fontSize: 11.5, color: Color(0xFF94A3B8)),
          ),
          SizedBox(height: 18),
        ],
      ),
    );
  }

  // ── Card: Steps (步数) ──────────────────────────────────────────────────────
  Widget _buildStepsCard(BuildContext context, int steps) {
    final progress = (steps / 10000).clamp(0.0, 1.0);
    return _buildActionCard(
      title: '步数',
      icon: Icons.directions_walk_rounded,
      iconColor: const Color(0xFFEA580C),
      badgeBgColor: const Color(0xFFFFEDD5),
      subtitle: '今日活动',
      onTap: () => context.push('/sport'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                NumberFormat('#,###').format(steps),
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E1B4B),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                '步',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '目标 ${(progress * 100).toInt()}%',
            style: const TextStyle(fontSize: 11.5, color: Color(0xFF94A3B8)),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFEA580C)),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(steps * 0.0007).toStringAsFixed(1)}km · ${(steps * 0.038).toInt()}kcal',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  // ── Card: Water (喝水) ──────────────────────────────────────────────────────
  Widget _buildWaterCard(BuildContext context, DailyHealthRecord record) {
    final waterProgress = (record.waterMl / 2000).clamp(0.0, 1.0);

    return _buildActionCard(
      title: '喝水',
      icon: Icons.water_drop_rounded,
      iconColor: const Color(0xFF0284C7),
      badgeBgColor: const Color(0xFFE0F2FE),
      subtitle: '今日饮水',
      onTap: () => context.push('/water'),
      onQuickAdd: () {
        ref.read(dailyHealthProvider.notifier).addWater(250);
        try {
          ref.read(waterProvider.notifier).addWater(250);
        } catch (_) {}
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${record.waterMl}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0284C7),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                '毫升',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            '/ 2,000毫升',
            style: TextStyle(fontSize: 11.5, color: Color(0xFF94A3B8)),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: waterProgress,
              minHeight: 5,
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0284C7)),
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              ref.read(dailyHealthProvider.notifier).addWater(250);
              try {
                ref.read(waterProvider.notifier).addWater(250);
              } catch (_) {}
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('已记录饮水 +250ml'),
                  duration: Duration(milliseconds: 1000),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Container(
              width: double.infinity,
              height: 34,
              decoration: BoxDecoration(
                color: const Color(0xFF0284C7).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(17),
              ),
              child: const Center(
                child: Text(
                  '+250ml',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0284C7),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Card: Sleep (睡眠) ──────────────────────────────────────────────────────
  Widget _buildSleepCard(BuildContext context, DailyHealthRecord record) {
    final hours = record.sleepMins ~/ 60 > 0 ? record.sleepMins ~/ 60 : 7;
    final mins = record.sleepMins % 60 > 0 ? record.sleepMins % 60 : 45;

    return _buildActionCard(
      title: '睡眠',
      icon: Icons.nightlight_round,
      iconColor: const Color(0xFF6366F1),
      badgeBgColor: const Color(0xFFEEF2FF),
      subtitle: '昨晚睡眠',
      onTap: () => context.push('/sleep'),
      onQuickAdd: () => context.push('/sleep'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${hours}h ${mins}m',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E1B4B),
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            '深睡 2h 10m · 优',
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF10B981),
            ),
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () => context.push('/white-noise'),
            child: Container(
              width: double.infinity,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(19),
              ),
              child: const Center(
                child: Text(
                  '助眠音',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF4F46E5),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Card: Heart / Vitals (心率) ─────────────────────────────────────────────
  Widget _buildVitalSignsCard(BuildContext context, DailyHealthRecord record) {
    return _buildActionCard(
      title: '心率',
      icon: Icons.favorite_rounded,
      iconColor: const Color(0xFFF43F5E),
      badgeBgColor: const Color(0xFFFFE4E6),
      subtitle: '静息心率',
      onTap: () => context.push('/vital-signs'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: const [
              Text(
                '72',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E1B4B),
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(width: 4),
              Text(
                'bpm · 正常',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF10B981),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'HRV 42ms · 状态轻松',
            style: TextStyle(fontSize: 11.5, color: Color(0xFF94A3B8)),
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () => MeasureBottomSheet.show(context),
            child: Container(
              width: double.infinity,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFF43F5E).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(19),
              ),
              child: const Center(
                child: Text(
                  '测量',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFE11D48),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Color badgeBgColor,
    required String subtitle,
    required Widget child,
    VoidCallback? onTap,
    VoidCallback? onQuickAdd,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Color(0x06000000),
              blurRadius: 16,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: badgeBgColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, size: 16, color: iconColor),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E1B4B),
                      ),
                    ),
                  ],
                ),
                if (onQuickAdd != null)
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onQuickAdd,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        size: 16,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (subtitle.isNotEmpty) ...[
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(height: 4),
            ],
            child,
          ],
        ),
      ),
    );
  }
}
