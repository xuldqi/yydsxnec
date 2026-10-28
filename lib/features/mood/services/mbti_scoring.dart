import '../models/mental_assessment.dart';

class MbtiScoring {
  static const List<String> dimensionOrder = ['EI', 'SN', 'TF', 'JP'];

  static const Map<String, _MbtiDimensionMeta> dimensionMeta = {
    'EI': _MbtiDimensionMeta(
      id: 'EI',
      name: '精力来源',
      leftLetter: 'E',
      rightLetter: 'I',
      leftLabel: '外向',
      rightLabel: '内向',
    ),
    'SN': _MbtiDimensionMeta(
      id: 'SN',
      name: '信息偏好',
      leftLetter: 'S',
      rightLetter: 'N',
      leftLabel: '实感',
      rightLabel: '直觉',
    ),
    'TF': _MbtiDimensionMeta(
      id: 'TF',
      name: '决策依据',
      leftLetter: 'T',
      rightLetter: 'F',
      leftLabel: '思考',
      rightLabel: '情感',
    ),
    'JP': _MbtiDimensionMeta(
      id: 'JP',
      name: '生活方式',
      leftLetter: 'J',
      rightLetter: 'P',
      leftLabel: '判断',
      rightLabel: '感知',
    ),
  };

  static final List<AssessmentQuestion> _seedQuestions = [
    // EI
    _q(
      'mbti_ei_01',
      'EI',
      '参加完多人活动后，你更常见的状态是？',
      '还想继续社交，精力被激活了',
      '需要安静独处，慢慢恢复精力',
    ),
    _q('mbti_ei_02', 'EI', '进入新团队时，你通常会？', '主动认识大家并快速建立联系', '先观察熟悉环境，再逐步建立联系'),
    _q('mbti_ei_03', 'EI', '讨论问题时，你更接近？', '边说边想，通过交流形成结论', '先独立思考，再给出相对完整结论'),
    _q('mbti_ei_04', 'EI', '有好消息时，你第一反应更像？', '马上分享给身边的人', '先自己消化，再选择性分享'),
    _q('mbti_ei_05', 'EI', '遇到陌生社交场景时，你倾向？', '先开口互动，边聊边适应', '先听先看，确认安全感后再加入'),
    _q('mbti_ei_06', 'EI', '在项目推进中，你更常用的工作节奏是？', '高频沟通、协同推进', '先独立推进，再阶段性同步'),
    _q(
      'mbti_ei_07',
      'EI',
      '临时被邀参加聚会时，你更可能？',
      '大概率会去，见人让我有状态',
      '更看当下精力，常会婉拒或缩短停留',
    ),
    _q('mbti_ei_08', 'EI', '遇到困难时，你更倾向？', '先和人讨论，借助外部反馈整理思路', '先自己梳理，再决定是否求助'),
    _q('mbti_ei_09', 'EI', '在会议里，你通常会？', '主动发言，及时推动讨论', '按关键点发言，避免无效表达'),
    _q('mbti_ei_10', 'EI', '结识新朋友后，你更可能？', '持续主动维系联系', '联系节奏较慢，更看关系深度'),
    _q('mbti_ei_11', 'EI', '你更偏好的放松方式是？', '和人一起做点有互动感的事', '独处阅读、听歌、做自己想做的事'),
    _q('mbti_ei_12', 'EI', '面对公开表达场景时，你更接近？', '表达本身会让我兴奋和投入', '表达前需要较多准备和心理预热'),
    _q('mbti_ei_13', 'EI', '当你需要快速做决定时，更依赖？', '和人实时碰撞出的判断', '个人思考后形成的内部判断'),
    _q('mbti_ei_14', 'EI', '工作日结束后，你更常见的选择是？', '愿意继续安排社交或协作', '倾向留给自己独处恢复时间'),
    _q('mbti_ei_15', 'EI', '你在群体中的自然角色更像？', '活跃连接者，带动场子和节奏', '稳定观察者，关键时刻精准发言'),

    // SN
    _q('mbti_sn_01', 'SN', '接到新任务时，你通常先关注？', '现有事实、约束和可执行步骤', '长期方向、潜在机会与延展空间'),
    _q('mbti_sn_02', 'SN', '学习新工具时，你更偏好？', '按说明和案例一步步上手', '先理解原理，再自由探索玩法'),
    _q('mbti_sn_03', 'SN', '看一份汇报时，你更在意？', '数据细节是否准确可靠', '结论洞察是否有前瞻价值'),
    _q('mbti_sn_04', 'SN', '复盘一次经历时，你更容易先想到？', '具体发生了什么、过程如何', '这件事背后的模式和启发'),
    _q('mbti_sn_05', 'SN', '面对不确定问题，你更常用？', '参考已有经验和成熟范式', '尝试新思路，探索可能性'),
    _q('mbti_sn_06', 'SN', '做风险评估时，你更先看？', '眼前可见风险与现实资源', '中长期变化带来的系统风险'),
    _q('mbti_sn_07', 'SN', '阅读内容时，你更偏好？', '具体、清晰、可操作的信息', '抽象、概念化、启发性的观点'),
    _q('mbti_sn_08', 'SN', '讨论改进方案时，你更容易提出？', '可立刻执行的细节优化', '跨场景可复用的创新思路'),
    _q('mbti_sn_09', 'SN', '做计划时，你更常见的出发点是？', '先把现实条件和步骤列清楚', '先勾勒愿景，再反推路径'),
    _q('mbti_sn_10', 'SN', '看一部电影后，你更容易记住？', '具体情节、人物行为和细节', '主题隐喻、象征意义与表达'),
    _q('mbti_sn_11', 'SN', '描述问题时，你更习惯？', '按事实顺序具体展开', '先讲核心判断和整体图景'),
    _q('mbti_sn_12', 'SN', '面对“新想法”时，你第一反应更像？', '先验证可行性与成本', '先保留可能性再逐步验证'),
    _q('mbti_sn_13', 'SN', '你做记录更倾向？', '记录关键细节和明确结论', '记录灵感关联和方向线索'),
    _q('mbti_sn_14', 'SN', '评价一个建议时，你更看重？', '是否贴合现实、可立即落地', '是否有突破性、能带来跃迁'),
    _q('mbti_sn_15', 'SN', '长期规划时，你更常见的方式是？', '基于现实条件稳步推进', '围绕愿景主动创造条件'),

    // TF
    _q('mbti_tf_01', 'TF', '做重要决策时，你通常先看？', '逻辑一致性和客观标准', '人的感受和关系影响'),
    _q('mbti_tf_02', 'TF', '给同事反馈时，你更可能？', '直接指出问题并给清晰改法', '先照顾感受，再提出建议'),
    _q('mbti_tf_03', 'TF', '遇到冲突时，你更倾向先处理？', '事实分歧和规则边界', '情绪状态和关系修复'),
    _q('mbti_tf_04', 'TF', '评估合作对象时，你更重视？', '能力匹配与结果稳定性', '价值认同与相处舒适度'),
    _q('mbti_tf_05', 'TF', '你理解的“公平”更接近？', '同标准同规则地对待所有人', '结合个体差异做弹性平衡'),
    _q('mbti_tf_06', 'TF', '谈判时你更常见策略是？', '明确条件、权责和可交换项', '先建立信任再推进共识'),
    _q('mbti_tf_07', 'TF', '面对低效流程时，你更可能？', '优先重构机制和职责', '优先理解人和协作阻力'),
    _q('mbti_tf_08', 'TF', '当朋友求建议时，你更可能？', '先给理性分析和可执行方案', '先共情陪伴，再讨论方案'),
    _q('mbti_tf_09', 'TF', '你更容易被哪种观点说服？', '证据充分、逻辑闭环', '价值一致、符合人性'),
    _q('mbti_tf_10', 'TF', '面对团队分歧时，你更倾向？', '回到目标和标准做取舍', '回到关系和接受度做取舍'),
    _q('mbti_tf_11', 'TF', '处理绩效问题时，你更关注？', '结果达成与能力缺口', '动机状态与支持方式'),
    _q('mbti_tf_12', 'TF', '表达不同意见时，你更常见？', '直接提出反例和论证', '先确认对方感受再表达'),
    _q('mbti_tf_13', 'TF', '遇到“规则与人情”冲突时，你倾向？', '优先保证规则稳定可复用', '优先照顾具体情境与关系'),
    _q('mbti_tf_14', 'TF', '对“好领导”的判断，你更看重？', '决策质量和执行效率', '共情能力和团队氛围'),
    _q('mbti_tf_15', 'TF', '复盘失误时，你更容易先想到？', '哪一步逻辑或机制出了问题', '谁在过程中承受了额外压力'),

    // JP
    _q('mbti_jp_01', 'JP', '面对一周安排时，你更偏好？', '先排清单和时间块，再执行', '保留弹性，按变化动态调整'),
    _q('mbti_jp_02', 'JP', '你对待待办的习惯更像？', '倾向尽快闭环，清空更安心', '按优先级滚动，不追求一次清空'),
    _q('mbti_jp_03', 'JP', '旅行时你通常会？', '提前规划路线与关键节点', '到现场看状态再决定行程'),
    _q('mbti_jp_04', 'JP', '面对截止日期时，你更常见？', '提前完成，留缓冲空间', '临近时集中冲刺，效率更高'),
    _q('mbti_jp_05', 'JP', '工作空间和资料管理上，你更接近？', '有固定秩序，分类较清晰', '可快速找到即可，不执着整齐'),
    _q('mbti_jp_06', 'JP', '计划被打断时，你更常见反应？', '先恢复秩序，再继续推进', '顺势改道，快速重排优先级'),
    _q('mbti_jp_07', 'JP', '买大件之前，你更习惯？', '先做比较和标准筛选', '边看边感受，合适就定'),
    _q('mbti_jp_08', 'JP', '启动新项目时，你通常先？', '明确范围、时间和交付定义', '先快速试做，边做边定形'),
    _q('mbti_jp_09', 'JP', '你安排家务/生活事务时更像？', '固定节奏执行更安心', '看当下状态灵活处理'),
    _q('mbti_jp_10', 'JP', '你做决定更偏向？', '尽快定案并按计划走', '先收集更多信息再决定'),
    _q('mbti_jp_11', 'JP', '被临时插入任务时，你更倾向？', '先确认是否影响原计划', '先处理当下最急再说'),
    _q('mbti_jp_12', 'JP', '同时有多个任务时，你更常见？', '排顺序逐个完成', '并行推进，灵活切换'),
    _q('mbti_jp_13', 'JP', '回复消息和邮件时，你更倾向？', '尽快回复并归档清理', '集中一段时间统一处理'),
    _q('mbti_jp_14', 'JP', '对长期目标执行，你更常见？', '制定里程碑并持续跟踪', '保持方向感，路径可随时调整'),
    _q('mbti_jp_15', 'JP', '周末安排你更偏好？', '提前定好大致计划', '临时决定更放松自在'),
  ];

  static AssessmentQuestion _q(
    String id,
    String dimensionId,
    String prompt,
    String leftOption,
    String rightOption,
  ) {
    return AssessmentQuestion(
      id: id,
      prompt: prompt,
      dimensionId: dimensionId,
      options: [
        AssessmentOption(label: leftOption, score: 1),
        AssessmentOption(label: rightOption, score: 2),
      ],
    );
  }

  static final List<AssessmentQuestion> quickQuestions = _buildTierQuestions(
    targetCount: 20,
    tierKey: 'q20',
  );
  static final List<AssessmentQuestion> fullQuestions = _buildTierQuestions(
    targetCount: 60,
    tierKey: 'q60',
  );
  static final List<AssessmentQuestion> professionalQuestions =
      _buildTierQuestions(targetCount: 93, tierKey: 'q93');
  static final List<AssessmentQuestion> expertQuestions = _buildTierQuestions(
    targetCount: 200,
    tierKey: 'q200',
  );

  // Backward-compatible alias: quick version
  static List<AssessmentQuestion> get questions => quickQuestions;

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
      1 => '在工作/学习场景下，',
      2 => '在亲密关系或亲近社交场景下，',
      _ => '在压力较高且时间紧张时，',
    };
  }

  static const Map<String, _MbtiTypeProfile> _profiles = {
    'ISTJ': _MbtiTypeProfile(
      name: '审慎执行者',
      intro: '稳健、可靠、重细节。',
      guidance: '你适合在清晰边界内持续交付，关键是避免过度保守。',
    ),
    'ISFJ': _MbtiTypeProfile(
      name: '可靠守护者',
      intro: '细腻、负责、重承诺。',
      guidance: '你的优势是稳定支持与持续关照，记得给自己留恢复空间。',
    ),
    'INFJ': _MbtiTypeProfile(
      name: '洞察引导者',
      intro: '有洞察、重意义、会连接人心。',
      guidance: '你适合做长期价值导向的事，也要防止过度内耗。',
    ),
    'INTJ': _MbtiTypeProfile(
      name: '战略规划者',
      intro: '结构化、独立、目标导向。',
      guidance: '你的优势是前瞻和系统思考，可适当增加过程沟通。',
    ),
    'ISTP': _MbtiTypeProfile(
      name: '冷静实干者',
      intro: '务实、灵活、擅长现场解决问题。',
      guidance: '你擅长高压场景，建议补齐长期规划与节奏管理。',
    ),
    'ISFP': _MbtiTypeProfile(
      name: '温和体验者',
      intro: '感受敏锐、真诚、重当下体验。',
      guidance: '你在真实与审美上很有优势，记得把目标拆小并持续推进。',
    ),
    'INFP': _MbtiTypeProfile(
      name: '理想共情者',
      intro: '价值驱动、共情强、富有想象力。',
      guidance: '你适合做有意义的长期投入，也要建立可执行闭环。',
    ),
    'INTP': _MbtiTypeProfile(
      name: '逻辑探索者',
      intro: '分析深、好奇心强、爱钻研。',
      guidance: '你擅长抽象思考，关键是把想法更快落地到现实。',
    ),
    'ESTP': _MbtiTypeProfile(
      name: '临场行动者',
      intro: '反应快、敢尝试、重结果。',
      guidance: '你在变化中很强，建议补上复盘与风险预案。',
    ),
    'ESFP': _MbtiTypeProfile(
      name: '活力体验者',
      intro: '热情外放、感染力强、重互动。',
      guidance: '你适合带动氛围与执行现场，注意节奏和优先级管理。',
    ),
    'ENFP': _MbtiTypeProfile(
      name: '创意连接者',
      intro: '想法多、联想快、重可能性。',
      guidance: '你擅长发起和连接，建议建立筛选机制避免分散。',
    ),
    'ENTP': _MbtiTypeProfile(
      name: '辩证开拓者',
      intro: '善思辨、爱挑战、点子密集。',
      guidance: '你能快速打开局面，记得在关键节点收束并定稿。',
    ),
    'ESTJ': _MbtiTypeProfile(
      name: '组织推进者',
      intro: '执行强、重秩序、善推动。',
      guidance: '你擅长把事做成，适当增加倾听会让团队更稳。',
    ),
    'ESFJ': _MbtiTypeProfile(
      name: '协调支持者',
      intro: '重协作、顾关系、执行细致。',
      guidance: '你是团队润滑剂，别忘了为自己设定边界。',
    ),
    'ENFJ': _MbtiTypeProfile(
      name: '关系驱动者',
      intro: '擅长鼓舞与连接，共识感强。',
      guidance: '你适合带人和带节奏，建议给自己留决策冷静期。',
    ),
    'ENTJ': _MbtiTypeProfile(
      name: '目标统筹者',
      intro: '战略清晰、推动果断、结果导向。',
      guidance: '你很会带队冲锋，适当放慢能提升可持续性。',
    ),
  };

  static AssessmentResult evaluate({
    required MentalAssessmentDefinition definition,
    required Map<String, int> answersByQuestionId,
    required List<int> answersInDisplayOrder,
    required DateTime completedAt,
  }) {
    final letterCounts = <String, int>{
      'E': 0,
      'I': 0,
      'S': 0,
      'N': 0,
      'T': 0,
      'F': 0,
      'J': 0,
      'P': 0,
    };

    for (final question in definition.questions) {
      final dim = question.dimensionId;
      if (dim == null || dim.length != 2) continue;
      final left = dim.substring(0, 1);
      final right = dim.substring(1, 2);
      final answer = answersByQuestionId[question.id] ?? 0;
      if (answer == 1) {
        letterCounts[left] = (letterCounts[left] ?? 0) + 1;
      } else if (answer == 2) {
        letterCounts[right] = (letterCounts[right] ?? 0) + 1;
      }
    }

    final dimensionBreakdown = <Map<String, dynamic>>[];
    final typeLetters = <String>[];
    final userDimensionScore = <double>[];
    var strengthSum = 0;

    for (final dim in dimensionOrder) {
      final meta = dimensionMeta[dim]!;
      final leftCount = letterCounts[meta.leftLetter] ?? 0;
      final rightCount = letterCounts[meta.rightLetter] ?? 0;
      final total = (leftCount + rightCount).clamp(1, 9999);
      final selected = leftCount >= rightCount
          ? meta.leftLetter
          : meta.rightLetter;
      final strength = (((leftCount - rightCount).abs() / total) * 100).round();
      final score = (leftCount - rightCount) / total;
      userDimensionScore.add(score);
      strengthSum += strength;
      typeLetters.add(selected);
      dimensionBreakdown.add({
        'dimensionId': dim,
        'dimensionName': meta.name,
        'leftLetter': meta.leftLetter,
        'rightLetter': meta.rightLetter,
        'leftLabel': meta.leftLabel,
        'rightLabel': meta.rightLabel,
        'leftCount': leftCount,
        'rightCount': rightCount,
        'total': total,
        'selectedLetter': selected,
        'strength': strength,
      });
    }

    final typeCode = typeLetters.join();
    final profile =
        _profiles[typeCode] ??
        const _MbtiTypeProfile(
          name: '混合倾向',
          intro: '你在多个维度上都表现出弹性。',
          guidance: '这通常意味着适应性较好，也可以通过场景刻意强化优势。',
        );

    final ranked =
        _profiles.keys
            .map(
              (code) => _rankType(
                code: code,
                userDimensionScore: userDimensionScore,
                dimensionBreakdown: dimensionBreakdown,
              ),
            )
            .toList(growable: false)
          ..sort((a, b) {
            if (a.distance != b.distance) {
              return a.distance.compareTo(b.distance);
            }
            if (a.exact != b.exact) {
              return b.exact.compareTo(a.exact);
            }
            return b.similarity.compareTo(a.similarity);
          });

    final topMatches = ranked
        .take(3)
        .map((entry) {
          final p = _profiles[entry.code]!;
          return <String, dynamic>{
            'code': entry.code,
            'name': p.name,
            'similarity': entry.similarity,
            'distance': entry.distance,
            'exact': entry.exact,
          };
        })
        .toList(growable: false);

    final best = ranked.first;
    final confidence = (strengthSum / dimensionOrder.length).round();
    final breakdownLine = dimensionBreakdown
        .map((item) {
          final leftLetter = item['leftLetter']?.toString() ?? '';
          final rightLetter = item['rightLetter']?.toString() ?? '';
          final leftCount = item['leftCount']?.toString() ?? '0';
          final rightCount = item['rightCount']?.toString() ?? '0';
          return '$leftLetter$leftCount-$rightLetter$rightCount';
        })
        .join(' · ');

    final guidance = [
      profile.guidance,
      '维度分布：$breakdownLine',
      '匹配度 ${best.similarity}% · 精准命中 ${best.exact}/4',
    ].join('\n');

    return AssessmentResult(
      assessmentId: definition.id,
      assessmentName: definition.name,
      category: definition.category,
      resultTitle: 'MBTI · $typeCode（${profile.name}）',
      summary: profile.intro,
      guidance: guidance,
      emoji: definition.emoji,
      totalScore: best.similarity,
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
        'mbti': {
          'typeCode': typeCode,
          'typeName': profile.name,
          'confidence': confidence,
          'questionCount': answersInDisplayOrder.length,
          'dimensionBreakdown': dimensionBreakdown,
          'topMatches': topMatches,
        },
      },
    );
  }

  static _MbtiRankedType _rankType({
    required String code,
    required List<double> userDimensionScore,
    required List<Map<String, dynamic>> dimensionBreakdown,
  }) {
    var distance = 0.0;
    var exact = 0;
    for (var i = 0; i < dimensionOrder.length; i++) {
      final dim = dimensionOrder[i];
      final meta = dimensionMeta[dim]!;
      final letter = code.substring(i, i + 1);
      final target = letter == meta.leftLetter ? 1.0 : -1.0;
      final diff = (userDimensionScore[i] - target).abs();
      distance += diff;
      final selected =
          dimensionBreakdown[i]['selectedLetter']?.toString() ?? '';
      if (selected == letter) {
        exact += 1;
      }
    }
    final similarity = ((1 - distance / 8) * 100).clamp(0, 100).round();
    return _MbtiRankedType(
      code: code,
      distance: double.parse(distance.toStringAsFixed(3)),
      exact: exact,
      similarity: similarity,
    );
  }
}

class _MbtiDimensionMeta {
  final String id;
  final String name;
  final String leftLetter;
  final String rightLetter;
  final String leftLabel;
  final String rightLabel;

  const _MbtiDimensionMeta({
    required this.id,
    required this.name,
    required this.leftLetter,
    required this.rightLetter,
    required this.leftLabel,
    required this.rightLabel,
  });
}

class _MbtiTypeProfile {
  final String name;
  final String intro;
  final String guidance;

  const _MbtiTypeProfile({
    required this.name,
    required this.intro,
    required this.guidance,
  });
}

class _MbtiRankedType {
  final String code;
  final double distance;
  final int exact;
  final int similarity;

  const _MbtiRankedType({
    required this.code,
    required this.distance,
    required this.exact,
    required this.similarity,
  });
}
