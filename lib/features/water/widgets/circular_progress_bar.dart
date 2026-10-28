import 'dart:math';
import 'package:flutter/material.dart';

class CircularProgressBar extends StatelessWidget {
  final double progress; // 0.0 ~ 1.0
  final String valueText; // 中间的主要数值字串，如 "3"
  final String labelText; // 下方的标签字串，如 "75%"
  final Color progressColor; // 进度的彩圈颜色
  final Color backgroundColor; // 进度的背景底圈颜色
  final double size; // 整个圆的大小，默认 90.0
  final double strokeWidth; // 圈宽度，默认 7.0

  const CircularProgressBar({
    super.key,
    required this.progress,
    required this.valueText,
    required this.labelText,
    required this.progressColor,
    required this.backgroundColor,
    this.size = 90.0,
    this.strokeWidth = 7.5,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          // 1. 底圈与进度圈绘制
          Positioned.fill(
            child: CustomPaint(
              painter: _CircularProgressPainter(
                progress: progress,
                progressColor: progressColor,
                backgroundColor: backgroundColor,
                strokeWidth: strokeWidth,
              ),
            ),
          ),
          // 2. 中间文字内容
          Positioned.fill(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    valueText,
                    style: TextStyle(
                      fontSize: size > 80 ? 18 : 13.5,
                      fontWeight: FontWeight.bold,
                      color: progressColor.darken(0.15),
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    labelText,
                    style: TextStyle(
                      fontSize: size > 80 ? 10.5 : 8.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color progressColor;
  final Color backgroundColor;
  final double strokeWidth;

  _CircularProgressPainter({
    required this.progress,
    required this.progressColor,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (min(size.width, size.height) - strokeWidth) / 2;

    // 绘制背景底轨圈
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, bgPaint);

    // 绘制当前进度圈（从顶部 -90 度开始）
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round; // 圆角端点，精致拟物

    final sweepAngle = 2 * pi * progress.clamp(0.0, 1.0);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // 顶部起点
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

// 辅助暗化颜色的扩展方法
extension on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}
