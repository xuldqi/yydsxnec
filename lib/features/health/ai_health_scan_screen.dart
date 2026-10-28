import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AiHealthScanScreen extends ConsumerStatefulWidget {
  const AiHealthScanScreen({super.key});

  @override
  ConsumerState<AiHealthScanScreen> createState() => _AiHealthScanScreenState();
}

class _AiHealthScanScreenState extends ConsumerState<AiHealthScanScreen> with SingleTickerProviderStateMixin {
  bool _isScanning = false;
  String _selectedMode = ''; // 'face', 'finger', 'heart'
  
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isScanning = false;
        });
        // Normally, navigate to results here.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('检测完成！')),
        );
      }
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  void _startScan(String mode) {
    setState(() {
      _selectedMode = mode;
      _isScanning = true;
    });
    _progressController.forward(from: 0);
  }

  Widget _buildModeCard({
    required String title,
    required String subtitle,
    required String badgeText,
    required IconData icon,
    required String mode,
    bool isRecommended = false,
  }) {
    return GestureDetector(
      onTap: () => _startScan(mode),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF10B981), size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      if (isRecommended) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            '推荐',
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badgeText,
                style: const TextStyle(
                  color: Color(0xFF10B981),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          // Background UI
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Text(
                          'AI 健康扫描',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.push('/scan-history'),
                        child: const Text(
                          '历史',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '选择检测方式',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '选择后再调用对应传感器，全程本地计算，保护您的隐私安全。',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                        const SizedBox(height: 32),
                        
                        _buildModeCard(
                          title: '识别脸',
                          subtitle: '前置镜头 · 无需接触 · 参考心率、呼吸',
                          badgeText: '前置',
                          icon: Icons.face,
                          mode: 'face',
                        ),
                        
                        _buildModeCard(
                          title: '识别手指',
                          subtitle: '后置镜头 + 手电筒 · 识别脉搏波 · 精度更高',
                          badgeText: '后置',
                          icon: Icons.fingerprint,
                          mode: 'finger',
                          isRecommended: true,
                        ),
                        
                        _buildModeCard(
                          title: '心率',
                          subtitle: '麦克风采集 · 贴近胸口 · 单独测心音',
                          badgeText: '心音',
                          icon: Icons.favorite,
                          mode: 'heart',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Scanning Overlay
          if (_isScanning)
            Container(
              color: Colors.white.withValues(alpha: 0.95),
              child: SafeArea(
                child: Stack(
                  children: [
                    // Top close button
                    Positioned(
                      top: 16,
                      left: 16,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.black54, size: 28),
                        onPressed: () {
                          setState(() {
                            _isScanning = false;
                            _progressController.stop();
                          });
                        },
                      ),
                    ),
                    
                    // Center Guide
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_selectedMode == 'face')
                            Container(
                              width: 260,
                              height: 320,
                              decoration: BoxDecoration(
                                border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.5), width: 2),
                                borderRadius: BorderRadius.circular(150),
                              ),
                              child: const Center(
                                child: Icon(Icons.face, color: Color(0xFF10B981), size: 100),
                              ),
                            )
                          else if (_selectedMode == 'finger')
                            Container(
                              width: 160,
                              height: 160,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0xFFF59E0B), width: 3),
                              ),
                              child: const Center(
                                child: Icon(Icons.fingerprint, color: Color(0xFFF59E0B), size: 80),
                              ),
                            )
                          else
                            Container(
                              width: 160,
                              height: 160,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0xFFEF4444), width: 3),
                              ),
                              child: const Center(
                                child: Icon(Icons.favorite, color: Color(0xFFEF4444), size: 80),
                              ),
                            ),
                            
                          const SizedBox(height: 32),
                          Text(
                            _selectedMode == 'face' ? '请将面部置于框内' 
                                : (_selectedMode == 'finger' ? '请将手指覆盖背部摄像头与闪光灯' : '请将麦克风贴近胸口'),
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            '保持光线充足，静止，不要说话',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Bottom Progress
                    Positioned(
                      bottom: 40,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: AnimatedBuilder(
                              animation: _progressController,
                              builder: (context, child) {
                                return CircularProgressIndicator(
                                  value: _progressController.value,
                                  strokeWidth: 6,
                                  backgroundColor: Colors.grey.shade200,
                                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          AnimatedBuilder(
                            animation: _progressController,
                            builder: (context, child) {
                              final secondsLeft = (30 - (_progressController.value * 30)).ceil();
                              return Text(
                                '${secondsLeft}s',
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
