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
                  .copyWith(bottom: 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopHeader(context),
                  const SizedBox(height: 14),
                  _buildCalendarStrip(context),
                  const SizedBox(height: 16),
                  _buildStepsHeroCard(context, steps, record),
                  const SizedBox(height: 18),
                  _buildHabitCardsStream(context, record),
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

  // ── 3. Steps Hero Card ──────────────────────────────────────────────────────
  Widget _buildStepsHeroCard(BuildContext context, int steps, DailyHealthRecord record) {
    final progress = (steps / 10000).clamp(0.0, 1.0);
    final distanceKm = (steps * 0.0007).toStringAsFixed(2);
    final calories = (steps * 0.038).toInt();

    return GestureDetector(
      onTap: () => context.push('/sport'),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 16,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.directions_walk_rounded, size: 18, color: Color(0xFF6366F1)),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '步数',
                      style: TextStyle(
                        color: Color(0xFF1E1B4B),
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: const [
                    Text('详情', style: TextStyle(fontSize: 12, color: Color(0xFF6366F1), fontWeight: FontWeight.w600)),
                    Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFF6366F1)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
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
                              fontSize: 34,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1E1B4B),
                              letterSpacing: -1,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text('步', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '目标 10,000 步',
                        style: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 60,
                  height: 60,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 6,
                        backgroundColor: const Color(0xFFF1F5F9),
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
                      ),
                      Text(
                        '${(progress * 100).toInt()}%',
                        style: const TextStyle(
                          color: Color(0xFF1E1B4B),
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSubStat(Icons.route_rounded, '$distanceKm km', '公里', const Color(0xFF10B981)),
                  Container(width: 1, height: 20, color: const Color(0xFFE2E8F0)),
                  _buildSubStat(Icons.local_fire_department_rounded, '$calories kcal', '千卡', const Color(0xFFF97316)),
                  Container(width: 1, height: 20, color: const Color(0xFFE2E8F0)),
                  _buildSubStat(Icons.timer_outlined, '${steps ~/ 100} 分', '时长', const Color(0xFF0EA5E9)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubStat(IconData icon, String value, String label, Color color) {
    return Row(
      children: [
        Icon(icon, size: 15, color: color),
        const SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF1E1B4B))),
            Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
          ],
        ),
      ],
    );
  }

  // ── 5. Interactive Habit Cards Flow (OtterLife Style) ───────────────────────
  Widget _buildHabitCardsStream(BuildContext context, DailyHealthRecord record) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            '今日打卡',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E1B4B),
            ),
          ),
        ),
        // 2-Column Grid of Action Cards
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  // 💧 喝水打卡卡片
                  _buildWaterCard(context, record),
                  const SizedBox(height: 12),
                  // 🥗 饮食热量卡片
                  _buildDietCard(context, record),
                  const SizedBox(height: 12),
                  // ❤️ 心率与压力卡片
                  _buildVitalSignsCard(context, record),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                children: [
                  // ⏳ 轻断食卡片
                  _buildFastingCard(context),
                  const SizedBox(height: 12),
                  // 😴 睡眠与助眠卡片
                  _buildSleepCard(context, record),
                  const SizedBox(height: 12),
                  // 🧠 今日心情卡片
                  _buildMoodCard(context, record),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Card: Water Intake ──────────────────────────────────────────────────────
  Widget _buildWaterCard(BuildContext context, DailyHealthRecord record) {
    final waterProgress = (record.waterMl / 2000).clamp(0.0, 1.0);

    return _buildActionCard(
      title: '喝水',
      icon: Icons.water_drop_rounded,
      color: const Color(0xFF0EA5E9),
      onTap: () => context.push('/water'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('${record.waterMl}',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1E1B4B))),
              const Text(' / 2000ml',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF94A3B8))),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: waterProgress,
              minHeight: 5,
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0EA5E9)),
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
                  duration: Duration(milliseconds: 1200),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF0EA5E9).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  '+250ml',
                  style: TextStyle(
                    fontSize: 12,
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

  // ── Card: Fasting ───────────────────────────────────────────────────────────
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
      color: const Color(0xFFF97316),
      onTap: () => context.push('/fasting'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isActive ? '${elapsedH}h ${elapsedM}m' : '未开启',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E1B4B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isActive
                ? (timer.isOvertime ? '已达成目标' : '剩 ${remainH}h ${remainM}m')
                : '16:8 方案',
            style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => context.push('/fasting'),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF97316).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  isActive ? '计时器' : '开启断食',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFEA580C),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Card: Diet & Calorie ────────────────────────────────────────────────────
  Widget _buildDietCard(BuildContext context, DailyHealthRecord record) {
    final dietAsync = ref.watch(dietProvider);
    final totalCalories = dietAsync.valueOrNull?.totalCal.round() ?? record.dietCalories;
    final goalCalories = (dietAsync.valueOrNull?.goal ?? 2000).round();

    return _buildActionCard(
      title: '饮食',
      icon: Icons.restaurant_rounded,
      color: const Color(0xFF10B981),
      onTap: () => context.push('/diet'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('$totalCalories',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1E1B4B))),
              Text(' / ${goalCalories}kcal',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF94A3B8))),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => context.push('/ai-scan'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text('识图',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF059669))),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: GestureDetector(
                  onTap: () => context.push('/diet'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text('记一餐',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF475569))),
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

  // ── Card: Sleep ─────────────────────────────────────────────────────────────
  Widget _buildSleepCard(BuildContext context, DailyHealthRecord record) {
    final hours = record.sleepMins ~/ 60 > 0 ? record.sleepMins ~/ 60 : 7;
    final mins = record.sleepMins % 60 > 0 ? record.sleepMins % 60 : 45;

    return _buildActionCard(
      title: '睡眠',
      icon: Icons.nightlight_round,
      color: const Color(0xFF6366F1),
      onTap: () => context.push('/sleep'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('$hours',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1E1B4B))),
              const Text('h ', style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
              Text('$mins',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1E1B4B))),
              const Text('m · 优', style: TextStyle(fontSize: 12, color: Color(0xFF10B981), fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => context.push('/white-noise'),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  '助眠音',
                  style: TextStyle(
                    fontSize: 12,
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

  // ── Card: Vital Signs ───────────────────────────────────────────────────────
  Widget _buildVitalSignsCard(BuildContext context, DailyHealthRecord record) {
    return _buildActionCard(
      title: '心率',
      icon: Icons.favorite_rounded,
      color: const Color(0xFFF43F5E),
      onTap: () => context.push('/vital-signs'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              const Text('72',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1E1B4B))),
              const Text(' bpm · ', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
              Text(record.stressLevel,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF10B981))),
            ],
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => MeasureBottomSheet.show(context),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF43F5E).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  '测量',
                  style: TextStyle(
                    fontSize: 12,
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

  // ── Card: Mood Diary ────────────────────────────────────────────────────────
  Widget _buildMoodCard(BuildContext context, DailyHealthRecord record) {
    return _buildActionCard(
      title: '情绪',
      icon: Icons.mood_rounded,
      color: const Color(0xFFF59E0B),
      onTap: () => context.push('/mood'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            record.mood.isNotEmpty ? record.mood : '平静',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1B4B)),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => context.push('/mood'),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  '记录',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFD97706),
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
    required Color color,
    required Widget child,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 12,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 14, color: color),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: color,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}
