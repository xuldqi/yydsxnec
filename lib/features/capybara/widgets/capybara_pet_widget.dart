import 'dart:math';
import 'package:flutter/material.dart';
import '../models/capybara_state.dart';

class CapybaraPetWidget extends StatefulWidget {
  final CapybaraMood mood;
  final String accessoryId;
  final double size;
  final VoidCallback? onPet;

  const CapybaraPetWidget({
    super.key,
    required this.mood,
    required this.accessoryId,
    this.size = 140,
    this.onPet,
  });

  @override
  State<CapybaraPetWidget> createState() => _CapybaraPetWidgetState();
}

class _CapybaraPetWidgetState extends State<CapybaraPetWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_FloatingHeart> _hearts = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap(TapDownDetails details) {
    widget.onPet?.call();
    setState(() {
      _hearts.add(_FloatingHeart(
        key: UniqueKey(),
        position: details.localPosition,
        onComplete: (key) {
          if (mounted) {
            setState(() {
              _hearts.removeWhere((h) => h.key == key);
            });
          }
        },
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 1. Mood environmental effects (Onsen steam / Sleepy zZz / Sparkles)
            _buildMoodEffect(),

            // 2. Animated breathing Capybara Body
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final bobY = sin(_controller.value * pi) * 3.5;
                final scale = 1.0 + sin(_controller.value * pi) * 0.02;

                return Transform.translate(
                  offset: Offset(0, bobY),
                  child: Transform.scale(
                    scale: scale,
                    child: child,
                  ),
                );
              },
              child: Container(
                width: widget.size * 0.9,
                height: widget.size * 0.9,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(widget.size * 0.45),
                  child: Image.asset(
                    'assets/images/capybara_mascot.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildFallbackVector(),
                  ),
                ),
              ),
            ),

            // 3. Accessory Overlay (if not default orange which is part of base art)
            if (widget.accessoryId != 'orange' && widget.accessoryId != 'none')
              Positioned(
                top: widget.size * 0.12,
                child: _buildAccessoryBadge(widget.accessoryId),
              ),

            // 4. Onsen Water Rim (when in onsen mode)
            if (widget.mood == CapybaraMood.onsen)
              Positioned(
                bottom: 0,
                child: Container(
                  width: widget.size * 0.85,
                  height: widget.size * 0.28,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF38BDF8).withValues(alpha: 0.85),
                        const Color(0xFF0284C7).withValues(alpha: 0.95),
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(widget.size * 0.4),
                      topRight: Radius.circular(widget.size * 0.4),
                      bottomLeft: Radius.circular(widget.size * 0.4),
                      bottomRight: Radius.circular(widget.size * 0.4),
                    ),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.6), width: 1.5),
                  ),
                  child: Center(
                    child: Text(
                      '♨️ 舒缓暖汤',
                      style: TextStyle(
                        fontSize: widget.size * 0.08,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

            // 5. Floating heart burst particles
            ..._hearts,
          ],
        ),
      ),
    );
  }

  Widget _buildMoodEffect() {
    switch (widget.mood) {
      case CapybaraMood.sleepy:
        return Positioned(
          top: 0,
          right: widget.size * 0.15,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final opacity = (0.4 + _controller.value * 0.6).clamp(0.0, 1.0);
              return Opacity(
                opacity: opacity,
                child: const Text(
                  '💤 zZz',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              );
            },
          ),
        );
      case CapybaraMood.energetic:
        return Positioned(
          top: 4,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('✨', style: TextStyle(fontSize: 16)),
                  SizedBox(width: 40),
                  Text('⭐', style: TextStyle(fontSize: 16)),
                ],
              );
            },
          ),
        );
      case CapybaraMood.onsen:
        return Positioned(
          top: widget.size * 0.05,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text('♨️', style: TextStyle(fontSize: 15)),
              SizedBox(width: 50),
              Text('♨️', style: TextStyle(fontSize: 15)),
            ],
          ),
        );
      case CapybaraMood.orange:
        return const SizedBox.shrink();
    }
  }

  Widget _buildAccessoryBadge(String accId) {
    IconData icon;
    Color color;
    switch (accId) {
      case 'duck':
        icon = Icons.cruelty_free_rounded;
        color = const Color(0xFFF59E0B);
        break;
      case 'glasses':
        icon = Icons.visibility_rounded;
        color = const Color(0xFF1E293B);
        break;
      case 'sakura':
        icon = Icons.filter_vintage_rounded;
        color = const Color(0xFFEC4899);
        break;
      case 'towel':
        icon = Icons.dry_cleaning_rounded;
        color = const Color(0xFF38BDF8);
        break;
      default:
        icon = Icons.star_rounded;
        color = const Color(0xFFEAB308);
    }

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, size: widget.size * 0.16, color: color),
    );
  }

  Widget _buildFallbackVector() {
    return Container(
      color: const Color(0xFFFDE68A),
      child: Center(
        child: Text(
          '🦫',
          style: TextStyle(fontSize: widget.size * 0.5),
        ),
      ),
    );
  }
}

class _FloatingHeart extends StatefulWidget {
  final Offset position;
  final void Function(Key key) onComplete;

  const _FloatingHeart({
    required super.key,
    required this.position,
    required this.onComplete,
  });

  @override
  State<_FloatingHeart> createState() => _FloatingHeartState();
}

class _FloatingHeartState extends State<_FloatingHeart>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward().then((_) => widget.onComplete(widget.key!));
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) {
        final progress = _anim.value;
        final dy = -progress * 60;
        final opacity = (1.0 - progress).clamp(0.0, 1.0);
        final scale = 0.8 + progress * 0.4;

        return Positioned(
          left: widget.position.dx - 18,
          top: widget.position.dy + dy - 20,
          child: Opacity(
            opacity: opacity,
            child: Transform.scale(
              scale: scale,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('❤️', style: TextStyle(fontSize: 16)),
                  SizedBox(width: 2),
                  Text(
                    '+2',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFEF4444),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
