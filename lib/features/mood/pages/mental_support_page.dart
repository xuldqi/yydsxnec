import 'package:flutter/material.dart';
import '../emoon_entry.dart';
import '../theme/app_theme.dart';


import '../models/mental_assessment.dart';
import '../models/therapy_recommendation.dart';
import '../services/database_service.dart';
import '../services/therapy_recommendation_service.dart';
import 'breathing_exercise_page.dart';

const int kSupportPlanTotalTasks = 21;

class MentalSupportPage extends StatelessWidget {
  final AssessmentResult result;

  const MentalSupportPage({super.key, required this.result});

  bool get _isUrgent => result.urgentSafetyReview;

  @override
  Widget build(BuildContext context) {
    final therapyRecommendations =
        TherapyRecommendationService.recommendationsFor(result);
    final actionColor = _isUrgent
        ? const Color(0xFFC64D42)
        : const Color(0xFF9E7B4F);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        title: Text(_isUrgent ? '安全支持' : '求助与支持'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.pageHorizontalPadding,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: actionColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: actionColor.withValues(alpha: 0.16),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isUrgent ? '先保证自己不独处' : '先让支持进入你的现实生活',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: actionColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _isUrgent
                          ? '如果你已经觉得自己不安全，先不要继续一个人撑着。比起把事情想清楚，现在更重要的是让人和支持来到你身边。'
                          : '如果这次评测结果已经影响到你的睡眠、工作、学习或关系，单靠自己硬扛通常不划算。让一个现实中的人知道你最近状态不好，会比单独消化更有效。',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textPrimary,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _SupportSection(
                title: _isUrgent ? '现在先做这 3 件事' : '接下来优先做这 3 件事',
                children: _isUrgent
                    ? const [
                        _SupportBullet(
                          title: '联系一个现实中的人',
                          body: '给家人、伴侣、朋友或同事发一句明确的话，例如：我现在状态不安全，想请你现在陪我一下。',
                        ),
                        _SupportBullet(
                          title: '离开独处环境',
                          body: '尽量去有人在的地方，或让可信任的人来你身边。不要把自己留在封闭、无人照应的状态里。',
                        ),
                        _SupportBullet(
                          title: '去医院或联系当地紧急援助',
                          body:
                              '如果你已经担心自己会做出伤害自己的事，请立刻前往医院急诊，或联系当地急救电话与危机支持资源。',
                        ),
                      ]
                    : const [
                        _SupportBullet(
                          title: '告诉一个可信任的人',
                          body: '不用讲很完整，只要说：我最近状态不太好，想请你这几天多留意我一下。',
                        ),
                        _SupportBullet(
                          title: '预约专业支持',
                          body: '可以考虑心理咨询师、精神科/身心科医生，或你所在地区可获得的心理援助服务。',
                        ),
                        _SupportBullet(
                          title: '把节奏先降下来',
                          body: '先保证睡眠、吃饭和基本起居，把这几天的目标缩到最小，不必按平时标准要求自己。',
                        ),
                      ],
              ),
              const SizedBox(height: 20),
              _SupportSection(
                title: '求助时可以直接这样说',
                children: [
                  _QuoteCard(
                    text: _isUrgent
                        ? '我现在状态不太安全，担心自己撑不住，想请你现在陪我，或者陪我去医院。'
                        : '我最近两周状态明显变差，睡眠和情绪都受影响了，想找你聊聊，也想让你知道我现在不太好。',
                  ),
                  _QuoteCard(text: '我刚做了一个心理筛查，结果提示我需要认真关注，想尽快找专业人士评估一下。'),
                ],
              ),
              const SizedBox(height: 20),
              if (therapyRecommendations.isNotEmpty) ...[
                _SupportSection(
                  title: '如果你准备找专业支持，可优先问这些方向',
                  children: therapyRecommendations
                      .map(_buildTherapyCard)
                      .toList(),
                ),
                const SizedBox(height: 20),
              ],
              _SupportSection(
                title: '去求助时建议准备的信息',
                children: const [
                  _SupportBullet(title: '症状持续多久', body: '例如：最近两周、一个月，还是更久。'),
                  _SupportBullet(
                    title: '具体影响了什么',
                    body: '比如睡眠、精力、专注、食欲、工作学习、人际关系。',
                  ),
                  _SupportBullet(
                    title: '最近有没有明显风险信号',
                    body: '如持续失眠、无法正常工作、明显回避社交，或出现伤害自己的想法。',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _SupportSection(
                title: '在正式求助前，先稳住自己',
                children: [
                  _ActionCard(
                    title: '去做 5 分钟呼吸练习',
                    body: '先把身体的紧绷和心跳压下来，让大脑从失控边缘退回一点。',
                    buttonLabel: '开始呼吸练习',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const BreathingExercisePage(),
                        ),
                      );
                    },
                  ),
                  _ActionCard(
                    title: '开始 7 天支持计划',
                    body: '这不是治疗，而是先把作息、支持和自我照顾重新建立起来。',
                    buttonLabel: '打开 7 天计划',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              SevenDaySupportPlanPage(result: result),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTherapyCard(TherapyRecommendation recommendation) {
    final approach = recommendation.approach;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              approach.shortLabel,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            approach.label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            recommendation.rationale,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.textPrimary,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '可以这样表达：${approach.askForSupport}',
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class SevenDaySupportPlanPage extends StatefulWidget {
  final AssessmentResult result;

  const SevenDaySupportPlanPage({super.key, required this.result});

  @override
  State<SevenDaySupportPlanPage> createState() =>
      _SevenDaySupportPlanPageState();
}

class _SevenDaySupportPlanPageState extends State<SevenDaySupportPlanPage> {
  final DatabaseService _dbService = DatabaseService();
  Map<String, bool> _progress = {};
  bool _loading = true;

  String get _storageKey =>
      'support_plan_progress_${widget.result.assessmentId}_${widget.result.createdAt.millisecondsSinceEpoch}';

  List<_SupportPlanDay> get _planDays =>
      _SupportPlanFactory.build(widget.result);

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final raw = await _dbService.getData(_storageKey);
    final progress = <String, bool>{};
    if (raw is Map) {
      raw.forEach((key, value) {
        progress[key.toString()] = value == true;
      });
    }

    if (!mounted) return;
    setState(() {
      _progress = progress;
      _loading = false;
    });
  }

  Future<void> _toggle(String taskId, bool checked) async {
    final next = Map<String, bool>.from(_progress)..[taskId] = checked;
    setState(() {
      _progress = next;
    });
    await _dbService.saveData(_storageKey, next);
  }

  @override
  Widget build(BuildContext context) {
    final totalTasks = _planDays.fold<int>(
      0,
      (sum, day) => sum + day.tasks.length,
    );
    final completedTasks = _progress.values.where((done) => done).length;
    final percent = totalTasks == 0 ? 0.0 : completedTasks / totalTasks;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        title: const Text('7 天支持计划'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _SupportPlanFactory.titleFor(widget.result),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '一天做 2 到 3 项就够了。目标不是完美执行，而是重新建立一点点稳定感和支持感。',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.textSecondary,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 16),
                        LinearProgressIndicator(
                          value: percent,
                          backgroundColor: AppTheme.surfaceColor,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppTheme.primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(999),
                          minHeight: 10,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '已完成 $completedTasks / $totalTasks 项',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.textHint,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ..._planDays.asMap().entries.map((entry) {
                    final index = entry.key;
                    final day = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '第 ${index + 1} 天 · ${day.title}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              day.focus,
                              style: TextStyle(
                                fontSize: 13,
                                color: AppTheme.textSecondary,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...day.tasks.map((task) {
                              final checked = _progress[task.id] == true;
                              return CheckboxListTile(
                                value: checked,
                                contentPadding: EdgeInsets.zero,
                                activeColor: AppTheme.primaryColor,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                title: Text(
                                  task.title,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.textPrimary,
                                    decoration: checked
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                                subtitle: Text(
                                  task.detail,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.textSecondary,
                                    height: 1.5,
                                  ),
                                ),
                                onChanged: (value) {
                                  _toggle(task.id, value == true);
                                },
                              );
                            }),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              MentalSupportPage(result: widget.result),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                      side: BorderSide(color: AppTheme.primaryColor),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('查看求助与支持'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => EmotionTestPage(
                            initialAssessmentId: widget.result.assessmentId,
                          ),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                      side: BorderSide(color: AppTheme.primaryColor),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      widget.result.isStandardized ? '重新做本次筛查' : '重新做这个评测',
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }
}

class _SupportPlanFactory {
  static String titleFor(AssessmentResult result) {
    if (result.assessmentId.startsWith('phq')) {
      return '7 天情绪回稳计划';
    }
    if (result.assessmentId.startsWith('gad')) {
      return '7 天减压稳住计划';
    }
    return '7 天稳定支持计划';
  }

  static List<_SupportPlanDay> build(AssessmentResult result) {
    if (result.assessmentId.startsWith('phq')) {
      return _depressionPlan();
    }
    if (result.assessmentId.startsWith('gad')) {
      return _anxietyPlan();
    }
    return _generalPlan();
  }

  static List<_SupportPlanDay> _generalPlan() {
    return const [
      _SupportPlanDay(
        title: '先稳住身体',
        focus: '把睡眠、吃饭、喝水和呼吸先拉回一点稳定。',
        tasks: [
          _SupportPlanTask(
            id: 'general_d1_t1',
            title: '今天尽量按时吃一顿正餐',
            detail: '不用追求完美饮食，只要让身体收到一点稳定信号。',
          ),
          _SupportPlanTask(
            id: 'general_d1_t2',
            title: '做 5 分钟缓慢呼吸',
            detail: '目标只是让身体从紧绷状态退出一点点。',
          ),
          _SupportPlanTask(
            id: 'general_d1_t3',
            title: '今晚尽量提前 30 分钟放下手机',
            detail: '先让睡前刺激少一点。',
          ),
        ],
      ),
      _SupportPlanDay(
        title: '减少过载',
        focus: '先删掉一点点压力，而不是继续往上加。',
        tasks: [
          _SupportPlanTask(
            id: 'general_d2_t1',
            title: '推迟一件不必要的事',
            detail: '给自己腾出一点恢复空间。',
          ),
          _SupportPlanTask(
            id: 'general_d2_t2',
            title: '把最担心的 3 件事写下来',
            detail: '让脑子里的混乱落到纸面。',
          ),
          _SupportPlanTask(
            id: 'general_d2_t3',
            title: '减少 30 分钟无目的刷屏',
            detail: '给大脑少一点噪音输入。',
          ),
        ],
      ),
      _SupportPlanDay(
        title: '恢复连接',
        focus: '让支持进入现实，而不是只停留在脑子里。',
        tasks: [
          _SupportPlanTask(
            id: 'general_d3_t1',
            title: '发消息给一个可信任的人',
            detail: '哪怕只发一句“我最近状态不太好”。',
          ),
          _SupportPlanTask(
            id: 'general_d3_t2',
            title: '和一个人说 5 分钟近况',
            detail: '不用解释完整，只讲现在的状态。',
          ),
          _SupportPlanTask(
            id: 'general_d3_t3',
            title: '记录今天最想被理解的一件事',
            detail: '帮助自己更清楚地表达需要。',
          ),
        ],
      ),
      _SupportPlanDay(
        title: '让身体动起来',
        focus: '一点点活动比完全停住更能帮助情绪回稳。',
        tasks: [
          _SupportPlanTask(
            id: 'general_d4_t1',
            title: '步行或拉伸 10 分钟',
            detail: '强度不重要，关键是开始动。',
          ),
          _SupportPlanTask(
            id: 'general_d4_t2',
            title: '晒到一点自然光',
            detail: '白天的光照会帮助睡眠和精神节律。',
          ),
          _SupportPlanTask(
            id: 'general_d4_t3',
            title: '喝一杯水后再做下一件事',
            detail: '借一个简单动作把自己带回当下。',
          ),
        ],
      ),
      _SupportPlanDay(
        title: '整理思绪',
        focus: '分清楚什么能做，什么先不用现在解决。',
        tasks: [
          _SupportPlanTask(
            id: 'general_d5_t1',
            title: '写下 1 件今天能做的小事',
            detail: '越小越好，比如洗澡、回一条消息、收桌面。',
          ),
          _SupportPlanTask(
            id: 'general_d5_t2',
            title: '把 1 件暂时做不了的事标记为“以后再处理”',
            detail: '先把它从今天挪开。',
          ),
          _SupportPlanTask(
            id: 'general_d5_t3',
            title: '记录今天情绪最重的时间点',
            detail: '为后续复测和求助留一点线索。',
          ),
        ],
      ),
      _SupportPlanDay(
        title: '补充恢复',
        focus: '允许自己有一点无功利的恢复。',
        tasks: [
          _SupportPlanTask(
            id: 'general_d6_t1',
            title: '做一件 10 分钟的舒缓活动',
            detail: '比如洗热水澡、听轻音乐、晒太阳。',
          ),
          _SupportPlanTask(
            id: 'general_d6_t2',
            title: '少做一件额外消耗你的事',
            detail: '恢复本身也是安排。',
          ),
          _SupportPlanTask(
            id: 'general_d6_t3',
            title: '写下今天稍微好一点的时刻',
            detail: '哪怕只有 1 分钟也算。',
          ),
        ],
      ),
      _SupportPlanDay(
        title: '回看变化',
        focus: '不是评判自己，而是判断还需要什么支持。',
        tasks: [
          _SupportPlanTask(
            id: 'general_d7_t1',
            title: '回看这一周完成了哪些事',
            detail: '哪怕只完成了几项，也说明你没有停在原地。',
          ),
          _SupportPlanTask(
            id: 'general_d7_t2',
            title: '重新做一次筛查或记录一次心情',
            detail: '看看状态有没有一点变化。',
          ),
          _SupportPlanTask(
            id: 'general_d7_t3',
            title: '决定下一步是继续计划还是寻求更多支持',
            detail: '如果状态没有缓解，就把求助提上日程。',
          ),
        ],
      ),
    ];
  }

  static List<_SupportPlanDay> _depressionPlan() {
    return const [
      _SupportPlanDay(
        title: '先照顾最基本的部分',
        focus: '低落时先保证吃饭、睡觉和起床，不先要求效率。',
        tasks: [
          _SupportPlanTask(
            id: 'phq_d1_t1',
            title: '今天按时吃一顿热的食物',
            detail: '先把身体维持住。',
          ),
          _SupportPlanTask(
            id: 'phq_d1_t2',
            title: '给自己定一个最晚起床时间',
            detail: '先把昼夜节律稳一点。',
          ),
          _SupportPlanTask(
            id: 'phq_d1_t3',
            title: '做 5 分钟呼吸或安静坐着',
            detail: '不是解决问题，只是先不继续下坠。',
          ),
        ],
      ),
      _SupportPlanDay(
        title: '把任务缩小',
        focus: '低落时最有效的不是拼命，而是把行动拆小。',
        tasks: [
          _SupportPlanTask(
            id: 'phq_d2_t1',
            title: '只做一件 5 分钟能完成的小事',
            detail: '比如洗脸、整理床铺、回复一条消息。',
          ),
          _SupportPlanTask(
            id: 'phq_d2_t2',
            title: '把今天“必须完成”的标准下调一点',
            detail: '恢复比完美更重要。',
          ),
          _SupportPlanTask(
            id: 'phq_d2_t3',
            title: '完成后写一句“我已经做了一点”',
            detail: '帮助自己看到行动。',
          ),
        ],
      ),
      _SupportPlanDay(
        title: '重新接回现实连接',
        focus: '低落时容易断联，但连接本身就是支持。',
        tasks: [
          _SupportPlanTask(
            id: 'phq_d3_t1',
            title: '给一个人发一句近况',
            detail: '可以只说“我最近状态不太好”。',
          ),
          _SupportPlanTask(
            id: 'phq_d3_t2',
            title: '和一个人有 5 分钟对话',
            detail: '不用表现正常。',
          ),
          _SupportPlanTask(
            id: 'phq_d3_t3',
            title: '把需要的帮助写具体',
            detail: '比如陪我去看医生、提醒我吃饭、和我散步。',
          ),
        ],
      ),
      _SupportPlanDay(
        title: '做一点点行为激活',
        focus: '先动一点点，情绪不一定立刻变好，但身体会先动起来。',
        tasks: [
          _SupportPlanTask(
            id: 'phq_d4_t1',
            title: '出门走 10 分钟',
            detail: '慢慢走也可以。',
          ),
          _SupportPlanTask(
            id: 'phq_d4_t2',
            title: '晒到一点白天的光',
            detail: '自然光对节律和精神状态有帮助。',
          ),
          _SupportPlanTask(
            id: 'phq_d4_t3',
            title: '做一个最简单的家务动作',
            detail: '哪怕只是清掉桌上的一个角落。',
          ),
        ],
      ),
      _SupportPlanDay(
        title: '减少自责',
        focus: '把“我不行”先换成更准确的描述。',
        tasks: [
          _SupportPlanTask(
            id: 'phq_d5_t1',
            title: '写下一个今天很难的事实',
            detail: '例如：我最近确实很累，而不是我太差。',
          ),
          _SupportPlanTask(
            id: 'phq_d5_t2',
            title: '停止和状态好的时候比较 1 次',
            detail: '先回到当下条件下。',
          ),
          _SupportPlanTask(
            id: 'phq_d5_t3',
            title: '给自己一句现实的善意话',
            detail: '比如：我现在不好，但我在处理。',
          ),
        ],
      ),
      _SupportPlanDay(
        title: '增加一点可感受的愉快',
        focus: '不是强迫开心，而是恢复一点点感受能力。',
        tasks: [
          _SupportPlanTask(
            id: 'phq_d6_t1',
            title: '做一件以前还算喜欢的小事',
            detail: '时间不用长，10 分钟就够。',
          ),
          _SupportPlanTask(
            id: 'phq_d6_t2',
            title: '喝一杯喜欢的饮品或吃一点喜欢的食物',
            detail: '给身体一点积极体验。',
          ),
          _SupportPlanTask(
            id: 'phq_d6_t3',
            title: '记录今天稍微没那么糟的一刻',
            detail: '哪怕只是 30 秒。',
          ),
        ],
      ),
      _SupportPlanDay(
        title: '决定下一步支持',
        focus: '低落持续存在时，下一步不该只是继续忍。',
        tasks: [
          _SupportPlanTask(
            id: 'phq_d7_t1',
            title: '回看这周最低落的时间点',
            detail: '看看有没有规律。',
          ),
          _SupportPlanTask(
            id: 'phq_d7_t2',
            title: '重新做一次 PHQ 或记录心情',
            detail: '帮助判断变化。',
          ),
          _SupportPlanTask(
            id: 'phq_d7_t3',
            title: '决定是否预约专业帮助',
            detail: '如果还是明显影响生活，就不要继续拖。',
          ),
        ],
      ),
    ];
  }

  static List<_SupportPlanDay> _anxietyPlan() {
    return const [
      _SupportPlanDay(
        title: '先把身体降下来',
        focus: '焦虑先从身体退一点，大脑才更容易恢复判断。',
        tasks: [
          _SupportPlanTask(
            id: 'gad_d1_t1',
            title: '做 5 分钟缓慢呼吸',
            detail: '先降低心跳和紧绷。',
          ),
          _SupportPlanTask(
            id: 'gad_d1_t2',
            title: '喝水并把双脚踩实地面 1 分钟',
            detail: '让注意力回到身体。',
          ),
          _SupportPlanTask(
            id: 'gad_d1_t3',
            title: '今晚少看 30 分钟刺激性信息',
            detail: '先把输入量降下来。',
          ),
        ],
      ),
      _SupportPlanDay(
        title: '把担忧外化',
        focus: '不让所有担忧都在脑子里循环。',
        tasks: [
          _SupportPlanTask(
            id: 'gad_d2_t1',
            title: '把最担心的 3 件事写下来',
            detail: '只是写，不急着解决。',
          ),
          _SupportPlanTask(
            id: 'gad_d2_t2',
            title: '标记哪件事今天能做一步',
            detail: '只选一件。',
          ),
          _SupportPlanTask(
            id: 'gad_d2_t3',
            title: '给自己设一个 10 分钟“担忧时间”',
            detail: '超过时间先停。',
          ),
        ],
      ),
      _SupportPlanDay(
        title: '减少回避',
        focus: '焦虑会让人想逃，但完全回避会把担心养大。',
        tasks: [
          _SupportPlanTask(
            id: 'gad_d3_t1',
            title: '面对一个最小的回避项',
            detail: '例如回一条消息、打开文件、出门 5 分钟。',
          ),
          _SupportPlanTask(
            id: 'gad_d3_t2',
            title: '做完后记录身体感觉有没有变化',
            detail: '不是为了完美，只是观察。',
          ),
          _SupportPlanTask(
            id: 'gad_d3_t3',
            title: '允许自己只完成 60 分',
            detail: '先动比做满更重要。',
          ),
        ],
      ),
      _SupportPlanDay(
        title: '建立可预期感',
        focus: '可预期会降低焦虑的失控感。',
        tasks: [
          _SupportPlanTask(
            id: 'gad_d4_t1',
            title: '写一个今天的简单顺序表',
            detail: '比如吃饭、洗澡、工作 30 分钟、散步。',
          ),
          _SupportPlanTask(
            id: 'gad_d4_t2',
            title: '固定一个睡前放松动作',
            detail: '如热水澡、拉伸或呼吸。',
          ),
          _SupportPlanTask(
            id: 'gad_d4_t3',
            title: '给自己留出 20 分钟无任务时间',
            detail: '让大脑知道今天不是无穷无尽。',
          ),
        ],
      ),
      _SupportPlanDay(
        title: '恢复现实支持',
        focus: '把焦虑说出来，比独自脑补更能减压。',
        tasks: [
          _SupportPlanTask(
            id: 'gad_d5_t1',
            title: '告诉一个人你最近比较焦虑',
            detail: '不必讲完整，只说明状态。',
          ),
          _SupportPlanTask(
            id: 'gad_d5_t2',
            title: '请对方给你一个具体帮助',
            detail: '比如陪你散步、提醒你吃饭、听你说 10 分钟。',
          ),
          _SupportPlanTask(
            id: 'gad_d5_t3',
            title: '记录说出来后身体有没有轻一点',
            detail: '把变化看见。',
          ),
        ],
      ),
      _SupportPlanDay(
        title: '训练回到当下',
        focus: '焦虑爱往未来跑，先把自己带回现在。',
        tasks: [
          _SupportPlanTask(
            id: 'gad_d6_t1',
            title: '做一次 5-4-3-2-1 grounding',
            detail: '看见 5 样东西，触摸 4 样，依次往下。',
          ),
          _SupportPlanTask(
            id: 'gad_d6_t2',
            title: '走 10 分钟并观察周围环境',
            detail: '把注意力放到外部现实。',
          ),
          _SupportPlanTask(
            id: 'gad_d6_t3',
            title: '睡前写下“明天再处理”的事',
            detail: '不要在床上继续想。',
          ),
        ],
      ),
      _SupportPlanDay(
        title: '判断是否需要更多支持',
        focus: '如果焦虑没有退下去，下一步应该更明确。',
        tasks: [
          _SupportPlanTask(
            id: 'gad_d7_t1',
            title: '回看这周最容易触发焦虑的场景',
            detail: '整理模式而不是责怪自己。',
          ),
          _SupportPlanTask(
            id: 'gad_d7_t2',
            title: '重新做一次 GAD 或记录状态',
            detail: '看看有无变化。',
          ),
          _SupportPlanTask(
            id: 'gad_d7_t3',
            title: '决定是否预约专业评估',
            detail: '如果失眠、心慌、回避还在加重，就别继续拖。',
          ),
        ],
      ),
    ];
  }
}

class _SupportPlanDay {
  final String title;
  final String focus;
  final List<_SupportPlanTask> tasks;

  const _SupportPlanDay({
    required this.title,
    required this.focus,
    required this.tasks,
  });
}

class _SupportPlanTask {
  final String id;
  final String title;
  final String detail;

  const _SupportPlanTask({
    required this.id,
    required this.title,
    required this.detail,
  });
}

class _SupportSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SupportSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }
}

class _SupportBullet extends StatelessWidget {
  final String title;
  final String body;

  const _SupportBullet({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 7),
            decoration: const BoxDecoration(
              color: AppTheme.primaryColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  body,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuoteCard extends StatelessWidget {
  final String text;

  const _QuoteCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        '“$text”',
        style: const TextStyle(
          fontSize: 14,
          color: AppTheme.textPrimary,
          height: 1.6,
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String body;
  final String buttonLabel;
  final VoidCallback onPressed;

  const _ActionCard({
    required this.title,
    required this.body,
    required this.buttonLabel,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            body,
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(buttonLabel),
            ),
          ),
        ],
      ),
    );
  }
}
