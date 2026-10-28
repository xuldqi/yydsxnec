import '../../models/ai_emotion_result.dart';
import 'ai_emotion_service.dart';

/// 基于 dart_sentiment 的文本情绪分析器
/// 简单实现：使用关键词匹配和情感词表
class SimpleTextEmotionAnalyzer extends TextEmotionAnalyzer {
  @override
  String get name => 'SimpleTextEmotionAnalyzer';

  bool _isInitialized = false;

  /// 情绪关键词词典
  static const Map<String, List<String>> _emotionKeywords = {
    '开心': ['开心', '高兴', '快乐', '幸福', '愉快', '欢乐', '欣喜', '兴奋', '满足', '开心极了', '好开心', '太开心', '笑', '哈哈', '嘻嘻', '棒', '好', '赞', '完美', '精彩', '美好', '甜蜜', '温暖', '阳光', '漂亮', '美丽', '可爱', '喜欢', '爱', '感谢', '谢谢', '感恩', '幸运', '惊喜', '期待', '希望', '梦想'],
    '幸福': ['幸福', '温馨', '甜蜜', '美满', '感动', '珍惜', '宝贝', '家人', '朋友', '爱人', '恋人', '一起', '陪伴', '相守', '温馨', '浪漫', '甜蜜蜜', '恩爱', '亲情', '友情', '爱情'],
    '难过': ['难过', '伤心', '悲伤', '心痛', '心碎', '痛苦', '哭泣', '哭', '流泪', '眼泪', '失落', '沮丧', '绝望', '孤独', '寂寞', '空虚', '无助', '委屈', '心疼', '可惜', '遗憾', '想念', '思念', '怀念', '回忆', '离别', '分手', '失去', '离开', '走'],
    '生气': ['生气', '愤怒', '恼火', '烦躁', '讨厌', '恨', '厌恶', '不爽', '气愤', '火大', '爆发', '受够了', '烦死', '气死', '可恶', '混蛋', '滚', '傻', '蠢', '无语', '服了', '受不了', '忍不了', '不公平', '凭什么'],
    '焦虑': ['焦虑', '紧张', '担心', '担忧', '害怕', '恐惧', '不安', '烦躁', '着急', '急', '压力', '焦虑症', '恐慌', '忐忑', '心慌', '心悸', '失眠', '睡不着', '噩梦', '压力好大', '喘不过气', '崩溃', '抑郁', '压抑', '闷', '窒息', '想逃避', '逃避'],
    '疲惫': ['累', '疲惫', '疲倦', '疲劳', '困', '困倦', '睡', '困死', '累死', '疲惫不堪', '精疲力尽', '没精神', '没力气', '无力', '懒', '不想动', '休息', '放松', '好累', '好困', '想睡觉', '昏昏欲睡', '乏力'],
  };

  /// 负面词（用于降低正面情绪分数）
  static const List<String> _negativeModifiers = ['不', '没', '别', '不要', '不想', '不是', '没有', '不再'];

  @override
  bool get isInitialized => _isInitialized;

  @override
  Future<bool> initialize() async {
    // 简单实现无需初始化，直接返回 true
    _isInitialized = true;
    return true;
  }

  @override
  Future<void> dispose() async {
    _isInitialized = false;
  }

  @override
  Future<AiEmotionResult?> analyze(String text) async {
    if (!_isInitialized || text.trim().isEmpty) {
      return null;
    }

    final scores = <String, double>{};
    final lowerText = text.toLowerCase();

    // 计算每种情绪的匹配分数
    for (final entry in _emotionKeywords.entries) {
      final emotion = entry.key;
      final keywords = entry.value;
      
      double score = 0;
      for (final keyword in keywords) {
        final count = _countOccurrences(lowerText, keyword);
        if (count > 0) {
          // 关键词长度越长，权重越高
          score += count * (1 + keyword.length * 0.1);
        }
      }
      scores[emotion] = score;
    }

    // 检查否定词修饰
    for (final neg in _negativeModifiers) {
      if (lowerText.contains(neg)) {
        // 如果有否定词，降低最高分情绪的分数
        final maxEmotion = scores.entries
            .reduce((a, b) => a.value > b.value ? a : b)
            .key;
        scores[maxEmotion] = scores[maxEmotion]! * 0.3;
      }
    }

    // 找出得分最高的情绪
    if (scores.values.every((s) => s == 0)) {
      // 没有匹配到任何关键词，返回默认情绪
      return AiEmotionResult(
        mood: '开心',
        emoji: '😊',
        confidence: 0.3,
        source: source,
        rawLabel: 'neutral',
      );
    }

    final maxEntry = scores.entries.reduce((a, b) => a.value > b.value ? a : b);
    final totalScore = scores.values.reduce((a, b) => a + b);
    final confidence = totalScore > 0 ? (maxEntry.value / totalScore).clamp(0.3, 0.95) : 0.3;

    return AiEmotionResult(
      mood: maxEntry.key,
      emoji: EmotionMapping.getEmoji(maxEntry.key),
      confidence: confidence,
      source: source,
      rawLabel: maxEntry.key,
    );
  }

  /// 计算关键词出现次数
  int _countOccurrences(String text, String keyword) {
    int count = 0;
    int index = 0;
    while ((index = text.indexOf(keyword, index)) != -1) {
      count++;
      index += keyword.length;
    }
    return count;
  }
}

/// 基于情感分析的文本情绪分析器
/// 使用简单的情感分数计算
class SentimentTextEmotionAnalyzer extends TextEmotionAnalyzer {
  @override
  String get name => 'SentimentTextEmotionAnalyzer';

  bool _isInitialized = false;

  /// 正面情感词
  static const List<String> _positiveWords = [
    '好', '棒', '赞', '美', '甜', '暖', '爱', '喜', '乐', '笑',
    '开心', '高兴', '快乐', '幸福', '满足', '感谢', '幸运', '期待', '希望',
    '漂亮', '美丽', '可爱', '温柔', '体贴', '善良', '优秀', '完美', '精彩',
    '成功', '胜利', '进步', '成长', '收获', '惊喜', '感动', '珍惜',
  ];

  /// 负面情感词
  static const List<String> _negativeWords = [
    '差', '糟', '坏', '恨', '怒', '气', '哭', '痛', '苦', '累',
    '难过', '伤心', '悲伤', '痛苦', '绝望', '孤独', '寂寞', '失落',
    '生气', '愤怒', '讨厌', '烦躁', '焦虑', '紧张', '害怕', '恐惧',
    '疲惫', '疲倦', '困倦', '无力', '懒散', '抑郁', '压抑',
  ];

  /// 焦虑相关词
  static const List<String> _anxietyWords = [
    '焦虑', '紧张', '担心', '担忧', '害怕', '恐惧', '不安', '压力',
    '恐慌', '忐忑', '心慌', '失眠', '睡不着', '压力大', '崩溃', '喘不过气',
  ];

  /// 疲惫相关词
  static const List<String> _tiredWords = [
    '累', '疲惫', '疲倦', '疲劳', '困', '困倦', '没精神', '无力',
    '精疲力尽', '好累', '好困', '想睡觉', '乏力', '昏昏欲睡',
  ];

  /// 生气相关词
  static const List<String> _angryWords = [
    '生气', '愤怒', '恼火', '烦躁', '讨厌', '恨', '厌恶', '不爽',
    '火大', '爆发', '气死', '可恶', '混蛋', '滚', '服了', '受不了',
  ];

  /// 幸福相关词
  static const List<String> _loveWords = [
    '幸福', '温馨', '甜蜜', '美满', '感动', '珍惜', '宝贝', '家人',
    '朋友', '爱人', '恋人', '一起', '陪伴', '浪漫', '恩爱', '亲情',
  ];

  @override
  bool get isInitialized => _isInitialized;

  @override
  Future<bool> initialize() async {
    _isInitialized = true;
    return true;
  }

  @override
  Future<void> dispose() async {
    _isInitialized = false;
  }

  @override
  Future<AiEmotionResult?> analyze(String text) async {
    if (!_isInitialized || text.trim().isEmpty) {
      return null;
    }

    // 计算各类情绪分数
    final scores = <String, double>{
      '开心': _calculateScore(text, _positiveWords) - _calculateScore(text, _negativeWords),
      '幸福': _calculateScore(text, _loveWords) * 1.2,
      '难过': _calculateScore(text, _negativeWords) - _calculateScore(text, _angryWords) - _calculateScore(text, _anxietyWords) - _calculateScore(text, _tiredWords),
      '生气': _calculateScore(text, _angryWords) * 1.2,
      '焦虑': _calculateScore(text, _anxietyWords) * 1.2,
      '疲惫': _calculateScore(text, _tiredWords) * 1.2,
    };

    // 找出最高分情绪
    final maxEntry = scores.entries.reduce((a, b) => a.value > b.value ? a : b);
    
    if (maxEntry.value <= 0) {
      // 没有明显情绪倾向，返回默认
      return AiEmotionResult(
        mood: '开心',
        emoji: '😊',
        confidence: 0.3,
        source: source,
        rawLabel: 'neutral',
      );
    }

    // 计算置信度
    final positiveScores = scores.values.where((v) => v > 0).toList();
    final totalPositive = positiveScores.isEmpty ? 0.0 : positiveScores.reduce((a, b) => a + b);
    final confidence = totalPositive > 0 
        ? (maxEntry.value / totalPositive).clamp(0.4, 0.9) 
        : 0.4;

    return AiEmotionResult(
      mood: maxEntry.key,
      emoji: EmotionMapping.getEmoji(maxEntry.key),
      confidence: confidence,
      source: source,
      rawLabel: maxEntry.key,
    );
  }

  double _calculateScore(String text, List<String> words) {
    double score = 0;
    for (final word in words) {
      if (text.contains(word)) {
        score += 1 + word.length * 0.1;
      }
    }
    return score;
  }
}
