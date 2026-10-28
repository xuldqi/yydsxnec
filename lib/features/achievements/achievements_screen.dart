// 成就系统 (对应 Android AchievementsActivity + achievement_summary_card)
// 5 大类成就 + 总积分 + 解锁徽章

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'achievement_detail_screen.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/app_l10n_ext.dart';
import 'package:drift/drift.dart' hide Column;
import '../../core/services/database_provider.dart';

class Achievement {
  final String id, name, description, category;
  final IconData icon;
  final Color color;
  final bool unlocked;
  final double progress; // 0-1
  Achievement({required this.id, required this.name, required this.description, required this.category,
    required this.icon, required this.color, required this.unlocked, required this.progress});
}

class AchievementsState {
  final List<Achievement> achievements;
  final int totalPoints;
  AchievementsState({this.achievements = const [], this.totalPoints = 0});
}

class AchievementsNotifier extends AsyncNotifier<AchievementsState> {
  @override
  Future<AchievementsState> build() async {
    return _calculateAchievements();
  }

  Future<AchievementsState> _calculateAchievements() async {
    final db = ref.read(databaseProvider);
    
    // 1. 步数类数据
    int totalSteps = 0;
    int maxStepsOneDay = 0;
    try {
      final stepRes = await db.customSelect('SELECT SUM(steps) as s, MAX(steps) as m FROM step_counts').getSingleOrNull();
      totalSteps = stepRes?.read<int>('s') ?? 0;
      maxStepsOneDay = stepRes?.read<int>('m') ?? 0;
    } catch (_) {}

    // 2. 运动类数据
    int maxCalories = 0;
    int sportCount = 0;
    try {
      final sportRes = await db.customSelect('SELECT MAX(calories_burned) as mc, COUNT(*) as c FROM sport_records').getSingleOrNull();
      maxCalories = (sportRes?.read<double>('mc') ?? 0.0).toInt();
      sportCount = sportRes?.read<int>('c') ?? 0;
    } catch (_) {}

    // 3. 饮食记录天数
    int dietDays = 0;
    try {
      final dietRes = await db.customSelect('SELECT COUNT(DISTINCT date(time / 1000, "unixepoch")) as c FROM diet_records').getSingleOrNull();
      dietDays = dietRes?.read<int>('c') ?? 0;
    } catch (_) {}

    // 4. 计算进度
    return AchievementsState(
      achievements: [
        Achievement(id: 'a1', name: '初出茅庐', description: '完成首次步数记录', category: '步数',
          icon: Icons.directions_walk_rounded, color: AppColors.primary, unlocked: totalSteps > 0, progress: (totalSteps > 0 ? 1.0 : 0.0)),
        Achievement(id: 'a2', name: '日行千里', description: '单日步数达到 10,000 步', category: '步数',
          icon: Icons.directions_run_rounded, color: AppColors.sportRun, unlocked: maxStepsOneDay >= 10000, progress: (maxStepsOneDay / 10000).clamp(0.0, 1.0)),
        Achievement(id: 'a4', name: '万里长城', description: '累计步数达到 1,000,000 步', category: '步数',
          icon: Icons.castle_rounded, color: AppColors.sportOther, unlocked: totalSteps >= 1000000, progress: (totalSteps / 1000000).clamp(0.0, 1.0)),

        Achievement(id: 'a5', name: '运动新手', description: '完成首次运动记录', category: '运动',
          icon: Icons.sports_rounded, color: AppColors.sportOther, unlocked: sportCount > 0, progress: (sportCount > 0 ? 1.0 : 0.0)),
        Achievement(id: 'a6', name: '燃脂达人', description: '单次运动消耗 500 千卡', category: '运动',
          icon: Icons.whatshot_rounded, color: AppColors.warning, unlocked: maxCalories >= 500, progress: (maxCalories / 500.0).clamp(0.0, 1.0)),
        Achievement(id: 'a7', name: '全能运动员', description: '尝试过 5 种不同的运动类型', category: '运动',
          icon: Icons.emoji_events_rounded, color: AppColors.sportRun, unlocked: sportCount >= 5, progress: (sportCount / 5.0).clamp(0.0, 1.0)),

        Achievement(id: 'a11', name: '健康饮食', description: '记录 7 天饮食', category: '饮食',
          icon: Icons.restaurant_rounded, color: AppColors.sportOther, unlocked: dietDays >= 7, progress: (dietDays / 7.0).clamp(0.0, 1.0)),
      ],
      totalPoints: totalSteps ~/ 1000 + dietDays * 10, // dummy point calculation
    );
  }
}

final achievementsProvider = AsyncNotifierProvider<AchievementsNotifier, AchievementsState>(AchievementsNotifier.new);

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context).s;
    final stateAsync = ref.watch(achievementsProvider);
    final state = stateAsync.valueOrNull ?? AchievementsState();
    final unlocked = state.achievements.where((a) => a.unlocked).length;
    final categories = state.achievements.map((a) => a.category).toSet().toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l.achievements),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimens.spacingMd),
        children: [
          // 总览
          Container(
            padding: const EdgeInsets.all(AppDimens.spacingLg),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [AppColors.sportRun, AppColors.sportOther],
              ),
              borderRadius: BorderRadius.circular(AppDimens.radiusCard),
            ),
            child: Column(
              children: [
                const Text('🏆', style: TextStyle(fontSize: 36)),
                const SizedBox(height: 8),
                Text(l.totalPoints,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13)),
                const SizedBox(height: 4),
                Text('${state.totalPoints}',
                  style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _OverviewStat(value: '$unlocked', label: l.unlocked),
                    Container(width: 1, height: 32, color: Colors.white.withValues(alpha: 0.3)),
                    _OverviewStat(value: '${state.achievements.length}', label: l.total),
                    Container(width: 1, height: 32, color: Colors.white.withValues(alpha: 0.3)),
                    _OverviewStat(value: '${(unlocked * 100 / state.achievements.length).round()}%', label: l.complete),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimens.spacingMd),
          // 分类
          ...categories.map((cat) {
            final items = state.achievements.where((a) => a.category == cat).toList();
            return _CategorySection(category: cat, achievements: items);
          }),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _OverviewStat extends StatelessWidget {
  final String value, label;
  const _OverviewStat({required this.value, required this.label});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }
}

class _CategorySection extends StatelessWidget {
  final String category;
  final List<Achievement> achievements;
  const _CategorySection({required this.category, required this.achievements});
  @override
  Widget build(BuildContext context) {
    final unlocked = achievements.where((a) => a.unlocked).length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, top: 8, bottom: 10),
          child: Row(
            children: [
              Text(category, style: const TextStyle(color: AppColors.textPrimary, fontSize: 17, fontWeight: FontWeight.w700)),
              const Spacer(),
              Text('$unlocked / ${achievements.length}',
                style: const TextStyle(color: AppColors.textHint, fontSize: 12)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimens.radiusCard),
          ),
          child: GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 0.85,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: achievements.map((a) => _Badge(achievement: a)).toList(),
          ),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final Achievement achievement;
  const _Badge({required this.achievement});
  @override
  Widget build(BuildContext context) {
    final a = achievement;
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => AchievementDetailScreen(
          id: a.id, name: a.name, description: a.description, category: a.category,
          icon: a.icon, color: a.color, unlocked: a.unlocked, progress: a.progress,
        )));
      },
      borderRadius: BorderRadius.circular(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 52, height: 52,
                decoration: BoxDecoration(
                  color: a.unlocked ? a.color.withValues(alpha: 0.15) : AppColors.border,
                  shape: BoxShape.circle,
                ),
              ),
              Icon(a.icon,
                color: a.unlocked ? a.color : AppColors.textHint,
                size: 26,
              ),
              if (!a.unlocked) Positioned(
                bottom: 0, right: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.lock_rounded, size: 12, color: a.color),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(a.name,
            style: TextStyle(
              color: a.unlocked ? AppColors.textPrimary : AppColors.textHint,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
