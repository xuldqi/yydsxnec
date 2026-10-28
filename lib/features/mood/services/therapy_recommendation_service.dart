import '../models/mental_assessment.dart';
import '../models/therapy_recommendation.dart';

class TherapyRecommendationService {
  static List<TherapyRecommendation> recommendationsFor(
    AssessmentResult result,
  ) {
    final assessmentId = result.assessmentId.toLowerCase();
    final severityIndex = result.severity.index;
    final items = <TherapyRecommendation>[];

    void add(
      TherapyApproach approach, {
      required String rationale,
      required int priority,
      bool emphasizeProfessionalSupport = false,
    }) {
      final existingIndex = items.indexWhere(
        (item) => item.approach == approach,
      );
      final recommendation = TherapyRecommendation(
        approach: approach,
        rationale: rationale,
        priority: priority,
        emphasizeProfessionalSupport: emphasizeProfessionalSupport,
      );
      if (existingIndex == -1) {
        items.add(recommendation);
      } else if (items[existingIndex].priority < priority) {
        items[existingIndex] = recommendation;
      }
    }

    if (assessmentId.startsWith('phq')) {
      add(
        TherapyApproach.behavioralActivation,
        rationale: '这类结果常伴随动力下降、回避增多或日常活动缩小，先恢复行动和节律通常比先逼自己想通更有效。',
        priority: 100,
        emphasizeProfessionalSupport:
            severityIndex >= AssessmentSeverity.moderate.index,
      );
      add(
        TherapyApproach.cbt,
        rationale: '如果你最近自责、无望感或负面推断很多，认知调整更适合处理这些想法对情绪和行为的影响。',
        priority: 88,
      );
      add(
        TherapyApproach.interpersonalSupport,
        rationale: '当状态已经影响到关系、支持感或角色压力时，人际支持取向能帮助你把“一个人扛着”的状态打破。',
        priority: 76,
      );
      if (severityIndex >= AssessmentSeverity.moderate.index) {
        add(
          TherapyApproach.sleepStabilization,
          rationale: '中度及以上低落往往会同时拖累睡眠和体力，先把节律稳一点，后续干预会更容易做下去。',
          priority: 72,
        );
      }
    } else if (assessmentId.startsWith('gad')) {
      add(
        TherapyApproach.cbt,
        rationale: '这类结果通常和反复担心、灾难化预期、过度警觉有关，认知调整更适合处理这些担忧循环。',
        priority: 100,
        emphasizeProfessionalSupport:
            severityIndex >= AssessmentSeverity.moderate.index,
      );
      add(
        TherapyApproach.act,
        rationale: '如果你越想压住焦虑越被它缠住，接纳练习更适合练习在焦虑存在时依然把动作拉回现实。',
        priority: 90,
      );
      add(
        TherapyApproach.dbt,
        rationale: '当焦虑峰值很高、身体反应强或容易慌乱时，情绪调节里的痛苦耐受和快速稳住技巧会更实用。',
        priority: 82,
      );
      add(
        TherapyApproach.sleepStabilization,
        rationale: '焦虑常先把睡眠和身体恢复拖乱，先稳住睡眠能降低整体唤醒水平。',
        priority: 70,
      );
    } else {
      add(
        TherapyApproach.cbt,
        rationale: '如果你最近被固定想法、反刍或自我批评困住，认知调整是最稳妥的起点。',
        priority: 92,
      );
      add(
        TherapyApproach.act,
        rationale: '如果你知道自己难受，却总想赶快摆脱它，接纳练习更适合帮助你在难受中继续生活。',
        priority: 88,
      );
      add(
        TherapyApproach.interpersonalSupport,
        rationale: '当状态已经影响到关系、支持感或现实压力时，把支持重新带回生活通常比单独消化更有效。',
        priority: 74,
      );
    }

    if (result.urgentSafetyReview) {
      add(
        TherapyApproach.dbt,
        rationale: '如果现在已经涉及安全风险，优先目标不是深度处理问题，而是先学会快速稳住、降低冲动和争取现实支持。',
        priority: 120,
        emphasizeProfessionalSupport: true,
      );
      add(
        TherapyApproach.interpersonalSupport,
        rationale: '当前最重要的是把支持带进现实，而不是继续独自承受。',
        priority: 115,
        emphasizeProfessionalSupport: true,
      );
    }

    items.sort((a, b) => b.priority.compareTo(a.priority));
    return items.take(3).toList();
  }

  static HealingNextStep nextStepFor(
    AssessmentResult result, {
    List<TherapyRecommendation>? recommendations,
  }) {
    final therapyRecommendations =
        recommendations ?? recommendationsFor(result);
    final primaryRecommendation = therapyRecommendations.isNotEmpty
        ? therapyRecommendations.first
        : null;

    if (result.urgentSafetyReview) {
      return const HealingNextStep(
        type: HealingActionType.supportPage,
        title: '现在先把安全放在第一位',
        description: '如果你已经担心自己的安全，先不要继续一个人扛着。先看安全支持，再决定后面的步骤。',
        buttonLabel: '先看安全支持',
      );
    }

    if (result.recommendProfessionalSupport) {
      return HealingNextStep(
        type: HealingActionType.supportPage,
        title: '现在先把支持带进现实生活',
        description: primaryRecommendation == null
            ? '这次结果说明你更适合先把支持带进现实，而不是继续自己硬撑。'
            : '这次结果说明你更适合先把支持带进现实，而${primaryRecommendation.approach.shortLabel}会是后续更值得优先考虑的方向。',
        buttonLabel: '先看求助与支持',
      );
    }

    if (result.severity == AssessmentSeverity.low ||
        result.severity == AssessmentSeverity.mild) {
      return HealingNextStep(
        type: HealingActionType.breathing,
        title: '可以先去放空缓一缓',
        description: primaryRecommendation == null
            ? '如果你只做一件事，先到放空里做 1 分钟呼吸，把身体从紧绷里拉回来。'
            : '如果你只做一件事，先到放空里做 1 分钟呼吸。稳一点之后，再按 ${primaryRecommendation.approach.shortLabel} 的方向往下走。',
        buttonLabel: '去放空做呼吸',
      );
    }

    return HealingNextStep(
      type: HealingActionType.supportPlan,
      title: '现在先做一个可执行的动作',
      description: primaryRecommendation == null
          ? '先从一个最小可执行的支持动作开始，比继续空想更能帮你把状态拉回来。'
          : '${primaryRecommendation.approach.shortLabel} 更贴近你这次的状态。先从一个小而具体的动作开始，比一下子想通所有事更有效。',
      buttonLabel: '先开始 7 天支持计划',
    );
  }
}
