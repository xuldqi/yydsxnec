import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_constants.dart';
import '../models/fasting_plan.dart';
import '../models/fasting_session.dart';
import '../models/week_plan.dart';
import '../providers/fasting_provider.dart';
import '../providers/timer_provider.dart';
import '../providers/week_plan_provider.dart';
import 'package:steps_webu_flutter/core/theme/app_colors.dart';
import '../utils/app_toast.dart';
import 'fasting_history_page.dart';
import 'week_plan_page.dart';

class FastingPage extends ConsumerStatefulWidget {
  const FastingPage({super.key});

  @override
  ConsumerState<FastingPage> createState() => _FastingPageState();
}

class _FastingPageState extends ConsumerState<FastingPage> {
  static const _ink = AppColors.textPrimary;
  static const _muted = AppColors.textSecondary;
  static const _leaf = AppColors.primary;
  static const _leafDark = AppColors.primaryDark;
  int _selectedMode = 0;

  @override
  Widget build(BuildContext context) {
    final activeSession = ref.watch(activeFastingSessionProvider);
    ref.watch(fastingTimerProvider);
    final plansAsync = ref.watch(fastingPlansProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(gradient: const LinearGradient(colors: [AppColors.background, AppColors.surface])),
        child: SafeArea(
          child: plansAsync.when(
            data: (plans) => SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                32.0,
                16.0,
                32.0,
                40.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 32.0),
                  _buildModeSwitcher(),
                  const SizedBox(height: 24.0),
                  _buildSelectedMode(plans, activeSession),
                ],
              ),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => _buildError(error),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final canPop = Navigator.canPop(context);
    return Row(
      children: [
        if (canPop) ...[
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: _ink),
            tooltip: '返回',
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
        ],
        const Expanded(
          child: Text(
            '断食计划',
            style: TextStyle(
              color: _ink,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        _headerButton(
          Icons.calendar_month_rounded,
          '周计划',
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const WeekPlanPage()),
          ),
        ),
        const SizedBox(width: 10),
        _headerButton(
          Icons.history_rounded,
          '断食历史',
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FastingHistoryPage()),
          ),
        ),
      ],
    );
  }

  Widget _headerButton(IconData icon, String tooltip, VoidCallback onPressed) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16.0),
      child: IconButton(
        onPressed: onPressed,
        tooltip: tooltip,
        icon: Icon(icon, color: _ink),
      ),
    );
  }

  Widget _buildModeSwitcher() {
    const modes = [
      (Icons.today_rounded, '每日'),
      (Icons.calendar_month_rounded, '每周'),
      (Icons.tune_rounded, '自定义'),
    ];

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        children: List.generate(modes.length, (index) {
          final selected = _selectedMode == index;
          return Expanded(
            child: InkWell(
              onTap: () => setState(() => _selectedMode = index),
              borderRadius: BorderRadius.circular(24.0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: 44,
                decoration: BoxDecoration(
                  color: selected ? _leaf : Colors.transparent,
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      modes[index].$1,
                      size: 18,
                      color: selected ? Colors.white : _muted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      modes[index].$2,
                      style: TextStyle(
                        color: selected ? Colors.white : _muted,
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSelectedMode(
    List<FastingPlan> plans,
    FastingSession? activeSession,
  ) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      child: switch (_selectedMode) {
        1 => _buildWeeklyPresets(plans),
        2 => _buildCustomPlans(plans),
        _ => _buildDailyPlans(plans, activeSession),
      },
    );
  }

  Widget _buildDailyPlans(
    List<FastingPlan> plans,
    FastingSession? activeSession,
  ) {
    FastingPlan getPlan(String id) => plans.firstWhere(
      (plan) => plan.id == id,
      orElse: () => FastingPlan.presetPlans.firstWhere((plan) => plan.id == id),
    );

    final beginnerPlans = [
      'preset_12_12',
      'preset_14_10',
      'preset_15_9',
    ].map(getPlan).toList();
    final intermediatePlans = [
      'preset_16_8',
      'preset_17_7',
      'preset_18_6',
    ].map(getPlan).toList();
    final advancedPlans = [
      'preset_20_4',
      'preset_omad',
      'preset_24h',
      'preset_36h',
      'preset_48h',
    ].map(getPlan).toList();

    Widget buildPlanGroup(
      String title,
      String subtitle,
      List<FastingPlan> groupPlans,
    ) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(title, subtitle),
          const SizedBox(height: 12),
          ...groupPlans.map((plan) {
            final selected = activeSession?.planId == plan.id;
            return _quickPlanCard(
              plan: plan,
              color: _difficultyColor(plan.difficulty),
              selected: selected,
            );
          }),
          const SizedBox(height: 12),
        ],
      );
    }

    return Column(
      key: const ValueKey('daily'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildPlanGroup('入门计划', '体验轻松建立节律', beginnerPlans),
        buildPlanGroup('进阶计划', '燃脂减重的经典选择', intermediatePlans),
        buildPlanGroup('挑战计划', '深度自噬与突破', advancedPlans),
      ],
    );
  }

  Widget _quickPlanCard({
    required FastingPlan plan,
    required Color color,
    required bool selected,
  }) {
    final duration = plan.eatingHours == 0
        ? '${plan.fastingHours}小时'
        : '${plan.fastingHours}:${plan.eatingHours}';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24.0),
        child: InkWell(
          onTap: () => _confirmStart(plan),
          borderRadius: BorderRadius.circular(24.0),
          child: Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.13),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Icon(Icons.eco_rounded, color: color, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _ink,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        plan.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _muted,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      duration,
                      style: TextStyle(
                        color: color,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      selected ? '进行中' : '开始',
                      style: const TextStyle(
                        color: _muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeeklyPresets(List<FastingPlan> plans) {
    final basePlan = plans.firstWhere(
      (plan) => plan.id == 'preset_16_8',
      orElse: () => FastingPlan.presetPlans[2],
    );
    final lowCalPlan = plans.firstWhere(
      (plan) => plan.id == 'preset_5_2',
      orElse: () =>
          FastingPlan.presetPlans.firstWhere((plan) => plan.id == 'preset_5_2'),
    );
    final activePlanAsync = ref.watch(activeWeekPlanProvider);

    return Column(
      key: const ValueKey('weekly'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('每周计划', '预设节奏'),
        const SizedBox(height: 12),
        activePlanAsync.when(
          data: (activePlan) => activePlan == null
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _weekPlanCard(activePlan, true),
                ),
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        ),
        _weeklyPresetCard(
          title: '5+2 工作日计划',
          subtitle: '周一到周五断食，周末恢复',
          icon: Icons.work_history_rounded,
          color: _leaf,
          onTap: () => _createPresetWeekPlan(
            WeekPlanPresets.fivePlusTwo(planId: basePlan.id, name: '5+2 工作日计划'),
          ),
        ),
        _weeklyPresetCard(
          title: '6+1 稳定计划',
          subtitle: '每周保留一天完全休息',
          icon: Icons.calendar_view_week_rounded,
          color: AppColors.warning,
          onTap: () => _createPresetWeekPlan(
            WeekPlanPresets.sixPlusOne(planId: basePlan.id, name: '6+1 稳定计划'),
          ),
        ),
        _weeklyPresetCard(
          title: '5:2 低卡计划',
          subtitle: '选择两天摄入低热量',
          icon: Icons.local_fire_department_rounded,
          color: AppColors.primary,
          onTap: () => _createPresetWeekPlan(
            WeekPlanPresets.fiveTwoLowCal(
              planId: lowCalPlan.id,
              name: '5:2 低卡计划',
            ),
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WeekPlanPage()),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: _ink,
              side: const BorderSide(color: AppColors.divider),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(99.0),
              ),
            ),
            icon: const Icon(Icons.edit_calendar_rounded),
            label: const Text(
              '编辑更多周计划',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  Widget _weeklyPresetCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24.0),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24.0),
          child: Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: Row(
              children: [
                _WeekBadge(icon: icon, color: color),
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _muted,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.chevron_right_rounded, color: _muted),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomPlans(List<FastingPlan> plans) {
    final customPlans = plans.where((plan) => plan.isCustom).toList();

    return Column(
      key: const ValueKey('custom'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('自定义计划', '自由设置时长'),
        const SizedBox(height: 12),
        _customCreateCard(),
        if (customPlans.isNotEmpty) ...[
          const SizedBox(height: 14),
          ...customPlans.map(
            (plan) =>
                _quickPlanCard(plan: plan, color: _leafDark, selected: false),
          ),
        ],
      ],
    );
  }

  Widget _customCreateCard() {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(24.0),
      child: InkWell(
        onTap: _showCustomPlanSheet,
        borderRadius: BorderRadius.circular(24.0),
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: const Row(
            children: [
              _WeekBadge(icon: Icons.add_rounded, color: _leaf),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '创建自定义计划',
                      style: TextStyle(
                        color: _ink,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '设置断食小时和进食窗口，可保存后立即开始',
                      style: TextStyle(
                        color: _muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: _muted),
            ],
          ),
        ),
      ),
    );
  }

  Widget _weekPlanCard(WeekPlan plan, bool shouldFast) {
    final today = DateTime.now().weekday;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _WeekBadge(
                icon: shouldFast ? Icons.eco_rounded : Icons.bedtime_rounded,
                color: shouldFast ? _leaf : AppColors.primary,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan.name,
                      style: const TextStyle(
                        color: _ink,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      shouldFast ? '今天属于断食路线' : '今天是恢复日，保持轻盈饮食',
                      style: const TextStyle(
                        color: _muted,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WeekPlanPage()),
                ),
                icon: const Icon(Icons.tune_rounded, color: _ink),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: List.generate(7, (index) {
              final day = index + 1;
              final isToday = day == today;
              final isRest = plan.isRestDay(day);
              final isLowCal = plan.isLowCalDay(day);
              final active = plan.fastingDays.contains(day) || isLowCal;
              final labels = ['一', '二', '三', '四', '五', '六', '日'];
              return Expanded(
                child: Container(
                  height: 42,
                  margin: EdgeInsets.only(right: index == 6 ? 0 : 6),
                  decoration: BoxDecoration(
                    color: isToday
                        ? _ink
                        : active
                        ? AppColors.surface
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: Center(
                    child: Text(
                      isRest
                          ? '休'
                          : isLowCal
                          ? '低'
                          : labels[index],
                      style: TextStyle(
                        color: isToday
                            ? Colors.white
                            : active
                            ? _leafDark
                            : _muted,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
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
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(99.0),
          ),
          child: Text(
            chip,
            style: const TextStyle(
              color: _leafDark,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildError(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.error,
              size: 42,
            ),
            const SizedBox(height: 12),
            Text('加载失败：$error', textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.refresh(fastingPlansProvider),
              child: const Text('重试'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmStart(FastingPlan plan) {
    final activeSession = ref.read(activeFastingSessionProvider);
    if (activeSession != null) {
      showAppToast(context, '已有正在进行的断食，请先结束当前断食', type: AppToastType.info);
      return;
    }
    _startFasting(plan);
  }

  Color _difficultyColor(FastingDifficulty difficulty) {
    return switch (difficulty) {
      FastingDifficulty.beginner => _leaf,
      FastingDifficulty.intermediate => AppColors.warning,
      FastingDifficulty.advanced => AppColors.primary,
    };
  }

  Future<void> _createPresetWeekPlan(WeekPlan plan) async {
    await ref.read(weekPlansProvider.notifier).addPlan(plan);
    await ref.read(weekPlansProvider.notifier).setActivePlan(plan.id);
    if (!mounted) return;
    showAppToast(context, '已启用 ${plan.name}', type: AppToastType.success);
  }

  void _showCustomPlanSheet() {
    final fastingController = TextEditingController(text: '16');
    final eatingController = TextEditingController(text: '8');
    final nameController = TextEditingController();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(32.0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(99.0),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  '自定义断食计划',
                  style: TextStyle(
                    color: _ink,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: _sheetInputDecoration('计划名称', '例如：工作日轻断食'),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: fastingController,
                        keyboardType: TextInputType.number,
                        decoration: _sheetInputDecoration('断食小时', '16'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: eatingController,
                        keyboardType: TextInputType.number,
                        decoration: _sheetInputDecoration('进食小时', '8'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      final fastingHours = int.tryParse(
                        fastingController.text.trim(),
                      );
                      final eatingHours = int.tryParse(
                        eatingController.text.trim(),
                      );
                      if (fastingHours == null ||
                          eatingHours == null ||
                          fastingHours <= 0 ||
                          fastingHours > 48 ||
                          eatingHours < 0 ||
                          eatingHours > 24) {
                        showAppToast(
                          context,
                          '请输入合理的断食和进食时长',
                          type: AppToastType.error,
                        );
                        return;
                      }
                      Navigator.pop(context);
                      _createCustomPlan(
                        name: nameController.text.trim(),
                        fastingHours: fastingHours,
                        eatingHours: eatingHours,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _leaf,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(99.0),
                      ),
                    ),
                    child: const Text(
                      '保存并开始',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).whenComplete(() {
      fastingController.dispose();
      eatingController.dispose();
      nameController.dispose();
    });
  }

  InputDecoration _sheetInputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: AppColors.primary,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        borderSide: BorderSide.none,
      ),
    );
  }

  Future<void> _createCustomPlan({
    required String name,
    required int fastingHours,
    required int eatingHours,
  }) async {
    final plan = FastingPlan(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      name: name.isEmpty ? '$fastingHours:$eatingHours 自定义断食' : name,
      description: '$fastingHours小时断食，$eatingHours小时进食窗口',
      fastingHours: fastingHours,
      eatingHours: eatingHours,
      difficulty: fastingHours <= 16
          ? FastingDifficulty.beginner
          : fastingHours <= 20
          ? FastingDifficulty.intermediate
          : FastingDifficulty.advanced,
      isCustom: true,
      createdAt: DateTime.now(),
      tips: '按自己的作息执行，过程中保持补水。',
      benefits: const ['自由匹配作息', '更容易长期坚持'],
      precautions: const ['不适时及时结束', '保证进食窗口营养充足'],
    );

    await ref.read(fastingPlansProvider.notifier).addPlan(plan);
    await _startFasting(plan);
  }

  Future<void> _startFasting(FastingPlan plan) async {
    final isLowCalorie = plan.fastingHours == 0 && plan.eatingHours == 0;
    final result = await ref
        .read(fastingSessionsProvider.notifier)
        .startFasting(
          plan,
          isLowCalorieDay: isLowCalorie,
          calorieTarget: isLowCalorie ? 600 : null,
        );
    if (!mounted) return;
    showAppToast(
      context,
      result ?? '已开始 ${plan.name}',
      type: result == null ? AppToastType.success : AppToastType.info,
    );
  }
}

class _WeekBadge extends StatelessWidget {
  const _WeekBadge({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }
}
