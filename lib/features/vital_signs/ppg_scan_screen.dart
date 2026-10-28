import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/daily_health_provider.dart';

class PpgScanScreen extends ConsumerStatefulWidget {
  const PpgScanScreen({super.key});

  @override
  ConsumerState<PpgScanScreen> createState() => _PpgScanScreenState();
}

class _PpgScanScreenState extends ConsumerState<PpgScanScreen> with SingleTickerProviderStateMixin {
  CameraController? _cameraController;
  bool _isDetecting = false;
  bool _isMeasuring = false;
  
  // PPG Data
  final List<double> _redValues = [];
  double _currentRedAvg = 0;
  
  // Heart Rate Calculation
  int _heartRate = 0;
  final List<int> _bpmQueue = [];
  DateTime? _lastBeatTime;
  
  // UI
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  Timer? _measurementTimer;
  int _secondsLeft = 15;

  @override
  void initState() {
    super.initState();
    _initCamera();
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      final backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        backCamera,
        ResolutionPreset.low,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );

      await _cameraController!.initialize();
      // Turn on flash
      await _cameraController!.setFlashMode(FlashMode.torch);
      
      if (mounted) {
        setState(() {});
        _startImageStream();
      }
    } catch (e) {
      debugPrint("Camera Error: \$e");
    }
  }

  void _startImageStream() {
    _cameraController?.startImageStream((CameraImage image) {
      if (_isDetecting) return;
      _isDetecting = true;
      
      try {
        _processFrame(image);
      } finally {
        _isDetecting = false;
      }
    });
  }

  void _processFrame(CameraImage image) {
    if (image.format.group == ImageFormatGroup.yuv420) {
      // Very basic approximation of red intensity in yuv420
      // We sample pixels from the center of the image to save CPU
      int width = image.width;
      int height = image.height;
      int rSum = 0;
      int count = 0;
      
      int startX = width ~/ 4;
      int endX = width * 3 ~/ 4;
      int startY = height ~/ 4;
      int endY = height * 3 ~/ 4;

      for (int y = startY; y < endY; y += 4) {
        for (int x = startX; x < endX; x += 4) {
          int uvIndex = (y ~/ 2) * (image.planes[1].bytesPerRow) + (x ~/ 2) * image.planes[1].bytesPerPixel!;
          int index = y * image.planes[0].bytesPerRow + x;
          
          int yp = image.planes[0].bytes[index];
          int up = image.planes[1].bytes[uvIndex];
          int vp = image.planes[2].bytes[uvIndex];
          
          // YUV to RGB (Red channel only approximation)
          int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
          rSum += r;
          count++;
        }
      }

      if (count > 0) {
        double avgR = rSum / count;
        _handleRedValue(avgR);
      }
    }
  }

  void _handleRedValue(double val) {
    if (!mounted) return;
    
    // Check if finger is covering the lens (High red intensity)
    if (val < 150) {
      if (_isMeasuring) {
        _cancelMeasurement();
      }
      return;
    }

    if (!_isMeasuring) {
      _startMeasurement();
    }

    setState(() {
      _currentRedAvg = val;
    });

    _redValues.add(val);
    if (_redValues.length > 30) {
      _redValues.removeAt(0);
    }

    // Basic peak detection algorithm (Moving Average)
    if (_redValues.length >= 10) {
      double sum = 0;
      for (var v in _redValues) { sum += v; }
      double avg = sum / _redValues.length;
      
      if (val > avg + 2.0) {
        // Potential beat detected
        DateTime now = DateTime.now();
        if (_lastBeatTime != null) {
          int diffMs = now.difference(_lastBeatTime!).inMilliseconds;
          if (diffMs > 300 && diffMs < 1500) { // Valid HR range (40 - 200 BPM)
            int currentBpm = (60000 / diffMs).round();
            _bpmQueue.add(currentBpm);
            if (_bpmQueue.length > 5) {
              _bpmQueue.removeAt(0);
            }
            
            // Average the queue
            int bpmSum = 0;
            for (var b in _bpmQueue) { bpmSum += b; }
            
            setState(() {
              _heartRate = bpmSum ~/ _bpmQueue.length;
              // Adjust pulse speed based on HR
              _pulseController.duration = Duration(milliseconds: diffMs ~/ 2);
            });
          }
        }
        _lastBeatTime = now;
      }
    }
  }

  void _startMeasurement() {
    setState(() {
      _isMeasuring = true;
      _secondsLeft = 15;
      _heartRate = 0;
      _bpmQueue.clear();
      _redValues.clear();
    });
    
    _measurementTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        setState(() {
          _secondsLeft--;
        });
      } else {
        _finishMeasurement();
      }
    });
  }

  void _cancelMeasurement() {
    _measurementTimer?.cancel();
    setState(() {
      _isMeasuring = false;
      _secondsLeft = 15;
      _heartRate = 0;
    });
  }

  void _finishMeasurement() {
    _measurementTimer?.cancel();
    if (_heartRate > 0) {
      // Save data
      ref.read(dailyHealthProvider.notifier).updateHrv(_heartRate);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('心率测量完成并保存！'), backgroundColor: AppColors.success),
      );
      
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) context.pop();
      });
    }
  }

  @override
  void dispose() {
    _measurementTimer?.cancel();
    _cameraController?.setFlashMode(FlashMode.off);
    _cameraController?.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('心率闪光灯测定', style: TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 1),
            
            // Heart Animation
            ScaleTransition(
              scale: _pulseAnimation,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isMeasuring ? Colors.red.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
                ),
                child: Icon(
                  Icons.favorite_rounded,
                  size: 80,
                  color: _isMeasuring ? Colors.red : Colors.grey,
                ),
              ),
            ),
            
            const SizedBox(height: 48),
            
            // Status Text
            Text(
              _isMeasuring 
                ? (_heartRate > 0 ? '\$_heartRate BPM' : '正在计算...')
                : '请将手指完全覆盖手机背后的\n摄像头与闪光灯',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _isMeasuring ? Colors.white : Colors.white70,
                fontSize: _isMeasuring && _heartRate > 0 ? 48 : 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            if (_isMeasuring) ...[
              const SizedBox(height: 16),
              Text(
                '剩余 \$_secondsLeft 秒',
                style: const TextStyle(color: Colors.white54, fontSize: 16),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48.0),
                child: LinearProgressIndicator(
                  value: 1 - (_secondsLeft / 15),
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation(Colors.red),
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ],
            
            const Spacer(flex: 2),
            
            // Warning text
            const Padding(
              padding: EdgeInsets.all(24.0),
              child: Text(
                '此功能仅供参考娱乐，不能替代专业医疗设备。\n测量时闪光灯可能发热，请注意安全。',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
