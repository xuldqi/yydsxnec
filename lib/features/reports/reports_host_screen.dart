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
      backgroundColor: const Color(0xFFF3F4F8),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEFEBFA), Color(0xFFF3F4F8), Color(0xFFEBEFF9)],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Custom Header with clean Segmented Switch
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    if (widget.showBackButton)
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_rounded, color: Color(0xFF1E1B4B), size: 20),
                        onPressed: () {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.go('/home');
                          }
                        },
                      )
                    else
                      const SizedBox(width: 8),
                    Expanded(
                      child: Center(
                        child: CupertinoSlidingSegmentedControl<int>(
                          backgroundColor: Colors.black.withValues(alpha: 0.05),
                          thumbColor: Colors.white,
                          groupValue: _currentIndex,
                          children: {
                            0: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 7),
                              child: Text(
                                '日常日报',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: _currentIndex == 0 ? const Color(0xFF1E1B4B) : const Color(0xFF64748B),
                                ),
                              ),
                            ),
                            1: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 7),
                              child: Text(
                                '趋势周报',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: _currentIndex == 1 ? const Color(0xFF1E1B4B) : const Color(0xFF64748B),
                                ),
                              ),
                            ),
                          },
                          onValueChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _currentIndex = val;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    if (widget.showBackButton)
                      const SizedBox(width: 48) // Balance for back button
                    else
                      const SizedBox(width: 8),
                  ],
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
      ),
    );
  }
}
