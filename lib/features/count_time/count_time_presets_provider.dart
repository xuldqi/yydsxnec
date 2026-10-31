import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CountTimePreset {
  final String id;
  final String name;
  final String desc;
  final int seconds;
  final String iconKey;
  final int colorValue;
  final bool isCustom;

  const CountTimePreset({
    required this.id,
    required this.name,
    required this.desc,
    required this.seconds,
    required this.iconKey,
    required this.colorValue,
    this.isCustom = false,
  });

  IconData get iconData {
    switch (iconKey) {
      case 'noodle':
        return Icons.ramen_dining_rounded;
      case 'relax':
        return Icons.self_improvement_rounded;
      case 'fitness':
        return Icons.fitness_center_rounded;
      case 'mask':
        return Icons.face_retouching_natural_rounded;
      case 'nap':
        return Icons.bedtime_rounded;
      case 'pomodoro':
      case 'timer':
        return Icons.timer_rounded;
      case 'coffee':
        return Icons.coffee_rounded;
      case 'book':
        return Icons.menu_book_rounded;
      case 'run':
        return Icons.directions_run_rounded;
      case 'spa':
        return Icons.spa_rounded;
      case 'fire':
        return Icons.local_fire_department_rounded;
      case 'music':
        return Icons.music_note_rounded;
      default:
        return Icons.timer_rounded;
    }
  }

  Color get color => Color(colorValue);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'desc': desc,
        'seconds': seconds,
        'iconKey': iconKey,
        'colorValue': colorValue,
        'isCustom': isCustom,
      };

  factory CountTimePreset.fromJson(Map<String, dynamic> json) =>
      CountTimePreset(
        id: json['id'] as String? ?? UniqueKey().toString(),
        name: json['name'] as String? ?? '自定义计时',
        desc: json['desc'] as String? ?? '',
        seconds: json['seconds'] as int? ?? 300,
        iconKey: json['iconKey'] as String? ?? 'timer',
        colorValue:
            json['colorValue'] as int? ?? const Color(0xFF8D5B4C).toARGB32(),
        isCustom: json['isCustom'] as bool? ?? true,
      );
}

const List<CountTimePreset> kDefaultPresets = [
  CountTimePreset(
    id: 'default_noodle',
    name: '煮面',
    desc: '5分钟',
    seconds: 300,
    iconKey: 'noodle',
    colorValue: 0xFFEA580C,
    isCustom: false,
  ),
  CountTimePreset(
    id: 'default_relax',
    name: '呼吸放松',
    desc: '3分钟',
    seconds: 180,
    iconKey: 'relax',
    colorValue: 0xFF10B981,
    isCustom: false,
  ),
  CountTimePreset(
    id: 'default_fitness',
    name: '训练组歇',
    desc: '90秒',
    seconds: 90,
    iconKey: 'fitness',
    colorValue: 0xFF8D5B4C,
    isCustom: false,
  ),
  CountTimePreset(
    id: 'default_mask',
    name: '敷面膜',
    desc: '15分钟',
    seconds: 900,
    iconKey: 'mask',
    colorValue: 0xFFEC4899,
    isCustom: false,
  ),
  CountTimePreset(
    id: 'default_nap',
    name: '午间小憩',
    desc: '30分钟',
    seconds: 1800,
    iconKey: 'nap',
    colorValue: 0xFF6366F1,
    isCustom: false,
  ),
  CountTimePreset(
    id: 'default_pomodoro',
    name: '专注番茄',
    desc: '25分钟',
    seconds: 1500,
    iconKey: 'pomodoro',
    colorValue: 0xFFE11D48,
    isCustom: false,
  ),
];

const String _kCustomPresetsKey = 'user_custom_count_time_presets_v1';

final countTimePresetsProvider =
    StateNotifierProvider<CountTimePresetsNotifier, List<CountTimePreset>>(
        (ref) {
  return CountTimePresetsNotifier();
});

class CountTimePresetsNotifier extends StateNotifier<List<CountTimePreset>> {
  CountTimePresetsNotifier() : super(kDefaultPresets) {
    _loadCustomPresets();
  }

  Future<void> _loadCustomPresets() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_kCustomPresetsKey);
      if (raw != null && raw.isNotEmpty) {
        final List<dynamic> list = jsonDecode(raw);
        final customList = list
            .map((item) =>
                CountTimePreset.fromJson(item as Map<String, dynamic>))
            .toList();
        state = [...kDefaultPresets, ...customList];
      }
    } catch (e) {
      debugPrint('Error loading custom presets: $e');
    }
  }

  Future<CountTimePreset> addPreset({
    required String name,
    required int seconds,
    required String iconKey,
    required Color color,
  }) async {
    final desc = seconds >= 60
        ? (seconds % 60 == 0
            ? '${seconds ~/ 60}分钟'
            : '${seconds ~/ 60}分${seconds % 60}秒')
        : '$seconds秒';

    final newPreset = CountTimePreset(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim().isEmpty ? '自定义计时' : name.trim(),
      desc: desc,
      seconds: seconds,
      iconKey: iconKey,
      colorValue: color.toARGB32(),
      isCustom: true,
    );

    state = [...state, newPreset];
    await _saveCustomPresets();
    return newPreset;
  }

  Future<void> deletePreset(String id) async {
    state = state.where((p) => p.id != id || !p.isCustom).toList();
    await _saveCustomPresets();
  }

  Future<void> _saveCustomPresets() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final customList =
          state.where((p) => p.isCustom).map((p) => p.toJson()).toList();
      await prefs.setString(_kCustomPresetsKey, jsonEncode(customList));
    } catch (e) {
      debugPrint('Error saving custom presets: $e');
    }
  }
}
