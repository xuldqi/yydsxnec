import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import 'report_provider.dart';

class AchievementPosterScreen extends ConsumerWidget {
  const AchievementPosterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(weeklyReportProvider);

    return Scaffold(
      backgroundColor: Colors.black, // Dark pure background
      body: Stack(
        children: [
          // Background blobs
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.3),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.sportOther.withValues(alpha: 0.4),
              ),
            ),
          ),
          // Blur layer
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
            child: Container(color: Colors.transparent),
          ),
          
          // Main Content
          SafeArea(
            child: reportAsync.when(
              loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
              error: (e, st) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.white))),
              data: (data) => _buildPosterContent(context, data),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPosterContent(BuildContext context, WeeklyReportData data) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Row(
            children: [
              const Icon(Icons.star_rounded, color: Colors.yellowAccent, size: 32),
              const SizedBox(width: 8),
              Text('MY HEALTH JOURNEY', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 16, letterSpacing: 2, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 60),
          const Text('本周成就汇总', style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.w900, height: 1.1)),
          const SizedBox(height: 8),
          Text(DateFormat('yyyy年MM月dd日').format(DateTime.now()), style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 18)),
          
          const Spacer(),
          
          // Stats Grid
          Row(
            children: [
              Expanded(child: _buildStat('总步数', NumberFormat('#,###').format(data.totalSteps), '步', AppColors.primary)),
              const SizedBox(width: 16),
              Expanded(child: _buildStat('消耗热量', NumberFormat('#,###').format(data.totalCalories), 'kcal', AppColors.warning)),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildStat('平均体重', data.avgWeight.toStringAsFixed(1), 'kg', Colors.blueAccent)),
              const SizedBox(width: 16),
              Expanded(child: _buildStat('日均睡眠', '${data.avgSleepMins ~/ 60}h ${data.avgSleepMins % 60}m', '', AppColors.sportOther)),
            ],
          ),
          
          const SizedBox(height: 80),
          Center(
            child: Text('截图保存分享至社交媒体', style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 13, letterSpacing: 1)),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, String unit, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 14)),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value, style: TextStyle(color: color, fontSize: 28, fontWeight: FontWeight.bold)),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(unit, style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12)),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
