// 心情统计 (MoodStatisticsActivity) - 真正从记录计算统计数据
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import 'mood_provider.dart';

class MoodStatsScreen extends ConsumerWidget {
  const MoodStatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(moodProvider);
    final state = asyncState.valueOrNull ?? const MoodState();
    final records = state.records;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('心情统计', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimens.spacingMd),
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimens.spacingMd),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('心情分布', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: records.isEmpty
                      ? const Center(child: Text('暂无足够的心情数据~去记录一下吧', style: TextStyle(color: AppColors.textHint)))
                      : _PieChart(records: records),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(AppDimens.spacingMd),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('近期心情走势 (指数 0-4)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
                const SizedBox(height: 16),
                SizedBox(
                  height: 180,
                  child: records.isEmpty
                      ? const Center(child: Text('暂无走势数据', style: TextStyle(color: AppColors.textHint)))
                      : _LineChart(records: records),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PieChart extends StatelessWidget {
  final List<EmotionRecord> records;
  const _PieChart({required this.records});

  @override
  Widget build(BuildContext context) {
    final total = records.length;
    if (total == 0) return const SizedBox.shrink();

    final counts = [0, 0, 0, 0, 0];
    for (final r in records) {
      final idx = r.mood.clamp(0, 4);
      counts[idx]++;
    }

    final labels = ['难过', '焦虑/生气', '平静/疲惫', '开心', '幸福'];
    final colors = [
      const Color(0xFF64748B),
      const Color(0xFFEF4444),
      const Color(0xFFF59E0B),
      const Color(0xFF3B82F6),
      const Color(0xFF10B981),
    ];

    final sections = <PieChartSectionData>[];
    for (int i = 0; i < 5; i++) {
      if (counts[i] > 0) {
        final pct = (counts[i] / total * 100).round();
        sections.add(
          PieChartSectionData(
            value: counts[i].toDouble(),
            color: colors[i],
            title: '${labels[i]}\n$pct%',
            radius: 55,
            titleStyle: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        );
      }
    }

    return PieChart(PieChartData(
      sectionsSpace: 2,
      centerSpaceRadius: 35,
      sections: sections,
    ));
  }
}

class _LineChart extends StatelessWidget {
  final List<EmotionRecord> records;
  const _LineChart({required this.records});

  @override
  Widget build(BuildContext context) {
    // Take up to last 15 records chronological order
    final reversed = records.reversed.toList();
    final recent = reversed.length > 15 ? reversed.sublist(reversed.length - 15) : reversed;

    final spots = <FlSpot>[];
    for (int i = 0; i < recent.length; i++) {
      spots.add(FlSpot(i.toDouble(), recent[i].mood.toDouble()));
    }

    return LineChart(LineChartData(
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: AppColors.primary,
          barWidth: 3,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
              radius: 4,
              color: Colors.white,
              strokeWidth: 2,
              strokeColor: AppColors.primary,
            ),
          ),
          belowBarData: BarAreaData(show: true, color: AppColors.primary.withValues(alpha: 0.1)),
        ),
      ],
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            reservedSize: 28,
            getTitlesWidget: (val, meta) {
              const map = {0: '难过', 1: '焦虑', 2: '平静', 3: '开心', 4: '幸福'};
              return Text(map[val.toInt()] ?? '', style: const TextStyle(fontSize: 10, color: AppColors.textHint));
            },
          ),
        ),
        bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      gridData: const FlGridData(show: true, horizontalInterval: 1),
      minY: 0,
      maxY: 4,
    ));
  }
}
