enum AssessmentCategory { standardizedScreener, selfReflection }

AssessmentCategory parseAssessmentCategory(String? value) {
  switch (value) {
    case 'standardized_screener':
      return AssessmentCategory.standardizedScreener;
    case 'self_reflection':
      return AssessmentCategory.selfReflection;
    default:
      return AssessmentCategory.selfReflection;
  }
}

extension AssessmentCategoryX on AssessmentCategory {
  String get storageValue {
    switch (this) {
      case AssessmentCategory.standardizedScreener:
        return 'standardized_screener';
      case AssessmentCategory.selfReflection:
        return 'self_reflection';
    }
  }

  String get label {
    switch (this) {
      case AssessmentCategory.standardizedScreener:
        return '标准化筛查';
      case AssessmentCategory.selfReflection:
        return '自我了解';
    }
  }
}

enum AssessmentSeverity { low, mild, moderate, elevated, high, urgent }

AssessmentSeverity parseAssessmentSeverity(String? value) {
  switch (value) {
    case 'low':
      return AssessmentSeverity.low;
    case 'mild':
      return AssessmentSeverity.mild;
    case 'moderate':
      return AssessmentSeverity.moderate;
    case 'elevated':
      return AssessmentSeverity.elevated;
    case 'high':
      return AssessmentSeverity.high;
    case 'urgent':
      return AssessmentSeverity.urgent;
    default:
      return AssessmentSeverity.mild;
  }
}

extension AssessmentSeverityX on AssessmentSeverity {
  String get storageValue {
    switch (this) {
      case AssessmentSeverity.low:
        return 'low';
      case AssessmentSeverity.mild:
        return 'mild';
      case AssessmentSeverity.moderate:
        return 'moderate';
      case AssessmentSeverity.elevated:
        return 'elevated';
      case AssessmentSeverity.high:
        return 'high';
      case AssessmentSeverity.urgent:
        return 'urgent';
    }
  }

  String get label {
    switch (this) {
      case AssessmentSeverity.low:
        return '低风险';
      case AssessmentSeverity.mild:
        return '轻度';
      case AssessmentSeverity.moderate:
        return '中度';
      case AssessmentSeverity.elevated:
        return '偏高';
      case AssessmentSeverity.high:
        return '高风险';
      case AssessmentSeverity.urgent:
        return '需要立即关注';
    }
  }
}

class AssessmentOption {
  final String label;
  final int score;

  const AssessmentOption({required this.label, required this.score});
}

class AssessmentQuestion {
  final String id;
  final String prompt;
  final List<AssessmentOption> options;
  final String? dimensionId;
  final bool special;
  final String? showWhenQuestionId;
  final int? showWhenScore;

  const AssessmentQuestion({
    required this.id,
    required this.prompt,
    required this.options,
    this.dimensionId,
    this.special = false,
    this.showWhenQuestionId,
    this.showWhenScore,
  });

  bool isVisible(Map<String, int> answersByQuestionId) {
    if (showWhenQuestionId == null) return true;
    return answersByQuestionId[showWhenQuestionId] == showWhenScore;
  }
}

class AssessmentBand {
  final int maxScore;
  final String title;
  final String summary;
  final String guidance;
  final String emoji;
  final AssessmentSeverity severity;
  final bool recommendProfessionalSupport;

  const AssessmentBand({
    required this.maxScore,
    required this.title,
    required this.summary,
    required this.guidance,
    required this.emoji,
    required this.severity,
    this.recommendProfessionalSupport = false,
  });
}

typedef AssessmentEvaluator =
    AssessmentResult Function({
      required MentalAssessmentDefinition definition,
      required Map<String, int> answersByQuestionId,
      required List<int> answersInDisplayOrder,
      required DateTime completedAt,
    });

class AssessmentResult {
  final String assessmentId;
  final String assessmentName;
  final AssessmentCategory category;
  final String resultTitle;
  final String summary;
  final String guidance;
  final String emoji;
  final int totalScore;
  final int maxScore;
  final AssessmentSeverity severity;
  final bool recommendProfessionalSupport;
  final bool urgentSafetyReview;
  final bool isStandardized;
  final String? sourceLabel;
  final String? periodLabel;
  final String? disclaimer;
  final DateTime createdAt;
  final List<int> answers;
  final Map<String, dynamic> extras;

  const AssessmentResult({
    required this.assessmentId,
    required this.assessmentName,
    required this.category,
    required this.resultTitle,
    required this.summary,
    required this.guidance,
    required this.emoji,
    required this.totalScore,
    required this.maxScore,
    required this.severity,
    required this.recommendProfessionalSupport,
    required this.urgentSafetyReview,
    required this.isStandardized,
    required this.createdAt,
    this.sourceLabel,
    this.periodLabel,
    this.disclaimer,
    this.answers = const [],
    this.extras = const {},
  });

  Map<String, dynamic> toMap() {
    return {
      'assessmentId': assessmentId,
      'assessmentName': assessmentName,
      'category': category.storageValue,
      'resultTitle': resultTitle,
      'summary': summary,
      'guidance': guidance,
      'emoji': emoji,
      'totalScore': totalScore,
      'maxScore': maxScore,
      'severity': severity.storageValue,
      'recommendProfessionalSupport': recommendProfessionalSupport,
      'urgentSafetyReview': urgentSafetyReview,
      'isStandardized': isStandardized,
      'sourceLabel': sourceLabel,
      'periodLabel': periodLabel,
      'disclaimer': disclaimer,
      'answers': answers,
      'extras': extras,
      'createdAt': createdAt.toIso8601String(),
      'testName': assessmentName,
      'resultText': resultTitle,
      'suggestion': summary,
    };
  }

  factory AssessmentResult.fromMap(Map<String, dynamic> map) {
    final createdAt =
        DateTime.tryParse(map['createdAt']?.toString() ?? '') ?? DateTime.now();

    if (map.containsKey('assessmentId')) {
      final rawAnswers = map['answers'];
      final answers = rawAnswers is List
          ? rawAnswers.map((e) => int.tryParse(e.toString()) ?? 0).toList()
          : <int>[];
      final rawExtras = map['extras'];
      final extras = rawExtras is Map
          ? Map<String, dynamic>.from(rawExtras)
          : <String, dynamic>{};

      return AssessmentResult(
        assessmentId: map['assessmentId']?.toString() ?? 'legacy_assessment',
        assessmentName: map['assessmentName']?.toString() ?? '心理评测',
        category: parseAssessmentCategory(map['category']?.toString()),
        resultTitle: map['resultTitle']?.toString() ?? '结果已生成',
        summary: map['summary']?.toString() ?? '',
        guidance: map['guidance']?.toString() ?? '',
        emoji: map['emoji']?.toString() ?? '🌿',
        totalScore: int.tryParse(map['totalScore']?.toString() ?? '') ?? 0,
        maxScore: int.tryParse(map['maxScore']?.toString() ?? '') ?? 0,
        severity: parseAssessmentSeverity(map['severity']?.toString()),
        recommendProfessionalSupport:
            map['recommendProfessionalSupport'] == true,
        urgentSafetyReview: map['urgentSafetyReview'] == true,
        isStandardized: map['isStandardized'] == true,
        sourceLabel: map['sourceLabel']?.toString(),
        periodLabel: map['periodLabel']?.toString(),
        disclaimer: map['disclaimer']?.toString(),
        createdAt: createdAt,
        answers: answers,
        extras: extras,
      );
    }

    return AssessmentResult(
      assessmentId: map['testName']?.toString() ?? 'legacy_self_reflection',
      assessmentName: map['testName']?.toString() ?? '情绪小测试',
      category: AssessmentCategory.selfReflection,
      resultTitle: map['resultText']?.toString() ?? '需要一点照顾',
      summary: map['suggestion']?.toString() ?? '',
      guidance: map['coping']?.toString() ?? '可以继续记录心情、做几轮呼吸练习，或和信任的人聊聊。',
      emoji: map['emoji']?.toString() ?? '🌿',
      totalScore: int.tryParse(map['totalScore']?.toString() ?? '') ?? 0,
      maxScore: int.tryParse(map['maxScore']?.toString() ?? '') ?? 20,
      severity: AssessmentSeverity.mild,
      recommendProfessionalSupport: false,
      urgentSafetyReview: false,
      isStandardized: false,
      createdAt: createdAt,
    );
  }
}

class MentalAssessmentDefinition {
  final String id;
  final String name;
  final String shortDescription;
  final String emoji;
  final String intro;
  final String durationLabel;
  final AssessmentCategory category;
  final String periodLabel;
  final String? sourceLabel;
  final String? disclaimer;
  final List<AssessmentQuestion> questions;
  final List<AssessmentBand> bands;
  final int? safetyQuestionIndex;
  final int safetyThresholdScore;
  final AssessmentEvaluator? customEvaluator;

  const MentalAssessmentDefinition({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.emoji,
    required this.intro,
    required this.durationLabel,
    required this.category,
    required this.periodLabel,
    required this.questions,
    required this.bands,
    this.sourceLabel,
    this.disclaimer,
    this.safetyQuestionIndex,
    this.safetyThresholdScore = 1,
    this.customEvaluator,
  });

  bool get isStandardized =>
      category == AssessmentCategory.standardizedScreener;

  int get maxScore {
    var total = 0;
    for (final question in questions) {
      if (question.options.isEmpty) continue;
      final scores = question.options.map((option) => option.score);
      total += scores.reduce((a, b) => a > b ? a : b);
    }
    return total;
  }

  AssessmentResult evaluate(List<int> answers, {DateTime? completedAt}) {
    final answersByQuestionId = <String, int>{};
    for (
      var index = 0;
      index < answers.length && index < questions.length;
      index++
    ) {
      answersByQuestionId[questions[index].id] = answers[index];
    }
    return evaluateByQuestionId(
      answersByQuestionId,
      completedAt: completedAt,
      answersInDisplayOrder: answers,
    );
  }

  List<AssessmentQuestion> visibleQuestions(
    Map<String, int> answersByQuestionId,
  ) {
    return questions
        .where((question) => question.isVisible(answersByQuestionId))
        .toList(growable: false);
  }

  AssessmentResult evaluateByQuestionId(
    Map<String, int> answersByQuestionId, {
    DateTime? completedAt,
    List<int>? answersInDisplayOrder,
  }) {
    final evaluatedAt = completedAt ?? DateTime.now();
    final visible = visibleQuestions(answersByQuestionId);
    final normalizedAnswers = answersInDisplayOrder != null
        ? List<int>.from(answersInDisplayOrder)
        : [
            for (final question in visible)
              answersByQuestionId[question.id] ?? 0,
          ];

    if (customEvaluator != null) {
      return customEvaluator!(
        definition: this,
        answersByQuestionId: Map<String, int>.from(answersByQuestionId),
        answersInDisplayOrder: normalizedAnswers,
        completedAt: evaluatedAt,
      );
    }

    if (bands.isEmpty) {
      throw StateError('Assessment "$id" has no score bands.');
    }

    final totalScore = normalizedAnswers.fold<int>(
      0,
      (sum, value) => sum + value,
    );
    final band = bands.firstWhere(
      (candidate) => totalScore <= candidate.maxScore,
      orElse: () => bands.last,
    );
    final urgentSafetyReview =
        safetyQuestionIndex != null &&
        normalizedAnswers.length > safetyQuestionIndex! &&
        normalizedAnswers[safetyQuestionIndex!] >= safetyThresholdScore;

    return AssessmentResult(
      assessmentId: id,
      assessmentName: name,
      category: category,
      resultTitle: band.title,
      summary: band.summary,
      guidance: band.guidance,
      emoji: band.emoji,
      totalScore: totalScore,
      maxScore: maxScore,
      severity: urgentSafetyReview ? AssessmentSeverity.urgent : band.severity,
      recommendProfessionalSupport:
          urgentSafetyReview || band.recommendProfessionalSupport,
      urgentSafetyReview: urgentSafetyReview,
      isStandardized: isStandardized,
      sourceLabel: sourceLabel,
      periodLabel: periodLabel,
      disclaimer: disclaimer,
      createdAt: evaluatedAt,
      answers: normalizedAnswers,
    );
  }
}
