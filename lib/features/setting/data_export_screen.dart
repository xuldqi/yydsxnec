import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/services/database_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';

class DataExportScreen extends ConsumerStatefulWidget {
  const DataExportScreen({super.key});

  @override
  ConsumerState<DataExportScreen> createState() => _DataExportScreenState();
}

class _DataExportScreenState extends ConsumerState<DataExportScreen> {
  bool _exporting = false;

  Future<void> _exportData(String type) async {
    setState(() => _exporting = true);
    try {
      final db = ref.read(databaseProvider);
      final sb = StringBuffer();
      
      if (type == 'steps') {
        sb.writeln('Date,Steps,ActiveMinutes,Calories');
        final records = await db.getStepCountsLastDays(365);
        for (final r in records) {
          final date = DateFormat('yyyy-MM-dd').format(r.startTime);
          sb.writeln('$date,${r.stepsNum},${r.useTime},${r.cal ?? 0.0}');
        }
      } else if (type == 'weight') {
        sb.writeln('Date,Weight,Fat,Muscle');
        final records = await db.getWeightRecordsLastDays(365);
        for (final r in records) {
          final date = DateFormat('yyyy-MM-dd').format(r.recordDatetime);
          sb.writeln('$date,${r.weight},${r.bodyFatPercentage ?? ''},${r.muscleMass ?? ''}');
        }
      } else if (type == 'sleep') {
        sb.writeln('StartTime,EndTime,Quality');
        final records = await db.getSleepRecordsLastDays(365);
        for (final r in records) {
          final start = DateFormat('yyyy-MM-dd HH:mm:ss').format(r.sleepTime);
          final end = DateFormat('yyyy-MM-dd HH:mm:ss').format(r.wakeTime);
          sb.writeln('$start,$end,${r.quality}');
        }
      } else if (type == 'fasting') {
        sb.writeln('StartTime,EndTime,TargetHours,Status');
        final records = await db.getFastingRecords();
        for (final r in records) {
          final start = DateFormat('yyyy-MM-dd HH:mm:ss').format(r.startTime);
          final end = r.endTime != null ? DateFormat('yyyy-MM-dd HH:mm:ss').format(r.endTime!) : '';
          sb.writeln('$start,$end,${r.targetHours},${r.status}');
        }
      }

      await Clipboard.setData(ClipboardData(text: sb.toString()));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('已生成 CSV 并复制到剪贴板！', style: TextStyle(color: Colors.white)), backgroundColor: AppColors.success),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('导出失败: $e', style: const TextStyle(color: Colors.white)), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('导出数据'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimens.spacingMd),
        children: [
          const Text('你可以将健康数据导出为 CSV 文本并复制到剪贴板，随后粘贴到备忘录或 Excel 中查看。默认导出过去一年的数据。',
            style: TextStyle(color: AppColors.textHint, fontSize: 14)),
          const SizedBox(height: 24),
          _buildItem('步数与活动', 'steps', Icons.directions_walk_rounded, AppColors.primary),
          _buildItem('体重记录', 'weight', Icons.monitor_weight_rounded, Colors.blueAccent),
          _buildItem('睡眠数据', 'sleep', Icons.bedtime_rounded, AppColors.sportOther),
          _buildItem('断食记录', 'fasting', Icons.timelapse_rounded, AppColors.sportOther),
        ],
      ),
    );
  }

  Widget _buildItem(String title, String type, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
      ),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: const TextStyle(color: AppColors.textPrimary)),
        trailing: _exporting 
            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
            : const Icon(Icons.file_copy_rounded, color: AppColors.textHint, size: 20),
        onTap: _exporting ? null : () => _exportData(type),
      ),
    );
  }
}
