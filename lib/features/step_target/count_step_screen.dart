// 步数目标相关 (CountStepsActivity + SetSportTargetActivity + CustomTargetActivity)
// 列表 + 自定义 + 里程碑

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/step_provider.dart' as svc;
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/app_l10n_ext.dart';

class CountStepScreen extends ConsumerStatefulWidget {
  const CountStepScreen({super.key});
  @override
  ConsumerState<CountStepScreen> createState() => _CountStepScreenState();
}

class _CountStepScreenState extends ConsumerState<CountStepScreen> {
  bool _autoStart = true;
  bool _countIdle = false;
  int _sensitivity = 5;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context).s;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(l.countStep), backgroundColor: AppColors.surface, elevation: 0),
      body: ListView(
        padding: const EdgeInsets.all(AppDimens.spacingMd),
        children: [
          _SectionTitle(l.sensorSettings),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimens.radiusCard),
            ),
            child: Column(
              children: [
                _SwitchRow(label: l.autoStartCount, sub: l.autoStartCountSub, value: _autoStart, onChanged: (v) => setState(() => _autoStart = v)),
                const Divider(height: 1, indent: 16, color: AppColors.border),
                _SwitchRow(label: l.countWhenIdle, sub: l.countWhenIdleSub, value: _countIdle, onChanged: (v) => setState(() => _countIdle = v)),
                const Divider(height: 1, indent: 16, color: AppColors.border),
                Padding(
                  padding: const EdgeInsets.all(AppDimens.spacingSm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(l.sensitivity, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14)),
                          const Spacer(),
                          Text('$_sensitivity/10', style: const TextStyle(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      Slider(
                        value: _sensitivity.toDouble(),
                        onChanged: (v) => setState(() => _sensitivity = v.round()),
                        min: 1, max: 10,
                        divisions: 9,
                        activeColor: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionTitle(l.stepTarget),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimens.radiusCard),
            ),
            child: Column(
              children: [
                _LinkRow(icon: Icons.flag_rounded, label: l.setTarget, color: AppColors.primary, onTap: () => _setTarget(context)),
                const Divider(height: 1, indent: 16, color: AppColors.border),
                _LinkRow(icon: Icons.list_alt_rounded, label: l.stepTargetList, color: AppColors.sportRun, onTap: () => context.push('/step-target-list')),
                const Divider(height: 1, indent: 16, color: AppColors.border),
                _LinkRow(icon: Icons.edit_rounded, label: l.customTarget, color: AppColors.sportOther, onTap: () => _customTarget(context)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionTitle(l.about),
          Container(
            padding: const EdgeInsets.all(AppDimens.spacingSm),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimens.radiusCard),
            ),
            child: Text(l.stepCountAbout, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.6)),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Future<void> _setTarget(BuildContext context) async {
    final l = AppL10n.of(context).s;
    final ctrl = TextEditingController(text: '${ref.read(svc.stepProvider).valueOrNull?.goal ?? 8000}');
    final result = await showDialog<int>(context: context, builder: (_) => AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text(l.setTarget),
      content: TextField(controller: ctrl, keyboardType: TextInputType.number,
        decoration: const InputDecoration(suffixText: '步')),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l.cancel)),
        ElevatedButton(
          onPressed: () {
            final v = int.tryParse(ctrl.text);
            if (v != null && v >= 1000) Navigator.pop(context, v);
          },
          child: Text(l.save),
        ),
      ],
    ));
    if (result != null) {
      await ref.read(svc.stepProvider.notifier).setGoal(result);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${l.save}: $result ${l.unitStep}'), backgroundColor: AppColors.success),
      );
    }
  }

  Future<void> _customTarget(BuildContext context) async {
    final l = AppL10n.of(context).s;
    showDialog(context: context, builder: (_) => AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text(l.customTarget),
      content: const Text('自定义目标包括：\n• 步数目标\n• 卡路里目标\n• 运动时长目标\n• 活动时长目标'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l.cancel)),
        TextButton(
          onPressed: () { Navigator.pop(context); context.push('/set-target'); },
          child: Text(l.next),
        ),
      ],
    ));
  }
}

class _SwitchRow extends StatelessWidget {
  final String label, sub;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _SwitchRow({required this.label, required this.sub, required this.value, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14)),
      subtitle: sub.isEmpty ? null : Text(sub, style: const TextStyle(color: AppColors.textHint, fontSize: 11)),
      trailing: Switch(value: value, activeColor: AppColors.primary, onChanged: onChanged),
    );
  }
}

class _LinkRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _LinkRow({required this.icon, required this.label, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(label, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14)),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textHint, size: 20),
      onTap: onTap,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String s;
  const _SectionTitle(this.s);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 8, top: 4),
    child: Text(s, style: const TextStyle(color: AppColors.textHint, fontSize: 12, fontWeight: FontWeight.w600)),
  );
}

class StepTargetListScreen extends ConsumerWidget {
  const StepTargetListScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context).s;
    final current = ref.watch(svc.stepProvider).valueOrNull?.goal ?? 8000;
    final milestones = [3000, 5000, 6000, 8000, 10000, 12000, 15000, 20000];
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(l.stepTargetList), backgroundColor: AppColors.surface, elevation: 0),
      body: ListView(
        padding: const EdgeInsets.all(AppDimens.spacingMd),
        children: [
          Text(l.chooseMilestone, style: const TextStyle(color: AppColors.textHint, fontSize: 13)),
          const SizedBox(height: 12),
          ...milestones.map((m) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: current == m ? AppColors.primary : AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: current == m ? null : Border.all(color: AppColors.border),
            ),
            child: ListTile(
              leading: Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: current == m ? Colors.white.withValues(alpha: 0.2) : AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _iconFor(m),
                  color: current == m ? Colors.white : AppColors.primary,
                  size: 22,
                ),
              ),
              title: Text('$m ${l.unitStep}',
                style: TextStyle(color: current == m ? Colors.white : AppColors.textPrimary,
                  fontSize: 16, fontWeight: FontWeight.w600)),
              subtitle: Text(_subFor(m, l),
                style: TextStyle(color: current == m ? Colors.white.withValues(alpha: 0.85) : AppColors.textHint, fontSize: 12)),
              trailing: current == m
                ? const Icon(Icons.check_circle_rounded, color: Colors.white)
                : const Icon(Icons.chevron_right_rounded, color: AppColors.textHint),
              onTap: () async {
                await ref.read(svc.stepProvider.notifier).setGoal(m);
                if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${l.save}: $m'), backgroundColor: AppColors.success),
                );
              },
            ),
          )),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  IconData _iconFor(int m) {
    if (m <= 5000) return Icons.directions_walk_rounded;
    if (m <= 10000) return Icons.directions_run_rounded;
    if (m <= 15000) return Icons.bolt_rounded;
    return Icons.emoji_events_rounded;
  }

  String _subFor(int m, AppL10nStrings l) {
    if (m <= 3000) return l.easy;
    if (m <= 6000) return l.light;
    if (m <= 10000) return l.recommend;
    if (m <= 15000) return l.challenging;
    return l.expert;
  }
}

class CustomTargetScreen extends ConsumerStatefulWidget {
  const CustomTargetScreen({super.key});
  @override
  ConsumerState<CustomTargetScreen> createState() => _CustomTargetScreenState();
}

class _CustomTargetScreenState extends ConsumerState<CustomTargetScreen> {
  int _stepTarget = 8000;
  int _calorieTarget = 300;
  int _sportMinTarget = 30;

  Future<void> _save() async {
    final p = await SharedPreferences.getInstance();
    await p.setInt('step_goal', _stepTarget);
    await p.setInt('calorie_goal', _calorieTarget);
    await p.setInt('sport_min_goal', _sportMinTarget);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('保存成功'), backgroundColor: AppColors.success),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context).s;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(l.customTarget), backgroundColor: AppColors.surface, elevation: 0),
      body: ListView(
        padding: const EdgeInsets.all(AppDimens.spacingMd),
        children: [
          _slider(l.steps, l.unitStep, _stepTarget.toDouble(), 1000, 50000, 500, (v) => _stepTarget = v.round()),
          _slider(l.calories, 'kcal', _calorieTarget.toDouble(), 100, 2000, 50, (v) => _calorieTarget = v.round()),
          _slider(l.sportDuration, l.minute, _sportMinTarget.toDouble(), 5, 240, 5, (v) => _sportMinTarget = v.round()),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity, height: 50,
            child: ElevatedButton(onPressed: _save, child: Text(l.save)),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _slider(String label, String unit, double value, double min, double max, double div, ValueChanged<double> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(AppDimens.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label, style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w600)),
              const Spacer(),
              Text('${value.toInt()} $unit',
                style: const TextStyle(color: AppColors.primary, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          Slider(
            value: value, onChanged: onChanged,
            min: min, max: max, divisions: ((max - min) / div).round(),
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class SetTargetScreen extends StatelessWidget {
  const SetTargetScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context).s;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(l.setTarget), backgroundColor: AppColors.surface, elevation: 0),
      body: const CustomTargetScreen(),
    );
  }
}

class SetSportTargetScreen extends ConsumerStatefulWidget {
  const SetSportTargetScreen({super.key});
  @override
  ConsumerState<SetSportTargetScreen> createState() => _SetSportTargetScreenState();
}

class _SetSportTargetScreenState extends ConsumerState<SetSportTargetScreen> {
  int _sportCalorieTarget = 300;
  int _sportMinTarget = 30;
  int _stepTarget = 8000;
  int _activeMinTarget = 60;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context).s;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(l.setSportTarget), backgroundColor: AppColors.surface, elevation: 0),
      body: ListView(
        padding: const EdgeInsets.all(AppDimens.spacingMd),
        children: [
          Text(l.sportTargetTip, style: const TextStyle(color: AppColors.textHint, fontSize: 13, height: 1.6)),
          const SizedBox(height: 16),
          _tile(context, l.sportCalorie, '$_sportCalorieTarget kcal', Icons.local_fire_department_rounded, AppColors.warning, () {}),
          _tile(context, l.sportDuration, '$_sportMinTarget ${l.minute}', Icons.access_time_rounded, AppColors.sportRun, () {}),
          _tile(context, l.dailySteps, '$_stepTarget ${l.unitStep}', Icons.directions_walk_rounded, AppColors.primary, () {}),
          _tile(context, l.activeDuration, '$_activeMinTarget ${l.minute}', Icons.timer_rounded, AppColors.sportOther, () {}),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity, height: 50,
            child: ElevatedButton(onPressed: () => Navigator.pop(context), child: Text(l.save)),
          ),
        ],
      ),
    );
  }

  Widget _tile(BuildContext ctx, String label, String value, IconData icon, Color color, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
      ),
      child: ListTile(
        leading: Container(
          width: 40, height: 40,
          decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(label, style: const TextStyle(color: AppColors.textPrimary, fontSize: 15)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textHint, size: 20),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

class TargetActivityScreen extends StatelessWidget {
  const TargetActivityScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context).s;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(l.target), backgroundColor: AppColors.surface, elevation: 0),
      body: ListView(
        padding: const EdgeInsets.all(AppDimens.spacingMd),
        children: [
          _LinkRow2(icon: Icons.directions_walk_rounded, label: l.countStep, color: AppColors.primary, onTap: () => context.push('/count-step')),
          _LinkRow2(icon: Icons.directions_run_rounded, label: l.setSportTarget, color: AppColors.sportRun, onTap: () => context.push('/set-sport-target')),
          _LinkRow2(icon: Icons.flag_outlined, label: l.target, color: AppColors.sportOther, onTap: () => context.push('/target')),
          _LinkRow2(icon: Icons.list_alt_rounded, label: l.stepTargetList, color: AppColors.sportWalk, onTap: () => context.push('/step-target-list')),
          _LinkRow2(icon: Icons.edit_rounded, label: l.customTarget, color: AppColors.warning, onTap: () => context.push('/custom-target')),
        ],
      ),
    );
  }
}

class _LinkRow2 extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _LinkRow2({required this.icon, required this.label, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 40, height: 40,
          decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(label, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14)),
        trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textHint, size: 20),
        onTap: onTap,
      ),
    );
  }
}

class CountStepNewScreen extends StatelessWidget {
  const CountStepNewScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context).s;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(l.countStepNew), backgroundColor: AppColors.surface, elevation: 0),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.timeline_rounded, size: 64, color: AppColors.textHint),
              SizedBox(height: 16),
              Text('详细步数趋势', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w600)),
              SizedBox(height: 8),
              Text('此页面展示完整的步数历史数据，请前往步数页查看',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textHint, fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}
