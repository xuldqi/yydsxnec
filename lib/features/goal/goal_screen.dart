import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/services/step_provider.dart' as svc;
import '../../core/theme/app_colors.dart';

class GoalScreen extends ConsumerStatefulWidget {
  const GoalScreen({super.key});
  @override
  ConsumerState<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends ConsumerState<GoalScreen> {
  int _stepGoal = 10000;
  int _waterGoal = 2000;
  int _sleepGoal = 480;
  int _calGoal = 2000;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _stepGoal = p.getInt('step_goal') ?? 10000;
      _waterGoal = p.getInt('water_goal') ?? 2000;
      _sleepGoal = p.getInt('sleep_goal') ?? 480;
      _calGoal = p.getInt('cal_goal') ?? 2000;
    });
  }

  Future<void> _editGoal(String key, int cur, int min, int max, int step) async {
    final ctrl = TextEditingController(text: cur.toString());
    final d = await showDialog<int>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('设置目标', style: TextStyle(color: Color(0xFF1E1B4B), fontWeight: FontWeight.bold)),
        content: Row(children: [
          IconButton(onPressed: () => ctrl.text = ((int.tryParse(ctrl.text) ?? cur) - step).clamp(min, max).toString(), icon: const Icon(Icons.remove_circle_outline, color: Color(0xFF6366F1))),
          Expanded(child: TextField(controller: ctrl, keyboardType: TextInputType.number, textAlign: TextAlign.center, style: const TextStyle(fontSize: 28, color: Color(0xFF1E1B4B), fontWeight: FontWeight.bold), decoration: const InputDecoration(border: InputBorder.none))),
          IconButton(onPressed: () => ctrl.text = ((int.tryParse(ctrl.text) ?? cur) + step).clamp(min, max).toString(), icon: const Icon(Icons.add_circle_outline, color: Color(0xFF6366F1))),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消', style: TextStyle(color: Color(0xFF94A3B8)))),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFF6366F1)),
            onPressed: () => Navigator.pop(context, int.tryParse(ctrl.text) ?? cur),
            child: const Text('确定'),
          ),
        ],
      ),
    );
    if (d != null) {
      final p = await SharedPreferences.getInstance();
      await p.setInt(key, d);
      setState(() { switch (key) { case 'step_goal': _stepGoal = d; case 'water_goal': _waterGoal = d; case 'sleep_goal': _sleepGoal = d; case 'cal_goal': _calGoal = d; }});
    }
  }

  @override
  Widget build(BuildContext context) {
    final stepAsync = ref.watch(svc.stepProvider);
    final today = stepAsync.valueOrNull?.todaySteps ?? 8256;
    final pct = (today / _stepGoal).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F8),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEFEBFA), Color(0xFFF3F4F8), Color(0xFFEBEFF9)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 110),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('目标', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF1E1B4B))),
              const SizedBox(height: 16),

              // 步数目标大环
              _WhiteWidgetCard(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                  child: Column(children: [
                    Stack(alignment: Alignment.center, children: [
                      SizedBox(
                        width: 190, height: 190,
                        child: CircularProgressIndicator(
                          value: pct,
                          strokeWidth: 14,
                          backgroundColor: const Color(0xFFF1F5F9),
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      Column(mainAxisSize: MainAxisSize.min, children: [
                        Text('$today', style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: Color(0xFF1E1B4B))),
                        Text('目标 $_stepGoal', style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(color: const Color(0xFF6366F1).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                          child: Text('${(pct * 100).toInt()}%', style: const TextStyle(color: Color(0xFF6366F1), fontWeight: FontWeight.w800, fontSize: 13)),
                        ),
                      ]),
                    ]),
                    const SizedBox(height: 16),
                    Text('建议每日 ${_stepGoal - 2000}~${_stepGoal + 2000} 步', style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                  ]),
                ),
              ),
              const SizedBox(height: 16),

              // 3个副目标小环
              Row(children: [
                Expanded(child: _MiniGoalCard(title: '卡路里', sub: '千卡', cur: 312, goal: _calGoal, color: const Color(0xFFF97316), onTap: () => _editGoal('cal_goal', _calGoal, 1000, 5000, 100))),
                const SizedBox(width: 10),
                Expanded(child: _MiniGoalCard(title: '饮水', sub: 'ml', cur: 1200, goal: _waterGoal, color: const Color(0xFF0EA5E9), onTap: () => _editGoal('water_goal', _waterGoal, 500, 4000, 250))),
                const SizedBox(width: 10),
                Expanded(child: _MiniGoalCard(title: '睡眠', sub: '分钟', cur: 468, goal: _sleepGoal, color: const Color(0xFF818CF8), onTap: () => _editGoal('sleep_goal', _sleepGoal, 300, 720, 30))),
              ]),
              const SizedBox(height: 20),

              // 近7日柱状图
              _WhiteWidgetCard(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('近 7 日步数', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1B4B))),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 140,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: 12000,
                          barTouchData: BarTouchData(enabled: false),
                          titlesData: FlTitlesData(
                            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (v, m) {
                                  const days = ['一', '二', '三', '四', '五', '六', '日'];
                                  final i = v.toInt();
                                  if (i >= 0 && i < days.length) {
                                    return Padding(padding: const EdgeInsets.only(top: 6), child: Text(days[i], style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)));
                                  }
                                  return const SizedBox();
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          gridData: const FlGridData(show: false),
                          barGroups: [
                            _bar(0, 6200, false), _bar(1, 8400, false), _bar(2, 10200, true),
                            _bar(3, 7100, false), _bar(4, 11500, false), _bar(5, 9300, false), _bar(6, 7800, false),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
              const SizedBox(height: 20),

              // 目标中心
              _WhiteWidgetCard(
                child: Column(children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Row(children: [
                      Text('目标中心', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1B4B))),
                    ]),
                  ),
                  _tile(Icons.fitness_center, '训练计划', () => context.push('/training-plan')),
                  _tile(Icons.task_alt, '任务中心', () => context.push('/task-center')),
                  _tile(Icons.monitor_weight_outlined, '体重目标', () => context.push('/weight')),
                  _tile(Icons.local_fire_department_outlined, '热量目标', () => context.push('/calorie')),
                ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  BarChartGroupData _bar(int x, double y, bool isHighlight) {
    return BarChartGroupData(x: x, barRods: [
      BarChartRodData(
        toY: y,
        gradient: LinearGradient(
          colors: isHighlight
              ? [const Color(0xFF6366F1), const Color(0xFF818CF8)]
              : [const Color(0xFFCBD5E1), const Color(0xFF94A3B8)],
          begin: Alignment.bottomCenter, end: Alignment.topCenter,
        ),
        width: 14,
        borderRadius: BorderRadius.circular(6),
      )
    ]);
  }

  Widget _tile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(color: const Color(0xFF6366F1).withValues(alpha: 0.1), shape: BoxShape.circle),
        child: Icon(icon, color: const Color(0xFF6366F1), size: 18),
      ),
      title: Text(title, style: const TextStyle(color: Color(0xFF1E1B4B), fontSize: 14, fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right, color: Color(0xFFCBD5E1), size: 18),
      onTap: onTap,
    );
  }
}

class _WhiteWidgetCard extends StatelessWidget {
  final Widget child;
  const _WhiteWidgetCard({required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(color: Color(0x0A000000), blurRadius: 16, offset: Offset(0, 4)),
        ],
      ),
      child: child,
    );
  }
}

class _MiniGoalCard extends StatelessWidget {
  final String title, sub;
  final int cur, goal;
  final Color color;
  final VoidCallback onTap;
  const _MiniGoalCard({required this.title, required this.sub, required this.cur, required this.goal, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final pct = (cur / goal).clamp(0.0, 1.0);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(color: Color(0x0A000000), blurRadius: 14, offset: Offset(0, 4)),
          ],
        ),
        child: Column(children: [
          Stack(alignment: Alignment.center, children: [
            SizedBox(
              width: 54, height: 54,
              child: CircularProgressIndicator(
                value: pct, strokeWidth: 5,
                backgroundColor: const Color(0xFFF1F5F9),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                strokeCap: StrokeCap.round,
              ),
            ),
            Text('$cur', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF1E1B4B))),
          ]),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E1B4B))),
          Text('/$goal $sub', style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
        ]),
      ),
    );
  }
}
