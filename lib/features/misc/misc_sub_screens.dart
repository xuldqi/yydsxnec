// 训练详情 + 扫描结果 + 健康报告子页
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';

class StartWorkoutScreen extends StatefulWidget {
  final String name;
  final int totalMin;
  const StartWorkoutScreen({super.key, required this.name, this.totalMin = 20});
  @override
  State<StartWorkoutScreen> createState() => _StartWorkoutScreenState();
}

class _StartWorkoutScreenState extends State<StartWorkoutScreen> {
  late int _sec;
  bool _running = false;

  @override
  void initState() {
    super.initState();
    _sec = widget.totalMin * 60;
  }

  void _tick() {
    if (!_running) return;
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted || !_running) return;
      setState(() {
        if (_sec > 0) { _sec--; _tick(); }
        else { _running = false; _showDone(); }
      });
    });
  }

  void _showDone() {
    showDialog(context: context, builder: (_) => AlertDialog(title: const Text('训练完成'), content: const Text('太棒了！'), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('好的'))]));
  }

  @override
  Widget build(BuildContext context) {
    final m = _sec ~/ 60; final s = _sec % 60;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(widget.name), centerTitle: true),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Spacer(flex: 2),
        Text('${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}', style: const TextStyle(fontSize: 64, fontWeight: FontWeight.w200, color: AppColors.primary)),
        const SizedBox(height: 16),
        Text(_running ? '训练中...' : '准备开始', style: const TextStyle(color: AppColors.textHint, fontSize: 16)),
        const Spacer(),
        Padding(padding: const EdgeInsets.all(AppDimens.spacingMd), child: FilledButton(style: FilledButton.styleFrom(minimumSize: const Size(double.infinity, 56)), onPressed: () => setState(() { _running = !_running; if (_running) _tick(); }), child: Text(_running ? '暂停' : '开始训练'))),
        const SizedBox(height: 40),
      ]),
    );
  }
}

class WorkoutDetailScreen extends StatelessWidget {
  final String name;
  const WorkoutDetailScreen({super.key, required this.name});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: ListView(padding: const EdgeInsets.all(AppDimens.spacingMd), children: [
        Card(color: AppColors.surface, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), child: Padding(padding: const EdgeInsets.all(AppDimens.spacingLg), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('训练分解', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _step('1', '热身 (3 分钟)'), _step('2', '开合跳 45s x 3'), _step('3', '深蹲 15 x 3'),
          _step('4', '俯卧撑 10 x 3'), _step('5', '拉伸冷却 (3 分钟)'),
        ]))),
        const SizedBox(height: 12),
        Card(color: AppColors.surface, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), child: Padding(padding: const EdgeInsets.all(AppDimens.spacingLg), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('组间休息: 30s', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('预计消耗: 120 千卡 . 时长: 20 分钟', style: TextStyle(color: AppColors.textHint)),
        ]))),
      ]),
    );
  }
  Widget _step(String num, String desc) {
    return Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(children: [
      CircleAvatar(radius: 14, backgroundColor: AppColors.primary, child: Text(num, style: const TextStyle(color: Colors.white, fontSize: 12))),
      const SizedBox(width: 10), Text(desc),
    ]));
  }
}

class WorkoutHistoryScreen extends StatelessWidget {
  const WorkoutHistoryScreen({super.key});
  final _data = const [
    {'name': '上肢力量', 'date': '06-18', 'dur': '30', 'cal': '180'},
    {'name': '核心训练', 'date': '06-16', 'dur': '20', 'cal': '120'},
    {'name': '有氧燃脂', 'date': '06-14', 'dur': '25', 'cal': '200'},
    {'name': '拉伸放松', 'date': '06-12', 'dur': '15', 'cal': '60'},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('训练历史')),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppDimens.spacingMd),
        itemCount: _data.length, separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, i) {
          final r = _data[i];
          return ListTile(
            leading: const Icon(Icons.fitness_center_rounded, color: AppColors.primary),
            title: Text(r['name']!), subtitle: Text('${r['dur']} 分钟 . ${r['cal']} 千卡', style: const TextStyle(color: AppColors.textHint, fontSize: 12)),
            trailing: Text(r['date']!, style: const TextStyle(color: AppColors.textHint, fontSize: 12)),
          );
        },
      ),
    );
  }
}

class AIHealthScanResultScreen extends StatelessWidget {
  const AIHealthScanResultScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('扫描结果')),
      body: ListView(padding: const EdgeInsets.all(AppDimens.spacingMd), children: [
        _rc('心率', '72 bpm', Icons.favorite_rounded, AppColors.error),
        const SizedBox(height: 8),
        _rc('血氧', '98%', Icons.bloodtype_rounded, AppColors.success),
        const SizedBox(height: 8),
        _rc('压力', '中等', Icons.psychology_rounded, AppColors.warning),
        const SizedBox(height: 8),
        _rc('呼吸', '16 bpm', Icons.air_rounded, AppColors.primary),
        const SizedBox(height: 16),
        FilledButton(style: FilledButton.styleFrom(minimumSize: const Size(double.infinity, 48)), onPressed: () => context.pop(), child: const Text('完成')),
      ]),
    );
  }
  Widget _rc(String label, String value, IconData icon, Color color) {
    return Container(padding: const EdgeInsets.all(AppDimens.spacingMd), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)), child: Row(children: [
      Container(width: 48, height: 48, decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color)),
      const SizedBox(width: 12), Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
      Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
    ]));
  }
}

class SmartAdviceScreen extends StatelessWidget {
  const SmartAdviceScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('智能建议')),
      body: ListView(padding: const EdgeInsets.all(AppDimens.spacingMd), children: [
        Container(padding: const EdgeInsets.all(AppDimens.spacingLg), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.primary.withValues(alpha: 0.2))), child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('基于你的扫描结果', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 12),
          _AdviceItem(icon: Icons.favorite_rounded, text: '心率正常 (72 bpm), 建议保持规律有氧运动'),
          _AdviceItem(icon: Icons.water_drop_rounded, text: '饮水不足, 建议每日至少 8 杯水'),
          _AdviceItem(icon: Icons.bedtime_rounded, text: '睡眠质量中等, 建议早睡 30 分钟'),
          _AdviceItem(icon: Icons.directions_walk_rounded, text: '步数未达标, 建议每天增加 2000 步'),
        ])),
      ]),
    );
  }
}

class _AdviceItem extends StatelessWidget {
  final IconData icon; final String text;
  const _AdviceItem({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(bottom: 10), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, size: 18, color: AppColors.primary), const SizedBox(width: 8), Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
    ]));
  }
}

class HealthFullReportScreen extends StatelessWidget {
  const HealthFullReportScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('健康报告')),
      body: ListView(padding: const EdgeInsets.all(AppDimens.spacingMd), children: const [
        Text('本周健康报告', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 16),
        _ReportItem(icon: Icons.directions_walk_rounded, label: '总步数', value: '52,340 步', sub: '日均 7,477 步'),
        _ReportItem(icon: Icons.local_fire_department_rounded, label: '总卡路里', value: '10,850 千卡', sub: '日均 1,550 千卡'),
        _ReportItem(icon: Icons.bedtime_rounded, label: '平均睡眠', value: '7.2 小时', sub: '达标率 85%'),
        _ReportItem(icon: Icons.water_drop_rounded, label: '平均饮水', value: '4.5 杯', sub: '达标率 55%'),
        SizedBox(height: 16),
        Text('建议', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Text('1. 饮水需增加, 每天至少 8 杯', style: TextStyle(color: AppColors.textHint)),
        Text('2. 周三睡眠不足, 建议周末补觉', style: TextStyle(color: AppColors.textHint)),
        Text('3. 步数保持, 继续加油', style: TextStyle(color: AppColors.textHint)),
      ]),
    );
  }
}

class _ReportItem extends StatelessWidget {
  final IconData icon; final String label, value, sub;
  const _ReportItem({required this.icon, required this.label, required this.value, required this.sub});
  @override
  Widget build(BuildContext context) {
    return Card(color: AppColors.surface, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), child: ListTile(
      leading: Icon(icon, color: AppColors.primary), title: Text(label),
      subtitle: Text(sub, style: const TextStyle(color: AppColors.textHint, fontSize: 12)), trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
    ));
  }
}
