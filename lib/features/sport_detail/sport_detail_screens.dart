// 运动子页 (WalkDistance/DistanceSport/TimeSport/ExerciseTracking/SportGoal/GuidedWorkout)
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';

class WalkDistanceScreen extends StatelessWidget {
  const WalkDistanceScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('步行距离')),
      body: ListView(padding: const EdgeInsets.all(AppDimens.spacingMd), children: [
        Container(
          padding: const EdgeInsets.all(AppDimens.spacingLg),
          decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppColors.primary, AppColors.sportWalk]), borderRadius: BorderRadius.circular(AppDimens.radiusCard)),
          child: const Column(children: [
            Text('今日步行', style: TextStyle(color: Colors.white70, fontSize: 14)),
            SizedBox(height: 8),
            Text('3.2 km', style: TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.w200)),
            SizedBox(height: 8),
            Text('昨日: 2.8 km', style: TextStyle(color: Colors.white54)),
          ]),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(AppDimens.spacingMd),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
          child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('近 7 日', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _Bar(day: '一', km: 2.1), _Bar(day: '二', km: 3.4), _Bar(day: '三', km: 2.8),
              _Bar(day: '四', km: 1.9), _Bar(day: '五', km: 3.2), _Bar(day: '六', km: 4.1), _Bar(day: '日', km: 3.2),
            ]),
          ]),
        ),
      ]),
    );
  }
}

class _Bar extends StatelessWidget {
  final String day; final double km;
  const _Bar({required this.day, required this.km});
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(width: 24, height: km * 30, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(4))),
      const SizedBox(height: 4),
      Text(day, style: const TextStyle(color: AppColors.textHint, fontSize: 10)),
    ]);
  }
}

class WalkDistanceHistoryScreen extends StatelessWidget {
  const WalkDistanceHistoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('距离历史')),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppDimens.spacingMd),
        itemCount: _distanceData.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, i) {
          final r = _distanceData[i];
          return ListTile(
            leading: const Icon(Icons.directions_walk_rounded, color: AppColors.primary),
            title: Text(r['date']!), subtitle: Text(r['steps']!),
            trailing: Text(r['km']!, style: const TextStyle(fontWeight: FontWeight.bold)),
          );
        },
      ),
    );
  }
  static const _distanceData = [
    {'date': '06-18', 'km': '3.2 km', 'steps': '4,280 步'},
    {'date': '06-17', 'km': '2.8 km', 'steps': '3,640 步'},
    {'date': '06-16', 'km': '3.4 km', 'steps': '4,520 步'},
    {'date': '06-15', 'km': '2.1 km', 'steps': '2,810 步'},
    {'date': '06-14', 'km': '4.1 km', 'steps': '5,520 步'},
  ];
}



class SportGoalSettingScreen extends StatefulWidget {
  const SportGoalSettingScreen({super.key});
  @override
  State<SportGoalSettingScreen> createState() => _SportGoalSettingScreenState();
}

class _SportGoalSettingScreenState extends State<SportGoalSettingScreen> {
  int _weekly = 3;
  int _cal = 2000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('运动目标'), actions: [TextButton(onPressed: () => context.pop(), child: const Text('保存'))]),
      body: ListView(padding: const EdgeInsets.all(AppDimens.spacingMd), children: [
        Text('每周运动天数', style: Theme.of(context).textTheme.titleMedium),
        Slider(value: _weekly.toDouble(), min: 1, max: 7, divisions: 6, label: '$_weekly 天', onChanged: (v) => setState(() => _weekly = v.toInt())),
        const SizedBox(height: 16),
        Text('每周卡路里目标', style: Theme.of(context).textTheme.titleMedium),
        Slider(value: _cal.toDouble(), min: 500, max: 5000, divisions: 9, label: '$_cal 千卡', onChanged: (v) => setState(() => _cal = v.toInt())),
        const SizedBox(height: 32),
        const Text('当前: 每周 4 次 · 已消耗 1,850 千卡', style: TextStyle(color: AppColors.textHint)),
      ]),
    );
  }
}

