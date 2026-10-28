import 'dart:async';
import 'package:flutter/material.dart';

class BreathingScreen extends StatefulWidget {
  const BreathingScreen({Key? key}) : super(key: key);

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  String _instruction = '准备';
  int _countdown = 3;
  bool _isPlaying = false;
  Timer? _phaseTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _phaseTimer?.cancel();
    super.dispose();
  }

  void _toggleBreathing() {
    if (_isPlaying) {
      _stopBreathing();
    } else {
      _startBreathing();
    }
  }

  void _startBreathing() {
    setState(() {
      _isPlaying = true;
      _instruction = '吸气...';
      _countdown = 4;
    });
    
    _controller.duration = const Duration(seconds: 4);
    _controller.forward(from: 0.0);
    _runPhase(4, '吸气...', () {
      setState(() {
        _instruction = '屏气...';
        _countdown = 7;
      });
      _runPhase(7, '屏气...', () {
        setState(() {
          _instruction = '呼气...';
          _countdown = 8;
        });
        _controller.duration = const Duration(seconds: 8);
        _controller.reverse(from: 1.0);
        _runPhase(8, '呼气...', () {
          if (_isPlaying) _startBreathing(); // Loop
        });
      });
    });
  }

  void _runPhase(int seconds, String text, VoidCallback onComplete) {
    _phaseTimer?.cancel();
    _countdown = seconds;
    _phaseTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_countdown > 1) {
          _countdown--;
        } else {
          timer.cancel();
          onComplete();
        }
      });
    });
  }

  void _stopBreathing() {
    _phaseTimer?.cancel();
    _controller.stop();
    _controller.value = 0.0;
    setState(() {
      _isPlaying = false;
      _instruction = '准备';
      _countdown = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('4-7-8 呼吸助眠', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Ambient background glow
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final scale = 1.0 + (_controller.value * 0.8);
                return Container(
                  width: 150 * scale,
                  height: 150 * scale,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF6BBF7A).withOpacity(0.4),
                        const Color(0xFF6BBF7A).withOpacity(0.0),
                      ],
                      stops: const [0.3, 1.0],
                    ),
                  ),
                );
              },
            ),
          ),
          
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                
                // Instructions
                Text(
                  _instruction,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Timer
                if (_isPlaying)
                  Text(
                    '$_countdown',
                    style: const TextStyle(
                      color: Color(0xFF6BBF7A),
                      fontSize: 64,
                      fontWeight: FontWeight.w300,
                    ),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      '这种呼吸法能通过调节神经系统，有效减缓心跳、放松肌肉，帮助你快速进入睡眠状态。',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white54, fontSize: 16, height: 1.5),
                    ),
                  ),
                  
                const Spacer(),
                
                // Play/Pause Button
                GestureDetector(
                  onTap: _toggleBreathing,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isPlaying ? Colors.white12 : const Color(0xFF6BBF7A),
                      border: Border.all(
                        color: _isPlaying ? Colors.white30 : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      _isPlaying ? Icons.stop_rounded : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
