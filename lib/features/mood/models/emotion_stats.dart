import 'emotion_type.dart';

class EmotionStats {
  final Map<EmotionType, int> emotionCounts;
  final Map<DateTime, double> dailyAverages;
  final Map<String, int> wordFrequency;
  final int totalRecords;
  final DateTime? firstRecordDate;
  final DateTime? lastRecordDate;

  const EmotionStats({
    required this.emotionCounts,
    required this.dailyAverages,
    required this.wordFrequency,
    required this.totalRecords,
    this.firstRecordDate,
    this.lastRecordDate,
  });

  double get averageEmotion {
    if (totalRecords == 0) return 0;
    
    int totalValue = 0;
    emotionCounts.forEach((emotion, count) {
      totalValue += emotion.value * count;
    });
    
    return totalValue / totalRecords;
  }

  EmotionType get dominantEmotion {
    if (emotionCounts.isEmpty) return EmotionType.neutral;
    
    return emotionCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }
  
  EmotionType? getAverageEmotion() {
    if (totalRecords == 0) return null;
    
    final avgValue = averageEmotion;
    return EmotionType.values
        .reduce((a, b) => (a.value - avgValue).abs() < (b.value - avgValue).abs() ? a : b);
  }
  
  EmotionType? getDominantEmotion() {
    if (emotionCounts.isEmpty) return null;
    return dominantEmotion;
  }

  List<MapEntry<String, int>> get topWords {
    final sortedWords = wordFrequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sortedWords.take(20).toList();
  }

  EmotionStats copyWith({
    Map<EmotionType, int>? emotionCounts,
    Map<DateTime, double>? dailyAverages,
    Map<String, int>? wordFrequency,
    int? totalRecords,
    DateTime? firstRecordDate,
    DateTime? lastRecordDate,
  }) {
    return EmotionStats(
      emotionCounts: emotionCounts ?? this.emotionCounts,
      dailyAverages: dailyAverages ?? this.dailyAverages,
      wordFrequency: wordFrequency ?? this.wordFrequency,
      totalRecords: totalRecords ?? this.totalRecords,
      firstRecordDate: firstRecordDate ?? this.firstRecordDate,
      lastRecordDate: lastRecordDate ?? this.lastRecordDate,
    );
  }

  static EmotionStats empty() {
    return const EmotionStats(
      emotionCounts: {},
      dailyAverages: {},
      wordFrequency: {},
      totalRecords: 0,
    );
  }
}