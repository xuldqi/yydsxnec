import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final movementMonitorProvider = ChangeNotifierProvider((ref) => MovementMonitorService());

class MovementMonitorService extends ChangeNotifier {
  StreamSubscription<AccelerometerEvent>? _accelSub;
  Timer? _periodicTimer;
  bool _isRunning = false;
  bool get isRunning => _isRunning;

  final List<String> _sleepPhases = [];
  List<String> get sleepPhases => _sleepPhases;

  DateTime? _startTime;
  DateTime? get startTime => _startTime;

  double _lastX = 0, _lastY = 0, _lastZ = 0;
  bool _isFirstReading = true;
  double _movementScore = 0;

  void start() {
    if (_isRunning) return;
    _isRunning = true;
    _sleepPhases.clear();
    _startTime = DateTime.now();
    _movementScore = 0;
    _isFirstReading = true;

    _periodicTimer?.cancel();
    _accelSub?.cancel();

    try {
      _accelSub = accelerometerEventStream().listen((event) {
        if (!_isRunning) return;
        
        if (_isFirstReading) {
          _lastX = event.x;
          _lastY = event.y;
          _lastZ = event.z;
          _isFirstReading = false;
          return;
        }
        
        // Calculate magnitude of movement
        final dx = event.x - _lastX;
        final dy = event.y - _lastY;
        final dz = event.z - _lastZ;
        final magnitude = sqrt(dx * dx + dy * dy + dz * dz);
        
        _lastX = event.x;
        _lastY = event.y;
        _lastZ = event.z;

        if (magnitude > 1.5) { // Threshold to ignore tiny noise
          _movementScore += magnitude;
        }
      });
      
      // Calculate phase every 5 minutes
      _periodicTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
        if (!_isRunning) {
          timer.cancel();
          return;
        }
        _calculatePhaseFromMovement();
      });

    } catch (e) {
      debugPrint("Accelerometer stream error: $e");
      // Fallback: If hardware fails, do not emit fake data.
    }
  }

  void _calculatePhaseFromMovement() {
    String phase;
    // Simple heuristic for mapping movement magnitude to sleep phase
    if (_movementScore > 50) {
      phase = 'Awake';
    } else if (_movementScore > 20) {
      phase = 'Light';
    } else if (_movementScore > 5) {
      phase = 'REM';
    } else {
      phase = 'Deep';
    }
    
    _sleepPhases.add(phase);
    _movementScore = 0; // reset for next period
    notifyListeners();
  }



  void stop() {
    _isRunning = false;
    _periodicTimer?.cancel();
    _accelSub?.cancel();
    notifyListeners();
  }

  @override
  void dispose() {
    stop();
    super.dispose();
  }
}
