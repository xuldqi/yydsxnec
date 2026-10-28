import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class EnergyAura extends StatefulWidget {
  final int score;
  final double size;

  const EnergyAura({
    super.key,
    required this.score,
    this.size = 160.0,
  });

  @override
  State<EnergyAura> createState() => _EnergyAuraState();
}

class _EnergyAuraState extends State<EnergyAura> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _breathAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // Breathing cycle
    )..repeat(reverse: true);

    _breathAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _auraColor {
    if (widget.score >= 90) return const Color(0xFF34D399); // Mint green (Excellent)
    if (widget.score >= 75) return const Color(0xFF38BDF8); // Sky blue (Good)
    if (widget.score >= 60) return const Color(0xFFFBBF24); // Warm yellow (Fair)
    return const Color(0xFFF87171); // Soft red (Tired)
  }

  @override
  Widget build(BuildContext context) {
    final auraColor = _auraColor;

    return AnimatedBuilder(
      animation: _breathAnimation,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // Outer glowing aura (Breathing)
              Transform.scale(
                scale: _breathAnimation.value * 1.2,
                child: Container(
                  width: widget.size * 0.8,
                  height: widget.size * 0.8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: auraColor.withValues(alpha: 0.2),
                    boxShadow: [
                      BoxShadow(
                        color: auraColor.withValues(alpha: 0.4),
                        blurRadius: 40,
                        spreadRadius: 20,
                      )
                    ],
                  ),
                ),
              ),
              
              // Inner solid core
              Transform.scale(
                scale: _breathAnimation.value * 0.95,
                child: Container(
                  width: widget.size * 0.6,
                  height: widget.size * 0.6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white,
                        auraColor.withValues(alpha: 0.8),
                      ],
                      stops: const [0.2, 1.0],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: auraColor.withValues(alpha: 0.6),
                        blurRadius: 20,
                        spreadRadius: 5,
                      )
                    ],
                  ),
                ),
              ),
              
              // Glassmorphism overlay for premium feel
              ClipOval(
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    width: widget.size * 0.7,
                    height: widget.size * 0.7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.1),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.5),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
              
              // Center icon
              Icon(
                Icons.favorite_rounded,
                color: Colors.white.withValues(alpha: 0.9),
                size: widget.size * 0.25,
              ),
            ],
          ),
        );
      },
    );
  }
}
