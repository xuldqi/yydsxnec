import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../models/emotion_type.dart';
import '../services/database_service.dart';
import '../theme/app_theme.dart';

class MoodBottlePage extends StatefulWidget {
  const MoodBottlePage({super.key});

  @override
  State<MoodBottlePage> createState() => _MoodBottlePageState();
}

class _MoodBottlePageState extends State<MoodBottlePage>
    with TickerProviderStateMixin {
  static const String _drawRecordsKey = 'mood_draw_records';
  static const int _maxDrawRecords = 100;
  static const EventChannel _shakeEventChannel = EventChannel(
    'emo_new/shake_events',
  );
  static const List<String> _veryHappyWords = [
    '心动',
    '雀跃',
    '幸福',
    '甜蜜',
    '超满足',
    '被爱着',
    '惊喜',
    '兴奋',
    '狂喜',
    '欣喜',
    '喜极而泣',
    '阳光满格',
    '好运爆棚',
    '太开心了',
    '爽到飞起',
    '全是好事',
    '幸福冒泡',
    '甜到心里',
    '圆满',
    '被治愈了',
  ];

  static const List<String> _happyWords = [
    '治愈',
    '温暖',
    '安心',
    '轻松',
    '有干劲',
    '被理解',
    '有盼头',
    '期待',
    '踏实',
    '顺利',
    '满足',
    '舒坦',
    '舒服',
    '愉快',
    '有希望',
    '有力量',
    '心安',
    '温柔',
    '稳定',
    '松弛',
  ];

  static const List<String> _neutralWords = [
    '平静',
    '放空',
    '发呆',
    '慢下来',
    '一般般',
    '思考中',
    '观察中',
    '无波澜',
    '普通',
    '还行',
    '平平',
    '就那样',
    '冷静',
    '缓慢',
    '没起伏',
    '中规中矩',
    '平衡',
    '宁静',
    '安静',
    '稳定中',
  ];

  static const List<String> _sadWords = [
    '心累',
    '委屈',
    '烦躁',
    '焦虑',
    '不安',
    '孤单',
    '低落',
    '想哭',
    '失落',
    '难受',
    '疲惫',
    '泄气',
    '没劲',
    '闷闷的',
    '压着火',
    '担心',
    '慌张',
    '揪心',
    '不甘心',
    '烦闷',
  ];

  static const List<String> _verySadWords = [
    '心碎',
    '崩溃',
    '压抑',
    '无助',
    '绝望',
    '麻木',
    '内耗',
    '透不过气',
    '快撑不住',
    '情绪爆炸',
    '好痛苦',
    '窒息感',
    '彻夜难眠',
    '被掏空',
    '想逃离',
    '濒临崩盘',
    '黑压压',
    '心被压住',
    '失控边缘',
    '好想躲起来',
  ];

  static final List<_EmotionDescriptor> _emotionPool = [
    ..._veryHappyWords.map(
      (text) => _EmotionDescriptor(text, EmotionType.veryHappy),
    ),
    ..._happyWords.map((text) => _EmotionDescriptor(text, EmotionType.happy)),
    ..._neutralWords.map(
      (text) => _EmotionDescriptor(text, EmotionType.neutral),
    ),
    ..._sadWords.map((text) => _EmotionDescriptor(text, EmotionType.sad)),
    ..._verySadWords.map(
      (text) => _EmotionDescriptor(text, EmotionType.verySad),
    ),
  ];

  final math.Random _random = math.Random();
  final DatabaseService _dbService = DatabaseService();
  final List<_BubbleEntity> _bubbles = <_BubbleEntity>[];
  List<_MoodDrawResult> _drawRecords = [];
  final ValueNotifier<int> _physicsFrameTick = ValueNotifier<int>(0);

  late final Ticker _physicsTicker;
  late final AnimationController _decorController;

  Duration _lastTick = Duration.zero;
  double _simulatedTime = 0;
  double _uiFrameAccumulator = 0;
  Size _physicsSize = Size.zero;
  bool _shakeRefreshPending = false;
  double? _refreshAfterSimTime;
  StreamSubscription<dynamic>? _nativeShakeSub;
  final List<Timer> _shakeBurstTimers = <Timer>[];
  DateTime _lastButtonTapAt = DateTime.fromMillisecondsSinceEpoch(0);
  int _buttonCombo = 0;
  _PerformanceTier _performanceTier = _PerformanceTier.high;
  _PerformanceTier _devicePreferredTier = _PerformanceTier.high;
  bool _physicsCanPause = false;
  bool _physicsPaused = false;
  bool _showPerfOverlay = false;
  _DrawLiftState? _drawLiftState;
  int _uiFramesInWindow = 0;
  double _uiWindowSeconds = 0;
  double _estimatedUiFps = 0;
  double _avgStepMs = 0;
  double _peakStepMs = 0;
  double _tierPressureSeconds = 0;
  double _tierRelaxSeconds = 0;
  double _tierCooldownSeconds = 0;

  int get _targetBubbleCount => switch (_performanceTier) {
    _PerformanceTier.high => 28,
    _PerformanceTier.medium => 22,
    _PerformanceTier.low => 16,
  };

  double get _targetUiFps => switch (_performanceTier) {
    _PerformanceTier.high => 60,
    _PerformanceTier.medium => 50,
    _PerformanceTier.low => 40,
  };

  double get _collisionCellSize => switch (_performanceTier) {
    _PerformanceTier.high => 120,
    _PerformanceTier.medium => 132,
    _PerformanceTier.low => 148,
  };

  @override
  void initState() {
    super.initState();
    _decorController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _physicsTicker = createTicker(_onPhysicsTick)..start();
    _bindNativeShakeSensor();
    _loadDrawRecords();
  }

  @override
  void dispose() {
    _cancelShakeBurstTimers();
    _drawLiftState?.controller.dispose();
    _nativeShakeSub?.cancel();
    _physicsTicker.dispose();
    _decorController.dispose();
    _physicsFrameTick.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncPerformanceTier(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EA),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [const Color(0xFFE8F2E6), const Color(0xFFFBF7EC)],
            ),
          ),
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(child: _buildBottleMain()),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  void _syncPerformanceTier(BuildContext context) {
    final media = MediaQuery.maybeOf(context);
    if (media == null) return;

    final shortestSide = media.size.shortestSide;
    final dpr = media.devicePixelRatio;
    final disableAnimations = media.disableAnimations;

    final nextTier = disableAnimations
        ? _PerformanceTier.low
        : (shortestSide < 340
              ? _PerformanceTier.low
              : (shortestSide < 370 || dpr <= 2.2
                    ? _PerformanceTier.medium
                    : _PerformanceTier.high));

    _devicePreferredTier = nextTier;

    // Respect runtime fallback when it already dropped to a lighter tier.
    // Only force correction when current tier is heavier than device profile.
    if (_tierRank(_performanceTier) > _tierRank(_devicePreferredTier)) {
      _setPerformanceTier(_devicePreferredTier);
    }
  }

  Widget _buildHeader(BuildContext context) {
    final now = DateTime.now();
    final date = DateFormat('M月d日').format(now);
    final week = DateFormat('EEE', 'zh_CN').format(now);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.pageHorizontalPadding,
        22,
        AppTheme.pageHorizontalPadding,
        12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '抽一张心情片',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      date,
                      style: AppTheme.headlineSmall.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Text(
                        week,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Material(
            color: Colors.white.withAlpha(150),
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => Navigator.of(context).pop(),
              child: const SizedBox(
                width: 40,
                height: 40,
                child: Icon(
                  Icons.close_rounded,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: Colors.white.withAlpha(150),
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: _showDrawHistorySheet,
              onLongPress: kDebugMode
                  ? () => setState(() => _showPerfOverlay = !_showPerfOverlay)
                  : null,
              child: const SizedBox(
                width: 40,
                height: 40,
                child: Icon(
                  Icons.history_rounded,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottleMain() {
    return LayoutBuilder(
      builder: (context, constraints) {
        _ensurePhysicsArea(Size(constraints.maxWidth, constraints.maxHeight));

        return Stack(
          children: [
            Positioned.fill(child: Container(color: Colors.transparent)),
            const Positioned(
              top: 4,
              left: 0,
              right: 0,
              child: Center(child: _HintChip(label: '先不看名字，点一张心情片')),
            ),

            Positioned.fill(
              child: ValueListenableBuilder<int>(
                valueListenable: _physicsFrameTick,
                builder: (context, _, __) {
                  return RepaintBoundary(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        for (int i = 0; i < _bubbles.length; i++)
                          if (_bubbles[i].active) _buildBubble(i),
                      ],
                    ),
                  );
                },
              ),
            ),
            if (_drawLiftState != null)
              Positioned.fill(child: _DrawLiftOverlay(state: _drawLiftState!)),
            if (kDebugMode && _showPerfOverlay)
              Positioned(top: 44, right: 12, child: _buildPerfOverlay()),
          ],
        );
      },
    );
  }

  Widget _buildBubble(int index) {
    final bubble = _bubbles[index];
    final left = bubble.position.dx - bubble.radius * 1.14;
    final top = bubble.position.dy - bubble.radius * 0.82;

    return Positioned(
      left: left,
      top: top,
      width: bubble.radius * 2.28,
      height: bubble.radius * 1.64,
      child: GestureDetector(
        onTap: () => _onBubbleTap(index),
        child: Transform.rotate(
          angle: bubble.angle,
          child: Container(
            decoration: bubble.decoration,
            child: Center(
              child: Transform.rotate(
                angle: -bubble.angle,
                child: Text(
                  bubble.text,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: bubble.textStyle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppTheme.pageHorizontalPadding,
        10,
        AppTheme.pageHorizontalPadding,
        26,
      ),
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Column(
        children: [
          Text(
            '摇一摇换一池纸片，抽取不会写入心情记录',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8.0),
          _buildAnimatedShakeButton(),
        ],
      ),
    );
  }

  Widget _buildAnimatedShakeButton() {
    if (_performanceTier == _PerformanceTier.low) {
      return Material(
        color: Colors.white.withAlpha(150),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: _shakeBubbles,
          child: const SizedBox(
            width: 64,
            height: 64,
            child: const Icon(
              Icons.refresh_rounded,
              size: 30,
              color: AppTheme.primaryColor,
            ),
          ),
        ),
      );
    }

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _decorController,
        builder: (context, _) {
          final t = _decorController.value;
          final floatY = math.sin(t * math.pi * 2) * 5;
          final ringScale = 0.8 + t * 0.5;
          final ringOpacity = (1 - t) * 0.5;

          return Transform.translate(
            offset: Offset(0, floatY),
            child: SizedBox(
              width: 72,
              height: 72,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Transform.scale(
                    scale: ringScale,
                    child: Opacity(
                      opacity: ringOpacity,
                      child: Container(
                        width: 66,
                        height: 66,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withAlpha(160),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.white.withAlpha(150),
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: _shakeBubbles,
                      child: const SizedBox(
                        width: 64,
                        height: 64,
                        child: Icon(
                          Icons.refresh_rounded,
                          size: 30,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPerfOverlay() {
    final tierLabel = switch (_performanceTier) {
      _PerformanceTier.high => 'HIGH',
      _PerformanceTier.medium => 'MED',
      _PerformanceTier.low => 'LOW',
    };
    return IgnorePointer(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(105),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withAlpha(70)),
        ),
        child: DefaultTextStyle(
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.w700,
            height: 1.25,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tier: $tierLabel  $_targetBubbleCount bubbles'),
              Text(
                'UI: ${_estimatedUiFps.toStringAsFixed(1)} fps  '
                'step:${_avgStepMs.toStringAsFixed(1)}ms  '
                'peak:${_peakStepMs.toStringAsFixed(1)}',
              ),
              Text('State: ${_physicsPaused ? 'paused' : 'running'}'),
            ],
          ),
        ),
      ),
    );
  }

  double _bubbleFontSize(double radius, String text) {
    final ratio = text.length >= 4 ? 0.3 : 0.36;
    return (radius * ratio).clamp(12, 18).toDouble();
  }

  Future<void> _onBubbleTap(int index) async {
    if (!mounted || index < 0 || index >= _bubbles.length) return;
    final bubble = _bubbles[index];
    if (!bubble.active) return;

    HapticFeedback.mediumImpact();
    final result = _createDrawResult(
      emotion: bubble.emotionText,
      type: bubble.emotion,
    );
    final shouldAnimate =
        !(MediaQuery.maybeOf(context)?.disableAnimations ?? false) &&
        _performanceTier != _PerformanceTier.low;
    if (shouldAnimate) {
      _startDrawLiftAnimation(bubble, result);
    }

    bubble.active = false;
    _physicsFrameTick.value = (_physicsFrameTick.value + 1) & 0x3fffffff;
    _applyImpulse(
      bubble,
      x: (_random.nextDouble() - 0.5) * 260,
      y: -320 - _random.nextDouble() * 180,
    );
    await _saveDrawResult(result);

    Future.delayed(Duration(milliseconds: shouldAnimate ? 520 : 80), () {
      if (mounted) {
        _drawLiftState?.controller.dispose();
        _drawLiftState = null;
        _showDrawResultSheet(result);
      }
    });
  }

  void _startDrawLiftAnimation(_BubbleEntity bubble, _MoodDrawResult result) {
    _drawLiftState?.controller.dispose();
    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
    final startRect = Rect.fromLTWH(
      bubble.position.dx - bubble.radius * 1.14,
      bubble.position.dy - bubble.radius * 0.82,
      bubble.radius * 2.28,
      bubble.radius * 1.64,
    );
    setState(() {
      _drawLiftState = _DrawLiftState(
        controller: controller,
        startRect: startRect,
        startAngle: bubble.angle,
        decoration: bubble.decoration,
        textStyle: bubble.textStyle,
        result: result,
      );
    });
  }

  Future<void> _loadDrawRecords() async {
    final raw = await _dbService.getData(_drawRecordsKey);
    if (raw is! List) return;
    final records = raw
        .whereType<Map>()
        .map((item) => _MoodDrawResult.fromMap(Map<String, dynamic>.from(item)))
        .whereType<_MoodDrawResult>()
        .toList();
    if (!mounted) return;
    setState(() {
      _drawRecords = records;
    });
  }

  Future<void> _saveDrawResult(_MoodDrawResult result) async {
    final next = <_MoodDrawResult>[result, ..._drawRecords];
    if (next.length > _maxDrawRecords) next.length = _maxDrawRecords;
    setState(() => _drawRecords = next);
    await _dbService.saveData(
      _drawRecordsKey,
      next.map((item) => item.toMap()).toList(),
    );
  }

  _MoodDrawResult _createDrawResult({
    required String emotion,
    required EmotionType type,
  }) {
    final explanation = _pick(_explanationsFor(type));
    final message = _pick(_messagesFor(type));
    final guidance = _pick(_guidanceFor(type));
    final tone = _toneFor(type);
    return _MoodDrawResult(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      emotion: emotion,
      typeName: type.name,
      tone: tone,
      explanation: '$emotion，像是心里递来的一张提示卡。$explanation',
      message: message,
      guidance: guidance,
      createdAt: DateTime.now(),
    );
  }

  String _pick(List<String> values) => values[_random.nextInt(values.length)];

  String _toneFor(EmotionType type) {
    switch (type) {
      case EmotionType.veryHappy:
        return '高亮时刻';
      case EmotionType.happy:
        return '温柔能量';
      case EmotionType.neutral:
        return '平稳片刻';
      case EmotionType.sad:
        return '需要照看';
      case EmotionType.verySad:
        return '先停一下';
    }
  }

  List<String> _explanationsFor(EmotionType type) {
    switch (type) {
      case EmotionType.veryHappy:
        return const [
          '这说明你正在接收到很强的正向能量，可以把它当成今天的小小燃料。',
          '它不是要求你一直兴奋，而是在提醒你：此刻值得被好好记住。',
          '这份明亮感很珍贵，适合用一个简单行动把它落到现实里。',
        ];
      case EmotionType.happy:
        return const [
          '它代表你的身心正在靠近舒服的位置，今天可以允许自己轻一点。',
          '这种感觉不一定轰轰烈烈，但很适合慢慢积攒成稳定的底气。',
          '它像一口温水，提醒你有些事情正在往更顺的方向走。',
        ];
      case EmotionType.neutral:
        return const [
          '平稳也很重要，它说明你暂时不用急着给自己一个明确答案。',
          '普通的一刻不是空白，它可能是在帮你恢复观察和选择的空间。',
          '这是一种可以停靠的状态，适合少做判断，多听听身体的反馈。',
        ];
      case EmotionType.sad:
        return const [
          '这不是失败信号，只是在提醒你：有一部分感受需要被看见。',
          '它可能来得有点重，但你不需要马上解决全部，只要先照顾这一分钟。',
          '难受出现时，先别急着责备自己，把它当成身体在请求一点缓冲。',
        ];
      case EmotionType.verySad:
        return const [
          '如果这张卡很贴近你现在的状态，请先把任务放小，照顾自己比硬撑更重要。',
          '很重的感受不代表你会一直这样，它只是说明今天需要更温柔的节奏。',
          '你不需要一个人把所有情绪扛完，先给自己一点安全感，再决定下一步。',
        ];
    }
  }

  List<String> _messagesFor(EmotionType type) {
    switch (type) {
      case EmotionType.veryHappy:
        return const [
          '愿你把今天的好心情留一小份给明天。',
          '把这份光收好，它会在普通日子里继续帮你发亮。',
          '今天适合相信自己，也适合温柔地感谢自己。',
        ];
      case EmotionType.happy:
        return const [
          '愿这份松弛陪你走完今天剩下的路。',
          '不用把好状态用完，慢慢享受就很好。',
          '你正在靠近一种更安稳的自己。',
        ];
      case EmotionType.neutral:
        return const [
          '平静不是没发生什么，而是你终于有空间听见自己。',
          '今天不必特别精彩，稳稳地过也算很认真。',
          '允许普通的一天普通地过去，也是对自己的照顾。',
        ];
      case EmotionType.sad:
        return const [
          '愿你先别急着变好，先被自己温柔接住。',
          '今天可以慢一点，情绪会过去，你不用跟它硬碰硬。',
          '你已经在努力了，现在先给心里留一盏小灯。',
        ];
      case EmotionType.verySad:
        return const [
          '请先回到一个安全的小动作里，你不用立刻撑起全部。',
          '很难的时候，能停下来照顾自己，就是很重要的能力。',
          '如果今天太重，就只过好接下来的十分钟。',
        ];
    }
  }

  List<String> _guidanceFor(EmotionType type) {
    switch (type) {
      case EmotionType.veryHappy:
        return const [
          '把让你开心的原因写一句，给这份好运留个锚点。',
          '做一件 5 分钟内能完成的小事，让好状态变成真实进展。',
          '给一个重要的人发句感谢，把好心情轻轻传出去。',
        ];
      case EmotionType.happy:
        return const [
          '喝口水，伸展肩颈，把这份舒服感放进身体里。',
          '挑一件今天想做的小事，不追求完美，只追求开始。',
          '把手机放下 3 分钟，看看窗外或听一首喜欢的歌。',
        ];
      case EmotionType.neutral:
        return const [
          '问自己一句：我现在最需要的是休息、行动，还是陪伴？',
          '把今天的待办删到只剩一件最重要的，先从它开始。',
          '安静坐 1 分钟，感受脚踩在地上的重量。',
        ];
      case EmotionType.sad:
        return const [
          '先做 3 次慢呼吸，再给这份感受起一个名字。',
          '把让你难受的事写成一句话，不分析，只写下来。',
          '离开当前位置 2 分钟，喝水、洗脸，或走到窗边透口气。',
        ];
      case EmotionType.verySad:
        return const [
          '先把呼吸放慢：吸气 4 秒，呼气 6 秒，重复 5 轮。',
          '给可信任的人发一句“我现在有点难，需要你陪我一下”。',
          '暂停做决定，先吃点东西、喝水，或让身体靠在椅背上休息。',
        ];
    }
  }

  void _showDrawResultSheet(_MoodDrawResult result) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '关闭',
      barrierColor: Colors.black.withAlpha(70),
      transitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (sheetContext, _, __) {
        return _MoodDrawResultSheet(
          result: result,
          onDrawAgain: () {
            Navigator.of(sheetContext).pop();
            _shakeBubbles();
          },
        );
      },
      transitionBuilder: (context, animation, _, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: Transform.scale(
            scale: 0.96 + curved.value * 0.04,
            child: child,
          ),
        );
      },
    );
  }

  void _showDrawHistorySheet() {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return _MoodDrawHistorySheet(records: _drawRecords);
      },
    );
  }

  void _bindNativeShakeSensor() {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    _nativeShakeSub = _shakeEventChannel.receiveBroadcastStream().listen((
      dynamic raw,
    ) {
      if (_shakeRefreshPending) return;
      if (raw is! num) return;
      final force = raw.toDouble().clamp(0.0, 1.0);
      if (force < 0.08) return;
      _triggerShakeByForce(force: force, fromDevice: true);
    }, onError: (_) {});
  }

  void _shakeBubbles() {
    if (_shakeRefreshPending) return;
    final now = DateTime.now();
    if (now.difference(_lastButtonTapAt).inMilliseconds <= 700) {
      _buttonCombo = (_buttonCombo + 1).clamp(1, 6);
    } else {
      _buttonCombo = 1;
    }
    _lastButtonTapAt = now;

    final force = (0.28 + (_buttonCombo - 1) * 0.18).clamp(0.28, 1.0);
    _triggerShakeByForce(force: force.toDouble(), fromDevice: false);
  }

  void _triggerShakeByForce({required double force, required bool fromDevice}) {
    if (_shakeRefreshPending) return;
    if (_bubbles.isEmpty) return;
    _resumePhysicsTicker();

    final _ShakeTier tier = force >= 0.82
        ? _ShakeTier.full
        : (force >= 0.55 ? _ShakeTier.medium : _ShakeTier.light);
    final throwRatio = switch (tier) {
      _ShakeTier.full => 1.0,
      _ShakeTier.medium => 0.62,
      _ShakeTier.light => 0.28,
    };
    final stageShares = switch (tier) {
      _ShakeTier.full => const <double>[0.24, 0.33, 0.43],
      _ShakeTier.medium => const <double>[0.32, 0.30],
      _ShakeTier.light => const <double>[0.28],
    };
    final stageDelays = switch (tier) {
      _ShakeTier.full => const <int>[0, 120, 260],
      _ShakeTier.medium => const <int>[0, 150],
      _ShakeTier.light => const <int>[0],
    };

    if (tier == _ShakeTier.full) {
      HapticFeedback.heavyImpact();
    } else if (tier == _ShakeTier.medium) {
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.lightImpact();
    }

    final activeIndexes = <int>[];
    for (int i = 0; i < _bubbles.length; i++) {
      if (_bubbles[i].active) activeIndexes.add(i);
    }
    if (activeIndexes.isEmpty) return;

    activeIndexes.shuffle(_random);
    final throwCount = math.max(1, (activeIndexes.length * throwRatio).round());
    final selected = activeIndexes.take(throwCount).toList(growable: false);
    final selectedSet = selected.toSet();
    final stageIndexes = <List<int>>[];
    var cursor = 0;
    for (int i = 0; i < stageShares.length; i++) {
      if (cursor >= selected.length) {
        stageIndexes.add(const <int>[]);
        continue;
      }
      final remaining = selected.length - cursor;
      final planned = i == stageShares.length - 1
          ? remaining
          : math.max(1, (selected.length * stageShares[i]).round());
      final count = planned.clamp(1, remaining);
      stageIndexes.add(selected.sublist(cursor, cursor + count));
      cursor += count;
    }

    for (int i = 0; i < stageIndexes.length; i++) {
      final indices = stageIndexes[i];
      if (indices.isEmpty) continue;
      late final Timer timer;
      timer = Timer(Duration(milliseconds: stageDelays[i]), () {
        _shakeBurstTimers.remove(timer);
        if (!mounted) return;
        final stageForce = (force + i * 0.12).clamp(0.0, 1.0);
        _throwBubbleIndices(indices, force: stageForce);
      });
      _shakeBurstTimers.add(timer);
    }

    for (int i = 0; i < _bubbles.length; i++) {
      if (!selectedSet.contains(i)) {
        final bubble = _bubbles[i];
        if (!bubble.active) continue;
        _applyImpulse(
          bubble,
          x: (_random.nextDouble() - 0.5) * (160 + force * 120),
          y: -(100 + force * 90),
        );
      }
    }

    if (tier == _ShakeTier.full) {
      _shakeRefreshPending = true;
      final lastDelaySeconds =
          (stageDelays.isEmpty ? 0 : stageDelays.last) / 1000;
      _refreshAfterSimTime =
          _simulatedTime + lastDelaySeconds + (fromDevice ? 0.78 : 0.88);
      _buttonCombo = 0;
    }
  }

  void _throwBubbleIndices(List<int> indexes, {required double force}) {
    for (final index in indexes) {
      if (index < 0 || index >= _bubbles.length) continue;
      final bubble = _bubbles[index];
      if (!bubble.active) continue;
      _applyImpulse(
        bubble,
        x: (_random.nextDouble() - 0.5) * (700 + force * 700),
        y: -(760 + force * 950 + _random.nextDouble() * 280),
      );
      bubble.angularVelocity += (_random.nextDouble() - 0.5) * (2.6 + force);
    }
  }

  void _cancelShakeBurstTimers() {
    for (final timer in _shakeBurstTimers) {
      if (timer.isActive) timer.cancel();
    }
    _shakeBurstTimers.clear();
  }

  void _applyImpulse(
    _BubbleEntity bubble, {
    required double x,
    required double y,
  }) {
    _resumePhysicsTicker();
    _wakeBubble(bubble);
    bubble.velocity = bubble.velocity.translate(x, y);
  }

  void _ensurePhysicsArea(Size nextSize) {
    if (_physicsSize == nextSize || nextSize.isEmpty) return;
    _physicsSize = nextSize;

    if (_bubbles.isEmpty) {
      _spawnBubbles();
      return;
    }
    for (final bubble in _bubbles) {
      final x = bubble.position.dx.clamp(
        bubble.radius,
        _physicsSize.width - bubble.radius,
      );
      final y = bubble.position.dy.clamp(
        -bubble.radius * 3,
        _physicsSize.height - bubble.radius,
      );
      bubble.position = Offset(x, y);
    }
  }

  void _spawnBubbles() {
    _resumePhysicsTicker();
    _cancelShakeBurstTimers();
    _bubbles.clear();
    _simulatedTime = 0;
    _lastTick = Duration.zero;
    _shakeRefreshPending = false;
    _refreshAfterSimTime = null;

    final selected = _pickEmotionDescriptors(_targetBubbleCount);

    for (int i = 0; i < selected.length; i++) {
      final descriptor = selected[i];
      final palette = _paletteFor(_bubbleTypeForEmotion(descriptor.emotion));
      final picked = palette[_random.nextInt(palette.length)];
      final radius = 34.0 * _bubbleScaleForEmotion(descriptor.emotion, i);
      final fontSize = _bubbleFontSize(radius, '？');
      final x =
          radius + _random.nextDouble() * (_physicsSize.width - radius * 2);
      final y = -80 - _random.nextDouble() * 240;
      final decoration = _buildBubbleDecoration(picked.$1);
      final textStyle = TextStyle(
        color: picked.$2.withValues(alpha: 0.82),
        fontSize: fontSize,
        fontWeight: FontWeight.w800,
        height: 1.05,
        letterSpacing: 0,
      );

      _bubbles.add(
        _BubbleEntity(
          text: '？',
          emotionText: descriptor.text,
          emotion: descriptor.emotion,
          radius: radius,
          position: Offset(x, y),
          velocity: Offset((_random.nextDouble() - 0.5) * 130, 0),
          angle: (_random.nextDouble() - 0.5) * 0.2,
          angularVelocity: (_random.nextDouble() - 0.5) * 0.9,
          decoration: decoration,
          textStyle: textStyle,
          spawnDelay: i * 0.02,
        ),
      );
    }
  }

  BoxDecoration _buildBubbleDecoration(Color color) {
    final borderColor = Colors.white.withAlpha(190);
    switch (_performanceTier) {
      case _PerformanceTier.low:
        return BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: color,
          border: Border.all(color: borderColor, width: 1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        );
      case _PerformanceTier.medium:
        return BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: color,
          border: Border.all(color: borderColor, width: 1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(14),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        );
      case _PerformanceTier.high:
        return BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: color,
          border: Border.all(color: borderColor, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(16),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        );
    }
  }

  List<_EmotionDescriptor> _pickEmotionDescriptors(int count) {
    final positive = _emotionPool
        .where(
          (e) =>
              e.emotion == EmotionType.veryHappy ||
              e.emotion == EmotionType.happy,
        )
        .toList(growable: false);
    final neutral = _emotionPool
        .where((e) => e.emotion == EmotionType.neutral)
        .toList(growable: false);
    final negative = _emotionPool
        .where(
          (e) =>
              e.emotion == EmotionType.sad || e.emotion == EmotionType.verySad,
        )
        .toList(growable: false);

    final shuffledPositive = List<_EmotionDescriptor>.of(positive)
      ..shuffle(_random);
    final shuffledNeutral = List<_EmotionDescriptor>.of(neutral)
      ..shuffle(_random);
    final shuffledNegative = List<_EmotionDescriptor>.of(negative)
      ..shuffle(_random);

    final positiveCount = (count * 0.4).round().clamp(2, count).toInt();
    final neutralCount = (count * 0.22)
        .round()
        .clamp(1, math.max(1, count - positiveCount))
        .toInt();
    final negativeCount = count - positiveCount - neutralCount;

    final selected = <_EmotionDescriptor>[
      ...shuffledPositive.take(positiveCount),
      ...shuffledNeutral.take(neutralCount),
      ...shuffledNegative.take(
        negativeCount.clamp(0, shuffledNegative.length).toInt(),
      ),
    ];

    if (selected.length < count) {
      final fallback = List<_EmotionDescriptor>.of(_emotionPool)
        ..shuffle(_random);
      for (final item in fallback) {
        if (selected.length >= count) break;
        if (selected.contains(item)) continue;
        selected.add(item);
      }
    }

    selected.shuffle(_random);
    return selected.take(count).toList(growable: false);
  }

  _BubbleType _bubbleTypeForEmotion(EmotionType emotion) {
    switch (emotion) {
      case EmotionType.veryHappy:
      case EmotionType.happy:
        return _BubbleType.warm;
      case EmotionType.neutral:
        return _BubbleType.neutral;
      case EmotionType.sad:
      case EmotionType.verySad:
        return _BubbleType.cool;
    }
  }

  double _bubbleScaleForEmotion(EmotionType emotion, int index) {
    final offset = (index % 3) * 0.05;
    switch (emotion) {
      case EmotionType.veryHappy:
      case EmotionType.verySad:
        return 1.08 + offset;
      case EmotionType.happy:
      case EmotionType.sad:
        return 1.0 + offset;
      case EmotionType.neutral:
        return 0.94 + offset;
    }
  }

  List<(Color, Color)> _paletteFor(_BubbleType type) {
    switch (type) {
      case _BubbleType.warm:
        return const [
          (Color(0xFFF7D7C5), Color(0xFF8C563B)),
          (Color(0xFFF4E3A7), Color(0xFF836B24)),
          (Color(0xFFF2C9C4), Color(0xFF92504C)),
        ];
      case _BubbleType.cool:
        return const [
          (Color(0xFFD3E0EC), Color(0xFF425C75)),
          (Color(0xFFDCD7EC), Color(0xFF5A5278)),
          (Color(0xFFCFE4DC), Color(0xFF3F6C5F)),
        ];
      case _BubbleType.neutral:
        return const [
          (Color(0xFFE8E3D6), Color(0xFF686354)),
          (Color(0xFFD7E6DA), Color(0xFF4B7155)),
          (Color(0xFFE8DCC8), Color(0xFF77644B)),
        ];
    }
  }

  void _onPhysicsTick(Duration elapsed) {
    if (_physicsSize.isEmpty || _bubbles.isEmpty) return;
    if (_lastTick == Duration.zero) {
      _lastTick = elapsed;
      return;
    }

    final dt = (elapsed - _lastTick).inMicroseconds / 1000000;
    _lastTick = elapsed;
    if (dt <= 0) return;

    final step = dt.clamp(0.0, 0.033);
    _simulatedTime += step;
    final shouldPaintFrame = _updatePhysics(step);
    if (!shouldPaintFrame) {
      _updatePerfWindow(step, painted: false);
      if (_physicsCanPause) {
        _pausePhysicsTicker();
      }
      return;
    }
    _uiFrameAccumulator += step;
    final targetFrame = 1 / _targetUiFps;
    var painted = false;
    if (_uiFrameAccumulator >= targetFrame) {
      while (_uiFrameAccumulator >= targetFrame) {
        _uiFrameAccumulator -= targetFrame;
      }
      _physicsFrameTick.value = (_physicsFrameTick.value + 1) & 0x3fffffff;
      painted = true;
    }
    _updatePerfWindow(step, painted: painted);
  }

  bool _updatePhysics(double dt) {
    const gravity = 880.0;
    var hasPendingSpawn = false;
    var dynamicBubbleCount = 0;

    for (final bubble in _bubbles) {
      bubble.supportedThisFrame = false;
      if (!bubble.active && _simulatedTime >= bubble.spawnDelay) {
        bubble.active = true;
      }
      if (!bubble.active) {
        hasPendingSpawn = true;
      }
      if (!bubble.active) continue;

      final maxY = _physicsSize.height - bubble.radius;
      if (bubble.settled) {
        if (bubble.position.dy > maxY) {
          bubble.position = Offset(bubble.position.dx, maxY);
        }
        bubble.velocity = Offset.zero;
        bubble.angularVelocity = 0;
        continue;
      }
      dynamicBubbleCount++;

      bubble.velocity = bubble.velocity.translate(0, gravity * dt);
      bubble.position = bubble.position.translate(
        bubble.velocity.dx * dt,
        bubble.velocity.dy * dt,
      );
      bubble.angle += bubble.angularVelocity * dt;
      bubble.velocity = Offset(
        bubble.velocity.dx * 0.992,
        bubble.velocity.dy * 0.996,
      );
      bubble.angularVelocity *= 0.986;

      final minX = bubble.radius;
      final maxX = _physicsSize.width - bubble.radius;

      if (bubble.position.dx < minX) {
        bubble.position = Offset(minX, bubble.position.dy);
        bubble.velocity = Offset(
          -bubble.velocity.dx * 0.84,
          bubble.velocity.dy,
        );
      } else if (bubble.position.dx > maxX) {
        bubble.position = Offset(maxX, bubble.position.dy);
        bubble.velocity = Offset(
          -bubble.velocity.dx * 0.84,
          bubble.velocity.dy,
        );
      }

      if (bubble.position.dy > maxY) {
        bubble.position = Offset(bubble.position.dx, maxY);
        bubble.velocity = Offset(
          bubble.velocity.dx * 0.9,
          -bubble.velocity.dy * 0.55,
        );
        bubble.supportedThisFrame = true;
        if (bubble.velocity.dy.abs() < 16) {
          bubble.velocity = Offset(bubble.velocity.dx, 0);
        }
      }

      final nearBottom = (maxY - bubble.position.dy).abs() < 1.2;
      final slowLinear =
          bubble.velocity.dx.abs() < 6 && bubble.velocity.dy.abs() < 6;
      final slowSpin = bubble.angularVelocity.abs() < 0.08;
      if (nearBottom && slowLinear && slowSpin) {
        bubble.settleTimer += dt;
        if (bubble.settleTimer > 0.28) {
          _settleBubbleOnFloor(bubble, maxY: maxY);
        }
      } else {
        bubble.settleTimer = math.max(0, bubble.settleTimer - dt);
      }
    }

    if (dynamicBubbleCount > 0) {
      _resolveBubbleCollisions();
      _resolveSupportedBubbleSettling(dt);
    }

    if (_shouldRefreshAfterShake()) {
      _spawnBubbles();
      return true;
    }
    _physicsCanPause =
        !hasPendingSpawn && dynamicBubbleCount == 0 && !_shakeRefreshPending;
    return hasPendingSpawn || dynamicBubbleCount > 0 || _shakeRefreshPending;
  }

  void _updatePerfWindow(double step, {required bool painted}) {
    final stepMs = step * 1000;
    _avgStepMs = _avgStepMs == 0 ? stepMs : (_avgStepMs * 0.9 + stepMs * 0.1);
    _peakStepMs = math.max(_peakStepMs, stepMs);

    _uiWindowSeconds += step;
    if (painted) {
      _uiFramesInWindow++;
    }
    _tierCooldownSeconds = math.max(0, _tierCooldownSeconds - step);

    if (_uiWindowSeconds < 1.0) {
      return;
    }

    _estimatedUiFps = _uiFramesInWindow / _uiWindowSeconds;
    _uiFramesInWindow = 0;
    _uiWindowSeconds = 0;
    _maybeAutoAdjustTier();
    _peakStepMs = 0;

    if (kDebugMode && _showPerfOverlay && mounted) {
      setState(() {});
    }
  }

  void _maybeAutoAdjustTier() {
    if (_tierCooldownSeconds > 0) return;
    if (_shakeRefreshPending) return;

    final targetFps = _targetUiFps;
    final overloaded =
        _estimatedUiFps < targetFps * 0.74 ||
        _avgStepMs > (1000 / targetFps) * 1.38;
    final healthy =
        _estimatedUiFps > targetFps * 0.95 &&
        _avgStepMs < (1000 / targetFps) * 1.02;

    if (overloaded) {
      _tierPressureSeconds += 1;
      _tierRelaxSeconds = math.max(0, _tierRelaxSeconds - 0.6);
    } else if (healthy) {
      _tierRelaxSeconds += 1;
      _tierPressureSeconds = math.max(0, _tierPressureSeconds - 0.6);
    } else {
      _tierPressureSeconds = math.max(0, _tierPressureSeconds - 0.45);
      _tierRelaxSeconds = math.max(0, _tierRelaxSeconds - 0.45);
    }

    if (_tierPressureSeconds >= 2) {
      final nextTier = _nextLowerTier(_performanceTier);
      if (nextTier != null) {
        _setPerformanceTier(nextTier);
      }
      return;
    }

    if (_tierRelaxSeconds >= 8) {
      final nextTier = _nextHigherTier(_performanceTier);
      if (nextTier != null &&
          _tierRank(nextTier) <= _tierRank(_devicePreferredTier)) {
        _setPerformanceTier(nextTier);
      }
    }
  }

  void _setPerformanceTier(_PerformanceTier tier) {
    if (tier == _performanceTier) return;
    _performanceTier = tier;
    _tierPressureSeconds = 0;
    _tierRelaxSeconds = 0;
    _tierCooldownSeconds = 2.2;
    if (_physicsSize.isEmpty || _shakeRefreshPending) return;
    _spawnBubbles();
    _physicsFrameTick.value = (_physicsFrameTick.value + 1) & 0x3fffffff;
  }

  void _pausePhysicsTicker() {
    if (_physicsPaused) return;
    _physicsTicker.stop();
    _physicsPaused = true;
  }

  void _resumePhysicsTicker() {
    if (!_physicsPaused) return;
    _physicsPaused = false;
    _physicsCanPause = false;
    _lastTick = Duration.zero;
    _physicsTicker.start();
  }

  int _tierRank(_PerformanceTier tier) {
    switch (tier) {
      case _PerformanceTier.high:
        return 2;
      case _PerformanceTier.medium:
        return 1;
      case _PerformanceTier.low:
        return 0;
    }
  }

  _PerformanceTier? _nextLowerTier(_PerformanceTier tier) {
    switch (tier) {
      case _PerformanceTier.high:
        return _PerformanceTier.medium;
      case _PerformanceTier.medium:
        return _PerformanceTier.low;
      case _PerformanceTier.low:
        return null;
    }
  }

  _PerformanceTier? _nextHigherTier(_PerformanceTier tier) {
    switch (tier) {
      case _PerformanceTier.high:
        return null;
      case _PerformanceTier.medium:
        return _PerformanceTier.high;
      case _PerformanceTier.low:
        return _PerformanceTier.medium;
    }
  }

  bool _shouldRefreshAfterShake() {
    if (!_shakeRefreshPending) return false;
    final timeoutReached =
        _refreshAfterSimTime != null && _simulatedTime >= _refreshAfterSimTime!;
    return timeoutReached || _allActiveBubblesOutOfViewport();
  }

  bool _allActiveBubblesOutOfViewport() {
    if (_physicsSize.isEmpty) return false;
    const margin = 28.0;
    var hasActive = false;

    for (final bubble in _bubbles) {
      if (!bubble.active) continue;
      hasActive = true;

      final outTop = bubble.position.dy + bubble.radius < -margin;
      final outLeft = bubble.position.dx + bubble.radius < -margin;
      final outRight =
          bubble.position.dx - bubble.radius > _physicsSize.width + margin;
      final outBottom =
          bubble.position.dy - bubble.radius > _physicsSize.height + margin;
      final isOut = outTop || outLeft || outRight || outBottom;

      if (!isOut) return false;
    }

    return hasActive;
  }

  void _resolveBubbleCollisions() {
    final cellSize = _collisionCellSize;
    final buckets = <String, List<int>>{};
    final active = <int>[];
    for (int i = 0; i < _bubbles.length; i++) {
      final bubble = _bubbles[i];
      if (!bubble.active) continue;
      active.add(i);
      final cx = (bubble.position.dx / cellSize).floor();
      final cy = (bubble.position.dy / cellSize).floor();
      final key = '${cx}_$cy';
      (buckets[key] ??= <int>[]).add(i);
    }
    if (active.length < 2) return;

    for (final i in active) {
      final a = _bubbles[i];
      final cx = (a.position.dx / cellSize).floor();
      final cy = (a.position.dy / cellSize).floor();
      for (int dx = -1; dx <= 1; dx++) {
        for (int dy = -1; dy <= 1; dy++) {
          final key = '${cx + dx}_${cy + dy}';
          final neighbors = buckets[key];
          if (neighbors == null) continue;
          for (final j in neighbors) {
            if (j <= i) continue;
            final b = _bubbles[j];
            _resolveCollisionPair(a, b);
          }
        }
      }
    }
  }

  void _resolveCollisionPair(_BubbleEntity a, _BubbleEntity b) {
    final delta = b.position - a.position;
    final distance = delta.distance;
    final minDistance = a.radius + b.radius;
    if (distance <= 0 || distance >= minDistance) return;
    if (a.settled && b.settled) return;

    final normal = delta / distance;
    final overlap = minDistance - distance;
    if (overlap <= 0.35) return;
    final relative = b.velocity - a.velocity;
    final velocityAlongNormal =
        relative.dx * normal.dx + relative.dy * normal.dy;
    if (a.settled != b.settled) {
      if (a.settled) {
        b.position += normal * overlap;
        b.supportedThisFrame = true;
      } else {
        a.position -= normal * overlap;
        a.supportedThisFrame = true;
      }

      if (velocityAlongNormal >= 0) return;
      const restitution = 0.22;
      final impulse = -(1 + restitution) * velocityAlongNormal;
      if (a.settled) {
        b.velocity += normal * impulse;
      } else {
        a.velocity -= normal * impulse;
      }
      return;
    }

    a.position -= normal * (overlap * 0.5);
    b.position += normal * (overlap * 0.5);
    _markSupportByRelativePosition(a, b, normal);
    if (velocityAlongNormal > -2) return;

    const restitution = 0.56;
    final impulse = -(1 + restitution) * velocityAlongNormal / 2;
    final impulseVector = normal * impulse;
    if (impulse.abs() > 90) {
      _wakeBubble(a);
      _wakeBubble(b);
    }
    if (!a.settled) a.velocity -= impulseVector;
    if (!b.settled) b.velocity += impulseVector;
  }

  void _markSupportByRelativePosition(
    _BubbleEntity a,
    _BubbleEntity b,
    Offset normal,
  ) {
    final aAboveB = normal.dy > 0.18;
    final bAboveA = normal.dy < -0.18;
    if (aAboveB) {
      a.supportedThisFrame = true;
    } else if (bAboveA) {
      b.supportedThisFrame = true;
    }
  }

  void _resolveSupportedBubbleSettling(double dt) {
    for (final bubble in _bubbles) {
      if (!bubble.active || bubble.settled) continue;

      final speed = bubble.velocity.distance;
      final spin = bubble.angularVelocity.abs();
      final inBottleLowerZone = bubble.position.dy > _physicsSize.height * 0.32;
      final canSleep =
          bubble.supportedThisFrame &&
          inBottleLowerZone &&
          speed < 11 &&
          spin < 0.16;

      if (!canSleep) {
        bubble.supportedSettleTimer = math.max(
          0,
          bubble.supportedSettleTimer - dt * 0.8,
        );
        continue;
      }

      bubble.supportedSettleTimer += dt;
      if (bubble.supportedSettleTimer > 0.34) {
        _settleBubbleInPlace(bubble);
      }
    }
  }

  void _wakeBubble(_BubbleEntity bubble) {
    bubble.settled = false;
    bubble.settleTimer = 0;
    bubble.supportedSettleTimer = 0;
    bubble.supportedThisFrame = false;
  }

  void _settleBubbleOnFloor(_BubbleEntity bubble, {required double maxY}) {
    bubble.settled = true;
    bubble.settleTimer = 0;
    bubble.supportedSettleTimer = 0;
    bubble.supportedThisFrame = true;
    bubble.position = Offset(bubble.position.dx, maxY);
    bubble.velocity = Offset.zero;
    bubble.angularVelocity = 0;
  }

  void _settleBubbleInPlace(_BubbleEntity bubble) {
    bubble.settled = true;
    bubble.settleTimer = 0;
    bubble.supportedSettleTimer = 0;
    bubble.velocity = Offset.zero;
    bubble.angularVelocity = 0;
  }
}

class _HintChip extends StatelessWidget {
  final String label;

  const _HintChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(110),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withAlpha(160)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(14),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF075985),
          fontWeight: FontWeight.w800,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class _DrawLiftOverlay extends StatelessWidget {
  final _DrawLiftState state;

  const _DrawLiftOverlay({required this.state});

  @override
  Widget build(BuildContext context) {
    final color = _resultColor(state.result.typeName);
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: state.controller,
        builder: (context, _) {
          final t = Curves.easeOutCubic.transform(state.controller.value);
          final viewport = MediaQuery.of(context).size;
          final targetWidth = math.min(viewport.width * 0.58, 230.0);
          final targetHeight = targetWidth * 0.62;
          final targetRect = Rect.fromCenter(
            center: Offset(viewport.width / 2, viewport.height * 0.46),
            width: targetWidth,
            height: targetHeight,
          );
          final rect = Rect.lerp(state.startRect, targetRect, t)!;
          final angle =
              state.startAngle +
              (0.10 - state.startAngle) * t +
              math.sin(t * math.pi) * 0.08;
          final reveal = Curves.easeOut.transform(
            ((state.controller.value - 0.42) / 0.58).clamp(0.0, 1.0),
          );

          return Stack(
            children: [
              Positioned.fill(
                child: Opacity(
                  opacity: 0.18 * t,
                  child: Container(color: Colors.white),
                ),
              ),
              Positioned.fromRect(
                rect: rect,
                child: Transform.rotate(
                  angle: angle,
                  child: Container(
                    decoration: state.decoration.copyWith(
                      boxShadow: [
                        BoxShadow(
                          color: color.withAlpha(46),
                          blurRadius: 28,
                          offset: const Offset(0, 14),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Opacity(
                        opacity: 1 - reveal,
                        child: Text(
                          '？',
                          style: state.textStyle.copyWith(
                            fontSize: state.textStyle.fontSize! * 1.25,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned.fromRect(
                rect: rect,
                child: Opacity(
                  opacity: reveal,
                  child: Center(
                    child: Text(
                      state.result.emotion,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: color,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MoodDrawResultSheet extends StatelessWidget {
  final _MoodDrawResult result;
  final VoidCallback onDrawAgain;

  const _MoodDrawResultSheet({required this.result, required this.onDrawAgain});

  @override
  Widget build(BuildContext context) {
    final color = _resultColor(result.typeName);
    final viewport = MediaQuery.of(context).size;
    return SafeArea(
      child: Center(
        child: Container(
          width: math.min(viewport.width - 36, 430),
          constraints: BoxConstraints(maxHeight: viewport.height * 0.82),
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFCF4),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(30),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.13),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        result.tone,
                        style: TextStyle(
                          color: color,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                      color: AppTheme.textSecondary,
                      tooltip: '关闭',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color.withValues(alpha: 0.16)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '你抽到了',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        result.emotion,
                        style: TextStyle(
                          fontSize: 34,
                          color: color,
                          fontWeight: FontWeight.w900,
                          height: 1.05,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        result.explanation,
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppTheme.textPrimary,
                          height: 1.55,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _ResultNoteBlock(
                        icon: Icons.local_florist_rounded,
                        title: '今日寄语',
                        text: result.message,
                        color: color,
                      ),
                      const SizedBox(height: 10),
                      _ResultNoteBlock(
                        icon: Icons.self_improvement_rounded,
                        title: '可以这样做',
                        text: result.guidance,
                        color: color,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onDrawAgain,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: color,
                          side: BorderSide(
                            color: color.withValues(alpha: 0.45),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 17),
                          textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        child: const Text('再抽一张'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: FilledButton.styleFrom(
                          backgroundColor: color,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 17),
                          textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        child: const Text('收下这张'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ResultNoteBlock extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;
  final Color color;

  const _ResultNoteBlock({
    required this.icon,
    required this.title,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 19, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    color: color,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textPrimary,
                    height: 1.45,
                    fontWeight: FontWeight.w500,
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

class _MoodDrawHistorySheet extends StatelessWidget {
  final List<_MoodDrawResult> records;

  const _MoodDrawHistorySheet({required this.records});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.72,
        ),
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(28),
              blurRadius: 22,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Text(
                  '抽取记录',
                  style: TextStyle(
                    fontSize: 20,
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                  tooltip: '关闭',
                ),
              ],
            ),
            if (records.isEmpty)
              const Padding(
                padding: EdgeInsets.fromLTRB(8, 38, 8, 48),
                child: Text(
                  '还没有抽过心情片',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            else
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: records.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final item = records[index];
                    final color = _resultColor(item.typeName);
                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              item.emotion.characters.first,
                              style: TextStyle(
                                color: color,
                                fontSize: 19,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${item.emotion} · ${item.tone}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: AppTheme.textPrimary,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.message,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppTheme.textSecondary,
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatHistoryTime(item.createdAt),
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textHint,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MoodDrawResult {
  final String id;
  final String emotion;
  final String typeName;
  final String tone;
  final String explanation;
  final String message;
  final String guidance;
  final DateTime createdAt;

  const _MoodDrawResult({
    required this.id,
    required this.emotion,
    required this.typeName,
    required this.tone,
    required this.explanation,
    required this.message,
    required this.guidance,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'emotion': emotion,
      'typeName': typeName,
      'tone': tone,
      'explanation': explanation,
      'message': message,
      'guidance': guidance,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  static _MoodDrawResult? fromMap(Map<String, dynamic> map) {
    final createdAt = DateTime.tryParse(map['createdAt']?.toString() ?? '');
    if (createdAt == null) return null;
    final emotion = map['emotion']?.toString() ?? '';
    if (emotion.isEmpty) return null;
    return _MoodDrawResult(
      id: map['id']?.toString() ?? createdAt.millisecondsSinceEpoch.toString(),
      emotion: emotion,
      typeName: map['typeName']?.toString() ?? EmotionType.neutral.name,
      tone: map['tone']?.toString() ?? '平稳片刻',
      explanation: map['explanation']?.toString() ?? '',
      message: map['message']?.toString() ?? '',
      guidance: map['guidance']?.toString() ?? '',
      createdAt: createdAt,
    );
  }
}

class _DrawLiftState {
  final AnimationController controller;
  final Rect startRect;
  final double startAngle;
  final BoxDecoration decoration;
  final TextStyle textStyle;
  final _MoodDrawResult result;

  const _DrawLiftState({
    required this.controller,
    required this.startRect,
    required this.startAngle,
    required this.decoration,
    required this.textStyle,
    required this.result,
  });
}

Color _resultColor(String typeName) {
  if (typeName == EmotionType.veryHappy.name) return const Color(0xFFE66A4E);
  if (typeName == EmotionType.happy.name) return const Color(0xFF4F9B6E);
  if (typeName == EmotionType.sad.name) return const Color(0xFF4D7FB8);
  if (typeName == EmotionType.verySad.name) return const Color(0xFF7067A5);
  return const Color(0xFF7D8A55);
}

String _formatHistoryTime(DateTime time) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(time.year, time.month, time.day);
  final clock =
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  if (day == today) return clock;
  if (day == today.subtract(const Duration(days: 1))) return '昨天';
  return '${time.month}/${time.day}';
}

enum _BubbleType { warm, cool, neutral }

enum _ShakeTier { light, medium, full }

enum _PerformanceTier { high, medium, low }

class _EmotionDescriptor {
  final String text;
  final EmotionType emotion;

  const _EmotionDescriptor(this.text, this.emotion);
}

class _BubbleEntity {
  final String text;
  final String emotionText;
  final EmotionType emotion;
  final double radius;
  final double spawnDelay;
  final BoxDecoration decoration;
  final TextStyle textStyle;

  Offset position;
  Offset velocity;
  double angle;
  double angularVelocity;
  bool active;
  bool settled;
  double settleTimer;
  bool supportedThisFrame;
  double supportedSettleTimer;

  _BubbleEntity({
    required this.text,
    required this.emotionText,
    required this.emotion,
    required this.radius,
    required this.position,
    required this.velocity,
    required this.angle,
    required this.angularVelocity,
    required this.decoration,
    required this.textStyle,
    required this.spawnDelay,
  }) : active = false,
       settled = false,
       settleTimer = 0,
       supportedThisFrame = false,
       supportedSettleTimer = 0;
}
