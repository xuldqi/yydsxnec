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
            Text(
              '情绪强度',
              style: AppTheme.titleSmall.copyWith(color: AppTheme.primaryText),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.paddingM,
                vertical: AppTheme.paddingXS,
              ),
              decoration: BoxDecoration(
                color: AppTheme.mistyPurple.withAlpha(25),
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
              ),
              child: Text(
                '$intensity%',
                style: AppTheme.bodyLarge.copyWith(
                  color: AppTheme.mistyPurple,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppTheme.paddingM),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: AppTheme.mistyPurple,
            inactiveTrackColor: AppTheme.lightText.withAlpha(50),
            thumbColor: AppTheme.mistyPurple,
            overlayColor: AppTheme.mistyPurple.withAlpha(30),
            trackHeight: 6,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
            valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
            valueIndicatorColor: AppTheme.mistyPurple,
            valueIndicatorTextStyle: AppTheme.bodyLarge.copyWith(
              color: Colors.white,
            ),
          ),
          child: Slider(
            value: intensity.toDouble(),
            min: 0,
            max: 100,
            divisions: 20,
            label: '$intensity%',
            onChanged: (value) {
              onIntensityChanged(value.round());
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '轻微',
              style: AppTheme.bodySmall.copyWith(color: AppTheme.lightText),
            ),
            Text(
              '中等',
              style: AppTheme.bodySmall.copyWith(color: AppTheme.lightText),
            ),
            Text(
              '强烈',
              style: AppTheme.bodySmall.copyWith(color: AppTheme.lightText),
            ),
          ],
        ),
      ],
    );
  }
}
