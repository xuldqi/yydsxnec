/// AI 情绪分析结果模型
class AiEmotionResult {
  /// 识别出的情绪标签（中文）：开心、幸福、难过、生气、焦虑、疲惫
  final String mood;
  
  /// 对应的 emoji
  final String emoji;
  
  /// 置信度 (0.0 - 1.0)
  final double confidence;
  
  /// 分析来源：'text', 'voice', 'face'
  final String source;
  
  /// 原始识别结果（用于调试）
  final String? rawLabel;
  
  /// 额外信息（如语音转文字结果）
  final Map<String, dynamic>? extra;

  const AiEmotionResult({
    required this.mood,
    required this.emoji,
    required this.confidence,
    required this.source,
    this.rawLabel,
    this.extra,
  });

  /// 是否为有效的情绪识别结果
  bool get isValid => mood.isNotEmpty && confidence > 0;

  /// 置信度等级描述
  String get confidenceLevel {
    if (confidence >= 0.8) return '很高';
    if (confidence >= 0.6) return '较高';
    if (confidence >= 0.4) return '中等';
    return '较低';
  }

  Map<String, dynamic> toMap() {
    return {
      'mood': mood,
      'emoji': emoji,
      'confidence': confidence,
      'source': source,
      'rawLabel': rawLabel,
      'extra': extra,
    };
  }

  factory AiEmotionResult.fromMap(Map<String, dynamic> map) {
    return AiEmotionResult(
      mood: map['mood'] ?? '',
      emoji: map['emoji'] ?? '',
      confidence: (map['confidence'] ?? 0.0).toDouble(),
      source: map['source'] ?? '',
      rawLabel: map['rawLabel'],
      extra: map['extra'] != null 
          ? Map<String, dynamic>.from(map['extra']) 
          : null,
    );
  }

  @override
  String toString() {
    return 'AiEmotionResult(mood: $mood, emoji: $emoji, confidence: ${confidence.toStringAsFixed(2)}, source: $source)';
  }
}

/// AI 情绪分析来源
enum AiEmotionSource {
  text('text', '文本分析'),
  voice('voice', '语音分析'),
  face('face', '人脸分析');

  final String value;
  final String label;

  const AiEmotionSource(this.value, this.label);
}

/// 情绪映射配置
class EmotionMapping {
  /// AI 识别结果到应用内情绪的映射
  static const Map<String, String> moodMapping = {
    // 英文标签
    'happy': '开心',
    'joy': '开心',
    'sad': '难过',
    'sadness': '难过',
    'angry': '生气',
    'anger': '生气',
    'fear': '焦虑',
    'anxiety': '焦虑',
    'fearful': '焦虑',
    'tired': '疲惫',
    'fatigue': '疲惫',
    'love': '幸福',
    'neutral': '开心', // 中性默认映射到开心
    
    // 中文标签（直接匹配）
    '开心': '开心',
    '幸福': '幸福',
    '难过': '难过',
    '生气': '生气',
    '焦虑': '焦虑',
    '疲惫': '疲惫',
  };

  /// 情绪对应的 emoji
  static const Map<String, String> moodEmoji = {
    '开心': '😊',
    '幸福': '🥰',
    '难过': '😢',
    '生气': '😠',
    '焦虑': '😰',
    '疲惫': '😴',
  };

  /// 将 AI 识别的情绪标签映射到应用内情绪
  static String mapToMood(String rawLabel) {
    final lower = rawLabel.toLowerCase().trim();
    return moodMapping[lower] ?? moodMapping[rawLabel] ?? '开心';
  }

  /// 获取情绪对应的 emoji
  static String getEmoji(String mood) {
    return moodEmoji[mood] ?? '😐';
  }
}
