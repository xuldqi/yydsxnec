import '../models/mental_assessment.dart';

class SbtiScoring {
  static const List<String> dimensionOrder = [
    'S1',
    'S2',
    'S3',
    'E1',
    'E2',
    'E3',
    'A1',
    'A2',
    'A3',
    'Ac1',
    'Ac2',
    'Ac3',
    'So1',
    'So2',
    'So3',
  ];

  static const Map<String, String> dimensionMeta = {
    'S1': 'S1 自尊自信',
    'S2': 'S2 自我清晰度',
    'S3': 'S3 核心价值',
    'E1': 'E1 依恋安全感',
    'E2': 'E2 情感投入度',
    'E3': 'E3 边界与依赖',
    'A1': 'A1 世界观倾向',
    'A2': 'A2 规则与灵活度',
    'A3': 'A3 人生意义感',
    'Ac1': 'Ac1 动机导向',
    'Ac2': 'Ac2 决策风格',
    'Ac3': 'Ac3 执行模式',
    'So1': 'So1 社交主动性',
    'So2': 'So2 人际边界感',
    'So3': 'So3 表达与真实度',
  };

  static const String drinkTriggerQuestionId = 'drink_gate_q2';
  static const int fallbackSimilarityThreshold = 60;
  static const int similarityDistanceDenominator = 30;

  static const List<AssessmentQuestion> questions = [
    AssessmentQuestion(
      id: 'q1',
      prompt: '我有时会因为自卑而否定自己',
      dimensionId: 'S1',
      options: [
        AssessmentOption(label: '经常这样', score: 1),
        AssessmentOption(label: '偶尔这样', score: 2),
        AssessmentOption(label: '几乎不会', score: 3),
      ],
    ),
    AssessmentQuestion(
      id: 'q2',
      prompt: '我不够好，周围的人都比我优秀',
      dimensionId: 'S1',
      options: [
        AssessmentOption(label: '确实', score: 1),
        AssessmentOption(label: '有时', score: 2),
        AssessmentOption(label: '不是', score: 3),
      ],
    ),
    AssessmentQuestion(
      id: 'q3',
      prompt: '我很清楚真正的自己是什么样的',
      dimensionId: 'S2',
      options: [
        AssessmentOption(label: '不认同', score: 1),
        AssessmentOption(label: '中立', score: 2),
        AssessmentOption(label: '认同', score: 3),
      ],
    ),
    AssessmentQuestion(
      id: 'q4',
      prompt: '我内心有真正追求的东西',
      dimensionId: 'S2',
      options: [
        AssessmentOption(label: '不认同', score: 1),
        AssessmentOption(label: '中立', score: 2),
        AssessmentOption(label: '认同', score: 3),
      ],
    ),
    AssessmentQuestion(
      id: 'q5',
      prompt: '我一定要不断往上爬、变得更厉害',
      dimensionId: 'S3',
      options: [
        AssessmentOption(label: '不认同', score: 1),
        AssessmentOption(label: '中立', score: 2),
        AssessmentOption(label: '认同', score: 3),
      ],
    ),
    AssessmentQuestion(
      id: 'q6',
      prompt: '外界评价对我的影响不大。',
      dimensionId: 'S3',
      options: [
        AssessmentOption(label: '不认同', score: 1),
        AssessmentOption(label: '中立', score: 2),
        AssessmentOption(label: '认同', score: 3),
      ],
    ),
    AssessmentQuestion(
      id: 'q7',
      prompt: '对象超过 5 小时没回消息，并说身体不舒服，你会怎么想？',
      dimensionId: 'E1',
      options: [
        AssessmentOption(label: '我会更倾向于怀疑对方在隐瞒。', score: 1),
        AssessmentOption(label: '在信任和怀疑之间摇摆。', score: 2),
        AssessmentOption(label: '我会先相信对方确实不舒服。', score: 3),
      ],
    ),
    AssessmentQuestion(
      id: 'q8',
      prompt: '我在感情里经常担心被对方抛弃',
      dimensionId: 'E1',
      options: [
        AssessmentOption(label: '是的', score: 1),
        AssessmentOption(label: '偶尔', score: 2),
        AssessmentOption(label: '不是', score: 3),
      ],
    ),
    AssessmentQuestion(
      id: 'q9',
      prompt: '我对待每一段关系都很认真。',
      dimensionId: 'E2',
      options: [
        AssessmentOption(label: '不太符合', score: 1),
        AssessmentOption(label: '不确定', score: 2),
        AssessmentOption(label: '比较符合', score: 3),
      ],
    ),
    AssessmentQuestion(
      id: 'q10',
      prompt: '当你遇到一个非常优秀、让你强烈心动的人时，你通常会？',
      dimensionId: 'E2',
      options: [
        AssessmentOption(label: '保持理性，不会投入太深。', score: 1),
        AssessmentOption(label: '在理性和投入之间平衡。', score: 2),
        AssessmentOption(label: '容易高度投入并非常珍惜对方。', score: 3),
      ],
    ),
    AssessmentQuestion(
      id: 'q11',
      prompt: '恋爱后，对象非常黏人，你作何感想？',
      dimensionId: 'E3',
      options: [
        AssessmentOption(label: '我会更享受高频陪伴。', score: 1),
        AssessmentOption(label: '我通常能接受。', score: 2),
        AssessmentOption(label: '我更喜欢保留独立空间', score: 3),
      ],
    ),
    AssessmentQuestion(
      id: 'q12',
      prompt: '我在任何关系里都很重视个人空间',
      dimensionId: 'E3',
      options: [
        AssessmentOption(label: '我更喜欢依赖与被依赖', score: 1),
        AssessmentOption(label: '看情况', score: 2),
        AssessmentOption(label: '是的，个人空间很重要。', score: 3),
      ],
    ),
    AssessmentQuestion(
      id: 'q13',
      prompt: '大多数人是善良的',
      dimensionId: 'A1',
      options: [
        AssessmentOption(label: '我认为大多数人更倾向于利己。', score: 1),
        AssessmentOption(label: '也许吧。', score: 2),
        AssessmentOption(label: '是的，我愿相信好人更多。', score: 3),
      ],
    ),
    AssessmentQuestion(
      id: 'q14',
      prompt: '在路上遇到陌生人主动送你小礼物时，你第一反应是？',
      dimensionId: 'A1',
      options: [
        AssessmentOption(label: '我会感到温暖并愿意接受善意。', score: 3),
        AssessmentOption(label: '我会先观察，再决定是否接受。', score: 2),
        AssessmentOption(label: '我会优先保持警惕并礼貌拒绝。', score: 1),
      ],
    ),
    AssessmentQuestion(
      id: 'q15',
      prompt: '当规则要求与你临时想做的事冲突时，你通常会？',
      dimensionId: 'A2',
      options: [
        AssessmentOption(label: '优先满足当下偏好。', score: 1),
        AssessmentOption(label: '权衡后选择折中方案。', score: 2),
        AssessmentOption(label: '优先遵守既定规则。', score: 3),
      ],
    ),
    AssessmentQuestion(
      id: 'q16',
      prompt: '我喜欢打破常规，不喜欢被束缚',
      dimensionId: 'A2',
      options: [
        AssessmentOption(label: '认同', score: 1),
        AssessmentOption(label: '保持中立', score: 2),
        AssessmentOption(label: '不认同', score: 3),
      ],
    ),
    AssessmentQuestion(
      id: 'q17',
      prompt: '我做事通常有目标。',
      dimensionId: 'A3',
      options: [
        AssessmentOption(label: '不认同', score: 1),
        AssessmentOption(label: '中立', score: 2),
        AssessmentOption(label: '认同', score: 3),
      ],
    ),
    AssessmentQuestion(
      id: 'q18',
      prompt: '有时我会觉得人生没有明确意义，人更多是在本能和欲望驱动下生活。',
      dimensionId: 'A3',
      options: [
        AssessmentOption(label: '是这样的。', score: 1),
        AssessmentOption(label: '也许是，也许不是。', score: 2),
        AssessmentOption(label: '这简直是胡扯', score: 3),
      ],
    ),
    AssessmentQuestion(
      id: 'q19',
      prompt: '我做事主要为了取得成果和进步，而不是避免麻烦和风险。',
      dimensionId: 'Ac1',
      options: [
        AssessmentOption(label: '不认同', score: 1),
        AssessmentOption(label: '中立', score: 2),
        AssessmentOption(label: '认同', score: 3),
      ],
    ),
    AssessmentQuestion(
      id: 'q20',
      prompt: '面对一个短时间难以解决的问题时，你更像：',
      dimensionId: 'Ac1',
      options: [
        AssessmentOption(label: '继续原方法，先看看会不会自然改善。', score: 1),
        AssessmentOption(label: '一边坚持一边尝试一些小调整。', score: 2),
        AssessmentOption(label: '快速换方案，优先解决问题。', score: 3),
      ],
    ),
    AssessmentQuestion(
      id: 'q21',
      prompt: '我做决定比较果断，不喜欢犹豫',
      dimensionId: 'Ac2',
      options: [
        AssessmentOption(label: '不认同', score: 1),
        AssessmentOption(label: '中立', score: 2),
        AssessmentOption(label: '认同', score: 3),
      ],
    ),
    AssessmentQuestion(
      id: 'q22',
      prompt: '面对不完整信息时，你通常会：',
      dimensionId: 'Ac2',
      options: [
        AssessmentOption(label: '先继续收集信息，再做决定。', score: 1),
        AssessmentOption(label: '先按经验做临时判断。', score: 2),
        AssessmentOption(label: '快速决策并根据反馈调整。', score: 3),
      ],
    ),
    AssessmentQuestion(
      id: 'q23',
      prompt: '别人说你“执行力强”，你内心更接近哪句？',
      dimensionId: 'Ac3',
      options: [
        AssessmentOption(label: '我通常在压力临近时才会爆发执行力。', score: 1),
        AssessmentOption(label: '看任务和状态，有时强有时一般。', score: 2),
        AssessmentOption(label: '我会主动推动事情持续前进。', score: 3),
      ],
    ),
    AssessmentQuestion(
      id: 'q24',
      prompt: '我做事常常有计划，',
      dimensionId: 'Ac3',
      options: [
        AssessmentOption(label: '但执行时容易被变化打断。', score: 1),
        AssessmentOption(label: '完成度会随情况波动。', score: 2),
        AssessmentOption(label: '并且会尽量按计划推进。', score: 3),
      ],
    ),
    AssessmentQuestion(
      id: 'q25',
      prompt: '你在网上结识新朋友并被邀请线下见面时，你通常会？',
      dimensionId: 'So1',
      options: [
        AssessmentOption(label: '倾向保留线上交流，不太愿意线下见面。', score: 1),
        AssessmentOption(label: '会先评估安全和氛围，再决定。', score: 2),
        AssessmentOption(label: '愿意积极参加并主动社交。', score: 3),
      ],
    ),
    AssessmentQuestion(
      id: 'q26',
      prompt: '朋友带了ta的朋友一起来玩，你最可能的状态是',
      dimensionId: 'So1',
      options: [
        AssessmentOption(label: '我会先保持距离，观察一会儿。', score: 1),
        AssessmentOption(label: '看现场氛围，能聊就聊。', score: 2),
        AssessmentOption(label: '我会主动打开话题并热情互动。', score: 3),
      ],
    ),
    AssessmentQuestion(
      id: 'q27',
      prompt: '我和人相处时边界感较强，靠太近会不舒服。',
      dimensionId: 'So2',
      options: [
        AssessmentOption(label: '认同', score: 3),
        AssessmentOption(label: '中立', score: 2),
        AssessmentOption(label: '不认同', score: 1),
      ],
    ),
    AssessmentQuestion(
      id: 'q28',
      prompt: '我渴望和我信任的人关系密切，熟得像失散多年的亲戚。',
      dimensionId: 'So2',
      options: [
        AssessmentOption(label: '认同', score: 1),
        AssessmentOption(label: '中立', score: 2),
        AssessmentOption(label: '不认同', score: 3),
      ],
    ),
    AssessmentQuestion(
      id: 'q29',
      prompt: '有时候你明明对一件事有不同的、负面的看法，但最后没说出来。多数情况下原因是：',
      dimensionId: 'So3',
      options: [
        AssessmentOption(label: '这种情况较少。', score: 1),
        AssessmentOption(label: '可能碍于情面或者关系。', score: 2),
        AssessmentOption(label: '不想让别人看到自己消极的一面。', score: 3),
      ],
    ),
    AssessmentQuestion(
      id: 'q30',
      prompt: '我在不同人面前会表现出不一样的自己',
      dimensionId: 'So3',
      options: [
        AssessmentOption(label: '不认同', score: 1),
        AssessmentOption(label: '中立', score: 2),
        AssessmentOption(label: '认同', score: 3),
      ],
    ),
    AssessmentQuestion(
      id: 'drink_gate_q1',
      prompt: '您平时有什么爱好？',
      special: true,
      options: [
        AssessmentOption(label: '日常休闲', score: 1),
        AssessmentOption(label: '艺术爱好', score: 2),
        AssessmentOption(label: '饮酒', score: 3),
        AssessmentOption(label: '健身', score: 4),
      ],
    ),
    AssessmentQuestion(
      id: 'drink_gate_q2',
      prompt: '您对饮酒的态度是？',
      special: true,
      showWhenQuestionId: 'drink_gate_q1',
      showWhenScore: 3,
      options: [
        AssessmentOption(label: '小酌怡情，喝不了太多。', score: 1),
        AssessmentOption(label: '饮酒频率较高，酒量也相对更大。', score: 2),
      ],
    ),
  ];

  static const List<_SbtiNormalPattern> _normalTypes = [
    _SbtiNormalPattern(code: 'CTRL', pattern: 'HHH-HMH-MHH-HHH-MHM'),
    _SbtiNormalPattern(code: 'ATM-er', pattern: 'HHH-HHM-HHH-HMH-MHL'),
    _SbtiNormalPattern(code: 'Dior-s', pattern: 'MHM-MMH-MHM-HMH-LHL'),
    _SbtiNormalPattern(code: 'BOSS', pattern: 'HHH-HMH-MMH-HHH-LHL'),
    _SbtiNormalPattern(code: 'THAN-K', pattern: 'MHM-HMM-HHM-MMH-MHL'),
    _SbtiNormalPattern(code: 'OH-NO', pattern: 'HHL-LMH-LHH-HHM-LHL'),
    _SbtiNormalPattern(code: 'GOGO', pattern: 'HHM-HMH-MMH-HHH-MHM'),
    _SbtiNormalPattern(code: 'SEXY', pattern: 'HMH-HHL-HMM-HMM-HLH'),
    _SbtiNormalPattern(code: 'LOVE-R', pattern: 'MLH-LHL-HLH-MLM-MLH'),
    _SbtiNormalPattern(code: 'MUM', pattern: 'MMH-MHL-HMM-LMM-HLL'),
    _SbtiNormalPattern(code: 'FAKE', pattern: 'HLM-MML-MLM-MLM-HLH'),
    _SbtiNormalPattern(code: 'OJBK', pattern: 'MMH-MMM-HML-LMM-MML'),
    _SbtiNormalPattern(code: 'MALO', pattern: 'MLH-MHM-MLH-MLH-LMH'),
    _SbtiNormalPattern(code: 'JOKE-R', pattern: 'LLH-LHL-LML-LLL-MLM'),
    _SbtiNormalPattern(code: 'WOW', pattern: 'HHL-HMH-MMH-HHM-LHH'),
    _SbtiNormalPattern(code: 'THIN-K', pattern: 'HHL-HMH-MLH-MHM-LHH'),
    _SbtiNormalPattern(code: 'EDGE', pattern: 'HHL-HLH-LMM-HHM-LHH'),
    _SbtiNormalPattern(code: 'ZZZZ', pattern: 'MHL-MLH-LML-MML-LHM'),
    _SbtiNormalPattern(code: 'POOR', pattern: 'HHL-MLH-LMH-HHH-LHL'),
    _SbtiNormalPattern(code: 'MONK', pattern: 'HHL-LLH-LLM-MML-LHM'),
    _SbtiNormalPattern(code: 'CALM', pattern: 'LLM-LMM-LLL-LLL-MLM'),
    _SbtiNormalPattern(code: 'SOLO', pattern: 'LML-LLH-LHL-LML-LHM'),
    _SbtiNormalPattern(code: 'SPRK', pattern: 'MLL-LHL-LLM-MLL-HLH'),
    _SbtiNormalPattern(code: 'DEAD', pattern: 'LLL-LLM-LML-LLL-LHM'),
    _SbtiNormalPattern(code: 'REUP', pattern: 'LLH-LHL-LML-LLL-MLL'),
  ];

  static const Map<String, _SbtiTypeProfile> _typeLibrary = {
    'CTRL': _SbtiTypeProfile(code: 'CTRL', cn: '掌控者', intro: '你擅长把握局面与节奏。'),
    'ATM-er': _SbtiTypeProfile(
      code: 'ATM-er',
      cn: '支持者',
      intro: '你愿意投入资源支持重要关系。',
    ),
    'Dior-s': _SbtiTypeProfile(code: 'Dior-s', cn: '逆风者', intro: '你常在逆风中寻找突破。'),
    'BOSS': _SbtiTypeProfile(code: 'BOSS', cn: '领导者', intro: '你倾向主动决策并承担责任。'),
    'THAN-K': _SbtiTypeProfile(
      code: 'THAN-K',
      cn: '感恩者',
      intro: '我感谢苍天！我感谢大地！',
    ),
    'OH-NO': _SbtiTypeProfile(
      code: 'OH-NO',
      cn: '谨慎者',
      intro: '你会提前关注风险与不确定性。',
    ),
    'GOGO': _SbtiTypeProfile(code: 'GOGO', cn: '行动者', intro: '你偏好快速启动并立即尝试。'),
    'SEXY': _SbtiTypeProfile(
      code: 'SEXY',
      cn: '魅力者',
      intro: '你在互动中有较强吸引力与表现力。',
    ),
    'LOVE-R': _SbtiTypeProfile(
      code: 'LOVE-R',
      cn: '多情者',
      intro: '爱意太满，现实显得有点贫瘠。',
    ),
    'MUM': _SbtiTypeProfile(code: 'MUM', cn: '照护者', intro: '你在关系中更愿意照顾他人感受。'),
    'FAKE': _SbtiTypeProfile(code: 'FAKE', cn: '面具者', intro: '你会根据场景切换表达方式。'),
    'OJBK': _SbtiTypeProfile(
      code: 'OJBK',
      cn: '随和者',
      intro: '你通常保持弹性，不执着单一路径。',
    ),
    'MALO': _SbtiTypeProfile(code: 'MALO', cn: '行动者', intro: '你更关注现实执行与推进。'),
    'JOKE-R': _SbtiTypeProfile(code: 'JOKE-R', cn: '戏谑者', intro: '你习惯用幽默化解压力。'),
    'WOW': _SbtiTypeProfile(code: 'WOW', cn: '惊叹者', intro: '你对外界变化有强烈感受。'),
    'THIN-K': _SbtiTypeProfile(
      code: 'THIN-K',
      cn: '思考者',
      intro: '你会在行动前进行更充分推演。',
    ),
    'EDGE': _SbtiTypeProfile(code: 'EDGE', cn: '直言者', intro: '你对问题保持批判和直率。'),
    'ZZZZ': _SbtiTypeProfile(code: 'ZZZZ', cn: '休整者', intro: '你倾向先恢复状态，再继续推进。'),
    'POOR': _SbtiTypeProfile(code: 'POOR', cn: '节制者', intro: '你在资源使用上更谨慎克制。'),
    'MONK': _SbtiTypeProfile(code: 'MONK', cn: '克制者', intro: '你偏向低欲望和稳定节奏。'),
    'CALM': _SbtiTypeProfile(code: 'CALM', cn: '慢热者', intro: '你习惯先观察，再投入行动。'),
    'SOLO': _SbtiTypeProfile(code: 'SOLO', cn: '独行者', intro: '你更适应独立处理问题。'),
    'SPRK': _SbtiTypeProfile(code: 'SPRK', cn: '爆发者', intro: '你在压力下会快速释放情绪。'),
    'DEAD': _SbtiTypeProfile(
      code: 'DEAD',
      cn: '停摆者',
      intro: '你在高压时可能暂时停摆，需要恢复期。',
    ),
    'REUP': _SbtiTypeProfile(code: 'REUP', cn: '重启者', intro: '你更容易在低谷中重新开始。'),
    'HHHH': _SbtiTypeProfile(code: 'HHHH', cn: '乐天者', intro: '你倾向于用乐观缓冲压力。'),
    'DRUNK': _SbtiTypeProfile(
      code: 'DRUNK',
      cn: '微醺者',
      intro: '饮酒偏好在本次结果中影响较大。',
    ),
  };

  static AssessmentResult evaluate({
    required MentalAssessmentDefinition definition,
    required Map<String, int> answersByQuestionId,
    required List<int> answersInDisplayOrder,
    required DateTime completedAt,
  }) {
    final rawScores = <String, int>{
      for (final dimensionId in dimensionOrder) dimensionId: 0,
    };

    for (final question in questions) {
      final dimensionId = question.dimensionId;
      if (dimensionId == null) continue;
      rawScores[dimensionId] =
          rawScores[dimensionId]! + (answersByQuestionId[question.id] ?? 0);
    }

    final levels = <String, String>{
      for (final dimensionId in dimensionOrder)
        dimensionId: _scoreToLevel(rawScores[dimensionId] ?? 0),
    };
    final resultPattern = _buildPattern(levels);
    final userVector = _patternToVector(resultPattern);

    final ranked =
        _normalTypes
            .map((normalType) => _rankOne(normalType, userVector))
            .toList(growable: false)
          ..sort((left, right) {
            if (left.distance != right.distance) {
              return left.distance.compareTo(right.distance);
            }
            if (left.exact != right.exact) {
              return right.exact.compareTo(left.exact);
            }
            return right.similarity.compareTo(left.similarity);
          });

    final bestNormal = ranked.first;
    final drinkTriggered =
        (answersByQuestionId[drinkTriggerQuestionId] ?? 0) == 2;
    final fallbackTriggered =
        !drinkTriggered && bestNormal.similarity < fallbackSimilarityThreshold;

    final _SbtiTypeProfile finalType;
    final String modeKicker;
    final String badge;
    final String sub;
    _SbtiTypeProfile? secondaryType;

    if (drinkTriggered) {
      finalType = _typeLibrary['DRUNK']!;
      secondaryType = _typeLibrary[bestNormal.code];
      modeKicker = '隐藏人格已激活';
      badge = '匹配度 100% · 饮酒偏好维度触发';
      sub = '饮酒偏好在本次结果中权重较高，系统优先返回该分支类型。';
    } else if (fallbackTriggered) {
      finalType = _typeLibrary['HHHH']!;
      modeKicker = '系统强制兜底';
      badge = '标准人格库最高匹配仅 ${bestNormal.similarity}%';
      sub = '标准人格库对你的脑回路集体罢工了，于是系统把你强制分配给了 HHHH。';
    } else {
      finalType = _typeLibrary[bestNormal.code]!;
      modeKicker = '你的主类型';
      badge = '匹配度 ${bestNormal.similarity}% · 精准命中 ${bestNormal.exact}/15 维';
      sub = '维度命中度较高，当前结果可视为你的第一人格画像。';
    }

    final detailLines = <String>[
      '$modeKicker · $badge',
      sub,
      '结果字符串：$resultPattern',
      if (secondaryType != null)
        '常规主类型：${secondaryType.code}（${secondaryType.cn}）',
      _dimensionSummary(levels),
    ];
    final topMatches = ranked
        .take(3)
        .map((entry) {
          final profile = _typeLibrary[entry.code];
          return <String, dynamic>{
            'code': entry.code,
            'cn': profile?.cn ?? entry.code,
            'similarity': entry.similarity,
            'distance': entry.distance,
            'exact': entry.exact,
            'pattern': entry.pattern,
          };
        })
        .toList(growable: false);

    final displayScore = drinkTriggered ? 100 : bestNormal.similarity;
    final emoji = switch (finalType.code) {
      'DRUNK' => '🍺',
      'HHHH' => '😂',
      _ => definition.emoji,
    };

    return AssessmentResult(
      assessmentId: definition.id,
      assessmentName: definition.name,
      category: definition.category,
      resultTitle: 'SBTI · ${finalType.code}（${finalType.cn}）',
      summary: finalType.intro,
      guidance: detailLines.join('\n'),
      emoji: emoji,
      totalScore: displayScore,
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
        'sbti': {
          'modeKicker': modeKicker,
          'badge': badge,
          'sub': sub,
          'resultPattern': resultPattern,
          'finalTypeCode': finalType.code,
          'finalTypeCn': finalType.cn,
          'secondaryTypeCode': secondaryType?.code,
          'rawScores': {
            for (final dimensionId in dimensionOrder)
              dimensionId: rawScores[dimensionId] ?? 0,
          },
          'levels': {
            for (final dimensionId in dimensionOrder)
              dimensionId: levels[dimensionId] ?? 'L',
          },
          'dimensionMeta': dimensionMeta,
          'topMatches': topMatches,
          'flags': {
            'drinkTriggered': drinkTriggered,
            'fallbackTriggered': fallbackTriggered,
          },
        },
      },
    );
  }

  static String _scoreToLevel(int score) {
    if (score <= 3) return 'L';
    if (score == 4) return 'M';
    return 'H';
  }

  static String _buildPattern(Map<String, String> levels) {
    final letters = <String>[
      for (final dimensionId in dimensionOrder) levels[dimensionId] ?? 'L',
    ];
    final groups = <String>[];
    for (var index = 0; index < letters.length; index += 3) {
      groups.add(letters.sublist(index, index + 3).join());
    }
    return groups.join('-');
  }

  static List<int> _patternToVector(String pattern) {
    final letters = pattern.replaceAll('-', '').split('');
    return letters
        .map(
          (letter) => switch (letter) {
            'L' => 1,
            'M' => 2,
            'H' => 3,
            _ => 1,
          },
        )
        .toList(growable: false);
  }

  static _SbtiRankedType _rankOne(
    _SbtiNormalPattern normalType,
    List<int> userVector,
  ) {
    final patternVector = _patternToVector(normalType.pattern);
    var distance = 0;
    var exact = 0;
    for (var index = 0; index < patternVector.length; index++) {
      final diff = (userVector[index] - patternVector[index]).abs();
      distance += diff;
      if (diff == 0) {
        exact += 1;
      }
    }
    final similarity = (1 - distance / similarityDistanceDenominator) * 100;
    return _SbtiRankedType(
      code: normalType.code,
      pattern: normalType.pattern,
      distance: distance,
      exact: exact,
      similarity: similarity.clamp(0, 100).round(),
    );
  }

  static String _dimensionSummary(Map<String, String> levels) {
    final summary = dimensionOrder
        .map(
          (dimensionId) =>
              '${dimensionMeta[dimensionId]}:${levels[dimensionId]}',
        )
        .join(' | ');
    return '15维概览：$summary';
  }
}

class _SbtiNormalPattern {
  final String code;
  final String pattern;

  const _SbtiNormalPattern({required this.code, required this.pattern});
}

class _SbtiTypeProfile {
  final String code;
  final String cn;
  final String intro;

  const _SbtiTypeProfile({
    required this.code,
    required this.cn,
    required this.intro,
  });
}

class _SbtiRankedType {
  final String code;
  final String pattern;
  final int distance;
  final int exact;
  final int similarity;

  const _SbtiRankedType({
    required this.code,
    required this.pattern,
    required this.distance,
    required this.exact,
    required this.similarity,
  });
}
