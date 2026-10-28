// 运动扩展页: 距离/时长运动 + 运动类型选择 + 添加记录 + 运动详情

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/health_providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/app_l10n_ext.dart';

class SportType {
  final String key;
  final String displayName;
  final IconData icon;
  final Color color;
  final double met;

  const SportType(this.key, this.displayName, this.icon, this.color, [this.met = 8.0]);

  static SportType? byKey(String key) {
    try {
      return all.firstWhere((e) => e.key == key);
    } catch (_) {
      return null;
    }
  }

  static const List<SportType> all = [
    SportType('running', '跑步', Icons.directions_run_rounded, AppColors.sportRun),
    SportType('walking', '健走', Icons.directions_walk_rounded, AppColors.sportWalk),
    SportType('cycling', '骑行', Icons.directions_bike_rounded, AppColors.sportRide),
    SportType('swimming', '游泳', Icons.pool_rounded, AppColors.sportOther),
    SportType('fitness', '健身', Icons.fitness_center_rounded, AppColors.sportOther),
    SportType('yoga', '瑜伽', Icons.self_improvement_rounded, AppColors.sportOther),
    SportType('basketball', '篮球', Icons.sports_basketball_rounded, AppColors.sportOther),
    SportType('football', '足球', Icons.sports_soccer_rounded, AppColors.sportOther),
  ];
}

class DistanceSportScreen extends ConsumerStatefulWidget {
  const DistanceSportScreen({super.key});
  @override
  ConsumerState<DistanceSportScreen> createState() => _DistanceSportScreenState();
}

class _DistanceSportScreenState extends ConsumerState<DistanceSportScreen> {
  double _targetKm = 5.0;
  final _distances = [1.0, 3.0, 5.0, 10.0, 21.0, 42.195];

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context).s;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(l.distanceSport), backgroundColor: AppColors.surface, elevation: 0),
      body: ListView(
        padding: const EdgeInsets.all(AppDimens.spacingMd),
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimens.spacingLg),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [AppColors.sportWalk, AppColors.primary],
              ),
              borderRadius: BorderRadius.circular(AppDimens.radiusCard),
            ),
            child: Column(
              children: [
                const Icon(Icons.route_rounded, color: Colors.white, size: 48),
                const SizedBox(height: 8),
                Text('${_targetKm.toStringAsFixed(1)} km',
                  style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
                Text(l.distanceGoal, style: const TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(l.chooseDistance, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10, runSpacing: 10,
            children: _distances.map((d) {
              final sel = d == _targetKm;
              return ChoiceChip(
                label: Text(d == 42.195 ? '马拉松' : '${d.toStringAsFixed(0)} km'),
                selected: sel,
                onSelected: (_) => setState(() => _targetKm = d),
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(color: sel ? Colors.white : AppColors.textPrimary),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity, height: 52,
            child: ElevatedButton.icon(
              onPressed: () => context.push('/count-time?type=running'),
              icon: const Icon(Icons.play_arrow_rounded, size: 24),
              label: Text(l.startSport, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
              ),
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class TimeSportScreen extends ConsumerStatefulWidget {
  const TimeSportScreen({super.key});
  @override
  ConsumerState<TimeSportScreen> createState() => _TimeSportScreenState();
}

class _TimeSportScreenState extends ConsumerState<TimeSportScreen> {
  int _targetMin = 30;
  final _durations = [15, 30, 45, 60, 90, 120];

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context).s;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(l.timeSport), backgroundColor: AppColors.surface, elevation: 0),
      body: ListView(
        padding: const EdgeInsets.all(AppDimens.spacingMd),
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimens.spacingLg),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [AppColors.sportRun, AppColors.warning],
              ),
              borderRadius: BorderRadius.circular(AppDimens.radiusCard),
            ),
            child: Column(
              children: [
                const Icon(Icons.access_time_rounded, color: Colors.white, size: 48),
                const SizedBox(height: 8),
                Text('$_targetMin ${l.minute}',
                  style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
                Text(l.timeGoal, style: const TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(l.chooseDuration, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10, runSpacing: 10,
            children: _durations.map((m) {
              final sel = m == _targetMin;
              return ChoiceChip(
                label: Text('$m ${l.minute}'),
                selected: sel,
                onSelected: (_) => setState(() => _targetMin = m),
                selectedColor: AppColors.sportRun,
                labelStyle: TextStyle(color: sel ? Colors.white : AppColors.textPrimary),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity, height: 52,
            child: ElevatedButton.icon(
              onPressed: () => context.push('/count-time?type=sport'),
              icon: const Icon(Icons.play_arrow_rounded, size: 24),
              label: Text(l.startSport, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.sportRun,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
              ),
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class SportTypeSelectorScreen extends StatelessWidget {
  const SportTypeSelectorScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context).s;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(l.sportTypeSelector), backgroundColor: AppColors.surface, elevation: 0),
      body: GridView.count(
        crossAxisCount: 3,
        padding: const EdgeInsets.all(AppDimens.spacingMd),
        childAspectRatio: 1,
        mainAxisSpacing: 12, crossAxisSpacing: 12,
        children: SportType.all.map((t) {
          return InkWell(
            onTap: () => context.push('/count-time?type=${t.key}'),
            borderRadius: BorderRadius.circular(AppDimens.radiusCard),
            child: Container(
              padding: const EdgeInsets.all(AppDimens.spacingSm),
              decoration: BoxDecoration(
                color: t.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppDimens.radiusCard),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(t.icon, color: t.color, size: 36),
                  const SizedBox(height: 8),
                  Text(t.displayName, style: TextStyle(color: t.color, fontSize: 14, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class AddSportRecordScreen extends ConsumerStatefulWidget {
  const AddSportRecordScreen({super.key});
  @override
  ConsumerState<AddSportRecordScreen> createState() => _AddSportRecordScreenState();
}

class _AddSportRecordScreenState extends ConsumerState<AddSportRecordScreen> {
  String _type = '跑步';
  double _distance = 3.0;
  int _duration = 30;
  int _calories = 250;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context).s;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(l.addSportRecord), backgroundColor: AppColors.surface, elevation: 0),
      body: ListView(
        padding: const EdgeInsets.all(AppDimens.spacingMd),
        children: [
          // 类型
          Text(l.sportType, style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: SportType.all.take(8).map((t) {
              final sel = t.displayName == _type;
              return ChoiceChip(
                label: Text(t.displayName),
                selected: sel,
                onSelected: (_) => setState(() => _type = t.displayName),
                selectedColor: t.color,
                labelStyle: TextStyle(color: sel ? Colors.white : AppColors.textPrimary),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          _slider(l.distance, 'km', _distance, 0.5, 50, 0.5, (v) {
            setState(() {
              _distance = v;
              _calories = (v * 70).round();
            });
          }),
          _slider(l.duration, l.minute, _duration.toDouble(), 5, 240, 5, (v) {
            setState(() {
              _duration = v.round();
              _calories = (v * 7).round();
            });
          }),
          _slider(l.calories, 'kcal', _calories.toDouble(), 50, 2000, 10, (v) => setState(() => _calories = v.round())),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity, height: 52,
            child: ElevatedButton(
              onPressed: () {
                ref.read(sportProvider.notifier).addSession(
                  type: _type,
                  start: DateTime.now().subtract(Duration(minutes: _duration)),
                  end: DateTime.now(),
                  distanceKm: _distance,
                  calories: _calories.toDouble(),
                  steps: (_distance * 1400).round(),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l.save), backgroundColor: AppColors.success),
                );
                Navigator.pop(context);
              },
              child: Text(l.save, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
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
              Text(label, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14)),
              const Spacer(),
              Text('${value.toStringAsFixed(unit == 'km' ? 1 : 0)} $unit',
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

class SportDetailScreen extends ConsumerStatefulWidget {
  const SportDetailScreen({super.key});
  @override
  ConsumerState<SportDetailScreen> createState() => _SportDetailScreenState();
}

class _SportDetailScreenState extends ConsumerState<SportDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context).s;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(l.sportDetail), backgroundColor: AppColors.surface, elevation: 0),
      body: ListView(
        padding: const EdgeInsets.all(AppDimens.spacingMd),
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimens.spacingLg),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.6)],
              ),
              borderRadius: BorderRadius.circular(AppDimens.radiusCard),
            ),
            child: Column(
              children: [
                const Icon(Icons.analytics_rounded, color: Colors.white, size: 48),
                const SizedBox(height: 8),
                const Text('运动分析', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _info('3.42', 'km', Icons.route_rounded),
                    _info('24:35', l.minute, Icons.access_time_rounded),
                    _info('256', 'kcal', Icons.local_fire_department_rounded),
                    _info('4.8', 'km/h', Icons.speed_rounded),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _section(l.paceAnalysis, content: _mockPace()),
          const SizedBox(height: 16),
          _section(l.heartRateZone, content: _mockHeartRate()),
          const SizedBox(height: 16),
          _section(l.calorieBreakdown, content: _mockCalories()),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _info(String value, String unit, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        Text(unit, style: const TextStyle(color: Colors.white70, fontSize: 10)),
      ],
    );
  }

  Widget _section(String label, {Widget? content}) {
    return Container(
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
              Text(label, style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.bold)),
              const Spacer(),
              if (content == null) const Icon(Icons.chevron_right_rounded, color: AppColors.textHint, size: 18),
            ],
          ),
          if (content != null) ...[
            const SizedBox(height: 16),
            content,
          ]
        ],
      ),
    );
  }

  Widget _mockPace() {
    return Column(
      children: [
        _paceRow('1 km', '5\'30"', 0.7),
        const SizedBox(height: 8),
        _paceRow('2 km', '5\'45"', 0.75),
        const SizedBox(height: 8),
        _paceRow('3 km', '6\'10"', 0.85),
        const SizedBox(height: 8),
        _paceRow('0.42 km', '6\'05"', 0.8),
      ],
    );
  }

  Widget _paceRow(String km, String time, double fraction) {
    return Row(
      children: [
        SizedBox(width: 50, child: Text(km, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13))),
        Expanded(
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: fraction,
            child: Container(
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 8),
              child: Text(time, style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _mockHeartRate() {
    return Column(
      children: [
        Row(
          children: [
            _hrBar(AppColors.textHint, 1, '热身'),
            const SizedBox(width: 4),
            _hrBar(AppColors.success, 3, '燃脂'),
            const SizedBox(width: 4),
            _hrBar(AppColors.warning, 5, '有氧'),
            const SizedBox(width: 4),
            _hrBar(Colors.orange, 2, '无氧'),
            const SizedBox(width: 4),
            _hrBar(AppColors.error, 1, '极限'),
          ],
        ),
        const SizedBox(height: 16),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('平均心率 142 bpm', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            Text('最大心率 168 bpm', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          ],
        ),
      ],
    );
  }

  Widget _hrBar(Color color, int flex, String label) {
    return Expanded(
      flex: flex,
      child: Column(
        children: [
          Container(height: 8, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(color: AppColors.textHint, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _mockCalories() {
    return Row(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary, width: 8),
          ),
          child: const Center(
            child: Text('256\nkcal', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _calRow(AppColors.primary, '基础代谢', '60 kcal'),
              const SizedBox(height: 8),
              _calRow(AppColors.warning, '运动消耗', '196 kcal'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _calRow(Color color, String label, String val) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        const Spacer(),
        Text(val, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
