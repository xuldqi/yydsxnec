import '../models/mental_assessment.dart';
import 'adhd_screening_scoring.dart';
import 'attachment_scoring.dart';
import 'big_five_scoring.dart';
import 'enneagram_scoring.dart';
import 'mbti_scoring.dart';
import 'sbti_scoring.dart';

class AssessmentCatalog {
  static const _standardizedFrequencyOptions = [
    AssessmentOption(label: '完全没有', score: 0),
    AssessmentOption(label: '几天', score: 1),
    AssessmentOption(label: '一半以上天数', score: 2),
    AssessmentOption(label: '几乎每天', score: 3),
  ];

  static final List<MentalAssessmentDefinition> all = [
    MentalAssessmentDefinition(
      id: 'phq2',
      name: 'PHQ-2 抑郁筛查',
      shortDescription: '用 2 道题快速筛查近两周的低落与兴趣下降',
      emoji: '🩺',
      intro: '这是一个常用的抑郁快速筛查工具，可帮助你判断是否值得继续做完整版评估。',
      durationLabel: '约 1 分钟',
      category: AssessmentCategory.standardizedScreener,
      periodLabel: '过去两周',
      sourceLabel: 'Patient Health Questionnaire-2 (PHQ-2)',
      disclaimer: '结果仅用于初步筛查和自我了解，不能替代诊断。如果你已经明显受影响，建议及时寻求专业帮助。',
      questions: const [
        AssessmentQuestion(
          id: 'phq2_q1',
          prompt: '做事时提不起兴趣，或者感受不到乐趣',
          options: _standardizedFrequencyOptions,
        ),
        AssessmentQuestion(
          id: 'phq2_q2',
          prompt: '感到情绪低落、沮丧，或者觉得没有希望',
          options: _standardizedFrequencyOptions,
        ),
      ],
      bands: const [
        AssessmentBand(
          maxScore: 2,
          title: '暂未见明显抑郁风险',
          summary: '这次快速筛查没有显示出明显的抑郁风险信号。',
          guidance: '如果你最近只是偶尔起伏，可以先继续记录心情、睡眠和压力变化。若低落持续加重，建议改做完整版 PHQ-9。',
          emoji: '🌿',
          severity: AssessmentSeverity.low,
        ),
        AssessmentBand(
          maxScore: 6,
          title: '建议继续做完整版评估',
          summary: '这个结果提示你最近两周可能有一定的低落或兴趣下降，需要进一步确认。',
          guidance:
              '下一步建议做完整版 PHQ-9，并留意睡眠、精力和日常功能是否持续受影响。如果已经明显影响生活，可以直接寻求专业支持。',
          emoji: '🫧',
          severity: AssessmentSeverity.moderate,
          recommendProfessionalSupport: true,
        ),
      ],
    ),
    MentalAssessmentDefinition(
      id: 'phq9',
      name: 'PHQ-9 抑郁筛查',
      shortDescription: '更完整地了解近两周的抑郁相关症状',
      emoji: '📋',
      intro: 'PHQ-9 常用于抑郁症状的初步筛查和严重程度分层。',
      durationLabel: '约 2 分钟',
      category: AssessmentCategory.standardizedScreener,
      periodLabel: '过去两周',
      sourceLabel: 'Patient Health Questionnaire-9 (PHQ-9)',
      disclaimer: 'PHQ-9 是筛查工具，不等于临床诊断。若结果偏高，或你感到自己不安全，请尽快联系专业人士或当地紧急支持系统。',
      safetyQuestionIndex: 8,
      questions: const [
        AssessmentQuestion(
          id: 'phq9_q1',
          prompt: '做事时提不起兴趣，或者感受不到乐趣',
          options: _standardizedFrequencyOptions,
        ),
        AssessmentQuestion(
          id: 'phq9_q2',
          prompt: '感到情绪低落、沮丧，或者觉得没有希望',
          options: _standardizedFrequencyOptions,
        ),
        AssessmentQuestion(
          id: 'phq9_q3',
          prompt: '入睡困难、睡不安稳，或者睡得过多',
          options: _standardizedFrequencyOptions,
        ),
        AssessmentQuestion(
          id: 'phq9_q4',
          prompt: '感到疲倦，或者没有精力',
          options: _standardizedFrequencyOptions,
        ),
        AssessmentQuestion(
          id: 'phq9_q5',
          prompt: '食欲不振，或者吃得明显比平时多',
          options: _standardizedFrequencyOptions,
        ),
        AssessmentQuestion(
          id: 'phq9_q6',
          prompt: '觉得自己很糟，或者觉得自己让自己或家人失望',
          options: _standardizedFrequencyOptions,
        ),
        AssessmentQuestion(
          id: 'phq9_q7',
          prompt: '很难专注，比如阅读、工作或看内容时容易分神',
          options: _standardizedFrequencyOptions,
        ),
        AssessmentQuestion(
          id: 'phq9_q8',
          prompt: '动作或说话比平时慢很多，或者反过来坐立不安、停不下来',
          options: _standardizedFrequencyOptions,
        ),
        AssessmentQuestion(
          id: 'phq9_q9',
          prompt: '觉得自己不如死了算了，或者有伤害自己的念头',
          options: _standardizedFrequencyOptions,
        ),
      ],
      bands: const [
        AssessmentBand(
          maxScore: 4,
          title: '当前抑郁症状较少',
          summary: '结果显示你当前的抑郁相关症状整体较少。',
          guidance: '可以继续通过记录心情、规律作息和基础放松练习来观察状态。如果之后连续两周明显变差，建议复测或寻求支持。',
          emoji: '🌿',
          severity: AssessmentSeverity.low,
        ),
        AssessmentBand(
          maxScore: 9,
          title: '轻度抑郁风险',
          summary: '你最近可能有一些低落、疲惫或兴趣下降的信号，值得持续关注。',
          guidance:
              '建议在未来 1 到 2 周继续观察，并优先照顾睡眠、饮食和节奏。若影响开始扩大，可以复测 PHQ-9 或直接找专业人士聊聊。',
          emoji: '🍃',
          severity: AssessmentSeverity.mild,
        ),
        AssessmentBand(
          maxScore: 14,
          title: '中度抑郁风险',
          summary: '结果提示抑郁相关症状已达到需要认真关注的程度。',
          guidance: '建议尽快增加支持：减少独自硬扛，和信任的人说明近况，并考虑预约专业评估。同时记录每天的情绪、睡眠和最小可完成事项。',
          emoji: '🌧',
          severity: AssessmentSeverity.moderate,
          recommendProfessionalSupport: true,
        ),
        AssessmentBand(
          maxScore: 19,
          title: '中重度抑郁风险',
          summary: '你最近的抑郁相关症状偏重，已经不适合只靠自己撑着。',
          guidance:
              '建议尽快寻求专业支持，并让身边可信任的人知道你现在并不好。先把目标收缩到基本休息、安全和陪伴，不必逼自己保持原来的效率。',
          emoji: '🫧',
          severity: AssessmentSeverity.elevated,
          recommendProfessionalSupport: true,
        ),
        AssessmentBand(
          maxScore: 27,
          title: '重度抑郁风险',
          summary: '结果提示当前状态已经较重，需要尽快获得专业帮助和现实支持。',
          guidance:
              '请优先联系专业机构、医生或危机支持资源，并尽量不要一个人硬扛。如果你已经担心自己的安全，应该立刻联系当地紧急援助或可信任的人陪你。',
          emoji: '🚨',
          severity: AssessmentSeverity.high,
          recommendProfessionalSupport: true,
        ),
      ],
    ),
    MentalAssessmentDefinition(
      id: 'gad2',
      name: 'GAD-2 焦虑筛查',
      shortDescription: '用 2 道题快速筛查近两周的焦虑与担忧',
      emoji: '🩺',
      intro: '这是一个常用的焦虑快速筛查工具，适合先做基础判断。',
      durationLabel: '约 1 分钟',
      category: AssessmentCategory.standardizedScreener,
      periodLabel: '过去两周',
      sourceLabel: 'Generalized Anxiety Disorder-2 (GAD-2)',
      disclaimer: '结果仅用于初步筛查，不能代替专业诊断。如果你的紧张和担忧已经明显影响生活，建议继续做 GAD-7 或尽快寻求帮助。',
      questions: const [
        AssessmentQuestion(
          id: 'gad2_q1',
          prompt: '感到紧张、焦虑，或者总是处在绷着的状态',
          options: _standardizedFrequencyOptions,
        ),
        AssessmentQuestion(
          id: 'gad2_q2',
          prompt: '无法停止担心，或者很难控制自己的担忧',
          options: _standardizedFrequencyOptions,
        ),
      ],
      bands: const [
        AssessmentBand(
          maxScore: 2,
          title: '暂未见明显焦虑风险',
          summary: '这次快速筛查没有显示出明显的焦虑风险。',
          guidance: '如果你只是阶段性紧张，可以先继续观察压力源、睡眠和躯体反应。若之后越来越频繁，建议改做完整版 GAD-7。',
          emoji: '🌿',
          severity: AssessmentSeverity.low,
        ),
        AssessmentBand(
          maxScore: 6,
          title: '建议继续做完整版评估',
          summary: '这个结果提示你最近两周可能存在持续的焦虑或担忧，需要进一步确认。',
          guidance: '下一步建议做完整版 GAD-7，并留意是否伴随失眠、心慌、回避或注意力下降。若影响已经明显，建议尽早寻求支持。',
          emoji: '🫧',
          severity: AssessmentSeverity.moderate,
          recommendProfessionalSupport: true,
        ),
      ],
    ),
    MentalAssessmentDefinition(
      id: 'gad7',
      name: 'GAD-7 焦虑筛查',
      shortDescription: '更完整地了解近两周的焦虑症状强度',
      emoji: '📋',
      intro: 'GAD-7 常用于焦虑症状的初步筛查和严重程度分层。',
      durationLabel: '约 2 分钟',
      category: AssessmentCategory.standardizedScreener,
      periodLabel: '过去两周',
      sourceLabel: 'Generalized Anxiety Disorder-7 (GAD-7)',
      disclaimer: '结果仅用于筛查和自我了解，不能替代诊断。若焦虑持续升级、伴随明显躯体不适或回避行为，建议及时寻求专业帮助。',
      questions: const [
        AssessmentQuestion(
          id: 'gad7_q1',
          prompt: '感到紧张、焦虑，或者总是处在绷着的状态',
          options: _standardizedFrequencyOptions,
        ),
        AssessmentQuestion(
          id: 'gad7_q2',
          prompt: '无法停止担心，或者很难控制自己的担忧',
          options: _standardizedFrequencyOptions,
        ),
        AssessmentQuestion(
          id: 'gad7_q3',
          prompt: '对很多事情都担心得过多',
          options: _standardizedFrequencyOptions,
        ),
        AssessmentQuestion(
          id: 'gad7_q4',
          prompt: '很难放松下来',
          options: _standardizedFrequencyOptions,
        ),
        AssessmentQuestion(
          id: 'gad7_q5',
          prompt: '因为过于不安而很难安静坐着',
          options: _standardizedFrequencyOptions,
        ),
        AssessmentQuestion(
          id: 'gad7_q6',
          prompt: '容易烦躁，或者比平时更容易发火',
          options: _standardizedFrequencyOptions,
        ),
        AssessmentQuestion(
          id: 'gad7_q7',
          prompt: '感到好像会有不好的事情发生',
          options: _standardizedFrequencyOptions,
        ),
      ],
      bands: const [
        AssessmentBand(
          maxScore: 4,
          title: '当前焦虑症状较少',
          summary: '结果显示你当前的焦虑相关症状整体较少。',
          guidance: '可以继续观察自己的压力源和身体反应，保持规律作息。若后续紧张频率升高，建议在 1 到 2 周后复测。',
          emoji: '🌿',
          severity: AssessmentSeverity.low,
        ),
        AssessmentBand(
          maxScore: 9,
          title: '轻度焦虑风险',
          summary: '你最近可能存在一些持续的担忧、紧绷或不易放松。',
          guidance: '建议先做减压和放松管理，比如呼吸练习、限制反复想同一件事的时间，并记录触发焦虑的情境。',
          emoji: '🍃',
          severity: AssessmentSeverity.mild,
        ),
        AssessmentBand(
          maxScore: 14,
          title: '中度焦虑风险',
          summary: '结果提示焦虑已经到了需要认真应对的程度。',
          guidance:
              '建议尽快为自己增加支持，包括减少高压输入、和可信任的人沟通，并考虑预约专业评估。如果心慌、失眠或回避越来越明显，更应尽快求助。',
          emoji: '🌧',
          severity: AssessmentSeverity.moderate,
          recommendProfessionalSupport: true,
        ),
        AssessmentBand(
          maxScore: 21,
          title: '高焦虑风险',
          summary: '你的焦虑相关症状已经较重，单靠硬撑通常很难缓解。',
          guidance: '建议尽快寻求专业支持，并优先照顾睡眠、安全感和现实减压。先把节奏慢下来，不必要求自己继续按高压标准运转。',
          emoji: '🚨',
          severity: AssessmentSeverity.high,
          recommendProfessionalSupport: true,
        ),
      ],
    ),
    MentalAssessmentDefinition(
      id: 'adhd_quick_6',
      name: 'ADHD 快速筛查',
      shortDescription: '6 题快速判断注意力与冲动相关风险',
      emoji: '🧠',
      intro: '基于 ASRS 思路的 6 题快速筛查，用于初步识别注意力与冲动控制风险。',
      durationLabel: '约 1-2 分钟',
      category: AssessmentCategory.standardizedScreener,
      periodLabel: '过去 6 个月',
      sourceLabel: 'ASRS v1.1 思路（非临床版）',
      disclaimer: '该结果仅用于筛查，不等于医学诊断。若结果偏高或已影响学习/工作/生活，请尽快寻求专业评估。',
      questions: AdhdScreeningScoring.quickQuestions,
      bands: const [
        AssessmentBand(
          maxScore: 24,
          title: 'ADHD 筛查结果',
          summary: 'ADHD 筛查结果已生成。',
          guidance: '请查看下方结果详情。',
          emoji: '🧠',
          severity: AssessmentSeverity.low,
        ),
      ],
      customEvaluator: AdhdScreeningScoring.evaluate,
    ),
    MentalAssessmentDefinition(
      id: 'adhd_full_18',
      name: 'ADHD 完整筛查',
      shortDescription: '18 题更完整评估注意力与冲动控制风险',
      emoji: '📚',
      intro: '这是基于 ASRS 思路的 18 题完整版筛查，能更完整呈现注意力缺陷与多动/冲动风险。',
      durationLabel: '约 4-6 分钟',
      category: AssessmentCategory.standardizedScreener,
      periodLabel: '过去 6 个月',
      sourceLabel: 'ASRS v1.1 思路（非临床版）',
      disclaimer: '结果仅用于筛查与自我了解，不构成临床诊断。若持续影响功能，请尽快预约专业评估。',
      questions: AdhdScreeningScoring.fullQuestions,
      bands: const [
        AssessmentBand(
          maxScore: 72,
          title: 'ADHD 筛查结果',
          summary: 'ADHD 筛查结果已生成。',
          guidance: '请查看下方结果详情。',
          emoji: '📚',
          severity: AssessmentSeverity.low,
        ),
      ],
      customEvaluator: AdhdScreeningScoring.evaluate,
    ),
    MentalAssessmentDefinition(
      id: 'sbti_style_compass',
      name: 'SBTI 风格探索',
      shortDescription: '用 31 题了解你的决策、协作与应压风格',
      emoji: '🧭',
      intro: '基于公开 SBTI 题库（31 题）生成的风格画像，用于自我了解，不用于医疗诊断。',
      durationLabel: '约 6-8 分钟',
      category: AssessmentCategory.selfReflection,
      periodLabel: '当前状态',
      sourceLabel: 'SBTI Personality Test（公开题库离线快照）',
      disclaimer: '该结果仅用于娱乐与自我探索，不具备心理诊断效力。',
      questions: SbtiScoring.questions,
      bands: const [
        AssessmentBand(
          maxScore: 100,
          title: 'SBTI 结果',
          summary: 'SBTI 结果已生成。',
          guidance: '请查看下方结果详情。',
          emoji: '🧭',
          severity: AssessmentSeverity.low,
        ),
      ],
      customEvaluator: SbtiScoring.evaluate,
    ),
    MentalAssessmentDefinition(
      id: 'mbti_personality_compass',
      name: 'MBTI 快速版',
      shortDescription: '20 题快速了解你在四个维度上的偏好组合',
      emoji: '🧩',
      intro: '基于 MBTI 维度模型设计的轻量探索问卷，适合先快速看倾向，不用于医疗诊断。',
      durationLabel: '约 3-4 分钟',
      category: AssessmentCategory.selfReflection,
      periodLabel: '当前状态',
      sourceLabel: 'MBTI 维度模型（非官方轻量版）',
      disclaimer: '该结果仅用于自我探索，不代表临床或职业测评结论。',
      questions: MbtiScoring.questions,
      bands: const [
        AssessmentBand(
          maxScore: 100,
          title: 'MBTI 结果',
          summary: 'MBTI 结果已生成。',
          guidance: '请查看下方结果详情。',
          emoji: '🧩',
          severity: AssessmentSeverity.low,
        ),
      ],
      customEvaluator: MbtiScoring.evaluate,
    ),
    MentalAssessmentDefinition(
      id: 'mbti_full_60',
      name: 'MBTI 完整版',
      shortDescription: '60 题更稳定地刻画四维偏好与类型匹配',
      emoji: '🧠',
      intro: '这是更完整的 MBTI 风格探索版本，题量更高，结果通常更稳定，不用于医疗诊断。',
      durationLabel: '约 6-8 分钟',
      category: AssessmentCategory.selfReflection,
      periodLabel: '当前状态',
      sourceLabel: 'MBTI 维度模型（非官方完整版）',
      disclaimer: '该结果仅用于自我探索，不代表临床或职业测评结论。',
      questions: MbtiScoring.fullQuestions,
      bands: const [
        AssessmentBand(
          maxScore: 100,
          title: 'MBTI 结果',
          summary: 'MBTI 结果已生成。',
          guidance: '请查看下方结果详情。',
          emoji: '🧠',
          severity: AssessmentSeverity.low,
        ),
      ],
      customEvaluator: MbtiScoring.evaluate,
    ),
    MentalAssessmentDefinition(
      id: 'mbti_advanced_93',
      name: 'MBTI 进阶版',
      shortDescription: '93 题进阶探索，适合想看更细偏好的人',
      emoji: '🔬',
      intro: '这是进阶 MBTI 风格探索版本，题量更高，适合希望得到更细致偏好分布的用户，不用于医疗诊断。',
      durationLabel: '约 10-12 分钟',
      category: AssessmentCategory.selfReflection,
      periodLabel: '当前状态',
      sourceLabel: 'MBTI 维度模型（非官方进阶版）',
      disclaimer: '该结果仅用于自我探索，不代表临床或职业测评结论。',
      questions: MbtiScoring.professionalQuestions,
      bands: const [
        AssessmentBand(
          maxScore: 100,
          title: 'MBTI 结果',
          summary: 'MBTI 结果已生成。',
          guidance: '请查看下方结果详情。',
          emoji: '🔬',
          severity: AssessmentSeverity.low,
        ),
      ],
      customEvaluator: MbtiScoring.evaluate,
    ),
    MentalAssessmentDefinition(
      id: 'mbti_pro_200',
      name: 'MBTI 专业版',
      shortDescription: '200 题专业探索，适合深度画像与长期对照',
      emoji: '🧭',
      intro: '这是专业 MBTI 风格探索版本，题量最高，适合做更细粒度的倾向观察与长期自我对照，不用于医疗诊断。',
      durationLabel: '约 18-25 分钟',
      category: AssessmentCategory.selfReflection,
      periodLabel: '当前状态',
      sourceLabel: 'MBTI 维度模型（非官方专业版）',
      disclaimer: '该结果仅用于自我探索，不代表临床或职业测评结论。',
      questions: MbtiScoring.expertQuestions,
      bands: const [
        AssessmentBand(
          maxScore: 100,
          title: 'MBTI 结果',
          summary: 'MBTI 结果已生成。',
          guidance: '请查看下方结果详情。',
          emoji: '🧭',
          severity: AssessmentSeverity.low,
        ),
      ],
      customEvaluator: MbtiScoring.evaluate,
    ),
    MentalAssessmentDefinition(
      id: 'attachment_quick_16',
      name: '依恋风格快速版',
      shortDescription: '16 题快速看你的关系安全感与靠近模式',
      emoji: '🫶',
      intro: '轻量版依恋风格探索，适合先快速看“安全感-焦虑-回避-投入”的整体轮廓。',
      durationLabel: '约 2-3 分钟',
      category: AssessmentCategory.selfReflection,
      periodLabel: '当前状态',
      sourceLabel: '依恋理论框架（非官方轻量版）',
      disclaimer: '该结果仅用于自我探索，不代表临床诊断结论。',
      questions: AttachmentScoring.quickQuestions,
      bands: const [
        AssessmentBand(
          maxScore: 100,
          title: '依恋风格结果',
          summary: '依恋风格结果已生成。',
          guidance: '请查看下方结果详情。',
          emoji: '🫶',
          severity: AssessmentSeverity.low,
        ),
      ],
      customEvaluator: AttachmentScoring.evaluate,
    ),
    MentalAssessmentDefinition(
      id: 'attachment_full_40',
      name: '依恋风格完整版',
      shortDescription: '40 题更稳定刻画你的关系模式',
      emoji: '💞',
      intro: '完整版依恋风格探索，适合更稳定地识别你的主风格与次风格。',
      durationLabel: '约 5-7 分钟',
      category: AssessmentCategory.selfReflection,
      periodLabel: '当前状态',
      sourceLabel: '依恋理论框架（非官方完整版）',
      disclaimer: '该结果仅用于自我探索，不代表临床诊断结论。',
      questions: AttachmentScoring.fullQuestions,
      bands: const [
        AssessmentBand(
          maxScore: 100,
          title: '依恋风格结果',
          summary: '依恋风格结果已生成。',
          guidance: '请查看下方结果详情。',
          emoji: '💞',
          severity: AssessmentSeverity.low,
        ),
      ],
      customEvaluator: AttachmentScoring.evaluate,
    ),
    MentalAssessmentDefinition(
      id: 'attachment_advanced_80',
      name: '依恋风格进阶版',
      shortDescription: '80 题进阶探索，适合做长期对照追踪',
      emoji: '🧭',
      intro: '进阶版依恋风格探索，题量更高，适合做阶段性复测和趋势对照。',
      durationLabel: '约 10-14 分钟',
      category: AssessmentCategory.selfReflection,
      periodLabel: '当前状态',
      sourceLabel: '依恋理论框架（非官方进阶版）',
      disclaimer: '该结果仅用于自我探索，不代表临床诊断结论。',
      questions: AttachmentScoring.advancedQuestions,
      bands: const [
        AssessmentBand(
          maxScore: 100,
          title: '依恋风格结果',
          summary: '依恋风格结果已生成。',
          guidance: '请查看下方结果详情。',
          emoji: '🧭',
          severity: AssessmentSeverity.low,
        ),
      ],
      customEvaluator: AttachmentScoring.evaluate,
    ),
    MentalAssessmentDefinition(
      id: 'big5_quick_20',
      name: '大五人格快速版',
      shortDescription: '20 题快速查看 OCEAN 五维偏好',
      emoji: '🌊',
      intro: '快速版大五人格评估，适合先看五维偏好概览。',
      durationLabel: '约 3-4 分钟',
      category: AssessmentCategory.selfReflection,
      periodLabel: '当前状态',
      sourceLabel: 'Big Five / OCEAN（非官方轻量版）',
      disclaimer: '该结果仅用于自我探索，不代表临床或职业测评结论。',
      questions: BigFiveScoring.quickQuestions,
      bands: const [
        AssessmentBand(
          maxScore: 100,
          title: '大五人格结果',
          summary: '大五人格结果已生成。',
          guidance: '请查看下方结果详情。',
          emoji: '🌊',
          severity: AssessmentSeverity.low,
        ),
      ],
      customEvaluator: BigFiveScoring.evaluate,
    ),
    MentalAssessmentDefinition(
      id: 'big5_full_50',
      name: '大五人格完整版',
      shortDescription: '50 题更稳定评估 OCEAN 五维分布',
      emoji: '📈',
      intro: '完整版大五人格评估，包含正反向题，结果更稳定。',
      durationLabel: '约 6-8 分钟',
      category: AssessmentCategory.selfReflection,
      periodLabel: '当前状态',
      sourceLabel: 'Big Five / OCEAN（非官方完整版）',
      disclaimer: '该结果仅用于自我探索，不代表临床或职业测评结论。',
      questions: BigFiveScoring.fullQuestions,
      bands: const [
        AssessmentBand(
          maxScore: 100,
          title: '大五人格结果',
          summary: '大五人格结果已生成。',
          guidance: '请查看下方结果详情。',
          emoji: '📈',
          severity: AssessmentSeverity.low,
        ),
      ],
      customEvaluator: BigFiveScoring.evaluate,
    ),
    MentalAssessmentDefinition(
      id: 'big5_advanced_120',
      name: '大五人格进阶版',
      shortDescription: '120 题进阶测评，适合高精度偏好画像',
      emoji: '🔍',
      intro: '进阶版大五人格评估，适合做更细粒度的维度观察。',
      durationLabel: '约 14-20 分钟',
      category: AssessmentCategory.selfReflection,
      periodLabel: '当前状态',
      sourceLabel: 'Big Five / OCEAN（非官方进阶版）',
      disclaimer: '该结果仅用于自我探索，不代表临床或职业测评结论。',
      questions: BigFiveScoring.advancedQuestions,
      bands: const [
        AssessmentBand(
          maxScore: 100,
          title: '大五人格结果',
          summary: '大五人格结果已生成。',
          guidance: '请查看下方结果详情。',
          emoji: '🔍',
          severity: AssessmentSeverity.low,
        ),
      ],
      customEvaluator: BigFiveScoring.evaluate,
    ),
    MentalAssessmentDefinition(
      id: 'enneagram_quick_36',
      name: '九型人格快速版',
      shortDescription: '36 题快速识别主型与次型倾向',
      emoji: '🧩',
      intro: '快速版九型人格探索，适合先看主型轮廓。',
      durationLabel: '约 5-6 分钟',
      category: AssessmentCategory.selfReflection,
      periodLabel: '当前状态',
      sourceLabel: 'Enneagram（非官方轻量版）',
      disclaimer: '该结果仅用于自我探索，不代表临床或职业测评结论。',
      questions: EnneagramScoring.quickQuestions,
      bands: const [
        AssessmentBand(
          maxScore: 100,
          title: '九型人格结果',
          summary: '九型人格结果已生成。',
          guidance: '请查看下方结果详情。',
          emoji: '🧩',
          severity: AssessmentSeverity.low,
        ),
      ],
      customEvaluator: EnneagramScoring.evaluate,
    ),
    MentalAssessmentDefinition(
      id: 'enneagram_full_108',
      name: '九型人格完整版',
      shortDescription: '108 题完整版，包含主型、翅膀与方向提示',
      emoji: '🎯',
      intro: '完整版九型人格探索，适合做更稳定的主型与翅膀判断。',
      durationLabel: '约 14-18 分钟',
      category: AssessmentCategory.selfReflection,
      periodLabel: '当前状态',
      sourceLabel: 'Enneagram（非官方完整版）',
      disclaimer: '该结果仅用于自我探索，不代表临床或职业测评结论。',
      questions: EnneagramScoring.fullQuestions,
      bands: const [
        AssessmentBand(
          maxScore: 100,
          title: '九型人格结果',
          summary: '九型人格结果已生成。',
          guidance: '请查看下方结果详情。',
          emoji: '🎯',
          severity: AssessmentSeverity.low,
        ),
      ],
      customEvaluator: EnneagramScoring.evaluate,
    ),
    MentalAssessmentDefinition(
      id: 'emotion_state_checkin',
      name: '情绪状态评估',
      shortDescription: '了解最近的整体情绪与状态',
      emoji: '🌿',
      intro: '这是一个轻量自测，适合快速回看自己最近的状态。',
      durationLabel: '约 1 分钟',
      category: AssessmentCategory.selfReflection,
      periodLabel: '最近几天',
      questions: [
        _reflectionQuestion(
          id: 'emotion_state_q1',
          prompt: '过去几天你的睡眠怎么样？',
          labels: ['很好，睡得很踏实', '还行', '睡得不太好', '经常失眠或早醒'],
        ),
        _reflectionQuestion(
          id: 'emotion_state_q2',
          prompt: '最近感到精力如何？',
          labels: ['充沛', '还行', '有点累', '很累，提不起劲'],
        ),
        _reflectionQuestion(
          id: 'emotion_state_q3',
          prompt: '情绪整体上？',
          labels: ['比较平稳', '有时会低落', '常常焦虑或烦躁', '说不清，乱糟糟'],
        ),
        _reflectionQuestion(
          id: 'emotion_state_q4',
          prompt: '有没有想倾诉或记录的冲动？',
          labels: ['经常有，想写想聊', '偶尔有', '很少', '没有，不想动'],
        ),
        _reflectionQuestion(
          id: 'emotion_state_q5',
          prompt: '对这几天的自己，你更接近？',
          labels: ['满意，在好好生活', '还行', '一般，有点勉强', '不太满意，想改变'],
        ),
      ],
      bands: const [
        AssessmentBand(
          maxScore: 8,
          title: '情绪状态不错',
          summary: '你近期的整体情绪与状态比较平稳。',
          guidance: '保持现在的记录和觉察习惯即可。若之后有波动，再测一次或多记几笔都有帮助。',
          emoji: '🌿',
          severity: AssessmentSeverity.low,
        ),
        AssessmentBand(
          maxScore: 12,
          title: '可以多关照自己',
          summary: '最近可能有些疲惫或情绪起伏，身体在提醒你多看一眼自己。',
          guidance: '适当减少安排、保证休息；在树洞里多记几笔心情，或和信任的人简单聊聊。',
          emoji: '🍃',
          severity: AssessmentSeverity.mild,
        ),
        AssessmentBand(
          maxScore: 16,
          title: '最近可能有点累',
          summary: '情绪和身体都在提示：你需要多一些休息和出口。',
          guidance: '尽量少逼自己，能推的事先往后放。把感受写下来、散步或做呼吸练习，都会有帮助。',
          emoji: '🌧',
          severity: AssessmentSeverity.moderate,
        ),
        AssessmentBand(
          maxScore: 20,
          title: '需要一点照顾',
          summary: '当前状态比较吃重，你值得被好好看见和照顾。',
          guidance: '先让自己停下来休息，不必硬撑。若这种吃力感持续存在，建议进一步做标准化筛查或寻求专业支持。',
          emoji: '🤗',
          severity: AssessmentSeverity.elevated,
          recommendProfessionalSupport: true,
        ),
      ],
    ),
    MentalAssessmentDefinition(
      id: 'stress_checkin',
      name: '压力自测',
      shortDescription: '看看最近压力有多大',
      emoji: '📋',
      intro: '这是一个轻量自测，帮助你快速感受最近的压力负荷。',
      durationLabel: '约 1 分钟',
      category: AssessmentCategory.selfReflection,
      periodLabel: '最近几天',
      questions: [
        _reflectionQuestion(
          id: 'stress_q1',
          prompt: '最近是否容易紧张？',
          labels: ['很少', '偶尔', '经常', '几乎一直'],
        ),
        _reflectionQuestion(
          id: 'stress_q2',
          prompt: '能放松下来吗？',
          labels: ['很容易', '还行', '有点难', '很难放松'],
        ),
        _reflectionQuestion(
          id: 'stress_q3',
          prompt: '工作或学习带来的压力？',
          labels: ['没什么', '一般', '有点大', '很大'],
        ),
        _reflectionQuestion(
          id: 'stress_q4',
          prompt: '身体有没有紧绷、肩颈酸？',
          labels: ['没有', '偶尔', '经常', '每天都酸'],
        ),
        _reflectionQuestion(
          id: 'stress_q5',
          prompt: '休息一阵后能恢复吗？',
          labels: ['能恢复', '有时能', '很难恢复', '完全恢复不了'],
        ),
      ],
      bands: const [
        AssessmentBand(
          maxScore: 8,
          title: '压力不大',
          summary: '近期压力感较轻，生活节奏相对可控。',
          guidance: '保持现有节奏即可，偶尔留一点时间放空或做喜欢的事，有助于长期稳定。',
          emoji: '😌',
          severity: AssessmentSeverity.low,
        ),
        AssessmentBand(
          maxScore: 12,
          title: '有些压力',
          summary: '工作或生活里有一些压力，但仍在可应对范围内。',
          guidance: '可以适当减负，记录压力来源和感受，帮助自己理清轻重缓急。',
          emoji: '📝',
          severity: AssessmentSeverity.mild,
        ),
        AssessmentBand(
          maxScore: 16,
          title: '压力偏大',
          summary: '压力已经比较明显，身体和情绪都在发出信号。',
          guidance: '建议主动减负：少接新事、多休息，把标准稍微放宽。若持续紧绷，考虑进一步筛查或寻求专业支持。',
          emoji: '🌧',
          severity: AssessmentSeverity.moderate,
        ),
        AssessmentBand(
          maxScore: 20,
          title: '需要减压',
          summary: '压力较大，需要先停下来照顾自己。',
          guidance: '先优先休息和稳定节奏，再决定下一步。若长时间难以恢复，建议进一步筛查或寻求专业帮助。',
          emoji: '🤗',
          severity: AssessmentSeverity.elevated,
          recommendProfessionalSupport: true,
        ),
      ],
    ),
    MentalAssessmentDefinition(
      id: 'sleep_checkin',
      name: '睡眠质量小测',
      shortDescription: '简单看看睡眠状况',
      emoji: '🌙',
      intro: '这是一个轻量自测，用来快速回看最近的睡眠状态。',
      durationLabel: '约 1 分钟',
      category: AssessmentCategory.selfReflection,
      periodLabel: '最近几天',
      questions: [
        _reflectionQuestion(
          id: 'sleep_q1',
          prompt: '最近入睡要多久？',
          labels: ['很快，十几分钟', '半小时内', '经常超过 1 小时', '很难入睡'],
        ),
        _reflectionQuestion(
          id: 'sleep_q2',
          prompt: '一觉能睡几小时？',
          labels: ['7～8 小时或更多', '6～7 小时', '5～6 小时', '不足 5 小时'],
        ),
        _reflectionQuestion(
          id: 'sleep_q3',
          prompt: '半夜会醒吗？',
          labels: ['几乎不醒', '偶尔醒', '经常醒', '醒很多次'],
        ),
        _reflectionQuestion(
          id: 'sleep_q4',
          prompt: '早上起来的感觉？',
          labels: ['精神不错', '还行', '有点困', '很累'],
        ),
        _reflectionQuestion(
          id: 'sleep_q5',
          prompt: '白天会犯困吗？',
          labels: ['不会', '偶尔', '经常', '一直想睡'],
        ),
      ],
      bands: const [
        AssessmentBand(
          maxScore: 8,
          title: '睡眠不错',
          summary: '近期睡眠质量尚可，作息相对稳定。',
          guidance: '保持现有作息，睡前尽量少看手机电脑，避免让大脑再次兴奋起来。',
          emoji: '🌿',
          severity: AssessmentSeverity.low,
        ),
        AssessmentBand(
          maxScore: 12,
          title: '睡眠一般',
          summary: '睡眠有些波动，可以通过一些小习惯来改善。',
          guidance: '尽量固定睡觉和起床时间，睡前做几轮深呼吸或简单拉伸，并记录当天心情和睡眠好坏。',
          emoji: '🍃',
          severity: AssessmentSeverity.mild,
        ),
        AssessmentBand(
          maxScore: 16,
          title: '睡眠不太好',
          summary: '睡眠已经受到明显影响，值得认真对待。',
          guidance: '优先改善作息和刺激控制。如果长期睡不好并影响白天状态，建议考虑和医生或专业人士聊一聊。',
          emoji: '🌙',
          severity: AssessmentSeverity.moderate,
          recommendProfessionalSupport: true,
        ),
        AssessmentBand(
          maxScore: 20,
          title: '需要重视睡眠',
          summary: '睡眠问题较明显，建议主动调整并在必要时寻求支持。',
          guidance: '先把睡眠恢复放到高优先级。若持续难以改善，建议尽快联系医生或心理/睡眠相关专业人士。',
          emoji: '🤗',
          severity: AssessmentSeverity.elevated,
          recommendProfessionalSupport: true,
        ),
      ],
    ),
    MentalAssessmentDefinition(
      id: 'anxiety_checkin',
      name: '焦虑程度自测',
      shortDescription: '了解最近的焦虑与烦躁',
      emoji: '🫧',
      intro: '这是一个轻量自测，适合快速回看最近的紧张、烦躁和回避倾向。',
      durationLabel: '约 1 分钟',
      category: AssessmentCategory.selfReflection,
      periodLabel: '最近几天',
      questions: [
        _reflectionQuestion(
          id: 'anxiety_q1',
          prompt: '担心的事多吗？',
          labels: ['很少', '偶尔想想', '挺多的', '一直在想'],
        ),
        _reflectionQuestion(
          id: 'anxiety_q2',
          prompt: '能专注做一件事吗？',
          labels: ['可以', '大部分时候能', '经常走神', '很难专注'],
        ),
        _reflectionQuestion(
          id: 'anxiety_q3',
          prompt: '容易烦躁、发火吗？',
          labels: ['很少', '偶尔', '经常', '一点就着'],
        ),
        _reflectionQuestion(
          id: 'anxiety_q4',
          prompt: '有没有心慌、胸闷、喘不上气？',
          labels: ['没有', '偶尔', '有时', '经常'],
        ),
        _reflectionQuestion(
          id: 'anxiety_q5',
          prompt: '会回避某些事或场合吗？',
          labels: ['不会', '偶尔', '会回避一些', '很多都想回避'],
        ),
      ],
      bands: const [
        AssessmentBand(
          maxScore: 8,
          title: '焦虑程度低',
          summary: '当前没有看到明显的焦虑负担。',
          guidance: '保持现状，继续记录和觉察就好。',
          emoji: '😊',
          severity: AssessmentSeverity.low,
        ),
        AssessmentBand(
          maxScore: 12,
          title: '有些焦虑',
          summary: '最近可能有些担心、烦躁或不容易放松。',
          guidance: '可以多休息、少想太远的事，给自己安排固定的放松和记录时间。',
          emoji: '🍃',
          severity: AssessmentSeverity.mild,
        ),
        AssessmentBand(
          maxScore: 16,
          title: '焦虑偏明显',
          summary: '焦虑已经比较明显，需要更认真地照顾自己。',
          guidance: '建议减少高压输入，增加可预期的作息和支持。如果这样的状态持续不退，建议进一步做 GAD-7 或寻求专业支持。',
          emoji: '🫧',
          severity: AssessmentSeverity.moderate,
          recommendProfessionalSupport: true,
        ),
        AssessmentBand(
          maxScore: 20,
          title: '需要关照',
          summary: '当前焦虑和烦躁感较重，先别再让自己硬扛。',
          guidance: '先让自己缓下来，必要时和信任的人说说，并考虑尽快寻求专业帮助。',
          emoji: '🤗',
          severity: AssessmentSeverity.elevated,
          recommendProfessionalSupport: true,
        ),
      ],
    ),
  ];

  static List<MentalAssessmentDefinition> get standardizedScreeners => all
      .where(
        (assessment) =>
            assessment.category == AssessmentCategory.standardizedScreener,
      )
      .toList();

  static List<MentalAssessmentDefinition> get selfReflectionAssessments => all
      .where(
        (assessment) =>
            assessment.category == AssessmentCategory.selfReflection &&
            !assessment.id.startsWith('sbti_') &&
            !assessment.id.startsWith('mbti_'),
      )
      .toList();

  static List<MentalAssessmentDefinition> get personalityAssessments =>
      all
          .where(
            (assessment) =>
                assessment.id.startsWith('sbti_') ||
                assessment.id.startsWith('mbti_'),
          )
          .toList()
        ..sort((a, b) {
          const order = <String, int>{
            'mbti_advanced_93': 0,
            'mbti_full_60': 1,
            'mbti_personality_compass': 2,
            'mbti_pro_200': 3,
            'sbti_style_compass': 4,
          };
          final left = order[a.id] ?? 999;
          final right = order[b.id] ?? 999;
          if (left != right) return left.compareTo(right);
          return a.name.compareTo(b.name);
        });

  static MentalAssessmentDefinition? findById(String id) {
    for (final assessment in all) {
      if (assessment.id == id) return assessment;
    }
    return null;
  }

  static AssessmentQuestion _reflectionQuestion({
    required String id,
    required String prompt,
    required List<String> labels,
  }) {
    return AssessmentQuestion(
      id: id,
      prompt: prompt,
      options: List<AssessmentOption>.generate(
        labels.length,
        (index) => AssessmentOption(label: labels[index], score: index + 1),
      ),
    );
  }
}
