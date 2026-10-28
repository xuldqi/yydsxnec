import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/sleep_data_provider.dart';
import 'sleep_report_screen.dart';

class GoodMorningScreen extends StatefulWidget {
  const GoodMorningScreen({Key? key}) : super(key: key);

  @override
  State<GoodMorningScreen> createState() => _GoodMorningScreenState();
}

class _GoodMorningScreenState extends State<GoodMorningScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  String? _selectedMood;

  final List<Map<String, String>> _moods = [
    {'emoji': '😖', 'label': '很差'},
    {'emoji': '🙁', 'label': '不好'},
    {'emoji': '😐', 'label': '一般'},
    {'emoji': '🙂', 'label': '不错'},
    {'emoji': '😄', 'label': '极佳'},
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.forward();
  }

  void _navigateToReport() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const SleepReportScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sleepData = Provider.of<SleepDataProvider>(context, listen: false);
    final duration = sleepData.totalSleepDuration;

    return Scaffold(
      backgroundColor: const Color(0xFF0A101C), // Morning light color
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.wb_sunny, color: Colors.amber, size: 80),
                const SizedBox(height: 30),
                const Text(
                  '早安',
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '昨晚你睡了 ${duration.inHours} 小时 ${duration.inMinutes.remainder(60)} 分钟',
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 60),

                // Mood Selection
                const Text(
                  '你现在感觉怎么样？',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _moods.map((mood) {
                    final isSelected = _selectedMood == mood['label'];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedMood = mood['label']!;
                        });
                        // Add some delay to show the selection before navigating
                        Future.delayed(const Duration(milliseconds: 400), () {
                          _navigateToReport();
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        padding: EdgeInsets.all(isSelected ? 16 : 12),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF90C29F).withOpacity(0.3) : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? const Color(0xFF4ADE80) : Colors.white12,
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: isSelected ? [] : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          mood['emoji']!,
                          style: TextStyle(fontSize: isSelected ? 36 : 28),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 40),
                TextButton(
                  onPressed: _navigateToReport,
                  child: const Text('跳过，查看报告', style: TextStyle(color: Colors.black45)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
