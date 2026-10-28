import '../models/mental_assessment.dart';

class AdhdScreeningScoring {
  static const List<AssessmentOption> _frequencyOptions = [
    AssessmentOption(label: '从不', score: 0),
    AssessmentOption(label: '很少', score: 1),
    AssessmentOption(label: '有时', score: 2),
    AssessmentOption(label: '经常', score: 3),
    AssessmentOption(label: '非常频繁', score: 4),
  ];

  static AssessmentQuestion _q(String id, String prompt, String dim) {
    return AssessmentQuestion(
      id: id,
      prompt: prompt,
      dimensionId: dim,
      options: _frequencyOptions,
    );
  }

  static final List<AssessmentQuestion> _allQuestions = [
    // Part A (6)
    _q('adhd_q1', '在处理重复或细节任务时，你会拖延到最后才开始。', 'IA'),
    _q('adhd_q2', '别人直接对你说话时，你会走神或漏听关键信息。', 'IA'),
    _q('adhd_q3', '你会因为分心而把手头任务切来切去，难以收尾。', 'IA'),
    _q('adhd_q4', '做计划时你经常低估所需时间并导致延误。', 'IA'),
    _q('adhd_q5', '你会频繁坐立不安，难以持续安静待着。', 'HI'),
    _q('adhd_q6', '你会在不合适的时机插话、抢答或打断别人。', 'HI'),

    // Part B (12)
    _q('adhd_q7', '你经常忘记归位物品，导致临时找不到关键东西。', 'IA'),
    _q('adhd_q8', '你很难长期维持固定作息或执行例行计划。', 'IA'),
    _q('adhd_q9', '面对需要持续专注的任务，你容易中途放弃。', 'IA'),
    _q('adhd_q10', '你会在会议、课堂或长谈中感觉“坐不住”。', 'HI'),
    _q('adhd_q11', '你常因冲动决定而在事后感到后悔。', 'HI'),
    _q('adhd_q12', '你会在高刺激情境下出现“越急越乱”的状态。', 'HI'),
    _q('adhd_q13', '你经常漏看消息、漏交事项或错过截止时间。', 'IA'),
    _q('adhd_q14', '你会同时开很多任务，但完成率偏低。', 'IA'),
    _q('adhd_q15', '你常感到大脑停不下来，休息时也在高速运转。', 'HI'),
    _q('adhd_q16', '你在排队、等候时容易烦躁并想立刻离开。', 'HI'),
    _q('adhd_q17', '你会因注意力漂移而反复返工。', 'IA'),
    _q('adhd_q18', '你会因为冲动表达影响合作或关系氛围。', 'HI'),
  ];

  static final List<AssessmentQuestion> quickQuestions = List.unmodifiable(
    _allQuestions.take(6),
  );
  static final List<AssessmentQuestion> fullQuestions = List.unmodifiable(
    _allQuestions,
  );

  static const Map<String, int> _partACutoffs = {
    'adhd_q1': 2,
    'adhd_q2': 2,
    'adhd_q3': 2,
    'adhd_q4': 2,
    'adhd_q5': 3,
    'adhd_q6': 3,
  };

  static AssessmentResult evaluate({
    required MentalAssessmentDefinition definition,
    required Map<String, int> answersByQuestionId,
    required List<int> answersInDisplayOrder,
    required DateTime completedAt,
  }) {
    final questionIds = definition.questions.map((q) => q.id).toList();
    final totalScore = _sumFor(answersByQuestionId, questionIds);
    final partAPositive = _partAPositiveCount(answersByQuestionId);
    final inattentionScore = _sumFor(answersByQuestionId, const [
      'adhd_q1',
      'adhd_q2',
      'adhd_q3',
      'adhd_q4',
      'adhd_q7',
      'adhd_q8',
      'adhd_q9',
      'adhd_q13',
      'adhd_q17',
    ]);
    final hyperactivityScore = _sumFor(answersByQuestionId, const [
      'adhd_q5',
      'adhd_q6',
      'adhd_q10',
      'adhd_q11',
      'adhd_q12',
      'adhd_q15',
      'adhd_q16',
      'adhd_q18',
    ]);

    final band = definition.questions.length <= 6
        ? _classifyQuick(partAPositive: partAPositive, totalScore: totalScore)
        : _classifyFull(partAPositive: partAPositive, totalScore: totalScore);

    return AssessmentResult(
      assessmentId: definition.id,
      assessmentName: definition.name,
      category: definition.category,
      resultTitle: band.title,
      summary: band.summary,
      guidance: band.guidance,
      emoji: definition.emoji,
      totalScore: totalScore,
      maxScore: definition.questions.length * 4,
      severity: band.severity,
      recommendProfessionalSupport: band.recommendProfessionalSupport,
      urgentSafetyReview: false,
      isStandardized: definition.isStandardized,
      sourceLabel: definition.sourceLabel,
      periodLabel: definition.periodLabel,
      disclaimer: definition.disclaimer,
      createdAt: completedAt,
      answers: List<int>.from(answersInDisplayOrder),
      extras: {
        'adhd': {
          'riskLevel': band.riskLevel,
          'partAPositive': partAPositive,
          'questionCount': definition.questions.length,
          'inattentionScore': inattentionScore,
          'hyperactivityScore': hyperactivityScore,
          'totalScore': totalScore,
        },
      },
    );
  }

  static int _sumFor(Map<String, int> answersByQuestionId, List<String> ids) {
    var sum = 0;
    for (final id in ids) {
      final value = answersByQuestionId[id] ?? 0;
      if (value >= 0 && value <= 4) {
        sum += value;
      }
    }
    return sum;
  }

  static int _partAPositiveCount(Map<String, int> answersByQuestionId) {
    var positives = 0;
    for (final entry in _partACutoffs.entries) {
      final answer = answersByQuestionId[entry.key] ?? 0;
      if (answer >= entry.value) positives++;
    }
    return positives;
  }

  static _AdhdBand _classifyQuick({
    required int partAPositive,
    required int totalScore,
  }) {
    if (partAPositive >= 5 || totalScore >= 18) {
      return const _AdhdBand(
        riskLevel: 'high',
        title: 'ADHD 风险较高（筛查）',
        summary: '快速筛查显示注意力/冲动相关信号较明显，建议尽快做专业评估。',
        guidance: '建议尽快预约精神科或心理专业评估。你也可以先记录一周内的专注、拖延、冲动场景，作为就诊材料。',
        severity: AssessmentSeverity.high,
        recommendProfessionalSupport: true,
      );
    }
    if (partAPositive >= 4 || totalScore >= 14) {
      return const _AdhdBand(
        riskLevel: 'moderate',
        title: 'ADHD 风险中等（筛查）',
        summary: '快速筛查提示存在一定注意力/冲动风险，需要进一步确认。',
        guidance: '建议继续完成完整版筛查，并观察功能受损（学习/工作效率、遗忘、冲动决策）是否持续 2 周以上。',
        severity: AssessmentSeverity.moderate,
        recommendProfessionalSupport: true,
      );
    }
    if (partAPositive >= 3 || totalScore >= 10) {
      return const _AdhdBand(
        riskLevel: 'mild',
        title: 'ADHD 风险偏低（筛查）',
        summary: '目前看到一些轻度注意力波动，但还不足以直接指向高风险。',
        guidance: '先做作息和任务管理优化，1-2 周后复测；若影响持续扩大，建议专业评估。',
        severity: AssessmentSeverity.mild,
        recommendProfessionalSupport: false,
      );
    }
    return const _AdhdBand(
      riskLevel: 'low',
      title: 'ADHD 风险较低（筛查）',
      summary: '本次筛查未见明显高风险信号。',
      guidance: '继续观察即可。如果后续在专注、执行、冲动控制上持续受影响，可再次筛查或直接咨询专业人士。',
      severity: AssessmentSeverity.low,
      recommendProfessionalSupport: false,
    );
  }

  static _AdhdBand _classifyFull({
    required int partAPositive,
    required int totalScore,
  }) {
    if (partAPositive >= 5 || totalScore >= 44) {
      return const _AdhdBand(
        riskLevel: 'high',
        title: 'ADHD 风险较高（完整版筛查）',
        summary: '完整版筛查显示风险偏高，建议尽快进行专业评估。',
        guidance: '建议尽快预约专业评估，并准备功能受损证据（遗漏、拖延、冲动、学业/工作影响记录）。筛查结果不等于诊断。',
        severity: AssessmentSeverity.high,
        recommendProfessionalSupport: true,
      );
    }
    if (partAPositive >= 4 || totalScore >= 34) {
      return const _AdhdBand(
        riskLevel: 'moderate',
        title: 'ADHD 风险中等（完整版筛查）',
        summary: '结果提示中等风险，建议结合现实功能损害做进一步确认。',
        guidance: '建议与专业人士讨论，重点描述持续时长、场景广度与功能影响。可先执行番茄钟、外部提醒、任务分块等策略。',
        severity: AssessmentSeverity.elevated,
        recommendProfessionalSupport: true,
      );
    }
    if (partAPositive >= 3 || totalScore >= 24) {
      return const _AdhdBand(
        riskLevel: 'mild',
        title: 'ADHD 风险偏低（完整版筛查）',
        summary: '有一定注意力/执行功能波动，建议持续观察。',
        guidance: '先做结构化管理并跟踪 2-4 周。若影响持续，建议到专业机构做正式评估。',
        severity: AssessmentSeverity.mild,
        recommendProfessionalSupport: false,
      );
    }
    return const _AdhdBand(
      riskLevel: 'low',
      title: 'ADHD 风险较低（完整版筛查）',
      summary: '未见明显 ADHD 高风险信号。',
      guidance: '保持规律作息与任务管理即可。若后续出现持续功能受损，可再次筛查或寻求专业评估。',
      severity: AssessmentSeverity.low,
      recommendProfessionalSupport: false,
    );
  }
}

class _AdhdBand {
  final String riskLevel;
  final String title;
  final String summary;
  final String guidance;
  final AssessmentSeverity severity;
  final bool recommendProfessionalSupport;

  const _AdhdBand({
    required this.riskLevel,
    required this.title,
    required this.summary,
    required this.guidance,
    required this.severity,
    required this.recommendProfessionalSupport,
  });
}
