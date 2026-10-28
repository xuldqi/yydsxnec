import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MeditationScreen extends ConsumerStatefulWidget {
  const MeditationScreen({super.key});

  @override
  ConsumerState<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends ConsumerState<MeditationScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4), // 4 seconds inhale, 4 seconds exhale
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOutSine),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed && _isPlaying) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _animationController.forward();
      } else {
        _animationController.stop();
        _animationController.animateTo(0, duration: const Duration(milliseconds: 500));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF6EE), // warm beige background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () => Navigator.pushNamed(context, '/meditation-settings'),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // Mode Title
            const Text(
              '深度放松',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '平缓呼吸，释放压力',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF9F9486),
              ),
            ),
            
            Expanded(
              child: Center(
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    final isExhaling = _animationController.status == AnimationStatus.reverse;
                    String actionText = _isPlaying 
                        ? (isExhaling ? '呼气' : '吸气') 
                        : '准备呼吸';

                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer Halo
                        Container(
                          width: 252 * _scaleAnimation.value,
                          height: 252 * _scaleAnimation.value,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFEBDDCB).withOpacity(0.3),
                          ),
                        ),
                        // Middle Ripple
                        Container(
                          width: 184 * (_scaleAnimation.value * 0.9),
                          height: 184 * (_scaleAnimation.value * 0.9),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFD7B494).withOpacity(0.4),
                          ),
                        ),
                        // Inner Core
                        Container(
                          width: 120,
                          height: 120,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Color(0xFFC08C67), Color(0xFFD7B494)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.air, color: Colors.white, size: 28),
                                const SizedBox(height: 8),
                                Text(
                                  actionText,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            
            // Settings Summary
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '时长：5分钟 · 背景音：雨声',
                style: TextStyle(
                  color: Color(0xFF8C8275),
                  fontSize: 13,
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Play Controls
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32).copyWith(bottom: 40),
              child: _isPlaying
                  ? Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _togglePlay,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: const BorderSide(color: Color(0xFF65B8D9)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            child: const Text(
                              '暂停',
                              style: TextStyle(
                                color: Color(0xFF65B8D9),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFC08C67),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            child: const Text(
                              '结束训练',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : ElevatedButton(
                      onPressed: _togglePlay,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF65B8D9), // teal soft
                        minimumSize: const Size(double.infinity, 56),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: const Text(
                        '开始放松',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
