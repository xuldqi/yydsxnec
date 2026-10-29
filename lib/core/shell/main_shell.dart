// 主页 Shell — OtterLife 底部贴底原生质感导航栏
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const _active = Color(0xFF8D5B4C); // Warm Caramel Primary (Harmonized)
const _inactive = Color(0xFFA89F99); // Warm Taupe Muted

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
        path: '/sport',
        icon: Icons.directions_run_rounded,
        iconOff: Icons.directions_run_outlined,
        labelKey: 'tabSport'),
    _TabSpec(
        path: '/reports',
        icon: Icons.insert_chart_rounded,
        iconOff: Icons.insert_chart_outlined,
        labelKey: 'tabReports'),
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
        return '今日';
      case 'tabSport':
        return '运动';
      case 'tabReports':
        return '数据';
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
      extendBody: false,
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Color(0xFFECE4D8), width: 0.6),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x087A533E),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_tabs.length, (i) {
                final t = _tabs[i];
                final sel = i == idx;
                return Expanded(
                  child: InkWell(
                    onTap: () => context.go(t.path),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          sel ? t.icon : t.iconOff,
                          color: sel ? _active : _inactive,
                          size: 23,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          _lookup(context, t.labelKey),
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: sel ? FontWeight.w800 : FontWeight.w500,
                            color: sel ? _active : _inactive,
                            letterSpacing: -0.2,
                          ),
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
