import 'package:flutter/material.dart';

/// 漫步探险阶段（灵感源于 Yoomy 探索之旅设计）
enum ExpeditionStage {
  morning(
    id: 'morning',
    name: '晨光小径',
    stepRange: '0 - 2,000 步',
    minSteps: 0,
    maxSteps: 2000,
    subtitle: '朝霞初升，迈出今日探索第一步',
    badgeIcon: Icons.wb_twilight_rounded,
    badgeColor: Color(0xFF2E6F7D),
    badgeBg: Color(0x33FFFFFF),
    skyColors: [Color(0xFF7FA7BA), Color(0xFFB1CBD6), Color(0xFFE5EDE6)],
    mountainColor: Color(0xFF4C6A7B),
    mountainFarColor: Color(0xFF88A2B0),
    treeColor: Color(0xFF1E352F),
    groundColor: Color(0xFF4D6E4A),
    isNight: false,
  ),

  noon(
    id: 'noon',
    name: '阳光林道',
    stepRange: '2,000 - 5,000 步',
    minSteps: 2000,
    maxSteps: 5000,
    subtitle: '阳光穿过松林，活力渐入佳境',
    badgeIcon: Icons.wb_sunny_rounded,
    badgeColor: Color(0xFF1E6044),
    badgeBg: Color(0x33FFFFFF),
    skyColors: [Color(0xFF5389B0), Color(0xFF85B6D4), Color(0xFFD4E7EF)],
    mountainColor: Color(0xFF38617D),
    mountainFarColor: Color(0xFF759CB5),
    treeColor: Color(0xFF1B3B28),
    groundColor: Color(0xFF436B40),
    isNight: false,
  ),

  dusk(
    id: 'dusk',
    name: '落日山脊',
    stepRange: '5,000 - 8,000 步',
    minSteps: 5000,
    maxSteps: 8000,
    subtitle: '枫红晚霞铺满山脊，即将冲顶',
    badgeIcon: Icons.wb_shade_rounded,
    badgeColor: Color(0xFF8E3B29),
    badgeBg: Color(0x33FFFFFF),
    skyColors: [Color(0xFF3C2C54), Color(0xFF8E4658), Color(0xFFDD7856), Color(0xFFFFBF75)],
    mountainColor: Color(0xFF381F38),
    mountainFarColor: Color(0xFF6A3B57),
    treeColor: Color(0xFF1A121F),
    groundColor: Color(0xFF5A312A),
    isNight: false,
  ),

  summit(
    id: 'summit',
    name: '巅峰营地',
    stepRange: '8,000+ 步',
    minSteps: 8000,
    maxSteps: 100000,
    subtitle: '达成今日目标！璀璨星空为你亮起营火',
    badgeIcon: Icons.auto_awesome_rounded,
    badgeColor: Color(0xFFFBBF24),
    badgeBg: Color(0x33FFFFFF),
    skyColors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF2B3752)],
    mountainColor: Color(0xFF0D1424),
    mountainFarColor: Color(0xFF182238),
    treeColor: Color(0xFF090D17),
    groundColor: Color(0xFF141B2D),
    isNight: true,
  );

  final String id;
  final String name;
  final String stepRange;
  final int minSteps;
  final int maxSteps;
  final String subtitle;
  final IconData badgeIcon;
  final Color badgeColor;
  final Color badgeBg;
  final List<Color> skyColors;
  final Color mountainColor;
  final Color mountainFarColor;
  final Color treeColor;
  final Color groundColor;
  final bool isNight;

  const ExpeditionStage({
    required this.id,
    required this.name,
    required this.stepRange,
    required this.minSteps,
    required this.maxSteps,
    required this.subtitle,
    required this.badgeIcon,
    required this.badgeColor,
    required this.badgeBg,
    required this.skyColors,
    required this.mountainColor,
    required this.mountainFarColor,
    required this.treeColor,
    required this.groundColor,
    required this.isNight,
  });

  /// 根据步数自动计算当前所处探险阶段
  static ExpeditionStage fromSteps(int steps) {
    if (steps >= 8000) return ExpeditionStage.summit;
    if (steps >= 5000) return ExpeditionStage.dusk;
    if (steps >= 2000) return ExpeditionStage.noon;
    return ExpeditionStage.morning;
  }

  /// 计算当前赛段内的百分比进度 (0.0 ~ 1.0)
  static double stageProgress(int steps) {
    if (steps >= 8000) return 1.0;
    if (steps >= 5000) return (steps - 5000) / 3000;
    if (steps >= 2000) return (steps - 2000) / 3000;
    return (steps / 2000).clamp(0.0, 1.0);
  }

  /// 距离下一赛段还差多少步
  static int stepsToNextStage(int steps) {
    if (steps >= 8000) return 0;
    if (steps >= 5000) return 8000 - steps;
    if (steps >= 2000) return 5000 - steps;
    return 2000 - steps;
  }

  /// 获取下一赛段
  static ExpeditionStage? nextStage(int steps) {
    if (steps >= 8000) return null;
    if (steps >= 5000) return ExpeditionStage.summit;
    if (steps >= 2000) return ExpeditionStage.dusk;
    return ExpeditionStage.noon;
  }

  /// 获取下一阶段目标名称及剩余步数
  String nextCheckpointInfo(int steps) {
    switch (this) {
      case ExpeditionStage.morning:
        final remain = (2000 - steps).clamp(0, 2000);
        return '距「阳光林道」还差 $remain 步';
      case ExpeditionStage.noon:
        final remain = (5000 - steps).clamp(0, 3000);
        return '距「落日山脊」还差 $remain 步';
      case ExpeditionStage.dusk:
        final remain = (8000 - steps).clamp(0, 3000);
        return '距「巅峰营地」还差 $remain 步';
      case ExpeditionStage.summit:
        return '今日目标已达成！已登顶营地 🏆';
    }
  }
}
