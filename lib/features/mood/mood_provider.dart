import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'services/database_service.dart';

class EmotionRecord {
  final String id;
  final int mood; // 0-4
  final String emoji;
  final String note;
  final DateTime createdAt;

  const EmotionRecord({
    required this.id,
    required this.mood,
    required this.emoji,
    required this.note,
    required this.createdAt,
  });
}

class MoodState {
  final List<EmotionRecord> records;
  const MoodState({this.records = const []});

  MoodState copyWith({List<EmotionRecord>? records}) =>
      MoodState(records: records ?? this.records);
}

int _mapMoodStringToInt(String moodStr) {
  switch (moodStr) {
    case '难过':
    case '0':
      return 0;
    case '焦虑':
    case '生气':
    case '焦虑/生气':
    case '1':
      return 1;
    case '平静':
    case '疲惫':
    case '平静/疲惫':
    case '2':
      return 2;
    case '开心':
    case '3':
      return 3;
    case '幸福':
    case '4':
      return 4;
    default:
      return int.tryParse(moodStr) ?? 2;
  }
}

class MoodNotifier extends AsyncNotifier<MoodState> {
  final DatabaseService _database = DatabaseService();

  @override
  Future<MoodState> build() async {
    return _load();
  }

  Future<MoodState> _load() async {
    try {
      final list = await _database.getEmotionRecords();
      final records = list.map((map) {
        final createdAtStr = map['createdAt'] as String?;
        final createdAt = createdAtStr != null
            ? DateTime.parse(createdAtStr)
            : DateTime.now();
        return EmotionRecord(
          id: map['id'] as String? ?? '',
          mood: _mapMoodStringToInt(map['mood']?.toString() ?? ''),
          emoji: map['emoji'] as String? ?? '😐',
          note: map['note'] as String? ?? '',
          createdAt: createdAt,
        );
      }).toList();
      // Sort newest first
      records.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return MoodState(records: records);
    } catch (e) {
      return const MoodState();
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _load());
  }

  Future<void> load() => refresh();

  Future<void> addRecord({
    required int mood,
    required String emoji,
    required String note,
  }) async {
    final now = DateTime.now();
    final moodLabels = ['难过', '焦虑/生气', '平静/疲惫', '开心', '幸福'];
    final moodStr = (mood >= 0 && mood < moodLabels.length) ? moodLabels[mood] : '平静/疲惫';
    final recordMap = {
      'id': now.millisecondsSinceEpoch.toString(),
      'mood': moodStr,
      'emoji': emoji,
      'note': note,
      'createdAt': now.toIso8601String(),
    };
    await _database.insertEmotionRecord(recordMap);
    await refresh();
  }
}

final moodProvider = AsyncNotifierProvider<MoodNotifier, MoodState>(() {
  return MoodNotifier();
});
