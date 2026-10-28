import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/services/step_provider.dart' as step_svc;
import '../../core/services/daily_health_provider.dart';
import '../vital_signs/widgets/measure_bottom_sheet.dart';

class StepsScreen extends ConsumerStatefulWidget {
  const StepsScreen({super.key});

  @override
  ConsumerState<StepsScreen> createState() => _StepsScreenState();
}

class _StepsScreenState extends ConsumerState<StepsScreen> {
  @override
  Widget build(BuildContext context) {
    final stepAsync = ref.watch(step_svc.stepProvider);
    final steps = stepAsync.valueOrNull?.todaySteps ?? 4000;

    final healthAsync = ref.watch(dailyHealthProvider);
    final record = healthAsync.valueOrNull;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F8),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEFEBFA), Color(0xFFF3F4F8), Color(0xFFEBEFF9)],
            stops: [0.0, 0.4, 1.0],
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Header
                  Row(
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
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => context.push('/setting'),
                        child: Container(
                          width: 44,
                          height: 44,
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
                            border: Border.all(
                                color: Colors.white.withValues(alpha: 0.8)),
                          ),
                          child: const Icon(Icons.person_rounded,
                              color: Color(0xFF6366F1), size: 22),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildCalendarStrip(context),
                  const SizedBox(height: 16),
                  _buildPetCompanionArea(context, steps),
                  const SizedBox(height: 18),
                  if (record == null)
                    const Center(
                        child: CircularProgressIndicator(
                            color: Color(0xFF6366F1)))
                  else
                    Column(
                      children: [
                        // Steps hero card
                        _buildStepsHeroCard(steps, record),
                        const SizedBox(height: 14),
                        // 2-col grid cards
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  _buildWhiteCard(
                                    title: '睡眠',
                                    icon: Icons.nightlight_round,
                                    color: const Color(0xFF6366F1),
                                    onTap: () => _showSleepDialog(context, record),
                                    child: _buildSleepValue(record),
                                  ),
                                  const SizedBox(height: 12),
                                  _buildWhiteCard(
                                    title: '血氧',
                                    icon: Icons.air_rounded,
                                    color: const Color(0xFF10B981),
                                    onTap: () => MeasureBottomSheet.show(context),
                                    child: _buildSimpleValue(
                                        '${record.bloodOxygen.toInt()}', '%'),
                                  ),
                                  const SizedBox(height: 12),
                                  _buildWhiteCard(
                                    title: '喝水',
                                    icon: Icons.water_drop,
                                    color: const Color(0xFF0EA5E9),
                                    onTap: () => ref
                                        .read(dailyHealthProvider.notifier)
                                        .addWater(250),
                                    child:
                                        _buildSimpleValue('${record.waterMl}', 'ml'),
                                  ),
                                  const SizedBox(height: 12),
                                  _buildWhiteCard(
                                    title: '压力',
                                    icon: Icons.psychology,
                                    color: const Color(0xFFF59E0B),
                                    onTap: () => ref
                                        .read(dailyHealthProvider.notifier)
                                        .setStressLevel('放松'),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        record.stressLevel,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900,
                                            color: Color(0xFF1E1B4B)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                children: [
                                  _buildWhiteCard(
                                    title: '目标',
                                    icon: Icons.track_changes,
                                    color: const Color(0xFFEF4444),
                                    onTap: () => ref
                                        .read(dailyHealthProvider.notifier)
                                        .incrementGoal(),
                                    child: _buildGoalValue(record),
                                  ),
                                  const SizedBox(height: 12),
                                  _buildWhiteCard(
                                    title: 'HRV',
                                    icon: Icons.favorite,
                                    color: const Color(0xFFEC4899),
                                    onTap: () => MeasureBottomSheet.show(context),
                                    child: _buildHrvValue(record.hrv),
                                  ),
                                  const SizedBox(height: 12),
                                  _buildWhiteCard(
                                    title: '热量',
                                    icon: Icons.local_fire_department,
                                    color: const Color(0xFFF97316),
                                    onTap: () => context.push('/calorie'),
                                    child: _buildSimpleValue(
                                        NumberFormat('#,###').format(
                                            record.dietCalories > 0
                                                ? record.dietCalories
                                                : 2400),
                                        'kcal'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  const SizedBox(height: 28),
                  _buildMoreFeaturesSection(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Calendar Strip ──────────────────────────────────────────────────────────
  Widget _buildCalendarStrip(BuildContext context) {
    final now = DateTime.now();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      height: 84,
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
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, index) {
          final date = now.subtract(Duration(days: 6 - index));
          final isToday = index == 6;
          return Container(
            width: 44,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              gradient: isToday
                  ? const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF818CF8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isToday ? null : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${date.day}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: isToday ? Colors.white : const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 4),
                Icon(
                  Icons.pets,
                  size: 12,
                  color: isToday ? Colors.white : const Color(0xFFCBD5E1),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── Pet / Lottie Area (OtterLife Style) ────────────────────────────────────
  Widget _buildPetCompanionArea(BuildContext context, int steps) {
    final pct = (steps / 10000 * 100).clamp(0, 100).toInt();
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 20,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Lottie.asset(
                'assets/lottie/new_dashboard_zh.json',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Center(child: Text('🦫', style: TextStyle(fontSize: 80))),
              ),
            ),
          ),
          Positioned(
            bottom: 14,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.2)),
                ),
                child: Text(
                  pct >= 100 ? '目标达成 🎉' : '蒸蒸日上 ($pct%)',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF6366F1),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Steps Hero Card ─────────────────────────────────────────────────────────
  Widget _buildStepsHeroCard(int steps, DailyHealthRecord record) {
    final displaySteps = steps > 0 ? steps : 20000;
    final progress = (displaySteps / 10000).clamp(0.0, 1.0);
    return Container(
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
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.directions_walk,
                          size: 16, color: Color(0xFF6366F1)),
                    ),
                    const SizedBox(width: 8),
                    const Text('步数',
                        style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 14,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  NumberFormat('#,###').format(displaySteps),
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E1B4B),
                    letterSpacing: -1,
                  ),
                ),
                const Text('步',
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: const Color(0xFFF1F5F9),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF6366F1)),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  '目标 10,000 步',
                  style: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 11,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 8,
                  backgroundColor: const Color(0xFFF1F5F9),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF0EA5E9)),
                ),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: const TextStyle(
                      color: Color(0xFF1E1B4B),
                      fontSize: 15,
                      fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Generic White Card (OtterLife iOS Widget Style) ─────────────────────────
  Widget _buildWhiteCard({
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 14,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 14, color: color),
                ),
                const SizedBox(width: 6),
                Text(title,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: color)),
              ],
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }

  // ── Card Value Builders ─────────────────────────────────────────────────────
  Widget _buildSimpleValue(String value, String unit) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(value,
            style: const TextStyle(
                fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1E1B4B))),
        const SizedBox(width: 3),
        Padding(
          padding: const EdgeInsets.only(bottom: 3),
          child: Text(unit,
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF94A3B8))),
        ),
      ],
    );
  }

  Widget _buildSleepValue(DailyHealthRecord record) {
    int hours = record.sleepMins ~/ 60;
    int mins = record.sleepMins % 60;
    if (hours == 0 && mins == 0) {
      hours = 10;
      mins = 54;
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text('$hours',
            style: const TextStyle(
                fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1E1B4B))),
        const Text('h ',
            style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
        Text('$mins',
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1B4B))),
        const Text('m',
            style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
      ],
    );
  }

  Widget _buildGoalValue(DailyHealthRecord record) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text('${record.goalCompleted}',
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E1B4B))),
            const Text('/4',
                style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF94A3B8),
                    fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: record.goalCompleted / 4,
            minHeight: 5,
            backgroundColor: const Color(0xFFF1F5F9),
            valueColor:
                const AlwaysStoppedAnimation<Color>(Color(0xFFEF4444)),
          ),
        ),
      ],
    );
  }

  Widget _buildHrvValue(int hrv) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSimpleValue('$hrv', 'ms'),
        const SizedBox(height: 8),
        Container(
          height: 4,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            gradient: const LinearGradient(
              colors: [Color(0xFFEC4899), Color(0xFF38BDF8)],
            ),
          ),
        ),
      ],
    );
  }

  // ── More Features Grid ──────────────────────────────────────────────────────
  Widget _buildMoreFeaturesSection(BuildContext context) {
    final features = [
      _FeatureItem('冥想', Icons.self_improvement, const Color(0xFF8B5CF6), '/relax'),
      _FeatureItem('白噪音', Icons.music_note, const Color(0xFF0EA5E9), '/white-noise'),
      _FeatureItem('断食', Icons.timer_outlined, const Color(0xFFF97316), '/fasting'),
      _FeatureItem('情绪', Icons.mood, const Color(0xFFF59E0B), '/mood'),
      _FeatureItem('经期', Icons.favorite_border, const Color(0xFFEC4899), '/period'),
      _FeatureItem('便便', Icons.emoji_nature, const Color(0xFF844D19), '/poop'),
      _FeatureItem('饮食', Icons.restaurant, const Color(0xFF10B981), '/diet'),
      _FeatureItem('卡路里', Icons.local_fire_department, const Color(0xFFEF4444), '/calorie'),
      _FeatureItem('体重', Icons.monitor_weight_outlined, const Color(0xFF3B82F6), '/weight'),
      _FeatureItem('训练计划', Icons.fitness_center, const Color(0xFF6366F1), '/training-plan'),
      _FeatureItem('运动库', Icons.directions_run, const Color(0xFF059669), '/movement-library'),
      _FeatureItem('AI 扫描', Icons.document_scanner, const Color(0xFF6366F1), '/ai-scan'),
      _FeatureItem('体测记录', Icons.accessibility_new, const Color(0xFF06B6D4), '/body-record'),
      _FeatureItem('生命体征', Icons.monitor_heart, const Color(0xFFF43F5E), '/vital-signs'),
      _FeatureItem('成就', Icons.emoji_events, const Color(0xFFD97706), '/achievements'),
      _FeatureItem('步数目标', Icons.flag, const Color(0xFF16A34A), '/count-step'),
      _FeatureItem('体型记录', Icons.straighten, const Color(0xFFA855F7), '/body-record-info'),
      _FeatureItem('睡眠助手', Icons.bedtime, const Color(0xFF4F46E5), '/sleep'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 14),
          child: Text(
            '更多功能',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E1B4B),
              letterSpacing: -0.3,
            ),
          ),
        ),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.88,
          ),
          itemCount: features.length,
          itemBuilder: (context, index) {
            final f = features[index];
            return GestureDetector(
              onTap: () => context.push(f.route),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0A000000),
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: f.color.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(f.icon, color: f.color, size: 20),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      f.label,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF334155),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // ── Sleep Dialog ────────────────────────────────────────────────────────────
  void _showSleepDialog(BuildContext context, DailyHealthRecord record) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(24),
          height: 220,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('添加睡眠',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1B4B))),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _sleepButton(ctx, '7 小时', 7 * 60),
                  _sleepButton(ctx, '8 小时', 8 * 60),
                  _sleepButton(ctx, '9 小时', 9 * 60),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget _sleepButton(BuildContext ctx, String label, int mins) {
    return ElevatedButton(
      onPressed: () {
        ref.read(dailyHealthProvider.notifier).setSleep(mins);
        Navigator.pop(ctx);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6366F1),
        foregroundColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
    );
  }
}

class _FeatureItem {
  final String label;
  final IconData icon;
  final Color color;
  final String route;
  const _FeatureItem(this.label, this.icon, this.color, this.route);
}
