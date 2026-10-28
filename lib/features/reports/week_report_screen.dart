// 周报 — 霓虹玻璃态风格 (OtterLife Style)
import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/app_l10n_ext.dart';
import 'report_provider.dart';

class WeekReportInnerScreen extends ConsumerStatefulWidget {
  const WeekReportInnerScreen({super.key});
  @override
  ConsumerState<WeekReportInnerScreen> createState() => _WeekReportInnerScreenState();
}

class _WeekReportInnerScreenState extends ConsumerState<WeekReportInnerScreen> {
  int _tab = 0; // 0=步数 1=热量 2=体重 3=睡眠

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context).s;
    final reportAsync = ref.watch(weeklyReportProvider);
    
    return Container(
      color: Colors.transparent,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingMd, vertical: 6),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _tabBtn(l.steps, 0),
                  const SizedBox(width: 8),
                  _tabBtn(l.calories, 1),
                  const SizedBox(width: 8),
                  _tabBtn(l.weight, 2),
                  const SizedBox(width: 8),
                  _tabBtn(l.sleep, 3),
                ],
              ),
            ),
          ),
          Expanded(
            child: reportAsync.when(
              loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
              error: (e, st) => Center(child: Text('加载失败: $e', style: const TextStyle(color: Colors.white))),
              data: (data) => ListView(
                padding: const EdgeInsets.all(AppDimens.spacingMd),
                children: [
                  // 头部
                  Container(
                    padding: const EdgeInsets.all(AppDimens.spacingLg),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft, end: Alignment.bottomRight,
                        colors: _getGradient(),
                      ),
                      borderRadius: BorderRadius.circular(AppDimens.radiusCard),
                      boxShadow: [
                        BoxShadow(color: _getGradient().first.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8))
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_getSummaryText(l),
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13)),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(_getMainValue(data),
                              style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 6),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(_getUnit(l),
                                style: const TextStyle(color: Colors.white70, fontSize: 16)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // 每日柱图/折线图
                  _SectionCard(
                    title: l.dailyBreakdown,
                    color: _getMainColor(),
                    child: SizedBox(
                      height: 180,
                      child: _tab == 2 
                          ? _TrendChart(tab: _tab, data: data) 
                          : _DailyBarChart(tab: _tab, data: data),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // 趋势线 (只有不为体重时显示)
                  if (_tab != 2) ...[
                    _SectionCard(
                      title: l.weeklyTrend,
                      color: _getSecondaryColor(),
                      child: SizedBox(
                        height: 180,
                        child: _TrendChart(tab: _tab, data: data),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  // 4 维度
                  Text(l.weekDimension, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _DimBox(label: l.avgDay, value: _getAvgValue(data), unit: _getUnit(l), color: _getMainColor())),
                      const SizedBox(width: 12),
                      Expanded(child: _DimBox(label: l.bestDay, value: _getBestValue(data), unit: _getUnit(l), color: const Color(0xFF10B981))),
                    ],
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: () => context.push('/achievement-poster'),
                      icon: const Icon(Icons.share_rounded, color: Colors.white),
                      label: const Text('生成成就海报', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF38BDF8),
                        shadowColor: const Color(0xFF38BDF8).withValues(alpha: 0.5),
                        elevation: 8,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100), // padding for bottom nav
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _getGradient() {
    if (_tab == 0) return const [Color(0xFF38BDF8), Color(0xFF2563EB)]; // Light Blue
    if (_tab == 1) return const [Color(0xFFFBBF24), Color(0xFFD97706)]; // Amber
    if (_tab == 2) return const [Color(0xFF60A5FA), Color(0xFF2563EB)]; // Blue
    return const [Color(0xFFC084FC), Color(0xFF7E22CE)]; // Purple
  }

  Color _getMainColor() {
    if (_tab == 0) return const Color(0xFF38BDF8);
    if (_tab == 1) return const Color(0xFFF59E0B);
    if (_tab == 2) return const Color(0xFF60A5FA);
    return const Color(0xFF8B5CF6);
  }

  Color _getSecondaryColor() {
    if (_tab == 0) return const Color(0xFF2563EB);
    if (_tab == 1) return const Color(0xFFD97706);
    if (_tab == 2) return const Color(0xFF3B82F6);
    return const Color(0xFF7E22CE);
  }

  String _getSummaryText(dynamic l) {
    if (_tab == 0) return l.weekStepSummary;
    if (_tab == 1) return l.weekCalSummary;
    if (_tab == 2) return l.weight;
    return l.sleep;
  }

  String _getUnit(dynamic l) {
    if (_tab == 0) return l.unitStep;
    if (_tab == 1) return 'kcal';
    if (_tab == 2) return 'kg';
    return l.minute;
  }

  String _getMainValue(WeeklyReportData data) {
    if (_tab == 0) return NumberFormat('#,###').format(data.totalSteps);
    if (_tab == 1) return NumberFormat('#,###').format(data.totalCalories);
    if (_tab == 2) return data.avgWeight.toStringAsFixed(1);
    if (_tab == 3) {
      final h = data.avgSleepMins ~/ 60;
      final m = data.avgSleepMins % 60;
      return '${h}h ${m}m';
    }
    return '0';
  }

  String _getAvgValue(WeeklyReportData data) {
    if (_tab == 0) return NumberFormat('#,###').format(data.totalSteps ~/ 7);
    if (_tab == 1) return NumberFormat('#,###').format(data.totalCalories ~/ 7);
    if (_tab == 2) return data.avgWeight.toStringAsFixed(1);
    if (_tab == 3) return data.avgSleepMins.toString();
    return '0';
  }

  String _getBestValue(WeeklyReportData data) {
    if (_tab == 0) return NumberFormat('#,###').format(data.bestSteps);
    if (_tab == 1) return NumberFormat('#,###').format(data.bestCalories);
    if (_tab == 2) return data.bestWeight.toStringAsFixed(1);
    if (_tab == 3) return data.bestSleepMins.toString();
    return '0';
  }

  Widget _tabBtn(String label, int idx) {
    final sel = idx == _tab;
    return InkWell(
      onTap: () => setState(() => _tab = idx),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: sel ? _getMainColor() : Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: sel ? Colors.transparent : Colors.white.withValues(alpha: 0.2)),
        ),
        child: Text(label, style: TextStyle(
          color: sel ? Colors.white : Colors.white70, fontSize: 13, fontWeight: FontWeight.w600,
        )),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Color color;
  final Widget child;
  const _SectionCard({required this.title, required this.color, required this.child});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimens.radiusCard),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.all(AppDimens.spacingMd),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(AppDimens.radiusCard),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 6, height: 16,
                    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
                  ),
                  const SizedBox(width: 8),
                  Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 16),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _DailyBarChart extends StatelessWidget {
  final int tab;
  final WeeklyReportData data;
  const _DailyBarChart({required this.tab, required this.data});
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final days = List.generate(7, (i) {
      final d = now.subtract(Duration(days: 6 - i));
      return DateFormat('E').format(d);
    });
    
    final values = tab == 0 ? data.dailySteps : (tab == 1 ? data.dailyCalories : data.dailySleepMins);
    final maxV = values.isEmpty ? 100 : values.reduce((a, b) => a > b ? a : b);
    
    Color color = const Color(0xFF38BDF8);
    if (tab == 1) color = const Color(0xFFF59E0B);
    if (tab == 3) color = const Color(0xFF8B5CF6);
    
    return BarChart(BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: maxV * 1.2 == 0 ? 100 : maxV * 1.2, minY: 0,
      barGroups: List.generate(7, (i) => BarChartGroupData(
        x: i, barRods: [BarChartRodData(
          toY: values[i].toDouble(), color: color, width: 18,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
        )],
      )),
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(sideTitles: SideTitles(
          showTitles: true, reservedSize: 22,
          getTitlesWidget: (v, _) => Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(v.toInt() >= 0 && v.toInt() < 7 ? days[v.toInt()] : '',
              style: const TextStyle(color: Colors.white54, fontSize: 11)),
          ),
        )),
      ),
    ));
  }
}

class _TrendChart extends StatelessWidget {
  final int tab;
  final WeeklyReportData data;
  const _TrendChart({required this.tab, required this.data});
  @override
  Widget build(BuildContext context) {
    final values = tab == 0 ? data.dailySteps : (tab == 1 ? data.dailyCalories : (tab == 2 ? data.dailyWeight : data.dailySleepMins));
    final spots = List.generate(7, (i) => FlSpot(i.toDouble(), values[i].toDouble()));
    
    Color color = const Color(0xFF38BDF8);
    if (tab == 1) color = const Color(0xFFF59E0B);
    if (tab == 2) color = const Color(0xFF60A5FA);
    if (tab == 3) color = const Color(0xFF8B5CF6);
    
    final minV = values.isEmpty ? 0 : values.reduce((a, b) => a < b ? a : b);
    final maxV = values.isEmpty ? 100 : values.reduce((a, b) => a > b ? a : b);
    
    return LineChart(LineChartData(
      minY: tab == 2 ? (minV * 0.9) : 0,
      maxY: maxV * 1.1 == 0 ? 100 : maxV * 1.1,
      gridData: FlGridData(
        show: true, drawVerticalLine: false,
        horizontalInterval: (maxV - minV > 0) ? (maxV - minV) / 4 : 2000,
        getDrawingHorizontalLine: (_) => FlLine(color: Colors.white.withValues(alpha: 0.1), strokeWidth: 1),
      ),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      lineBarsData: [LineChartBarData(
        spots: spots, isCurved: true, color: color, barWidth: 3,
        dotData: FlDotData(show: true, getDotPainter: (s, _, __, ___) =>
          FlDotCirclePainter(radius: 4, color: color, strokeWidth: 2, strokeColor: Colors.white)),
        belowBarData: BarAreaData(show: true, gradient: LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [color.withValues(alpha: 0.3), color.withValues(alpha: 0)],
        )),
      )],
    ));
  }
}

class _DimBox extends StatelessWidget {
  final String label, value, unit;
  final Color color;
  const _DimBox({required this.label, required this.value, required this.unit, required this.color});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(value, style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 4),
                  Padding(padding: const EdgeInsets.only(bottom: 3),
                    child: Text(unit, style: const TextStyle(color: Colors.white54, fontSize: 11))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
