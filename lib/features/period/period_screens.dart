// Period 子页 (Record/Calendar/History/Trends/Prediction/Reminder)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import 'period_provider.dart';

// 记录页 (PeriodRecordActivity)
class PeriodRecordScreen extends ConsumerStatefulWidget {
  const PeriodRecordScreen({super.key});
  @override
  ConsumerState<PeriodRecordScreen> createState() => _PeriodRecordScreenState();
}

class _PeriodRecordScreenState extends ConsumerState<PeriodRecordScreen> {
  DateTime _date = DateTime.now();
  int _days = 5;
  final _symptoms = <String>{};
  final _noteCtrl = TextEditingController();
  final _allSymptoms = ['腹痛', '腰痛', '头痛', '疲劳', '情绪波动', '食欲变化', '失眠', '乳房胀痛'];

  @override
  void dispose() { _noteCtrl.dispose(); super.dispose(); }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context, initialDate: _date, firstDate: DateTime(2020), lastDate: DateTime.now(),
    );
    if (d != null) setState(() => _date = d);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('记录经期'), actions: [TextButton(onPressed: _save, child: const Text('保存'))]),
      body: ListView(padding: const EdgeInsets.all(AppDimens.spacingMd), children: [
        ListTile(
          title: const Text('开始日期'),
          subtitle: Text(_fmt(_date)),
          trailing: const Icon(Icons.calendar_today),
          onTap: _pickDate,
        ),
        const Divider(height: 1),
        ListTile(
          title: const Text('持续天数'), subtitle: Text('$_days 天'),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(icon: const Icon(Icons.remove), onPressed: _days > 1 ? () => setState(() => _days--) : null),
            Text('$_days', style: const TextStyle(fontSize: 16)),
            IconButton(icon: const Icon(Icons.add), onPressed: _days < 10 ? () => setState(() => _days++) : null),
          ]),
        ),
        const Divider(height: 1),
        const SizedBox(height: 16),
        const Text('症状', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 8, children: _allSymptoms.map((t) => FilterChip(
          label: Text(t), selected: _symptoms.contains(t),
          onSelected: (v) => setState(() => v ? _symptoms.add(t) : _symptoms.remove(t)),
        )).toList()),
        const SizedBox(height: 16),
        const Text('备注', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(controller: _noteCtrl, maxLines: 3, decoration: InputDecoration(
          hintText: '记录身体感受...', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        )),
        const SizedBox(height: 24),
        FilledButton(
          style: FilledButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
          onPressed: _save, child: const Text('保存'),
        ),
      ]),
    );
  }

  void _save() {
    ref.read(periodProvider.notifier).addPeriod(
      _date, durationDays: _days, symptoms: _symptoms.toList(),
      note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
    );
    context.pop();
  }

  String _fmt(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}

// 日历 (PeriodCalendarActivity)
class PeriodCalendarScreen extends ConsumerWidget {
  const PeriodCalendarScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(periodProvider).valueOrNull ?? const PeriodState();
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    return Scaffold(
      appBar: AppBar(title: const Text('经期日历')),
      body: GridView.builder(
        padding: const EdgeInsets.all(AppDimens.spacingMd),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, mainAxisSpacing: 4, crossAxisSpacing: 4),
        itemCount: daysInMonth,
        itemBuilder: (c, i) {
          final d = DateTime(now.year, now.month, i + 1);
          final isPeriod = state.records.any((r) =>
            d.difference(r.startDate).inDays >= 0 &&
            d.difference(r.startDate).inDays < r.durationDays);
          return Container(
            decoration: BoxDecoration(
              color: isPeriod ? Color(0xFFE85D9C).withValues(alpha: 0.2) : AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: isPeriod ? Border.all(color: Color(0xFFE85D9C), width: 1.5) : null,
            ),
            child: Center(child: Text('${i + 1}', style: TextStyle(
              color: isPeriod ? Color(0xFFE85D9C) : AppColors.textPrimary,
              fontWeight: isPeriod ? FontWeight.bold : FontWeight.normal,
            ))),
          );
        },
      ),
    );
  }
}

// 历史 (PeriodHistoryActivity)
class PeriodHistoryScreen extends ConsumerWidget {
  const PeriodHistoryScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(periodProvider).valueOrNull?.records ?? [];
    return Scaffold(
      appBar: AppBar(title: const Text('经期历史')),
      body: records.isEmpty
        ? const Center(child: Text('暂无记录', style: TextStyle(color: AppColors.textHint)))
        : ListView.separated(
            padding: const EdgeInsets.all(AppDimens.spacingMd),
            itemCount: records.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (c, i) {
              final r = records[i];
              return Container(
                padding: const EdgeInsets.all(AppDimens.spacingMd),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
                child: Row(children: [
                  Container(width: 48, height: 48, decoration: BoxDecoration(
                    color: Color(0xFFE85D9C).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12),
                  ), child: const Icon(Icons.bloodtype_rounded, color: Color(0xFFE85D9C))),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('${r.startDate.year}-${r.startDate.month.toString().padLeft(2, '0')}-${r.startDate.day.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('持续 ${r.durationDays} 天', style: const TextStyle(color: AppColors.textHint, fontSize: 12)),
                    if (r.symptoms.isNotEmpty) Text(r.symptoms.join(' · '), style: const TextStyle(color: AppColors.textHint, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ])),
                  IconButton(icon: const Icon(Icons.delete_outline_rounded, color: AppColors.textHint),
                    onPressed: () => ref.read(periodProvider.notifier).removePeriod(r.id)),
                ]),
              );
            },
          ),
    );
  }
}

// 趋势 (PeriodTrendsActivity)
class PeriodTrendsScreen extends StatelessWidget {
  const PeriodTrendsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('经期趋势')),
      body: ListView(padding: const EdgeInsets.all(AppDimens.spacingMd), children: [
        Container(padding: const EdgeInsets.all(AppDimens.spacingMd),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
          child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('统计分析', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Row(children: [
              _Stat(label: '平均周期', value: '28 天'),
              _Stat(label: '平均经期', value: '5 天'),
              _Stat(label: '记录次数', value: '12'),
            ]),
          ])),
        const SizedBox(height: 16),
        Container(padding: const EdgeInsets.all(AppDimens.spacingMd),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
          child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('常见症状', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Wrap(spacing: 8, runSpacing: 8, children: [
              Chip(label: Text('腹痛 8次')), Chip(label: Text('疲劳 6次')),
              Chip(label: Text('情绪波动 5次')), Chip(label: Text('腰痛 4次')),
            ]),
          ])),
      ]),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  const _Stat({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Expanded(child: Column(children: [
      Text(label, style: const TextStyle(color: AppColors.textHint, fontSize: 12)),
      const SizedBox(height: 4),
      Text(value, style: const TextStyle(fontSize: 24, color: Color(0xFFE85D9C), fontWeight: FontWeight.bold)),
    ]));
  }
}

// 预测 (PeriodPredictionActivity)
class PeriodPredictionScreen extends ConsumerWidget {
  const PeriodPredictionScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(periodProvider).valueOrNull ?? const PeriodState();
    final next = state.nextPrediction;
    return Scaffold(
      appBar: AppBar(title: const Text('周期预测')),
      body: ListView(padding: const EdgeInsets.all(AppDimens.spacingMd), children: [
        Container(
          padding: const EdgeInsets.all(AppDimens.spacingLg),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFFE85D9C), Color(0xFFF4A3C4)]),
            borderRadius: BorderRadius.circular(AppDimens.radiusCard),
          ),
          child: Column(children: [
            const Text('下次经期预测', style: TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 8),
            Text(next == null ? '数据不足' : '${next.year}-${next.month.toString().padLeft(2, '0')}-${next.day.toString().padLeft(2, '0')}',
              style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(next == null ? '需至少记录 1 次经期' : '还有 ${state.daysToNext} 天',
              style: const TextStyle(color: Colors.white70)),
          ])),
        const SizedBox(height: 16),
        if (next != null) ...[
          Container(
            padding: const EdgeInsets.all(AppDimens.spacingMd),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              Container(width: 48, height: 48, decoration: BoxDecoration(
                color: Color(0xFFE85D9C).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12),
              ), child: const Icon(Icons.calendar_today_rounded, color: Color(0xFFE85D9C))),
              const SizedBox(width: 12),
              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('排卵期预测', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                SizedBox(height: 2),
                Text('预计在经期前 14 天', style: TextStyle(color: AppColors.textHint, fontSize: 12)),
              ])),
            ])),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(AppDimens.spacingMd),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              Container(width: 48, height: 48, decoration: BoxDecoration(
                color: Color(0xFFE85D9C).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12),
              ), child: const Icon(Icons.wb_sunny_rounded, color: Color(0xFFE85D9C))),
              const SizedBox(width: 12),
              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('安全期', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                SizedBox(height: 2),
                Text('仅供参考，请勿作为避孕依据', style: TextStyle(color: AppColors.textHint, fontSize: 12)),
              ])),
            ])),
        ],
      ]),
    );
  }
}

// 提醒设置 (PeriodReminderSettingsActivity)
class PeriodReminderScreen extends StatefulWidget {
  const PeriodReminderScreen({super.key});
  @override
  State<PeriodReminderScreen> createState() => _PeriodReminderScreenState();
}

class _PeriodReminderScreenState extends State<PeriodReminderScreen> {
  bool _before = true, _during = false, _ovulation = false;
  int _beforeDays = 3;
  TimeOfDay _remindTime = const TimeOfDay(hour: 9, minute: 0);

  Future<void> _pickTime() async {
    final t = await showTimePicker(context: context, initialTime: _remindTime);
    if (t != null) setState(() => _remindTime = t);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('经期提醒')),
      body: ListView(padding: const EdgeInsets.all(AppDimens.spacingMd), children: [
        SwitchListTile(title: const Text('经前提醒'), subtitle: Text('提前 $_beforeDays 天'), value: _before, onChanged: (v) => setState(() => _before = v)),
        SwitchListTile(title: const Text('经期提醒'), subtitle: const Text('每日提醒'), value: _during, onChanged: (v) => setState(() => _during = v)),
        SwitchListTile(title: const Text('排卵期提醒'), value: _ovulation, onChanged: (v) => setState(() => _ovulation = v)),
        const Divider(),
        ListTile(title: const Text('提醒时间'), subtitle: Text('${_remindTime.hour.toString().padLeft(2, '0')}:${_remindTime.minute.toString().padLeft(2, '0')}'), trailing: const Icon(Icons.chevron_right_rounded), onTap: _pickTime),
        const Divider(),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: Text('提前天数', style: Theme.of(context).textTheme.titleSmall)),
        Slider(value: _beforeDays.toDouble(), min: 1, max: 7, divisions: 6, label: '$_beforeDays 天', onChanged: (v) => setState(() => _beforeDays = v.toInt())),
        const SizedBox(height: 32),
        FilledButton(
          style: FilledButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
          onPressed: () => context.pop(), child: const Text('保存设置')),
      ]),
    );
  }
}
