import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/database/app_database.dart';
import '../../core/services/database_provider.dart';
import '../../core/services/health_providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';

class WaterHistoryScreen extends ConsumerWidget {
  const WaterHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final waterState = ref.watch(waterProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('饮水历史记录', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
      ),
      body: waterState.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (err, _) => Center(child: Text('加载失败: $err')),
        data: (state) {
          final records = List<WaterRecord>.from(state.records);
          records.sort((a, b) => b.time.compareTo(a.time)); // 最新在前

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
                    child: const Icon(Icons.water_drop_rounded, size: 40, color: AppColors.primary),
                  ),
                  const SizedBox(height: 16),
                  const Text('今日暂无饮水记录', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  const Text('去喝杯水补充水分吧', style: TextStyle(fontSize: 13, color: AppColors.textHint)),
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
                      content: const Text('确定要删除这条饮水记录吗？'),
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
                  await db.deleteWaterRecord(r.id);
                  ref.invalidate(waterProvider); // 刷新数据
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('已删除该饮水记录')),
                    );
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppDimens.radiusCard),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.water_drop_rounded, color: AppColors.primary, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${r.amount} ml', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                            const SizedBox(height: 4),
                            Text(r.waterType, style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
                          ],
                        ),
                      ),
                      Text(
                        DateFormat('HH:mm').format(r.time),
                        style: const TextStyle(fontSize: 14, color: AppColors.textHint, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
