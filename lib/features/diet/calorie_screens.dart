// 热量子页 (CalorieHome/Goal/History/DayDetail)
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';

class CalorieHomeScreen extends StatefulWidget {
  const CalorieHomeScreen({super.key});
  @override
  State<CalorieHomeScreen> createState() => _CalorieHomeScreenState();
}

class _CalorieHomeScreenState extends State<CalorieHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('热量管理'), actions: [
        IconButton(icon: const Icon(Icons.tune_rounded), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CalorieGoalSettingScreen()))),
        IconButton(icon: const Icon(Icons.history_rounded), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CalorieHistoryScreen()))),
      ]),
      body: ListView(padding: const EdgeInsets.all(AppDimens.spacingMd), children: [
        Container(
          padding: const EdgeInsets.all(AppDimens.spacingLg),
          decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppColors.warning, AppColors.warning]), borderRadius: BorderRadius.circular(AppDimens.radiusCard)),
          child: Column(children: [
            const Text('今日摄入', style: TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 8),
            const Text('1,280', style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.w200)),
            const SizedBox(height: 4),
            Text('目标 2,000 千卡', style: TextStyle(color: Colors.white.withValues(alpha: 0.7))),
            const SizedBox(height: 12),
            LinearProgressIndicator(value: 0.64, minHeight: 8, backgroundColor: Colors.white24, valueColor: const AlwaysStoppedAnimation(Colors.white)),
          ]),
        ),
        const SizedBox(height: 16),
        Row(children: [
          _macro('碳水', '160g', AppColors.primary),
          const SizedBox(width: 8),
          _macro('蛋白质', '80g', AppColors.sportOther),
          const SizedBox(width: 8),
          _macro('脂肪', '42g', AppColors.warning),
        ]),
        const SizedBox(height: 16),
        const Text('今日三餐', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        _meal('早餐', '380 千卡', '面包+鸡蛋+牛奶'),
        _meal('午餐', '520 千卡', '米饭+鸡胸肉+青菜'),
        _meal('晚餐', '380 千卡', '沙拉+鱼肉'),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CalorieDayDetailScreen())),
          icon: const Icon(Icons.add_rounded), label: const Text('记录饮食'),
          style: FilledButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
        ),
      ]),
    );
  }

  Widget _macro(String label, String value, Color color) {
    return Expanded(child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12)),
      child: Column(children: [
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: TextStyle(color: color.withValues(alpha: 0.7), fontSize: 12)),
      ]),
    ));
  }

  Widget _meal(String name, String cal, String desc) {
    return Card(color: AppColors.surface, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), child: ListTile(
      title: Text(name), subtitle: Text(desc, style: const TextStyle(color: AppColors.textHint, fontSize: 12)),
      trailing: Text(cal, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.warning)),
    ));
  }
}

class CalorieGoalSettingScreen extends StatefulWidget {
  const CalorieGoalSettingScreen({super.key});
  @override
  State<CalorieGoalSettingScreen> createState() => _CalorieGoalSettingScreenState();
}

class _CalorieGoalSettingScreenState extends State<CalorieGoalSettingScreen> {
  int _cal = 2000;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('热量目标'), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('保存'))]),
      body: Padding(padding: const EdgeInsets.all(AppDimens.spacingMd), child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        const Text('每日摄入目标', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 24),
        Text('$_cal 千卡', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w200, color: AppColors.warning)),
        const SizedBox(height: 16),
        Slider(value: _cal.toDouble(), min: 800, max: 4000, divisions: 64, label: '$_cal 千卡', onChanged: (v) => setState(() => _cal = v.toInt())),
        const SizedBox(height: 16),
        Text('建议: ${(_cal * 0.3).toInt()}千卡 碳水 · ${(_cal * 0.35).toInt()}千卡 蛋白 · ${(_cal * 0.35).toInt()}千卡 脂肪', style: const TextStyle(color: AppColors.textHint)),
      ])),
    );
  }
}

class CalorieHistoryScreen extends StatelessWidget {
  const CalorieHistoryScreen({super.key});
  final _data = const [
    {'date': '06-18', 'cal': '1,280', 'status': '达标'},
    {'date': '06-17', 'cal': '1,950', 'status': '达标'},
    {'date': '06-16', 'cal': '2,340', 'status': '超标'},
    {'date': '06-15', 'cal': '1,680', 'status': '达标'},
    {'date': '06-14', 'cal': '2,100', 'status': '超标'},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('热量历史')),
      body: Column(children: [
        SizedBox(height: 180, child: BarChart(BarChartData(
          barGroups: List.generate(5, (i) => BarChartGroupData(x: i, barRods: [BarChartRodData(toY: [1280, 1950, 2340, 1680, 2100][i].toDouble(), color: AppColors.warning, width: 20)])),
          titlesData: const FlTitlesData(show: false), borderData: FlBorderData(show: false), gridData: const FlGridData(show: false),
        ))),
        Expanded(child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingMd),
          itemCount: _data.length, separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, i) {
            final r = _data[i];
            return ListTile(
              leading: const Icon(Icons.local_fire_department_rounded, color: AppColors.warning),
              title: Text(r['cal']!), subtitle: Text(r['date']!, style: const TextStyle(color: AppColors.textHint)),
              trailing: Chip(label: Text(r['status']!), backgroundColor: r['status'] == '超标' ? AppColors.error.withValues(alpha: 0.1) : AppColors.success.withValues(alpha: 0.1)),
            );
          },
        )),
      ]),
    );
  }
}

class CalorieDayDetailScreen extends StatefulWidget {
  const CalorieDayDetailScreen({super.key});
  @override
  State<CalorieDayDetailScreen> createState() => _CalorieDayDetailScreenState();
}

class _CalorieDayDetailScreenState extends State<CalorieDayDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('记录饮食'), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('保存'))]),
      body: ListView(padding: const EdgeInsets.all(AppDimens.spacingMd), children: [
        _addBlock('早餐', [('面包', 120), ('牛奶', 150), ('鸡蛋', 80)]),
        _addBlock('午餐', [('米饭', 200), ('鸡胸肉', 165), ('青菜', 32)]),
        _addBlock('晚餐', [('沙拉', 100), ('鱼肉', 180), ('水果', 60)]),
        _addBlock('加餐', [('坚果', 100), ('酸奶', 80)]),
        const SizedBox(height: 16),
        FilledButton(style: FilledButton.styleFrom(minimumSize: const Size(double.infinity, 48)), onPressed: () => Navigator.pop(context), child: const Text('保存')),
      ]),
    );
  }

  Widget _addBlock(String meal, List<(String, int)> items) {
    return Column(children: [
      const Divider(),
      Row(children: [
        Text(meal, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const Spacer(),
        Text('${items.fold(0, (s, x) => s + x.$2)} 千卡', style: const TextStyle(color: AppColors.warning)),
        IconButton(icon: const Icon(Icons.add_circle_outline, color: AppColors.primary), onPressed: () => context.push('/food-selection')),
      ]),
      ...items.map((i) => ListTile(
        dense: true, title: Text(i.$1), trailing: Text('${i.$2} 千卡', style: const TextStyle(color: AppColors.textHint)),
      )),
    ]);
  }
}
