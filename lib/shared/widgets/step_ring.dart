import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class StepRing extends StatelessWidget {
  final int steps;
  final int goal;
  final double size;

  const StepRing({
    super.key,
    required this.steps,
    required this.goal,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (steps / goal).clamp(0.0, 1.0);
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingPainter(progress: progress),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${(progress * 100).toInt()}%',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
              const SizedBox(height: 2),
              const Text('完成', style: TextStyle(
                color: AppColors.textHint,
                fontSize: 11,
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  _RingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 10;
    const strokeWidth = 10.0;

    // 背景环
    final bgPaint = Paint()
      ..color = AppColors.surfaceVariant
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // 进度环
    final progressPaint = Paint()
      ..shader = const LinearGradient(
        colors: [AppColors.primary, AppColors.primaryLight],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress;
}
