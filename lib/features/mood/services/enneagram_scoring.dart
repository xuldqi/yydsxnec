import '../models/mental_assessment.dart';

class EnneagramScoring {
  static const List<String> typeOrder = [
    'T1',
    'T2',
    'T3',
    'T4',
    'T5',
    'T6',
    'T7',
    'T8',
    'T9',
  ];

  static const List<AssessmentOption> _agreementOptions = [
    AssessmentOption(label: '非常不像我', score: 1),
    AssessmentOption(label: '不太像我', score: 2),
    AssessmentOption(label: '一般', score: 3),
    AssessmentOption(label: '比较像我', score: 4),
    AssessmentOption(label: '非常像我', score: 5),
  ];

  static AssessmentQuestion _q(String id, String type, String prompt) {
    return AssessmentQuestion(
      id: id,
      prompt: prompt,
      dimensionId: type,
      options: _agreementOptions,
    );
  }

  static final List<AssessmentQuestion> _seedQuestions = [
    _q('en_t1_01', 'T1', '我对“正确做事”有较强标准，看到问题会想纠正。'),
    _q('en_t1_02', 'T1', '我对自己和他人的失误都比较敏感。'),
    _q('en_t1_03', 'T1', '我倾向于克制情绪，以保证事情可控。'),

    _q('en_t2_01', 'T2', '我常通过帮助他人来建立关系价值。'),
    _q('en_t2_02', 'T2', '我很在意自己是否被需要、被认可。'),
    _q('en_t2_03', 'T2', '我有时会把他人的需求放在自己前面。'),

    _q('en_t3_01', 'T3', '我会主动设定目标，并希望结果可见、可衡量。'),
    _q('en_t3_02', 'T3', '我很在意效率与表现，不喜欢低效停滞。'),
    _q('en_t3_03', 'T3', '我倾向于用“成果”来判断自己状态。'),

    _q('en_t4_01', 'T4', '我对情绪和内在体验非常敏感。'),
    _q('en_t4_02', 'T4', '我会追求独特表达，不太愿意随大流。'),
    _q('en_t4_03', 'T4', '当关系失衡时，我容易进入强烈感受。'),

    _q('en_t5_01', 'T5', '我会通过收集信息与理解原理来获得安全感。'),
    _q('en_t5_02', 'T5', '我倾向于保持心理空间，不喜欢被频繁打扰。'),
    _q('en_t5_03', 'T5', '面对复杂问题时，我会先观察再行动。'),

    _q('en_t6_01', 'T6', '我会预判风险并提前做准备。'),
    _q('en_t6_02', 'T6', '在关键决定上，我会反复核对是否可靠。'),
    _q('en_t6_03', 'T6', '我对不确定性比较警觉，倾向保留后手。'),

    _q('en_t7_01', 'T7', '我喜欢保持选择空间，探索更多可能性。'),
    _q('en_t7_02', 'T7', '我不喜欢被长期困在单一、沉重的状态里。'),
    _q('en_t7_03', 'T7', '当压力来临时，我会主动寻找新出口。'),

    _q('en_t8_01', 'T8', '我会直接表达立场，遇到问题倾向正面解决。'),
    _q('en_t8_02', 'T8', '我不喜欢被控制，更愿意掌握主动权。'),
    _q('en_t8_03', 'T8', '在团队里我愿意扛责任，也会要求清晰边界。'),

    _q('en_t9_01', 'T9', '我倾向维持和谐，不希望冲突持续升级。'),
    _q('en_t9_02', 'T9', '我会先看各方立场，再尝试找平衡点。'),
    _q('en_t9_03', 'T9', '我有时会先顺着局面走，延后表达自己的想法。'),
  ];

  static final List<AssessmentQuestion> quickQuestions = _buildTierQuestions(
    targetCount: 36,
    tierKey: 'q36',
  );
  static final List<AssessmentQuestion> fullQuestions = _buildTierQuestions(
    targetCount: 108,
    tierKey: 'q108',
  );

  static List<AssessmentQuestion> _buildTierQuestions({
    required int targetCount,
    required String tierKey,
  }) {
    final byType = <String, List<AssessmentQuestion>>{
      for (final type in typeOrder) type: <AssessmentQuestion>[],
    };
    for (final question in _seedQuestions) {
      final type = question.dimensionId;
      if (type == null) continue;
      byType[type]!.add(question);
    }

    final counters = <String, int>{for (final type in typeOrder) type: 0};
    final result = <AssessmentQuestion>[];

    while (result.length < targetCount) {
      for (final type in typeOrder) {
        if (result.length >= targetCount) break;
        final pool = byType[type]!;
        if (pool.isEmpty) continue;
        final cursor = counters[type] ?? 0;
        final seed = pool[cursor % pool.length];
        final round = cursor ~/ pool.length;
        final prefix = _roundPrefix(round);
        final prompt = prefix == null ? seed.prompt : '$prefix${seed.prompt}';
        result.add(
          AssessmentQuestion(
            id: '${seed.id}_${tierKey}_${cursor + 1}',
            prompt: prompt,
            options: seed.options,
            dimensionId: seed.dimensionId,
          ),
        );
        counters[type] = cursor + 1;
      }
    }
    return result;
  }

  static String? _roundPrefix(int round) {
    return switch (round) {
      0 => null,
      1 => '在工作/学习场景中，',
      2 => '在亲密关系场景中，',
      _ => '在高压且时间紧张时，',
    };
  }

  static const Map<String, _EnneagramProfile> _profiles = {
    '1': _EnneagramProfile(name: '改革者', intro: '重原则、追求改进、责任感强。'),
    '2': _EnneagramProfile(name: '助人者', intro: '重关系、善支持、渴望被需要。'),
    '3': _EnneagramProfile(name: '成就者', intro: '目标导向、行动高效、重视成果。'),
    '4': _EnneagramProfile(name: '自我者', intro: '情感细腻、追求独特与真实。'),
    '5': _EnneagramProfile(name: '观察者', intro: '理性深思、重边界、喜钻研。'),
    '6': _EnneagramProfile(name: '怀疑者', intro: '警觉审慎、重安全、擅风险预判。'),
    '7': _EnneagramProfile(name: '享乐者', intro: '积极外放、探索导向、点子丰富。'),
    '8': _EnneagramProfile(name: '挑战者', intro: '果断直接、重掌控、保护弱者。'),
    '9': _EnneagramProfile(name: '调停者', intro: '温和包容、重和谐、擅协调。'),
  };

  static const Map<String, _DirectionPair> _directions = {
    '1': _DirectionPair(stress: '4', growth: '7'),
    '2': _DirectionPair(stress: '8', growth: '4'),
    '3': _DirectionPair(stress: '9', growth: '6'),
    '4': _DirectionPair(stress: '2', growth: '1'),
    '5': _DirectionPair(stress: '7', growth: '8'),
    '6': _DirectionPair(stress: '3', growth: '9'),
    '7': _DirectionPair(stress: '1', growth: '5'),
    '8': _DirectionPair(stress: '5', growth: '2'),
    '9': _DirectionPair(stress: '6', growth: '3'),
  };

  static AssessmentResult evaluate({
    required MentalAssessmentDefinition definition,
    required Map<String, int> answersByQuestionId,
    required List<int> answersInDisplayOrder,
    required DateTime completedAt,
  }) {
    final sums = <String, double>{for (final type in typeOrder) type: 0};
    final counts = <String, int>{for (final type in typeOrder) type: 0};

    for (final question in definition.questions) {
      final type = question.dimensionId;
      if (type == null || !sums.containsKey(type)) continue;
      final answer = answersByQuestionId[question.id] ?? 0;
      if (answer < 1 || answer > 5) continue;
      sums[type] = (sums[type] ?? 0) + answer;
      counts[type] = (counts[type] ?? 0) + 1;
    }

    final typeScores = <String, int>{};
    for (final type in typeOrder) {
      final count = counts[type] ?? 0;
      final avg = count == 0 ? 3.0 : (sums[type] ?? 0) / count;
      typeScores[_typeCode(type)] = _toPercentile(avg);
    }

    final ranked = typeScores.entries.toList(growable: false)
      ..sort((a, b) => b.value.compareTo(a.value));
    final primary = ranked[0];
    final secondary = ranked[1];
    final primaryCode = primary.key;
    final wing = _resolveWing(primaryCode, typeScores);
    final clarity = (primary.value - secondary.value).clamp(0, 100);
    final direction = _directions[primaryCode]!;
    final profile = _profiles[primaryCode]!;

    final topTypes = ranked
        .take(3)
        .map((entry) {
          final p = _profiles[entry.key]!;
          return <String, dynamic>{
            'code': int.parse(entry.key),
            'name': p.name,
            'score': entry.value,
          };
        })
        .toList(growable: false);

    return AssessmentResult(
      assessmentId: definition.id,
      assessmentName: definition.name,
      category: definition.category,
      resultTitle: '九型人格 · ${int.parse(primaryCode)}号（${profile.name}）',
      summary: '主型为 ${int.parse(primaryCode)} 号，翅膀倾向为 ${wing.code} 号。',
      guidance:
          '压力方向：${direction.stress} 号（${_profiles[direction.stress]!.name}）\n成长方向：${direction.growth} 号（${_profiles[direction.growth]!.name}）\n建议先用一到两周观察主型触发场景，再结合行动记录做微调。',
      emoji: definition.emoji,
      totalScore: primary.value,
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
        'enneagram': {
          'primaryType': {
            'code': int.parse(primaryCode),
            'name': profile.name,
            'score': primary.value,
          },
          'wingType': {
            'code': wing.code,
            'name': wing.name,
            'score': wing.score,
          },
          'clarity': clarity,
          'topTypes': topTypes,
          'typeScores': typeScores.map(
            (key, value) => MapEntry<String, int>(key.toString(), value),
          ),
          'questionCount': answersInDisplayOrder.length,
        },
      },
    );
  }

  static _WingResult _resolveWing(String primaryCode, Map<String, int> scores) {
    final primary = int.parse(primaryCode);
    final left = primary == 1 ? 9 : primary - 1;
    final right = primary == 9 ? 1 : primary + 1;
    final leftCode = left.toString();
    final rightCode = right.toString();
    final leftScore = scores[leftCode] ?? 0;
    final rightScore = scores[rightCode] ?? 0;
    final wingCode = leftScore >= rightScore ? leftCode : rightCode;
    return _WingResult(
      code: int.parse(wingCode),
      name: _profiles[wingCode]!.name,
      score: scores[wingCode] ?? 0,
    );
  }

  static String _typeCode(String typeId) {
    return typeId.replaceFirst('T', '');
  }

  static int _toPercentile(double raw) {
    return (((raw - 1) / 4) * 100).clamp(0, 100).round();
  }
}

class _EnneagramProfile {
  final String name;
  final String intro;

  const _EnneagramProfile({required this.name, required this.intro});
}

class _DirectionPair {
  final String stress;
  final String growth;

  const _DirectionPair({required this.stress, required this.growth});
}

class _WingResult {
  final int code;
  final String name;
  final int score;

  const _WingResult({
    required this.code,
    required this.name,
    required this.score,
  });
}
