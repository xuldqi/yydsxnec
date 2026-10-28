import '../models/mental_assessment.dart';

class BigFiveScoring {
  static const List<String> traitOrder = ['O', 'C', 'E', 'A', 'N'];

  static const Map<String, String> traitMeta = {
    'O': '开放性',
    'C': '尽责性',
    'E': '外向性',
    'A': '宜人性',
    'N': '情绪敏感度',
  };

  static const List<AssessmentOption> _agreementOptions = [
    AssessmentOption(label: '非常不同意', score: 1),
    AssessmentOption(label: '不同意', score: 2),
    AssessmentOption(label: '一般', score: 3),
    AssessmentOption(label: '同意', score: 4),
    AssessmentOption(label: '非常同意', score: 5),
  ];

  static const List<_BigFiveSeed> _seedStatements = [
    // O
    _BigFiveSeed(
      id: 'big5_o_01',
      trait: 'O',
      prompt: '我愿意尝试新观点和新方法。',
      reversed: false,
    ),
    _BigFiveSeed(
      id: 'big5_o_02',
      trait: 'O',
      prompt: '我更喜欢重复熟悉套路，不愿意改变做法。',
      reversed: true,
    ),
    _BigFiveSeed(
      id: 'big5_o_03',
      trait: 'O',
      prompt: '跨领域学习会让我感到兴奋。',
      reversed: false,
    ),
    _BigFiveSeed(
      id: 'big5_o_04',
      trait: 'O',
      prompt: '抽象概念对我来说通常没有意义。',
      reversed: true,
    ),

    // C
    _BigFiveSeed(
      id: 'big5_c_01',
      trait: 'C',
      prompt: '我会把任务拆解后按计划推进。',
      reversed: false,
    ),
    _BigFiveSeed(
      id: 'big5_c_02',
      trait: 'C',
      prompt: '我经常拖到最后一刻才处理重要事情。',
      reversed: true,
    ),
    _BigFiveSeed(
      id: 'big5_c_03',
      trait: 'C',
      prompt: '我习惯在截止日前预留缓冲时间。',
      reversed: false,
    ),
    _BigFiveSeed(
      id: 'big5_c_04',
      trait: 'C',
      prompt: '我的日程和待办通常比较混乱。',
      reversed: true,
    ),

    // E
    _BigFiveSeed(
      id: 'big5_e_01',
      trait: 'E',
      prompt: '在社交场景里我通常会主动开启互动。',
      reversed: false,
    ),
    _BigFiveSeed(
      id: 'big5_e_02',
      trait: 'E',
      prompt: '在人多的场合里，我更常保持安静观察。',
      reversed: true,
    ),
    _BigFiveSeed(
      id: 'big5_e_03',
      trait: 'E',
      prompt: '团队讨论会让我更有能量。',
      reversed: false,
    ),
    _BigFiveSeed(
      id: 'big5_e_04',
      trait: 'E',
      prompt: '频繁社交通常会消耗我很多精力。',
      reversed: true,
    ),

    // A
    _BigFiveSeed(
      id: 'big5_a_01',
      trait: 'A',
      prompt: '我会优先考虑他人感受并避免无谓冲突。',
      reversed: false,
    ),
    _BigFiveSeed(
      id: 'big5_a_02',
      trait: 'A',
      prompt: '我常在争论里坚持“赢”比“理解”更重要。',
      reversed: true,
    ),
    _BigFiveSeed(
      id: 'big5_a_03',
      trait: 'A',
      prompt: '在合作中我更倾向寻找双方可接受的方案。',
      reversed: false,
    ),
    _BigFiveSeed(
      id: 'big5_a_04',
      trait: 'A',
      prompt: '我对他人的失误通常缺乏耐心。',
      reversed: true,
    ),

    // N
    _BigFiveSeed(
      id: 'big5_n_01',
      trait: 'N',
      prompt: '小压力也容易让我持续紧绷。',
      reversed: false,
    ),
    _BigFiveSeed(
      id: 'big5_n_02',
      trait: 'N',
      prompt: '我通常能很快从负面情绪中恢复。',
      reversed: true,
    ),
    _BigFiveSeed(
      id: 'big5_n_03',
      trait: 'N',
      prompt: '不确定性会明显影响我的情绪稳定。',
      reversed: false,
    ),
    _BigFiveSeed(
      id: 'big5_n_04',
      trait: 'N',
      prompt: '在高压情境下，我依然能保持平稳。',
      reversed: true,
    ),
  ];

  static final Map<String, bool> _reverseByQuestionId = {};

  static final List<AssessmentQuestion> quickQuestions = _buildTierQuestions(
    targetCount: 20,
    tierKey: 'q20',
  );
  static final List<AssessmentQuestion> fullQuestions = _buildTierQuestions(
    targetCount: 50,
    tierKey: 'q50',
  );
  static final List<AssessmentQuestion> advancedQuestions = _buildTierQuestions(
    targetCount: 120,
    tierKey: 'q120',
  );

  static bool isReverseKeyed(String questionId) {
    return _reverseByQuestionId[questionId] ?? false;
  }

  static List<AssessmentQuestion> _buildTierQuestions({
    required int targetCount,
    required String tierKey,
  }) {
    final byTrait = <String, List<_BigFiveSeed>>{
      for (final trait in traitOrder) trait: <_BigFiveSeed>[],
    };
    for (final seed in _seedStatements) {
      byTrait[seed.trait]!.add(seed);
    }

    final counters = <String, int>{for (final trait in traitOrder) trait: 0};
    final result = <AssessmentQuestion>[];

    while (result.length < targetCount) {
      for (final trait in traitOrder) {
        if (result.length >= targetCount) break;
        final pool = byTrait[trait]!;
        if (pool.isEmpty) continue;
        final cursor = counters[trait] ?? 0;
        final seed = pool[cursor % pool.length];
        final round = cursor ~/ pool.length;
        final prefix = _roundPrefix(round);
        final prompt = prefix == null ? seed.prompt : '$prefix${seed.prompt}';
        final questionId = '${seed.id}_${tierKey}_${cursor + 1}';
        _reverseByQuestionId[questionId] = seed.reversed;
        result.add(
          AssessmentQuestion(
            id: questionId,
            prompt: prompt,
            options: _agreementOptions,
            dimensionId: seed.trait,
          ),
        );
        counters[trait] = cursor + 1;
      }
    }
    return result;
  }

  static String? _roundPrefix(int round) {
    return switch (round) {
      0 => null,
      1 => '在工作/学习场景中，',
      2 => '在亲密关系或密集社交中，',
      _ => '在连续高压与睡眠不足时，',
    };
  }

  static AssessmentResult evaluate({
    required MentalAssessmentDefinition definition,
    required Map<String, int> answersByQuestionId,
    required List<int> answersInDisplayOrder,
    required DateTime completedAt,
  }) {
    final sums = <String, double>{for (final trait in traitOrder) trait: 0};
    final counts = <String, int>{for (final trait in traitOrder) trait: 0};

    for (final question in definition.questions) {
      final trait = question.dimensionId;
      if (trait == null || !sums.containsKey(trait)) continue;
      final answer = answersByQuestionId[question.id] ?? 0;
      if (answer < 1 || answer > 5) continue;
      final reverse = isReverseKeyed(question.id);
      final scored = reverse ? (6 - answer) : answer;
      sums[trait] = (sums[trait] ?? 0) + scored;
      counts[trait] = (counts[trait] ?? 0) + 1;
    }

    final traitAverages = <String, double>{};
    final traitPercentiles = <String, int>{};
    final dimensionBreakdown = <Map<String, dynamic>>[];
    for (final trait in traitOrder) {
      final count = counts[trait] ?? 0;
      final average = count == 0 ? 3.0 : (sums[trait] ?? 0) / count;
      final percentile = _toPercentile(average);
      traitAverages[trait] = average;
      traitPercentiles[trait] = percentile;
      dimensionBreakdown.add({
        'traitId': trait,
        'traitName': traitMeta[trait] ?? trait,
        'average': double.parse(average.toStringAsFixed(2)),
        'percentile': percentile,
      });
    }

    final ranked = traitPercentiles.entries.toList(growable: false)
      ..sort((a, b) => b.value.compareTo(a.value));
    final top = ranked.first;
    final second = ranked[1];
    final bottom = ranked.last;
    final confidence = (top.value - second.value).clamp(0, 100);

    return AssessmentResult(
      assessmentId: definition.id,
      assessmentName: definition.name,
      category: definition.category,
      resultTitle: '大五人格 · ${traitMeta[top.key]}突出',
      summary:
          '你当前最突出的维度是「${traitMeta[top.key]}」，相对较低的是「${traitMeta[bottom.key]}」。',
      guidance: '建议把高分维度作为优势场景，把低分维度作为补位能力逐步训练。\n你当前的维度差异清晰度约为 $confidence%。',
      emoji: definition.emoji,
      totalScore: top.value,
      maxScore: 100,
      severity: AssessmentSeverity.low,
      recommendProfessionalSupport: false,
      urgentSafetyReview: false,
      isStandardized: definition.isStandardized,
      sourceLabel: definition.sourceLabel,
      periodLabel: definition.periodLabel,
      disclaimer: definition.disclaimer,
      createdAt: completedAt,
      answers: List<int>.from(answersInDisplayOrder),
      extras: {
        'bigFive': {
          'dominantTrait': top.key,
          'dominantTraitName': traitMeta[top.key],
          'traitPercentiles': traitPercentiles,
          'dimensionBreakdown': dimensionBreakdown,
          'confidence': confidence,
          'questionCount': answersInDisplayOrder.length,
        },
      },
    );
  }

  static int _toPercentile(double avg) {
    return (((avg - 1) / 4) * 100).clamp(0, 100).round();
  }
}

class _BigFiveSeed {
  final String id;
  final String trait;
  final String prompt;
  final bool reversed;

  const _BigFiveSeed({
    required this.id,
    required this.trait,
    required this.prompt,
    required this.reversed,
  });
}
