import 'package:flutter/material.dart';
import '../models/emotion_tag.dart';
import '../theme/app_theme.dart';

class EmotionTagSelector extends StatelessWidget {
  final List<EmotionTag> selectedTags;
  final ValueChanged<List<EmotionTag>> onTagsChanged;

  const EmotionTagSelector({
    super.key,
    required this.selectedTags,
    required this.onTagsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '选择标签',
          style: AppTheme.titleSmall.copyWith(color: AppTheme.primaryText),
        ),
        SizedBox(height: AppTheme.paddingS),
        Wrap(
          spacing: AppTheme.paddingS,
          runSpacing: AppTheme.paddingS,
          children: EmotionTag.values.map((tag) {
            final isSelected = selectedTags.contains(tag);
            return _TagChip(
              tag: tag,
              isSelected: isSelected,
              onTap: () {
                final newTags = List<EmotionTag>.from(selectedTags);
                if (isSelected) {
                  newTags.remove(tag);
                } else {
                  newTags.add(tag);
                }
                onTagsChanged(newTags);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _TagChip extends StatelessWidget {
  final EmotionTag tag;
  final bool isSelected;
  final VoidCallback onTap;

  const _TagChip({
    required this.tag,
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
          color: isSelected ? Color(tag.color) : AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(AppTheme.radiusL),
          border: Border.all(
            color: isSelected
                ? Color(tag.color)
                : AppTheme.lightText.withAlpha(50),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(tag.icon, style: const TextStyle(fontSize: 16)),
            SizedBox(width: AppTheme.paddingXS),
            Text(
              tag.value,
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
