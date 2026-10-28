import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/services/health_providers.dart';
import 'core/constants/app_constants.dart';
import 'models/fasting_plan.dart';
import 'models/fasting_session.dart';
import 'providers/fasting_provider.dart';
import 'providers/timer_provider.dart';
import 'pages/fasting_history_page.dart';

class UnifiedFastingScreen extends ConsumerStatefulWidget {
  const UnifiedFastingScreen({super.key});

  @override
  ConsumerState<UnifiedFastingScreen> createState() => _UnifiedFastingScreenState();
}

class _UnifiedFastingScreenState extends ConsumerState<UnifiedFastingScreen> {
  bool _showRemaining = false; // Toggle between elapsed and remaining timer
  String _selectedPlanId = 'preset_16_8'; // Default plan

  @override
  Widget build(BuildContext context) {
    final activeSession = ref.watch(activeFastingSessionProvider);
    final timer = ref.watch(fastingTimerProvider);
    final plansAsync = ref.watch(fastingPlansProvider);
    final plans = plansAsync.valueOrNull ?? FastingPlan.presetPlans;

    // Find current active plan or selected plan
    final currentPlan = activeSession != null
        ? plans.firstWhere(
            (p) => p.id == activeSession.planId,
            orElse: () => FastingPlan.presetPlans.firstWhere(
              (p) => p.id == 'preset_16_8',
              orElse: () => FastingPlan.presetPlans.first,
            ),
          )
        : plans.firstWhere(
            (p) => p.id == _selectedPlanId,
            orElse: () => FastingPlan.presetPlans.firstWhere(
              (p) => p.id == 'preset_16_8',
              orElse: () => FastingPlan.presetPlans.first,
            ),
          );

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F8),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEFEBFA), Color(0xFFF3F4F8), Color(0xFFEBEFF9)],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _buildHeader(currentPlan, plans, activeSession != null),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 110),
                  children: [
                    _buildTimerRingHero(activeSession, currentPlan, timer),
                    const SizedBox(height: 20),
                    if (activeSession == null) ...[
                      _buildPlanSelectorBar(plans, currentPlan),
                      const SizedBox(height: 20),
                    ],
                    _buildBiologicalStagesCard(activeSession, timer),
                    const SizedBox(height: 20),
                    _buildWaterAndDrinkCompanionCard(),
                    const SizedBox(height: 20),
                    _buildStreakAndStatsCard(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────────────────────
  Widget _buildHeader(FastingPlan currentPlan, List<FastingPlan> plans, bool isFastingActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded, color: Color(0xFF1E1B4B), size: 20),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/home');
                  }
                },
              ),
              const Text(
                '轻断食',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E1B4B),
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          Row(
            children: [
              // Plan Switcher Chip
              GestureDetector(
                onTap: isFastingActive
                    ? () => _showCannotSwitchPlanDialog()
                    : () => _showPlanPickerSheet(plans),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(color: Color(0x081E1B4B), blurRadius: 8, offset: Offset(0, 2)),
                    ],
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isFastingActive ? const Color(0xFF10B981) : const Color(0xFF6366F1),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        currentPlan.fastingHours > 0
                            ? '${currentPlan.fastingHours}:${currentPlan.eatingHours}'
                            : currentPlan.name,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E1B4B),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF64748B), size: 18),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // History Button
              IconButton(
                icon: const Icon(Icons.history_rounded, color: Color(0xFF1E1B4B), size: 24),
                tooltip: '断食历史',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FastingHistoryPage()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Hero Fasting Timer Ring ────────────────────────────────────────────────
  Widget _buildTimerRingHero(FastingSession? session, FastingPlan plan, FastingTimerData timer) {
    final isActive = session != null && session.status == FastingStatus.active;
    final progress = isActive ? (timer.progressPercentage / 100).clamp(0.0, 1.0) : 0.0;
    final isOvertime = timer.isOvertime;
    final isEatingWindow = timer.isEatingWindow;

    // Display strings
    final elapsedHours = timer.elapsedTime.inHours;
    final elapsedMinutes = timer.elapsedTime.inMinutes % 60;
    final elapsedSeconds = timer.elapsedTime.inSeconds % 60;
    final elapsedStr = '${elapsedHours.toString().padLeft(2, '0')}:${elapsedMinutes.toString().padLeft(2, '0')}:${elapsedSeconds.toString().padLeft(2, '0')}';

    final remainingHours = timer.remainingTime.inHours;
    final remainingMinutes = timer.remainingTime.inMinutes % 60;
    final remainingSeconds = timer.remainingTime.inSeconds % 60;
    final remainingStr = '${remainingHours.toString().padLeft(2, '0')}:${remainingMinutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';

    // Status label
    String statusTitle;
    Color statusColor;
    if (!isActive) {
      statusTitle = '准备就绪 · 待开启';
      statusColor = const Color(0xFF64748B);
    } else if (isEatingWindow) {
      statusTitle = '🍽️ 进食窗口开放中';
      statusColor = const Color(0xFF10B981);
    } else if (isOvertime) {
      statusTitle = '🔥 超额燃脂阶段';
      statusColor = const Color(0xFFF59E0B);
    } else if (elapsedHours >= 16) {
      statusTitle = '✨ 细胞自噬巅峰期';
      statusColor = const Color(0xFF8B5CF6);
    } else if (elapsedHours >= 12) {
      statusTitle = '🔥 深度燃脂生酮期';
      statusColor = const Color(0xFFF97316);
    } else if (elapsedHours >= 8) {
      statusTitle = '⚡ 糖原快速消耗期';
      statusColor = const Color(0xFF0EA5E9);
    } else {
      statusTitle = '⏳ 消化系统休整中';
      statusColor = const Color(0xFF6366F1);
    }

    // Format Start & End Times
    final startTimeStr = isActive ? DateFormat('HH:mm').format(session.startTime) : '--:--';
    final endTime = isActive
        ? (session.plannedEndTime ?? session.startTime.add(Duration(hours: session.fastingHours)))
        : DateTime.now().add(Duration(hours: plan.fastingHours > 0 ? plan.fastingHours : 16));
    final endTimeStr = isActive ? DateFormat('HH:mm').format(endTime) : DateFormat('HH:mm').format(endTime);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A1E1B4B),
            blurRadius: 20,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Circular Ring
          SizedBox(
            width: 250,
            height: 250,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Custom Circular Arc
                CustomPaint(
                  size: const Size(250, 250),
                  painter: _FastingRingPainter(
                    progress: isActive ? (isOvertime ? 1.0 : progress) : 0.0,
                    primaryColor: isOvertime
                        ? const Color(0xFFF59E0B)
                        : (isEatingWindow ? const Color(0xFF10B981) : const Color(0xFF6366F1)),
                    trackColor: const Color(0xFFF1F5F9),
                  ),
                ),
                // Inner Content
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        statusTitle,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: statusColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Main Timer Display
                    GestureDetector(
                      onTap: isActive ? () => setState(() => _showRemaining = !_showRemaining) : null,
                      child: Column(
                        children: [
                          Text(
                            isActive ? (_showRemaining ? remainingStr : elapsedStr) : '${plan.fastingHours > 0 ? plan.fastingHours : 16}:00:00',
                            style: const TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1E1B4B),
                              fontFeatures: [FontFeature.tabularFigures()],
                              letterSpacing: -1,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                isActive ? (_showRemaining ? '剩余倒计时 (点击切换)' : '已断食时长 (点击切换)') : '计划断食目标时长',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF94A3B8),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (isActive) ...[
                                const SizedBox(width: 4),
                                const Icon(Icons.sync_alt_rounded, size: 12, color: Color(0xFF94A3B8)),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Progress percentage badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Text(
                        isActive ? '${(progress * 100).toInt()}% 达成' : '方案: ${plan.name}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Start & Target End Times
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTimeBadge('开始时间', startTimeStr, Icons.play_circle_outline_rounded),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                width: 1,
                height: 28,
                color: const Color(0xFFE2E8F0),
              ),
              _buildTimeBadge('预计结束', endTimeStr, Icons.flag_outlined),
            ],
          ),
          const SizedBox(height: 24),
          // Action Button (Start / End)
          if (!isActive) ...[
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () => _handleStartFasting(plan),
                icon: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 24),
                label: const Text(
                  '开始断食 🚀',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => _handleStartFastingWithCustomTime(plan),
              child: const Text(
                '补记从更早时间开始 ✏️',
                style: TextStyle(color: Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () => _handleEndFasting(session),
                      icon: const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                      label: const Text(
                        '结束断食 🏁',
                        style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () => _handleCancelFasting(session),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFEF4444),
                      side: const BorderSide(color: Color(0xFFFEE2E2)),
                      backgroundColor: const Color(0xFFFEF2F2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('放弃', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimeBadge(String title, String time, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF6366F1)),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500)),
            Text(time, style: const TextStyle(fontSize: 14, color: Color(0xFF1E1B4B), fontWeight: FontWeight.w800)),
          ],
        ),
      ],
    );
  }

  // ── Plan Selector Horizontal Bar ──────────────────────────────────────────
  Widget _buildPlanSelectorBar(List<FastingPlan> plans, FastingPlan currentPlan) {
    final presetOptions = [
      ('preset_14_10', '14:10', '初学温和'),
      ('preset_16_8', '16:8', '黄金燃脂'),
      ('preset_18_6', '18:6', '深度自噬'),
      ('preset_20_4', '20:4', '生酮战士'),
      ('preset_24h', '24:0', 'OMAD'),
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(color: Color(0x061E1B4B), blurRadius: 16, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '选择断食方案',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF1E1B4B)),
              ),
              GestureDetector(
                onTap: () => _showPlanPickerSheet(plans),
                child: const Text(
                  '查看全部 ▾',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF6366F1)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: presetOptions.map((opt) {
                final isSelected = opt.$1 == currentPlan.id || opt.$1 == _selectedPlanId;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedPlanId = opt.$1;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF6366F1) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF6366F1) : const Color(0xFFE2E8F0),
                        width: 1.5,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              )
                            ]
                          : null,
                    ),
                    child: Column(
                      children: [
                        Text(
                          opt.$2,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: isSelected ? Colors.white : const Color(0xFF1E1B4B),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          opt.$3,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white70 : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ── 5 Biological Stages Milestone Tracker ──────────────────────────────────
  Widget _buildBiologicalStagesCard(FastingSession? session, FastingTimerData timer) {
    final elapsedHours = session != null ? timer.elapsedTime.inHours : 0;

    final stages = [
      (
        hoursRange: '0 - 2 小时',
        title: '血糖平稳期',
        desc: '消化系统开始歇息，血糖与胰岛素分泌下降，胃肠排空。',
        icon: Icons.water_drop_outlined,
        color: const Color(0xFF0EA5E9),
        minHour: 0,
        maxHour: 2,
      ),
      (
        hoursRange: '2 - 8 小时',
        title: '肠胃休整期',
        desc: '消化酶分泌降低，肠道全面休息排毒，胃饥饿素出现波动。',
        icon: Icons.eco_outlined,
        color: const Color(0xFF10B981),
        minHour: 2,
        maxHour: 8,
      ),
      (
        hoursRange: '8 - 12 小时',
        title: '糖原消耗期',
        desc: '肝糖原逐渐消耗殆尽，机体代谢引擎向燃脂模式平稳切换。',
        icon: Icons.bolt_rounded,
        color: const Color(0xFFF59E0B),
        minHour: 8,
        maxHour: 12,
      ),
      (
        hoursRange: '12 - 16 小时',
        title: '深度燃脂生酮期',
        desc: '脂肪分解动员达到巅峰，生成高能酮体供大脑运转，精力倍增。',
        icon: Icons.local_fire_department_rounded,
        color: const Color(0xFFF97316),
        minHour: 12,
        maxHour: 16,
      ),
      (
        hoursRange: '16 - 20+ 小时',
        title: '细胞自噬巅峰期',
        desc: '溶酶体吞噬老化损伤细胞微粒，激活抗衰老Sirtuins长寿因子。',
        icon: Icons.auto_awesome_rounded,
        color: const Color(0xFF8B5CF6),
        minHour: 16,
        maxHour: 999,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(color: Color(0x061E1B4B), blurRadius: 16, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.biotech_rounded, color: Color(0xFF6366F1), size: 20),
                  SizedBox(width: 8),
                  Text(
                    '五大身体生理里程碑',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E1B4B),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  '科学自噬理论',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF6366F1)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...stages.asMap().entries.map((entry) {
            final s = entry.value;
            final isCompleted = session != null && elapsedHours >= s.maxHour;
            final isCurrent = session != null && elapsedHours >= s.minHour && elapsedHours < s.maxHour;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isCurrent
                    ? s.color.withValues(alpha: 0.08)
                    : (isCompleted ? const Color(0xFFF8FAFC) : Colors.white),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isCurrent
                      ? s.color
                      : (isCompleted ? const Color(0xFFE2E8F0) : const Color(0xFFF1F5F9)),
                  width: isCurrent ? 1.5 : 1.0,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: s.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(s.icon, color: s.color, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              s.title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: isCurrent ? s.color : const Color(0xFF1E1B4B),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: isCurrent
                                    ? s.color
                                    : (isCompleted ? const Color(0xFF10B981) : const Color(0xFFE2E8F0)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                isCurrent ? '当前阶段 🌟' : (isCompleted ? '已达标 ✓' : s.hoursRange),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: isCurrent || isCompleted ? Colors.white : const Color(0xFF64748B),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          s.desc,
                          style: TextStyle(
                            fontSize: 12,
                            color: isCurrent ? const Color(0xFF334155) : const Color(0xFF64748B),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ── Drink & Water Companion Card ──────────────────────────────────────────
  Widget _buildWaterAndDrinkCompanionCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(color: Color(0x061E1B4B), blurRadius: 16, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.water_drop_rounded, color: Color(0xFF06B6D4), size: 20),
                  SizedBox(width: 8),
                  Text(
                    '断食伴侣 & 补水打卡',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1E1B4B)),
                  ),
                ],
              ),
              InkWell(
                onTap: _quickLogWater,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF06B6D4).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.add_rounded, size: 14, color: Color(0xFF0891B2)),
                      SizedBox(width: 2),
                      Text(
                        '+250ml 纯水',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF0891B2)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            '断食期间充分饮水能缓解假性饥饿，并协助排泄体内酮体代谢废物。',
            style: TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.4),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('🟢 允许饮用 (0卡不破断食):', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  '• 白开水 / 纯净水 · 纯黑咖啡(促进自噬) · 绿茶/普洱 · 淡盐水/电解质水',
                  style: TextStyle(fontSize: 11, color: Color(0xFF475569)),
                ),
                SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('🔴 破坏断食 (严禁碰触):', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFEF4444))),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  '• 含糖奶茶 · 牛奶/拿铁 · 代糖/无糖可乐 · 果汁/椰子水 · 饼干零食',
                  style: TextStyle(fontSize: 11, color: Color(0xFF475569)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Streak and Stats ──────────────────────────────────────────────────────
  Widget _buildStreakAndStatsCard() {
    final sessionsAsync = ref.watch(fastingSessionsProvider);
    final sessions = sessionsAsync.valueOrNull ?? [];
    final completedCount = sessions.where((s) => s.status == FastingStatus.completed).length;
    final totalHours = sessions.fold<double>(
      0.0,
      (sum, s) => sum + (s.status == FastingStatus.completed ? s.actualFastingDurationHours : 0.0),
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(color: Color(0x061E1B4B), blurRadius: 16, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('累计达标', '$completedCount 次', Icons.emoji_events_rounded, const Color(0xFFF59E0B)),
          Container(width: 1, height: 36, color: const Color(0xFFF1F5F9)),
          _buildStatItem('累计时长', '${totalHours.toInt()} 小时', Icons.timelapse_rounded, const Color(0xFF6366F1)),
          Container(width: 1, height: 36, color: const Color(0xFFF1F5F9)),
          _buildStatItem('本周状态', '良好 🔥', Icons.local_fire_department_rounded, const Color(0xFFF97316)),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF1E1B4B))),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8), fontWeight: FontWeight.w600)),
      ],
    );
  }

  // ── Actions & Dialogs ─────────────────────────────────────────────────────
  Future<void> _handleStartFasting(FastingPlan plan) async {
    final error = await ref.read(fastingSessionsProvider.notifier).startFasting(plan);
    if (error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎉 断食已正式开启！请保持充足饮水'),
          backgroundColor: Color(0xFF6366F1),
        ),
      );
    }
  }

  Future<void> _handleStartFastingWithCustomTime(FastingPlan plan) async {
    final now = DateTime.now();
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now.subtract(const Duration(hours: 2))),
    );

    if (pickedTime != null) {
      final customStart = DateTime(now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);
      final finalStart = customStart.isAfter(now) ? customStart.subtract(const Duration(days: 1)) : customStart;
      final error = await ref.read(fastingSessionsProvider.notifier).startFasting(plan, startTime: finalStart);
      if (error != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('已从 ${DateFormat('HH:mm').format(finalStart)} 补记开启断食！'),
            backgroundColor: const Color(0xFF6366F1),
          ),
        );
      }
    }
  }

  Future<void> _handleEndFasting(FastingSession session) async {
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (c) => CupertinoAlertDialog(
        title: const Text('结束本次断食'),
        content: const Text('恭喜您坚持完成断食！是否确认结束并保存记录？建议进食时先补充温水和轻食。'),
        actions: [
          CupertinoDialogAction(
            child: const Text('继续断食'),
            onPressed: () => Navigator.pop(c, false),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('确认结束'),
            onPressed: () => Navigator.pop(c, true),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(fastingSessionsProvider.notifier).endFasting(session.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('🎉 断食记录已成功保存！'), backgroundColor: Color(0xFF10B981)),
        );
      }
    }
  }

  Future<void> _handleCancelFasting(FastingSession session) async {
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (c) => CupertinoAlertDialog(
        title: const Text('放弃当前断食'),
        content: const Text('确定要取消本次断食吗？记录将标记为已放弃。'),
        actions: [
          CupertinoDialogAction(
            child: const Text('容我再想想'),
            onPressed: () => Navigator.pop(c, false),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('确认放弃'),
            onPressed: () => Navigator.pop(c, true),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(fastingSessionsProvider.notifier).cancelFasting(session.id);
    }
  }

  void _quickLogWater() {
    ref.read(waterProvider.notifier).addWater(250, type: '纯水');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('💧 已补水 250ml，健康又减脂！'),
        duration: Duration(seconds: 1),
        backgroundColor: Color(0xFF06B6D4),
      ),
    );
  }

  void _showCannotSwitchPlanDialog() {
    showCupertinoDialog(
      context: context,
      builder: (c) => CupertinoAlertDialog(
        title: const Text('断食正在进行中'),
        content: const Text('当前断食会话已锁定所选方案。如需切换方案，请先结束或取消当前断食。'),
        actions: [
          CupertinoDialogAction(
            child: const Text('知道了'),
            onPressed: () => Navigator.pop(c),
          ),
        ],
      ),
    );
  }

  void _showPlanPickerSheet(List<FastingPlan> plans) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (c) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '选择适合您的轻断食方案',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1B4B)),
            ),
            const SizedBox(height: 6),
            const Text(
              '科学断食不伤身，根据日常生活作息与身体感受选择。',
              style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: plans.map((p) {
                  final isSelected = p.id == _selectedPlanId;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedPlanId = p.id;
                      });
                      Navigator.pop(c);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFEEF2FF) : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF6366F1) : const Color(0xFFE2E8F0),
                          width: isSelected ? 1.5 : 1.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      p.name,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                        color: isSelected ? const Color(0xFF6366F1) : const Color(0xFF1E1B4B),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: isSelected ? const Color(0xFF6366F1) : const Color(0xFF94A3B8),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        '断食 ${p.fastingHours}h',
                                        style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  p.description,
                                  style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            const Icon(Icons.check_circle_rounded, color: Color(0xFF6366F1), size: 22),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Custom Ring Painter ─────────────────────────────────────────────────────
class _FastingRingPainter extends CustomPainter {
  final double progress;
  final Color primaryColor;
  final Color trackColor;

  _FastingRingPainter({
    required this.progress,
    required this.primaryColor,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 24) / 2;

    // Background track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    if (progress > 0) {
      final sweepAngle = 2 * math.pi * progress;
      final progressPaint = Paint()
        ..color = primaryColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 14
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _FastingRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.trackColor != trackColor;
  }
}
