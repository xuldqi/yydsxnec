import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/session_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _initAnimation();
    _enterApp();
  }

  void _initAnimation() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward();
  }

  void _enterApp() {
    _navigationTimer = Timer(const Duration(seconds: 2), () async {
      if (!mounted) return;
      await SessionService.ensureLocalUser();
      if (!mounted) return;
      context.go('/home');
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEAFBFA), Color(0xFFFFF8F0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF46B9B2,
                              ).withValues(alpha: 0.18),
                              offset: const Offset(0, 12),
                              blurRadius: 24,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset(
                            'assets/images/app_icon_cup_1024.png',
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        '小鹿喝水',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        '记录每一杯水和饮品',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF55706C),
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: 60),
                      const SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF46B9B2),
                          ),
                          strokeWidth: 3,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
