// 生命体征 (对应 Android VitalSignsActivity + HealthRecordsActivity)
// 心率/血压/血糖/血氧/体温 - 5 类指标手动添加 + 历史趋势

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/app_l10n_ext.dart';

import 'package:drift/drift.dart' as drift;
import '../../core/database/app_database.dart';
import '../../core/services/database_provider.dart';

class VitalSignsNotifier extends AsyncNotifier<List<VitalRecord>> {
  @override
  Future<List<VitalRecord>> build() async {
    final db = ref.read(databaseProvider);
    // Fetch all vital records, ordered by time desc
    return (db.select(db.vitalRecords)..orderBy([(t) => drift.OrderingTerm(expression: t.time, mode: drift.OrderingMode.desc)])).get();
  }

  Future<void> add(String type, double v1, double? v2) async {
    final db = ref.read(databaseProvider);
    await db.insertVitalRecord(VitalRecordsCompanion.insert(
      type: type,
      value1: v1,
      value2: drift.Value(v2),
      time: DateTime.now(),
    ));
    ref.invalidateSelf();
  }

  Future<void> remove(int id) async {
    final db = ref.read(databaseProvider);
    await db.deleteVitalRecord(id);
    ref.invalidateSelf();
  }
}

final vitalSignsProvider = AsyncNotifierProvider<VitalSignsNotifier, List<VitalRecord>>(VitalSignsNotifier.new);

class VitalSignsScreen extends ConsumerStatefulWidget {
  const VitalSignsScreen({super.key});
  @override
  ConsumerState<VitalSignsScreen> createState() => _VitalSignsScreenState();
}

class _VitalSignsScreenState extends ConsumerState<VitalSignsScreen> {
  @override
  void initState() {
    super.initState();
  }

  void _addHeart() => _showDialog('heart_rate', '心率', 'bpm', color: AppColors.error, icon: Icons.favorite_rounded);
  void _addBP() => _showDoubleDialog('bp', '血压', ('收缩压', '舒张压'), 'mmHg', color: AppColors.error, icon: Icons.monitor_heart_rounded);
  void _addGlucose() => _showDialog('glucose', '血糖', 'mmol/L', color: AppColors.warning, icon: Icons.water_drop_rounded, min: 1, max: 30, decimals: 1);
  void _addSpO2() => _showDialog('spo2', '血氧', '%', color: AppColors.sportOther, icon: Icons.air_rounded, min: 70, max: 100);
  void _addTemp() => _showDialog('temp', '体温', '°C', color: AppColors.info, icon: Icons.thermostat_rounded, min: 34, max: 42, decimals: 1);

  void _showDialog(String type, String title, String unit, {required Color color, required IconData icon, double min = 30, double max = 200, int decimals = 0}) {
    final ctrl = TextEditingController();
    showDialog(context: context, builder: (_) => AlertDialog(
      backgroundColor: AppColors.surface,
      title: Row(children: [Icon(icon, color: color), const SizedBox(width: 8), Text(title)]),
      content: TextField(
        controller: ctrl, autofocus: true,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          suffixText: unit,
          hintText: '请输入数值',
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
        ElevatedButton(
          onPressed: () {
            final v = double.tryParse(ctrl.text);
            if (v != null && v >= min && v <= max) {
              ref.read(vitalSignsProvider.notifier).add(type, v, null);
              Navigator.pop(context);
            }
          },
          child: const Text('保存'),
        ),
      ],
    ));
  }

  void _showDoubleDialog(String type, String title, (String, String) labels, String unit, {required Color color, required IconData icon}) {
    final c1 = TextEditingController();
    final c2 = TextEditingController();
    showDialog(context: context, builder: (_) => AlertDialog(
      backgroundColor: AppColors.surface,
      title: Row(children: [Icon(icon, color: color), const SizedBox(width: 8), Text(title)]),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: c1, autofocus: true, keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: labels.$1, suffixText: unit)),
          const SizedBox(height: 10),
          TextField(controller: c2, keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: labels.$2, suffixText: unit)),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
        ElevatedButton(
          onPressed: () {
            final v1 = double.tryParse(c1.text);
            final v2 = double.tryParse(c2.text);
            if (v1 != null && v2 != null && v1 > 0 && v2 > 0) {
              ref.read(vitalSignsProvider.notifier).add(type, v1, v2);
              Navigator.pop(context);
            }
          },
          child: const Text('保存'),
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context).s;
    final state = ref.watch(vitalSignsProvider);
    final allRecords = state.valueOrNull ?? [];
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l.vitalSigns),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimens.spacingMd),
        children: [
          // 5 个指标卡
          _VitalCard(
            title: l.heart, type: 'heart_rate', color: AppColors.error, icon: Icons.favorite_rounded,
            records: allRecords.where((r) => r.type == 'heart_rate').toList(),
            unit: 'bpm', formatter: (r) => r.value1.toInt().toString(),
            statusOf: (v) => v < 60 ? '偏低' : (v > 100 ? '偏高' : '正常'),
            onAdd: _addHeart,
          ),
          _VitalCard(
            title: l.bp, type: 'bp', color: AppColors.error, icon: Icons.monitor_heart_rounded,
            records: allRecords.where((r) => r.type == 'bp').toList(),
            unit: 'mmHg',
            formatter: (r) => '${r.value1.toInt()}/${r.value2?.toInt() ?? 0}',
            statusOf: (v) => v > 140 ? '偏高' : (v < 90 ? '偏低' : '正常'),
            onAdd: _addBP,
          ),
          _VitalCard(
            title: l.bg, type: 'glucose', color: AppColors.warning, icon: Icons.water_drop_rounded,
            records: allRecords.where((r) => r.type == 'glucose').toList(),
            unit: 'mmol/L',
            formatter: (r) => r.value1.toStringAsFixed(1),
            statusOf: (v) => v < 3.9 ? '偏低' : (v > 6.1 ? '偏高' : '正常'),
            onAdd: _addGlucose,
          ),
          _VitalCard(
            title: l.spo2, type: 'spo2', color: AppColors.sportOther, icon: Icons.air_rounded,
            records: allRecords.where((r) => r.type == 'spo2').toList(),
            unit: '%',
            formatter: (r) => r.value1.toInt().toString(),
            statusOf: (v) => v < 95 ? '偏低' : '正常',
            onAdd: _addSpO2,
          ),
          _VitalCard(
            title: l.temp, type: 'temp', color: AppColors.info, icon: Icons.thermostat_rounded,
            records: allRecords.where((r) => r.type == 'temp').toList(),
            unit: '°C',
            formatter: (r) => r.value1.toStringAsFixed(1),
            statusOf: (v) => v < 36 ? '偏低' : (v > 37.3 ? '偏高' : '正常'),
            onAdd: _addTemp,
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _VitalCard extends StatelessWidget {
  final String title;
  final String type; // The DB type string
  final Color color;
  final IconData icon;
  final List<VitalRecord> records;
  final String unit;
  final String Function(VitalRecord) formatter;
  final String Function(double) statusOf;
  final VoidCallback onAdd;

  const _VitalCard({
    required this.title,
    required this.type,
    required this.color,
    required this.icon,
    required this.records,
    required this.unit,
    required this.formatter,
    required this.statusOf,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final latest = records.isEmpty ? null : records.first;
    final status = latest == null ? '未记录' : statusOf(latest.value1);
    final statusColor = status == '正常' ? AppColors.success : (status == '未记录' ? AppColors.textHint : AppColors.warning);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
      ),
      child: InkWell(
        onTap: () {
          context.push('/vital-detail?type=$type&title=${Uri.encodeComponent(title)}');
        },
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.spacingSm),
          child: Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(status, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
              if (latest != null) Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(formatter(latest),
                    style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.bold)),
                  Text(unit, style: const TextStyle(color: AppColors.textHint, fontSize: 11)),
                ],
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.add_circle_rounded, color: AppColors.primary),
                onPressed: onAdd,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
