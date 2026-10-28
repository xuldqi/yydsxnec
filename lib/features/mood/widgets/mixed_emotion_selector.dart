import 'package:flutter/material.dart';
import '../models/emotion_type.dart';
import '../theme/app_theme.dart';

class MixedEmotionSelector extends StatelessWidget {
  final List<EmotionType> selectedEmotions;
  final ValueChanged<List<EmotionType>> onEmotionsChanged;
  final EmotionType? primaryEmotion;

  const MixedEmotionSelector({
    super.key,
    required this.selectedEmotions,
    required this.onEmotionsChanged,
    this.primaryEmotion,
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
              '混合情绪',
              style: AppTheme.titleSmall.copyWith(color: AppTheme.primaryText),
            ),
            if (selectedEmotions.isNotEmpty)
              Text(
                '已选 ${selectedEmotions.length} 种',
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.secondaryText,
                ),
              ),
          ],
        ),
        SizedBox(height: AppTheme.paddingM),
        Wrap(
          spacing: AppTheme.paddingS,
          runSpacing: AppTheme.paddingS,
          children: EmotionType.values.map((emotion) {
            final isSelected = selectedEmotions.contains(emotion);
            final isPrimary = primaryEmotion == emotion;

            if (isPrimary) return const SizedBox.shrink();

            return _EmotionChip(
              emotion: emotion,
              isSelected: isSelected,
              onTap: () {
                final newEmotions = List<EmotionType>.from(selectedEmotions);
                if (isSelected) {
                  newEmotions.remove(emotion);
                } else if (selectedEmotions.length < 3) {
                  newEmotions.add(emotion);
                }
                onEmotionsChanged(newEmotions);
              },
            );
          }).toList(),
        ),
        if (selectedEmotions.length >= 3)
          Padding(
            padding: EdgeInsets.only(top: AppTheme.paddingS),
            child: Text(
              '最多选择3种混合情绪',
              style: AppTheme.bodySmall.copyWith(color: AppTheme.lightText),
            ),
          ),
      ],
    );
  }
}

class _EmotionChip extends StatelessWidget {
  final EmotionType emotion;
  final bool isSelected;
  final VoidCallback onTap;

  const _EmotionChip({
    required this.emotion,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppTheme.shortAnimation,
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.paddingM,
          vertical: AppTheme.paddingS,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Color(emotion.color) : AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(AppTheme.radiusL),
          border: Border.all(
            color: isSelected
                ? Color(emotion.color)
                : AppTheme.lightText.withAlpha(50),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emotion.emoji, style: const TextStyle(fontSize: 16)),
            SizedBox(width: AppTheme.paddingXS),
            Text(
              emotion.label,
              style: AppTheme.bodySmall.copyWith(
                color: isSelected ? Colors.white : AppTheme.primaryText,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
