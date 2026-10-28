import 'emotion_type.dart';

class EmotionInsight {
  final String id;
  final String title;
  final String description;
  final String? icon;
  final List<EmotionType> relatedEmotions;

  const EmotionInsight({
    required this.id,
    required this.title,
    required this.description,
    this.icon,
    this.relatedEmotions = const [],
  });

  EmotionInsight copyWith({
    String? id,
    String? title,
    String? description,
    String? icon,
    List<EmotionType>? relatedEmotions,
  }) {
    return EmotionInsight(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      relatedEmotions: relatedEmotions ?? this.relatedEmotions,
    );
  }
}
