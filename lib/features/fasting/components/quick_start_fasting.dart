import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steps_webu_flutter/core/theme/app_colors.dart';
import '../components/modern_card.dart';
import '../components/circular_progress_ring.dart';
import '../models/fasting_plan.dart';
import '../models/fasting_session.dart';
import '../providers/fasting_provider.dart';
import '../providers/timer_provider.dart';
import '../core/constants/app_constants.dart';
import '../utils/app_toast.dart';

/// 一键开始断食组件
class QuickStartFasting extends ConsumerStatefulWidget {
  final bool showProgress;
  final EdgeInsetsGeometry? margin;

  const QuickStartFasting({super.key, this.showProgress = true, this.margin});

  @override
  ConsumerState<QuickStartFasting> createState() => _QuickStartFastingState();
}

class _QuickStartFastingState extends ConsumerState<QuickStartFasting> {
  FastingPlan? selectedPlan;

  @override
  Widget build(BuildContext context) {
    final activeSession = ref.watch(activeFastingSessionProvider);
    final plansAsync = ref.watch(fastingPlansProvider);

    return ModernCard(
      margin: widget.margin ?? EdgeInsets.zero,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      borderRadius: 24.0,
      showShadow: true,
      useGradient: true,
      gradient: const LinearGradient(
        colors: [Color(0xFFFBFCFA), Color(0xFFEFF9F1)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: Border.all(color: const Color(0xFFD9EBDD)),
      // 移除卡片整体点击，只让按钮可点击
      onTap: null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF9F1),
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: const Color(0xFFD9EBDD)),
                ),
                child: const Icon(
                  Icons.eco_rounded,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activeSession == null ? '生命树断食' : '生命树成长中',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      activeSession == null
                          ? '每一次坚持，都在滋养你的生命树'
                          : '身体正在进入更稳定的能量节奏',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (activeSession == null)
                TextButton(
                  onPressed: () => _showPlanChoiceDialog(context, ref),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primaryDark,
                    backgroundColor: Colors.white.withValues(alpha: 0.72),
                    minimumSize: const Size(0, 36),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  child: const Text('更多'),
                ),
            ],
          ),

          const SizedBox(height: 14),

          // 当前方案 pill（参考 16:8 >）
          if (activeSession != null) ...[
            Align(
              alignment: Alignment.center,
              child: plansAsync.when(
                data: (plans) {
                  final plan = plans.firstWhere(
                    (p) => p.id == activeSession.planId,
                    orElse: () => plans.isNotEmpty
                        ? plans.first
                        : FastingPlan.presetPlans.first,
                  );
                  return _buildPlanPill(context, plan);
                },
                loading: () => _buildPlanPill(context, null),
                error: (_, __) => _buildPlanPill(context, null),
              ),
            ),
            const SizedBox(height: 14),
          ],

          // 进度显示区域
          if (widget.showProgress && activeSession != null) ...[
            _buildProgressSection(context, activeSession),
            const SizedBox(height: 16),
          ],

          // 快速选择计划
          if (activeSession == null) ...[
            _buildSelectedPlanHero(context),
            const SizedBox(height: 14),
            _buildPlanSelection(context),
            const SizedBox(height: 16),
          ],

          // 已在断食时：开始 / 结束时间信息
          if (activeSession != null) ...[
            _buildTimeInfoRow(context, activeSession),
            const SizedBox(height: 16),
          ],

          // 操作按钮
          _buildActionButton(context, ref, activeSession),
        ],
      ),
    );
  }

  Widget _buildPlanPill(BuildContext context, FastingPlan? plan) {
    final label = plan?.name ?? '当前计划';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, size: 18, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildProgressSection(
    BuildContext context,
    FastingSession activeSession,
  ) {
    final timerData = ref.watch(fastingTimerProvider);
    final sessionPhase = activeSession
        .currentPhase; // fasting / eating / post_eating / low_calorie
    final isPaused = activeSession.status == FastingStatus.paused;

    // 进度 & 时间文案统一从计时器里拿，保证和首页大圆逻辑一致
    final elapsedDuration = timerData.elapsedTime;
    final elapsedText = timerData.elapsedTimeFormatted;
    final remainingText = timerData.remainingTimeFormatted;

    double progress;
    String statusLabel;
    String subLabel;

    if (sessionPhase == 'low_calorie') {
      // 5:2 等低卡日：主要提示「低卡日进行中」，不强调进度
      progress = 0.0;
      statusLabel = '低卡日进行中';
      subLabel = activeSession.calorieTarget != null
          ? '建议今日总摄入不超过 ${activeSession.calorieTarget!.toStringAsFixed(0)} 卡'
          : '请控制今日总热量摄入';
    } else if (sessionPhase == 'eating') {
      // 进入进食窗口：断食目标已达成，显示进食窗口
      progress = 1.0;
      statusLabel = '进食窗口';
      final eatingRemain = activeSession.eatingWindowRemainingMinutes;
      if (eatingRemain > 0) {
        final hours = eatingRemain ~/ 60;
        final minutes = eatingRemain % 60;
        if (hours > 0) {
          subLabel = '进食窗口剩余 $hours小时$minutes分钟';
        } else {
          subLabel = '进食窗口剩余 $minutes分钟';
        }
      } else {
        subLabel = '进食窗口即将结束';
      }
    } else if (sessionPhase == 'post_eating') {
      // 进食窗口已结束，但用户还没在应用里结束本次断食
      progress = 1.0;
      statusLabel = '进食窗口已结束';
      subLabel = '本次断食已完成，建议在应用中点击“结束断食”进行总结';
    } else {
      // 正常断食阶段
      progress = (timerData.progressPercentage / 100.0).clamp(0.0, 1.0);
      if (timerData.isOvertime) {
        statusLabel = '已超过目标时间';
        subLabel = '已断食 $elapsedText，建议根据身体状态决定是否结束';
      } else {
        statusLabel = isPaused ? '断食已暂停' : '你正在断食！';
        subLabel = '已断食 $elapsedText • 剩余 $remainingText';
      }
    }

    // 阶段逻辑：脂肪燃烧模式（仅在断食阶段，未暂停，未超时）
    bool isFatBurningStage = false;
    if (sessionPhase == 'fasting' && !isPaused && !timerData.isOvertime) {
      final plannedMinutes = activeSession.plannedFastingDurationMinutes;
      if (plannedMinutes > 0) {
        final elapsedMinutes = elapsedDuration.inMinutes;
        // 经验规则：长断食（>=16h）12小时后进入脂肪燃烧，
        // 短一些的方案按 50% 时长计算。
        final thresholdMinutes = plannedMinutes >= 16 * 60
            ? 12 * 60
            : (plannedMinutes * 0.5).round();
        isFatBurningStage = elapsedMinutes >= thresholdMinutes;
      }
    }

    final stageInfo = _calculateFastingStageInfo(
      activeSession,
      elapsedDuration,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (isFatBurningStage) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(999),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.local_fire_department,
                  color: AppColors.warning,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  '脂肪燃烧模式开始！',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
        // 大号环形进度，居中展示
        Center(
          child: CircularProgressRing(
            progress: progress,
            size: 220,
            strokeWidth: 12,
            gradient: LinearGradient(colors: [AppColors.primary, AppColors.primaryDark]),
            backgroundColor: Colors.white.withValues(alpha: 0.15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  statusLabel,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  elapsedText,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subLabel,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        _buildStageInfoCard(context, stageInfo),
      ],
    );
  }

  Widget _buildTimeInfoRow(BuildContext context, FastingSession session) {
    final start = session.startTime;
    final plannedEnd =
        session.plannedEndTime ??
        start.add(Duration(hours: session.fastingHours));
    final startDayLabel = _formatDayLabel(start);
    final endDayLabel = _formatDayLabel(plannedEnd);

    String formatTime(DateTime dt) =>
        TimeOfDay.fromDateTime(dt).format(context);

    return Row(
      children: [
        Expanded(
          child: _TimeInfoCard(
            title: '开始时间',
            dayLabel: startDayLabel,
            timeLabel: formatTime(start),
            icon: Icons.play_arrow_rounded,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _TimeInfoCard(
            title: '结束时间',
            dayLabel: endDayLabel,
            timeLabel: formatTime(plannedEnd),
            icon: Icons.flag_rounded,
          ),
        ),
      ],
    );
  }

  String _formatDayLabel(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final thatDay = DateTime(dt.year, dt.month, dt.day);
    if (thatDay == today) return '今天';
    if (thatDay == today.add(const Duration(days: 1))) return '明天';
    if (thatDay == today.subtract(const Duration(days: 1))) return '昨天';
    return '${dt.month}月${dt.day}日';
  }

  /// 根据已断食时长和方案，粗略划分当前处于哪个阶段
  _FastingStageInfo _calculateFastingStageInfo(
    FastingSession session,
    Duration elapsed,
  ) {
    if (session.isLowCalorieDay) {
      return const _FastingStageInfo(
        title: '低卡日阶段',
        description: '今天是 5:2 等低卡日，请优先关注总体热量摄入，而不是断食时长。',
        icon: Icons.local_fire_department,
      );
    }

    final hours = elapsed.inHours;

    if (hours < 4) {
      return const _FastingStageInfo(
        title: '血糖正常阶段',
        description: '刚进入断食不久，身体主要消耗餐后葡萄糖和血糖，日常活动无明显影响。',
        icon: Icons.bloodtype,
      );
    } else if (hours < 12) {
      return const _FastingStageInfo(
        title: '糖原消耗阶段',
        description: '肝糖原开始被分解用作能量，为接下来进入脂肪燃烧做准备。',
        icon: Icons.auto_graph,
      );
    } else if (hours < 24) {
      return const _FastingStageInfo(
        title: '脂肪燃烧阶段',
        description: '身体逐渐从糖原转向脂肪供能，是减脂的重要时间段，请注意补水与休息。',
        icon: Icons.local_fire_department,
      );
    } else {
      return const _FastingStageInfo(
        title: '深度断食阶段',
        description: '已处于较长时长断食阶段，可能启动更多细胞自噬过程，请量力而行并关注身体信号。',
        icon: Icons.health_and_safety,
      );
    }
  }

  Widget _buildStageInfoCard(
    BuildContext context,
    _FastingStageInfo stageInfo,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(stageInfo.icon, size: 18, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '当前断食阶段',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  stageInfo.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  stageInfo.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<FastingPlan> get _quickPlans {
    final now = DateTime.now();
    return [
      FastingPlan(
        id: 'quick_16_8',
        name: '16:8',
        description: '16小时断食，8小时进食',
        fastingHours: 16,
        eatingHours: 8,
        difficulty: FastingDifficulty.beginner,
        createdAt: now,
      ),
      FastingPlan(
        id: 'quick_18_6',
        name: '18:6',
        description: '18小时断食，6小时进食',
        fastingHours: 18,
        eatingHours: 6,
        difficulty: FastingDifficulty.intermediate,
        createdAt: now,
      ),
      FastingPlan(
        id: 'quick_20_4',
        name: '20:4',
        description: '20小时断食，4小时进食',
        fastingHours: 20,
        eatingHours: 4,
        difficulty: FastingDifficulty.advanced,
        createdAt: now,
      ),
    ];
  }

  List<FastingPlan> get _allChoicePlans {
    final now = DateTime.now();
    return [
      FastingPlan(
        id: 'quick_12_12',
        name: '12:12',
        description: '12小时断食，12小时进食，更适合刚开始建立节奏的人',
        fastingHours: 12,
        eatingHours: 12,
        difficulty: FastingDifficulty.beginner,
        createdAt: now,
      ),
      FastingPlan(
        id: 'quick_14_10',
        name: '14:10',
        description: '14小时断食，10小时进食，适合从晚餐后开始控制进食',
        fastingHours: 14,
        eatingHours: 10,
        difficulty: FastingDifficulty.beginner,
        createdAt: now,
      ),
      ..._quickPlans,
    ];
  }

  Widget _buildSelectedPlanHero(BuildContext context) {
    final plan = selectedPlan ?? _quickPlans.first;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '准备断食',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      plan.name,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 38,
                        fontWeight: FontWeight.w900,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF9F1),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '建立进食窗口',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '计划 ${plan.fastingHours}h / ${plan.eatingHours}h',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Center(
            child: SizedBox(
              width: 190,
              height: 190,
              child: _GrowthIslandIllustration(progress: 0.66),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.82),
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(color: const Color(0xFFE2EBDD)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF406B4C).withValues(alpha: 0.07),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.spa_rounded,
                            color: AppColors.primary,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '下一阶段',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '深度脂肪阶段',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '预计 2h 18m 后到达，先从稳定补水开始。',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDF1E3),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.local_fire_department_rounded,
                    color: AppColors.warning,
                    size: 26,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _PlanMetricPill(
                label: '断食',
                value: '${plan.fastingHours}h',
                icon: Icons.nightlight_round,
              ),
              const SizedBox(width: 8),
              _PlanMetricPill(
                label: '进食',
                value: '${plan.eatingHours}h',
                icon: Icons.restaurant_rounded,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  plan.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlanSelection(BuildContext context) {
    final quickPlans = _quickPlans;
    final effectiveSelectedPlan = selectedPlan ?? quickPlans.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '切换方案',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                '轻点切换',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.warning,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: quickPlans.asMap().entries.map((entry) {
            final index = entry.key;
            final plan = entry.value;
            final isSelected = effectiveSelectedPlan.id == plan.id;
            final isLast = index == quickPlans.length - 1;

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: isLast ? 0 : 8),
                child: _QuickPlanTile(
                  plan: plan,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      selectedPlan = plan;
                    });
                  },
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    WidgetRef ref,
    FastingSession? activeSession,
  ) {
    final plan = selectedPlan ?? _quickPlans.first;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          _handleQuickStart(context, ref);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              activeSession != null
                  ? Icons.stop_rounded
                  : Icons.play_arrow_rounded,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              activeSession != null ? '结束断食' : '开始 ${plan.name}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleQuickStart(BuildContext context, WidgetRef ref) async {
    try {
      final activeSession = ref.read(activeFastingSessionProvider);
      if (activeSession != null) {
        // 结束当前断食
        _showEndFastingDialog(context, ref);
      } else {
        // 默认预选 16:8，用户可先切换再开始
        final plan = selectedPlan ?? _quickPlans.first;
        await _startFastingWithPlan(context, ref, plan);
      }
    } catch (e) {
      if (context.mounted) {
        showAppToast(context, '操作失败: $e', type: AppToastType.error);
      }
    }
  }

  Future<void> _showPlanChoiceDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final choicePlans = _allChoicePlans;

    final plan = await showModalBottomSheet<FastingPlan>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SafeArea(
          child: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(24.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.14),
                  blurRadius: 28,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: const Icon(
                        Icons.schedule_rounded,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '选择断食计划',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '按今天的状态选择，开始后可随时结束',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: choicePlans.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = choicePlans[index];
                      return _PlanChoiceRow(
                        plan: item,
                        isRecommended: item.name == '16:8',
                        onTap: () => Navigator.of(context).pop(item),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('取消'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (plan == null || !context.mounted) return;

    setState(() {
      selectedPlan = plan;
    });
    await _startFastingWithPlan(context, ref, plan);
  }

  Future<void> _startFastingWithPlan(
    BuildContext context,
    WidgetRef ref,
    FastingPlan plan,
  ) async {
    final fastingNotifier = ref.read(fastingSessionsProvider.notifier);

    final result = await fastingNotifier.startFasting(plan);

    if (!context.mounted) {
      return;
    }

    if (result == null) {
      // 成功
      showAppToast(context, '开始 ${plan.name} 断食计划', type: AppToastType.success);
    } else {
      // 失败或警告
      showAppToast(
        context,
        result,
        type: result.contains('已有') ? AppToastType.info : AppToastType.error,
      );
    }
  }

  void _showEndFastingDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('结束断食'),
        content: const Text('确定要结束当前的断食吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              final activeSession = ref.read(activeFastingSessionProvider);
              if (activeSession != null) {
                ref
                    .read(fastingSessionsProvider.notifier)
                    .endFasting(activeSession.id);
              }
              Navigator.of(context).pop();
              showAppToast(context, '断食已结束', type: AppToastType.success);
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}

class _FastingStageInfo {
  final String title;
  final String description;
  final IconData icon;

  const _FastingStageInfo({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class _GrowthIslandIllustration extends StatelessWidget {
  final double progress;

  const _GrowthIslandIllustration({required this.progress});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GrowthIslandPainter(progress: progress),
      child: const SizedBox.expand(),
    );
  }
}

class _GrowthIslandPainter extends CustomPainter {
  final double progress;

  _GrowthIslandPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * 0.39;
    final ringRect = Rect.fromCircle(center: center, radius: radius);

    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFBFE7AA).withValues(alpha: 0.26),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 1.35));
    canvas.drawCircle(center, radius * 1.35, glowPaint);

    final trackPaint = Paint()
      ..color = const Color(0xFFE3EAD9)
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(ringRect, -math.pi / 2, math.pi * 2, false, trackPaint);

    final progressPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF35B76E), Color(0xFF8BD15C)],
      ).createShader(ringRect)
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      ringRect,
      -math.pi / 2,
      math.pi * 2 * progress.clamp(0.0, 1.0),
      false,
      progressPaint,
    );

    final knobAngle = -math.pi / 2 + math.pi * 2 * progress.clamp(0.0, 1.0);
    final knob = Offset(
      center.dx + math.cos(knobAngle) * radius,
      center.dy + math.sin(knobAngle) * radius,
    );
    canvas.drawCircle(
      knob,
      9,
      Paint()..color = Colors.white.withValues(alpha: 0.92),
    );
    canvas.drawCircle(knob, 6, Paint()..color = const Color(0xFF8BD15C));

    final islandCenter = Offset(center.dx, center.dy + 34);
    final shadowPaint = Paint()
      ..color = const Color(0xFF244331).withValues(alpha: 0.16)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(islandCenter.dx, islandCenter.dy + 18),
        width: 104,
        height: 26,
      ),
      shadowPaint,
    );

    final rockPath = Path()
      ..moveTo(islandCenter.dx - 58, islandCenter.dy)
      ..quadraticBezierTo(
        islandCenter.dx,
        islandCenter.dy - 24,
        islandCenter.dx + 58,
        islandCenter.dy,
      )
      ..lineTo(islandCenter.dx + 40, islandCenter.dy + 30)
      ..quadraticBezierTo(
        islandCenter.dx,
        islandCenter.dy + 44,
        islandCenter.dx - 42,
        islandCenter.dy + 30,
      )
      ..close();
    canvas.drawPath(rockPath, Paint()..color = const Color(0xFF8A7B5D));
    canvas.drawPath(
      rockPath,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFFB7A77D), Color(0xFF746850)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(rockPath.getBounds()),
    );

    final grassPath = Path()
      ..moveTo(islandCenter.dx - 56, islandCenter.dy - 2)
      ..quadraticBezierTo(
        islandCenter.dx,
        islandCenter.dy - 34,
        islandCenter.dx + 58,
        islandCenter.dy - 1,
      )
      ..quadraticBezierTo(
        islandCenter.dx + 36,
        islandCenter.dy + 13,
        islandCenter.dx,
        islandCenter.dy + 14,
      )
      ..quadraticBezierTo(
        islandCenter.dx - 36,
        islandCenter.dy + 13,
        islandCenter.dx - 56,
        islandCenter.dy - 2,
      );
    canvas.drawPath(
      grassPath,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFFBDEB69), Color(0xFF4DB65F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(grassPath.getBounds()),
    );

    final trunkPaint = Paint()
      ..color = const Color(0xFF88633F)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(center.dx, center.dy + 44),
      Offset(center.dx, center.dy - 12),
      trunkPaint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy + 12),
      Offset(center.dx - 18, center.dy - 10),
      trunkPaint..strokeWidth = 5,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy + 4),
      Offset(center.dx + 18, center.dy - 18),
      trunkPaint,
    );

    void leaf(Offset offset, double rx, double ry, Color color) {
      canvas.drawOval(
        Rect.fromCenter(center: offset, width: rx, height: ry),
        Paint()..color = color,
      );
    }

    leaf(
      Offset(center.dx - 24, center.dy - 26),
      42,
      34,
      const Color(0xFF56B957),
    );
    leaf(
      Offset(center.dx + 18, center.dy - 31),
      46,
      38,
      const Color(0xFF7ED15A),
    );
    leaf(
      Offset(center.dx - 2, center.dy - 47),
      48,
      42,
      const Color(0xFF9ADA62),
    );
    leaf(
      Offset(center.dx + 34, center.dy - 5),
      38,
      32,
      const Color(0xFF4DAF5D),
    );
    leaf(
      Offset(center.dx - 34, center.dy - 2),
      34,
      28,
      const Color(0xFF6CC965),
    );
    leaf(Offset(center.dx, center.dy - 14), 58, 42, const Color(0xFF73C65A));

    final sparklePaint = Paint()..color = const Color(0xFFFFD769);
    canvas.drawCircle(Offset(center.dx - 52, center.dy + 30), 3, sparklePaint);
    canvas.drawCircle(
      Offset(center.dx + 48, center.dy + 20),
      2.5,
      sparklePaint,
    );
    canvas.drawCircle(
      Offset(center.dx - 38, center.dy - 55),
      2,
      sparklePaint..color = const Color(0xFFFFFFFF),
    );
  }

  @override
  bool shouldRepaint(covariant _GrowthIslandPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _QuickPlanTile extends StatelessWidget {
  final FastingPlan plan;
  final bool isSelected;
  final VoidCallback onTap;

  const _QuickPlanTile({
    required this.plan,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary
                : Colors.white.withValues(alpha: 0.74),
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : const Color(0xFFDDEBDF),
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                plan.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${plan.fastingHours}h / ${plan.eatingHours}h',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.78)
                      : AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlanMetricPill extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _PlanMetricPill({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 74,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF8F2),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF006B5A)),
          const SizedBox(height: 3),
          Text(
            value,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: const Color(0xFF006B5A),
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanChoiceRow extends StatelessWidget {
  final FastingPlan plan;
  final bool isRecommended;
  final VoidCallback onTap;

  const _PlanChoiceRow({
    required this.plan,
    required this.isRecommended,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isRecommended
                ? AppColors.primary.withValues(alpha: 0.08)
                : const Color(0xFFF7F9F8),
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: isRecommended
                  ? AppColors.primary.withValues(alpha: 0.28)
                  : AppColors.border,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  plan.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          _difficultyLabel(plan.difficulty),
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        if (isRecommended) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.warning,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              '推荐',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      plan.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF94A3B8),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _difficultyLabel(FastingDifficulty difficulty) {
    switch (difficulty) {
      case FastingDifficulty.beginner:
        return '入门';
      case FastingDifficulty.intermediate:
        return '进阶';
      case FastingDifficulty.advanced:
        return '挑战';
    }
  }
}

class _TimeInfoCard extends StatelessWidget {
  final String title;
  final String dayLabel;
  final String timeLabel;
  final IconData icon;

  const _TimeInfoCard({
    required this.title,
    required this.dayLabel,
    required this.timeLabel,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: AppColors.primary),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$dayLabel $timeLabel',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 简化版快速开始按钮
class QuickStartButton extends ConsumerWidget {
  final FastingPlan? plan;
  final EdgeInsetsGeometry? margin;

  const QuickStartButton({super.key, this.plan, this.margin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeSession = ref.watch(activeFastingSessionProvider);

    return Container(
      margin: margin,
      child: ElevatedButton(
        onPressed: () => _handleQuickStart(context, ref),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              activeSession != null ? Icons.stop : Icons.play_arrow,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              activeSession != null ? '结束断食' : '快速开始',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _handleQuickStart(BuildContext context, WidgetRef ref) {
    final activeSession = ref.read(activeFastingSessionProvider);
    final fastingNotifier = ref.read(fastingSessionsProvider.notifier);

    if (activeSession != null) {
      fastingNotifier.endFasting(activeSession.id);
    } else {
      final defaultPlan =
          plan ??
          FastingPlan(
            id: 'quick_16_8',
            name: '16:8 断食',
            description: '16小时断食，8小时进食',
            fastingHours: 16,
            eatingHours: 8,
            difficulty: FastingDifficulty.beginner,
            createdAt: DateTime.now(),
          );

      fastingNotifier.startFasting(defaultPlan);
    }
  }
}
