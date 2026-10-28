import 'package:flutter/material.dart';

import '../models/drink_record.dart';
import '../services/database_service.dart';
import '../services/no_drink_service.dart';
import '../services/session_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../utils/navigation_helper.dart';

class NoDrinkRecordsPage extends StatefulWidget {
  const NoDrinkRecordsPage({super.key});

  @override
  State<NoDrinkRecordsPage> createState() => _NoDrinkRecordsPageState();
}

class _NoDrinkRecordsPageState extends State<NoDrinkRecordsPage> {
  final NoDrinkService _noDrinkService = NoDrinkService();
  final DatabaseService _db = DatabaseService();

  DateTime _focusedMonth = DateTime.now();
  List<String> _checkInDates = []; // YYYY-M-D
  List<DrinkRecord> _monthDrinkRecords = [];
  NoDrinkStats? _stats;
  bool _isLoading = true;
  String _userId = 'guest';
  bool _todayDrunk = false;

  @override
  void initState() {
    super.initState();
    _loadPageData();
  }

  // 加载页面全部数据
  Future<void> _loadPageData() async {
    try {
      _userId = await SessionService.getCurrentUserId() ?? 'guest';

      // 1. 获取打卡日期列表
      final checkIns = await _db.getCheckInDates(_userId);

      // 2. 获取当月饮用记录，用于日历展示
      final start = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
      final end = DateTime(
        _focusedMonth.year,
        _focusedMonth.month + 1,
        1,
      ).subtract(const Duration(seconds: 1));
      final monthDrinkRecords = await _db.getDrinkRecords(
        userId: _userId,
        startDate: start,
        endDate: end,
      );

      // 3. 检查今天是否记录了高糖饮品
      final todayDrunk = await _noDrinkService.hasDrunkOnDate(
        _userId,
        DateTime.now(),
      );

      // 4. 获取连续天数统计
      final stats = await _noDrinkService.getStats(_userId);

      setState(() {
        _checkInDates = checkIns;
        _monthDrinkRecords = monthDrinkRecords;
        _todayDrunk = todayDrunk;
        _stats = stats;
        _isLoading = false;
      });
    } catch (_) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 切换月份
  void _changeMonth(int offset) {
    setState(() {
      _isLoading = true;
      _focusedMonth = DateTime(
        _focusedMonth.year,
        _focusedMonth.month + offset,
        1,
      );
    });
    _loadPageData();
  }

  // 今日打卡
  Future<void> _performCheckIn() async {
    setState(() {
      _isLoading = true;
    });

    final success = await _noDrinkService.checkIn(_userId);
    await _loadPageData();

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('打卡成功！今天也是没有被甜诱惑的一天，真棒！'),
            backgroundColor: AppColors.success,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('打卡失败：今天已记录高糖饮品，无法打卡。'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  // 点击日期进行补签或撤销打卡
  Future<void> _onDayTapped(DateTime day) async {
    final today = DateTime.now();
    final todayZero = DateTime(today.year, today.month, today.day);

    if (day.isAfter(todayZero)) {
      // 未来的日期不能操作
      return;
    }

    final dateStr = '${day.year}-${day.month}-${day.day}';
    final hasCheckIn = _checkInDates.contains(dateStr);

    // 检查该天是否记录了高糖饮品
    final hasDrinkRecord = _monthDrinkRecords.any(
      (r) =>
          r.recordTime.year == day.year &&
          r.recordTime.month == day.month &&
          r.recordTime.day == day.day,
    );

    if (hasDrinkRecord) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('这一天已记录高糖饮品，无法进行打卡。')));
      return;
    }

    if (hasCheckIn) {
      // 撤销打卡
      final confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('撤销打卡'),
          content: Text('确定要撤销 ${day.month}月${day.day}日 的控糖打卡吗？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('确认撤销'),
            ),
          ],
        ),
      );

      if (confirm == true) {
        setState(() {
          _isLoading = true;
        });
        await _noDrinkService.deleteCheckIn(_userId, day);
        await _loadPageData();
      }
    } else {
      // 补签打卡
      setState(() {
        _isLoading = true;
      });
      await _noDrinkService.batchCheckIn(_userId, [day]);
      await _loadPageData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${day.month}月${day.day}日 补签成功！')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final todayStr =
        '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';
    final alreadyCheckedIn = _checkInDates.contains(todayStr);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('戒糖自控打卡'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => goBackOr(context, '/profile'),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // 1. 连续天数展示
                  _buildStreakDashboard(),
                  const SizedBox(height: 16),
                  // 2. 自定义日历视图
                  _buildCalendarCard(),
                  const SizedBox(height: 20),
                  // 3. 打卡操作按钮
                  _buildCheckInButton(alreadyCheckedIn),
                ],
              ),
            ),
    );
  }

  Widget _buildStreakDashboard() {
    final currentStreak = _stats?.currentStreak ?? 0;
    final longestStreak = _stats?.longestStreak ?? 0;
    final totalDays = _stats?.totalDays ?? 0;

    return Row(
      children: [
        _buildStatCard('当前连胜', '$currentStreak 天', '🔥', AppColors.warning),
        const SizedBox(width: 12),
        _buildStatCard('历史最长', '$longestStreak 天', '🏆', AppColors.primaryDark),
        const SizedBox(width: 12),
        _buildStatCard('累计打卡', '$totalDays 天', '✨', AppColors.primary),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, String emoji, Color color) {
    return Expanded(
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 6),
              Text(
                title,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarCard() {
    final daysInMonth = _getDaysInMonth(_focusedMonth);
    final firstWeekday = DateTime(
      _focusedMonth.year,
      _focusedMonth.month,
      1,
    ).weekday;

    // 填充网格，如果第一天不是周一，前面需要补白
    final paddingCells = firstWeekday - 1;
    final totalCells = paddingCells + daysInMonth;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 月份切换
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () => _changeMonth(-1),
                ),
                Text(
                  '${_focusedMonth.year} 年 ${_focusedMonth.month} 月',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => _changeMonth(1),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // 星期头
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Text('一', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('二', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('三', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('四', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('五', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  '六',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  '日',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            // 日期网格
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: totalCells,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                if (index < paddingCells) {
                  return const SizedBox.shrink();
                }

                final dayNum = index - paddingCells + 1;
                final dayDate = DateTime(
                  _focusedMonth.year,
                  _focusedMonth.month,
                  dayNum,
                );
                final dayStr =
                    '${dayDate.year}-${dayDate.month}-${dayDate.day}';

                final isCheckedIn = _checkInDates.contains(dayStr);

                // 检查这一天是否记录了高糖饮品
                final isDrunk = _monthDrinkRecords.any(
                  (r) =>
                      r.recordTime.year == dayDate.year &&
                      r.recordTime.month == dayDate.month &&
                      r.recordTime.day == dayDate.day,
                );

                final isToday =
                    dayDate.year == DateTime.now().year &&
                    dayDate.month == DateTime.now().month &&
                    dayDate.day == DateTime.now().day;

                Color cellColor = Colors.transparent;
                Color textColor = Colors.black;
                Widget? overlayWidget;

                if (isCheckedIn) {
                  cellColor = AppColors.primary.withValues(alpha: 0.15);
                  textColor = AppColors.primary;
                  overlayWidget = const Icon(
                    Icons.check,
                    size: 12,
                    color: AppColors.primary,
                  );
                } else if (isDrunk) {
                  cellColor = AppColors.error.withValues(alpha: 0.1);
                  textColor = AppColors.error;
                  overlayWidget = const Text(
                    '🥤',
                    style: TextStyle(fontSize: 10),
                  );
                } else if (isToday) {
                  cellColor = Colors.grey.shade200;
                  textColor = Colors.black;
                }

                // 判断是否是未来日期
                final todayZero = DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                );
                final isFuture = dayDate.isAfter(todayZero);

                return InkWell(
                  onTap: isFuture ? null : () => _onDayTapped(dayDate),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: cellColor,
                      shape: BoxShape.circle,
                      border: isToday
                          ? Border.all(color: AppColors.primary, width: 1.5)
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          top: 4,
                          child: Text(
                            '$dayNum',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isToday
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isFuture
                                  ? Colors.grey.shade300
                                  : textColor,
                            ),
                          ),
                        ),
                        if (overlayWidget != null)
                          Positioned(bottom: 2, child: overlayWidget),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            // 图例
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegend(
                  AppColors.primary.withValues(alpha: 0.15),
                  '自控成功',
                ),
                const SizedBox(width: 16),
                _buildLegend(
                  AppColors.error.withValues(alpha: 0.1),
                  '高糖饮品',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildCheckInButton(bool alreadyCheckedIn) {
    if (alreadyCheckedIn) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(30),
        ),
        alignment: Alignment.center,
        child: const Text(
          '今日已完成控糖打卡',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      );
    }

    if (_todayDrunk) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(30),
        ),
        alignment: Alignment.center,
        child: const Text(
          '今天已记录高糖饮品，无法打卡',
          style: TextStyle(
            color: AppColors.error,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: _performCheckIn,
        child: const Text(
          '今日少糖打卡',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  // 获取一个月的天数
  int _getDaysInMonth(DateTime month) {
    final nextMonth = DateTime(month.year, month.month + 1, 1);
    return nextMonth.subtract(const Duration(days: 1)).day;
  }
}
