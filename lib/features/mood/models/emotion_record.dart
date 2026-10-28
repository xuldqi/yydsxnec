class EmotionRecord {
  final String id;
  final String mood;
  final String emoji;
  final String note;
  final double intensity;
  final DateTime createdAt;
  final List<String> imagePaths;
  final String? audioPath;
  final bool isTimeCapsule;
  final DateTime? unlockAt;
  final String triggerTag;
  final int bodyEnergy;
  final int bodySleep;
  final int bodyAppetite;
  final String menstrualStatus;
  final List<String> cycleSymptoms;
  final String cycleFunctionImpact;
  final List<String> additionalMoods;
  final List<String> additionalEmojis;

  // AI 情绪分析相关字段
  final String? aiDetectedMood; // AI 分析的情绪
  final String? aiDetectedEmoji; // AI 分析的 emoji
  final double? aiConfidence; // AI 置信度 (0.0 - 1.0)
  final String? aiSource; // 分析来源: 'text', 'voice', 'face'

  EmotionRecord({
    required this.id,
    required this.mood,
    required this.emoji,
    required this.note,
    this.intensity = 50.0,
    required this.createdAt,
    this.imagePaths = const [],
    this.audioPath,
    this.isTimeCapsule = false,
    this.unlockAt,
    this.triggerTag = '',
    this.bodyEnergy = 0,
    this.bodySleep = 0,
    this.bodyAppetite = 0,
    this.menstrualStatus = '',
    this.cycleSymptoms = const [],
    this.cycleFunctionImpact = '',
    this.additionalMoods = const [],
    this.additionalEmojis = const [],
    this.aiDetectedMood,
    this.aiDetectedEmoji,
    this.aiConfidence,
    this.aiSource,
  });

  List<String> get selectedMoods => [mood, ...additionalMoods];
  List<String> get selectedEmojis => [emoji, ...additionalEmojis];

  /// AI 分析结果是否与用户选择一致
  bool get isAiMatch => aiDetectedMood != null && aiDetectedMood == mood;

  /// 是否有 AI 分析结果
  bool get hasAiAnalysis => aiDetectedMood != null;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mood': mood,
      'emoji': emoji,
      'note': note,
      'intensity': intensity,
      'createdAt': createdAt.toIso8601String(),
      'imagePaths': imagePaths,
      'audioPath': audioPath,
      'isTimeCapsule': isTimeCapsule,
      'unlockAt': unlockAt?.toIso8601String(),
      'triggerTag': triggerTag,
      'bodyEnergy': bodyEnergy,
      'bodySleep': bodySleep,
      'bodyAppetite': bodyAppetite,
      'menstrualStatus': menstrualStatus,
      'cycleSymptoms': cycleSymptoms,
      'cycleFunctionImpact': cycleFunctionImpact,
      'additionalMoods': additionalMoods,
      'additionalEmojis': additionalEmojis,
      'aiDetectedMood': aiDetectedMood,
      'aiDetectedEmoji': aiDetectedEmoji,
      'aiConfidence': aiConfidence,
      'aiSource': aiSource,
    };
  }

  factory EmotionRecord.fromMap(Map<String, dynamic> map) {
    return EmotionRecord(
      id: map['id'] ?? '',
      mood: map['mood'] ?? '',
      emoji: map['emoji'] ?? '',
      note: map['note'] ?? '',
      intensity: (map['intensity'] ?? 50.0).toDouble(),
      createdAt: map['createdAt'] != null
          ? (DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now())
          : DateTime.now(),
      imagePaths: List<String>.from(map['imagePaths'] ?? []),
      audioPath: map['audioPath'],
      isTimeCapsule: map['isTimeCapsule'] == true,
      unlockAt: map['unlockAt'] != null
          ? DateTime.tryParse(map['unlockAt'])
          : null,
      triggerTag: map['triggerTag'] ?? '',
      bodyEnergy: map['bodyEnergy'] ?? 0,
      bodySleep: map['bodySleep'] ?? 0,
      bodyAppetite: map['bodyAppetite'] ?? 0,
      menstrualStatus: map['menstrualStatus'] ?? '',
      cycleSymptoms: List<String>.from(map['cycleSymptoms'] ?? const []),
      cycleFunctionImpact: map['cycleFunctionImpact'] ?? '',
      additionalMoods: List<String>.from(map['additionalMoods'] ?? const []),
      additionalEmojis: List<String>.from(map['additionalEmojis'] ?? const []),
      aiDetectedMood: map['aiDetectedMood'],
      aiDetectedEmoji: map['aiDetectedEmoji'],
      aiConfidence: map['aiConfidence'] != null
          ? (map['aiConfidence']).toDouble()
          : null,
      aiSource: map['aiSource'],
    );
  }

  EmotionRecord copyWith({
    String? id,
    String? mood,
    String? emoji,
    String? note,
    double? intensity,
    DateTime? createdAt,
    List<String>? imagePaths,
    String? audioPath,
    bool? isTimeCapsule,
    DateTime? unlockAt,
    String? triggerTag,
    int? bodyEnergy,
    int? bodySleep,
    int? bodyAppetite,
    String? menstrualStatus,
    List<String>? cycleSymptoms,
    String? cycleFunctionImpact,
    List<String>? additionalMoods,
    List<String>? additionalEmojis,
    String? aiDetectedMood,
    String? aiDetectedEmoji,
    double? aiConfidence,
    String? aiSource,
  }) {
    return EmotionRecord(
      id: id ?? this.id,
      mood: mood ?? this.mood,
      emoji: emoji ?? this.emoji,
      note: note ?? this.note,
      intensity: intensity ?? this.intensity,
      createdAt: createdAt ?? this.createdAt,
      imagePaths: imagePaths ?? this.imagePaths,
      audioPath: audioPath ?? this.audioPath,
      isTimeCapsule: isTimeCapsule ?? this.isTimeCapsule,
      unlockAt: unlockAt ?? this.unlockAt,
      triggerTag: triggerTag ?? this.triggerTag,
      bodyEnergy: bodyEnergy ?? this.bodyEnergy,
      bodySleep: bodySleep ?? this.bodySleep,
      bodyAppetite: bodyAppetite ?? this.bodyAppetite,
      menstrualStatus: menstrualStatus ?? this.menstrualStatus,
      cycleSymptoms: cycleSymptoms ?? this.cycleSymptoms,
      cycleFunctionImpact: cycleFunctionImpact ?? this.cycleFunctionImpact,
      additionalMoods: additionalMoods ?? this.additionalMoods,
      additionalEmojis: additionalEmojis ?? this.additionalEmojis,
      aiDetectedMood: aiDetectedMood ?? this.aiDetectedMood,
      aiDetectedEmoji: aiDetectedEmoji ?? this.aiDetectedEmoji,
      aiConfidence: aiConfidence ?? this.aiConfidence,
      aiSource: aiSource ?? this.aiSource,
    );
  }
}
