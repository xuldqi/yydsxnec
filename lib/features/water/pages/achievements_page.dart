import 'package:flutter/material.dart';
import '../models/achievement.dart';
import '../services/achievement_service.dart';
import '../services/session_service.dart';
import '../services/database_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../utils/navigation_helper.dart';

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({super.key});

  @override
  State<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  final AchievementService _achievementService = AchievementService();
  List<Achievement> _achievements = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAndScanAchievements();
  }

  // 加载并重新计算最新成就状态
  Future<void> _loadAndScanAchievements() async {
    try {
      final userId = await SessionService.getCurrentUserId() ?? 'guest';

      // 扫描并计算最新的成就状态
      await _achievementService.checkAndUnlockAchievements(userId);

      // 从数据库加载
      final list = await DatabaseService().getAchievements(userId);

      if (!mounted) return;
      setState(() {
        _achievements = list;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('勋章墙'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => goBackOr(context, '/profile'),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildAchievementsGrid(),
    );
  }

  Widget _buildAchievementsGrid() {
    final filtered = List<Achievement>.from(_achievements);

    filtered.sort((a, b) {
      if (a.completed != b.completed) return a.completed ? -1 : 1;
      final aProgress = a.target > 0 ? a.current / a.target : 0;
      final bProgress = b.target > 0 ? b.current / b.target : 0;
      return bProgress.compareTo(aProgress);
    });

    if (filtered.isEmpty) {
      return _buildEmptyState();
    }

    // 统计已完成勋章数量
    final completedCount = filtered.where((a) => a.completed).length;
    final progress = filtered.isEmpty ? 0.0 : completedCount / filtered.length;

    return SafeArea(
      top: false,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(18, 16, 18, 14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFF4E2D7)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.04),
                    blurRadius: 16,
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
                        const Text(
                          '勋章解锁进度',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '已解锁 $completedCount / ${filtered.length} 枚',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 8,
                            backgroundColor: const Color(0xFFF6E7DD),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 18),
                  SizedBox(
                    width: 58,
                    height: 58,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 5,
                          backgroundColor: const Color(0xFFF6E7DD),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                        ),
                        Text(
                          '${(progress * 100).round()}%',
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
            sliver: SliverLayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.crossAxisExtent >= 720
                    ? 3
                    : 2;
                return SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: crossAxisCount == 2 ? 1.08 : 1.18,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final achievement = filtered[index];
                    return _buildAchievementCard(achievement);
                  }, childCount: filtered.length),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withValues(alpha: 0.55),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.emoji_events_outlined,
                color: AppColors.primary,
                size: 34,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              '暂无相关勋章',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              '记录喝水、坚持打卡或达成每日喝水目标后，这里会展示新的勋章。',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementCard(Achievement achievement) {
    final progressRatio = achievement.target > 0
        ? (achievement.current / achievement.target).clamp(0.0, 1.0)
        : 0.0;
    final isCompleted = achievement.completed;
    final accent = _categoryColor(achievement.category);
    final borderColor = isCompleted
        ? AppColors.primary.withValues(alpha: 0.35)
        : const Color(0xFFEFE4DC);
    final iconBg = isCompleted
        ? AppColors.primaryLight.withValues(alpha: 0.65)
        : const Color(0xFFF3F0ED);

    return Card(
      color: isCompleted ? Colors.white : const Color(0xFFFFFEFC),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: borderColor, width: isCompleted ? 1.4 : 1),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 8,
            right: 8,
            child: Tooltip(
              message: _achievementTooltip(achievement),
              child: Icon(
                isCompleted
                    ? Icons.check_circle_rounded
                    : Icons.info_outline_rounded,
                size: 15,
                color: isCompleted
                    ? const Color(0xFF4FCB91)
                    : AppColors.textHint,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 9),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Opacity(
                  opacity: isCompleted ? 1.0 : 0.52,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: iconBg,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCompleted
                            ? AppColors.primary.withValues(alpha: 0.2)
                            : Colors.white,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      achievement.icon,
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  achievement.name,
                  style: TextStyle(
                    color: isCompleted
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.w900,
                    fontSize: 13.5,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  achievement.description,
                  style: TextStyle(
                    color: isCompleted
                        ? AppColors.textSecondary
                        : AppColors.textHint,
                    fontSize: 11,
                    height: 1.05,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 7),
                if (isCompleted)
                  _buildCompletedBadge(achievement)
                else
                  _buildProgressBlock(
                    achievement.current,
                    achievement.target,
                    progressRatio,
                    accent,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedBadge(Achievement achievement) {
    final date = achievement.completedAt;
    final dateText = date == null
        ? '已解锁'
        : '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';

    return Container(
      height: 22,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFEAFBF4),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_rounded, color: Color(0xFF4FCB91), size: 13),
          const SizedBox(width: 3),
          Flexible(
            child: Text(
              dateText,
              style: const TextStyle(
                color: Color(0xFF35A875),
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBlock(
    int current,
    int target,
    double progressRatio,
    Color color,
  ) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: progressRatio,
            backgroundColor: const Color(0xFFF0E8E2),
            color: color,
            minHeight: 4,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$current/$target',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  String _achievementTooltip(Achievement achievement) {
    final date = achievement.completedAt;
    if (!achievement.completed || date == null) {
      return achievement.description;
    }
    return '解锁于 ${date.year}-${date.month}-${date.day}';
  }

  Color _categoryColor(AchievementCategory category) {
    switch (category) {
      case AchievementCategory.record:
        return AppColors.primary;
      case AchievementCategory.streak:
        return const Color(0xFFFFA83D);
      case AchievementCategory.explore:
        return const Color(0xFF6BA8FF);
      case AchievementCategory.goal:
        return const Color(0xFF4FCB91);
    }
  }
}
