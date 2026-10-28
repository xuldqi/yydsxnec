import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/exercise_provider.dart';
import '../providers/fasting_provider.dart';
import '../providers/food_record_provider.dart';
import '../providers/water_provider.dart';
import '../providers/week_plan_provider.dart';
import '../providers/weight_provider.dart';
import '../services/data_export_service.dart';
import 'package:steps_webu_flutter/core/theme/app_colors.dart';

class DataManagementPage extends ConsumerStatefulWidget {
  const DataManagementPage({super.key});

  @override
  ConsumerState<DataManagementPage> createState() => _DataManagementPageState();
}

class _DataManagementPageState extends ConsumerState<DataManagementPage> {
  bool _isBusy = false;

  DataExportService get _service {
    return DataExportService(
      fastingRepository: ref.read(fastingRepositoryProvider),
      waterRepository: ref.read(waterRepositoryProvider),
      weightRepository: ref.read(weightRepositoryProvider),
      exerciseRepository: ref.read(exerciseRepositoryProvider),
      foodRecordRepository: ref.read(foodRecordRepositoryProvider),
      weekPlanRepository: ref.read(weekPlanRepositoryProvider),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('数据管理')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          32.0,
          24.0,
          32.0,
          40.0,
        ),
        children: [
          _buildSummaryCard(),
          const SizedBox(height: 24.0),
          _buildActionTile(
            icon: Icons.content_copy_rounded,
            title: '复制备份 JSON',
            subtitle: '包含断食、饮水、体重、运动、饮食和周计划数据',
            onTap: _copyBackupJson,
          ),
          _buildActionTile(
            icon: Icons.table_chart_rounded,
            title: '复制 CSV 报表',
            subtitle: '适合粘贴到表格工具中查看',
            onTap: _copyCsvReport,
          ),
          _buildActionTile(
            icon: Icons.restore_rounded,
            title: '从 JSON 恢复',
            subtitle: '会先清空当前健康记录，再写入备份内容',
            onTap: _showRestoreDialog,
          ),
          const SizedBox(height: 8),
          _buildDangerTile(),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    final sessions = ref.watch(fastingSessionsProvider).valueOrNull ?? const [];
    final water = ref.watch(waterRecordsProvider).valueOrNull ?? const [];
    final weight = ref.watch(weightRecordsProvider).valueOrNull ?? const [];
    final exercise = ref.watch(exerciseRecordsProvider).valueOrNull ?? const [];
    final food = ref.watch(foodRecordsProvider).valueOrNull ?? const [];
    final weekPlans = ref.watch(weekPlansProvider).valueOrNull ?? const [];
    final total =
        sessions.length +
        water.length +
        weight.length +
        exercise.length +
        food.length +
        weekPlans.length;

    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(color: AppColors.divider),
        boxShadow: [BoxShadow(color: Color(0x1A000000), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '本地数据',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            '共 $total 条记录。数据默认保存在本机，复制备份后请妥善保管。',
            style: const TextStyle(
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 24.0),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              _countChip('断食', sessions.length),
              _countChip('饮水', water.length),
              _countChip('体重', weight.length),
              _countChip('运动', exercise.length),
              _countChip('饮食', food.length),
              _countChip('周计划', weekPlans.length),
            ],
          ),
        ],
      ),
    );
  }

  Widget _countChip(String label, int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(99.0),
      ),
      child: Text(
        '$label $count',
        style: const TextStyle(
          color: AppColors.primaryDark,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24.0),
        child: InkWell(
          onTap: _isBusy ? null : onTap,
          borderRadius: BorderRadius.circular(24.0),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Icon(icon, color: AppColors.primary),
                const SizedBox(width: 24.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDangerTile() {
    return Material(
      color: AppColors.error.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(24.0),
      child: InkWell(
        onTap: _isBusy ? null : _confirmClearAll,
        borderRadius: BorderRadius.circular(24.0),
        child: const Padding(
          padding: EdgeInsets.all(24.0),
          child: Row(
            children: [
              Icon(Icons.delete_forever_rounded, color: AppColors.error),
              SizedBox(width: 24.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '清空健康记录',
                      style: TextStyle(
                        color: AppColors.error,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      '建议先复制备份 JSON。清空后无法在本机直接撤销。',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _copyBackupJson() async {
    await _runBusyAction(() async {
      final json = await _service.createBackupJson();
      await Clipboard.setData(ClipboardData(text: json));
      _showMessage('备份 JSON 已复制');
    });
  }

  Future<void> _copyCsvReport() async {
    await _runBusyAction(() async {
      final csv = await _service.createCsvReport();
      await Clipboard.setData(ClipboardData(text: csv));
      _showMessage('CSV 报表已复制');
    });
  }

  Future<void> _showRestoreDialog() async {
    final controller = TextEditingController();
    final rawJson = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('从 JSON 恢复'),
        content: TextField(
          controller: controller,
          minLines: 6,
          maxLines: 10,
          decoration: const InputDecoration(
            hintText: '粘贴通过“复制备份 JSON”得到的内容',
            alignLabelWithHint: true,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('恢复'),
          ),
        ],
      ),
    );
    controller.dispose();

    if (rawJson == null || rawJson.trim().isEmpty) return;
    await _runBusyAction(() async {
      final result = await _service.restoreFromJson(rawJson.trim());
      await _reloadProviders();
      _showMessage('已恢复 ${result.totalCount} 条记录');
    });
  }

  Future<void> _confirmClearAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清空健康记录？'),
        content: const Text('这会删除断食、饮水、体重、运动、饮食和周计划记录。建议先复制备份 JSON。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('清空'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    await _runBusyAction(() async {
      await _service.restoreFromJson('{"data":{}}');
      await _reloadProviders();
      _showMessage('健康记录已清空');
    });
  }

  Future<void> _runBusyAction(Future<void> Function() action) async {
    if (_isBusy) return;
    setState(() => _isBusy = true);
    try {
      await action();
    } catch (error) {
      _showMessage('操作失败：$error');
    } finally {
      if (mounted) {
        setState(() => _isBusy = false);
      }
    }
  }

  Future<void> _reloadProviders() async {
    await Future.wait([
      ref.read(fastingPlansProvider.notifier).loadPlans(),
      ref.read(fastingSessionsProvider.notifier).loadSessions(),
      ref.read(waterRecordsProvider.notifier).loadRecords(),
      ref.read(weightRecordsProvider.notifier).loadRecords(),
      ref.read(exerciseRecordsProvider.notifier).loadRecords(),
      ref.read(foodRecordsProvider.notifier).loadRecords(),
      ref.read(weekPlansProvider.notifier).loadPlans(),
    ]);
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
