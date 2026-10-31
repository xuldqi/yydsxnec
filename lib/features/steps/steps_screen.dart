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
import '../capybara/widgets/capybara_hero_card.dart';
import '../capybara/providers/capybara_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../agreement/privacy_dialog.dart';

class StepsScreen extends ConsumerStatefulWidget {
  const StepsScreen({super.key});

  @override
  ConsumerState<StepsScreen> createState() => _StepsScreenState();
}

class _StepsScreenState extends ConsumerState<StepsScreen> {
  int _selectedDayIndex = 6; // 0..6, 6 is today
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkPrivacyAgreement();
    });
  }

  Future<void> _checkPrivacyAgreement() async {
    final prefs = await SharedPreferences.getInstance();
    final agreed = prefs.getBool('privacy_agreed') ?? false;
    if (!agreed && mounted) {
      await showAppPrivacyDialog(context);
    }
  }

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
        color: const Color(0xFFF3F4F8),
        child: SafeArea(
          child: RefreshIndicator(
            color: const Color(0xFF8D5B4C),
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
                  const CapybaraHeroCard(showHeader: false),
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

  // ── 1. Top Header (OtterLife Month Dropdown + Hearts & Sanctuary) ──────────
  Widget _buildTopHeader(BuildContext context) {
    final capyState = ref.watch(capybaraProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => _showMonthPickerSheet(context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$_selectedMonth月',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF2D2522),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 26,
                color: Color(0xFF2D2522),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => context.push('/capybara'),
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x067A533E),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('💛', style: TextStyle(fontSize: 13)),
                const SizedBox(width: 4),
                Text(
                  '${capyState.hearts}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF3D342F),
                  ),
                ),
                const SizedBox(width: 6),
                Container(width: 1, height: 10, color: const Color(0xFFE5DDD5)),
                const SizedBox(width: 6),
                const Text(
                  '小窝',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF8D5B4C),
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, size: 14, color: Color(0xFF8D5B4C)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showMonthPickerSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5DDD5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$_selectedYear 年选择月份',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF2D2522),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedMonth = DateTime.now().month;
                        _selectedYear = DateTime.now().year;
                      });
                      Navigator.pop(ctx);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '回到当月',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF8D5B4C),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 12,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 2.0,
                ),
                itemBuilder: (c, idx) {
                  final m = idx + 1;
                  final isSelected = m == _selectedMonth;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedMonth = m;
                      });
                      Navigator.pop(ctx);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF8D5B4C) : const Color(0xFFF3F4F8),
                        borderRadius: BorderRadius.circular(14),
                        border: isSelected
                            ? null
                            : Border.all(color: const Color(0xFFECE4D8), width: 0.8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$m月',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                          color: isSelected ? Colors.white : const Color(0xFF2D2522),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
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
            color: Color(0x067A533E),
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
                        colors: [Color(0xFF8D5B4C), Color(0xFFA26E5F)],
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
                      color: isSelected ? Colors.white.withValues(alpha: 0.85) : const Color(0xFF8C7E77),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: isSelected ? Colors.white : const Color(0xFF2D2522),
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
                          : (isToday ? const Color(0xFF8D5B4C) : const Color(0xFFE5DDD5)),
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

  // ── 4. Interactive Habit Cards Flow (OtterLife 大气网格卡片) ─────────────────
  Widget _buildHabitCardsStream(BuildContext context, int steps, DailyHealthRecord record) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            '日常',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Color(0xFF2D2522),
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
      onTap: () => context.push('/fasting'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isActive ? '${elapsedH}h ${elapsedM}m' : '未开始',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF2D2522),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isActive
                ? (timer.isOvertime ? '已达成目标' : '剩余 ${remainH}h ${remainM}m')
                : '16:8 方案',
            style: const TextStyle(fontSize: 11.5, color: Color(0xFF7D726D)),
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () => context.push('/fasting'),
            child: Container(
              width: double.infinity,
              height: 38,
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFFD97706) : const Color(0xFF2E7D5B),
                borderRadius: BorderRadius.circular(19),
                boxShadow: [
                  BoxShadow(
                    color: (isActive ? const Color(0xFFD97706) : const Color(0xFF2E7D5B)).withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  isActive ? '计时中' : '开始',
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
                  color: Color(0xFF2D2522),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                '千卡',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF8C7E77),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            totalCalories > 0 ? '已摄入 $totalCalories 千卡' : '目标 $goalCalories 千卡',
            style: const TextStyle(fontSize: 11.5, color: Color(0xFF8C7E77)),
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

  // ── Card: Weight (体重) ─────────────────────────────────────────────────────
  Widget _buildWeightCard(BuildContext context) {
    return _buildActionCard(
      title: '体重',
      icon: Icons.monitor_weight_outlined,
      iconColor: const Color(0xFF10B981),
      badgeBgColor: const Color(0xFFDCFCE7),
      onTap: () => context.push('/goal'),
      onQuickAdd: () => context.push('/goal'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: const [
              Text(
                '--',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF2D2522),
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(width: 4),
              Text(
                'kg',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF8C7E77),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            '目标 60.0 kg',
            style: TextStyle(fontSize: 11.5, color: Color(0xFF8C7E77)),
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () => context.push('/goal'),
            child: Container(
              width: double.infinity,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(19),
              ),
              child: const Center(
                child: Text(
                  '记录',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF059669),
                  ),
                ),
              ),
            ),
          ),
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
                  color: Color(0xFF2D2522),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                '步',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF8C7E77),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '目标 ${(progress * 100).toInt()}%',
            style: const TextStyle(fontSize: 11.5, color: Color(0xFF8C7E77)),
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
            '${(steps * 0.0007).toStringAsFixed(1)} km   ${(steps * 0.038).toInt()} kcal',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF8C7E77),
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
                'ml',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF8C7E77),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            '/ 2,000 ml',
            style: TextStyle(fontSize: 11.5, color: Color(0xFF8C7E77)),
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
                  color: Color(0xFF2D2522),
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            '深睡 2h 10m',
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
                  color: Color(0xFF2D2522),
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(width: 4),
              Text(
                'bpm',
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
            'HRV 42ms',
            style: TextStyle(fontSize: 11.5, color: Color(0xFF8C7E77)),
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
    String? subtitle,
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
              color: Color(0x067A533E),
              blurRadius: 14,
              offset: Offset(0, 3),
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
                        color: Color(0xFF2D2522),
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
                        color: Color(0xFFF6F2EB),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        size: 16,
                        color: Color(0xFF7D726D),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (subtitle != null && subtitle.isNotEmpty) ...[
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF7D726D),
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
