// 体重/睡眠/冥想设置/喝水/饮食 扩展页

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../core/services/health_providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/app_l10n_ext.dart';

// 体重日历
class WeightCalendarScreen extends ConsumerStatefulWidget {
  const WeightCalendarScreen({super.key});
  @override
  ConsumerState<WeightCalendarScreen> createState() => _WeightCalendarScreenState();
}

class _WeightCalendarScreenState extends ConsumerState<WeightCalendarScreen> {
  DateTime _focused = DateTime.now();
  DateTime? _selected;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context).s;
    final weightAsync = ref.watch(weightProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(l.weightCalendar), backgroundColor: AppColors.surface, elevation: 0),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(AppDimens.spacingMd),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimens.radiusCard),
            ),
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focused,
              selectedDayPredicate: (d) => _selected != null && isSameDay(_selected, d),
              onDaySelected: (s, f) => setState(() { _selected = s; _focused = f; }),
              headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.3), shape: BoxShape.circle),
                selectedDecoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
              ),
            ),
          ),
          Expanded(
            child: weightAsync.maybeWhen(
              data: (data) {
                final byDay = <int, double>{};
                for (final r in data) {
                  final d = r.recordDatetime;
                  byDay[d.year * 10000 + d.month * 100 + d.day] = r.weight;
                }
                final selected = _selected ?? DateTime.now();
                final key = selected.year * 10000 + selected.month * 100 + selected.day;
                final w = byDay[key];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(AppDimens.spacingLg),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppDimens.radiusCard),
                  ),
                  child: Column(
                    children: [
                      Text(DateFormat('yyyy 年 M 月 d 日').format(selected),
                        style: const TextStyle(color: AppColors.textHint, fontSize: 13)),
                      const SizedBox(height: 8),
                      if (w != null) Text('${w.toStringAsFixed(1)} kg',
                        style: const TextStyle(color: AppColors.info, fontSize: 36, fontWeight: FontWeight.bold))
                      else const Text('未记录', style: TextStyle(color: AppColors.textHint, fontSize: 18)),
                    ],
                  ),
                );
              },
              orElse: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfessionalWeightScreen extends ConsumerWidget {
  const ProfessionalWeightScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context).s;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(l.professionalWeight), backgroundColor: AppColors.surface, elevation: 0),
      body: ListView(
        padding: const EdgeInsets.all(AppDimens.spacingMd),
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimens.spacingLg),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [AppColors.info, AppColors.sportRide],
              ),
              borderRadius: BorderRadius.circular(AppDimens.radiusCard),
            ),
            child: Column(
              children: [
                const Icon(Icons.medical_services_rounded, color: Colors.white, size: 48),
                const SizedBox(height: 8),
                Text(l.professionalWeight, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(l.professionalWeightSub, textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...[
            {'icon': Icons.monitor_weight_rounded, 'label': l.bmi, 'color': AppColors.info, 'desc': '22.5 (正常)'},
            {'icon': Icons.monitor_heart_rounded, 'label': l.bodyFat, 'color': AppColors.error, 'desc': '18.2% (标准)'},
            {'icon': Icons.water_drop_rounded, 'label': l.bodyWater, 'color': AppColors.info, 'desc': '60% (良好)'},
            {'icon': Icons.fitness_center_rounded, 'label': l.muscleMass, 'color': AppColors.sportOther, 'desc': '45.2 kg'},
            {'icon': Icons.directions_run_rounded, 'label': l.visceralFat, 'color': AppColors.sportRun, 'desc': '8 (健康)'},
            {'icon': Icons.bolt_rounded, 'label': l.bmr, 'color': AppColors.warning, 'desc': '1650 kcal'},
          ].map((m) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(AppDimens.spacingSm),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(color: (m['color'] as Color).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                  child: Icon(m['icon'] as IconData, color: m['color'] as Color, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(m['label'] as String, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600))),
                Text(m['desc'] as String, style: TextStyle(color: m['color'] as Color, fontSize: 13)),
              ],
            ),
          )),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class BodyRecordScreen extends ConsumerWidget {
  const BodyRecordScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context).s;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(l.bodyRecord), backgroundColor: AppColors.surface, elevation: 0),
      body: ListView(
        padding: const EdgeInsets.all(AppDimens.spacingMd),
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimens.spacingLg),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [AppColors.info, AppColors.primary],
              ),
              borderRadius: BorderRadius.circular(AppDimens.radiusCard),
            ),
            child: Column(
              children: [
                const Text('65.0 kg', style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
                const Text('当前体重', style: TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
                  child: const Text('比上周 -0.5 kg', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(l.bodyData, style: const TextStyle(color: AppColors.textPrimary, fontSize: 17, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 2,
            mainAxisSpacing: 10, crossAxisSpacing: 10,
            children: [
              _dataBox('BMI', '22.5', '正常', AppColors.success),
              _dataBox('体脂率', '18.2%', '标准', AppColors.success),
              _dataBox('肌肉量', '45.2 kg', '+0.3', AppColors.sportOther),
              _dataBox('基础代谢', '1650', 'kcal', AppColors.warning),
            ],
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _dataBox(String label, String value, String sub, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textHint, fontSize: 11)),
          const SizedBox(height: 2),
          Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
          Text(sub, style: TextStyle(color: color, fontSize: 11)),
        ],
      ),
    );
  }
}

class BodyRecordInfoScreen extends ConsumerWidget {
  const BodyRecordInfoScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context).s;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(l.bodyRecordInfo), backgroundColor: AppColors.surface, elevation: 0),
      body: ListView(
        padding: const EdgeInsets.all(AppDimens.spacingMd),
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimens.spacingMd),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimens.radiusCard),
            ),
            child: Column(
              children: [
                const Icon(Icons.info_rounded, size: 48, color: AppColors.primary),
                const SizedBox(height: 12),
                Text(l.bodyDataIntro, textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, height: 1.6)),
                const SizedBox(height: 16),
                ...['BMI 指数反映身材胖瘦', '体脂率反映身体脂肪比例', '肌肉量决定基础代谢', '基础代谢影响每日所需热量'].map((s) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(color: AppColors.primary)),
                      Expanded(child: Text(s, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12))),
                    ],
                  ),
                )),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

// 睡眠记录
