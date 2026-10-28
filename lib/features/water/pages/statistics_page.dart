import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../models/drink_record.dart';
import '../models/nutrition.dart';
import '../services/database_service.dart';
import '../services/drink_statistics_service.dart';
import '../services/personalization_service.dart';
import '../services/session_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../utils/navigation_helper.dart';

class StatisticsPage extends StatefulWidget {
  final bool showBackButton;
  final bool useWrapper;

  const StatisticsPage({
    super.key,
    this.showBackButton = true,
    this.useWrapper = true,
  });

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  final DatabaseService _databaseService = DatabaseService();
  final DrinkStatisticsService _statisticsService = DrinkStatisticsService();
  String _selectedPeriod = '本周';
  bool _isLoading = true;
  List<DrinkRecord> _records = [];
  Nutrition _totalNutrition = Nutrition();

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userId = await SessionService.getCurrentUserId();
      if (userId == null) {
        if (mounted) {
          setState(() {
            _records = [];
            _totalNutrition = Nutrition();
            _isLoading = false;
          });
        }
        return;
      }

      final now = DateTime.now();
      final start = _statisticsService.startDateByPeriod(now, _selectedPeriod);
      final records = await _databaseService.getDrinkRecords(
        userId: userId,
        startDate: start,
        endDate: now,
      );

      final nutrition = _statisticsService.aggregateNutrition(records);

      if (!mounted) return;
      setState(() {
        _records = records;
        _totalNutrition = nutrition;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  double get _totalVolume => _statisticsService.totalVolume(_records);
  int get _recordCount => _records.length;
  int get _goalRatePercent {
    final now = DateTime.now();
    return _statisticsService.goalRatePercent(
      totalVolume: _totalVolume,
      now: now,
      periodStart: _statisticsService.startDateByPeriod(now, _selectedPeriod),
      dailyGoal: _dailyGoal,
    );
  }

  Map<String, int> get _categoryCount =>
      _statisticsService.categoryCount(_records);

  DateTime get _periodStart {
    final now = DateTime.now();
    return _statisticsService.startDateByPeriod(now, _selectedPeriod);
  }

  int get _periodDayCount {
    final now = DateTime.now();
    return now.difference(_periodStart).inDays + 1;
  }

  double get _dailyGoal {
    final goal = context
        .watch<PersonalizationProvider>()
        .preferences
        .dailyWaterGoal;
    if (goal <= 0) return 2000;
    return goal;
  }

  double get _periodGoal => _periodDayCount * _dailyGoal;
  double get _averageDailyVolume =>
      _periodDayCount <= 0 ? 0 : _totalVolume / _periodDayCount;
  double get _averageDrinkVolume =>
      _recordCount == 0 ? 0 : _totalVolume / _recordCount;
  double get _goalGap => _periodGoal - _totalVolume;

  double get _rawChartMaxY =>
      _volumeSeries.fold<double>(0, (max, value) => value > max ? value : max);

  List<double> get _volumeSeries {
    final now = DateTime.now();
    switch (_selectedPeriod) {
      case '今日':
        final data = List<double>.filled(8, 0);
        for (final record in _records) {
          final index = (record.recordTime.hour / 3).floor().clamp(0, 7);
          data[index] += record.volume;
        }
        return data;
      case '本月':
        final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
        final data = List<double>.filled(4, 0);
        for (final record in _records) {
          final index = (((record.recordTime.day - 1) / daysInMonth) * 4)
              .floor()
              .clamp(0, 3);
          data[index] += record.volume;
        }
        return data;
      case '本年':
        final data = List<double>.filled(12, 0);
        for (final record in _records) {
          data[record.recordTime.month - 1] += record.volume;
        }
        return data;
      case '本周':
      default:
        final data = List<double>.filled(7, 0);
        for (final record in _records) {
          final weekday = record.recordTime.weekday.clamp(1, 7);
          data[weekday - 1] += record.volume;
        }
        return data;
    }
  }

  List<FlSpot> get _volumeSpots {
    final data = _volumeSeries;
    return List.generate(
      data.length,
      (index) => FlSpot(index.toDouble(), data[index]),
    );
  }

  List<String> get _volumeLabels {
    switch (_selectedPeriod) {
      case '今日':
        return const [
          '0:00',
          '3:00',
          '6:00',
          '9:00',
          '12:00',
          '15:00',
          '18:00',
          '21:00',
        ];
      case '本月':
        return const ['1周', '2周', '3周', '4周'];
      case '本年':
        return const [
          '1月',
          '2月',
          '3月',
          '4月',
          '5月',
          '6月',
          '7月',
          '8月',
          '9月',
          '10月',
          '11月',
          '12月',
        ];
      case '本周':
      default:
        return const ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    }
  }

  double get _chartMaxY {
    final interval = _chartInterval;
    final rounded = (_rawChartMaxY / interval).ceil() * interval;
    final minimum = interval * 4;
    return rounded < minimum ? minimum : rounded;
  }

  double get _chartInterval => _chartIntervalFor(_rawChartMaxY);

  double _chartIntervalFor(double value) {
    if (value <= 800) return 200;
    if (value <= 1600) return 400;
    if (value <= 3000) return 750;
    if (value <= 6000) return 1500;
    if (value <= 12000) return 3000;
    return 5000;
  }

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold(
      backgroundColor: widget.useWrapper
          ? AppColors.background
          : Colors.transparent,
      appBar: widget.showBackButton
          ? AppBar(
              title: const Text('喝水统计'),
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.textPrimary,
                ),
                onPressed: () => goBackOr(context, '/home'),
              ),
            )
          : null,
      body: SafeArea(
        top: !widget.showBackButton,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _buildDrinkStatistics(),
      ),
    );

    if (widget.useWrapper) {
      return scaffold;
    }
    return scaffold;
  }

  Widget _buildDrinkStatistics() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!widget.showBackButton) ...[
            _buildTopLevelHeader('喝水统计'),
            const SizedBox(height: 14),
          ],
          _buildPeriodSelector(),
          const SizedBox(height: 18),
          // 总览卡片
          _buildOverviewCards(),
          const SizedBox(height: 18),
          // 饮水量趋势图
          _buildDrinkTrendChart(),
          const SizedBox(height: 18),
          // 饮品类别分布
          _buildCategoryDistribution(),
          const SizedBox(height: 18),
          // 饮水与营养分析
          _buildHydrationAnalysis(),
          const SizedBox(height: 18),
          _buildNutritionInsights(),
          const SizedBox(height: 18),
          _buildHealthSuggestions(),
          if (!widget.useWrapper) const SizedBox(height: 90),
        ],
      ),
    );
  }

  Widget _buildTopLevelHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 22,
        fontWeight: FontWeight.w900,
      ),
    );
  }

  Widget _buildPeriodSelector() {
    final labels = const {'今日': '日', '本周': '周', '本月': '月', '本年': '年'};
    return Container(
      height: 34,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F2EA),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF0E4D7)),
      ),
      child: Row(
        children: labels.entries.map((entry) {
          final label = entry.key;
          final selected = label == _selectedPeriod;
          return Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedPeriod = label;
                });
                _loadStatistics();
              },
              borderRadius: BorderRadius.circular(15),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  entry.value,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: selected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOverviewCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatPill(
            Icons.water_drop_rounded,
            '${_totalVolume.toStringAsFixed(0)}ml',
            '总饮水量',
            const Color(0xFFEAF5FF),
            const Color(0xFF4AA7F7),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatPill(
            Icons.local_drink_rounded,
            '$_recordCount次',
            '喝水次数',
            const Color(0xFFEAFBF7),
            const Color(0xFF39B7A0),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatPill(
            Icons.star_rounded,
            '$_goalRatePercent%',
            '完成率',
            const Color(0xFFFFF9E6),
            const Color(0xFFF2C14D),
          ),
        ),
      ],
    );
  }

  Widget _buildStatPill(
    IconData icon,
    String value,
    String label,
    Color bg,
    Color color,
  ) {
    return Container(
      height: 88,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.8)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDrinkTrendChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '饮水趋势',
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: _chartInterval,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: const Color(0xFFF1E2D6),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          const style = TextStyle(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          );
                          final index = value.toInt();
                          final labels = _volumeLabels;
                          final text = index >= 0 && index < labels.length
                              ? Text(labels[index], style: style)
                              : const Text('', style: style);
                          return SideTitleWidget(
                            meta: meta,
                            child: text,
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: _chartInterval,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          if (value < 0 || value > _chartMaxY) {
                            return const SizedBox.shrink();
                          }
                          return Text(
                            _formatMlAxis(value),
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                            ),
                          );
                        },
                        reservedSize: 52,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: const Color(0xFFF2E4D8),
                      width: 1,
                    ),
                  ),
                  minX: 0,
                  maxX: (_volumeSpots.length - 1).toDouble(),
                  minY: 0,
                  maxY: _chartMaxY,
                  lineBarsData: [
                    LineChartBarData(
                      spots: _volumeSpots,
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primary.withValues(alpha: 0.35),
                        ],
                      ),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: AppColors.primary,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withValues(alpha: 0.24),
                            AppColors.primary.withValues(alpha: 0.04),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryDistribution() {
    final entries = _categoryCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final total = entries.fold<int>(0, (sum, e) => sum + e.value);
    final palette = <Color>[
      AppColors.primary,
      const Color(0xFF86D66A),
      const Color(0xFFF6D75B),
      const Color(0xFF77BDF7),
      const Color(0xFFE7A5F3),
      const Color(0xFF8BD7C7),
    ];

    return Card(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
              '饮品类别分布',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            if (entries.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  '当前时间范围内暂无记录',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              )
            else ...[
              SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 3,
                    centerSpaceRadius: 40,
                    sections: entries.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      final percent = total == 0
                          ? 0
                          : ((item.value / total) * 100);
                      return PieChartSectionData(
                        color: palette[index % palette.length],
                        value: item.value.toDouble(),
                        title: '${percent.toStringAsFixed(0)}%',
                        radius: 56,
                        titleStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: entries.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return _buildLegendItem(
                    item.key,
                    palette[index % palette.length],
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildHydrationAnalysis() {
    final progress = _periodGoal <= 0
        ? 0.0
        : (_totalVolume / _periodGoal).clamp(0.0, 1.0);
    final peak = _peakVolumeLabel();
    final topCategory = _dominantCategoryLabel();
    final goalTitle = _goalGap > 0 ? '还差 ${_formatMl(_goalGap)}' : '已超过目标';
    final goalSubtitle = _goalGap > 0
        ? '按当前周期目标 ${_formatMl(_periodGoal)} 计算'
        : '比目标多 ${_formatMl(_goalGap.abs())}';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '饮水分析',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFFCBD8)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.water_drop_rounded,
                          color: AppColors.primary,
                          size: 21,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              goalTitle,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              goalSubtitle,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: Colors.white.withValues(alpha: 0.85),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final width = (constraints.maxWidth - 10) / 2;
                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    SizedBox(
                      width: width,
                      child: _buildAnalysisTile(
                        '日均饮水',
                        _formatMl(_averageDailyVolume),
                        '目标 ${_formatMl(_dailyGoal)}/天',
                        Icons.calendar_today_rounded,
                        const Color(0xFF58A6FF),
                      ),
                    ),
                    SizedBox(
                      width: width,
                      child: _buildAnalysisTile(
                        '单次平均',
                        _formatMl(_averageDrinkVolume),
                        '共 $_recordCount 次',
                        Icons.local_drink_rounded,
                        const Color(0xFF27B49E),
                      ),
                    ),
                    SizedBox(
                      width: width,
                      child: _buildAnalysisTile(
                        '高峰',
                        peak,
                        '饮水最多的区间',
                        Icons.insights_rounded,
                        const Color(0xFFF2A93B),
                      ),
                    ),
                    SizedBox(
                      width: width,
                      child: _buildAnalysisTile(
                        '主要类型',
                        topCategory,
                        '按记录次数计算',
                        Icons.pie_chart_rounded,
                        const Color(0xFFC05DE8),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionInsights() {
    final calorieGoal = 300 * _periodDayCount;
    final sugarGoal = 50 * _periodDayCount;
    final caffeineGoal = 400 * _periodDayCount;

    return Card(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
              '营养分析',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _records.isEmpty ? '当前周期暂无饮品营养数据' : '按 $_selectedPeriod 的累计摄入估算',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 16),
            _buildNutrientBar(
              label: '热量',
              value: _totalNutrition.calories,
              target: calorieGoal.toDouble(),
              unit: 'kcal',
              color: const Color(0xFFFF7A59),
            ),
            const SizedBox(height: 14),
            _buildNutrientBar(
              label: '糖分',
              value: _totalNutrition.sugar,
              target: sugarGoal.toDouble(),
              unit: 'g',
              color: const Color(0xFFF2A93B),
            ),
            const SizedBox(height: 14),
            _buildNutrientBar(
              label: '咖啡因',
              value: _totalNutrition.caffeine,
              target: caffeineGoal.toDouble(),
              unit: 'mg',
              color: const Color(0xFF8A6B4F),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildHealthSuggestions() {
    final suggestions = _buildSuggestionData();

    return Card(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '分析结论',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            ...suggestions.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _buildSuggestionRow(
                  item.icon,
                  item.color,
                  item.title,
                  item.content,
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildAnalysisTile(
    String label,
    String value,
    String caption,
    IconData icon,
    Color color,
  ) {
    return Container(
      height: 98,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 17),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Spacer(),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            caption,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 10),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientBar({
    required String label,
    required double value,
    required double target,
    required String unit,
    required Color color,
  }) {
    final progress = target <= 0 ? 0.0 : (value / target).clamp(0.0, 1.0);
    final valueText = unit == 'kcal'
        ? '${value.toStringAsFixed(0)}$unit'
        : '${value.toStringAsFixed(0)}$unit';
    final targetText = unit == 'kcal'
        ? '参考 ${target.toStringAsFixed(0)}$unit'
        : '参考 ${target.toStringAsFixed(0)}$unit';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            Flexible(
              child: Text(
                '$valueText / $targetText',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: const Color(0xFFF6E8DC),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestionRow(
    IconData icon,
    Color color,
    String title,
    String content,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 21),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  content,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<_SuggestionData> _buildSuggestionData() {
    if (_records.isEmpty) {
      return const [
        _SuggestionData(
          Icons.info_rounded,
          Color(0xFF58A6FF),
          '暂无可分析数据',
          '记录喝水或饮品后，这里会分析饮水量、热量、糖分和咖啡因。',
        ),
      ];
    }

    final suggestions = <_SuggestionData>[];
    if (_goalGap > 0) {
      suggestions.add(
        _SuggestionData(
          Icons.water_drop_outlined,
          const Color(0xFF58A6FF),
          '饮水目标未完成',
          '$_selectedPeriod 还差 ${_formatMl(_goalGap)}，日均 ${_formatMl(_averageDailyVolume)}。',
        ),
      );
    } else {
      suggestions.add(
        _SuggestionData(
          Icons.check_circle_rounded,
          const Color(0xFF27B49E),
          '饮水目标已完成',
          '$_selectedPeriod 已记录 ${_formatMl(_totalVolume)}，完成度 $_goalRatePercent%。',
        ),
      );
    }

    final sugarLimit = 50 * _periodDayCount;
    final caffeineLimit = 400 * _periodDayCount;
    final calorieLimit = 300 * _periodDayCount;

    if (_totalNutrition.sugar > sugarLimit) {
      suggestions.add(
        _SuggestionData(
          Icons.warning_rounded,
          const Color(0xFFF2A93B),
          '糖分偏高',
          '累计糖分 ${_totalNutrition.sugar.toStringAsFixed(0)}g，已超过提醒线，下一杯可以优先选择水或茶饮。',
        ),
      );
    }

    if (_totalNutrition.caffeine > caffeineLimit) {
      suggestions.add(
        _SuggestionData(
          Icons.coffee_rounded,
          const Color(0xFF8A6B4F),
          '咖啡因偏高',
          '累计咖啡因 ${_totalNutrition.caffeine.toStringAsFixed(0)}mg，下午后可以减少咖啡和浓茶。',
        ),
      );
    }

    if (_totalNutrition.calories > calorieLimit) {
      suggestions.add(
        _SuggestionData(
          Icons.local_fire_department_rounded,
          const Color(0xFFFF7A59),
          '饮品热量偏高',
          '饮品热量 ${_totalNutrition.calories.toStringAsFixed(0)}kcal，奶茶、果汁和含糖饮料可以降频。',
        ),
      );
    }

    if (suggestions.length == 1 && _goalGap <= 0) {
      suggestions.add(
        _SuggestionData(
          Icons.auto_graph_rounded,
          AppColors.primary,
          '结构比较稳定',
          '当前周期没有明显的糖分、咖啡因或热量异常，可以继续保持这个节奏。',
        ),
      );
    }

    return suggestions.take(4).toList();
  }

  String _formatMlAxis(double value) {
    if (value >= 1000) {
      final liter = value / 1000;
      final text = liter == liter.roundToDouble()
          ? liter.toStringAsFixed(0)
          : liter.toStringAsFixed(1);
      return '${text}L';
    }
    return '${value.toInt()}ml';
  }

  String _formatMl(double value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}L';
    }
    return '${value.toStringAsFixed(0)}ml';
  }

  String _peakVolumeLabel() {
    final series = _volumeSeries;
    if (series.isEmpty || _rawChartMaxY <= 0) return '暂无';
    var index = 0;
    for (var i = 1; i < series.length; i++) {
      if (series[i] > series[index]) index = i;
    }
    final labels = _volumeLabels;
    if (index >= labels.length) return _formatMl(series[index]);
    return '${labels[index]} ${_formatMl(series[index])}';
  }

  String _dominantCategoryLabel() {
    final entries = _categoryCount.entries.toList();
    if (entries.isEmpty) return '暂无';
    entries.sort((a, b) => b.value.compareTo(a.value));
    final top = entries.first;
    final total = entries.fold<int>(0, (sum, item) => sum + item.value);
    final percent = total == 0 ? 0 : (top.value / total * 100).round();
    return '${top.key} $percent%';
  }
}

class _SuggestionData {
  final IconData icon;
  final Color color;
  final String title;
  final String content;

  const _SuggestionData(this.icon, this.color, this.title, this.content);
}
