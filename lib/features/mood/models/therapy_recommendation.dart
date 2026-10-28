enum TherapyApproach {
  cbt,
  act,
  dbt,
  behavioralActivation,
  sleepStabilization,
  interpersonalSupport,
}

extension TherapyApproachX on TherapyApproach {
  String get label {
    switch (this) {
      case TherapyApproach.cbt:
        return '认知行为治疗';
      case TherapyApproach.act:
        return '接纳承诺取向';
      case TherapyApproach.dbt:
        return '辩证行为治疗';
      case TherapyApproach.behavioralActivation:
        return '行为激活';
      case TherapyApproach.sleepStabilization:
        return '睡眠稳定化';
      case TherapyApproach.interpersonalSupport:
        return '人际支持取向';
    }
  }

  String get shortLabel {
    switch (this) {
      case TherapyApproach.cbt:
        return '认知调整';
      case TherapyApproach.act:
        return '接纳练习';
      case TherapyApproach.dbt:
        return '情绪调节';
      case TherapyApproach.behavioralActivation:
        return '行为激活';
      case TherapyApproach.sleepStabilization:
        return '睡眠稳定';
      case TherapyApproach.interpersonalSupport:
        return '人际支持';
    }
  }

  String get summary {
    switch (this) {
      case TherapyApproach.cbt:
        return '适合反复担心、自责、灾难化或负性自动想法明显的时候，核心是识别“想法-情绪-行为”之间的连锁反应。';
      case TherapyApproach.act:
        return '适合脑子停不下来、越想控制情绪越被情绪拖住的时候，核心是先允许体验存在，再把行动拉回到当下。';
      case TherapyApproach.dbt:
        return '适合情绪峰值高、冲动强、关系拉扯明显或需要先稳住安全风险的时候，核心是情绪调节与痛苦耐受。';
      case TherapyApproach.behavioralActivation:
        return '适合动力低、回避增多、什么都不想做的时候，核心是先恢复行动和节律，再等待情绪慢慢跟上。';
      case TherapyApproach.sleepStabilization:
        return '适合作息被焦虑或低落打乱、入睡困难或醒后恢复差的时候，核心是先稳住昼夜节律和睡前刺激。';
      case TherapyApproach.interpersonalSupport:
        return '适合状态变化已经明显影响到关系、支持系统或角色压力的时候，核心是把支持重新带回现实生活。';
    }
  }

  String get firstStep {
    switch (this) {
      case TherapyApproach.cbt:
        return '先记录一条最常出现的念头，并写下支持它和不支持它的证据。';
      case TherapyApproach.act:
        return '先给此刻的情绪命名，再做一件 10 分钟以内、对你重要的小事。';
      case TherapyApproach.dbt:
        return '先把自己从高刺激场景里挪开，做冷水洗脸、慢呼吸或联系一个可信任的人。';
      case TherapyApproach.behavioralActivation:
        return '先安排一件最小可执行的事，比如洗澡、下楼走 10 分钟或吃一顿正餐。';
      case TherapyApproach.sleepStabilization:
        return '先固定明天起床时间，今晚把手机和强刺激内容往后撤 30 分钟。';
      case TherapyApproach.interpersonalSupport:
        return '先告诉一个现实中的人：我最近状态不太好，想让你知道并请你留意我。';
    }
  }

  String get askForSupport {
    switch (this) {
      case TherapyApproach.cbt:
        return '我最近容易陷进反复担心和负面想法里，想找人帮我梳理这些思路。';
      case TherapyApproach.act:
        return '我最近很难和情绪共处，想练习在难受的时候不被它完全带走。';
      case TherapyApproach.dbt:
        return '我最近情绪起伏很大，想先学一些快速稳住自己的方法。';
      case TherapyApproach.behavioralActivation:
        return '我最近动力很低，想从恢复行动、作息和节奏开始。';
      case TherapyApproach.sleepStabilization:
        return '我最近睡眠和节律被打乱了，想先从睡眠稳定和恢复体力开始。';
      case TherapyApproach.interpersonalSupport:
        return '我最近的状态已经影响到关系和支持感，想先处理现实里的连接和压力。';
    }
  }
}

class TherapyRecommendation {
  final TherapyApproach approach;
  final String rationale;
  final int priority;
  final bool emphasizeProfessionalSupport;

  const TherapyRecommendation({
    required this.approach,
    required this.rationale,
    required this.priority,
    this.emphasizeProfessionalSupport = false,
  });
}

enum HealingActionType { breathing, supportPlan, supportPage }

class HealingNextStep {
  final HealingActionType type;
  final String title;
  final String description;
  final String buttonLabel;

  const HealingNextStep({
    required this.type,
    required this.title,
    required this.description,
    required this.buttonLabel,
  });
}
