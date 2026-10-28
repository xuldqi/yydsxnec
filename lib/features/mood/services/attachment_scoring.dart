import '../models/mental_assessment.dart';

class AttachmentScoring {
  static const List<String> dimensionOrder = ['SEC', 'ANX', 'AVO', 'DEP'];

  static const Map<String, String> dimensionMeta = {
    'SEC': '关系安全感',
    'ANX': '分离焦虑',
    'AVO': '回避亲密',
    'DEP': '亲密投入',
  };

  static const List<AssessmentOption> _agreementOptions = [
    AssessmentOption(label: '非常不同意', score: 1),
    AssessmentOption(label: '不同意', score: 2),
    AssessmentOption(label: '一般', score: 3),
    AssessmentOption(label: '同意', score: 4),
    AssessmentOption(label: '非常同意', score: 5),
  ];

  static AssessmentQuestion _q(String id, String dim, String prompt) {
    return AssessmentQuestion(
      id: id,
      prompt: prompt,
      dimensionId: dim,
      options: _agreementOptions,
    );
  }

  static final List<AssessmentQuestion> _seedQuestions = [
    _q('attach_sec_01', 'SEC', '在亲密关系中，我大多数时候能感到被理解与被接住。'),
    _q('attach_sec_02', 'SEC', '即使发生争执，我也相信关系可以通过沟通修复。'),
    _q('attach_sec_03', 'SEC', '我不会因为一两次冷淡就认定对方不在乎我。'),
    _q('attach_sec_04', 'SEC', '我能比较稳定地表达需求，而不是压抑或爆发。'),
    _q('attach_sec_05', 'SEC', '关系里出现不确定时，我仍能保持基本信任感。'),

    _q('attach_anx_01', 'ANX', '对方回复慢一点，我就会反复猜测是不是出问题了。'),
    _q('attach_anx_02', 'ANX', '我会担心自己不够好，最后会被比较后淘汰。'),
    _q('attach_anx_03', 'ANX', '关系稍有波动，我的情绪就会明显起伏。'),
    _q('attach_anx_04', 'ANX', '我常常需要通过确认来缓解“会失去对方”的不安。'),
    _q('attach_anx_05', 'ANX', '我会因为害怕失去而过度解读细节。'),

    _q('attach_avo_01', 'AVO', '一旦关系太靠近，我会本能地想拉开距离。'),
    _q('attach_avo_02', 'AVO', '我更习惯自己扛问题，不太愿意在关系里示弱。'),
    _q('attach_avo_03', 'AVO', '当对方情绪需求很高时，我会想先躲开。'),
    _q('attach_avo_04', 'AVO', '我不太喜欢别人深入了解我的脆弱部分。'),
    _q('attach_avo_05', 'AVO', '我会通过理性化来避免进入高强度情绪连接。'),

    _q('attach_dep_01', 'DEP', '我愿意在亲密关系里投入时间和精力去经营连接。'),
    _q('attach_dep_02', 'DEP', '当关系遇到问题时，我倾向于留下来一起修复。'),
    _q('attach_dep_03', 'DEP', '我愿意在信任关系里讨论长期安排和承诺。'),
    _q('attach_dep_04', 'DEP', '我能在保持边界的同时与对方形成稳定依赖。'),
    _q('attach_dep_05', 'DEP', '我在关系中更倾向于建设，而不是随时退出。'),
  ];

  static final List<AssessmentQuestion> quickQuestions = _buildTierQuestions(
    targetCount: 16,
    tierKey: 'q16',
  );
  static final List<AssessmentQuestion> fullQuestions = _buildTierQuestions(
    targetCount: 40,
    tierKey: 'q40',
  );
  static final List<AssessmentQuestion> advancedQuestions = _buildTierQuestions(
    targetCount: 80,
    tierKey: 'q80',
  );

  static List<AssessmentQuestion> _buildTierQuestions({
    required int targetCount,
    required String tierKey,
  }) {
    final byDim = <String, List<AssessmentQuestion>>{
      for (final dim in dimensionOrder) dim: <AssessmentQuestion>[],
    };
    for (final question in _seedQuestions) {
      final dim = question.dimensionId;
      if (dim == null) continue;
      byDim[dim]!.add(question);
    }

    final counters = <String, int>{for (final dim in dimensionOrder) dim: 0};
    final result = <AssessmentQuestion>[];

    while (result.length < targetCount) {
      for (final dim in dimensionOrder) {
        if (result.length >= targetCount) break;
        final pool = byDim[dim]!;
        if (pool.isEmpty) continue;
        final cursor = counters[dim] ?? 0;
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
        counters[dim] = cursor + 1;
      }
    }
    return result;
  }

  static String? _roundPrefix(int round) {
    return switch (round) {
      0 => null,
      1 => '在工作/学习高压周期里，',
      2 => '在亲密关系进入稳定期后，',
      _ => '当你状态不佳且沟通变少时，',
    };
  }

  static const Map<String, _AttachmentStyleProfile> _profiles = {
    'secure': _AttachmentStyleProfile(
      code: 'secure',
      name: '安全型',
      intro: '你倾向于在关系中保持信任、边界与稳定投入的平衡。',
      guidance: '继续保持“表达需求 + 情绪调节 + 修复关系”的节奏，会让关系更稳。',
    ),
    'anxious': _AttachmentStyleProfile(
      code: 'anxious',
      name: '焦虑型',
      intro: '你对关系连接很重视，也更容易对不确定信号产生担忧。',
      guidance: '建议练习延迟反应与证据校准，先稳定情绪再沟通需求。',
    ),
    'avoidant': _AttachmentStyleProfile(
      code: 'avoidant',
      name: '回避型',
      intro: '你重视独立与掌控，面对高强度亲密时会倾向拉开距离。',
      guidance: '尝试用小步表达脆弱和边界，能减少“靠近-退开”循环。',
    ),
    'mixed': _AttachmentStyleProfile(
      code: 'mixed',
      name: '混合型',
      intro: '你可能同时存在“想靠近”和“怕受伤”两种拉扯。',
      guidance: '先识别触发场景，再建立稳定沟通脚本，会明显提升关系质量。',
    ),
  };

  static AssessmentResult evaluate({
    required MentalAssessmentDefinition definition,
    required Map<String, int> answersByQuestionId,
    required List<int> answersInDisplayOrder,
    required DateTime completedAt,
  }) {
    final sums = <String, double>{for (final dim in dimensionOrder) dim: 0};
    final counts = <String, int>{for (final dim in dimensionOrder) dim: 0};

    for (final question in definition.questions) {
      final dim = question.dimensionId;
      if (dim == null || !sums.containsKey(dim)) continue;
      final answer = answersByQuestionId[question.id] ?? 0;
      if (answer < 1 || answer > 5) continue;
      sums[dim] = (sums[dim] ?? 0) + answer;
      counts[dim] = (counts[dim] ?? 0) + 1;
    }

    final averages = <String, double>{};
    for (final dim in dimensionOrder) {
      final count = counts[dim] ?? 0;
      averages[dim] = count == 0 ? 3.0 : (sums[dim] ?? 0) / count;
    }

    final secureScore = _toPercentile(
      (averages['SEC']! + (6 - averages['ANX']!) + (6 - averages['AVO']!)) / 3,
    );
    final anxiousScore = _toPercentile(
      (averages['ANX']! + averages['DEP']! + (6 - averages['SEC']!)) / 3,
    );
    final avoidantScore = _toPercentile(
      (averages['AVO']! + (6 - averages['DEP']!) + (6 - averages['SEC']!)) / 3,
    );
    final mixedScore = _toPercentile(
      (averages['ANX']! + averages['AVO']! + (6 - averages['SEC']!)) / 3,
    );

    final ranked = <MapEntry<String, int>>[
      MapEntry('secure', secureScore),
      MapEntry('anxious', anxiousScore),
      MapEntry('avoidant', avoidantScore),
      MapEntry('mixed', mixedScore),
    ]..sort((a, b) => b.value.compareTo(a.value));

    final primary = ranked[0];
    final secondary = ranked[1];
    final profile = _profiles[primary.key]!;
    final confidence = (primary.value - secondary.value).clamp(0, 100);

    final dimensionBreakdown = dimensionOrder
        .map((dim) {
          final avg = averages[dim] ?? 3.0;
          return <String, dynamic>{
            'dimensionId': dim,
            'dimensionName': dimensionMeta[dim] ?? dim,
            'average': double.parse(avg.toStringAsFixed(2)),
            'percentile': _toPercentile(avg),
          };
        })
        .toList(growable: false);

    final topMatches = ranked
        .take(3)
        .map((entry) {
          final p = _profiles[entry.key]!;
          return <String, dynamic>{
            'code': p.code,
            'name': p.name,
            'score': entry.value,
          };
        })
        .toList(growable: false);

    return AssessmentResult(
      assessmentId: definition.id,
      assessmentName: definition.name,
      category: definition.category,
      resultTitle: '依恋风格 · ${profile.name}',
      summary: profile.intro,
      guidance: '${profile.guidance}\n建议优先观察：关系不确定、冲突修复、边界沟通这三个场景。',
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
        'attachment': {
          'styleCode': profile.code,
          'styleName': profile.name,
          'confidence': confidence,
          'questionCount': answersInDisplayOrder.length,
          'dimensionBreakdown': dimensionBreakdown,
          'topMatches': topMatches,
        },
      },
    );
  }

  static int _toPercentile(double rawValue) {
    return (((rawValue - 1) / 4) * 100).clamp(0, 100).round();
  }
}

class _AttachmentStyleProfile {
  final String code;
  final String name;
  final String intro;
  final String guidance;

  const _AttachmentStyleProfile({
    required this.code,
    required this.name,
    required this.intro,
    required this.guidance,
  });
}
