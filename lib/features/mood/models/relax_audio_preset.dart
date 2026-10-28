import 'package:flutter/material.dart';

class RelaxAudioPreset {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final List<String> assetPaths;

  const RelaxAudioPreset({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.assetPaths,
  });
}

class RelaxAudioPresets {
  static const all = <RelaxAudioPreset>[
    RelaxAudioPreset(
      id: 'ocean',
      title: '海浪',
      subtitle: '缓慢起伏，适合放松',
      icon: Icons.waves_rounded,
      color: Color(0xFF4F9B91),
      assetPaths: [
        'assets/emoon/audio/noise/ocean_a.mp3',
        'assets/emoon/audio/noise/ocean_b.mp3',
      ],
    ),
    RelaxAudioPreset(
      id: 'forest',
      title: '森林',
      subtitle: '柔和环境，适合安静',
      icon: Icons.forest_rounded,
      color: Color(0xFF63835C),
      assetPaths: [
        'assets/emoon/audio/noise/forest_a.mp3',
        'assets/emoon/audio/noise/forest_b.mp3',
      ],
    ),
    RelaxAudioPreset(
      id: 'wind',
      title: '风声',
      subtitle: '轻缓流动，适合发呆',
      icon: Icons.air_rounded,
      color: Color(0xFF7C8C68),
      assetPaths: [
        'assets/emoon/audio/noise/wind_a.mp3',
        'assets/emoon/audio/noise/wind_b.mp3',
      ],
    ),
    RelaxAudioPreset(
      id: 'white',
      title: '白噪音',
      subtitle: '平稳覆盖，适合专注',
      icon: Icons.graphic_eq_rounded,
      color: Color(0xFF768797),
      assetPaths: [
        'assets/emoon/audio/noise/white_noise_a.mp3',
        'assets/emoon/audio/noise/white_noise_b.mp3',
      ],
    ),
    RelaxAudioPreset(
      id: 'deep_relax',
      title: '放松氛围',
      subtitle: '低饱和音乐，适合睡前',
      icon: Icons.spa_rounded,
      color: Color(0xFF756FA6),
      assetPaths: [
        'assets/emoon/audio/noise/deep_relax_a.mp3',
        'assets/emoon/audio/noise/deep_relax_b.mp3',
      ],
    ),
  ];
}
