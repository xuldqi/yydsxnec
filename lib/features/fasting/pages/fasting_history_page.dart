import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../providers/fasting_provider.dart';
import '../models/fasting_session.dart';
import '../models/fasting_plan.dart';
import '../core/constants/app_constants.dart';
import 'package:steps_webu_flutter/core/theme/app_colors.dart';
import '../components/modern_card.dart';
import '../components/add_fasting_record_sheet.dart';

class FastingHistoryPage extends ConsumerWidget {
  const FastingHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(fastingSessionsProvider);
    final plansAsync = ref.watch(fastingPlansProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('断食历史'),
        centerTitle: true,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const AddFastingRecordSheet(),
              );
            },
          ),
        ],
      ),
      body: sessionsAsync.when(
        data: (sessions) {
          if (sessions.isEmpty) {
            return _buildEmptyState(context);
          }

          // 按日期分组
          final groupedSessions = _groupSessionsByDate(sessions);

          return ListView.builder(
            padding: const EdgeInsets.all(24.0),
            itemCount: groupedSessions.length,
            itemBuilder: (context, index) {
              final entry = groupedSessions[index];
              return _buildDateGroup(
                context,
                ref,
                entry.key,
                entry.value,
                plansAsync,
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.primaryDark,
              ),
              const SizedBox(height: 16),
              Text('加载失败: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(fastingSessionsProvider),
                child: const Text('重试'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.history, size: 80, color: AppColors.textSecondary),
          const SizedBox(height: 24),
          Text(
            '暂无断食记录',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            '开始您的第一次断食之旅吧！',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  List<MapEntry<DateTime, List<FastingSession>>> _groupSessionsByDate(
    List<FastingSession> sessions,
  ) {
    final Map<DateTime, List<FastingSession>> grouped = {};

    for (final session in sessions) {
      final date = DateTime(
        session.startTime.year,
        session.startTime.month,
        session.startTime.day,
      );

      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(session);
    }

    final sortedEntries = grouped.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));

    return sortedEntries;
  }

  Widget _buildDateGroup(
    BuildContext context,
    WidgetRef ref,
    DateTime date,
    List<FastingSession> sessions,
    AsyncValue<List<FastingPlan>> plansAsync,
  ) {
    final dateFormatter = DateFormat('yyyy年MM月dd日');
    final weekDayFormatter = DateFormat('EEEE', 'zh_CN');

    final now = DateTime.now();
    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;
    final yesterday = now.subtract(const Duration(days: 1));
    final isYesterday =
        date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;

    String dateText;
    if (isToday) {
      dateText = '今天';
    } else if (isYesterday) {
      dateText = '昨天';
    } else {
      dateText =
          '${dateFormatter.format(date)} ${weekDayFormatter.format(date)}';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            dateText,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        ...sessions.map(
          (session) => _buildSessionCard(context, ref, session, plansAsync),
        ),
        const SizedBox(height: 8.0),
      ],
    );
  }

  Widget _buildSessionCard(
    BuildContext context,
    WidgetRef ref,
    FastingSession session,
    AsyncValue<List<FastingPlan>> plansAsync,
  ) {
    return plansAsync.when(
      data: (plans) {
        final plan = plans.firstWhere(
          (p) => p.id == session.planId,
          orElse: () =>
              plans.isNotEmpty ? plans.first : FastingPlan.presetPlans.first,
        );

        return Container(
          margin: const EdgeInsets.only(bottom: 16.0),
          child: Dismissible(
            key: Key(session.id),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20.0),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) {
              ref
                  .read(fastingSessionsProvider.notifier)
                  .deleteSession(session.id);
            },
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) =>
                      AddFastingRecordSheet(editingSession: session),
                );
              },
              child: ModernCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 标题行
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                plan.name,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${session.fastingHours}:${session.eatingHours}',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        _buildStatusBadge(context, session.status),
                      ],
                    ),
                    const SizedBox(height: 16.0),

                    // 时间信息
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatSessionTime(session),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),

                    // 持续时间
                    Row(
                      children: [
                        const Icon(
                          Icons.timer_outlined,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '实际断食: ${_formatDuration(session.actualFastingDurationMinutes)}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),

                    // 成功率
                    if (session.status == FastingStatus.completed) ...[
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              value: session.successRate,
                              backgroundColor: AppColors.divider,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                session.successRate >= 0.8
                                    ? Color(0xFF10B981)
                                    : session.successRate >= 0.5
                                    ? AppColors.warning
                                    : AppColors.error,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            '${(session.successRate * 100).toStringAsFixed(0)}%',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: session.successRate >= 0.8
                                      ? Color(0xFF10B981)
                                      : session.successRate >= 0.5
                                      ? AppColors.warning
                                      : AppColors.error,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
      loading: () => const SizedBox(),
      error: (_, __) => const SizedBox(),
    );
  }

  Widget _buildStatusBadge(BuildContext context, FastingStatus status) {
    Color color;
    String text;
    IconData icon;

    switch (status) {
      case FastingStatus.completed:
        color = Color(0xFF10B981);
        text = '已完成';
        icon = Icons.check_circle;
        break;
      case FastingStatus.cancelled:
        color = AppColors.error;
        text = '已取消';
        icon = Icons.cancel;
        break;
      case FastingStatus.paused:
        color = AppColors.warning;
        text = '已暂停';
        icon = Icons.pause_circle;
        break;
      case FastingStatus.active:
        color = AppColors.primary;
        text = '进行中';
        icon = Icons.play_circle;
        break;
      default:
        color = AppColors.textSecondary;
        text = '未开始';
        icon = Icons.radio_button_unchecked;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 16.0,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatSessionTime(FastingSession session) {
    final timeFormatter = DateFormat('HH:mm');
    final startTime = timeFormatter.format(session.startTime);

    if (session.endTime != null) {
      final endTime = timeFormatter.format(session.endTime!);
      return '$startTime - $endTime';
    } else if (session.plannedEndTime != null) {
      final endTime = timeFormatter.format(session.plannedEndTime!);
      return '$startTime - $endTime (计划)';
    }

    return '开始于 $startTime';
  }

  String _formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;

    if (hours > 0) {
      return '$hours小时$mins分钟';
    }
    return '$mins分钟';
  }
}
