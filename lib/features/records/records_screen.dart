// 日常 Tab — 霓虹玻璃态风格 (OtterLife Style)
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/health_providers.dart';
import '../../core/services/step_provider.dart' as svc;
import '../../l10n/app_localizations.dart';
import '../../l10n/app_l10n_ext.dart';

// ─── Design Tokens ────────────────────────────────────────────────────────
const _p1    = Color(0xFF38BDF8); // Light Blue
const _p2    = Color(0xFF8B5CF6); // Purple
const _p3    = Color(0xFF10B981); // Emerald
const _p4    = Color(0xFFF59E0B); // Amber
const _water = Color(0xFF06B6D4); // Cyan

class DailyScreen extends ConsumerStatefulWidget {
  const DailyScreen({super.key});
  @override
  ConsumerState<DailyScreen> createState() => _DailyScreenState();
}

class _DailyScreenState extends ConsumerState<DailyScreen> {
  final int _range = 7; // Default to 7 days for trend charts

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent, // Background handled by ReportsHostScreen
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: [
          _OverviewCard(range: _range),
          const SizedBox(height: 24),
          _sectionTitle('今日四维'),
          const SizedBox(height: 16),
          _FourDimRow(range: _range),
          const SizedBox(height: 24),
          _sectionTitle('步数趋势'),
          const SizedBox(height: 16),
          _ChartCard(child: _StepsTrend(range: _range)),
          const SizedBox(height: 24),
          _sectionTitle('热量消耗'),
          const SizedBox(height: 16),
          _ChartCard(child: _CaloriesTrend(range: _range)),
          const SizedBox(height: 24),
          _sectionTitle('饮水'),
          const SizedBox(height: 16),
          _ChartCard(child: _WaterTrend(range: _range)),
          const SizedBox(height: 24),
          _sectionTitle('睡眠'),
          const SizedBox(height: 16),
          _ChartCard(child: _SleepTrend(range: _range)),
        ],
      ),
    );
  }

  Widget _sectionTitle(String t) => Padding(
    padding: const EdgeInsets.only(left: 4),
    child: Text(t, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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
        gradient: const LinearGradient(colors: [Color(0xFF38BDF8), Color(0xFF2563EB)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: const Color(0xFF2563EB).withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      padding: const EdgeInsets.all(22),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(range == 1 ? '今天' : '本周',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13)),
        const SizedBox(height: 8),
        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('$steps',
            style: const TextStyle(color: Colors.white, fontSize: 52, fontWeight: FontWeight.w800, height: 1)),
          const Padding(padding: EdgeInsets.only(bottom: 8, left: 6),
            child: Text('步', style: TextStyle(color: Colors.white70, fontSize: 17))),
          const Spacer(),
          Text('${(progress * 100).toInt()}%',
            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
        ]),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress, minHeight: 6,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            valueColor: const AlwaysStoppedAnimation(Colors.white),
          ),
        ),
        const SizedBox(height: 18),
        Row(children: [
          _pill(Icons.local_fire_department_rounded, '${stepAsync.valueOrNull?.calories.toInt() ?? 0} kcal'),
          const SizedBox(width: 14),
          _pill(Icons.water_drop_rounded, '${waterAsync.valueOrNull?.todayTotal ?? 0} ml'),
          const SizedBox(width: 14),
          _pill(Icons.directions_run_rounded, '${sportAsync.valueOrNull?.length ?? 0} 次运动'),
        ]),
      ]),
    );
  }

  Widget _pill(IconData icon, String t) => Row(mainAxisSize: MainAxisSize.min, children: [
    Icon(icon, color: Colors.white70, size: 14),
    const SizedBox(width: 6),
    Flexible(child: Text(t, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis)),
  ]);
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
      const SizedBox(width: 12),
      Expanded(child: _Tile(icon: Icons.bedtime_rounded, color: _p2, label: l.sleep,
        value: dur > 0 ? '${dur ~/ 60}h${dur % 60}m' : '--', unit: '')),
      const SizedBox(width: 12),
      Expanded(child: _Tile(icon: Icons.water_drop_rounded, color: _water, label: l.water,
        value: '${waterAsync.valueOrNull?.todayTotal ?? 0}', unit: 'ml')),
      const SizedBox(width: 12),
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
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 1),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(width: 36, height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: color.withValues(alpha: 0.2), blurRadius: 8)],
            ),
            child: Icon(icon, color: color, size: 20)),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
          if (unit.isNotEmpty) Text(unit, style: const TextStyle(color: Colors.white54, fontSize: 10)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        ]),
      ),
    ),
  );
}

class _ChartCard extends StatelessWidget {
  final Widget child;
  const _ChartCard({required this.child});
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(24),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
        ),
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        child: SizedBox(height: 160, child: child),
      ),
    ),
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
            colors: [Color(0xFF2563EB), Color(0xFF38BDF8)]),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6))),
      ])).toList(),
      gridData: FlGridData(show: true, drawVerticalLine: false,
        getDrawingHorizontalLine: (_) => FlLine(color: Colors.white.withValues(alpha: 0.05), strokeWidth: 1)),
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
                style: const TextStyle(color: Colors.white54, fontSize: 11)),
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
      getDrawingHorizontalLine: (_) => FlLine(color: Colors.white.withValues(alpha: 0.05), strokeWidth: 1)),
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
        FlDotCirclePainter(radius: 4, color: c, strokeWidth: 2, strokeColor: Colors.white)),
      belowBarData: BarAreaData(show: true, gradient: LinearGradient(
        begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [c.withValues(alpha: 0.3), c.withValues(alpha: 0.0)])),
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
