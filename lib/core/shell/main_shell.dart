// 主页 Shell — OtterLife 精致轻盈悬浮玻璃态导航栏
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/app_l10n_ext.dart';

const _active = Color(0xFF6366F1); // Indigo Primary
const _inactive = Color(0xFF94A3B8); // Slate 400

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  static const _tabs = <_TabSpec>[
    _TabSpec(
        path: '/home',
        icon: Icons.calendar_today_rounded,
        iconOff: Icons.calendar_today_outlined,
        labelKey: 'tabToday'),
    _TabSpec(
        path: '/goal',
        icon: Icons.track_changes_rounded,
        iconOff: Icons.track_changes_outlined,
        labelKey: 'tabGoal'),
    _TabSpec(
        path: '/relax',
        icon: Icons.self_improvement_rounded,
        iconOff: Icons.self_improvement_outlined,
        labelKey: 'tabRelax'),
    _TabSpec(
        path: '/profile',
        icon: Icons.person_rounded,
        iconOff: Icons.person_outline_rounded,
        labelKey: 'tabUser'),
  ];

  int _selectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    for (int i = 0; i < _tabs.length; i++) {
      if (location == _tabs[i].path ||
          location.startsWith('${_tabs[i].path}/')) {
        return i;
      }
    }
    return 0;
  }

  String _lookup(BuildContext context, String key) {
    switch (key) {
      case 'tabToday':
        return '今天';
      case 'tabGoal':
        return '目标';
      case 'tabRelax':
        return '放松';
      case 'tabUser':
        return '我的';
    }
    return key;
  }

  @override
  Widget build(BuildContext context) {
    final idx = _selectedIndex(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F8),
      extendBody: true,
      body: child,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              height: 68,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.90),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                    color: Colors.white.withValues(alpha: 0.8), width: 1.5),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0F000000),
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(_tabs.length, (i) {
                  final t = _tabs[i];
                  final sel = i == idx;
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => context.go(t.path),
                    child: SizedBox(
                      width: 60,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOutCubic,
                            padding: EdgeInsets.all(sel ? 6 : 4),
                            decoration: BoxDecoration(
                              color: sel
                                  ? _active.withValues(alpha: 0.12)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              sel ? t.icon : t.iconOff,
                              color: sel ? _active : _inactive,
                              size: sel ? 24 : 22,
                            ),
                          ),
                          const SizedBox(height: 2),
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 300),
                            style: TextStyle(
                              fontSize: sel ? 11 : 10,
                              color: sel ? _active : _inactive,
                              fontWeight:
                                  sel ? FontWeight.w700 : FontWeight.w500,
                            ),
                            child: Text(_lookup(context, t.labelKey)),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabSpec {
  final String path;
  final IconData icon;
  final IconData iconOff;
  final String labelKey;
  const _TabSpec(
      {required this.path,
      required this.icon,
      required this.iconOff,
      required this.labelKey});
}
