enum EmotionTag {
  work(value: '工作', icon: '💼', color: 0xFF4FC3F7),
  family(value: '家庭', icon: '🏠', color: 0xFF81C784),
  health(value: '健康', icon: '❤️', color: 0xFFE57373),
  study(value: '学习', icon: '📚', color: 0xFFFFB74D),
  relationship(value: '感情', icon: '💕', color: 0xFFF06292),
  finance(value: '财务', icon: '💰', color: 0xFF9575CD),
  social(value: '社交', icon: '👥', color: 0xFF4DB6AC),
  exercise(value: '运动', icon: '🏃', color: 0xFF7986CB),
  entertainment(value: '娱乐', icon: '🎮', color: 0xFFBA68C8),
  other(value: '其他', icon: '📌', color: 0xFF90A4AE);

  const EmotionTag({
    required this.value,
    required this.icon,
    required this.color,
  });

  final String value;
  final String icon;
  final int color;

  static EmotionTag fromString(String name) {
    return EmotionTag.values.firstWhere(
      (tag) => tag.name == name,
      orElse: () => EmotionTag.other,
    );
  }

  static List<EmotionTag> fromStringList(String tagsString) {
    if (tagsString.isEmpty) return [];
    return tagsString.split(',').map((s) => fromString(s.trim())).toList();
  }
}
