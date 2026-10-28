import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:steps_webu_flutter/core/theme/app_colors.dart';

/// 环形进度指示器组件
class CircularProgressRing extends StatefulWidget {
  final double progress; // 进度值 0.0 - 1.0
  final double size; // 组件大小
  final double strokeWidth; // 线条宽度
  final Color? progressColor; // 进度颜色
  final Color? backgroundColor; // 背景颜色
  final Gradient? gradient; // 渐变色
  final Widget? child; // 中心内容
  final bool animated; // 是否启用动画
  final Duration animationDuration; // 动画持续时间
  final bool showPercentage; // 是否显示百分比
  final TextStyle? percentageStyle; // 百分比文字样式

  const CircularProgressRing({
    super.key,
    required this.progress,
    this.size = 120.0,
    this.strokeWidth = 8.0,
    this.progressColor,
    this.backgroundColor,
    this.gradient,
    this.child,
    this.animated = true,
    this.animationDuration = const Duration(milliseconds: 1000),
    this.showPercentage = false,
    this.percentageStyle,
  });

  @override
  State<CircularProgressRing> createState() => _CircularProgressRingState();
}

class _CircularProgressRingState extends State<CircularProgressRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: widget.progress).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    if (widget.animated) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(CircularProgressRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _animation =
          Tween<double>(
            begin: oldWidget.progress,
            end: widget.progress,
          ).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Curves.easeInOut,
            ),
          );

      if (widget.animated) {
        _animationController.reset();
        _animationController.forward();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 进度环
          widget.animated
              ? AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return CustomPaint(
                      size: Size(widget.size, widget.size),
                      painter: CircularProgressPainter(
                        progress: _animation.value,
                        strokeWidth: widget.strokeWidth,
                        progressColor:
                            widget.progressColor ?? AppColors.primary,
                        backgroundColor:
                            widget.backgroundColor ??
                            (isDark
                                ? Color(0xFF1E293B)
                                : AppColors.divider),
                        gradient: widget.gradient,
                      ),
                    );
                  },
                )
              : CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: CircularProgressPainter(
                    progress: widget.progress,
                    strokeWidth: widget.strokeWidth,
                    progressColor: widget.progressColor ?? AppColors.primary,
                    backgroundColor:
                        widget.backgroundColor ??
                        (isDark ? Color(0xFF1E293B) : AppColors.divider),
                    gradient: widget.gradient,
                  ),
                ),

          // 中心内容
          if (widget.child != null)
            widget.child!
          else if (widget.showPercentage)
            widget.animated
                ? AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Text(
                        '${(_animation.value * 100).round()}%',
                        style:
                            widget.percentageStyle ??
                            Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white
                                  : AppColors.textPrimary,
                            ),
                      );
                    },
                  )
                : Text(
                    '${(widget.progress * 100).round()}%',
                    style:
                        widget.percentageStyle ??
                        Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.white
                              : AppColors.textPrimary,
                        ),
                  ),
        ],
      ),
    );
  }
}

/// 环形进度绘制器
class CircularProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color progressColor;
  final Color backgroundColor;
  final Gradient? gradient;

  CircularProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.progressColor,
    required this.backgroundColor,
    this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // 绘制背景圆环
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // 绘制进度圆环
    final progressPaint = Paint()
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    if (gradient != null) {
      // 使用渐变色
      final rect = Rect.fromCircle(center: center, radius: radius);
      progressPaint.shader = gradient!.createShader(rect);
    } else {
      progressPaint.color = progressColor;
    }

    // 计算进度弧度
    const startAngle = -math.pi / 2; // 从顶部开始
    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.gradient != gradient;
  }
}

/// 多层环形进度指示器
class MultiLayerProgressRing extends StatelessWidget {
  final List<ProgressLayer> layers;
  final double size;
  final Widget? child;

  const MultiLayerProgressRing({
    super.key,
    required this.layers,
    this.size = 120.0,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 绘制所有层
          ...layers.asMap().entries.map((entry) {
            final index = entry.key;
            final layer = entry.value;
            final layerSize = size - (index * layer.strokeWidth * 2.5);

            return CircularProgressRing(
              progress: layer.progress,
              size: layerSize,
              strokeWidth: layer.strokeWidth,
              progressColor: layer.color,
              backgroundColor: layer.backgroundColor,
              gradient: layer.gradient,
              animated: layer.animated,
              animationDuration: layer.animationDuration,
            );
          }),

          // 中心内容
          if (child != null) child!,
        ],
      ),
    );
  }
}

/// 进度层配置
class ProgressLayer {
  final double progress;
  final double strokeWidth;
  final Color color;
  final Color? backgroundColor;
  final Gradient? gradient;
  final bool animated;
  final Duration animationDuration;

  const ProgressLayer({
    required this.progress,
    this.strokeWidth = 6.0,
    required this.color,
    this.backgroundColor,
    this.gradient,
    this.animated = true,
    this.animationDuration = const Duration(milliseconds: 1000),
  });
}
