import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  static const _pages = <_OnboardItem>[
    _OnboardItem(
      icon: Icons.directions_walk_rounded,
      title: '步数与能耗追踪',
      desc: '精准记录每日步数、运动里程与卡路里消耗，助您轻松达成每日健康目标。',
      color: Color(0xFF38BDF8),
    ),
    _OnboardItem(
      icon: Icons.self_improvement_rounded,
      title: '冥想与助眠白噪音',
      desc: '内置多场景冥想指导与放松白噪音，配合情绪与睡眠记录，改善身心健康。',
      color: Color(0xFF818CF8),
    ),
    _OnboardItem(
      icon: Icons.monitor_heart_rounded,
      title: 'AI 扫描与体测管理',
      desc: '支持 PPG 脉搏监测、血氧、HRV 与多维度体测记录，全方位守护您的健康。',
      color: Color(0xFF34D399),
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onNext() async {
    if (_index < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      await _finish();
    }
  }

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarded', true);
    if (!mounted) return;
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F0C29), Color(0xFF1A1040), Color(0xFF24243E)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (_index < _pages.length - 1)
                      TextButton(
                        onPressed: _finish,
                        child: const Text('跳过',
                            style: TextStyle(color: Colors.white54, fontSize: 14)),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemCount: _pages.length,
                  itemBuilder: (_, i) {
                    final p = _pages[i];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              color: p.color.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: p.color.withValues(alpha: 0.25),
                                  blurRadius: 30,
                                  offset: const Offset(0, 10),
                                )
                              ],
                            ),
                            child: Icon(p.icon, size: 100, color: p.color),
                          ),
                          const SizedBox(height: 40),
                          Text(
                            p.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            p.desc,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // Dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pages.length, (i) {
                  final active = i == _index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: active ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: active
                          ? const Color(0xFF38BDF8)
                          : Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF38BDF8),
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shadowColor: const Color(0xFF38BDF8).withValues(alpha: 0.4),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: _onNext,
                    child: Text(
                      _index == _pages.length - 1 ? '立即体验' : '下一步',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardItem {
  final IconData icon;
  final String title;
  final String desc;
  final Color color;
  const _OnboardItem(
      {required this.icon,
      required this.title,
      required this.desc,
      required this.color});
}
