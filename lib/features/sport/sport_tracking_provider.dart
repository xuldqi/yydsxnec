import 'dart:async';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/database/app_database.dart';
import '../../core/services/database_provider.dart';

@immutable
class SportTrackingState {
  final bool isTracking;
  final bool isPaused;
  final DateTime? startTime;
  final Duration duration;
  final double distanceKm; // in km
  final double currentSpeed; // m/s
  final double calories;
  final List<Position> path;

  const SportTrackingState({
    this.isTracking = false,
    this.isPaused = false,
    this.startTime,
    this.duration = Duration.zero,
    this.distanceKm = 0.0,
    this.currentSpeed = 0.0,
    this.calories = 0.0,
    this.path = const [],
  });

  SportTrackingState copyWith({
    bool? isTracking,
    bool? isPaused,
    DateTime? startTime,
    Duration? duration,
    double? distanceKm,
    double? currentSpeed,
    double? calories,
    List<Position>? path,
  }) {
    return SportTrackingState(
      isTracking: isTracking ?? this.isTracking,
      isPaused: isPaused ?? this.isPaused,
      startTime: startTime ?? this.startTime,
      duration: duration ?? this.duration,
      distanceKm: distanceKm ?? this.distanceKm,
      currentSpeed: currentSpeed ?? this.currentSpeed,
      calories: calories ?? this.calories,
      path: path ?? this.path,
    );
  }

  // 配速计算 (分钟/公里)
  String get paceFormatted {
    if (currentSpeed <= 0.2) return "--'--\""; // 速度过低不计算配速
    final paceMinsPerKm = 1000 / (currentSpeed * 60);
    if (paceMinsPerKm > 60) return "--'--\""; // 太慢
    final mins = paceMinsPerKm.floor();
    final secs = ((paceMinsPerKm - mins) * 60).floor();
    return "$mins'${secs.toString().padLeft(2, '0')}\"";
  }

  String get durationFormatted {
    final h = duration.inHours;
    final m = duration.inMinutes % 60;
    final s = duration.inSeconds % 60;
    if (h > 0) {
      return "${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
    }
    return "${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
  }
}

class SportTrackingNotifier extends StateNotifier<SportTrackingState> {
  final Ref ref;
  StreamSubscription<Position>? _positionStream;
  Timer? _timer;

  SportTrackingNotifier(this.ref) : super(const SportTrackingState());

  @override
  void dispose() {
    _positionStream?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> startTracking() async {
    // Check permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    state = const SportTrackingState(
      isTracking: true,
      startTime: null,
    );
    state = state.copyWith(startTime: DateTime.now());

    _timer = Timer.periodic(const Duration(seconds: 1), _onTick);

    // Position Stream
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 2, // notify every 2 meters
    );

    _positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position position) {
      if (!state.isTracking || state.isPaused) return;

      final newPath = List<Position>.from(state.path)..add(position);
      double newDistance = state.distanceKm;

      if (state.path.isNotEmpty) {
        final last = state.path.last;
        final d = Geolocator.distanceBetween(
          last.latitude, last.longitude,
          position.latitude, position.longitude,
        );
        newDistance += d / 1000.0;
      }

      // Simple calories: ~60 kcal per km
      final newCalories = newDistance * 60.0;

      state = state.copyWith(
        path: newPath,
        distanceKm: newDistance,
        currentSpeed: position.speed,
        calories: newCalories,
      );
    });
  }

  void pauseTracking() {
    if (!state.isTracking) return;
    state = state.copyWith(isPaused: true, currentSpeed: 0);
  }

  void resumeTracking() {
    if (!state.isTracking) return;
    state = state.copyWith(isPaused: false);
  }

  void _onTick(Timer timer) {
    if (state.isTracking && !state.isPaused) {
      state = state.copyWith(
        duration: state.duration + const Duration(seconds: 1),
      );
    }
  }

  Future<void> finishAndSave(String type) async {
    _positionStream?.cancel();
    _timer?.cancel();

    if (state.path.isNotEmpty && state.distanceKm > 0.05) {
      // Serialize route
      final routeList = state.path.map((p) => {
        'lat': p.latitude,
        'lng': p.longitude,
        'alt': p.altitude,
      }).toList();
      final routeJson = jsonEncode(routeList);

      final db = ref.read(databaseProvider);
      
      double avgSpeed = 0;
      if (state.duration.inSeconds > 0) {
        avgSpeed = (state.distanceKm * 1000.0) / state.duration.inSeconds;
      }

      await db.insertExerciseRecord(ExerciseRecordsCompanion.insert(
        userId: 'default_user',
        startTime: state.startTime ?? DateTime.now(),
        endTime: Value(DateTime.now()),
        duration: Value(state.duration.inSeconds),
        exerciseType: Value(type),
        distance: Value(state.distanceKm),
        averageSpeed: Value(avgSpeed),
        routeData: Value(routeJson),
        intensity: const Value('medium'),
      ));
    }

    state = const SportTrackingState();
  }
}

final sportTrackingProvider = StateNotifierProvider<SportTrackingNotifier, SportTrackingState>((ref) {
  return SportTrackingNotifier(ref);
});
