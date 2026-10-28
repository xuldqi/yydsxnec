import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../records/records_screen.dart';
import 'week_report_screen.dart';

class ReportsHostScreen extends StatefulWidget {
  final int initialIndex;
  final bool showBackButton;
  const ReportsHostScreen({
    super.key,
    this.initialIndex = 0,
    this.showBackButton = true,
  });

  @override
  State<ReportsHostScreen> createState() => _ReportsHostScreenState();
}

class _ReportsHostScreenState extends State<ReportsHostScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F0C29), Color(0xFF1A1040), Color(0xFF24243E)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Column(
          children: [
            // Custom App Bar with Glassmorphism
            ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Colors.white.withValues(alpha: 0.05),
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 10,
                    bottom: 10,
                  ),
                  child: Row(
                    children: [
                      if (widget.showBackButton)
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 20),
                          onPressed: () {
                            if (context.canPop()) {
                              context.pop();
                            } else {
                              context.go('/home');
                            }
                          },
                        )
                      else
                        const SizedBox(width: 16),
                      Expanded(
                        child: Center(
                          child: CupertinoSegmentedControl<int>(
                            children: const {
                              0: Padding(padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8), child: Text('日报')),
                              1: Padding(padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8), child: Text('周报')),
                            },
                            groupValue: _currentIndex,
                            selectedColor: AppColors.primary,
                            borderColor: AppColors.primary,
                            pressedColor: AppColors.primary.withValues(alpha: 0.2),
                            unselectedColor: Colors.transparent,
                            onValueChanged: (val) {
                              setState(() {
                                _currentIndex = val;
                              });
                            },
                          ),
                        ),
                      ),
                      if (widget.showBackButton)
                        const SizedBox(width: 48) // Balance for back button
                      else
                        const SizedBox(width: 16),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: const [
                  DailyScreen(),
                  WeekReportInnerScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
