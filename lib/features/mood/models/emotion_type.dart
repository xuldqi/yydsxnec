enum EmotionType {
  veryHappy(value: 5, label: '非常开心', emoji: '😄', color: 0xFF81C784),
  happy(value: 4, label: '开心', emoji: '😊', color: 0xFFAED581),
  neutral(value: 3, label: '平静', emoji: '😐', color: 0xFFFFB74D),
  sad(value: 2, label: '难过', emoji: '😢', color: 0xFFFF8A65),
  verySad(value: 1, label: '非常难过', emoji: '😭', color: 0xFFE57373);

  const EmotionType({
    required this.value,
    required this.label,
    required this.emoji,
    required this.color,
  });

  final int value;
  final String label;
  final String emoji;
  final int color;

  static EmotionType fromValue(int value) {
    return EmotionType.values.firstWhere(
      (emotion) => emotion.value == value,
      orElse: () => EmotionType.neutral,
    );
  }

  static EmotionType fromString(String name) {
    return EmotionType.values.firstWhere(
      (emotion) => emotion.name == name,
      orElse: () => EmotionType.neutral,
    );
  }
}