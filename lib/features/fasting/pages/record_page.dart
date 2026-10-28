import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/harmony_picker_sheet.dart';
import '../components/add_fasting_record_sheet.dart';
import 'package:steps_webu_flutter/core/theme/app_colors.dart';
import '../providers/water_provider.dart';
import '../providers/weight_provider.dart';
import '../providers/exercise_provider.dart';
import '../providers/food_record_provider.dart';
import '../providers/fasting_provider.dart';
import '../models/food.dart';
import '../models/food_record.dart';
import '../models/water_record.dart';
import '../models/exercise_record.dart';
import '../core/constants/app_constants.dart';
import '../utils/app_toast.dart';
import 'food_search_page.dart';
import 'package:table_calendar/table_calendar.dart';

import 'weight_detail_page.dart';
import 'fasting_history_page.dart';

class RecordView extends ConsumerStatefulWidget {
  const RecordView({super.key});

  @override
  ConsumerState<RecordView> createState() => _RecordViewState();
}

class _RecordViewState extends ConsumerState<RecordView> {
  static const _ink = AppColors.textPrimary;
  static const _muted = AppColors.textSecondary;
  static const _leaf = AppColors.primary;
  static const _leafDark = AppColors.primaryDark;
  static const _surface = AppColors.surface;
  static const _surfaceSoft = AppColors.surface;
  static const _water = AppColors.info;
  static const _berry = AppColors.primary;
  static const _sun = AppColors.warning;
  static const _rose = AppColors.error;

  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    final latestWeight = ref.watch(latestWeightRecordProvider);
    final bmiValue = ref.watch(simpleBMIProvider);
    final fastingSessionsAsync = ref.watch(fastingSessionsProvider);
    final waterRecordsAsync = ref.watch(waterRecordsProvider);
    final recommendedAmount = ref.watch(recommendedWaterAmountProvider);

    final calendarEvents = <DateTime, List<String>>{};

    if (fastingSessionsAsync.valueOrNull != null) {
      for (final session in fastingSessionsAsync.valueOrNull!) {
        final startDay = DateTime.utc(
          session.startTime.year,
          session.startTime.month,
          session.startTime.day,
        );
        if (!calendarEvents.containsKey(startDay)) {
          calendarEvents[startDay] = [];
        }
        if (!calendarEvents[startDay]!.contains('fasting')) {
          calendarEvents[startDay]!.add('fasting');
        }
      }
    }
    if (waterRecordsAsync.valueOrNull != null) {
      final waterRecords = waterRecordsAsync.valueOrNull!;
      final waterByDay = <DateTime, int>{};
      for (final record in waterRecords) {
        final day = DateTime.utc(
          record.recordTime.year,
          record.recordTime.month,
          record.recordTime.day,
        );
        waterByDay[day] = (waterByDay[day] ?? 0) + record.amount.toInt();
      }
      for (final entry in waterByDay.entries) {
        if (entry.value >= recommendedAmount) {
          if (!calendarEvents.containsKey(entry.key)) {
            calendarEvents[entry.key] = [];
          }
          if (!calendarEvents[entry.key]!.contains('water')) {
            calendarEvents[entry.key]!.add('water');
          }
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCalendarView(calendarEvents),
        const SizedBox(height: 20),
        _buildTodayOverview(),
        const SizedBox(height: 22),
        _sectionTitle('记一笔', '今日数据'),
        const SizedBox(height: 14),
        fastingSessionsAsync.when(
          data: (sessions) {
            final totalCount = sessions.length;
            final now = DateTime.now();
            final todayCount = sessions
                .where(
                  (s) =>
                      s.startTime.year == now.year &&
                      s.startTime.month == now.month &&
                      s.startTime.day == now.day,
                )
                .length;
            final completedCount = sessions
                .where((s) => s.status == FastingStatus.completed)
                .length;

            return _buildRecordCard(
              icon: Icons.nightlight_round,
              title: '断食记录',
              subtitle: totalCount == 0
                  ? '补记已经完成的断食时长'
                  : '共 $totalCount 次 / 今日 $todayCount 次 / 完成 $completedCount 次',
              color: _leaf,
              actionLabel: '历史',
              onTap: _showAddFastingRecordSheet,
              onAction: _openFastingHistory,
            );
          },
          loading: () => _buildRecordCard(
            icon: Icons.nightlight_round,
            title: '断食记录',
            subtitle: '加载中...',
            color: _leaf,
            actionLabel: '历史',
            onTap: _showAddFastingRecordSheet,
            onAction: _openFastingHistory,
          ),
          error: (_, __) => _buildRecordCard(
            icon: Icons.nightlight_round,
            title: '断食记录',
            subtitle: '补记已经完成的断食时长',
            color: _leaf,
            actionLabel: '历史',
            onTap: _showAddFastingRecordSheet,
            onAction: _openFastingHistory,
          ),
        ),
        const SizedBox(height: 12),
        _buildWaterRecordCard(),
        const SizedBox(height: 12),
        latestWeight.when(
          data: (record) => _buildRecordCard(
            icon: Icons.monitor_weight_rounded,
            title: '体重记录',
            subtitle: record != null
                ? '最新 ${record.weight.toStringAsFixed(1)}kg / BMI $bmiValue'
                : '暂无记录，记录一次体重观察趋势',
            color: _berry,
            actionLabel: '详情',
            onTap: _showWeightRecordDialog,
            onAction: _openWeightDetail,
          ),
          loading: () => _buildRecordCard(
            icon: Icons.monitor_weight_rounded,
            title: '体重记录',
            subtitle: '加载中...',
            color: _berry,
            actionLabel: '详情',
            onTap: _showWeightRecordDialog,
            onAction: _openWeightDetail,
          ),
          error: (_, __) => _buildRecordCard(
            icon: Icons.monitor_weight_rounded,
            title: '体重记录',
            subtitle: '记录一次体重观察趋势',
            color: _berry,
            actionLabel: '详情',
            onTap: _showWeightRecordDialog,
            onAction: _openWeightDetail,
          ),
        ),
        const SizedBox(height: 12),
        ref
            .watch(todayExerciseDurationProvider)
            .when(
              data: (duration) => _buildRecordCard(
                icon: Icons.fitness_center_rounded,
                title: '运动记录',
                subtitle: duration > 0
                    ? '今日 ${_formatDuration(duration)}'
                    : '今日还没有运动记录',
                color: _sun,
                actionLabel: '今日',
                onTap: _showExerciseRecordDialog,
                onAction: _showExerciseRecordsSheet,
              ),
              loading: () => _buildRecordCard(
                icon: Icons.fitness_center_rounded,
                title: '运动记录',
                subtitle: '加载中...',
                color: _sun,
                actionLabel: '今日',
                onTap: _showExerciseRecordDialog,
                onAction: _showExerciseRecordsSheet,
              ),
              error: (_, __) => _buildRecordCard(
                icon: Icons.fitness_center_rounded,
                title: '运动记录',
                subtitle: '记录一次运动',
                color: _sun,
                actionLabel: '今日',
                onTap: _showExerciseRecordDialog,
                onAction: _showExerciseRecordsSheet,
              ),
            ),
        const SizedBox(height: 12),
        ref
            .watch(todayFoodRecordsByMealProvider)
            .when(
              data: (recordsByMeal) {
                final mealCount = recordsByMeal.values
                    .where((records) => records.isNotEmpty)
                    .length;
                final totalCalories = recordsByMeal.values
                    .expand((records) => records)
                    .fold<double>(0.0, (sum, r) => sum + r.totalCalories);
                return _buildRecordCard(
                  icon: Icons.restaurant_rounded,
                  title: '饮食记录',
                  subtitle: mealCount > 0
                      ? '今日 $mealCount 餐 / ${totalCalories.toStringAsFixed(0)} 卡'
                      : '今日还没有饮食记录',
                  color: AppColors.error,
                  actionLabel: '今日',
                  onTap: _openFoodSearchForRecord,
                  onAction: _showFoodRecordDialog,
                );
              },
              loading: () => _buildRecordCard(
                icon: Icons.restaurant_rounded,
                title: '饮食记录',
                subtitle: '加载中...',
                color: AppColors.error,
                actionLabel: '今日',
                onTap: _openFoodSearchForRecord,
                onAction: _showFoodRecordDialog,
              ),
              error: (_, __) => _buildRecordCard(
                icon: Icons.restaurant_rounded,
                title: '饮食记录',
                subtitle: '记录一餐饮食',
                color: AppColors.error,
                actionLabel: '今日',
                onTap: _openFoodSearchForRecord,
                onAction: _showFoodRecordDialog,
              ),
            ),
      ],
    );
  }

  Widget _sectionTitle(String title, String chip) {
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
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          decoration: BoxDecoration(
            color: _leaf.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(99.0),
          ),
          child: Text(
            chip,
            style: const TextStyle(
              color: _leafDark,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarView(Map<DateTime, List<String>> events) {
    return Container(
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(color: AppColors.divider),
        boxShadow: [BoxShadow(color: Color(0x1A000000), blurRadius: 10, offset: Offset(0, 4))],
      ),
      padding: const EdgeInsets.only(bottom: 12),
      child: TableCalendar<String>(
        locale: 'zh_CN',
        firstDay: DateTime.utc(2023, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        eventLoader: (day) {
          final normalizedDay = DateTime.utc(day.year, day.month, day.day);
          return events[normalizedDay] ?? [];
        },
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(_selectedDay, selectedDay)) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          }
        },
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        calendarStyle: const CalendarStyle(
          selectedDecoration: BoxDecoration(
            color: _leaf,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: AppColors.primaryLight,
            shape: BoxShape.circle,
          ),
          markersMaxCount: 3,
        ),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, day, dayEvents) {
            if (dayEvents.isEmpty) return const SizedBox();
            return Positioned(
              bottom: 6,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: dayEvents.map((event) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 1.5),
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: event == 'fasting' ? _leafDark : _water,
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),
        headerStyle: const HeaderStyle(
          formatButtonVisible: true,
          titleCentered: true,
          formatButtonShowsNext: false,
        ),
      ),
    );
  }

  Widget _buildTodayOverview() {
    final todayWaterTotal = ref.watch(todayWaterTotalProvider);
    final recommendedAmount = ref.watch(recommendedWaterAmountProvider);
    final latestWeight = ref.watch(latestWeightRecordProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(32.0),
        border: Border.all(color: AppColors.divider),
        boxShadow: [BoxShadow(color: Color(0x1A000000), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '今日概览',
            style: TextStyle(
              color: _ink,
              fontSize: 21,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: todayWaterTotal.when(
                  data: (total) => _buildOverviewItem(
                    icon: Icons.water_drop_rounded,
                    label: '饮水',
                    value: '${total}ml',
                    target: '/ ${recommendedAmount}ml',
                    color: _water,
                  ),
                  loading: () => _buildOverviewItem(
                    icon: Icons.water_drop_rounded,
                    label: '饮水',
                    value: '--ml',
                    target: '/ ${recommendedAmount}ml',
                    color: _water,
                  ),
                  error: (_, __) => _buildOverviewItem(
                    icon: Icons.water_drop_rounded,
                    label: '饮水',
                    value: '0ml',
                    target: '/ ${recommendedAmount}ml',
                    color: _water,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: latestWeight.when(
                  data: (record) => _buildOverviewItem(
                    icon: Icons.monitor_weight_rounded,
                    label: '体重',
                    value: record == null
                        ? '--kg'
                        : '${record.weight.toStringAsFixed(1)}kg',
                    target: '',
                    color: _berry,
                  ),
                  loading: () => _buildOverviewItem(
                    icon: Icons.monitor_weight_rounded,
                    label: '体重',
                    value: '--kg',
                    target: '',
                    color: _berry,
                  ),
                  error: (_, __) => _buildOverviewItem(
                    icon: Icons.monitor_weight_rounded,
                    label: '体重',
                    value: '--kg',
                    target: '',
                    color: _berry,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ref
                    .watch(todayExerciseDurationProvider)
                    .when(
                      data: (duration) => _buildOverviewItem(
                        icon: Icons.fitness_center_rounded,
                        label: '运动',
                        value: _formatDuration(duration),
                        target: '',
                        color: _sun,
                      ),
                      loading: () => _buildOverviewItem(
                        icon: Icons.fitness_center_rounded,
                        label: '运动',
                        value: '--',
                        target: '',
                        color: _sun,
                      ),
                      error: (_, __) => _buildOverviewItem(
                        icon: Icons.fitness_center_rounded,
                        label: '运动',
                        value: '0分钟',
                        target: '',
                        color: _sun,
                      ),
                    ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ref
                    .watch(todayFoodRecordsByMealProvider)
                    .when(
                      data: (recordsByMeal) {
                        final mealCount = recordsByMeal.values
                            .where((records) => records.isNotEmpty)
                            .length;
                        return _buildOverviewItem(
                          icon: Icons.restaurant_rounded,
                          label: '饮食',
                          value: '$mealCount餐',
                          target: '',
                          color: _rose,
                        );
                      },
                      loading: () => _buildOverviewItem(
                        icon: Icons.restaurant_rounded,
                        label: '饮食',
                        value: '--',
                        target: '',
                        color: _rose,
                      ),
                      error: (_, __) => _buildOverviewItem(
                        icon: Icons.restaurant_rounded,
                        label: '饮食',
                        value: '0餐',
                        target: '',
                        color: _rose,
                      ),
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewItem({
    required IconData icon,
    required String label,
    required String value,
    required String target,
    required Color color,
  }) {
    return Container(
      height: 94,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: _surfaceSoft,
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 17),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: _muted,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Spacer(),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: _ink,
                    fontSize: 18,
                  ),
                ),
                if (target.isNotEmpty)
                  TextSpan(
                    text: target,
                    style: const TextStyle(
                      color: _muted,
                      fontSize: 11,
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

  Widget _buildRecordCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required String actionLabel,
    required VoidCallback onTap,
    required VoidCallback onAction,
    String? asset,
  }) {
    return Material(
      color: _surface,
      borderRadius: BorderRadius.circular(24.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24.0),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.0),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: asset == null
                    ? Icon(icon, color: color, size: 25)
                    : Padding(
                        padding: const EdgeInsets.all(5),
                        child: Image.asset(asset, fit: BoxFit.contain),
                      ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: _ink,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _muted,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Semantics(
                button: true,
                label: '$actionLabel$title',
                child: Material(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(99.0),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: onAction,
                    child: Container(
                      height: 36,
                      constraints: const BoxConstraints(minWidth: 54),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      alignment: Alignment.center,
                      child: Text(
                        actionLabel,
                        style: TextStyle(
                          color: color,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
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
    );
  }

  void _openFastingHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FastingHistoryPage()),
    );
  }

  void _showAddFastingRecordSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddFastingRecordSheet(),
    );
  }

  void _openWeightDetail() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WeightDetailPage()),
    );
  }

  void _showWeightRecordDialog() {
    final weightController = TextEditingController();
    final bodyFatController = TextEditingController();
    final notesController = TextEditingController();
    var isTarget = false;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.28),
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setState) => HarmonyPickerSheet(
          title: '添加体重记录',
          subtitle: '记录当前体重，也可以设为目标体重',
          confirmText: '保存',
          heightFactor: 0.58,
          onCancel: () => Navigator.pop(sheetContext),
          onConfirm: () {
            final weight = double.tryParse(weightController.text.trim());
            if (weight == null || weight <= 0) {
              showAppToast(context, '请输入有效体重', type: AppToastType.error);
              return;
            }
            Navigator.pop(sheetContext);
            _addWeightRecord(
              weight: weight,
              bodyFat: double.tryParse(bodyFatController.text.trim()),
              notes: notesController.text.trim().isEmpty
                  ? null
                  : notesController.text.trim(),
              isTarget: isTarget,
            );
          },
          child: Padding(
            padding: EdgeInsets.only(
              left: 18,
              right: 18,
              top: 18,
              bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
            ),
            child: Column(
              children: [
                _harmonyInput(
                  controller: weightController,
                  label: '体重',
                  hint: 'kg',
                  icon: Icons.monitor_weight_rounded,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
                const SizedBox(height: 10),
                _harmonyInput(
                  controller: bodyFatController,
                  label: '体脂率',
                  hint: '可选，%',
                  icon: Icons.percent_rounded,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
                const SizedBox(height: 10),
                _harmonyInput(
                  controller: notesController,
                  label: '备注',
                  hint: '可选',
                  icon: Icons.note_rounded,
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  value: isTarget,
                  contentPadding: EdgeInsets.zero,
                  activeThumbColor: _leaf,
                  title: const Text(
                    '设为目标体重',
                    style: TextStyle(color: _ink, fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text('开启后会更新目标体重'),
                  onChanged: (value) => setState(() => isTarget = value),
                ),
              ],
            ),
          ),
        ),
      ),
    ).then((_) {
      weightController.dispose();
      bodyFatController.dispose();
      notesController.dispose();
    });
  }

  Widget _buildWaterRecordCard() {
    final todayTotal = ref.watch(todayWaterTotalProvider);
    final recommendedAmount = ref.watch(recommendedWaterAmountProvider);

    return todayTotal.when(
      data: (total) => _buildRecordCard(
        icon: Icons.water_drop_rounded,
        title: '水分记录',
        subtitle: '今日已喝 ${total}ml / ${recommendedAmount}ml',
        color: _water,
        asset: 'assets/images/water_bottle_500_gpt_image2.png',
        actionLabel: '今日',
        onTap: _showWaterRecordDialog,
        onAction: _showWaterRecordsSheet,
      ),
      loading: () => _buildRecordCard(
        icon: Icons.water_drop_rounded,
        title: '水分记录',
        subtitle: '加载中...',
        color: _water,
        asset: 'assets/images/water_bottle_500_gpt_image2.png',
        actionLabel: '今日',
        onTap: _showWaterRecordDialog,
        onAction: _showWaterRecordsSheet,
      ),
      error: (_, __) => _buildRecordCard(
        icon: Icons.water_drop_rounded,
        title: '水分记录',
        subtitle: '今日已喝 0ml / ${recommendedAmount}ml',
        color: _water,
        asset: 'assets/images/water_bottle_500_gpt_image2.png',
        actionLabel: '今日',
        onTap: _showWaterRecordDialog,
        onAction: _showWaterRecordsSheet,
      ),
    );
  }

  void _showWaterRecordDialog() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.28),
      builder: (context) => HarmonyPickerSheet(
        title: '添加饮水',
        subtitle: '选一个常用容量，记录会更快',
        confirmText: '关闭',
        heightFactor: 0.34,
        onCancel: () => Navigator.pop(context),
        onConfirm: () => Navigator.pop(context),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
          child: Row(
            children: [
              Expanded(
                child: _waterAmountButton(
                  amount: 100,
                  label: '小杯',
                  asset: 'assets/images/water_cup_100_gpt_image2.png',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _waterAmountButton(
                  amount: 200,
                  label: '中杯',
                  asset: 'assets/images/water_cup_200_gpt_image2.png',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _waterAmountButton(
                  amount: 300,
                  label: '大杯',
                  asset: 'assets/images/water_cup_300_gpt_image2.png',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _waterAmountButton(
                  amount: 500,
                  label: '水瓶',
                  asset: 'assets/images/water_bottle_500_gpt_image2.png',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showWaterRecordsSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.28),
      builder: (sheetContext) => HarmonyPickerSheet(
        title: '水分记录',
        subtitle: '查看今日饮水，或继续添加',
        confirmText: '添加饮水',
        heightFactor: 0.72,
        onCancel: () => Navigator.pop(sheetContext),
        onConfirm: () {
          Navigator.pop(sheetContext);
          _showWaterRecordDialog();
        },
        child: Consumer(
          builder: (context, ref, _) {
            final recordsAsync = ref.watch(todayWaterRecordsProvider);
            return recordsAsync.when(
              data: (records) {
                if (records.isEmpty) {
                  return _emptyRecordsState(
                    icon: Icons.water_drop_outlined,
                    text: '今天还没有饮水记录',
                  );
                }
                return _recordsList(
                  children: records
                      .map(
                        (record) => _historyTile(
                          icon: Icons.water_drop_rounded,
                          color: _water,
                          title: record.displayText,
                          subtitle: _formatRecordTime(record.recordTime),
                          onDelete: () {
                            ref
                                .read(waterRecordsProvider.notifier)
                                .deleteRecord(record.id);
                          },
                        ),
                      )
                      .toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => _emptyRecordsState(
                icon: Icons.error_outline_rounded,
                text: '饮水记录加载失败',
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _waterAmountButton({
    required int amount,
    required String label,
    required String asset,
  }) {
    return Material(
      color: _surface,
      borderRadius: BorderRadius.circular(16.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          _addWaterRecord(amount);
        },
        borderRadius: BorderRadius.circular(16.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
          child: Column(
            children: [
              SizedBox(
                height: 56,
                child: Image.asset(asset, fit: BoxFit.contain),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  color: _ink,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${amount}ml',
                style: const TextStyle(
                  color: _muted,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showExerciseRecordDialog() {
    ExerciseType selectedType = ExerciseType.walking;
    int durationMinutes = 30;
    int intensity = 3;
    final durationController = TextEditingController(text: '30');
    final caloriesController = TextEditingController();
    final distanceController = TextEditingController();
    final notesController = TextEditingController();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.28),
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setState) => HarmonyPickerSheet(
          title: '添加运动记录',
          subtitle: '滚动选择时长，补充可选数据',
          confirmText: '保存',
          heightFactor: 0.78,
          onCancel: () => Navigator.pop(sheetContext),
          onConfirm: () {
            Navigator.pop(sheetContext);
            _addExerciseRecord(
              type: selectedType,
              durationMinutes: durationMinutes,
              calories: double.tryParse(caloriesController.text.trim()),
              distance: double.tryParse(distanceController.text.trim()),
              notes: notesController.text.trim().isEmpty
                  ? null
                  : notesController.text.trim(),
              intensity: intensity,
            );
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 18,
              right: 18,
              top: 18,
              bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '运动类型',
                  style: TextStyle(
                    color: _ink,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ExerciseType.values.map((type) {
                    return HarmonyOptionChip(
                      label: _exerciseTypeName(type),
                      selected: selectedType == type,
                      onTap: () => setState(() => selectedType = type),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        '运动时长',
                        style: TextStyle(
                          color: _ink,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      '$durationMinutes分钟',
                      style: const TextStyle(
                        color: _leafDark,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 132,
                  child: HarmonyWheelPicker<int>(
                    items: List.generate(24, (index) => (index + 1) * 5),
                    selectedIndex: 5,
                    labelBuilder: (minute) => '$minute 分钟',
                    onSelectedItemChanged: (index) {
                      final next = (index + 1) * 5;
                      durationController.text = '$next';
                      setState(() => durationMinutes = next);
                    },
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  '运动强度',
                  style: TextStyle(
                    color: _ink,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: List.generate(5, (index) {
                    final level = index + 1;
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: index == 4 ? 0 : 8),
                        child: HarmonyOptionChip(
                          label: '$level',
                          selected: intensity == level,
                          onTap: () => setState(() => intensity = level),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 18),
                _harmonyInput(
                  controller: caloriesController,
                  label: '消耗卡路里',
                  hint: '留空自动估算',
                  icon: Icons.local_fire_department_rounded,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
                if (selectedType == ExerciseType.running ||
                    selectedType == ExerciseType.cycling ||
                    selectedType == ExerciseType.walking) ...[
                  const SizedBox(height: 10),
                  _harmonyInput(
                    controller: distanceController,
                    label: '距离',
                    hint: '公里，可选',
                    icon: Icons.straighten_rounded,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                _harmonyInput(
                  controller: notesController,
                  label: '备注',
                  hint: '可选',
                  icon: Icons.note_rounded,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    ).then((_) {
      durationController.dispose();
      caloriesController.dispose();
      distanceController.dispose();
      notesController.dispose();
    });
  }

  void _showExerciseRecordsSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.28),
      builder: (sheetContext) => HarmonyPickerSheet(
        title: '运动记录',
        subtitle: '查看今日运动，或继续添加',
        confirmText: '添加运动',
        heightFactor: 0.72,
        onCancel: () => Navigator.pop(sheetContext),
        onConfirm: () {
          Navigator.pop(sheetContext);
          _showExerciseRecordDialog();
        },
        child: Consumer(
          builder: (context, ref, _) {
            final recordsAsync = ref.watch(todayExerciseRecordsProvider);
            return recordsAsync.when(
              data: (records) {
                if (records.isEmpty) {
                  return _emptyRecordsState(
                    icon: Icons.fitness_center_rounded,
                    text: '今天还没有运动记录',
                  );
                }
                return _recordsList(
                  children: records
                      .map(
                        (record) => _historyTile(
                          icon: Icons.fitness_center_rounded,
                          color: _sun,
                          title:
                              '${record.typeDisplayName} ${record.durationDisplay}',
                          subtitle:
                              '${_formatRecordTime(record.recordTime)} · ${record.estimatedCalories.toStringAsFixed(0)}卡',
                          onDelete: () {
                            ref
                                .read(exerciseRecordsProvider.notifier)
                                .deleteRecord(record.id);
                          },
                        ),
                      )
                      .toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => _emptyRecordsState(
                icon: Icons.error_outline_rounded,
                text: '运动记录加载失败',
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _harmonyInput({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: _muted),
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(color: _leaf, width: 1.4),
        ),
      ),
    );
  }

  String _formatDuration(int minutes) {
    if (minutes < 60) {
      return '$minutes分钟';
    }
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (mins == 0) {
      return '$hours小时';
    }
    return '$hours小时$mins分钟';
  }

  String _exerciseTypeName(ExerciseType type) {
    switch (type) {
      case ExerciseType.walking:
        return '步行';
      case ExerciseType.running:
        return '跑步';
      case ExerciseType.cycling:
        return '骑行';
      case ExerciseType.swimming:
        return '游泳';
      case ExerciseType.yoga:
        return '瑜伽';
      case ExerciseType.weightTraining:
        return '力量训练';
      case ExerciseType.other:
        return '其他';
    }
  }

  void _addExerciseRecord({
    required ExerciseType type,
    required int durationMinutes,
    double? calories,
    double? distance,
    String? notes,
    int? intensity,
  }) async {
    try {
      await ref
          .read(exerciseRecordsProvider.notifier)
          .addRecord(
            type: type,
            durationMinutes: durationMinutes,
            calories: calories,
            distance: distance,
            notes: notes,
            intensity: intensity,
          );

      if (mounted) {
        showAppToast(
          context,
          '已添加运动记录: ${_formatDuration(durationMinutes)}',
          type: AppToastType.success,
        );
      }
    } catch (error) {
      if (mounted) {
        showAppToast(context, '添加失败: $error', type: AppToastType.error);
      }
    }
  }

  Widget _recordsList({required List<Widget> children}) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
      itemCount: children.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) => children[index],
    );
  }

  Widget _emptyRecordsState({required IconData icon, required String text}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: _leaf.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Icon(icon, color: _leafDark, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              text,
              style: const TextStyle(color: _ink, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _historyTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onDelete,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: AppColors.divider),
      ),
      child: ListTile(
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 21),
        ),
        title: Text(
          title,
          style: const TextStyle(color: _ink, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: _muted, fontWeight: FontWeight.w400),
        ),
        trailing: IconButton(
          tooltip: '删除',
          icon: const Icon(Icons.delete_outline_rounded),
          color: _muted,
          onPressed: onDelete,
        ),
      ),
    );
  }

  String _formatRecordTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _openFoodSearchForRecord() async {
    final selectedFood = await Navigator.push<FoodItem>(
      context,
      MaterialPageRoute(builder: (context) => const FoodSearchPage()),
    );
    if (!mounted || selectedFood == null) return;
    _showAddFoodDialog(selectedFood);
  }

  void _showFoodRecordDialog() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.28),
      builder: (sheetContext) => HarmonyPickerSheet(
        title: '饮食记录',
        subtitle: '查看今日饮食，或继续添加',
        confirmText: '添加食物',
        heightFactor: 0.82,
        onCancel: () => Navigator.pop(sheetContext),
        onConfirm: () {
          Navigator.pop(sheetContext);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FoodSearchPage()),
          ).then((selectedFood) {
            if (selectedFood != null && selectedFood is FoodItem) {
              _showAddFoodDialog(selectedFood);
            }
          });
        },
        child: Consumer(
          builder: (context, ref, _) {
            final recordsByMealAsync = ref.watch(
              todayFoodRecordsByMealProvider,
            );
            return recordsByMealAsync.when(
              data: (recordsByMeal) {
                final hasRecords = recordsByMeal.values.any(
                  (records) => records.isNotEmpty,
                );
                if (!hasRecords) {
                  return _emptyRecordsState(
                    icon: Icons.restaurant_outlined,
                    text: '今日暂无饮食记录',
                  );
                }

                final mealTypes = {
                  'breakfast': '早餐',
                  'lunch': '午餐',
                  'dinner': '晚餐',
                  'snack': '加餐',
                  'other': '其他',
                };

                return ListView(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
                  children: [
                    ...mealTypes.entries.map((entry) {
                      final records = recordsByMeal[entry.key] ?? [];
                      if (records.isEmpty) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.value,
                              style: const TextStyle(
                                color: _ink,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...records.map(
                              (record) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: _historyTile(
                                  icon: Icons.restaurant_rounded,
                                  color: _rose,
                                  title: record.foodName,
                                  subtitle:
                                      '${record.quantity}${record.unit} · ${record.totalCalories.toStringAsFixed(0)}卡',
                                  onDelete: () => _deleteFoodRecord(record.id),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => _emptyRecordsState(
                icon: Icons.error_outline_rounded,
                text: '饮食记录加载失败',
              ),
            );
          },
        ),
      ),
    );
  }

  void _showAddFoodDialog(FoodItem food) {
    double quantity = 100.0;
    String unit = 'g';
    String? mealType;
    String? notes;

    final quantityController = TextEditingController(text: '100');
    final notesController = TextEditingController();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.28),
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setState) => HarmonyPickerSheet(
          title: '添加 ${food.name}',
          subtitle: '补充份量后保存到今天',
          confirmText: '保存',
          heightFactor: 0.78,
          onCancel: () => Navigator.pop(sheetContext),
          onConfirm: () {
            Navigator.pop(sheetContext);
            _addFoodRecord(
              food: food,
              quantity: quantity,
              unit: unit,
              mealType: mealType,
              notes: notes,
            );
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              18,
              18,
              18,
              MediaQuery.viewInsetsOf(context).bottom + 22,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: quantityController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: '数量',
                    prefixIcon: const Icon(Icons.straighten_rounded),
                    suffixIconConstraints: const BoxConstraints(
                      minWidth: 72,
                      minHeight: 48,
                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: unit,
                          isDense: true,
                          items: const [
                            DropdownMenuItem(value: 'g', child: Text('g')),
                            DropdownMenuItem(value: 'ml', child: Text('ml')),
                            DropdownMenuItem(value: '份', child: Text('份')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => unit = value);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    quantity = double.tryParse(value) ?? 100.0;
                  },
                ),
                const SizedBox(height: 14),
                const Text(
                  '餐次',
                  style: TextStyle(
                    color: _ink,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      [
                        {'value': 'breakfast', 'label': '早餐'},
                        {'value': 'lunch', 'label': '午餐'},
                        {'value': 'dinner', 'label': '晚餐'},
                        {'value': 'snack', 'label': '加餐'},
                      ].map((item) {
                        final isSelected = mealType == item['value'];
                        return HarmonyOptionChip(
                          label: item['label']!,
                          selected: isSelected,
                          onTap: () {
                            setState(
                              () =>
                                  mealType = isSelected ? null : item['value'],
                            );
                          },
                        );
                      }).toList(),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(
                    labelText: '备注（可选）',
                    prefixIcon: Icon(Icons.note_rounded),
                  ),
                  maxLines: 2,
                  onChanged: (value) => notes = value.isEmpty ? null : value,
                ),
              ],
            ),
          ),
        ),
      ),
    ).then((_) {
      quantityController.dispose();
      notesController.dispose();
    });
  }

  void _addFoodRecord({
    required FoodItem food,
    required double quantity,
    required String unit,
    String? mealType,
    String? notes,
  }) async {
    try {
      await ref
          .read(foodRecordsProvider.notifier)
          .addRecord(
            foodId: food.id,
            foodName: food.name,
            quantity: quantity,
            unit: unit,
            mealType: mealType,
            notes: notes,
            nutrition: food.nutrition,
          );

      if (mounted) {
        showAppToast(context, '已添加 ${food.name}', type: AppToastType.success);
      }
    } catch (error) {
      if (mounted) {
        showAppToast(context, '添加失败: $error', type: AppToastType.error);
      }
    }
  }

  void _deleteFoodRecord(String recordId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: const Text('确定要删除这条饮食记录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: _rose,
              foregroundColor: Colors.white,
            ),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await ref.read(foodRecordsProvider.notifier).deleteRecord(recordId);
        if (mounted) {
          showAppToast(context, '已删除', type: AppToastType.success);
        }
      } catch (error) {
        if (mounted) {
          showAppToast(context, '删除失败: $error', type: AppToastType.error);
        }
      }
    }
  }

  void _addWaterRecord(int amount) async {
    try {
      await ref.read(waterRecordsProvider.notifier).addQuickRecord(amount);
      if (mounted) {
        showAppToast(context, '已添加${amount}ml饮水记录', type: AppToastType.success);
      }
    } catch (error) {
      if (mounted) {
        showAppToast(context, '添加失败: $error', type: AppToastType.error);
      }
    }
  }

  void _addWeightRecord({
    required double weight,
    double? bodyFat,
    String? notes,
    required bool isTarget,
  }) async {
    try {
      if (isTarget) {
        await ref
            .read(weightRecordsProvider.notifier)
            .setTargetWeight(weight, notes: notes);
      } else {
        await ref
            .read(weightRecordsProvider.notifier)
            .addRecord(weight: weight, bodyFat: bodyFat, notes: notes);
      }
      if (mounted) {
        showAppToast(
          context,
          isTarget ? '目标体重已更新' : '已添加体重记录',
          type: AppToastType.success,
        );
      }
    } catch (error) {
      if (mounted) {
        showAppToast(context, '添加失败: $error', type: AppToastType.error);
      }
    }
  }
}
