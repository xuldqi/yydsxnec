import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum BreathingPattern {
  boxBreathing(
    name: '箱式呼吸',
    description: '吸气4秒-保持4秒-呼气4秒-保持4秒',
    inhale: 4,
    hold: 4,
    exhale: 4,
    pause: 4,
  ),
  fourSevenEight(
    name: '4-7-8呼吸',
    description: '吸气4秒-保持7秒-呼气8秒',
    inhale: 4,
    hold: 7,
    exhale: 8,
    pause: 0,
  ),
  deepBreathing(
    name: '深度呼吸',
    description: '深吸气6秒-深呼气6秒',
    inhale: 6,
    hold: 0,
    exhale: 6,
    pause: 0,
  ),
  calmBreathing(
    name: '平静呼吸',
    description: '吸气5秒-保持2秒-呼气7秒-保持2秒',
    inhale: 5,
    hold: 2,
    exhale: 7,
    pause: 2,
  );

  const BreathingPattern({
    required this.name,
    required this.description,
    required this.inhale,
    required this.hold,
    required this.exhale,
    required this.pause,
  });

  final String name;
  final String description;
  final int inhale;
  final int hold;
  final int exhale;
  final int pause;
}

class BreathingExercisePage extends StatefulWidget {
  const BreathingExercisePage({super.key});

  @override
  State<BreathingExercisePage> createState() => _BreathingExercisePageState();
}

class _BreathingExercisePageState extends State<BreathingExercisePage>
    with TickerProviderStateMixin {
  BreathingPattern _selectedPattern = BreathingPattern.boxBreathing;
  BreathingPhase _currentPhase = BreathingPhase.inhale;
  int _totalCycles = 0;
  bool _isRunning = false;

  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this);
    _animController.addStatusListener(_onAnimationStatus);
    _updateAnimationForPhase();
  }

  void _onAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && _isRunning && mounted) {
      _advanceToNextPhase();
    }
  }

  void _updateAnimationForPhase() {
    final durationSec = _getPhaseDuration();
    final startScale = _getStartScale();
    final endScale = _getEndScale();

    if (durationSec <= 0) {
      _scaleAnimation = AlwaysStoppedAnimation(endScale);
      Future.microtask(() {
        if (_isRunning && mounted) _advanceToNextPhase();
      });
      return;
    }
    _animController.duration = Duration(seconds: durationSec);
    _scaleAnimation = Tween<double>(begin: startScale, end: endScale).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
    _animController.reset();
    _animController.forward();
  }

  int _getPhaseDuration() {
    switch (_currentPhase) {
      case BreathingPhase.inhale:
        return _selectedPattern.inhale;
      case BreathingPhase.hold:
        return _selectedPattern.hold;
      case BreathingPhase.exhale:
        return _selectedPattern.exhale;
      case BreathingPhase.pause:
        return _selectedPattern.pause;
    }
  }

  double _getStartScale() {
    switch (_currentPhase) {
      case BreathingPhase.inhale:
        return 0.35;
      case BreathingPhase.hold:
        return 1.0;
      case BreathingPhase.exhale:
        return 1.0;
      case BreathingPhase.pause:
        return 0.35;
    }
  }

  double _getEndScale() {
    switch (_currentPhase) {
      case BreathingPhase.inhale:
        return 1.0;
      case BreathingPhase.hold:
        return 1.0;
      case BreathingPhase.exhale:
        return 0.35;
      case BreathingPhase.pause:
        return 0.35;
    }
  }

  @override
  void dispose() {
    _animController.removeStatusListener(_onAnimationStatus);
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('呼吸练习'),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.pageHorizontalPadding,
              ),
              child: _PatternSelector(),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.pageHorizontalPadding,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final bubbleSize = math
                        .min(
                          constraints.maxWidth * 0.76,
                          constraints.maxHeight * 0.48,
                        )
                        .clamp(220.0, 320.0);

                    return Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: _BreathingBubble(size: bubbleSize),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 18),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _PhaseText(),
                                const SizedBox(height: 6),
                                _CycleCounter(),
                                const SizedBox(height: 22),
                                _Controls(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            _BottomInfo(),
          ],
        ),
      ),
    );
  }

  Widget _PatternSelector() {
    return ClipRect(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: BreathingPattern.values.map((pattern) {
            final isSelected = _selectedPattern == pattern;
            return Padding(
              padding: EdgeInsets.only(right: AppTheme.paddingS),
              child: GestureDetector(
                onTap: () {
                  if (_isRunning) return;
                  setState(() {
                    _selectedPattern = pattern;
                    _currentPhase = BreathingPhase.inhale;
                    _updateAnimationForPhase();
                  });
                },
                child: AnimatedContainer(
                  duration: AppTheme.shortAnimation,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.paddingM,
                    vertical: AppTheme.paddingS,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primaryColor
                        : AppTheme.cardBackground,
                    borderRadius: BorderRadius.circular(AppTheme.radiusL),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.primaryColor
                          : AppTheme.borderColor,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Text(
                    pattern.name,
                    maxLines: 1,
                    style: AppTheme.bodySmall.copyWith(
                      color: isSelected ? Colors.white : AppTheme.primaryText,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _BreathingBubble({double size = 240}) {
    return SizedBox(
      width: size,
      height: size,
      child: AnimatedBuilder(
        animation: _animController,
        builder: (context, _) {
          return CustomPaint(
            painter: _BreathingBubblePainter(
              scale: _scaleAnimation.value,
              phase: _currentPhase,
            ),
          );
        },
      ),
    );
  }

  Widget _PhaseText() {
    final phaseText = _currentPhase.text;
    return Text(
      phaseText,
      style: AppTheme.headlineLarge.copyWith(color: AppTheme.primaryColor),
    );
  }

  Widget _CycleCounter() {
    return Text(
      '已完成 $_totalCycles 个循环',
      style: AppTheme.bodyMedium.copyWith(color: AppTheme.secondaryText),
    );
  }

  Widget _Controls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: _isRunning ? _stopExercise : _startExercise,
          icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
          label: Text(_isRunning ? '暂停' : '开始'),
          style: ElevatedButton.styleFrom(
            backgroundColor: _isRunning
                ? AppTheme.sadColor
                : AppTheme.primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.paddingXL,
              vertical: AppTheme.paddingM,
            ),
          ),
        ),
      ],
    );
  }

  Widget _BottomInfo() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppTheme.paddingL),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        border: Border(top: BorderSide(color: AppTheme.borderColor)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _selectedPattern.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTheme.titleMedium.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: AppTheme.paddingS),
          Text(
            _selectedPattern.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTheme.bodySmall.copyWith(color: AppTheme.secondaryText),
          ),
        ],
      ),
    );
  }

  void _startExercise() {
    setState(() {
      _isRunning = true;
      _currentPhase = BreathingPhase.inhale;
      _updateAnimationForPhase();
    });
  }

  void _stopExercise() {
    _animController.stop();
    setState(() {
      _isRunning = false;
    });
  }

  void _advanceToNextPhase() {
    if (!_isRunning || !mounted) return;

    switch (_currentPhase) {
      case BreathingPhase.inhale:
        _currentPhase = BreathingPhase.hold;
        break;
      case BreathingPhase.hold:
        _currentPhase = BreathingPhase.exhale;
        break;
      case BreathingPhase.exhale:
        _currentPhase = BreathingPhase.pause;
        break;
      case BreathingPhase.pause:
        _totalCycles++;
        _currentPhase = BreathingPhase.inhale;
        break;
    }

    if (mounted) {
      setState(() {
        _updateAnimationForPhase();
      });
    }
  }
}

enum BreathingPhase {
  inhale('吸气'),
  hold('保持'),
  exhale('呼气'),
  pause('暂停');

  const BreathingPhase(this.text);
  final String text;
}

class _BreathingBubblePainter extends CustomPainter {
  final double scale;
  final BreathingPhase phase;

  const _BreathingBubblePainter({required this.scale, required this.phase});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = size.width / 2 - 22;
    final radius = baseRadius * scale;
    final phaseShift = switch (phase) {
      BreathingPhase.inhale => 0.0,
      BreathingPhase.hold => 0.9,
      BreathingPhase.exhale => 1.7,
      BreathingPhase.pause => 2.4,
    };

    final glowPaint = Paint()
      ..color = AppTheme.primaryColor.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 1.18, glowPaint);

    final bubblePath = Path();
    const points = 40;
    for (var i = 0; i <= points; i++) {
      final angle = (math.pi * 2 * i / points) - math.pi / 2;
      final wobble =
          1 +
          math.sin(angle * 3 + phaseShift) * 0.035 +
          math.cos(angle * 5 - phaseShift) * 0.022;
      final point = Offset(
        center.dx + math.cos(angle) * radius * wobble,
        center.dy + math.sin(angle) * radius * wobble,
      );
      if (i == 0) {
        bubblePath.moveTo(point.dx, point.dy);
      } else {
        bubblePath.lineTo(point.dx, point.dy);
      }
    }
    bubblePath.close();

    final rect = Rect.fromCircle(center: center, radius: radius * 1.1);
    final fillPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.32, -0.38),
        radius: 0.92,
        colors: [
          AppTheme.primaryColor.withValues(alpha: 0.72),
          AppTheme.primaryColor.withValues(alpha: 0.48),
          AppTheme.primaryColor.withValues(alpha: 0.30),
        ],
        stops: const [0.0, 0.58, 1.0],
      ).createShader(rect)
      ..style = PaintingStyle.fill;
    canvas.drawPath(bubblePath, fillPaint);

    final edgePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.42)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawPath(bubblePath, edgePaint);

    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.22)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
        center: center.translate(-radius * 0.28, -radius * 0.30),
        width: radius * 0.50,
        height: radius * 0.28,
      ),
      highlightPaint,
    );
  }

  @override
  bool shouldRepaint(_BreathingBubblePainter oldDelegate) {
    return oldDelegate.scale != scale || oldDelegate.phase != phase;
  }
}
