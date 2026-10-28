// Period 主页 (PeriodHomeActivity)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import 'period_provider.dart';

class PeriodHomeScreen extends ConsumerStatefulWidget {
  const PeriodHomeScreen({super.key});
  @override
  ConsumerState<PeriodHomeScreen> createState() => _PeriodHomeScreenState();
}

class _PeriodHomeScreenState extends ConsumerState<PeriodHomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(periodProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(periodProvider);
    final state = asyncState.valueOrNull ?? const PeriodState();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('经期'),
        actions: [
          IconButton(icon: const Icon(Icons.calendar_month_rounded), onPressed: () => context.push('/period/calendar')),
          IconButton(icon: const Icon(Icons.bar_chart_rounded), onPressed: () => context.push('/period/trends')),
          IconButton(icon: const Icon(Icons.notifications_rounded), onPressed: () => context.push('/period/reminder')),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/period/record'),
        icon: const Icon(Icons.add_rounded),
        label: const Text('记录经期'),
        backgroundColor: Color(0xFFE85D9C),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimens.spacingMd),
        children: [
          _phaseCard(state),
          const SizedBox(height: 16),
          _predictionCard(state),
          const SizedBox(height: 16),
          _cycleSettings(state),
          const SizedBox(height: 16),
          _history(state),
        ],
      ),
    );
  }

  Widget _phaseCard(PeriodState s) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.spacingLg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE85D9C), Color(0xFFF4A3C4)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
      ),
      child: Column(
        children: [
          const Text('当前阶段', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 8),
          Text(s.currentPhase, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('周期第 ${s.cycleDay} 天', style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _predictionCard(PeriodState s) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.spacingMd),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(color: Color(0xFFE85D9C).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.event_rounded, color: Color(0xFFE85D9C)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('下次预测', style: TextStyle(color: AppColors.textHint, fontSize: 12)),
                const SizedBox(height: 4),
                Text(
                  s.nextPrediction == null ? '尚未设置' : _format(s.nextPrediction!),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(s.nextPrediction == null ? '' : '还有 ${s.daysToNext} 天', style: const TextStyle(color: AppColors.textHint, fontSize: 12)),
              ],
            ),
          ),
          TextButton(onPressed: () => context.push('/period/prediction'), child: const Text('详情')),
        ],
      ),
    );
  }

  Widget _cycleSettings(PeriodState s) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.spacingMd),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('平均周期', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('${s.avgCycle} 天', style: const TextStyle(fontSize: 24, color: Color(0xFFE85D9C), fontWeight: FontWeight.bold)),
              const Spacer(),
              IconButton(icon: const Icon(Icons.remove_rounded), onPressed: () => ref.read(periodProvider.notifier).setCycle((s.avgCycle - 1).clamp(20, 40))),
              IconButton(icon: const Icon(Icons.add_rounded), onPressed: () => ref.read(periodProvider.notifier).setCycle((s.avgCycle + 1).clamp(20, 40))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _history(PeriodState s) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('历史记录', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...s.records.map((r) => Card(
              color: AppColors.surface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                title: Text(_format(r.startDate)),
                subtitle: Text('持续 ${r.durationDays} 天'),
                trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textHint),
                onTap: () => context.push('/period/history'),
              ),
            )),
      ],
    );
  }

  String _format(DateTime d) {
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }
}
