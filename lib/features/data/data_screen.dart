import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/providers/sleep_data_provider.dart';
import 'sleep_report_screen.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({Key? key}) : super(key: key);

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  int _activeTab = 0; // 0: Day, 1: Week, 2: Month
  int _selectedSessionIndex = -1;

  // Session Helper Calculations
  int getSessionScore(SleepSession session) {
    if (session.dataPoints.isEmpty) return 0;
    int deepSec = getSessionPhaseDuration(session, 'Deep').inSeconds;
    int awakeSec = getSessionPhaseDuration(session, 'Awake').inSeconds;
    int totalSec = session.duration.inSeconds;
    if (totalSec == 0) return 0;
    double score = 70 + (deepSec / totalSec * 50) - (awakeSec / totalSec * 30);
    return score.clamp(0, 100).toInt();
  }

  Duration getSessionPhaseDuration(SleepSession session, String targetPhase) {
    if (session.dataPoints.isEmpty) return Duration.zero;
    int totalSeconds = 0;
    for (int i = 0; i < session.dataPoints.length - 1; i++) {
      if (session.dataPoints[i].phase == targetPhase) {
        totalSeconds += session.dataPoints[i + 1].time
            .difference(session.dataPoints[i].time)
            .inSeconds;
      }
    }
    return Duration(seconds: totalSeconds);
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return '一';
      case 2:
        return '二';
      case 3:
        return '三';
      case 4:
        return '四';
      case 5:
        return '五';
      case 6:
        return '六';
      case 7:
        return '日';
      default:
        return '-';
    }
  }

  List<FlSpot> _generateLineData(List<SleepDataPoint> data) {
    if (data.isEmpty) return [];
    List<FlSpot> spots = [];
    final startTime = data.first.time;
    final totalDuration = data.last.time.difference(startTime).inMinutes;

    for (int i = 0; i < data.length; i++) {
      double x = totalDuration == 0
          ? 0.0
          : data[i].time.difference(startTime).inMinutes /
                totalDuration *
                10; // normalized 0-10
      double y = 1;
      switch (data[i].phase) {
        case 'Deep':
          y = 0;
          break;
        case 'Light':
          y = 1;
          break;
        case 'REM':
          y = 2;
          break;
        case 'Awake':
          y = 3;
          break;
      }
      spots.add(FlSpot(x, y));
    }
    return spots;
  }

  @override
  Widget build(BuildContext context) {
    final sleepData = Provider.of<SleepDataProvider>(context);
    final history = sleepData.history;

    if (history.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFF0A101C),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const Text(
                  '数据',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Spacer(flex: 2),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Color(0xFF151C2C),
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.03),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4ADE80).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.auto_graph_rounded,
                            size: 64,
                            color: Color(0xFF4ADE80),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          '暂无睡眠数据',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          '您的睡眠时间、阶段、习惯等分析数据将在此处展示。今晚去「睡眠」页面开启您的第一次记录吧！',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(flex: 3),
              ],
            ),
          ),
        ),
      );
    }

    // Initialize selected session index to latest if not set or out of bounds
    if (_selectedSessionIndex == -1 ||
        _selectedSessionIndex >= history.length) {
      _selectedSessionIndex = history.length - 1;
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0A101C),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '数据',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.share_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('分享图片已保存到相册'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Custom Tabs (Day/Week/Month)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _activeTab = 0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: _activeTab == 0
                                  ? Color(0xFF151C2C)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: _activeTab == 0
                                  ? [
                                      BoxShadow(
                                        color: Colors.white.withOpacity(0.05),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                '日',
                                style: TextStyle(
                                  color: _activeTab == 0
                                      ? const Color(0xFF4ADE80)
                                      : Colors.white70,
                                  fontWeight: _activeTab == 0
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _activeTab = 1),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: _activeTab == 1
                                  ? Color(0xFF151C2C)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: _activeTab == 1
                                  ? [
                                      BoxShadow(
                                        color: Colors.white.withOpacity(0.05),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                '周',
                                style: TextStyle(
                                  color: _activeTab == 1
                                      ? const Color(0xFF4ADE80)
                                      : Colors.white70,
                                  fontWeight: _activeTab == 1
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _activeTab = 2),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: _activeTab == 2
                                  ? Color(0xFF151C2C)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: _activeTab == 2
                                  ? [
                                      BoxShadow(
                                        color: Colors.white.withOpacity(0.05),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                '月',
                                style: TextStyle(
                                  color: _activeTab == 2
                                      ? const Color(0xFF4ADE80)
                                      : Colors.white70,
                                  fontWeight: _activeTab == 2
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              if (sleepData.isDemoHistory) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: _buildDemoDataBanner(),
                ),
                const SizedBox(height: 16),
              ],

              // Render Content Based on Active Tab
              if (_activeTab == 0)
                _buildDayTab(history)
              else if (_activeTab == 1)
                _buildWeekTab(history)
              else
                _buildMonthTab(history),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------
  // DAY TAB BUILDER
  // ----------------------------------------------------
  Widget _buildDayTab(List<SleepSession> history) {
    // Last 7 recorded nights selection
    final last7Sessions = history.length > 7
        ? history.sublist(history.length - 7)
        : history;
    final selectedSession = history[_selectedSessionIndex];
    final duration = selectedSession.duration;
    final score = getSessionScore(selectedSession);

    final deepMin = getSessionPhaseDuration(selectedSession, 'Deep').inMinutes;
    final lightMin = getSessionPhaseDuration(
      selectedSession,
      'Light',
    ).inMinutes;
    final remMin = getSessionPhaseDuration(selectedSession, 'REM').inMinutes;
    final awakeMin = getSessionPhaseDuration(
      selectedSession,
      'Awake',
    ).inMinutes;

    final targetPercent = (duration.inMinutes / (7.5 * 60) * 100).clamp(0, 100);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Horizontal Date List
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: last7Sessions.length,
            itemBuilder: (context, index) {
              final actualIndex = history.indexOf(last7Sessions[index]);
              final session = history[actualIndex];
              final isSelected = actualIndex == _selectedSessionIndex;
              final date = session.dataPoints.first.time;
              final dayName = _getDayName(date.weekday);
              final dateStr = '${date.month}/${date.day}';
              final sessionScore = getSessionScore(session);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedSessionIndex = actualIndex;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 62,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF4ADE80)
                        : Color(0xFF151C2C),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.03),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    border: isSelected
                        ? null
                        : Border.all(color: Colors.white.withOpacity(0.04)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dayName,
                        style: TextStyle(
                          color: isSelected
                              ? const Color(0xFF151C2C).withOpacity(0.7)
                              : Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        dateStr,
                        style: TextStyle(
                          color: isSelected ? Color(0xFF151C2C) : Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '$sessionScore分',
                        style: TextStyle(
                          color: isSelected
                              ? Color(0xFF151C2C)
                              : const Color(0xFF4ADE80),
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: _buildSleepRecordCard(selectedSession, score),
        ),
        const SizedBox(height: 16),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: _buildVoiceRecordCard(selectedSession),
        ),
        const SizedBox(height: 20),

        // 2. Score & Duration side by side cards
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Color(0xFF151C2C),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '睡眠评分',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '$score',
                            style: const TextStyle(
                              color: Color(0xFF4ADE80),
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            ' 分',
                            style: TextStyle(
                              color: Color(0xFF4ADE80),
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        score >= 90
                            ? '非常好'
                            : score >= 70
                            ? '良好'
                            : score >= 50
                            ? '一般'
                            : '需改善',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Color(0xFF151C2C),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '睡眠时长',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '${duration.inHours}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'h ',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          Text(
                            '${duration.inMinutes.remainder(60)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'm',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '目标完成 ${targetPercent.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // 3. Stage breakdown donut chart
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFF151C2C),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '睡眠阶段占比',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 150,
                  child: Stack(
                    children: [
                      PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 50,
                          startDegreeOffset: -90,
                          sections: [
                            PieChartSectionData(
                              color: const Color(0xFF3B5998),
                              value: deepMin.toDouble() == 0
                                  ? 1
                                  : deepMin.toDouble(),
                              title: '',
                              radius: 18,
                            ),
                            PieChartSectionData(
                              color: const Color(0xFF5A95D1),
                              value: lightMin.toDouble() == 0
                                  ? 1
                                  : lightMin.toDouble(),
                              title: '',
                              radius: 18,
                            ),
                            PieChartSectionData(
                              color: const Color(0xFF4ADE80),
                              value: remMin.toDouble() == 0
                                  ? 1
                                  : remMin.toDouble(),
                              title: '',
                              radius: 18,
                            ),
                            PieChartSectionData(
                              color: const Color(0xFFF2C94C),
                              value: awakeMin.toDouble() == 0
                                  ? 1
                                  : awakeMin.toDouble(),
                              title: '',
                              radius: 18,
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$score%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              '睡眠效率',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildPhaseDot(
                      '深睡',
                      '${deepMin ~/ 60}h${deepMin % 60}m',
                      const Color(0xFF3B5998),
                    ),
                    _buildPhaseDot(
                      '浅睡',
                      '${lightMin ~/ 60}h${lightMin % 60}m',
                      const Color(0xFF5A95D1),
                    ),
                    _buildPhaseDot(
                      'REM',
                      '${remMin ~/ 60}h${remMin % 60}m',
                      const Color(0xFF4ADE80),
                    ),
                    _buildPhaseDot(
                      '清醒',
                      '${awakeMin}m',
                      const Color(0xFFF2C94C),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // 4. Influencing Factors (Pre-sleep Habits) card
        if (selectedSession.tags.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF151C2C),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '影响因素',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 2.2,
                        ),
                    itemCount: selectedSession.tags.length,
                    itemBuilder: (context, index) {
                      final tagId = selectedSession.tags[index];
                      final details = _getTagDetails(tagId);
                      // Generate a mock impact score for UI presentation (-15 to +15)
                      final impactScore = (tagId.length * 3 % 20) - 5;
                      final isPositive = impactScore >= 0;

                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.03),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: details['color'].withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                details['icon'],
                                size: 16,
                                color: details['color'],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    details['name'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    isPositive
                                        ? '+$impactScore分'
                                        : '$impactScore分',
                                    style: TextStyle(
                                      color: isPositive
                                          ? const Color(0xFF4ADE80)
                                          : const Color(0xFFF87171),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        if (selectedSession.tags.isNotEmpty) const SizedBox(height: 20),

        // 5. Line Chart (Sleep Cycles)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFF151C2C),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '睡眠周期分布',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 120,
                  child: LineChart(
                    LineChartData(
                      minY: 0,
                      maxY: 3,
                      lineTouchData: LineTouchData(enabled: false),
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            reservedSize: 32,
                            getTitlesWidget: (value, meta) {
                              String label = '';
                              if (value == 0) label = '深睡';
                              if (value == 1) label = '浅睡';
                              if (value == 2) label = 'REM';
                              if (value == 3) label = '清醒';
                              return Text(
                                label,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 9,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: _generateLineData(selectedSession.dataPoints),
                          isCurved: true,
                          curveSmoothness: 0.35,
                          color: const Color(0xFF4ADE80),
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: const Color(0xFF4ADE80).withOpacity(0.1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDemoDataBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFD8B46A).withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD8B46A).withOpacity(0.28)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.info_outline, color: Color(0xFFD8B46A), size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              '当前是示例睡眠数据。完成第一次睡眠记录后，这里会替换成你的真实睡眠记录和录音片段。',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSleepRecordCard(SleepSession session, int score) {
    final start = session.dataPoints.isNotEmpty
        ? session.dataPoints.first.time
        : null;
    final end = session.dataPoints.isNotEmpty
        ? session.dataPoints.last.time
        : null;
    final date = start == null ? '--' : '${start.month}月${start.day}日';
    final timeRange = start == null || end == null
        ? '--'
        : '${_formatClock(start)} - ${_formatClock(end)}';
    final duration = session.duration;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF151C2C),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                '睡眠记录',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Text(
                date,
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildRecordMetric(
                '时间',
                timeRange,
                Icons.schedule_rounded,
                const Color(0xFFD8B46A),
              ),
              const SizedBox(width: 12),
              _buildRecordMetric(
                '时长',
                '${duration.inHours}h ${duration.inMinutes.remainder(60)}m',
                Icons.bedtime_outlined,
                const Color(0xFF90C29F),
              ),
              const SizedBox(width: 12),
              _buildRecordMetric(
                '评分',
                '$score 分',
                Icons.auto_graph_rounded,
                const Color(0xFFB5D5C1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecordMetric(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.035),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(color: Colors.white54, fontSize: 11),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceRecordCard(SleepSession session) {
    final snippets = session.snoreSnippets;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF151C2C),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                '梦话录音',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Text(
                snippets.isEmpty ? '无片段' : '${snippets.length} 段',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (snippets.isEmpty)
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: const Color(0xFF90C29F).withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.volume_off_outlined,
                    color: Color(0xFF90C29F),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    '这晚没有保存到梦话或鼾声片段。开启睡眠监测后，检测到明显声音才会出现在这里。',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            )
          else
            ...snippets.asMap().entries.map((entry) {
              final idx = entry.key;
              final path = entry.value;
              return Padding(
                padding: EdgeInsets.only(top: idx > 0 ? 12 : 0),
                child: SnoreSnippetPlayer(
                  filePath: path,
                  time: '片段 ${idx + 1}',
                  type: '环境音/鼾声',
                  duration: '0:05',
                ),
              );
            }),
        ],
      ),
    );
  }

  String _formatClock(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  // Helper mapping tag IDs
  Map<String, dynamic> _getTagDetails(String tagId) {
    final Map<String, Map<String, dynamic>> tagMapping = {
      'caffeine': {'name': '咖啡因', 'icon': Icons.coffee, 'color': Colors.brown},
      'alcohol': {
        'name': '酒精',
        'icon': Icons.local_bar,
        'color': Colors.redAccent,
      },
      'exercise': {
        'name': '运动',
        'icon': Icons.fitness_center,
        'color': Colors.green,
      },
      'late_meal': {
        'name': '晚顿/宵夜',
        'icon': Icons.fastfood,
        'color': Colors.orange,
      },
      'screen_time': {
        'name': '屏幕使用',
        'icon': Icons.phone_iphone,
        'color': Colors.blue,
      },
      'meditation': {
        'name': '冥想放松',
        'icon': Icons.self_improvement,
        'color': Colors.teal,
      },
    };
    return tagMapping[tagId] ??
        {'name': '习惯', 'icon': Icons.check, 'color': Colors.grey};
  }

  // ----------------------------------------------------
  // WEEK TAB BUILDER
  // ----------------------------------------------------
  Widget _buildWeekTab(List<SleepSession> history) {
    final last7Sessions = history.length > 7
        ? history.sublist(history.length - 7)
        : history;

    // Compute averages
    double avgScore =
        last7Sessions.map((s) => getSessionScore(s)).reduce((a, b) => a + b) /
        last7Sessions.length;
    double avgHours =
        last7Sessions
            .map((s) => s.duration.inMinutes / 60.0)
            .reduce((a, b) => a + b) /
        last7Sessions.length;

    double avgDeepRatio =
        last7Sessions
            .map((s) {
              final total = s.duration.inSeconds;
              if (total == 0) return 0.0;
              return getSessionPhaseDuration(s, 'Deep').inSeconds / total;
            })
            .reduce((a, b) => a + b) /
        last7Sessions.length;

    // Formatting for Date Range
    final firstDate = last7Sessions.first.dataPoints.first.time;
    final lastDate = last7Sessions.last.dataPoints.first.time;
    final dateRangeStr =
        '${firstDate.month}月${firstDate.day}日 - ${lastDate.month}月${lastDate.day}日';

    // Prepare chart data
    List<Map<String, dynamic>> weeklyData = [];
    for (int i = 0; i < 7; i++) {
      int index = last7Sessions.length - 7 + i;
      if (index >= 0) {
        final session = last7Sessions[index];
        final dayStr = _getDayName(session.dataPoints.first.time.weekday);
        weeklyData.add({
          'day': dayStr,
          'hours': session.duration.inMinutes / 60.0,
        });
      } else {
        weeklyData.add({'day': '-', 'hours': 0.0});
      }
    }

    double maxHours = 10.0;
    for (var d in weeklyData) {
      if (d['hours'] as double > maxHours) {
        maxHours = d['hours'] as double;
      }
    }
    double chartMaxY = maxHours <= 10.0
        ? 10.0
        : ((maxHours / 2.0).ceil() * 2.0);

    return Column(
      children: [
        // Date Range
        Center(
          child: Text(
            '<  $dateRangeStr  >',
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ),
        const SizedBox(height: 18),

        // 0. Weekly Summary Report Card
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: _buildWeeklySummaryCard(avgScore, avgHours),
        ),
        const SizedBox(height: 20),

        // 1. Weekly Averages Card
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFF151C2C),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '本周睡眠均值',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildWeekMetric(
                      '评分',
                      '${avgScore.toStringAsFixed(0)}',
                      '分',
                    ),
                    _buildWeekMetric(
                      '时长',
                      '${avgHours.toStringAsFixed(1)}',
                      '小时',
                    ),
                    _buildWeekMetric(
                      '深睡',
                      '${(avgDeepRatio * 100).toStringAsFixed(0)}',
                      '%',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // 2. Bar Chart of last 7 sessions
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFF151C2C),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '睡眠时长趋势',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 150,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: chartMaxY,
                      barTouchData: BarTouchData(enabled: false),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() >= 0 &&
                                  value.toInt() < weeklyData.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    weeklyData[value.toInt()]['day'] as String,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 11,
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 2,
                            reservedSize: 26,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                '${value.toInt()}h',
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 9,
                                ),
                              );
                            },
                          ),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 2,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: Colors.white.withOpacity(0.05),
                          strokeWidth: 1,
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: List.generate(7, (i) {
                        return BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY: weeklyData[i]['hours'] as double,
                              color: i == 6
                                  ? const Color(0xFF4ADE80)
                                  : const Color(0xFFB5D5C1),
                              width: 14,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(4),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // 3. Pre-sleep Habit correlation card
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: _buildHabitCorrelationCard(history),
        ),
      ],
    );
  }

  Widget _buildWeeklySummaryCard(double avgScore, double avgHours) {
    String title = '';
    String description = '';
    IconData icon;
    Color color;

    if (avgScore >= 85 && avgHours >= 7.0) {
      title = '出色的睡眠周！';
      description = '本周您的睡眠质量极佳，睡眠时间充足，深度睡眠比例也很健康。请继续保持现在的良好作息。';
      icon = Icons.star_rounded;
      color = const Color(0xFFE2A03F); // Gold
    } else if (avgScore >= 70 && avgHours >= 6.0) {
      title = '良好的睡眠表现';
      description = '本周整体睡眠状况不错，大部分时间都获得了足够的休息。或许可以尝试早睡15分钟，让状态更完美。';
      icon = Icons.thumb_up_rounded;
      color = const Color(0xFF4ADE80); // Green
    } else if (avgHours < 6.0) {
      title = '睡眠时间不足';
      description = '本周您的平均睡眠时间较短。长期的睡眠不足会影响您的注意力和免疫力，建议在周末补个觉，或尝试使用助眠声音提前入睡。';
      icon = Icons.warning_rounded;
      color = const Color(0xFFD97757); // Reddish
    } else {
      title = '睡眠质量有待提升';
      description = '虽然您的睡眠时间尚可，但睡眠评分偏低，说明可能存在易醒或浅睡偏多的情况。建议睡前进行放松训练，避免摄入咖啡因。';
      icon = Icons.info_outline_rounded;
      color = const Color(0xFF5A95D1); // Blue
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: color.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekMetric(String label, String value, String unit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Color(0xFF4ADE80),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              ' $unit',
              style: const TextStyle(color: Colors.white, fontSize: 11),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHabitCorrelationCard(List<SleepSession> history) {
    final Map<String, Map<String, dynamic>> tagMapping = {
      'caffeine': {'name': '咖啡因', 'icon': Icons.coffee, 'color': Colors.brown},
      'alcohol': {
        'name': '酒精',
        'icon': Icons.local_bar,
        'color': Colors.redAccent,
      },
      'exercise': {
        'name': '运动',
        'icon': Icons.fitness_center,
        'color': Colors.green,
      },
      'late_meal': {
        'name': '晚顿/宵夜',
        'icon': Icons.fastfood,
        'color': Colors.orange,
      },
      'screen_time': {
        'name': '屏幕使用',
        'icon': Icons.phone_iphone,
        'color': Colors.blue,
      },
      'meditation': {
        'name': '冥想放松',
        'icon': Icons.self_improvement,
        'color': Colors.teal,
      },
    };

    List<Widget> correlationRows = [];

    tagMapping.forEach((tagId, tagInfo) {
      final sessionsWith = history
          .where((s) => s.tags.contains(tagId))
          .toList();
      final sessionsWithout = history
          .where((s) => !s.tags.contains(tagId))
          .toList();

      if (sessionsWith.isNotEmpty && sessionsWithout.isNotEmpty) {
        double avgWith =
            sessionsWith
                .map((s) => getSessionScore(s))
                .reduce((a, b) => a + b) /
            sessionsWith.length;
        double avgWithout =
            sessionsWithout
                .map((s) => getSessionScore(s))
                .reduce((a, b) => a + b) /
            sessionsWithout.length;
        double diff = avgWith - avgWithout;

        final diffStr = diff >= 0
            ? '+${diff.toStringAsFixed(1)}'
            : diff.toStringAsFixed(1);
        final diffColor = diff >= 0 ? Colors.green : Colors.redAccent;

        correlationRows.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: (tagInfo['color'] as Color).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    tagInfo['icon'] as IconData,
                    color: tagInfo['color'] as Color,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  tagInfo['name'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    '有: ${avgWith.toStringAsFixed(0)}分  无: ${avgWithout.toStringAsFixed(0)}分',
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: diffColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$diffStr分',
                    style: TextStyle(
                      color: diffColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    });

    if (correlationRows.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Color(0xFF151C2C),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: Text(
            '积累更多不同睡前习惯的数据后，将为您生成影响分析',
            style: TextStyle(color: Colors.white54, fontSize: 12, height: 1.5),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF151C2C),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '睡前习惯与评分关联分析',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '基于您的历史记录，分析不同睡前行为对睡眠质量的平均影响。',
            style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.4),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Colors.white12),
          const SizedBox(height: 8),
          ...correlationRows,
        ],
      ),
    );
  }

  // ----------------------------------------------------
  // MONTH TAB BUILDER
  // ----------------------------------------------------
  Widget _buildMonthTab(List<SleepSession> history) {
    // Get last 30 sessions, or fewer if history is smaller
    final last30Sessions = history.length > 30
        ? history.sublist(history.length - 30)
        : history;

    // Compute averages
    double avgScore =
        last30Sessions.map((s) => getSessionScore(s)).reduce((a, b) => a + b) /
        last30Sessions.length;
    double avgHours =
        last30Sessions
            .map((s) => s.duration.inMinutes / 60.0)
            .reduce((a, b) => a + b) /
        last30Sessions.length;

    // Formatting calendar last 30 days
    final now = DateTime.now();
    final List<DateTime> last30Days = List.generate(
      30,
      (i) => now.subtract(Duration(days: 29 - i)),
    );

    SleepSession getSessionForDate(DateTime date) {
      return history.firstWhere(
        (s) =>
            s.dataPoints.isNotEmpty &&
            s.dataPoints.first.time.year == date.year &&
            s.dataPoints.first.time.month == date.month &&
            s.dataPoints.first.time.day == date.day,
        orElse: () => SleepSession(dataPoints: []),
      );
    }

    return Column(
      children: [
        // Date Range
        const Center(
          child: Text(
            '<  最近 30 天睡眠趋势  >',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ),
        const SizedBox(height: 18),

        // 1. Monthly Averages Card
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFF151C2C),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '月度睡眠均值',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildWeekMetric(
                      '评分',
                      '${avgScore.toStringAsFixed(0)}',
                      '分',
                    ),
                    _buildWeekMetric(
                      '时长',
                      '${avgHours.toStringAsFixed(1)}',
                      '小时',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // 2. Score Trend Line Chart
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFF151C2C),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '30日评分趋势',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                _buildMonthLineChart(last30Sessions),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // 3. Dotted/Colored Calendar Grid
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFF151C2C),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '睡眠日历',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.start,
                  children: last30Days.map((date) {
                    final session = getSessionForDate(date);
                    final hasSession = session.dataPoints.isNotEmpty;
                    final score = hasSession ? getSessionScore(session) : 0;

                    Color circleColor = Colors.grey.withOpacity(0.08);
                    Color textColor = Colors.white70;
                    Border? border = Border.all(
                      color: Colors.white.withOpacity(0.05),
                      style: BorderStyle.solid,
                    );

                    if (hasSession) {
                      border = null;
                      if (score >= 85) {
                        circleColor = const Color(0xFF4ADE80); // Green
                        textColor = Color(0xFF151C2C);
                      } else if (score >= 70) {
                        circleColor = const Color(0xFFF2C94C); // Yellow
                        textColor = Colors.white;
                      } else {
                        circleColor = const Color(0xFFE07A5F); // Red
                        textColor = Color(0xFF151C2C);
                      }
                    }

                    return Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: circleColor,
                        shape: BoxShape.circle,
                        border: border,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${date.day}',
                              style: TextStyle(
                                color: textColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (hasSession)
                              Text(
                                '$score',
                                style: TextStyle(
                                  color: textColor.withOpacity(0.8),
                                  fontSize: 8,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildCalendarLegend('优秀 (>=85)', const Color(0xFF4ADE80)),
                    const SizedBox(width: 16),
                    _buildCalendarLegend('良好 (70-84)', const Color(0xFFF2C94C)),
                    const SizedBox(width: 16),
                    _buildCalendarLegend('待改善 (<70)', const Color(0xFFE07A5F)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarLegend(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildMonthLineChart(List<SleepSession> sessions) {
    List<FlSpot> spots = [];
    for (int i = 0; i < sessions.length; i++) {
      spots.add(FlSpot(i.toDouble(), getSessionScore(sessions[i]).toDouble()));
    }

    return SizedBox(
      height: 140,
      child: LineChart(
        LineChartData(
          minY: 40,
          maxY: 100,
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (touchedSpot) => Colors.white,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  return LineTooltipItem(
                    '${spot.y.toInt()} 分',
                    const TextStyle(
                      color: Color(0xFF151C2C),
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  );
                }).toList();
              },
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 20,
            getDrawingHorizontalLine: (value) =>
                FlLine(color: Colors.white.withOpacity(0.04), strokeWidth: 1),
          ),
          titlesData: FlTitlesData(
            show: true,
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 20,
                reservedSize: 24,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}',
                    style: const TextStyle(color: Colors.white54, fontSize: 8),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: const Color(0xFF4ADE80),
              barWidth: 2.5,
              dotData: FlDotData(show: spots.length <= 15),
              belowBarData: BarAreaData(
                show: true,
                color: const Color(0xFF4ADE80).withOpacity(0.08),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhaseDot(String label, String time, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(time, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}
