// 日常 Tab — 优雅浅色轻量风格 (OtterLife Light Unified Style)
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/health_providers.dart';
import '../../core/services/step_provider.dart' as svc;
import '../../l10n/app_localizations.dart';
import '../../l10n/app_l10n_ext.dart';

// ─── Design Tokens ────────────────────────────────────────────────────────
const _p1    = Color(0xFF0EA5E9); // Sky Blue (Steps)
const _p2    = Color(0xFF8B5CF6); // Purple (Sleep)
const _p3    = Color(0xFF10B981); // Emerald (Activity)
const _p4    = Color(0xFFF59E0B); // Amber (Calories)
const _water = Color(0xFF06B6D4); // Cyan (Water)

class DailyScreen extends ConsumerStatefulWidget {
  const DailyScreen({super.key});
  @override
  ConsumerState<DailyScreen> createState() => _DailyScreenState();
}

class _DailyScreenState extends ConsumerState<DailyScreen> {
  final int _range = 7; // Default to 7 days for trend charts

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
      children: [
        _OverviewCard(range: _range),
        const SizedBox(height: 22),
        _sectionTitle('今日四维健康'),
        const SizedBox(height: 12),
        _FourDimRow(range: _range),
        const SizedBox(height: 22),
        _sectionTitle('步数趋势'),
        const SizedBox(height: 12),
        _ChartCard(child: _StepsTrend(range: _range)),
        const SizedBox(height: 22),
        _sectionTitle('热量消耗 (kcal)'),
        const SizedBox(height: 12),
        _ChartCard(child: _CaloriesTrend(range: _range)),
        const SizedBox(height: 22),
        _sectionTitle('饮水补水 (ml)'),
        const SizedBox(height: 12),
        _ChartCard(child: _WaterTrend(range: _range)),
        const SizedBox(height: 22),
        _sectionTitle('睡眠时长 (小时)'),
        const SizedBox(height: 12),
        _ChartCard(child: _SleepTrend(range: _range)),
      ],
    );
  }

  Widget _sectionTitle(String t) => Padding(
    padding: const EdgeInsets.only(left: 4),
    child: Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          t,
          style: const TextStyle(
            color: Color(0xFF1E1B4B),
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.2,
          ),
        ),
      ],
    ),
  );
}

class _OverviewCard extends ConsumerWidget {
  final int range;
  const _OverviewCard({required this.range});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stepAsync = ref.watch(svc.stepProvider);
    final sportAsync = ref.watch(sportProvider);
    final waterAsync = ref.watch(waterProvider);
    final steps = stepAsync.valueOrNull?.todaySteps ?? 0;
    final goal  = stepAsync.valueOrNull?.goal ?? 10000;
    final progress = (steps / goal).clamp(0.0, 1.0);
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF38BDF8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withValues(alpha: 0.3),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(22),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              range == 1 ? '今天健康总览' : '本周健康总览',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '目标 ${goal} 步',
                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('$steps',
            style: const TextStyle(color: Colors.white, fontSize: 46, fontWeight: FontWeight.w900, height: 1)),
          const Padding(padding: EdgeInsets.only(bottom: 6, left: 6),
            child: Text('步', style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold))),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${(progress * 100).toInt()}%',
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
              const Text('完成度', style: TextStyle(color: Colors.white70, fontSize: 11)),
            ],
          ),
        ]),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress, minHeight: 8,
            backgroundColor: Colors.white.withValues(alpha: 0.25),
            valueColor: const AlwaysStoppedAnimation(Colors.white),
          ),
        ),
        const SizedBox(height: 18),
        Row(children: [
          _pill(Icons.local_fire_department_rounded, '${stepAsync.valueOrNull?.calories.toInt() ?? 0} kcal'),
          const SizedBox(width: 10),
          _pill(Icons.water_drop_rounded, '${waterAsync.valueOrNull?.todayTotal ?? 0} ml'),
          const SizedBox(width: 10),
          _pill(Icons.directions_run_rounded, '${sportAsync.valueOrNull?.length ?? 0} 次运动'),
        ]),
      ]),
    );
  }

  Widget _pill(IconData icon, String t) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.18),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, color: Colors.white, size: 14),
      const SizedBox(width: 5),
      Text(t, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
    ]),
  );
}

class _FourDimRow extends ConsumerWidget {
  final int range;
  const _FourDimRow({required this.range});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context).s;
    final stepAsync = ref.watch(svc.stepProvider);
    final sleepAsync = ref.watch(sleepProvider);
    final waterAsync = ref.watch(waterProvider);
    final sportAsync = ref.watch(sportProvider);
    final dur = sleepAsync.valueOrNull?.isNotEmpty == true ? sleepAsync.valueOrNull!.first.duration : 0;
    return Row(children: [
      Expanded(child: _Tile(icon: Icons.directions_walk_rounded, color: _p1, label: l.steps,
        value: '${stepAsync.valueOrNull?.todaySteps ?? 0}', unit: '步')),
      const SizedBox(width: 10),
      Expanded(child: _Tile(icon: Icons.bedtime_rounded, color: _p2, label: l.sleep,
        value: dur > 0 ? '${dur ~/ 60}h${dur % 60}m' : '--', unit: '')),
      const SizedBox(width: 10),
      Expanded(child: _Tile(icon: Icons.water_drop_rounded, color: _water, label: l.water,
        value: '${waterAsync.valueOrNull?.todayTotal ?? 0}', unit: 'ml')),
      const SizedBox(width: 10),
      Expanded(child: _Tile(icon: Icons.local_fire_department_rounded, color: _p4, label: l.calories,
        value: '${(sportAsync.valueOrNull?.fold<double>(0, (s, e) => s + (e.caloriesBurned ?? 0)) ?? 0).round()}', unit: 'kcal')),
    ]);
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label, value, unit;
  const _Tile({required this.icon, required this.color, required this.label, required this.value, required this.unit});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(
          color: Color(0x081E1B4B),
          blurRadius: 14,
          offset: Offset(0, 4),
        ),
      ],
      border: Border.all(color: const Color(0xFFF1F5F9)),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Container(width: 38, height: 38,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 20)),
      const SizedBox(height: 10),
      Text(value, style: const TextStyle(color: Color(0xFF1E1B4B), fontSize: 15, fontWeight: FontWeight.w800), maxLines: 1, overflow: TextOverflow.ellipsis),
      if (unit.isNotEmpty) Text(unit, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10, fontWeight: FontWeight.w500)),
      const SizedBox(height: 4),
      Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.w600)),
    ]),
  );
}

class _ChartCard extends StatelessWidget {
  final Widget child;
  const _ChartCard({required this.child});
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: const Color(0xFFF1F5F9)),
      boxShadow: const [
        BoxShadow(
          color: Color(0x061E1B4B),
          blurRadius: 16,
          offset: Offset(0, 4),
        ),
      ],
    ),
    padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
    child: SizedBox(height: 160, child: child),
  );
}

// ─── Charts ──────────────────────────────────────────────────────────────
class _StepsTrend extends ConsumerWidget {
  final int range;
  const _StepsTrend({required this.range});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final steps = ref.watch(svc.stepProvider).valueOrNull?.todaySteps ?? 0;
    
    final data = List.generate(range, (i) =>
      FlSpot(i.toDouble(), i == range - 1 ? steps.toDouble() : 0.0));
      
    double maxY = data.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    if (maxY == 0) maxY = 1000;
    
    return BarChart(BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: maxY * 1.3, minY: 0,
      barGroups: data.asMap().entries.map((e) => BarChartGroupData(x: e.key, barRods: [
        BarChartRodData(toY: e.value.y, width: 14,
          gradient: const LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter,
            colors: [Color(0xFF6366F1), Color(0xFF38BDF8)]),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6))),
      ])).toList(),
      gridData: FlGridData(show: true, drawVerticalLine: false,
        getDrawingHorizontalLine: (_) => const FlLine(color: Color(0xFFF1F5F9), strokeWidth: 1)),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 24,
          getTitlesWidget: (v, _) {
            if (v.toInt() < 0 || v.toInt() >= range) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(v.toInt() == range - 1 ? '今' : '${v.toInt() + 1}',
                style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.w600)),
            );
          })),
      ),
    ));
  }
}

Widget _lineChart(List<FlSpot> data, Color c, {double? maxY}) {
  return LineChart(LineChartData(
    minY: 0, maxY: maxY,
    gridData: FlGridData(show: true, drawVerticalLine: false,
      getDrawingHorizontalLine: (_) => const FlLine(color: Color(0xFFF1F5F9), strokeWidth: 1)),
    borderData: FlBorderData(show: false),
    titlesData: FlTitlesData(
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    ),
    lineBarsData: [LineChartBarData(
      spots: data, isCurved: true, curveSmoothness: 0.4, color: c, barWidth: 3,
      dotData: FlDotData(show: true, getDotPainter: (s, _, __, ___) =>
        FlDotCirclePainter(radius: 4, color: Colors.white, strokeWidth: 2.5, strokeColor: c)),
      belowBarData: BarAreaData(show: true, gradient: LinearGradient(
        begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [c.withValues(alpha: 0.25), c.withValues(alpha: 0.0)])),
    )],
  ));
}

class _CaloriesTrend extends ConsumerWidget {
  final int range;
  const _CaloriesTrend({required this.range});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(sportProvider).valueOrNull ?? [];
    final todayCalories = records.fold<double>(0, (s, e) => s + (e.caloriesBurned ?? 0));
    final data = List.generate(range, (i) => FlSpot(i.toDouble(),
      i == range - 1 ? todayCalories : 0.0));
    return _lineChart(data, _p4);
  }
}

class _WaterTrend extends ConsumerWidget {
  final int range;
  const _WaterTrend({required this.range});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(waterProvider).valueOrNull;
    final todayWater = (state?.todayTotal ?? 0).toDouble();
    final data = List.generate(range, (i) => FlSpot(i.toDouble(),
      i == range - 1 ? todayWater : 0.0));
    return _lineChart(data, _water);
  }
}

class _SleepTrend extends ConsumerWidget {
  final int range;
  const _SleepTrend({required this.range});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(sleepProvider).valueOrNull ?? [];
    final byDay = <int, int>{};
    for (final r in records) {
      final d = r.sleepTime;
      final key = d.year * 10000 + d.month * 100 + d.day;
      byDay[key] = r.duration;
    }
    final data = List.generate(range, (i) {
      final d = DateTime.now().subtract(Duration(days: range - 1 - i));
      final key = d.year * 10000 + d.month * 100 + d.day;
      return FlSpot(i.toDouble(), ((byDay[key] ?? 420) / 60).toDouble());
    });
    return _lineChart(data, _p2, maxY: 12);
  }
}
