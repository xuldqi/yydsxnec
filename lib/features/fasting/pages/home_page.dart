import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/harmony_picker_sheet.dart';
import '../models/fasting_plan.dart';
import '../models/fasting_session.dart';
import '../providers/fasting_provider.dart';
import '../providers/timer_provider.dart';
import '../providers/water_provider.dart';
import 'package:steps_webu_flutter/core/theme/app_colors.dart';
import '../utils/app_toast.dart';
import 'fasting_celebration_page.dart';
import 'fasting_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  static const _ink = AppColors.textPrimary;
  static const _muted = AppColors.textSecondary;
  static const _leaf = AppColors.primary;
  static const _leafDark = AppColors.primaryDark;

  DateTime? _customStartTime;

  @override
  Widget build(BuildContext context) {
    final activeSession = ref.watch(activeFastingSessionProvider);
    final timer = ref.watch(fastingTimerProvider);
    final plans =
        ref.watch(fastingPlansProvider).valueOrNull ?? FastingPlan.presetPlans;
    final activePlan = _planForSession(activeSession, plans);
    final isActive = activeSession != null;
    final progress = isActive
        ? (timer.progressPercentage / 100).clamp(0.0, 1.0)
        : 0.18;
    final percent = (progress * 100).round().clamp(0, 100);

    if (activeSession != null) {
      return _buildActiveFastingPage(
        session: activeSession,
        plan: activePlan,
        timer: timer,
        progress: progress,
        percent: percent,
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(gradient: const LinearGradient(colors: [AppColors.background, AppColors.surface])),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _idleFastingCard(activePlan),
                const SizedBox(height: 22),
                _buildStageCard(
                  isActive: false,
                  progress: progress,
                  plan: activePlan,
                ),
                const SizedBox(height: 18),
                _buildTodayHealthPanel(),
                const SizedBox(height: 18),
                _buildTipsCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _idleFastingCard(FastingPlan plan) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(32.0),
        boxShadow: [BoxShadow(color: Color(0x1A000000), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Column(
        children: [
          _planSelector(plan),
          const SizedBox(height: 14),
          SizedBox(
            height: 274,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 252,
                  height: 252,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: Colors.white, width: 8),
                  ),
                ),
                const CustomPaint(
                  size: Size(244, 244),
                  painter: _ActiveRingPainter(progress: 0),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '准备开始',
                      style: TextStyle(
                        color: _muted,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 11),
                    const Text(
                      '00:00:00',
                      style: TextStyle(
                        color: _ink,
                        fontSize: 36,
                        height: 1,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 11),
                    Text(
                      plan.fastingHours == 0
                          ? '低卡日计划'
                          : '${plan.fastingHours}小时目标',
                      style: const TextStyle(
                        color: _leafDark,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: Builder(
              builder: (context) {
                final effectiveStart = _customStartTime ?? DateTime.now();
                final effectiveEnd = effectiveStart.add(
                  Duration(hours: plan.fastingHours),
                );
                final startText = _customStartTime == null
                    ? '现在'
                    : _formatRelativeTime(effectiveStart);
                final endText = plan.fastingHours == 0
                    ? '今晚'
                    : _formatRelativeTime(effectiveEnd);

                return Row(
                  children: [
                    Expanded(
                      child: _activeTimeInfo(
                        '开始时间',
                        startText,
                        onTap: () => _editIdleStartTime(effectiveStart),
                        showIcon: false,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 34,
                      color: AppColors.divider,
                    ),
                    Expanded(
                      child: _activeTimeInfo('计划结束', endText, showIcon: false),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: () => _startFasting(plan),
              style: ElevatedButton.styleFrom(
                backgroundColor: _leaf,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(99.0),
                ),
              ),
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text(
                '开始断食',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              plan.name,
              style: const TextStyle(
                color: _muted,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _planSelector(FastingPlan plan) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(99.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(99.0),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FastingPage()),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(99.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                plan.fastingHours == 0
                    ? plan.name
                    : '${plan.fastingHours}:${plan.eatingHours} 轻断食',
                style: const TextStyle(
                  color: _ink,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.expand_more_rounded, color: _leafDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveFastingPage({
    required FastingSession session,
    required FastingPlan plan,
    required FastingTimerData timer,
    required double progress,
    required int percent,
  }) {
    final startText = _formatRelativeTime(session.startTime);
    final endTime =
        session.plannedEndTime ??
        session.startTime.add(Duration(hours: session.fastingHours));
    final endText = _formatRelativeTime(endTime);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(gradient: const LinearGradient(colors: [AppColors.background, AppColors.surface])),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(14, 16, 14, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _activeFastingCard(
                  plan: plan,
                  timer: timer,
                  progress: progress,
                  percent: percent,
                  startText: startText,
                  endText: endText,
                  session: session,
                ),
                const SizedBox(height: 22),
                _buildStageCard(
                  isActive: true,
                  progress: progress,
                  plan: plan,
                  timer: timer,
                ),
                const SizedBox(height: 18),
                _buildTodayHealthPanel(timer: timer),
                const SizedBox(height: 18),
                _buildTipsCard(timer: timer),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _activeFastingCard({
    required FastingPlan plan,
    required FastingTimerData timer,
    required double progress,
    required int percent,
    required String startText,
    required String endText,
    required FastingSession session,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(32.0),
        boxShadow: [BoxShadow(color: Color(0x1A000000), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(99.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: _leaf,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  '正在断食中',
                  style: TextStyle(
                    color: _leafDark,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 286,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 268,
                  height: 268,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: Colors.white, width: 8),
                  ),
                ),
                CustomPaint(
                  size: const Size(260, 260),
                  painter: _ActiveRingPainter(progress: progress),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '已断食时长',
                      style: TextStyle(
                        color: _muted,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      timer.elapsedTimeFormatted,
                      style: const TextStyle(
                        color: _ink,
                        fontSize: 40,
                        height: 1,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (timer.isOvertime)
                      const Text(
                        '目标已完成',
                        style: TextStyle(
                          color: AppColors.error,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    else ...[
                      const Text(
                        '距离结束还剩',
                        style: TextStyle(
                          color: _muted,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        timer.remainingTimeFormatted,
                        style: const TextStyle(
                          color: AppColors.error,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: _leaf,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '断食中 ${plan.fastingHours.toInt()}h',
                style: const TextStyle(
                  color: _muted,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 24),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '进食中 ${(24 - plan.fastingHours).toInt()}h',
                style: const TextStyle(
                  color: _muted,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _activeTimeInfo(
                    '开始时间',
                    startText,
                    onTap: () => _editSessionTime(session, isStartTime: true),
                    showIcon: false,
                  ),
                ),
                Container(width: 1, height: 34, color: AppColors.divider),
                Expanded(
                  child: _activeTimeInfo(
                    '计划结束',
                    endText,
                    onTap: () => _editSessionTime(session, isStartTime: false),
                    showIcon: false,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56, // slightly taller
            child: ElevatedButton(
              onPressed: () => _endFasting(session),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                elevation: 4, // Add a bit of shadow
                shadowColor: AppColors.error.withValues(alpha: 0.25),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(99.0),
                ),
              ),
              child: const Text(
                '结束断食',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipsCard({FastingTimerData? timer}) {
    String title = '小鹿轻语：补水秘诀';
    String content = '知道吗？每天喝够水可以减少 30% 的虚假饥饿感！';
    IconData icon = Icons.water_drop_rounded;

    if (timer != null) {
      final elapsedHours = timer.elapsedTime.inMinutes / 60.0;
      if (elapsedHours > 12) {
        title = '小鹿科普：脂肪燃烧中 🔥';
        content = '身体已经切入燃脂模式，坚持住，你的脂肪正在转化为能量！';
        icon = Icons.local_fire_department_rounded;
      } else if (elapsedHours > 8) {
        title = '小鹿建议：加速入酮 🔋';
        content = '身体正在清空糖原储备。如果此时适度活动，能更快进入燃脂状态！';
        icon = Icons.directions_run_rounded;
      } else {
        title = '小鹿妙招：对抗饥饿 🍵';
        content = '觉得饿了？泡一杯无糖绿茶或者黑咖啡，能有效抑制食欲哦。';
        icon = Icons.emoji_food_beverage_rounded;
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(color: AppColors.primary),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.error, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    height: 1.4,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _activeTimeInfo(
    String label,
    String value, {
    VoidCallback? onTap,
    bool showIcon = true,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(24.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: _muted.withValues(alpha: 0.92),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (onTap != null && showIcon) ...[
                    const SizedBox(width: 4),
                    const Icon(Icons.edit_rounded, size: 13, color: _muted),
                  ],
                ],
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(
                  color: _ink,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStageCard({
    required bool isActive,
    required double progress,
    required FastingPlan plan,
    FastingTimerData? timer,
  }) {
    final elapsedHours = timer != null
        ? timer.elapsedTime.inMinutes / 60.0
        : 0.0;
    final stage = _stageForProgress(
      isActive,
      elapsedHours,
      timer?.isOvertime ?? false,
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [BoxShadow(color: Color(0x1A000000), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Icon(stage.icon, color: stage.color, size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stage.title,
                      style: const TextStyle(
                        color: _ink,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      stage.subtitle,
                      style: const TextStyle(
                        color: _muted,
                        fontSize: 13,
                        height: 1.35,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(99.0),
            child: LinearProgressIndicator(
              value: isActive ? progress.clamp(0.0, 1.0) : 0.0,
              minHeight: 9,
              backgroundColor: AppColors.divider,
              valueColor: AlwaysStoppedAnimation<Color>(stage.color),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _stagePill(
                isActive ? '当前 ${plan.name}' : '准备期',
                Icons.eco_rounded,
                _leaf,
              ),
              const SizedBox(width: 8),
              _stagePill(
                timer?.isOvertime == true ? '可进入进食窗口' : '按计划推进',
                Icons.schedule_rounded,
                AppColors.warning,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stagePill(String text, IconData icon, Color color) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(99.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: color),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _FastingStage _stageForProgress(
    bool isActive,
    double elapsedHours,
    bool overtime,
  ) {
    if (!isActive) {
      return const _FastingStage(
        title: '身体状态：准备期',
        subtitle: '先选好计划，补足水分，开始后这里会显示断食阶段。',
        icon: Icons.spa_rounded,
        color: AppColors.primary,
      );
    }
    if (overtime) {
      return const _FastingStage(
        title: '身体状态：进食窗口',
        subtitle: '本次目标已完成，可以温和结束断食并记录饮食。',
        icon: Icons.restaurant_rounded,
        color: AppColors.error,
      );
    }

    // 0 - 2 小时：血糖上升期
    if (elapsedHours < 2) {
      return const _FastingStage(
        title: '身体状态：血糖上升期',
        subtitle: '刚才吃下的食物正在消化，血糖升高，身体以消耗糖分为主。',
        icon: Icons.restaurant,
        color: AppColors.warning,
      );
    }
    // 2 - 8 小时：血糖下降期
    if (elapsedHours < 8) {
      return const _FastingStage(
        title: '身体状态：血糖下降期',
        subtitle: '消化完成，血糖逐渐下降，胰岛素分泌减少。可能会感到轻微饥饿，喝水有助于缓解。',
        icon: Icons.trending_down_rounded,
        color: AppColors.primary,
      );
    }
    // 8 - 12 小时：糖原消耗期
    if (elapsedHours < 12) {
      return const _FastingStage(
        title: '身体状态：糖原消耗期',
        subtitle: '肝脏中的糖原即将耗尽，身体准备切换能量来源。挺住，马上开始燃脂！',
        icon: Icons.battery_charging_full_rounded,
        color: AppColors.primary,
      );
    }
    // 12 - 14 小时：进入燃脂状态
    if (elapsedHours < 14) {
      return const _FastingStage(
        title: '身体状态：燃脂状态',
        subtitle: '糖原已耗尽，身体正式开始燃烧脂肪获取能量（酮症）。',
        icon: Icons.local_fire_department_rounded,
        color: AppColors.error,
      );
    }
    // 14 - 16 小时：深度燃脂
    if (elapsedHours < 16) {
      return const _FastingStage(
        title: '身体状态：深度燃脂',
        subtitle: '脂肪酸转化为酮体，能量更加稳定，专注力提升。',
        icon: Icons.fireplace_rounded,
        color: AppColors.primary,
      );
    }
    // 16 小时以上：细胞自噬
    return const _FastingStage(
      title: '身体状态：细胞自噬',
      subtitle: '身体正在清理老化和受损细胞，促进细胞更新与抗衰老。',
      icon: Icons.shield_rounded,
      color: AppColors.primary,
    );
  }

  Widget _buildTodayHealthPanel({FastingTimerData? timer}) {
    final recommendedWater = ref.watch(recommendedWaterAmountProvider);
    final waterTotal = ref.watch(todayWaterTotalProvider);
    final fastingSessions = ref.watch(fastingSessionsProvider);

    final water = waterTotal.valueOrNull ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildWaterTrackerCard(water, recommendedWater),
        const SizedBox(height: 18),
        _weeklyFastingCard(fastingSessions),
      ],
    );
  }

  Widget _buildWaterTrackerCard(int water, int recommendedWater) {
    final progress = (water / recommendedWater).clamp(0.0, 1.0);
    return GestureDetector(
      onTap: () {
        _addWaterRecord(250);
      },
      child: Container(
        height: 96,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24.0),
          boxShadow: [BoxShadow(color: Color(0x1A000000), blurRadius: 10, offset: Offset(0, 4))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.0),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 1200),
                  curve: Curves.elasticOut,
                  height: 96 * progress,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withValues(alpha: 0.8),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.water_drop_rounded,
                                color: AppColors.info,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              '饮水进度',
                              style: TextStyle(
                                color: _muted,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.info.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add_rounded,
                            color: AppColors.info,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      '$water / $recommendedWater ml',
                      style: const TextStyle(
                        color: _ink,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _progressLine({
    required String label,
    required String value,
    required double progress,
    required Color color,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                color: _muted,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(99.0),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: color.withValues(alpha: 0.12),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _weeklyFastingCard(AsyncValue<List<FastingSession>> sessionsAsync) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [BoxShadow(color: Color(0x1A000000), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: sessionsAsync.when(
        data: (sessions) {
          final summary = _weekSummary(sessions);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '本周断食',
                style: TextStyle(
                  color: _ink,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 13),
              Row(
                children: [
                  Expanded(
                    child: _weeklyNumber(
                      value: '${summary.completed}',
                      label: '已完成',
                    ),
                  ),
                  Expanded(
                    child: _weeklyNumber(
                      value: '${summary.totalHours.round()}h',
                      label: '累计时长',
                    ),
                  ),
                  Expanded(
                    child: _weeklyNumber(
                      value: '${summary.streak}',
                      label: '连续天数',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 13),
              _progressLine(
                label: '本周目标',
                value: '${summary.completed}/5',
                progress: (summary.completed / 5).clamp(0.0, 1.0),
                color: _leaf,
              ),
            ],
          );
        },
        loading: () => const Text(
          '本周断食加载中',
          style: TextStyle(color: _muted, fontWeight: FontWeight.w400),
        ),
        error: (_, __) => const Text(
          '暂无本周断食记录',
          style: TextStyle(color: _muted, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  Widget _weeklyNumber({required String value, required String label}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: _ink,
            fontSize: 22,
            height: 1,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            color: _muted,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  _WeeklyFastingSummary _weekSummary(List<FastingSession> sessions) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekStart = today.subtract(Duration(days: today.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 7));
    final completed = sessions.where((session) {
      final end = session.endTime ?? session.startTime;
      return session.isFinished &&
          !end.isBefore(weekStart) &&
          end.isBefore(weekEnd);
    }).toList();
    final totalHours = completed.fold<double>(
      0,
      (sum, session) => sum + session.actualFastingDurationHours,
    );
    final completedDays = completed.map((session) {
      final end = session.endTime ?? session.startTime;
      return DateTime(end.year, end.month, end.day);
    }).toSet();
    var streak = 0;
    var cursor = today;
    while (completedDays.contains(cursor)) {
      streak += 1;
      cursor = cursor.subtract(const Duration(days: 1));
    }

    return _WeeklyFastingSummary(
      completed: completed.length,
      totalHours: totalHours,
      streak: streak,
    );
  }

  FastingPlan _planForSession(
    FastingSession? session,
    List<FastingPlan> plans,
  ) {
    if (session != null) {
      for (final plan in plans) {
        if (plan.id == session.planId) return plan;
      }
    }
    return plans.firstWhere(
      (plan) => plan.id == 'preset_16_8',
      orElse: () => plans.isNotEmpty ? plans.first : FastingPlan.presetPlans[2],
    );
  }

  Future<void> _editIdleStartTime(DateTime initialTime) async {
    final nextTime = await _showHarmonyDateTimePicker(
      title: '调整开始时间',
      initialValue: initialTime,
    );
    if (!mounted || nextTime == null) return;
    if (nextTime.isAfter(DateTime.now())) {
      _showTimeEditMessage('开始时间不能晚于现在');
      return;
    }
    setState(() {
      _customStartTime = nextTime;
    });
  }

  Future<void> _startFasting(FastingPlan plan) async {
    final isLowCalorie = plan.fastingHours == 0 && plan.eatingHours == 0;
    final result = await ref
        .read(fastingSessionsProvider.notifier)
        .startFasting(
          plan,
          startTime: _customStartTime,
          isLowCalorieDay: isLowCalorie,
          calorieTarget: isLowCalorie ? 600 : null,
        );

    if (!mounted) return;

    // 清除自定义时间，以便下次恢复“现在”
    setState(() {
      _customStartTime = null;
    });

    showAppToast(
      context,
      result ?? '已开始 ${plan.name}',
      type: result == null ? AppToastType.success : AppToastType.info,
    );
  }

  Future<void> _endFasting(FastingSession session) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FastingCelebrationPage(session: session),
      ),
    );
  }

  Future<void> _editSessionTime(
    FastingSession session, {
    required bool isStartTime,
  }) async {
    final currentValue = isStartTime
        ? session.startTime
        : (session.plannedEndTime ??
              session.startTime.add(Duration(hours: session.fastingHours)));
    final nextTime = await _showHarmonyDateTimePicker(
      title: isStartTime ? '调整开始时间' : '调整计划结束',
      initialValue: currentValue,
    );
    if (!mounted || nextTime == null) return;
    final currentEnd =
        session.plannedEndTime ??
        session.startTime.add(Duration(hours: session.fastingHours));

    late final FastingSession updatedSession;
    if (isStartTime) {
      if (!currentEnd.isAfter(nextTime)) {
        _showTimeEditMessage('开始时间必须早于计划结束时间');
        return;
      }
      updatedSession = session.copyWith(
        startTime: nextTime,
        updatedAt: DateTime.now(),
      );
    } else {
      if (!nextTime.isAfter(session.startTime)) {
        _showTimeEditMessage('计划结束时间必须晚于开始时间');
        return;
      }
      final durationHours =
          nextTime.difference(session.startTime).inMinutes / 60;
      updatedSession = session.copyWith(
        plannedEndTime: nextTime,
        fastingHours: durationHours.ceil().clamp(1, 240),
        updatedAt: DateTime.now(),
      );
    }

    await ref
        .read(fastingSessionsProvider.notifier)
        .updateSession(updatedSession);
    if (!mounted) return;
    _showTimeEditMessage(isStartTime ? '开始时间已调整' : '计划结束时间已调整');
  }

  void _showTimeEditMessage(String text) {
    showAppToast(context, text, type: AppToastType.info);
  }

  Future<DateTime?> _showHarmonyDateTimePicker({
    required String title,
    required DateTime initialValue,
  }) async {
    final baseDate = DateTime.now().subtract(const Duration(days: 30));
    final dates = List.generate(61, (index) {
      final value = baseDate.add(Duration(days: index));
      return DateTime(value.year, value.month, value.day);
    });
    var selectedDate = DateTime(
      initialValue.year,
      initialValue.month,
      initialValue.day,
    );
    var selectedHour = initialValue.hour;
    var selectedMinute = initialValue.minute;
    final initialDateIndex = dates.indexWhere(
      (date) =>
          date.year == selectedDate.year &&
          date.month == selectedDate.month &&
          date.day == selectedDate.day,
    );

    return showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.28),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return HarmonyPickerSheet(
              title: title,
              subtitle: '上下滑动选择日期和时间',
              confirmText: '保存',
              heightFactor: 0.52,
              onCancel: () => Navigator.pop(sheetContext),
              onConfirm: () {
                Navigator.pop(
                  sheetContext,
                  DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                    selectedHour,
                    selectedMinute,
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
                child: Column(
                  children: [
                    Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${selectedDate.month}月${selectedDate.day}日 ${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          color: _ink,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: HarmonyWheelPicker<DateTime>(
                              items: dates,
                              selectedIndex: math.max(0, initialDateIndex),
                              labelBuilder: _formatPickerDate,
                              onSelectedItemChanged: (index) {
                                setSheetState(
                                  () => selectedDate = dates[index],
                                );
                              },
                            ),
                          ),
                          Expanded(
                            child: HarmonyWheelPicker<int>(
                              items: List.generate(24, (index) => index),
                              selectedIndex: selectedHour,
                              labelBuilder: (hour) =>
                                  hour.toString().padLeft(2, '0'),
                              onSelectedItemChanged: (index) {
                                setSheetState(() => selectedHour = index);
                              },
                            ),
                          ),
                          const Text(
                            ':',
                            style: TextStyle(
                              color: _ink,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Expanded(
                            child: HarmonyWheelPicker<int>(
                              items: List.generate(60, (index) => index),
                              selectedIndex: selectedMinute,
                              labelBuilder: (minute) =>
                                  minute.toString().padLeft(2, '0'),
                              onSelectedItemChanged: (index) {
                                setSheetState(() => selectedMinute = index);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _formatPickerDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final diff = date.difference(today).inDays;
    if (diff == 0) return '今天';
    if (diff == -1) return '昨天';
    if (diff == 1) return '明天';
    return '${date.month}月${date.day}日';
  }

  Future<void> _addWaterRecord(int amount) async {
    await ref.read(waterRecordsProvider.notifier).addQuickRecord(amount);
    if (!mounted) return;
    showAppToast(context, '已添加 ${amount}ml 饮水', type: AppToastType.success);
  }

  String _formatRelativeTime(DateTime time) {
    final now = DateTime.now();
    final date = DateTime(time.year, time.month, time.day);
    final today = DateTime(now.year, now.month, now.day);
    final prefix = date == today
        ? '今天'
        : date == today.subtract(const Duration(days: 1))
        ? '昨天'
        : date == today.add(const Duration(days: 1))
        ? '明天'
        : '${time.month}/${time.day}';
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$prefix $hour:$minute';
  }
}

class _FastingStage {
  const _FastingStage({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
}

class _WeeklyFastingSummary {
  const _WeeklyFastingSummary({
    required this.completed,
    required this.totalHours,
    required this.streak,
  });

  final int completed;
  final double totalHours;
  final int streak;
}

class _ActiveRingPainter extends CustomPainter {
  const _ActiveRingPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 8;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final startAngle = -math.pi / 2;
    final sweepAngle = math.pi * 2 * progress;

    // Background track
    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round
      ..color = AppColors.surface;

    // Progress ring gradient
    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round
      ..shader = const SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: math.pi * 1.5,
        colors: [
          AppColors.primaryLight,
          AppColors.primary,
          AppColors.primaryDark,
        ],
        stops: [0.0, 0.5, 1.0],
      ).createShader(rect);

    canvas.drawCircle(center, radius, bgPaint);

    if (progress > 0) {
      canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);

      // Draw leading dot
      final dotAngle = startAngle + sweepAngle;
      final dotX = center.dx + radius * math.cos(dotAngle);
      final dotY = center.dy + radius * math.sin(dotAngle);

      final dotBgPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = Colors.white;

      final dotBorderPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5
        ..color = AppColors.primary;

      canvas.drawCircle(Offset(dotX, dotY), 7, dotBgPaint);
      canvas.drawCircle(Offset(dotX, dotY), 7, dotBorderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ActiveRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
