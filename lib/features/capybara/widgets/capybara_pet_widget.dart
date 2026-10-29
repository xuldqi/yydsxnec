import 'dart:math';
import 'package:flutter/material.dart';
import '../models/capybara_state.dart';

enum PetAnimMode { idle, tap, drink, walk }

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
  late AnimationController _animController;
  PetAnimMode _currentMode = PetAnimMode.idle;
  final List<_FloatingHeart> _hearts = [];

  // Frame lists - 100% crisp unblended keyframes (ZERO ghosting / 残影)
  static const List<String> _idleFrames = [
    'assets/images/pet_frames/idle_1.png',
    'assets/images/pet_frames/idle_2.png',
    'assets/images/pet_frames/idle_3.png',
    'assets/images/pet_frames/idle_4.png',
  ];

  static const List<String> _tapFrames = [
    'assets/images/pet_frames/tap_1.png',
    'assets/images/pet_frames/tap_2.png',
    'assets/images/pet_frames/tap_3.png',
    'assets/images/pet_frames/tap_4.png',
    'assets/images/pet_frames/tap_5.png',
    'assets/images/pet_frames/tap_6.png',
  ];

  static const List<String> _drinkFrames = [
    'assets/images/pet_frames/drink_1.png',
    'assets/images/pet_frames/drink_2.png',
    'assets/images/pet_frames/drink_3.png',
    'assets/images/pet_frames/drink_4.png',
  ];

  static const List<String> _walkFrames = [
    'assets/images/pet_frames/walk_1.png',
    'assets/images/pet_frames/walk_2.png',
    'assets/images/pet_frames/walk_3.png',
    'assets/images/pet_frames/walk_4.png',
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    _syncModeWithMood();
  }

  @override
  void didUpdateWidget(covariant CapybaraPetWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.mood != oldWidget.mood && _currentMode != PetAnimMode.tap) {
      _syncModeWithMood();
    }
  }

  void _syncModeWithMood() {
    if (widget.mood == CapybaraMood.onsen) {
      _currentMode = PetAnimMode.drink;
      _animController.duration = const Duration(milliseconds: 1200);
      _animController.repeat();
    } else if (widget.mood == CapybaraMood.energetic) {
      _currentMode = PetAnimMode.walk;
      _animController.duration = const Duration(milliseconds: 1000);
      _animController.repeat();
    } else {
      _currentMode = PetAnimMode.idle;
      _animController.duration = const Duration(milliseconds: 1400);
      _animController.repeat();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Precache all frames so animation plays buttery smooth
    for (final f in _idleFrames) {
      precacheImage(AssetImage(f), context);
    }
    for (final f in _tapFrames) {
      precacheImage(AssetImage(f), context);
    }
    for (final f in _drinkFrames) {
      precacheImage(AssetImage(f), context);
    }
    for (final f in _walkFrames) {
      precacheImage(AssetImage(f), context);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _handleTap(TapDownDetails details) {
    widget.onPet?.call();

    // Trigger tap celebration animation sequence
    setState(() {
      _currentMode = PetAnimMode.tap;
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

    _animController.stop();
    _animController.duration = const Duration(milliseconds: 900);
    _animController.forward(from: 0.0).then((_) {
      if (mounted) {
        setState(() {
          _syncModeWithMood();
        });
      }
    });
  }

  List<String> get _activeFrameList {
    switch (_currentMode) {
      case PetAnimMode.tap:
        return _tapFrames;
      case PetAnimMode.drink:
        return _drinkFrames;
      case PetAnimMode.walk:
        return _walkFrames;
      case PetAnimMode.idle:
      default:
        return _idleFrames;
    }
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
          clipBehavior: Clip.none,
          children: [
            // 1. Soft Ambient Pet Stage Shadow (Harmonious Warm Earth Palette)
            Positioned(
              bottom: widget.size * 0.02,
              child: Container(
                width: widget.size * 0.68,
                height: widget.size * 0.16,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.elliptical(widget.size * 0.68, widget.size * 0.16)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8D5B4C).withValues(alpha: 0.12),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),

            // 2. High-Frame Multi-Sprite 2D Character Animation
            AnimatedBuilder(
              animation: _animController,
              builder: (context, _) {
                final frames = _activeFrameList;
                final frameIndex = (_animController.value * frames.length).floor().clamp(0, frames.length - 1);
                final currentFrameAsset = frames[frameIndex];

                // Disney-style micro squash & stretch for life-like softness
                final t = _animController.value * 2 * pi;
                final scaleY = 1.0 + sin(t) * 0.02;
                final scaleX = 1.0 - sin(t) * 0.015;
                final bobY = -sin(t).abs() * 2.5;

                return Transform.translate(
                  offset: Offset(0, bobY),
                  child: Transform.scale(
                    scaleX: scaleX,
                    scaleY: scaleY,
                    alignment: Alignment.bottomCenter,
                    child: Image.asset(
                      currentFrameAsset,
                      width: widget.size * 0.95,
                      height: widget.size * 0.95,
                      fit: BoxFit.contain,
                      gaplessPlayback: true,
                      filterQuality: FilterQuality.medium,
                      errorBuilder: (_, __, ___) => _buildFallback(),
                    ),
                  ),
                );
              },
            ),

            // 3. Optional Accessory Badge (if unlocked)
            if (widget.accessoryId != 'orange' && widget.accessoryId != 'none')
              Positioned(
                top: widget.size * 0.10,
                right: widget.size * 0.12,
                child: _buildAccessoryBadge(widget.accessoryId),
              ),

            // 4. Subtle Environmental Indicators (Onsen / Sleep / Walk)
            _buildMoodIndicator(),

            // 5. Floating heart burst particles on pet
            ..._hearts,
          ],
        ),
      ),
    );
  }

  Widget _buildMoodIndicator() {
    switch (widget.mood) {
      case CapybaraMood.sleepy:
        return Positioned(
          top: 0,
          right: widget.size * 0.08,
          child: AnimatedBuilder(
            animation: _animController,
            builder: (context, _) {
              final opacity = (0.35 + _animController.value * 0.65).clamp(0.0, 1.0);
              return Opacity(
                opacity: opacity,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3EEEA),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE5DDD5)),
                  ),
                  child: const Text(
                    '💤 zZz',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF8C7E77),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      case CapybaraMood.onsen:
        return Positioned(
          top: 2,
          right: widget.size * 0.06,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F4F8),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFCFE5ED)),
            ),
            child: const Text(
              '💧 润喉中',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2E7D9E),
              ),
            ),
          ),
        );
      case CapybaraMood.energetic:
        return Positioned(
          top: 2,
          right: widget.size * 0.06,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFEDF7ED),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFD3EAD3)),
            ),
            child: const Text(
              '🐾 漫步中',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Color(0xFF388E3C),
              ),
            ),
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
        color = const Color(0xFFD97706);
        break;
      case 'glasses':
        icon = Icons.visibility_rounded;
        color = const Color(0xFF4B5563);
        break;
      case 'sakura':
        icon = Icons.filter_vintage_rounded;
        color = const Color(0xFFDB2777);
        break;
      case 'towel':
        icon = Icons.dry_cleaning_rounded;
        color = const Color(0xFF0284C7);
        break;
      default:
        icon = Icons.star_rounded;
        color = const Color(0xFFCA8A04);
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, size: 14, color: color),
    );
  }

  Widget _buildFallback() {
    return Image.asset(
      'assets/images/app_icon.png',
      width: widget.size * 0.9,
      height: widget.size * 0.9,
      fit: BoxFit.contain,
    );
  }
}

class _FloatingHeart extends StatefulWidget {
  final Offset position;
  final ValueChanged<Key?> onComplete;

  const _FloatingHeart({
    super.key,
    required this.position,
    required this.onComplete,
  });

  @override
  State<_FloatingHeart> createState() => _FloatingHeartState();
}

class _FloatingHeartState extends State<_FloatingHeart>
    with SingleTickerProviderStateMixin {
  late AnimationController _heartController;
  late double _randomDriftX;

  @override
  void initState() {
    super.initState();
    _randomDriftX = (Random().nextDouble() - 0.5) * 35;
    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    )..forward().then((_) {
        widget.onComplete(widget.key);
      });
  }

  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _heartController,
      builder: (context, _) {
        final progress = _heartController.value;
        final dy = -progress * 65.0;
        final dx = sin(progress * pi) * _randomDriftX;
        final opacity = (1.0 - progress).clamp(0.0, 1.0);
        final scale = 0.8 + progress * 0.45;

        return Positioned(
          left: widget.position.dx + dx - 20,
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
                      color: Color(0xFFE11D48),
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
