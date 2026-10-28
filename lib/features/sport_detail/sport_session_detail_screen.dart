import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/database/app_database.dart';
import '../../core/theme/app_colors.dart';
import '../sport/sport_tracking_screen.dart'; // To reuse BlindRoutePainter

class SportSessionDetailScreen extends StatelessWidget {
  final ExerciseRecord record;

  const SportSessionDetailScreen({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    List<Position> path = [];
    if (record.routeData != null && record.routeData!.isNotEmpty) {
      try {
        final decoded = jsonDecode(record.routeData!) as List;
        path = decoded.map((e) {
          final map = e as Map<String, dynamic>;
          return Position(
            longitude: map['lng'] as double,
            latitude: map['lat'] as double,
            timestamp: DateTime.now(),
            accuracy: 0.0,
            altitude: map['alt'] as double? ?? 0.0,
            heading: 0.0,
            speed: 0.0,
            speedAccuracy: 0.0,
            altitudeAccuracy: 0.0,
            headingAccuracy: 0.0,
          );
        }).toList();
      } catch (e) {
        debugPrint('Error decoding route: $e');
      }
    }

    final duration = Duration(seconds: record.duration ?? 0);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    final durationStr = hours > 0 
        ? '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}'
        : '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    double pace = 0;
    String paceStr = "--'--\"";
    if (record.averageSpeed != null && record.averageSpeed! > 0) {
      final speedMs = record.averageSpeed!; // m/s
      final paceMinsPerKm = 1000 / (speedMs * 60);
      if (paceMinsPerKm < 60) {
        final mins = paceMinsPerKm.floor();
        final secs = ((paceMinsPerKm - mins) * 60).floor();
        paceStr = "$mins'${secs.toString().padLeft(2, '0')}\"";
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(record.exerciseType ?? '运动详情', style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: 300,
              child: path.length > 1 
                ? CustomPaint(painter: BlindRoutePainter(path: path))
                : const Center(
                    child: Text('无轨迹数据', style: TextStyle(color: Colors.white54)),
                  ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  Text(
                    (record.distance ?? 0.0).toStringAsFixed(2),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 72,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  const Text('公里', style: TextStyle(color: Colors.white70, fontSize: 16)),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _StatItem(label: '配速', value: paceStr),
                      _StatItem(label: '用时', value: durationStr),
                      _StatItem(label: '大卡', value: ((record.distance ?? 0.0) * 60).toStringAsFixed(0)),
                    ],
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

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 14)),
      ],
    );
  }
}
