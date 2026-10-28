import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/database/app_database.dart';
import '../../core/services/health_providers.dart';
import '../../core/services/database_provider.dart';
import 'vital_signs_screen.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';

class VitalDetailScreen extends ConsumerStatefulWidget {
  final String title;
  final String type; // blood_pressure, heart_rate, blood_sugar, blood_oxygen, body_temperature

  const VitalDetailScreen({
    super.key,
    required this.title,
    required this.type,
  });

  @override
  ConsumerState<VitalDetailScreen> createState() => _VitalDetailScreenState();
}

class _VitalDetailScreenState extends ConsumerState<VitalDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final asyncVitals = ref.watch(vitalSignsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
      ),
      body: asyncVitals.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (err, _) => Center(child: Text('加载失败: $err', style: const TextStyle(color: AppColors.textHint))),
        data: (allRecords) {
          final records = allRecords.where((r) => r.type == widget.type).toList();
          records.sort((a, b) => b.time.compareTo(a.time));

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
                    child: const Icon(Icons.monitor_heart_rounded, size: 40, color: AppColors.primary),
                  ),
                  const SizedBox(height: 16),
                  const Text('暂无历史记录', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  const Text('点击首页的卡片加号记录数据', style: TextStyle(fontSize: 13, color: AppColors.textHint)),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppDimens.spacingMd),
            itemCount: records.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final record = records[index];
              return Dismissible(
                key: ValueKey(record.id),
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
                      content: const Text('确定要删除这条体征记录吗？删除后无法恢复。'),
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
                  await db.deleteVitalRecord(record.id);
                  ref.invalidate(vitalSignsProvider);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('已删除该记录')),
                    );
                  }
                },
                child: _buildRecordCard(record),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildRecordCard(VitalRecord record) {
    String valueStr = '';
    String unitStr = '';

    switch (record.type) {
      case 'bp':
        valueStr = '${record.value1.toInt()}/${record.value2?.toInt() ?? 0}';
        unitStr = 'mmHg';
        break;
      case 'heart_rate':
        valueStr = record.value1.toInt().toString();
        unitStr = 'bpm';
        break;
      case 'glucose':
        valueStr = record.value1.toStringAsFixed(1);
        unitStr = 'mmol/L';
        break;
      case 'spo2':
        valueStr = record.value1.toInt().toString();
        unitStr = '%';
        break;
      case 'temp':
        valueStr = record.value1.toStringAsFixed(1);
        unitStr = '°C';
        break;
    }

    final timeStr = DateFormat('yyyy-MM-dd HH:mm').format(record.time);
    final status = _getStatus(record.type, record.value1, record.value2);
    final statusColor = status == '正常' ? AppColors.success : AppColors.warning;

    return Container(
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(valueStr, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(width: 4),
                  Text(unitStr, style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
                ],
              ),
              const SizedBox(height: 4),
              Text(timeStr, style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(status, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: statusColor)),
          ),
        ],
      ),
    );
  }

  String _getStatus(String type, double val1, double? val2) {
    if (type == 'bp') {
      if (val1 < 90 || val1 > 140 || (val2 ?? 0) < 60 || (val2 ?? 0) > 90) return '偏高/偏低';
      return '正常';
    } else if (type == 'heart_rate') {
      if (val1 < 60 || val1 > 100) return '异常';
      return '正常';
    } else if (type == 'glucose') {
      if (val1 < 3.9 || val1 > 6.1) return '异常';
      return '正常';
    } else if (type == 'spo2') {
      if (val1 < 95) return '偏低';
      return '正常';
    } else if (type == 'temp') {
      if (val1 < 36.0 || val1 > 37.3) return '发热/偏低';
      return '正常';
    }
    return '未知';
  }
}
