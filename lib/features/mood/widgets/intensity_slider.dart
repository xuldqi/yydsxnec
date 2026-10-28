import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class EmotionIntensitySlider extends StatelessWidget {
  final int intensity;
  final ValueChanged<int> onIntensityChanged;

  const EmotionIntensitySlider({
    super.key,
    required this.intensity,
    required this.onIntensityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('情绪强度', style: AppTheme.titleMedium),
            Text(
              '$intensity%',
              style: AppTheme.titleMedium.copyWith(
                color: AppTheme.mistyPurple,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Slider(
          value: intensity.toDouble(),
          min: 0,
          max: 100,
          activeColor: AppTheme.mistyPurple,
          label: intensity <= 33
              ? '弱'
              : intensity <= 66
              ? '中'
              : '强',
          onChanged: (value) => onIntensityChanged(value.round()),
        ),
      ],
    );
  }
}
