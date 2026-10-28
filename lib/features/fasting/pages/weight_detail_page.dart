import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:steps_webu_flutter/core/theme/app_colors.dart';
import '../providers/weight_provider.dart';
import '../models/weight_record.dart';
import '../utils/app_toast.dart';

class WeightDetailPage extends ConsumerWidget {
  const WeightDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordsAsync = ref.watch(weightRecordsProvider);
    final latestAsync = ref.watch(latestWeightRecordProvider);
    final targetAsync = ref.watch(targetWeightProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('体重记录'),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      backgroundColor: AppColors.background,
      body: recordsAsync.when(
        data: (records) {
          final latest = latestAsync.asData?.value;
          final targetRecord = targetAsync.asData?.value;
          final initial = records.isNotEmpty ? records.last : null;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGoalCard(context, ref, initial, latest, targetRecord),
                const SizedBox(height: 24.0),
                _buildSimpleTrendCard(context, records),
                const SizedBox(height: 24.0),
                _buildRecordsList(context, records),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('加载体重数据失败: $error')),
      ),
    );
  }

  Widget _buildGoalCard(
    BuildContext context,
    WidgetRef ref,
    WeightRecord? initial,
    WeightRecord? latest,
    WeightRecord? target,
  ) {
    final initialWeight = initial?.weight;
    final latestWeight = latest?.weight;
    final targetWeight = target?.weight;

    double? progress;
    double? diffToTarget;
    double? totalNeedLose;

    if (initialWeight != null && targetWeight != null && latestWeight != null) {
      totalNeedLose = (initialWeight - targetWeight);
      if (totalNeedLose <= 0) {
        progress = null;
      } else {
        final lost = (initialWeight - latestWeight);
        progress = (lost / totalNeedLose).clamp(0.0, 1.0);
        diffToTarget = (latestWeight - targetWeight);
      }
    }

    String statusText;
    if (progress == null ||
        totalNeedLose == null ||
        latestWeight == null ||
        targetWeight == null ||
        initialWeight == null) {
      statusText = '设置目标体重后，可以看到减重进度';
    } else if (diffToTarget != null && diffToTarget <= 0) {
      statusText = '太棒了！已达到或低于目标体重 🎉';
    } else {
      statusText =
          '截至目前您已减重 ${(initialWeight - latestWeight).toStringAsFixed(1)}kg';
    }

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '我的目标',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      _showTargetWeightDialog(context, ref, target),
                  child: const Text('编辑'),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            // 进度条
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(99.0),
              ),
              child: Stack(
                children: [
                  if (progress != null)
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final p = progress ?? 0.0;
                        final double width = constraints.maxWidth * p;
                        return Container(
                          width: width,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [AppColors.primary, AppColors.primaryDark]),
                            borderRadius: BorderRadius.circular(99.0),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8.0),
            if (diffToTarget != null && diffToTarget > 0)
              Text(
                '还差 ${diffToTarget.toStringAsFixed(1)}kg',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            const SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildGoalNumberItem(context, '初始(kg)', initialWeight),
                _buildGoalNumberItem(context, '当前(kg)', latestWeight),
                _buildGoalNumberItem(context, '目标(kg)', targetWeight),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                const Text('😊 '),
                Expanded(
                  child: Text(
                    statusText,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalNumberItem(
    BuildContext context,
    String label,
    double? value,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 4),
        Text(
          value != null ? value.toStringAsFixed(1) : '--',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  void _showTargetWeightDialog(
    BuildContext context,
    WidgetRef ref,
    WeightRecord? currentTarget,
  ) {
    final weightController = TextEditingController(
      text: currentTarget?.weight.toStringAsFixed(1) ?? '',
    );
    final notesController = TextEditingController(
      text: currentTarget?.notes ?? '',
    );

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.28),
      builder: (sheetContext) => Material(
        color: Colors.transparent,
        child: SafeArea(
          top: false,
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(32.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 38,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(99.0),
                    ),
                  ),
                  Text(
                    '编辑目标体重',
                    style: Theme.of(sheetContext).textTheme.titleLarge
                        ?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24.0),
                  TextField(
                    controller: weightController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: '目标体重',
                      hintText: 'kg',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: notesController,
                    maxLines: 2,
                    decoration: const InputDecoration(labelText: '备注（可选）'),
                  ),
                  const SizedBox(height: 24.0),
                  FilledButton(
                    onPressed: () async {
                      final weight = double.tryParse(
                        weightController.text.trim(),
                      );
                      if (weight == null || weight <= 0) {
                        showAppToast(
                          sheetContext,
                          '请输入有效目标体重',
                          type: AppToastType.error,
                        );
                        return;
                      }
                      Navigator.pop(sheetContext);
                      await ref
                          .read(weightRecordsProvider.notifier)
                          .setTargetWeight(
                            weight,
                            notes: notesController.text.trim().isEmpty
                                ? null
                                : notesController.text.trim(),
                          );
                      if (context.mounted) {
                        showAppToast(
                          context,
                          '目标体重已更新',
                          type: AppToastType.success,
                        );
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text('保存'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).then((_) {
      weightController.dispose();
      notesController.dispose();
    });
  }

  Widget _buildSimpleTrendCard(
    BuildContext context,
    List<WeightRecord> records,
  ) {
    if (records.isEmpty) {
      return Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: const Icon(
                  Icons.monitor_weight_rounded,
                  color: AppColors.primaryDark,
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Text(
                  '还没有体重记录，先在首页或记录页添加一条吧。',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // 为简化，这里先做成折线趋势的占位视图：仅用 Polyline + 底部日期标签
    final sorted = [...records]
      ..sort((a, b) => a.recordTime.compareTo(b.recordTime));

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '体重趋势（简版）',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              height: 160,
              child: CustomPaint(
                painter: _WeightTrendPainter(sorted),
                child: const SizedBox.expand(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordsList(BuildContext context, List<WeightRecord> records) {
    if (records.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '历史记录',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16.0),
            ...records.map((r) {
              final date =
                  '${r.recordTime.month.toString().padLeft(2, '0')}/${r.recordTime.day.toString().padLeft(2, '0')}';
              final time =
                  '${r.recordTime.hour.toString().padLeft(2, '0')}:${r.recordTime.minute.toString().padLeft(2, '0')}';
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  tileColor: AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  title: Text('${r.weight.toStringAsFixed(1)} kg'),
                  subtitle: Text('$date $time'),
                  trailing: r.isTarget
                      ? const Icon(
                          Icons.flag,
                          color: AppColors.primary,
                          size: 18,
                        )
                      : null,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _WeightTrendPainter extends CustomPainter {
  final List<WeightRecord> records;

  _WeightTrendPainter(this.records);

  @override
  void paint(Canvas canvas, Size size) {
    if (records.isEmpty) return;

    final weights = records.map((e) => e.weight).toList();
    final minW = weights.reduce((a, b) => a < b ? a : b);
    final maxW = weights.reduce((a, b) => a > b ? a : b);
    final range = (maxW - minW).abs() < 0.1 ? 1.0 : (maxW - minW);

    final paintLine = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final paintFill = Paint()
      ..shader = const LinearGradient(colors: [AppColors.primary, AppColors.primaryDark]).createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      )
      ..style = PaintingStyle.fill
      ..color = AppColors.primary.withValues(alpha: 0.15);

    final path = Path();
    final fillPath = Path();

    for (int i = 0; i < records.length; i++) {
      final x =
          size.width * (i / (records.length - 1).clamp(1, double.infinity));
      final yRatio = (records[i].weight - minW) / range;
      final y = size.height - yRatio * (size.height - 20);

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, paintFill);
    canvas.drawPath(path, paintLine);
  }

  @override
  bool shouldRepaint(covariant _WeightTrendPainter oldDelegate) {
    return oldDelegate.records != records;
  }
}
