// 训练计划 (对应 Android TrainingPlanActivity + MyTrainingPlanActivity + exercise_set)
// 计划列表 + 今日训练 + 训练详情

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/app_l10n_ext.dart';

class _PlanItem {
  final String id, name, level, duration, focus;
  final int daysPerWeek;
  final int enrolled;
  final double rating;
  final List<String> tags;
  final Color color;
  final IconData icon;
  const _PlanItem({required this.id, required this.name, required this.level, required this.duration,
    required this.focus, required this.daysPerWeek, required this.enrolled, required this.rating,
    required this.tags, required this.color, required this.icon});
}

class TrainingPlanScreen extends ConsumerStatefulWidget {
  const TrainingPlanScreen({super.key});
  @override
  ConsumerState<TrainingPlanScreen> createState() => _TrainingPlanScreenState();
}

class _TrainingPlanScreenState extends ConsumerState<TrainingPlanScreen> {
  final _plans = const <_PlanItem>[
    _PlanItem(id: 'p1', name: '新手燃脂 4 周', level: '入门', duration: '4 周', focus: '全身减脂',
      daysPerWeek: 3, enrolled: 12500, rating: 4.8, tags: ['减脂', '入门', 'HIIT'],
      color: AppColors.sportRun, icon: Icons.local_fire_department_rounded),
    _PlanItem(id: 'p2', name: '增肌塑形 8 周', level: '进阶', duration: '8 周', focus: '胸/背/腿',
      daysPerWeek: 5, enrolled: 8900, rating: 4.9, tags: ['增肌', '力量', '分化训练'],
      color: AppColors.sportOther, icon: Icons.fitness_center_rounded),
    _PlanItem(id: 'p3', name: '瑜伽柔韧 4 周', level: '入门', duration: '4 周', focus: '柔韧/平衡',
      daysPerWeek: 4, enrolled: 15200, rating: 4.7, tags: ['瑜伽', '柔韧', '舒缓'],
      color: AppColors.sportOther, icon: Icons.self_improvement_rounded),
    _PlanItem(id: 'p4', name: '跑步耐力 6 周', level: '中级', duration: '6 周', focus: '5K-10K',
      daysPerWeek: 4, enrolled: 6700, rating: 4.6, tags: ['跑步', '耐力', '心肺'],
      color: AppColors.sportWalk, icon: Icons.directions_run_rounded),
    _PlanItem(id: 'p5', name: '核心力量 2 周', level: '入门', duration: '2 周', focus: '核心稳定',
      daysPerWeek: 4, enrolled: 9300, rating: 4.5, tags: ['核心', '平板', '稳定性'],
      color: AppColors.warning, icon: Icons.center_focus_strong_rounded),
    _PlanItem(id: 'p6', name: '拳击搏击 4 周', level: '进阶', duration: '4 周', focus: '全身爆发',
      daysPerWeek: 4, enrolled: 4200, rating: 4.7, tags: ['拳击', '搏击', '爆发'],
      color: AppColors.sportOther, icon: Icons.sports_mma_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context).s;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l.trainingPlan),
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.assignment_turned_in_rounded, color: AppColors.primary),
            onPressed: () => context.push('/my-training-plan'),
            tooltip: l.myTrainingPlan,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimens.spacingMd),
        children: [
          // Banner
          Container(
            padding: const EdgeInsets.all(AppDimens.spacingLg),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [AppColors.sportOther, AppColors.warning],
              ),
              borderRadius: BorderRadius.circular(AppDimens.radiusCard),
            ),
            child: Row(
              children: [
                const Icon(Icons.assignment_rounded, color: Colors.white, size: 40),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.choosePlan, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(l.choosePlanSub,
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ..._plans.map((p) => _PlanCard(plan: p, l: l, onJoin: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${l.joined}: ${p.name}'), backgroundColor: AppColors.success),
            );
            context.push('/my-training-plan');
          })),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final _PlanItem plan;
  final AppL10nStrings l;
  final VoidCallback onJoin;
  const _PlanCard({required this.plan, required this.l, required this.onJoin});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(AppDimens.spacingSm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56, height: 56,
                decoration: BoxDecoration(
                  color: plan.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(plan.icon, color: plan.color, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(plan.name, style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: plan.color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(plan.level, style: TextStyle(color: plan.color, fontSize: 10, fontWeight: FontWeight.w600)),
                        ),
                        const SizedBox(width: 6),
                        Text(plan.duration, style: const TextStyle(color: AppColors.textHint, fontSize: 11)),
                        const SizedBox(width: 6),
                        const Icon(Icons.star_rounded, color: AppColors.warning, size: 12),
                        const SizedBox(width: 2),
                        Text(plan.rating.toString(), style: const TextStyle(color: AppColors.textHint, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.textHint),
            ],
          ),
          const SizedBox(height: 8),
          Text(plan.focus, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            children: plan.tags.map((t) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('#$t', style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
            )).toList(),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.calendar_today_rounded, size: 12, color: AppColors.textHint),
              const SizedBox(width: 4),
              Text('${plan.daysPerWeek} ${l.daysPerWeek}',
                style: const TextStyle(color: AppColors.textHint, fontSize: 11)),
              const SizedBox(width: 14),
              Icon(Icons.group_rounded, size: 12, color: AppColors.textHint),
              const SizedBox(width: 4),
              Text('${plan.enrolled ~/ 1000}k+ ${l.joined}',
                style: const TextStyle(color: AppColors.textHint, fontSize: 11)),
              const Spacer(),
              SizedBox(
                height: 32,
                child: ElevatedButton(
                  onPressed: onJoin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: plan.color,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(l.joinNow, style: const TextStyle(fontSize: 12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MyTrainingPlanScreen extends ConsumerStatefulWidget {
  const MyTrainingPlanScreen({super.key});
  @override
  ConsumerState<MyTrainingPlanScreen> createState() => _MyTrainingPlanScreenState();
}

class _MyTrainingPlanScreenState extends ConsumerState<MyTrainingPlanScreen> {
  int _currentDay = 3;
  final _totalDays = 28;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context).s;
    final progress = _currentDay / _totalDays;
    final todayExercises = <_Exercise>[
      const _Exercise(name: '动态热身', duration: 5, sets: 1, color: AppColors.warning, icon: Icons.accessibility_new_rounded),
      const _Exercise(name: '深蹲', duration: 12, sets: 4, color: AppColors.sportRun, icon: Icons.fitness_center_rounded),
      const _Exercise(name: '俯卧撑', duration: 10, sets: 4, color: AppColors.sportOther, icon: Icons.accessibility_rounded),
      const _Exercise(name: '平板支撑', duration: 8, sets: 3, color: AppColors.primary, icon: Icons.center_focus_strong_rounded),
      const _Exercise(name: '拉伸放松', duration: 6, sets: 1, color: AppColors.sportOther, icon: Icons.self_improvement_rounded),
    ];
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l.myTrainingPlan),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimens.spacingMd),
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimens.spacingLg),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [AppColors.sportOther, AppColors.warning],
              ),
              borderRadius: BorderRadius.circular(AppDimens.radiusCard),
            ),
            child: Column(
              children: [
                Text('新手燃脂 4 周',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Day $_currentDay',
                      style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 4),
                    Text('/ $_totalDays',
                      style: const TextStyle(color: Colors.white70, fontSize: 18)),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress, minHeight: 8,
                    backgroundColor: Colors.white.withValues(alpha: 0.3),
                    valueColor: const AlwaysStoppedAnimation(Colors.white),
                  ),
                ),
                const SizedBox(height: 4),
                Text('${(progress * 100).toInt()}% ${l.complete}',
                  style: const TextStyle(color: Colors.white, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(l.todayTraining, style: const TextStyle(color: AppColors.textPrimary, fontSize: 17, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          ...todayExercises.asMap().entries.map((e) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(AppDimens.spacingSm),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text('${e.key + 1}',
                    style: const TextStyle(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: e.value.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(e.value.icon, color: e.value.color, size: 22),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.value.name, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text('${e.value.duration} ${l.minute} · ${e.value.sets} ${l.sets}',
                        style: const TextStyle(color: AppColors.textHint, fontSize: 12)),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(e.key < 2 ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                    color: e.key < 2 ? AppColors.success : AppColors.textHint),
                  onPressed: null,
                ),
              ],
            ),
          )),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity, height: 50,
            child: ElevatedButton.icon(
              onPressed: () => context.push('/guided-workout'),
              icon: const Icon(Icons.play_arrow_rounded, size: 24),
              label: Text(l.startTodayTraining, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(l.calendarProgress, style: const TextStyle(color: AppColors.textPrimary, fontSize: 17, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(AppDimens.spacingSm),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimens.radiusCard),
            ),
            child: GridView.count(
              crossAxisCount: 7,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              children: List.generate(_totalDays, (i) {
                final done = i < _currentDay;
                final today = i == _currentDay - 1;
                return Container(
                  decoration: BoxDecoration(
                    color: done
                      ? AppColors.success
                      : today
                        ? AppColors.primary
                        : AppColors.background,
                    borderRadius: BorderRadius.circular(6),
                    border: today ? Border.all(color: AppColors.primary, width: 1.5) : null,
                  ),
                  alignment: Alignment.center,
                  child: done
                    ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                    : Text('${i + 1}',
                        style: TextStyle(
                          color: today ? Colors.white : AppColors.textHint,
                          fontSize: 12,
                          fontWeight: today ? FontWeight.bold : FontWeight.normal,
                        )),
                );
              }),
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _Exercise {
  final String name;
  final int duration, sets;
  final Color color;
  final IconData icon;
  const _Exercise({required this.name, required this.duration, required this.sets, required this.color, required this.icon});
}
