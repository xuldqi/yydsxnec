// 动作库 (对应 Android MovementLibraryActivity + MovementDetailActivity + MovementTimerActivity)
// 动作列表 + 详情 + 计时器

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/app_l10n_ext.dart';

class Movement {
  final String id, name, bodyPart, difficulty, equipment;
  final int durationSec, calories;
  final List<String> steps;
  final Color color;
  final IconData icon;
  const Movement({required this.id, required this.name, required this.bodyPart, required this.difficulty,
    required this.equipment, required this.durationSec, required this.calories, required this.steps,
    required this.color, required this.icon});
}

const _movements = <Movement>[
  Movement(id: 'm1', name: '标准俯卧撑', bodyPart: '胸/三头', difficulty: '入门', equipment: '无',
    durationSec: 60, calories: 8, color: AppColors.sportOther, icon: Icons.accessibility_rounded,
    steps: ['双手撑地，与肩同宽', '身体保持一条直线', '下降至胸部接近地面', '推起至起始位置', '重复 10-15 次']),
  Movement(id: 'm2', name: '徒手深蹲', bodyPart: '腿/臀', difficulty: '入门', equipment: '无',
    durationSec: 90, calories: 12, color: AppColors.sportRun, icon: Icons.airline_seat_legroom_normal_rounded,
    steps: ['双脚与肩同宽', '下蹲至大腿与地面平行', '保持膝盖不超过脚尖', '起身至站立', '重复 15-20 次']),
  Movement(id: 'm3', name: '平板支撑', bodyPart: '核心', difficulty: '入门', equipment: '无',
    durationSec: 60, calories: 5, color: AppColors.primary, icon: Icons.center_focus_strong_rounded,
    steps: ['俯撑姿势，前臂着地', '身体保持一条直线', '收紧核心', '保持 30-60 秒', '注意不要塌腰']),
  Movement(id: 'm4', name: '开合跳', bodyPart: '全身', difficulty: '入门', equipment: '无',
    durationSec: 60, calories: 15, color: AppColors.warning, icon: Icons.directions_run_rounded,
    steps: ['站立，双脚并拢', '跳起同时双脚分开，双手上举', '再次跳起回到起始', '保持节奏', '持续 30-60 秒']),
  Movement(id: 'm5', name: '卷腹', bodyPart: '腹肌', difficulty: '入门', equipment: '无',
    durationSec: 90, calories: 7, color: AppColors.warning, icon: Icons.accessibility_new_rounded,
    steps: ['仰卧，膝盖弯曲', '双手轻放头侧', '卷起上身至肩胛离地', '缓慢下降', '重复 15-20 次']),
  Movement(id: 'm6', name: '波比跳', bodyPart: '全身', difficulty: '进阶', equipment: '无',
    durationSec: 60, calories: 20, color: AppColors.error, icon: Icons.flash_on_rounded,
    steps: ['站立', '下蹲双手撑地', '双脚后跳成俯撑', '做一个俯卧撑', '双脚收回，向上跳起']),
  Movement(id: 'm7', name: '弓步蹲', bodyPart: '腿/臀', difficulty: '入门', equipment: '无',
    durationSec: 90, calories: 10, color: AppColors.sportOther, icon: Icons.directions_walk_rounded,
    steps: ['站立', '一腿向前迈出下蹲', '前腿大腿与地面平行', '后腿膝盖接近地面', '换腿重复']),
  Movement(id: 'm8', name: '俄罗斯转体', bodyPart: '核心/侧腹', difficulty: '入门', equipment: '无',
    durationSec: 60, calories: 8, color: AppColors.sportRide, icon: Icons.swap_horiz_rounded,
    steps: ['坐姿，膝盖弯曲', '上身微微后倾', '双手抱拳左右转动', '尽量触地', '保持节奏']),
  Movement(id: 'm9', name: '高抬腿', bodyPart: '腿/心肺', difficulty: '入门', equipment: '无',
    durationSec: 60, calories: 13, color: AppColors.sportOther, icon: Icons.trending_up_rounded,
    steps: ['原地站立', '快速交替抬腿', '膝盖尽量抬高', '摆臂配合', '持续 30-60 秒']),
];

class MovementLibraryScreen extends StatelessWidget {
  const MovementLibraryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context).s;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l.movementLibrary),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(AppDimens.spacingMd),
        childAspectRatio: 0.85,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        children: _movements.map((m) => MovementCard(m: m, l: l)).toList(),
      ),
    );
  }
}

class MovementCard extends StatelessWidget {
  final Movement m;
  final AppL10nStrings l;
  const MovementCard({required this.m, required this.l});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MovementDetailScreen(movement: m))),
      borderRadius: BorderRadius.circular(AppDimens.radiusCard),
      child: Container(
        padding: const EdgeInsets.all(AppDimens.spacingSm),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: m.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(m.icon, color: m.color, size: 22),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: m.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(m.difficulty, style: TextStyle(color: m.color, fontSize: 10, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(m.name, style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(m.bodyPart, style: const TextStyle(color: AppColors.textHint, fontSize: 11)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.local_fire_department_rounded, size: 11, color: AppColors.warning),
                    const SizedBox(width: 2),
                    Text('${m.calories} kcal', style: const TextStyle(color: AppColors.textHint, fontSize: 11)),
                    const SizedBox(width: 8),
                    const Icon(Icons.access_time_rounded, size: 11, color: AppColors.textHint),
                    const SizedBox(width: 2),
                    Text('${m.durationSec}s', style: const TextStyle(color: AppColors.textHint, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MovementDetailScreen extends StatelessWidget {
  final Movement movement;
  const MovementDetailScreen({super.key, required this.movement});
  @override
  Widget build(BuildContext context) {
    final m = movement;
    final l = AppL10n.of(context).s;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(m.name),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimens.spacingMd),
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimens.spacingLg),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [m.color, m.color.withValues(alpha: 0.7)],
              ),
              borderRadius: BorderRadius.circular(AppDimens.radiusCard),
            ),
            child: Column(
              children: [
                Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Icon(m.icon, color: m.color, size: 40),
                ),
                const SizedBox(height: 10),
                Text(m.name, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('${m.bodyPart} · ${m.difficulty} · ${m.equipment}',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 12)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _info(l.duration, '${m.durationSec}s'),
                    _info(l.calories, '${m.calories} kcal'),
                    _info(l.equipment, m.equipment),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(l.actionSteps, style: const TextStyle(color: AppColors.textPrimary, fontSize: 17, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(AppDimens.spacingMd),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimens.radiusCard),
            ),
            child: Column(
              children: m.steps.asMap().entries.map((e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24, height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: m.color.withValues(alpha: 0.15),
                      ),
                      alignment: Alignment.center,
                      child: Text('${e.key + 1}',
                        style: TextStyle(color: m.color, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: Text(e.value,
                      style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, height: 1.5))),
                  ],
                ),
              )).toList(),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity, height: 52,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (_) => MovementTimerScreen(movement: m),
                ));
              },
              icon: const Icon(Icons.play_arrow_rounded, size: 24),
              label: Text(l.startTraining, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: m.color,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
              ),
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _info(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 11)),
      ],
    );
  }
}

class MovementTimerScreen extends StatefulWidget {
  final Movement movement;
  const MovementTimerScreen({super.key, required this.movement});
  @override
  State<MovementTimerScreen> createState() => _MovementTimerScreenState();
}

class _MovementTimerScreenState extends State<MovementTimerScreen> {
  late int _remaining;
  Timer? _timer;
  bool _running = false;
  int _currentStep = 0;
  int _totalSets = 1;
  int _completedSets = 0;

  @override
  void initState() {
    super.initState();
    _remaining = widget.movement.durationSec;
    _totalSets = 3;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _start() {
    setState(() => _running = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        _remaining--;
        if (_remaining <= 0) {
          _completedSets++;
          if (_completedSets >= _totalSets) {
            _running = false;
            t.cancel();
            _finish();
          } else {
            _remaining = widget.movement.durationSec;
            _currentStep = (_currentStep + 1) % widget.movement.steps.length;
            HapticFeedback.heavyImpact();
          }
        }
      });
    });
  }

  void _pause() {
    setState(() => _running = false);
    _timer?.cancel();
  }

  void _finish() {
    showDialog(context: context, builder: (_) => AlertDialog(
      backgroundColor: AppColors.surface,
      title: const Row(children: [
        Icon(Icons.emoji_events_rounded, color: AppColors.success),
        SizedBox(width: 8),
        Text('训练完成'),
      ]),
      content: Text('完成 ${widget.movement.name} ${_totalSets} 组\n消耗约 ${widget.movement.calories * _totalSets} 千卡'),
      actions: [
        TextButton(onPressed: () => Navigator.popUntil(context, (r) => r.isFirst), child: const Text('完成')),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    final m = widget.movement;
    final l = AppL10n.of(context).s;
    return Scaffold(
      backgroundColor: m.color,
      body: SafeArea(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
              title: Text(m.name, style: const TextStyle(color: Colors.white)),
            ),
            const Spacer(),
            // 大圆
            SizedBox(
              width: 240, height: 240,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 240, height: 240,
                    child: CircularProgressIndicator(
                      value: _remaining / m.durationSec,
                      strokeWidth: 10,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      valueColor: const AlwaysStoppedAnimation(Colors.white),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${_remaining ~/ 60}:${(_remaining % 60).toString().padLeft(2, '0')}',
                        style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold,
                          fontFeatures: [FontFeature.tabularFigures()])),
                      const SizedBox(height: 4),
                      Text('第 ${_completedSets + 1} / $_totalSets ${l.sets}',
                        style: const TextStyle(color: Colors.white70, fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // 当前步骤
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(AppDimens.spacingMd),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text('${l.step} ${_currentStep + 1}',
                    style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(m.steps[_currentStep],
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous_rounded, color: Colors.white, size: 36),
                  onPressed: () => setState(() {
                    _currentStep = (_currentStep - 1 + m.steps.length) % m.steps.length;
                  }),
                ),
                FloatingActionButton(
                  onPressed: _running ? _pause : _start,
                  backgroundColor: Colors.white,
                  foregroundColor: m.color,
                  child: Icon(_running ? Icons.pause_rounded : Icons.play_arrow_rounded, size: 36),
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next_rounded, color: Colors.white, size: 36),
                  onPressed: () => setState(() {
                    _currentStep = (_currentStep + 1) % m.steps.length;
                  }),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class GuidedWorkoutScreen extends ConsumerStatefulWidget {
  const GuidedWorkoutScreen({super.key});
  @override
  ConsumerState<GuidedWorkoutScreen> createState() => _GuidedWorkoutScreenState();
}

class _GuidedWorkoutScreenState extends ConsumerState<GuidedWorkoutScreen> {
  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context).s;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(l.guidedWorkout), backgroundColor: AppColors.surface, elevation: 0),
      body: ListView(
        padding: const EdgeInsets.all(AppDimens.spacingMd),
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimens.spacingLg),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [AppColors.sportOther, AppColors.warning],
              ),
              borderRadius: BorderRadius.circular(AppDimens.radiusCard),
            ),
            child: Column(
              children: [
                const Icon(Icons.play_lesson_rounded, color: Colors.white, size: 48),
                const SizedBox(height: 8),
                Text(l.guidedWorkout, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(l.guidedWorkoutSub,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ..._movements.take(5).map((m) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(AppDimens.spacingSm),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: m.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(m.icon, color: m.color, size: 22),
              ),
              title: Text(m.name, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
              subtitle: Text('${m.durationSec}s · ${m.calories} kcal', style: const TextStyle(color: AppColors.textHint, fontSize: 12)),
              trailing: const Icon(Icons.play_arrow_rounded, color: AppColors.primary),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MovementDetailScreen(movement: m))),
            ),
          )),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class ExerciseTrackingScreen extends ConsumerStatefulWidget {
  const ExerciseTrackingScreen({super.key});
  @override
  ConsumerState<ExerciseTrackingScreen> createState() => _ExerciseTrackingScreenState();
}

class _ExerciseTrackingScreenState extends ConsumerState<ExerciseTrackingScreen> {
  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context).s;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(l.exerciseTracking), backgroundColor: AppColors.surface, elevation: 0),
      body: ListView(
        padding: const EdgeInsets.all(AppDimens.spacingMd),
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimens.spacingXl),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [AppColors.sportRun, AppColors.sportOther],
              ),
              borderRadius: BorderRadius.circular(AppDimens.radiusCard),
            ),
            child: Column(
              children: [
                const Icon(Icons.directions_run_rounded, color: Colors.white, size: 48),
                const SizedBox(height: 8),
                Text('24:35', style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold,
                  fontFeatures: [FontFeature.tabularFigures()])),
                const SizedBox(height: 4),
                const Text('运动时长', style: TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _metric(Icons.route_rounded, '3.42', 'km'),
                    _metric(Icons.local_fire_department_rounded, '256', 'kcal'),
                    _metric(Icons.directions_walk_rounded, '4,820', '步'),
                    _metric(Icons.speed_rounded, '5.2', 'min/km'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(l.realTimeTrack, style: const TextStyle(color: AppColors.textPrimary, fontSize: 17, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimens.radiusCard),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDimens.radiusCard),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                    colors: [AppColors.sportRun.withValues(alpha: 0.1), AppColors.sportWalk.withValues(alpha: 0.1)],
                  ),
                ),
                child: CustomPaint(
                  painter: _MapPainter(),
                  child: Container(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.stop_rounded),
                label: Text(l.stop, style: const TextStyle(fontSize: 14)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              )),
              const SizedBox(width: 10),
              Expanded(child: ElevatedButton.icon(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('已暂停')),
                ),
                icon: const Icon(Icons.pause_rounded),
                label: Text(l.pause, style: const TextStyle(fontSize: 14)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              )),
            ],
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _metric(IconData icon, String value, String unit) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(width: 2),
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(unit, style: const TextStyle(color: Colors.white70, fontSize: 10)),
            ),
          ],
        ),
      ],
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 网格背景
    final grid = Paint()..color = AppColors.primary.withValues(alpha: 0.1)..strokeWidth = 0.5;
    for (double x = 0; x < size.width; x += 30) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = 0; y < size.height; y += 30) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    // 路径
    final path = Path();
    final pts = [Offset(0.05, 0.85), Offset(0.15, 0.75), Offset(0.25, 0.80), Offset(0.35, 0.55),
                 Offset(0.45, 0.45), Offset(0.55, 0.50), Offset(0.65, 0.30), Offset(0.75, 0.20),
                 Offset(0.85, 0.25), Offset(0.95, 0.10)];
    final realPts = pts.map((p) => Offset(p.dx * size.width, p.dy * size.height)).toList();
    for (int i = 0; i < realPts.length; i++) {
      if (i == 0) path.moveTo(realPts[i].dx, realPts[i].dy);
      else path.lineTo(realPts[i].dx, realPts[i].dy);
    }
    final paint = Paint()
      ..color = AppColors.sportRun
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, paint);
    // 起终点
    canvas.drawCircle(realPts.first, 6, Paint()..color = AppColors.success);
    canvas.drawCircle(realPts.last, 6, Paint()..color = AppColors.error);
  }
  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
