import 'package:flutter/material.dart';

/// 水豚当前核心状态
enum CapybaraMood {
  /// 待充能/打瞌睡：步数与喝水不足，或是夜间
  sleepy(
    label: '打瞌睡',
    statusDesc: '正在养精蓄锐',
    defaultQuote: '呼噜... 今天还没怎么动呢，带我去散散步吧~',
    badgeColor: Color(0xFF64748B),
    badgeBg: Color(0xFFF1F5F9),
  ),

  /// 泡温泉：今日喝水充足，暖融融滋养
  onsen(
    label: '泡温泉',
    statusDesc: '水分充足超舒服',
    defaultQuote: '咕嘟咕嘟，温水泡澡最舒服了~ 皮肤水润润！',
    badgeColor: Color(0xFF0284C7),
    badgeBg: Color(0xFFE0F2FE),
  ),

  /// 顶橘子：断食进行中或沉浸专注运动中，心如止水
  orange(
    label: '顶橘子',
    statusDesc: '专注自律沉浸中',
    defaultQuote: '保持专注，心如止水... 头顶的橘子一动不动~',
    badgeColor: Color(0xFFEA580C),
    badgeBg: Color(0xFFFFF7ED),
  ),

  /// 神采奕奕：步数达标或今日目标达成，活力绽放
  energetic(
    label: '神采奕奕',
    statusDesc: '元气满满状态佳',
    defaultQuote: '哇！今天的你超级自律，水豚为你感到骄傲！',
    badgeColor: Color(0xFF16A34A),
    badgeBg: Color(0xFFDCFCE7),
  );

  final String label;
  final String statusDesc;
  final String defaultQuote;
  final Color badgeColor;
  final Color badgeBg;

  const CapybaraMood({
    required this.label,
    required this.statusDesc,
    required this.defaultQuote,
    required this.badgeColor,
    required this.badgeBg,
  });
}

/// 配件数据结构
class CapybaraAccessory {
  final String id;
  final String name;
  final String description;
  final int cost;
  final IconData icon;

  const CapybaraAccessory({
    required this.id,
    required this.name,
    required this.description,
    required this.cost,
    required this.icon,
  });
}

/// 场景数据结构
class CapybaraScene {
  final String id;
  final String name;
  final String description;
  final int cost;
  final List<Color> gradientColors;
  final IconData icon;

  const CapybaraScene({
    required this.id,
    required this.name,
    required this.description,
    required this.cost,
    required this.gradientColors,
    required this.icon,
  });
}

/// 水豚完整养成状态
class CapybaraState {
  final int hearts; // 爱心金币
  final CapybaraMood mood;
  final String currentAccessoryId;
  final String currentSceneId;
  final Set<String> unlockedAccessories;
  final Set<String> unlockedScenes;
  final int companionshipDays; // 陪伴天数
  final int intimacyLevel; // 亲密度等级 (1-10)
  final String activeDialogue;

  const CapybaraState({
    this.hearts = 150,
    this.mood = CapybaraMood.orange,
    this.currentAccessoryId = 'orange',
    this.currentSceneId = 'onsen',
    this.unlockedAccessories = const {'none', 'orange'},
    this.unlockedScenes = const {'onsen'},
    this.companionshipDays = 7,
    this.intimacyLevel = 3,
    this.activeDialogue = '保持专注，心如止水... 头顶的橘子一动不动~',
  });

  CapybaraState copyWith({
    int? hearts,
    CapybaraMood? mood,
    String? currentAccessoryId,
    String? currentSceneId,
    Set<String>? unlockedAccessories,
    Set<String>? unlockedScenes,
    int? companionshipDays,
    int? intimacyLevel,
    String? activeDialogue,
  }) {
    return CapybaraState(
      hearts: hearts ?? this.hearts,
      mood: mood ?? this.mood,
      currentAccessoryId: currentAccessoryId ?? this.currentAccessoryId,
      currentSceneId: currentSceneId ?? this.currentSceneId,
      unlockedAccessories: unlockedAccessories ?? this.unlockedAccessories,
      unlockedScenes: unlockedScenes ?? this.unlockedScenes,
      companionshipDays: companionshipDays ?? this.companionshipDays,
      intimacyLevel: intimacyLevel ?? this.intimacyLevel,
      activeDialogue: activeDialogue ?? this.activeDialogue,
    );
  }
}
