import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/database/app_database.dart';
import '../../core/services/database_provider.dart';
import '../../core/services/health_providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';

class TraceHistoryScreen extends ConsumerWidget {
  const TraceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sportAsync = ref.watch(sportProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('运动历史记录', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
      ),
      body: sportAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (err, _) => Center(child: Text('加载失败: $err', style: const TextStyle(color: AppColors.textHint))),
        data: (records) {
          if (records.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.history_toggle_off_rounded, size: 40, color: AppColors.primary),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '暂无运动历史记录',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '完成你的第一次运动，记录会显示在这里',
                    style: TextStyle(fontSize: 13, color: AppColors.textHint),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                    ),
                    child: const Text('去运动', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppDimens.spacingMd),
            itemCount: records.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (ctx, idx) {
              final r = records[idx];
              return Dismissible(
                key: ValueKey(r.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: AppColors.warning,
                    borderRadius: BorderRadius.circular(AppDimens.radiusCard),
                  ),
                  child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
                ),
                confirmDismiss: (direction) async {
                  return await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('删除记录'),
                      content: const Text('确定要删除这条运动记录吗？'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('取消', style: TextStyle(color: AppColors.textHint)),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text('删除', style: TextStyle(color: AppColors.warning)),
                        ),
                      ],
                    ),
                  ) ?? false;
                },
                onDismissed: (direction) async {
                  final db = ref.read(databaseProvider);
                  await db.deleteExerciseRecord(r.id);
                  ref.invalidate(sportProvider);
                  if (ctx.mounted) {
                    ScaffoldMessenger.of(ctx).showSnackBar(
                      const SnackBar(content: Text('已删除该运动记录')),
                    );
                  }
                },
                child: _buildRecordCard(context, r),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildRecordCard(BuildContext context, ExerciseRecord record) {
    final typeStr = record.exerciseType ?? '跑步';
    IconData icon;
    Color iconColor = AppColors.primary;

    switch (typeStr) {
      case '步行':
      case 'walking':
        icon = Icons.directions_walk_rounded;
        iconColor = const Color(0xFF0CC291);
        break;
      case '骑行':
      case 'cycling':
        icon = Icons.directions_bike_rounded;
        iconColor = const Color(0xFFF59E0B);
        break;
      case '健身':
      case 'gym':
        icon = Icons.fitness_center_rounded;
        iconColor = const Color(0xFFEA580C);
        break;
      case '游泳':
      case 'swimming':
        icon = Icons.pool_rounded;
        iconColor = const Color(0xFF14B8A6);
        break;
      case '瑜伽':
      case 'yoga':
        icon = Icons.self_improvement_rounded;
        iconColor = const Color(0xFF0F766E);
        break;
      case '篮球':
      case 'basketball':
        icon = Icons.sports_basketball_rounded;
        iconColor = const Color(0xFFF97316);
        break;
      default:
        icon = Icons.directions_run_rounded;
        iconColor = const Color(0xFF059669);
    }

    final durationSec = record.duration ?? 0;
    final mins = durationSec ~/ 60;
    final secs = durationSec % 60;
    final durationStr = mins > 0 ? '$mins分$secs秒' : '$secs秒';
    final distStr = (record.distance ?? 0.0) > 0 ? '${(record.distance ?? 0.0).toStringAsFixed(2)} km' : '-- km';
    final cal = record.caloriesBurned ?? ((record.distance ?? 0.0) * 60).round();
    final timeStr = DateFormat('yyyy-MM-dd HH:mm').format(record.startTime);

    return InkWell(
      onTap: () {
        context.push('/sport-session-detail', extra: record);
      },
      borderRadius: BorderRadius.circular(AppDimens.radiusCard),
      child: Container(
        padding: const EdgeInsets.all(AppDimens.spacingMd),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimens.radiusCard),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        typeStr,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        timeStr,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textHint),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('运动距离', distStr),
                _buildStatItem('运动时长', durationStr),
                _buildStatItem('消耗热量', '$cal kcal'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String val) {
    return Column(
      children: [
        Text(
          val,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textHint,
          ),
        ),
      ],
    );
  }
}
