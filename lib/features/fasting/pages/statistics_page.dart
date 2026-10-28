import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../core/constants/app_constants.dart' as constants;
import '../models/fasting_session.dart';
import '../providers/fasting_provider.dart';
import '../providers/water_provider.dart';
import '../providers/weight_provider.dart';
import 'package:steps_webu_flutter/core/theme/app_colors.dart';

class StatisticsView extends ConsumerWidget {
  const StatisticsView({super.key});

  static const _ink = AppColors.textPrimary;
  static const _muted = AppColors.textSecondary;
  static const _leaf = AppColors.primary;
  static const _leafDark = AppColors.primaryDark;
  static const _water = AppColors.info;
  static const _berry = AppColors.primary;
  static const _sun = AppColors.warning;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInsightHero(context, ref),
        const SizedBox(height: 22),
        _sectionTitle('成长洞察', '断食节律'),
        const SizedBox(height: 14),
        _buildFastingRecordsChart(context, ref),
        const SizedBox(height: 14),
        _buildSuccessRateChart(context, ref),
        const SizedBox(height: 22),
        _sectionTitle('身体趋势', '水分与体重'),
        const SizedBox(height: 14),
        _buildWeightTrend(context, ref),
        const SizedBox(height: 14),
        _buildWaterTrend(context, ref),
      ],
    );
  }

  Widget _buildInsightHero(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(fastingSessionsProvider);
    final latestWeight = ref.watch(latestWeightRecordProvider);
    final todayWater = ref.watch(todayWaterTotalProvider);

    return sessionsAsync.when(
      data: (sessions) {
        final completed = sessions
            .where((s) => s.status == constants.FastingStatus.completed)
            .toList();
        final totalHours = completed.fold<double>(
          0,
          (sum, item) => sum + item.actualFastingDurationHours,
        );
        final avgSuccess = completed.isEmpty
            ? 0.0
            : completed.map((s) => s.successRate).reduce((a, b) => a + b) /
                  completed.length;
        final last7 = _last7Days();
        final activeDays = last7.where((day) {
          return sessions.any((s) => _isSameDay(s.startTime, day));
        }).length;
        final forestLevel = completed.length >= 12
            ? '繁茂森林'
            : completed.length >= 5
            ? '稳定生长'
            : completed.isNotEmpty
            ? '新芽阶段'
            : '等待发芽';

        return Container(
          padding: const EdgeInsets.all(18),
          decoration: _panelDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _insightBadge(completed.length),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          forestLevel,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: _ink,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          completed.isEmpty
                              ? '完成一次断食后，这里会生成你的成长分析。'
                              : '最近 7 天点亮 $activeDays 天，平均完成度 ${avgSuccess.toStringAsFixed(0)}%。',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: _muted,
                                fontWeight: FontWeight.w400,
                                height: 1.35,
                              ),
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(99.0),
                          child: LinearProgressIndicator(
                            minHeight: 9,
                            value: (avgSuccess / 100).clamp(0.0, 1.0),
                            backgroundColor: AppColors.divider,
                            valueColor: const AlwaysStoppedAnimation(_leaf),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _metricTile(
                      context,
                      '完成次数',
                      '${completed.length}',
                      Icons.done_all_rounded,
                      _leaf,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _metricTile(
                      context,
                      '累计时长',
                      '${totalHours.toStringAsFixed(1)}h',
                      Icons.hourglass_bottom_rounded,
                      _sun,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: latestWeight.when(
                      data: (record) => _metricTile(
                        context,
                        '当前体重',
                        record == null
                            ? '--'
                            : '${record.weight.toStringAsFixed(1)}kg',
                        Icons.monitor_weight_rounded,
                        _berry,
                      ),
                      loading: () => _metricTile(
                        context,
                        '当前体重',
                        '...',
                        Icons.monitor_weight_rounded,
                        _berry,
                      ),
                      error: (_, __) => _metricTile(
                        context,
                        '当前体重',
                        '--',
                        Icons.monitor_weight_rounded,
                        _berry,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: todayWater.when(
                      data: (value) => _metricTile(
                        context,
                        '今日饮水',
                        '${(value / 1000).toStringAsFixed(1)}L',
                        Icons.water_drop_rounded,
                        _water,
                      ),
                      loading: () => _metricTile(
                        context,
                        '今日饮水',
                        '...',
                        Icons.water_drop_rounded,
                        _water,
                      ),
                      error: (_, __) => _metricTile(
                        context,
                        '今日饮水',
                        '--',
                        Icons.water_drop_rounded,
                        _water,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => _loadingPanel(),
      error: (_, __) => _emptyPanel(context, '分析数据加载失败'),
    );
  }

  Widget _buildFastingRecordsChart(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(fastingSessionsProvider);

    return _analysisPanel(
      context,
      title: '7 天断食路线',
      subtitle: '深色为实际完成，浅色为目标时长',
      icon: Icons.route_rounded,
      accent: _leaf,
      child: SizedBox(
        height: 210,
        child: sessionsAsync.when(
          data: (sessions) {
            final days = _last7Days();
            final data = List.generate(
              days.length,
              (_) => <String, double>{'actual': 0, 'target': 0},
            );

            for (final session in sessions) {
              final index = days.indexWhere(
                (day) => _isSameDay(day, session.startTime),
              );
              if (index == -1) continue;
              data[index]['actual'] =
                  data[index]['actual']! + session.actualFastingDurationHours;
              data[index]['target'] = math.max(
                data[index]['target']!,
                session.fastingHours.toDouble(),
              );
            }

            final hasData = data.any(
              (item) => item['actual']! > 0 || item['target']! > 0,
            );
            if (!hasData) return _chartEmpty(context, '暂无断食记录');

            var maxHours = 16.0;
            for (final item in data) {
              maxHours = math.max(maxHours, item['actual']!);
              maxHours = math.max(maxHours, item['target']!);
            }

            return BarChart(
              BarChartData(
                maxY: maxHours * 1.12,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) => const FlLine(
                    color: AppColors.divider,
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 26,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= days.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 7),
                          child: Text(
                            DateFormat('E', 'zh_CN').format(days[index]),
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: _muted,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: List.generate(days.length, (index) {
                  final actual = data[index]['actual']!;
                  final target = data[index]['target']!;
                  return BarChartGroupData(
                    x: index,
                    barsSpace: 2,
                    barRods: [
                      BarChartRodData(
                        toY: target <= 0 ? maxHours * 0.08 : target,
                        color: AppColors.divider,
                        width: 10,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      BarChartRodData(
                        toY: actual,
                        color: _leaf,
                        width: 10,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ],
                  );
                }),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => _chartEmpty(context, '断食记录加载失败'),
        ),
      ),
    );
  }

  Widget _buildSuccessRateChart(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(fastingSessionsProvider);

    return _analysisPanel(
      context,
      title: '完成度分布',
      subtitle: '按目标完成比例分组，判断断食强度是否合适',
      icon: Icons.spa_rounded,
      accent: _sun,
      child: SizedBox(
        height: 214,
        child: sessionsAsync.when(
          data: (sessions) {
            final completed = sessions
                .where((s) => s.status == constants.FastingStatus.completed)
                .toList();
            if (completed.isEmpty) return _chartEmpty(context, '暂无完成记录');

            final excellent = completed
                .where((s) => s.successRate >= 90)
                .length;
            final good = completed
                .where((s) => s.successRate >= 70 && s.successRate < 90)
                .length;
            final fair = completed
                .where((s) => s.successRate >= 50 && s.successRate < 70)
                .length;
            final poor = completed.where((s) => s.successRate < 50).length;

            final sections = [
              _pieSection('优秀', excellent, _leaf),
              _pieSection('良好', good, _water),
              _pieSection('一般', fair, _sun),
              _pieSection('调整', poor, AppColors.error),
            ].where((item) => item.value > 0).toList();

            return Row(
              children: [
                Expanded(
                  child: PieChart(
                    PieChartData(
                      sections: sections,
                      centerSpaceRadius: 40,
                      sectionsSpace: 3,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _legendRow('优秀', excellent, _leaf),
                      _legendRow('良好', good, _water),
                      _legendRow('一般', fair, _sun),
                      _legendRow('需调整', poor, AppColors.error),
                    ],
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => _chartEmpty(context, '完成度加载失败'),
        ),
      ),
    );
  }

  Widget _buildWeightTrend(BuildContext context, WidgetRef ref) {
    final weightRecordsAsync = ref.watch(weightRecordsProvider);

    return _analysisPanel(
      context,
      title: '体重曲线',
      subtitle: '最近记录会在这里形成趋势线',
      icon: Icons.monitor_weight_rounded,
      accent: _berry,
      child: SizedBox(
        height: 210,
        child: weightRecordsAsync.when(
          data: (records) {
            if (records.isEmpty) return _chartEmpty(context, '暂无体重数据');
            final recent = records.take(7).toList().reversed.toList();
            if (recent.length < 2) return _chartEmpty(context, '至少 2 条记录后生成趋势');

            final minWeight = recent.map((r) => r.weight).reduce(math.min);
            final maxWeight = recent.map((r) => r.weight).reduce(math.max);
            final range = math.max(maxWeight - minWeight, 1.0);

            return LineChart(
              LineChartData(
                minX: 0,
                maxX: (recent.length - 1).toDouble(),
                minY: minWeight - range * 0.25,
                maxY: maxWeight + range * 0.25,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) => const FlLine(
                    color: AppColors.divider,
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= recent.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 7),
                          child: Text(
                            DateFormat(
                              'M月d日',
                              'zh_CN',
                            ).format(recent[index].recordTime),
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: _muted,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 38,
                      getTitlesWidget: (value, meta) => Text(
                        value.toStringAsFixed(0),
                        style: Theme.of(
                          context,
                        ).textTheme.labelSmall?.copyWith(color: _muted),
                      ),
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: recent.asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(), entry.value.weight);
                    }).toList(),
                    isCurved: true,
                    color: _berry,
                    barWidth: 4,
                    dotData: FlDotData(
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: _berry,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: _berry.withValues(alpha: 0.12),
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => _chartEmpty(context, '体重数据加载失败'),
        ),
      ),
    );
  }

  Widget _buildWaterTrend(BuildContext context, WidgetRef ref) {
    final waterRecordsAsync = ref.watch(waterRecordsProvider);

    return _analysisPanel(
      context,
      title: '补水节奏',
      subtitle: '最近 7 天饮水量，目标建议保持在 2L 左右',
      icon: Icons.water_drop_rounded,
      accent: _water,
      child: SizedBox(
        height: 210,
        child: waterRecordsAsync.when(
          data: (records) {
            final days = _last7Days();
            final daily = List<double>.filled(7, 0);
            for (final record in records) {
              final index = days.indexWhere(
                (day) => _isSameDay(day, record.recordTime),
              );
              if (index != -1) daily[index] += record.amount;
            }

            if (daily.every((value) => value <= 0)) {
              return _chartEmpty(context, '暂无饮水数据');
            }

            final maxWater = math.max(2000.0, daily.reduce(math.max));
            return BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxWater * 1.2,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) => const FlLine(
                    color: AppColors.divider,
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36,
                      getTitlesWidget: (value, meta) => Text(
                        '${(value / 1000).toStringAsFixed(0)}L',
                        style: Theme.of(
                          context,
                        ).textTheme.labelSmall?.copyWith(color: _muted),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= days.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 7),
                          child: Text(
                            DateFormat('E', 'zh_CN').format(days[index]),
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: _muted,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: List.generate(days.length, (index) {
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: daily[index],
                        color: _water,
                        width: 18,
                        borderRadius: BorderRadius.circular(10),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: 2000,
                          color: _water.withValues(alpha: 0.12),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => _chartEmpty(context, '饮水数据加载失败'),
        ),
      ),
    );
  }

  Widget _analysisPanel(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accent,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _panelDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Icon(icon, color: accent, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: _ink,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: _muted,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _metricTile(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: _ink,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: _muted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, String tag) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: _ink,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: _leaf.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(99.0),
          ),
          child: Text(
            tag,
            style: const TextStyle(
              color: _leafDark,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _chartEmpty(BuildContext context, String text) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.divider),
            ),
            child: const Icon(Icons.eco_rounded, color: _leaf),
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: _muted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _loadingPanel() {
    return Container(
      height: 230,
      decoration: _panelDecoration(),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _emptyPanel(BuildContext context, String text) {
    return Container(
      height: 180,
      decoration: _panelDecoration(),
      child: _chartEmpty(context, text),
    );
  }

  Widget _legendRow(String label, int value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: _muted,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            '$value',
            style: const TextStyle(
              color: _ink,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  PieChartSectionData _pieSection(String label, int value, Color color) {
    return PieChartSectionData(
      value: value.toDouble(),
      title: value == 0 ? '' : '$label\n$value',
      color: color,
      radius: 58,
      titleStyle: const TextStyle(
        color: Colors.white,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        height: 1.15,
      ),
    );
  }

  BoxDecoration _panelDecoration() {
    return BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16.0),
      border: Border.all(color: AppColors.divider),
      boxShadow: [BoxShadow(color: Color(0x1A000000), blurRadius: 10, offset: Offset(0, 4))],
    );
  }

  Widget _insightBadge(int completed) {
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(32.0),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$completed',
            style: const TextStyle(
              color: _ink,
              fontSize: 28,
              fontWeight: FontWeight.w600,
              height: 1,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            '完成',
            style: TextStyle(
              color: _muted,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  List<DateTime> _last7Days() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return List.generate(7, (index) {
      return today.subtract(Duration(days: 6 - index));
    });
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
