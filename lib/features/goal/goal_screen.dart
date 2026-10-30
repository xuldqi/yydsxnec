import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/services/step_provider.dart' as svc;

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

  Future<void> _editGoal(String title, String key, int cur, int min, int max, int step, String unit) async {
    final ctrl = TextEditingController(text: cur.toString());
    final d = await showDialog<int>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              title: Text(
                '设置$title',
                style: const TextStyle(
                  color: Color(0xFF2D2522),
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '可输入或点击按钮调节 ($min ~ $max $unit)',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF7D726D)),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          final val = (int.tryParse(ctrl.text) ?? cur) - step;
                          final clamped = val.clamp(min, max);
                          ctrl.text = clamped.toString();
                          setDialogState(() {});
                        },
                        icon: const Icon(Icons.remove_circle_outline_rounded, color: Color(0xFF8D5B4C), size: 30),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 110,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F8),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFECE4D8)),
                        ),
                        child: TextField(
                          controller: ctrl,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            color: Color(0xFF2D2522),
                            fontWeight: FontWeight.w900,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            suffixText: unit,
                            suffixStyle: const TextStyle(fontSize: 12, color: Color(0xFF7D726D)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () {
                          final val = (int.tryParse(ctrl.text) ?? cur) + step;
                          final clamped = val.clamp(min, max);
                          ctrl.text = clamped.toString();
                          setDialogState(() {});
                        },
                        icon: const Icon(Icons.add_circle_outline_rounded, color: Color(0xFF8D5B4C), size: 30),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('取消', style: TextStyle(color: Color(0xFF7D726D), fontWeight: FontWeight.bold)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8D5B4C),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    final entered = int.tryParse(ctrl.text) ?? cur;
                    Navigator.pop(dialogContext, entered.clamp(min, max));
                  },
                  child: const Text('保存', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
    if (d != null) {
      final p = await SharedPreferences.getInstance();
      await p.setInt(key, d);
      setState(() {
        switch (key) {
          case 'step_goal':
            _stepGoal = d;
            break;
          case 'water_goal':
            _waterGoal = d;
            break;
          case 'sleep_goal':
            _sleepGoal = d;
            break;
          case 'cal_goal':
            _calGoal = d;
            break;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final stepAsync = ref.watch(svc.stepProvider);
    final today = stepAsync.valueOrNull?.todaySteps ?? 8256;
    final pct = (today / _stepGoal).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F8),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top Bar with Back Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go('/profile');
                      }
                    },
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFECE4D8), width: 1.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x087A533E),
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Color(0xFF2D2522),
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    '目标管理',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF2D2522),
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 步数目标大环（支持点击设置目标）
                    GestureDetector(
                      onTap: () => _editGoal('每日步数目标', 'step_goal', _stepGoal, 1000, 50000, 1000, '步'),
                      child: _WhiteWidgetCard(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    '今日步数进度',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF2D2522),
                                    ),
                                  ),
                                  Row(
                                    children: const [
                                      Text(
                                        '点击修改目标',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF8D5B4C),
                                        ),
                                      ),
                                      SizedBox(width: 2),
                                      Icon(Icons.edit_outlined, size: 14, color: Color(0xFF8D5B4C)),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: 190,
                                    height: 190,
                                    child: CircularProgressIndicator(
                                      value: pct,
                                      strokeWidth: 14,
                                      backgroundColor: const Color(0xFFE5DDD5),
                                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2E7D5B)),
                                      strokeCap: StrokeCap.round,
                                    ),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '$today',
                                        style: const TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.w900,
                                          color: Color(0xFF2D2522),
                                        ),
                                      ),
                                      Text(
                                        '目标 $_stepGoal 步',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF7D726D),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEBF7EE),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          '${(pct * 100).toInt()}%',
                                          style: const TextStyle(
                                            color: Color(0xFF2E7D5B),
                                            fontWeight: FontWeight.w900,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                '建议每日保持 ${_stepGoal - 2000 > 0 ? _stepGoal - 2000 : 2000}~${_stepGoal + 2000} 步',
                                style: const TextStyle(fontSize: 12, color: Color(0xFF7D726D)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 3个副目标小环（点击均可设置对应目标）
                    Row(
                      children: [
                        Expanded(
                          child: _MiniGoalCard(
                            title: '卡路里',
                            sub: '千卡',
                            cur: 312,
                            goal: _calGoal,
                            color: const Color(0xFFF97316),
                            onTap: () => _editGoal('卡路里目标', 'cal_goal', _calGoal, 1000, 5000, 100, '千卡'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _MiniGoalCard(
                            title: '饮水',
                            sub: 'ml',
                            cur: 1200,
                            goal: _waterGoal,
                            color: const Color(0xFF0EA5E9),
                            onTap: () => _editGoal('饮水目标', 'water_goal', _waterGoal, 500, 4000, 250, 'ml'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _MiniGoalCard(
                            title: '睡眠',
                            sub: '分钟',
                            cur: 468,
                            goal: _sleepGoal,
                            color: const Color(0xFF8B5CF6),
                            onTap: () => _editGoal('睡眠目标', 'sleep_goal', _sleepGoal, 300, 720, 30, '分钟'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 近7日柱状图
                    _WhiteWidgetCard(
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '近 7 日步数趋势',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF2D2522),
                              ),
                            ),
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
                                            return Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                                                days[i],
                                                style: const TextStyle(
                                                  color: Color(0xFF7D726D),
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            );
                                          }
                                          return const SizedBox();
                                        },
                                      ),
                                    ),
                                  ),
                                  borderData: FlBorderData(show: false),
                                  gridData: const FlGridData(show: false),
                                  barGroups: [
                                    _bar(0, 6200, false),
                                    _bar(1, 8400, false),
                                    _bar(2, 10200, true),
                                    _bar(3, 7100, false),
                                    _bar(4, 11500, false),
                                    _bar(5, 9300, false),
                                    _bar(6, 7800, false),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 目标关联服务
                    _WhiteWidgetCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: Text(
                              '目标中心',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF2D2522),
                              ),
                            ),
                          ),
                          _tile(Icons.fitness_center_rounded, '训练计划', () => context.push('/training-plan')),
                          _tile(Icons.task_alt_rounded, '任务中心', () => context.push('/task-center')),
                          _tile(Icons.monitor_weight_outlined, '体重目标', () => context.push('/weight')),
                          _tile(Icons.local_fire_department_outlined, '热量目标', () => context.push('/calorie')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
              ? [const Color(0xFF2E7D5B), const Color(0xFF48BB78)]
              : [const Color(0xFFE5DDD5), const Color(0xFFECE4D8)],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
        width: 14,
        borderRadius: BorderRadius.circular(6),
      )
    ]);
  }

  Widget _tile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFFAF7F5),
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFECE4D8)),
        ),
        child: Icon(icon, color: const Color(0xFF8D5B4C), size: 18),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF2D2522),
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFF8D5B4C), size: 18),
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
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFECE4D8), width: 1.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0x087A533E),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
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
  const _MiniGoalCard({
    required this.title,
    required this.sub,
    required this.cur,
    required this.goal,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final pct = (cur / goal).clamp(0.0, 1.0);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFECE4D8), width: 1.0),
          boxShadow: const [
            BoxShadow(
              color: Color(0x087A533E),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 52,
                  height: 52,
                  child: CircularProgressIndicator(
                    value: pct,
                    strokeWidth: 5,
                    backgroundColor: const Color(0xFFE5DDD5),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Text(
                  '$cur',
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF2D2522),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2D2522),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '/$goal $sub',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Color(0xFF7D726D),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
