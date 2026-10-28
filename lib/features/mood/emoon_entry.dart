import 'models/emotion_record.dart';
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/database_service.dart';
import 'services/daily_reminder_service.dart';
import 'services/ohos_native_service.dart';
import 'widgets/privacy_consent_dialog.dart';
import 'pages/settings/privacy_policy_page.dart';
import 'pages/settings/user_agreement_page.dart';
import 'dart:convert';
import 'dart:io' show File;
import 'widgets/media_picker.dart';
import 'widgets/primary_page_header.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'pages/breathing_exercise_page.dart';
import 'pages/app_lock_page.dart';
import 'pages/custom_emotions_page.dart';
import 'pages/mental_support_page.dart';
import 'pages/record_detail_page.dart';
import 'pages/retest_reminders_page.dart';
import 'pages/test_result_detail_page.dart';
import 'pages/time_page.dart';
import 'pages/mood_bottle_page.dart';
import 'pages/relax_page.dart';
import 'pages/relax_tools_page.dart';

import 'models/ai_emotion_result.dart';
import 'models/mental_assessment.dart';
import 'models/therapy_recommendation.dart';
import 'services/assessment_catalog.dart';
import 'services/relax_audio_controller.dart';
import 'services/therapy_recommendation_service.dart';
import 'widgets/emotion_recommendation_dialog.dart';
import 'services/ai/ai_emotion_service.dart';
import 'services/ai/voice_emotion_analyzer_stub.dart'
    if (dart.library.io) 'services/ai/voice_emotion_analyzer.dart';
import 'services/ai/face_emotion_analyzer_stub.dart'
    if (dart.library.io) 'services/ai/face_emotion_analyzer.dart';
import 'services/ai/text_emotion_analyzer.dart';
import 'dart:math' as math;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPaintBaselinesEnabled = false;
  debugPaintSizeEnabled = false;
  debugRepaintRainbowEnabled = false;

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // 不在启动时请求或使用通知：通知权限仅在用户同意隐私后、且打开「每日提醒」时再申请
  runApp(const FomoEmotionApp());
}

// 应用主题配置

class MoodOptionUtils {
  static const List<Map<String, dynamic>> defaultMoods = [
    {'emoji': '😊', 'label': '开心', 'color': Color(0xFFFFD93D)},
    {'emoji': '🥰', 'label': '幸福', 'color': Color(0xFFF48FB1)},
    {'emoji': '🥺', 'label': '难过', 'color': Color(0xFF6B8CCE)},
    {'emoji': '😠', 'label': '生气', 'color': Color(0xFFE57373)},
    {'emoji': '😰', 'label': '焦虑', 'color': Color(0xFFFFB74D)},
    {'emoji': '😴', 'label': '疲惫', 'color': Color(0xFF90A4AE)},
  ];

  static List<Map<String, dynamic>> merge({
    Iterable<String> customLabels = const [],
    Iterable<EmotionRecord> records = const [],
    EmotionRecord? currentRecord,
  }) {
    final result = <Map<String, dynamic>>[];
    final seen = <String>{};

    void add({
      required String label,
      required String emoji,
      Color color = const Color(0xFF9E9E9E),
      IconData icon = Icons.sentiment_satisfied_alt,
    }) {
      final normalized = label.trim();
      if (normalized.isEmpty || seen.contains(normalized)) return;
      seen.add(normalized);
      result.add({
        'emoji': emoji.trim().isNotEmpty ? emoji.trim() : '😐',
        'label': normalized,
        'color': AppTheme.moodColors[normalized] ?? color,
        'icon': icon,
      });
    }

    for (final mood in defaultMoods) {
      add(
        label: mood['label'] as String,
        emoji: mood['emoji'] as String,
        color: mood['color'] as Color,
      );
    }
    for (final label in customLabels) {
      add(label: label, emoji: '😐');
    }
    for (final record in records) {
      add(label: record.mood, emoji: record.emoji);
      for (var i = 0; i < record.additionalMoods.length; i++) {
        final emoji = i < record.additionalEmojis.length
            ? record.additionalEmojis[i]
            : '😐';
        add(label: record.additionalMoods[i], emoji: emoji);
      }
    }
    if (currentRecord != null) {
      add(label: currentRecord.mood, emoji: currentRecord.emoji);
      for (var i = 0; i < currentRecord.additionalMoods.length; i++) {
        final emoji = i < currentRecord.additionalEmojis.length
            ? currentRecord.additionalEmojis[i]
            : '😐';
        add(label: currentRecord.additionalMoods[i], emoji: emoji);
      }
    }
    return result;
  }

  static String emojiFor(List<Map<String, dynamic>> moods, String label) {
    final option = moods.cast<Map<String, dynamic>?>().firstWhere(
      (mood) => mood?['label'] == label,
      orElse: () => null,
    );
    final emoji = option?['emoji'];
    return emoji is String && emoji.isNotEmpty ? emoji : '😐';
  }
}

class FomoEmotionApp extends StatelessWidget {
  const FomoEmotionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FOMO情绪',
      theme: AppTheme.theme,
      locale: const Locale('zh', 'CN'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('zh', 'CN'), Locale('en')],
      home: const SplashPage(),
      debugShowCheckedModeBanner: false,
      // 确保 Material Icons 字体正确加载
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(1.0)),
          child: child!,
        );
      },
    );
  }
}

// 启动页 - 带动画效果
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
      ),
    );

    _controller.forward();

    // 仅在用户同意隐私政策后才进入主页；麦克风/相册/相机/通知等权限均在「使用时」再申请，不在此前请求
    Future.delayed(const Duration(seconds: 2), () async {
      if (!mounted) return;

      final accepted = await PrivacyConsentManager.hasAccepted();
      final reConsent = await PrivacyConsentManager.needsReConsent(
        kPrivacyPolicyVersion,
      );

      if (!mounted) return;

      if (accepted && !reConsent) {
        await _navigateToHome();
      } else {
        await _showPrivacyConsentDialog();
      }
    });
  }

  /// 显示隐私政策同意弹窗
  Future<void> _showPrivacyConsentDialog() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const PrivacyConsentDialog(),
    );

    if (result == true) {
      await PrivacyConsentManager.setAccepted(
        true,
        policyVersion: kPrivacyPolicyVersion,
      );
      if (mounted) {
        await _navigateToHome();
      }
    }
    // 如果用户拒绝，弹窗内会处理退出应用逻辑
  }

  /// 导航到主页（不在此处调用任何通知相关逻辑，避免刚确认隐私就弹通知权限）
  Future<void> _navigateToHome() async {
    if (!mounted) return;
    // 先读取设置，判断是否需要应用锁
    final dbService = DatabaseService();
    final settingsMap = await dbService.getSettings();
    final appSettings = settingsMap != null
        ? AppSettings.fromMap(settingsMap)
        : AppSettings();

    Widget target = const HomePage();
    if (appSettings.appLockEnabled && appSettings.appLockPin.isNotEmpty) {
      // 检查是否在超时时间内
      final prefs = await dbService.prefs;
      final lastUnlockTime = prefs.getInt('last_unlock_time');
      final now = DateTime.now().millisecondsSinceEpoch;
      final timeoutMs = appSettings.lockTimeoutSeconds * 1000;

      if (lastUnlockTime == null || (now - lastUnlockTime) > timeoutMs) {
        // 需要解锁
        target = AppLockPage(expectedPin: appSettings.appLockPin);
      } else {
        // 在超时时间内，直接进入主页
        target = const HomePage();
      }
    }

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => target,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(35),
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/icon/icon.png',
                    fit: BoxFit.cover,
                    width: 140,
                    height: 140,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  const Text(
                    'FOMO情绪',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '记录心情 · 温暖相伴',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60),
            FadeTransition(
              opacity: _fadeAnimation,
              child: SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.primaryColor.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 主页
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  int _currentIndex = 0;
  final ValueNotifier<int> _recordSavedNotifier = ValueNotifier(0);
  final RelaxAudioController _relaxAudio = RelaxAudioController.instance;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _relaxAudio.addListener(_handleRelaxAudioChanged);
    _pages = [
      HistoryPage(
        refreshTrigger: _recordSavedNotifier,
        onDeleteRecord: () => setState(() => _currentIndex = 0),
      ),
      const RelaxPage(),
      StatsPage(refreshTrigger: _recordSavedNotifier),
      const SettingsPage(),
    ];
    // 延迟 3 秒后静默恢复每日提醒调度（不请求权限）：应用被系统杀掉后闹钟会丢失，需重新注册
    Future.delayed(const Duration(seconds: 3), _scheduleReminderIfEnabled);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // 每次从后台回到前台都重新注册闹钟，提高华为等机型到点触发的概率（测试通知能弹说明权限和渠道正常，问题在定时被系统清理）
      Future.delayed(
        const Duration(milliseconds: 500),
        _scheduleReminderIfEnabled,
      );
    }
  }

  Future<void> _scheduleReminderIfEnabled() async {
    try {
      final settings = await DatabaseService().getSettings();
      if (settings == null) return;
      final s = AppSettings.fromMap(settings);
      if (!s.notificationsEnabled) return;
      await DailyReminderService.init();
      final hasPermission = await DailyReminderService.hasPermission();
      if (hasPermission) {
        await DailyReminderService.scheduleDaily(
          s.reminderHour,
          s.reminderMinute,
        );
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _relaxAudio.removeListener(_handleRelaxAudioChanged);
    _recordSavedNotifier.dispose();
    super.dispose();
  }

  void _handleRelaxAudioChanged() {
    if (mounted) setState(() {});
  }

  void _openRecordModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: RecordPage(
          onRecordSaved: () {
            _recordSavedNotifier.value++;
            // RecordPage will pop itself after a delay upon success
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _pages[_currentIndex],
      ),
      floatingActionButton: _currentIndex == 0
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_relaxAudio.canStop) ...[
                  FloatingActionButton.small(
                    heroTag: 'relax_audio_fab',
                    tooltip: _relaxAudio.isPlaying ? '白噪音播放中' : '白噪音已暂停',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const WhiteNoisePage(),
                        ),
                      );
                    },
                    backgroundColor: _relaxAudio.isPlaying
                        ? Colors.white
                        : AppTheme.primaryColor.withValues(alpha: 0.92),
                    foregroundColor: _relaxAudio.isPlaying
                        ? AppTheme.primaryColor
                        : Colors.white,
                    elevation: 4,
                    shape: const CircleBorder(),
                    child: Icon(
                      _relaxAudio.isPlaying
                          ? Icons.graphic_eq_rounded
                          : Icons.play_arrow_rounded,
                      size: 22,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                FloatingActionButton(
                  heroTag: 'record_fab',
                  onPressed: _openRecordModal,
                  backgroundColor: AppTheme.primaryColor,
                  elevation: 4,
                  shape: const CircleBorder(),
                  child: const Icon(
                    Icons.add_rounded,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
              ],
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: Container(
        height: 64 + bottomInset,
        padding: EdgeInsets.only(bottom: bottomInset),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.history_rounded, '时光'),
              _buildNavItem(1, Icons.self_improvement_rounded, '放空'),
              _buildNavItem(2, Icons.bar_chart_rounded, '内现'),
              _buildNavItem(3, Icons.settings_rounded, '我的'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.primaryColor : AppTheme.textHint,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppTheme.primaryColor : AppTheme.textHint,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 时光胶囊列表页
// 记录页 - 优化版
class RecordPage extends StatefulWidget {
  const RecordPage({super.key, this.onRecordSaved});

  final VoidCallback? onRecordSaved;

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  String _selectedMood = '';
  final List<String> _additionalMoods = [];
  String _selectedTrigger = '';
  int _bodyEnergy = 0;
  int _bodySleep = 0;
  int _bodyAppetite = 0;
  bool _cycleMoodAnalysisEnabled = false;
  String _menstrualStatus = '';
  final List<String> _cycleSymptoms = [];
  String _cycleFunctionImpact = '';
  final TextEditingController _noteController = TextEditingController();
  final DatabaseService _dbService = DatabaseService();
  double _intensity = 50;
  List<String> _imagePaths = [];
  String? _audioPath;
  final ScrollController _recordScrollController = ScrollController();
  bool _isBottomSaveVisible = false;
  bool _isTimeCapsule = false;
  DateTime? _unlockAt;
  List<Map<String, dynamic>> _moods = [];

  // AI 情绪识别相关状态
  AiEmotionResult? _aiEmotionResult;
  late final VoiceEmotionAnalyzer _mediaVoiceAnalyzer;
  late final FaceEmotionAnalyzer _mediaFaceAnalyzer;
  late final TextEmotionAnalyzer _mediaTextAnalyzer;
  bool _mediaVoiceReady = false;
  bool _mediaFaceReady = false;
  bool _mediaTextReady = false;
  bool _isMediaAiAnalyzing = false;
  bool _isTextAiAnalyzing = false;

  static const List<Map<String, dynamic>> _defaultMoods = [
    {'emoji': '😊', 'label': '开心', 'color': Color(0xFFFFD93D)},
    {'emoji': '🥰', 'label': '幸福', 'color': Color(0xFFF48FB1)},
    {'emoji': '🥺', 'label': '难过', 'color': Color(0xFF6B8CCE)},
    {'emoji': '😠', 'label': '生气', 'color': Color(0xFFE57373)},
    {'emoji': '😰', 'label': '焦虑', 'color': Color(0xFFFFB74D)},
    {'emoji': '😴', 'label': '疲惫', 'color': Color(0xFF90A4AE)},
  ];

  @override
  void initState() {
    super.initState();
    _noteController.addListener(_onDraftChanged);
    _recordScrollController.addListener(_handleRecordScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _handleRecordScroll());
    _moods = List<Map<String, dynamic>>.from(_defaultMoods);
    _loadMoods();
    _loadSettings();
    _initMediaAnalyzers();
  }

  @override
  void dispose() {
    _noteController.removeListener(_onDraftChanged);
    _recordScrollController.removeListener(_handleRecordScroll);
    _recordScrollController.dispose();
    _mediaVoiceAnalyzer.dispose();
    _mediaFaceAnalyzer.dispose();
    _mediaTextAnalyzer.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _clearRecordForm() {
    if (!mounted) return;
    setState(() {
      _selectedMood = '';
      _additionalMoods.clear();
      _selectedTrigger = '';
      _bodyEnergy = 0;
      _bodySleep = 0;
      _bodyAppetite = 0;
      _menstrualStatus = '';
      _cycleSymptoms.clear();
      _cycleFunctionImpact = '';
      _noteController.clear();
      _intensity = 50;
      _imagePaths = [];
      _audioPath = null;
      _aiEmotionResult = null;
    });
  }

  void _finishRecordSave({bool closePage = true}) {
    _clearRecordForm();
    widget.onRecordSaved?.call();
    if (closePage && mounted) {
      Navigator.of(context).maybePop();
    }
  }

  Future<void> _initMediaAnalyzers() async {
    _mediaVoiceAnalyzer = HeuristicVoiceEmotionAnalyzer();
    _mediaFaceAnalyzer = SimpleFaceEmotionAnalyzer();
    _mediaTextAnalyzer = SimpleTextEmotionAnalyzer();
    final results = await Future.wait([
      _mediaVoiceAnalyzer.initialize(),
      _mediaFaceAnalyzer.initialize(),
      _mediaTextAnalyzer.initialize(),
    ]);
    if (!mounted) return;
    setState(() {
      _mediaVoiceReady = results[0];
      _mediaFaceReady = results[1];
      _mediaTextReady = results[2];
    });
  }

  Future<void> _analyzeTextFromInput() async {
    if (_isTextAiAnalyzing || !_mediaTextReady) return;
    final text = _noteController.text.trim();
    if (text.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请先输入一些文字')));
      return;
    }

    setState(() => _isTextAiAnalyzing = true);
    try {
      final result = await _mediaTextAnalyzer.analyze(text);
      if (result != null && mounted) {
        await _handleAiResult(result, null);
      }
    } catch (_) {
      // 忽略文本识别异常，避免打断输入体验
    } finally {
      if (mounted) {
        setState(() => _isTextAiAnalyzing = false);
      } else {
        _isTextAiAnalyzing = false;
      }
    }
  }

  Future<void> _analyzeImageOnAdd(String imagePath) async {
    if (!_mediaFaceReady || _isMediaAiAnalyzing) return;
    _isMediaAiAnalyzing = true;
    try {
      final result = await _mediaFaceAnalyzer.analyze(imagePath);
      if (result != null && mounted) {
        await _handleAiResult(result, imagePath);
      }
    } catch (_) {
      // 媒体识别失败时不打断用户添加流程
    } finally {
      _isMediaAiAnalyzing = false;
    }
  }

  Future<void> _analyzeAudioOnAdd(String audioPath) async {
    if (!_mediaVoiceReady || _isMediaAiAnalyzing) return;
    _isMediaAiAnalyzing = true;
    try {
      final result = await _mediaVoiceAnalyzer.analyzeWithContext(
        audioPath,
        context: {'source': 'media_picker'},
      );
      if (result != null && mounted) {
        await _handleAiResult(result, audioPath);
      }
    } catch (_) {
      // 媒体识别失败时不打断用户添加流程
    } finally {
      _isMediaAiAnalyzing = false;
    }
  }

  Future<void> _loadMoods() async {
    final custom = await _dbService.getCustomEmotions();
    final records = await _dbService.getEmotionRecords();
    final parsedRecords = records.map((r) {
      try {
        return EmotionRecord.fromMap(r);
      } catch (_) {
        return null;
      }
    }).whereType<EmotionRecord>();
    if (mounted) {
      setState(() {
        _moods = MoodOptionUtils.merge(
          customLabels: custom,
          records: parsedRecords,
        );
      });
    }
  }

  Future<void> _loadSettings() async {
    try {
      final settings = await _dbService.getSettings();
      if (!mounted || settings == null) return;
      final appSettings = AppSettings.fromMap(settings);
      setState(() {
        _cycleMoodAnalysisEnabled = appSettings.cycleMoodAnalysisEnabled;
      });
    } catch (_) {
      // 设置读取失败不影响普通情绪记录。
    }
  }

  bool get _hasDraftContent {
    return _selectedMoodLabels.isNotEmpty ||
        _noteController.text.trim().isNotEmpty ||
        _selectedTrigger.isNotEmpty ||
        _bodyEnergy > 0 ||
        _bodySleep > 0 ||
        _bodyAppetite > 0 ||
        (_cycleMoodAnalysisEnabled &&
            (_menstrualStatus.isNotEmpty ||
                _cycleSymptoms.isNotEmpty ||
                _cycleFunctionImpact.isNotEmpty)) ||
        _imagePaths.isNotEmpty ||
        _audioPath != null ||
        _isTimeCapsule ||
        _aiEmotionResult != null;
  }

  void _onDraftChanged() {
    if (!mounted) return;
    setState(() {});
  }

  void _handleRecordScroll() {
    if (!_recordScrollController.hasClients || !mounted) return;
    final position = _recordScrollController.position;
    final isAtBottom = position.pixels >= (position.maxScrollExtent - 120);
    if (_isBottomSaveVisible != isAtBottom) {
      setState(() => _isBottomSaveVisible = isAtBottom);
    }
  }

  static const List<String> _negativeMoods = ['难过', '生气', '焦虑', '疲惫'];
  static const List<String> _triggerTags = ['工作', '家庭', '睡眠', '天气', '人际', '其他'];
  static const List<String> _menstrualStatusOptions = [
    '月经期',
    '卵泡期',
    '排卵期',
    '黄体期',
    '经前7天',
    '不确定',
  ];
  static const List<String> _cycleSymptomOptions = [
    '腹胀',
    '水肿',
    '头痛',
    '乳房胀痛',
    '疲惫',
    '睡眠变差',
    '食欲变化',
  ];
  static const List<String> _cycleImpactOptions = [
    '无明显影响',
    '工作学习受影响',
    '人际关系受影响',
    '日常活动减少',
  ];

  bool _isMoodSelected(String label) {
    return _selectedMood == label || _additionalMoods.contains(label);
  }

  List<String> get _selectedMoodLabels {
    return [if (_selectedMood.isNotEmpty) _selectedMood, ..._additionalMoods];
  }

  Map<String, dynamic>? _findMood(String label) {
    for (final mood in _moods) {
      if (mood['label'] == label) return mood;
    }
    return null;
  }

  String _emojiForMood(String label) {
    final mood = _findMood(label);
    final emoji = mood?['emoji'];
    return emoji is String && emoji.isNotEmpty ? emoji : '😐';
  }

  void _toggleMoodSelection(String label) {
    final isPrimary = _selectedMood == label;
    final isAdditional = _additionalMoods.contains(label);

    setState(() {
      if (isPrimary) {
        if (_additionalMoods.isNotEmpty) {
          _selectedMood = _additionalMoods.removeAt(0);
        } else {
          _selectedMood = '';
        }
      } else if (isAdditional) {
        _additionalMoods.remove(label);
      } else if (_selectedMood.isEmpty) {
        _selectedMood = label;
      } else {
        _additionalMoods.add(label);
      }
    });
  }

  void _setPrimaryMood(String label) {
    setState(() {
      _additionalMoods.remove(label);
      if (_selectedMood.isNotEmpty && _selectedMood != label) {
        _additionalMoods.remove(_selectedMood);
        _additionalMoods.insert(0, _selectedMood);
      }
      _selectedMood = label;
    });
  }

  void _attachAiMediaToDraft(AiEmotionResult result, String? mediaPath) {
    if (mediaPath == null || mediaPath.isEmpty) return;

    if (result.source == AiEmotionSource.voice.value) {
      _audioPath = mediaPath;
      return;
    }

    if (result.source == AiEmotionSource.face.value &&
        !_imagePaths.contains(mediaPath)) {
      _imagePaths = List<String>.from(_imagePaths)..add(mediaPath);
    }
  }

  /// 处理 AI 分析结果
  Future<void> _handleAiResult(
    AiEmotionResult result,
    String? mediaPath,
  ) async {
    setState(() {
      _aiEmotionResult = result;
      _attachAiMediaToDraft(result, mediaPath);
    });

    // 显示情绪推荐弹窗
    final accepted = await showEmotionRecommendation(context, result: result);

    if (accepted && mounted) {
      // 用户接受了 AI 推荐
      _setPrimaryMood(result.mood);
    }
  }

  Future<void> _saveRecord() async {
    if (_selectedMood.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请先选择至少 1 种心情，再保存记录')));
      return;
    }

    final mood = _findMood(_selectedMood);
    if (mood == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('当前情绪不可用，请重新选择后再试')));
      return;
    }
    final additionalMoodEntries = _additionalMoods
        .map(_findMood)
        .whereType<Map<String, dynamic>>()
        .toList();
    final record = EmotionRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      mood: mood['label'],
      emoji: (mood['emoji'] as String?) ?? _emojiForMood(_selectedMood),
      additionalMoods: List<String>.from(_additionalMoods),
      additionalEmojis: additionalMoodEntries
          .map((entry) => (entry['emoji'] as String?) ?? '😐')
          .toList(),
      note: _noteController.text,
      intensity: _intensity,
      createdAt: DateTime.now(),
      imagePaths: _imagePaths,
      audioPath: _audioPath,
      isTimeCapsule: _isTimeCapsule,
      unlockAt: _isTimeCapsule ? _unlockAt : null,
      triggerTag: _selectedTrigger,
      bodyEnergy: _bodyEnergy,
      bodySleep: _bodySleep,
      bodyAppetite: _bodyAppetite,
      menstrualStatus: _cycleMoodAnalysisEnabled ? _menstrualStatus : '',
      cycleSymptoms: _cycleMoodAnalysisEnabled
          ? List<String>.from(_cycleSymptoms)
          : const [],
      cycleFunctionImpact: _cycleMoodAnalysisEnabled
          ? _cycleFunctionImpact
          : '',
      // AI 情绪分析结果
      aiDetectedMood: _aiEmotionResult?.mood,
      aiDetectedEmoji: _aiEmotionResult?.emoji,
      aiConfidence: _aiEmotionResult?.confidence,
      aiSource: _aiEmotionResult?.source,
    );

    try {
      await _dbService.insertEmotionRecord(record.toMap());
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('保存失败：$e'), backgroundColor: Colors.red),
        );
      }
      return;
    }

    if (mounted) {
      final isNegative = _negativeMoods.contains(mood['label']);

      if (isNegative) {
        // 负面情绪：仅第一次提示去试试呼吸练习，之后只提示记录好了并自动关闭
        final prefs = await SharedPreferences.getInstance();
        final hasShownBreathingPrompt =
            prefs.getBool('breathing_prompt_after_record_shown') ?? false;

        void resetFormAndNotify() {
          _finishRecordSave();
        }

        if (!hasShownBreathingPrompt) {
          // 第一次：提示「想不想试试呼吸练习」+ 去试试/稍后
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: AppTheme.primaryColor,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '记录好了',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '想不想试试呼吸练习，放松一下？',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    await prefs.setBool(
                      'breathing_prompt_after_record_shown',
                      true,
                    );
                    if (!ctx.mounted) return;
                    Navigator.of(ctx).pop();
                    resetFormAndNotify();
                  },
                  child: const Text('稍后'),
                ),
                TextButton(
                  onPressed: () async {
                    await prefs.setBool(
                      'breathing_prompt_after_record_shown',
                      true,
                    );
                    if (!ctx.mounted) return;
                    Navigator.of(ctx).pop();
                    resetFormAndNotify();
                    if (!context.mounted) return;
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const BreathingExercisePage(),
                      ),
                    );
                  },
                  child: const Text('去试试'),
                ),
              ],
            ),
          );
        } else {
          // 之后：只提示记录好了，不确认、自动关闭
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: AppTheme.primaryColor,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '记录好了',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
          Future.delayed(const Duration(seconds: 1), () {
            if (!mounted) return;
            Navigator.of(context).pop();
            _finishRecordSave();
          });
        }
      } else {
        // 正面情绪：原有成功弹窗
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: AppTheme.primaryColor,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '记录成功！',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '今天的心情已保存',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                ],
              ),
            ),
          ),
        );

        Future.delayed(const Duration(seconds: 1), () {
          if (!mounted) return;
          Navigator.of(context).pop();
          _finishRecordSave();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: _recordScrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).padding.top + 8),
                    // 顶部关闭指示条和按钮
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.pageHorizontalPadding,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 48), // 占位保持居中
                          Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppTheme.textHint.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.close_rounded,
                              color: AppTheme.textSecondary,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.pageHorizontalPadding,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Text(
                          '此刻心情',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            '可多选，第一个为主情绪',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                            textAlign: TextAlign.right,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 116,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (var index = 0; index < _moods.length; index++)
                              Padding(
                                padding: EdgeInsets.only(
                                  right: index == _moods.length - 1 ? 0 : 12,
                                ),
                                child: SizedBox(
                                  width: 92,
                                  child: _buildMoodSelectionCard(
                                    _moods[index],
                                    _isMoodSelected(
                                      _moods[index]['label'] as String,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    if (_selectedMoodLabels.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _selectedMoodLabels.map((label) {
                          final isPrimary = label == _selectedMood;
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isPrimary
                                  ? AppTheme.primaryColor.withValues(
                                      alpha: 0.12,
                                    )
                                  : AppTheme.surfaceColor,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              '${_emojiForMood(label)} $label${isPrimary ? ' · 主情绪' : ''}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isPrimary
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: isPrimary
                                    ? AppTheme.primaryColor
                                    : AppTheme.textSecondary,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 22),
                    ],
                    if (_cycleMoodAnalysisEnabled) ...[
                      _buildCycleMoodSection(),
                      const SizedBox(height: 24),
                    ],
                    if (_selectedMoodLabels.isNotEmpty) ...[
                      const Text(
                        '情绪强度',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  '轻微',
                                  style: TextStyle(color: AppTheme.textHint),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryColor.withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '${_intensity.round()}%',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.primaryColor,
                                    ),
                                  ),
                                ),
                                const Text(
                                  '强烈',
                                  style: TextStyle(color: AppTheme.textHint),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Slider(
                              value: _intensity,
                              min: 0,
                              max: 100,
                              activeColor: AppTheme.primaryColor,
                              inactiveColor: AppTheme.surfaceColor,
                              onChanged: (value) {
                                setState(() {
                                  _intensity = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        '可能原因（可选）',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _triggerTags.map((tag) {
                          final isSelected = _selectedTrigger == tag;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedTrigger = isSelected ? '' : tag;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppTheme.primaryColor.withValues(
                                        alpha: 0.15,
                                      )
                                    : AppTheme.surfaceColor,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? AppTheme.primaryColor
                                      : Colors.transparent,
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                tag,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? AppTheme.primaryColor
                                      : AppTheme.textSecondary,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        '身体状态（可选）',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildBodyStateRow(
                        '精力',
                        _bodyEnergy,
                        (v) => setState(() => _bodyEnergy = v),
                      ),
                      const SizedBox(height: 8),
                      _buildBodyStateRow(
                        '睡眠',
                        _bodySleep,
                        (v) => setState(() => _bodySleep = v),
                      ),
                      const SizedBox(height: 8),
                      _buildBodyStateRow(
                        '食欲',
                        _bodyAppetite,
                        (v) => setState(() => _bodyAppetite = v),
                      ),
                      const SizedBox(height: 32),
                    ],
                    Row(
                      children: [
                        const Text(
                          '想说的话',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: (_mediaTextReady && !_isTextAiAnalyzing)
                              ? _analyzeTextFromInput
                              : null,
                          icon: _isTextAiAnalyzing
                              ? const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.text_fields, size: 16),
                          label: Text(_isTextAiAnalyzing ? '分析中' : '分析文字'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppTheme.primaryColor,
                            textStyle: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                            visualDensity: VisualDensity.compact,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller: _noteController,
                        maxLines: 5,
                        style: const TextStyle(fontSize: 15),
                        decoration: InputDecoration(
                          hintText: '写下此刻的想法...\n可以是开心的分享，也可以是烦恼的倾诉',
                          hintStyle: TextStyle(
                            color: AppTheme.textHint.withValues(alpha: 0.6),
                            height: 1.5,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(20),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),
                    const Text(
                      '添加媒体',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    MediaPicker(
                      imagePaths: _imagePaths,
                      audioPath: _audioPath,
                      onImageAdded: (path) async {
                        setState(() {
                          _imagePaths = List.from(_imagePaths)..add(path);
                        });
                        await _analyzeImageOnAdd(path);
                      },
                      onImageRemoved: (path) {
                        setState(() {
                          _imagePaths = List.from(_imagePaths)..remove(path);
                        });
                      },
                      onAudioChanged: (path) async {
                        setState(() {
                          _audioPath = path;
                        });
                        if (path != null) {
                          await _analyzeAudioOnAdd(path);
                        }
                      },
                    ),
                    const SizedBox(height: 32),

                    // 时光胶囊设置（简版）
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.lock_clock_outlined,
                                color: AppTheme.primaryColor,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                '时光胶囊（可选）',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _isTimeCapsule
                                ? (_unlockAt == null
                                      ? '已开启时光胶囊，请选择一个未来的解锁时间。'
                                      : '将于 ${_unlockAt!.year}年${_unlockAt!.month}月${_unlockAt!.day}日 ${_unlockAt!.hour.toString().padLeft(2, '0')}:${_unlockAt!.minute.toString().padLeft(2, '0')} 解锁。')
                                : '不开启时光胶囊时，这条记录会像普通日记一样随时可见。',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppTheme.textSecondary,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('将这条记录设为时光胶囊'),
                            subtitle: const Text(
                              '为未来的自己留一条心情小纸条。',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.textHint,
                              ),
                            ),
                            value: _isTimeCapsule,
                            onChanged: (value) {
                              setState(() {
                                _isTimeCapsule = value;
                                if (!value) {
                                  _unlockAt = null;
                                } else {
                                  _unlockAt ??= DateTime.now().add(
                                    const Duration(days: 7),
                                  );
                                }
                              });
                            },
                          ),
                          if (_isTimeCapsule) ...[
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton.icon(
                                onPressed: () async {
                                  final now = DateTime.now();
                                  final initial =
                                      _unlockAt ??
                                      now.add(const Duration(days: 7));
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: initial.isAfter(now)
                                        ? initial
                                        : now,
                                    firstDate: now,
                                    lastDate: now.add(
                                      const Duration(days: 365 * 3),
                                    ),
                                    builder: (context, child) => Theme(
                                      data: Theme.of(context).copyWith(
                                        platform: TargetPlatform.android,
                                      ),
                                      child: child!,
                                    ),
                                  );
                                  if (date == null) return;
                                  final time = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.fromDateTime(
                                      initial,
                                    ),
                                    helpText: '选择解锁时间',
                                    cancelText: '取消',
                                    confirmText: '确定',
                                    initialEntryMode: TimePickerEntryMode.dial,
                                    builder: (context, child) => Theme(
                                      data: Theme.of(context).copyWith(
                                        platform: TargetPlatform.android,
                                      ),
                                      child: child!,
                                    ),
                                  );
                                  if (time == null) return;
                                  setState(() {
                                    _unlockAt = DateTime(
                                      date.year,
                                      date.month,
                                      date.day,
                                      time.hour,
                                      time.minute,
                                    );
                                  });
                                },
                                icon: const Icon(Icons.lock_clock, size: 18),
                                label: const Text('选择解锁时间'),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // 保存按钮
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _saveRecord,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedMood.isNotEmpty
                              ? AppTheme.primaryColor
                              : AppTheme.primaryColor.withValues(alpha: 0.55),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          '保存记录',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    if (_selectedMood.isEmpty) ...[
                      const SizedBox(height: 8),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '必填：请先选择至少 1 种心情',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.secondaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 40),
                  ]),
                ),
              ),
            ],
          ),
          if (_hasDraftContent && !_isBottomSaveVisible)
            Positioned(
              right: 20,
              bottom: MediaQuery.of(context).padding.bottom + 20,
              child: FloatingActionButton(
                heroTag: 'record_save_fab',
                onPressed: _saveRecord,
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                elevation: 2,
                shape: const CircleBorder(),
                child: const Icon(Icons.check_rounded, size: 28),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBodyStateRow(
    String label,
    int value,
    ValueChanged<int> onChanged,
  ) {
    const options = [(0, '未选'), (1, '差'), (2, '一般'), (3, '好')];
    return Row(
      children: [
        SizedBox(
          width: 48,
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary),
          ),
        ),
        const SizedBox(width: 12),
        ...options.map((e) {
          final (v, text) = e;
          final isSelected = value == v;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onChanged(v),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primaryColor.withValues(alpha: 0.15)
                      : AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primaryColor
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: isSelected
                        ? AppTheme.primaryColor
                        : AppTheme.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCycleMoodSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.insights_rounded,
                  color: AppTheme.primaryColor,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  '周期线索（可选）',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            '用于分析情绪和生理周期的可能关联，不作为医学诊断。',
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textHint,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '周期阶段',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _menstrualStatusOptions.map((status) {
              return _buildCycleChip(
                label: status,
                selected: _menstrualStatus == status,
                onTap: () {
                  setState(() {
                    _menstrualStatus = _menstrualStatus == status ? '' : status;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Text(
            '身体症状',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _cycleSymptomOptions.map((symptom) {
              final selected = _cycleSymptoms.contains(symptom);
              return _buildCycleChip(
                label: symptom,
                selected: selected,
                onTap: () {
                  setState(() {
                    if (selected) {
                      _cycleSymptoms.remove(symptom);
                    } else {
                      _cycleSymptoms.add(symptom);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Text(
            '生活影响',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _cycleImpactOptions.map((impact) {
              return _buildCycleChip(
                label: impact,
                selected: _cycleFunctionImpact == impact,
                onTap: () {
                  setState(() {
                    _cycleFunctionImpact = _cycleFunctionImpact == impact
                        ? ''
                        : impact;
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCycleChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.primaryColor.withValues(alpha: 0.14)
              : AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? AppTheme.primaryColor : Colors.transparent,
            width: 1.3,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            color: selected ? AppTheme.primaryColor : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildMoodSelectionCard(Map<String, dynamic> mood, bool isSelected) {
    final label = mood['label'] as String;
    final color = mood['color'] as Color? ?? AppTheme.primaryColor;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: isSelected ? color.withValues(alpha: 0.2) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: isSelected ? 4 : 0,
        shadowColor: color.withValues(alpha: 0.3),
        child: InkWell(
          onTap: () => _toggleMoodSelection(label),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: isSelected ? 0.22 : 0.14),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    mood['emoji'] as String? ?? '🙂',
                    style: const TextStyle(fontSize: 25, height: 1),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: isSelected
                        ? AppTheme.textPrimary
                        : AppTheme.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 历史页 - 优化版
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key, this.refreshTrigger, this.onDeleteRecord});

  final ValueNotifier<int>? refreshTrigger;

  /// 删除某条记录后回调，用于切回「记录」页
  final VoidCallback? onDeleteRecord;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final DatabaseService _dbService = DatabaseService();
  List<EmotionRecord> _records = [];
  bool _isLoading = true;
  String _timeRange = 'week'; // all | week | month，默认本周减少首屏数据量
  String? _moodFilter;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _quickRecordController = TextEditingController();
  final FocusNode _quickRecordFocusNode = FocusNode();
  bool _isSavingQuickRecord = false;
  String _quickMood = '开心';
  static const double _recordDeleteActionWidth = 92;
  final Map<String, double> _recordSwipeOffsets = {};
  List<Map<String, dynamic>> _moodOptions = [];

  @override
  void initState() {
    super.initState();
    _loadRecords();
    widget.refreshTrigger?.addListener(_onRefreshTriggered);
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    widget.refreshTrigger?.removeListener(_onRefreshTriggered);
    _searchController.dispose();
    _quickRecordController.dispose();
    _quickRecordFocusNode.dispose();
    super.dispose();
  }

  List<EmotionRecord> get _filteredRecords {
    var list = List<EmotionRecord>.from(_records);
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    if (_timeRange == 'week') {
      final weekStart = todayStart.subtract(const Duration(days: 7));
      list = list.where((r) => r.createdAt.isAfter(weekStart)).toList();
    } else if (_timeRange == 'month') {
      final monthStart = todayStart.subtract(const Duration(days: 30));
      list = list.where((r) => r.createdAt.isAfter(monthStart)).toList();
    }
    if (_moodFilter != null) {
      list = list.where((r) => r.mood == _moodFilter).toList();
    }
    final q = _searchController.text.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((r) => r.note.toLowerCase().contains(q)).toList();
    }
    return list;
  }

  void _onRefreshTriggered() => _loadRecords();

  Future<void> _loadRecords({bool showLoading = true}) async {
    if (showLoading && mounted) {
      setState(() => _isLoading = true);
    }
    try {
      final records = await _dbService.getEmotionRecords();
      final customMoods = await _dbService.getCustomEmotions();
      final list = <EmotionRecord>[];
      for (final r in records) {
        try {
          list.add(EmotionRecord.fromMap(r));
        } catch (_) {
          // 跳过格式异常的单条，避免整页无记录
        }
      }
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      if (mounted) {
        setState(() {
          _records = list;
          _moodOptions = MoodOptionUtils.merge(
            customLabels: customMoods,
            records: _records,
          );
          if (!_moodOptions.any((m) => m['label'] == _quickMood)) {
            _quickMood = _moodOptions.isNotEmpty
                ? (_moodOptions.first['label'] as String)
                : '开心';
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _records = [];
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveQuickRecord() async {
    final note = _quickRecordController.text.trim();
    if (_isSavingQuickRecord) {
      return;
    }

    setState(() => _isSavingQuickRecord = true);
    final now = DateTime.now();
    final selectedMood = _moodOptions.firstWhere(
      (m) => m['label'] == _quickMood,
      orElse: () => <String, dynamic>{'label': _quickMood, 'emoji': '🙂'},
    );
    final record = EmotionRecord(
      id: 'quick_${now.microsecondsSinceEpoch}',
      mood: selectedMood['label'] as String,
      emoji: selectedMood['emoji'] as String? ?? '🙂',
      note: note,
      intensity: 45,
      createdAt: now,
    );

    try {
      await _dbService.insertEmotionRecord(record.toMap());
      _quickRecordController.clear();
      _quickRecordFocusNode.unfocus();
      await _loadRecords(showLoading: false);
      widget.refreshTrigger?.value++;
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('已快速记录'),
          duration: Duration(milliseconds: 900),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('保存失败：$e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() => _isSavingQuickRecord = false);
      } else {
        _isSavingQuickRecord = false;
      }
    }
  }

  Future<void> _deleteRecord(String id) async {
    await _dbService.deleteEmotionRecord(id);
    _loadRecords();
  }

  /// 按日期分组：同一天的记录放一起，日期新的在前，当天内后记录的在前
  Map<DateTime, List<EmotionRecord>> _groupRecordsByDate() {
    final Map<DateTime, List<EmotionRecord>> map = {};
    for (final r in _filteredRecords) {
      final d = DateTime(r.createdAt.year, r.createdAt.month, r.createdAt.day);
      (map[d] ??= []).add(r);
    }
    for (final list in map.values) {
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
    final sortedEntries = map.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));
    return Map.fromEntries(sortedEntries);
  }

  int _groupedListLength() {
    final grouped = _groupRecordsByDate();
    int len = 0;
    for (final list in grouped.values) {
      len += 1 + list.length;
      if (list.length > 1) len += 1; // 当日情绪走势一行
    }
    return len;
  }

  Widget _buildDateHeader(DateTime date, int count) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(date.year, date.month, date.day);
    String title;
    if (d == today) {
      title = '今天';
    } else if (d == today.subtract(const Duration(days: 1))) {
      title = '昨天';
    } else {
      const weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
      title = '${date.month}月${date.day}日 ${weekdays[date.weekday - 1]}';
    }
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 4),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(width: 8),
          // Mock weather icon, since real weather isn't tracked yet
          const Icon(
            Icons.wb_sunny_outlined,
            size: 18,
            color: Color(0xFFFF9800),
          ),
        ],
      ),
    );
  }

  /// 当日多条记录时展示情绪走势：开心 • 焦虑 • 平静
  Widget _buildDayMoodFlow(List<EmotionRecord> dayRecords) {
    final ordered = List<EmotionRecord>.from(dayRecords)
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Wrap(
        spacing: 6,
        runSpacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          for (int i = 0; i < ordered.length; i++) ...[
            if (i > 0)
              Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: AppTheme.textHint,
                  shape: BoxShape.circle,
                ),
              ),
            Text(
              ordered[i].mood,
              style: TextStyle(
                fontSize: 12,
                color:
                    AppTheme.moodColors[ordered[i].mood] ??
                    AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _cycleSummaryForRecord(EmotionRecord record) {
    final parts = <String>[
      if (record.menstrualStatus.isNotEmpty) record.menstrualStatus,
      ...record.cycleSymptoms.take(2),
      if (record.cycleFunctionImpact.isNotEmpty &&
          record.cycleFunctionImpact != '无明显影响')
        record.cycleFunctionImpact,
    ];
    return parts.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    final safeTop = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        children: [
          // ── 最底层：插画背景（fitWidth 不裁剪，渐变完整显示）──
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/bg_shiguang.png',
              fit: BoxFit.fitWidth,
              alignment: Alignment.topRight,
            ),
          ),
          // ── 上层：可滚动内容 ──
          CustomScrollView(
            slivers: [
              // 透明占位 AppBar（仅放标题和头像）
              SliverAppBar(
                floating: false,
                pinned: false,
                expandedHeight: safeTop + PrimaryPageLayout.headerHeightOffset,
                toolbarHeight: 0,
                elevation: 0,
                shadowColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                forceMaterialTransparency: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: PrimaryPageHeader(
                    safeTop: safeTop,
                    title: '时光',
                    subtitle: '记录心情，遇见更好的自己',
                    titleColor: AppTheme.textPrimary,
                    subtitleColor: AppTheme.textSecondary.withValues(
                      alpha: 0.9,
                    ),
                    trailing: Material(
                      color: Colors.white,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const StatsPage(
                                mode: StatsPageMode.moodStats,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF6E9F76,
                                ).withValues(alpha: 0.2),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.insights_rounded,
                              size: 27,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // 统计概览卡：负 margin 上移，盖住插画底部
              SliverToBoxAdapter(
                child: _buildHomeContentShell(
                  SizedBox(
                    height: 74,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          left: 0,
                          right: 0,
                          top: -8,
                          child: _buildHistoryOverviewCards(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (_isLoading)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryColor,
                    ),
                  ),
                )
              else ...[
                SliverToBoxAdapter(child: _buildMoodDrawEntry()),
                SliverToBoxAdapter(child: _buildQuickRecordInput()),
                SliverToBoxAdapter(child: _buildHistoryFilters()),
                if (_records.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox,
                            size: 80,
                            color: AppTheme.textHint.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            '还没有记录',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppTheme.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '先去首页写一条心情试试吧～',
                            style: TextStyle(color: AppTheme.textHint),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (_filteredRecords.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.filter_list_off,
                            size: 64,
                            color: AppTheme.textHint.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            '没有符合条件的记录',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '试试调整筛选或搜索',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.textHint,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppTheme.pageHorizontalPadding,
                      0,
                      AppTheme.pageHorizontalPadding,
                      20,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final grouped = _groupRecordsByDate();
                        int offset = 0;
                        for (final entry in grouped.entries) {
                          final date = entry.key;
                          final dayRecords = entry.value;
                          if (index == offset) {
                            return _buildDateHeader(date, dayRecords.length);
                          }
                          offset++;
                          if (dayRecords.length > 1 && index == offset) {
                            return _buildDayMoodFlow(dayRecords);
                          }
                          if (dayRecords.length > 1) offset++;
                          if (index < offset + dayRecords.length) {
                            return _buildRecordCard(
                              dayRecords[index - offset],
                              showTime: dayRecords.length > 1,
                            );
                          }
                          offset += dayRecords.length;
                        }
                        return const SizedBox.shrink();
                      }, childCount: _groupedListLength()),
                    ),
                  ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContentShell(Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.pageHorizontalPadding,
      ),
      child: Align(alignment: Alignment.centerLeft, child: child),
    );
  }

  Widget _buildHistoryOverviewCards() {
    final days = _records
        .map(
          (r) => DateTime(r.createdAt.year, r.createdAt.month, r.createdAt.day),
        )
        .toSet()
        .length;
    final longestStreak = _calcLongestStreak(_records);
    // 连续记录: 算当前的 streak (如果是今天或者昨天记录过，算连续)
    int currentStreak = 0;
    if (_records.isNotEmpty) {
      final sortedDays =
          _records
              .map(
                (r) => DateTime(
                  r.createdAt.year,
                  r.createdAt.month,
                  r.createdAt.day,
                ),
              )
              .toSet()
              .toList()
            ..sort((a, b) => b.compareTo(a)); // desc
      final today = DateTime.now();
      final todayMidnight = DateTime(today.year, today.month, today.day);

      if (sortedDays.first == todayMidnight ||
          sortedDays.first == todayMidnight.subtract(const Duration(days: 1))) {
        currentStreak = 1;
        for (int i = 0; i < sortedDays.length - 1; i++) {
          if (sortedDays[i].difference(sortedDays[i + 1]).inDays == 1) {
            currentStreak++;
          } else {
            break;
          }
        }
      }
    }

    Widget buildStat(String title, int value, Color color) {
      return Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$value天',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    Widget divider() {
      return Container(
        width: 1,
        height: 30,
        color: AppTheme.surfaceColor.withValues(alpha: 0.9),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          buildStat('记录天数', days, const Color(0xFF5F9869)),
          divider(),
          buildStat('连续记录', currentStreak, const Color(0xFFE48B61)),
          divider(),
          buildStat('坚持时光', longestStreak, const Color(0xFFE3AA35)),
        ],
      ),
    );
  }

  int _calcLongestStreak(List<EmotionRecord> records) {
    if (records.isEmpty) return 0;
    final days =
        records
            .map(
              (r) => DateTime(
                r.createdAt.year,
                r.createdAt.month,
                r.createdAt.day,
              ),
            )
            .toSet()
            .toList()
          ..sort();
    int longest = 1;
    int current = 1;
    for (var i = 1; i < days.length; i++) {
      final diff = days[i].difference(days[i - 1]).inDays;
      if (diff == 1) {
        current += 1;
      } else if (diff > 1) {
        if (current > longest) longest = current;
        current = 1;
      }
    }
    if (current > longest) longest = current;
    return longest;
  }

  Widget _buildQuickRecordInput() {
    return _buildHomeContentShell(
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.94),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.025),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      '心情快速记录',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              LayoutBuilder(
                builder: (context, constraints) {
                  final itemWidth = math.min(76.0, constraints.maxWidth / 4.6);
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (final entry in _moodOptions) ...[
                          SizedBox(
                            width: itemWidth,
                            child: _buildQuickMoodOption(
                              entry,
                              _quickMood == entry['label'],
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: AppTheme.textHint.withValues(alpha: 0.08),
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 14),
                    Icon(
                      Icons.edit_rounded,
                      size: 19,
                      color: AppTheme.primaryColor.withValues(alpha: 0.78),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: TextField(
                        controller: _quickRecordController,
                        focusNode: _quickRecordFocusNode,
                        minLines: 1,
                        maxLines: 3,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _saveQuickRecord(),
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppTheme.textPrimary,
                          height: 1.35,
                        ),
                        decoration: InputDecoration(
                          hintText: '记录此刻的想法...',
                          hintStyle: TextStyle(
                            color: AppTheme.textHint.withValues(alpha: 0.82),
                            fontSize: 14,
                          ),
                          filled: false,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _quickRecordController,
                        builder: (context, value, _) {
                          final canSave = !_isSavingQuickRecord;
                          return FilledButton(
                            onPressed: canSave ? _saveQuickRecord : null,
                            style: FilledButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                              disabledBackgroundColor: AppTheme.primaryColor
                                  .withValues(alpha: 0.38),
                              foregroundColor: Colors.white,
                              disabledForegroundColor: Colors.white.withValues(
                                alpha: 0.72,
                              ),
                              minimumSize: const Size(74, 38),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(19),
                              ),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: _isSavingQuickRecord
                                ? const SizedBox(
                                    width: 15,
                                    height: 15,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    '保存',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickMoodOption(Map<String, dynamic> mood, bool selected) {
    final label = mood['label'] as String? ?? '';
    final emoji = mood['emoji'] as String? ?? '😐';
    final color = mood['color'] as Color? ?? AppTheme.primaryColor;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => setState(() => _quickMood = label),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: color.withValues(alpha: selected ? 0.25 : 0.14),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selected
                      ? color.withValues(alpha: 0.48)
                      : Colors.white.withValues(alpha: 0.7),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 27, height: 1),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                color: selected ? AppTheme.textPrimary : AppTheme.textSecondary,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodDrawEntry() {
    return _buildHomeContentShell(
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Material(
          color: const Color(0xFFFFFCF4),
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const MoodBottlePage()));
            },
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFFE9C78C).withValues(alpha: 0.28),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE4B8).withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.style_rounded,
                      color: Color(0xFFC0762B),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 13),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '抽一张心情片',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 2),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppTheme.textHint,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryFilters() {
    return _buildHomeContentShell(
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: '搜索记录内容、心情关键词...',
                  hintStyle: TextStyle(color: AppTheme.textHint, fontSize: 14),
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppTheme.textHint,
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                style: const TextStyle(fontSize: 14),
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildMoodChip(
                    '全部',
                    _timeRange == 'all',
                    () => setState(() => _timeRange = 'all'),
                  ),
                  const SizedBox(width: 8),
                  _buildMoodChip(
                    '本周',
                    _timeRange == 'week',
                    () => setState(() => _timeRange = 'week'),
                  ),
                  const SizedBox(width: 8),
                  _buildMoodChip(
                    '本月',
                    _timeRange == 'month',
                    () => setState(() => _timeRange = 'month'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildMoodChip(
                    '全部',
                    _moodFilter == null,
                    () => setState(() => _moodFilter = null),
                  ),
                  ..._moodOptions.map(
                    (m) => Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: _buildMoodChip(
                        m['label'] as String,
                        _moodFilter == m['label'],
                        () => setState(
                          () => _moodFilter = _moodFilter == m['label']
                              ? null
                              : m['label'] as String,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodChip(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF6E9F76) // Dark green from mockup
              : const Color(0xFFF5F7F5), // Light grey
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? Colors.white : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildRecordCard(EmotionRecord record, {bool showTime = false}) {
    final offset = (_recordSwipeOffsets[record.id] ?? 0.0)
        .clamp(-_recordDeleteActionWidth, 0.0)
        .toDouble();

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.zero,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEAEA),
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    if (mounted) {
                      _deleteRecord(record.id);
                      widget.onDeleteRecord?.call();
                      setState(() {
                        _recordSwipeOffsets.remove(record.id);
                        _loadRecords();
                      });
                    }
                  },
                  child: const SizedBox(
                    width: 80,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delete_outline, color: Colors.red, size: 24),
                        SizedBox(height: 4),
                        Text(
                          '删除',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            transform: Matrix4.translationValues(offset, 0, 0),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onHorizontalDragStart: (_) {
                if (_recordSwipeOffsets.length <= 1 &&
                    _recordSwipeOffsets.containsKey(record.id)) {
                  return;
                }
                setState(() {
                  _recordSwipeOffsets.removeWhere((key, _) => key != record.id);
                });
              },
              onHorizontalDragUpdate: (details) {
                final current = (_recordSwipeOffsets[record.id] ?? 0.0);
                final next = (current + details.delta.dx)
                    .clamp(-_recordDeleteActionWidth, 0.0)
                    .toDouble();
                setState(() => _recordSwipeOffsets[record.id] = next);
              },
              onHorizontalDragEnd: (_) {
                final current = (_recordSwipeOffsets[record.id] ?? 0.0);
                final shouldOpen = current <= -_recordDeleteActionWidth * 0.45;
                setState(() {
                  _recordSwipeOffsets[record.id] = shouldOpen
                      ? -_recordDeleteActionWidth
                      : 0.0;
                });
              },
              child: InkWell(
                onTap: () async {
                  final current = (_recordSwipeOffsets[record.id] ?? 0);
                  if (current < 0) {
                    setState(() => _recordSwipeOffsets[record.id] = 0);
                    return;
                  }
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => RecordDetailPage(
                        record: record,
                        onDeleted: widget.onDeleteRecord,
                      ),
                    ),
                  );
                  if (mounted) _loadRecords();
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      margin: EdgeInsets.zero,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 30,
                                      height: 30,
                                      margin: const EdgeInsets.only(right: 8),
                                      decoration: BoxDecoration(
                                        color: AppTheme.surfaceColor,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        record.emoji,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          height: 1,
                                        ),
                                      ),
                                    ),
                                    // Mood Chip
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            (AppTheme.moodColors[record.mood] ??
                                                    AppTheme.primaryColor)
                                                .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        record.mood,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color:
                                              AppTheme.moodColors[record
                                                  .mood] ??
                                              AppTheme.textSecondary,
                                        ),
                                      ),
                                    ),
                                    // First Category Chip
                                    if (record.additionalMoods.isNotEmpty) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppTheme.surfaceColor,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          record.additionalMoods.first,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: AppTheme.textHint,
                                          ),
                                        ),
                                      ),
                                    ],
                                    const Spacer(),
                                    Text(
                                      showTime
                                          ? '${record.createdAt.hour.toString().padLeft(2, '0')}:${record.createdAt.minute.toString().padLeft(2, '0')}'
                                          : _formatDate(record.createdAt),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.textHint,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  record.note.isNotEmpty ? record.note : '快速记录',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: record.note.isNotEmpty
                                        ? AppTheme.textPrimary
                                        : AppTheme.textHint,
                                    height: 1.4,
                                  ),
                                ),
                                if (_cycleSummaryForRecord(
                                  record,
                                ).isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryColor.withValues(
                                        alpha: 0.08,
                                      ),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_month_outlined,
                                          size: 14,
                                          color: AppTheme.primaryColor,
                                        ),
                                        const SizedBox(width: 5),
                                        Expanded(
                                          child: Text(
                                            _cycleSummaryForRecord(record),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: AppTheme.primaryColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                if (record.audioPath != null) ...[
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryColor.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.mic,
                                          size: 14,
                                          color: AppTheme.primaryColor,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          '语音',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppTheme.primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          if (record.imagePaths.isNotEmpty) ...[
                            const SizedBox(width: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(record.imagePaths.first),
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 60,
                                  height: 60,
                                  color: AppTheme.surfaceColor,
                                  child: const Icon(
                                    Icons.image_not_supported,
                                    size: 20,
                                    color: AppTheme.textHint,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateToCheck = DateTime(date.year, date.month, date.day);

    if (dateToCheck == today) {
      return '今天 ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (dateToCheck == today.subtract(const Duration(days: 1))) {
      return '昨天 ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.month}月${date.day}日';
    }
  }
}

// 记录详情页
// 编辑记录页
// 情绪小测试页
enum AssessmentEntryMode { all, personalityOnly }

enum _DraftResumeAction { resume, restart }

class _AssessmentProgressDraft {
  final String assessmentId;
  final int currentStep;
  final int visibleQuestionCount;
  final DateTime updatedAt;
  final Map<String, int> answersByQuestionId;

  const _AssessmentProgressDraft({
    required this.assessmentId,
    required this.currentStep,
    required this.visibleQuestionCount,
    required this.updatedAt,
    required this.answersByQuestionId,
  });

  int get answeredCount => answersByQuestionId.length;

  Map<String, dynamic> toMap() {
    return {
      'assessmentId': assessmentId,
      'currentStep': currentStep,
      'visibleQuestionCount': visibleQuestionCount,
      'updatedAt': updatedAt.toIso8601String(),
      'answersByQuestionId': answersByQuestionId,
    };
  }

  static _AssessmentProgressDraft? fromMap(Map<String, dynamic> map) {
    final assessmentId = map['assessmentId']?.toString() ?? '';
    if (assessmentId.isEmpty) return null;

    final answers = <String, int>{};
    final rawAnswers = map['answersByQuestionId'];
    if (rawAnswers is Map) {
      for (final entry in rawAnswers.entries) {
        final key = entry.key.toString();
        if (key.isEmpty) continue;
        final rawValue = entry.value;
        final score = rawValue is num
            ? rawValue.toInt()
            : int.tryParse(rawValue?.toString() ?? '');
        if (score != null) {
          answers[key] = score;
        }
      }
    }

    final currentStep = map['currentStep'] is num
        ? (map['currentStep'] as num).toInt()
        : int.tryParse(map['currentStep']?.toString() ?? '') ?? 0;
    final visibleQuestionCount = map['visibleQuestionCount'] is num
        ? (map['visibleQuestionCount'] as num).toInt()
        : int.tryParse(map['visibleQuestionCount']?.toString() ?? '') ?? 0;
    final updatedAt =
        DateTime.tryParse(map['updatedAt']?.toString() ?? '') ??
        DateTime.fromMillisecondsSinceEpoch(0);

    return _AssessmentProgressDraft(
      assessmentId: assessmentId,
      currentStep: currentStep < 0 ? 0 : currentStep,
      visibleQuestionCount: visibleQuestionCount < 0 ? 0 : visibleQuestionCount,
      updatedAt: updatedAt,
      answersByQuestionId: answers,
    );
  }
}

class EmotionTestPage extends StatefulWidget {
  final String? initialAssessmentId;
  final AssessmentEntryMode entryMode;

  const EmotionTestPage({
    super.key,
    this.initialAssessmentId,
    this.entryMode = AssessmentEntryMode.all,
  });

  @override
  State<EmotionTestPage> createState() => _EmotionTestPageState();
}

class _EmotionTestPageState extends State<EmotionTestPage> {
  static const String _assessmentDraftKeyPrefix = 'assessment_draft_v1_';

  MentalAssessmentDefinition? _selectedAssessment;
  int _currentStep = 0;
  final Map<String, int> _answersByQuestionId = {};
  final Map<String, _AssessmentProgressDraft> _draftsByAssessmentId = {};
  final DatabaseService _dbService = DatabaseService();
  List<AssessmentResult> _pastResults = [];
  bool _showAssessmentEntry = true;
  bool _initialDraftPromptHandled = false;

  @override
  void initState() {
    super.initState();
    final initialAssessmentId = widget.initialAssessmentId;
    if (initialAssessmentId != null) {
      _selectedAssessment = AssessmentCatalog.findById(initialAssessmentId);
    }
    _loadPastResults();
    _loadAssessmentDrafts();
  }

  Future<void> _loadPastResults() async {
    final list = await _dbService.getTestResults();
    if (!mounted) return;
    setState(() {
      _pastResults = list.map(AssessmentResult.fromMap).toList();
    });
  }

  String _draftKey(String assessmentId) {
    return '$_assessmentDraftKeyPrefix$assessmentId';
  }

  Future<void> _loadAssessmentDrafts() async {
    final entries = await _dbService.getDataEntriesByPrefix(
      _assessmentDraftKeyPrefix,
    );
    final parsed = <String, _AssessmentProgressDraft>{};
    for (final value in entries.values) {
      if (value is! Map) continue;
      final draft = _AssessmentProgressDraft.fromMap(
        Map<String, dynamic>.from(value),
      );
      if (draft == null) continue;
      if (draft.answersByQuestionId.isEmpty) continue;
      parsed[draft.assessmentId] = draft;
    }
    if (!mounted) return;
    setState(() {
      _draftsByAssessmentId
        ..clear()
        ..addAll(parsed);
    });

    if (!_initialDraftPromptHandled && widget.initialAssessmentId != null) {
      final selected = _selectedAssessment;
      if (selected != null &&
          _draftsByAssessmentId[selected.id]?.answersByQuestionId.isNotEmpty ==
              true) {
        _initialDraftPromptHandled = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _startAssessment(selected);
        });
      }
    }
  }

  Future<void> _clearAssessmentDraft(String assessmentId) async {
    _draftsByAssessmentId.remove(assessmentId);
    if (mounted) setState(() {});
    await _dbService.removeData(_draftKey(assessmentId));
  }

  Future<bool> _persistCurrentProgress({bool allowEmpty = false}) async {
    final definition = _selectedAssessment;
    if (definition == null) return false;
    if (_answersByQuestionId.isEmpty && !allowEmpty) return false;

    final visibleQuestions = definition.visibleQuestions(_answersByQuestionId);
    final visibleCount = visibleQuestions.isEmpty ? 0 : visibleQuestions.length;
    final draft = _AssessmentProgressDraft(
      assessmentId: definition.id,
      currentStep: _currentStep < 0 ? 0 : _currentStep,
      visibleQuestionCount: visibleCount,
      updatedAt: DateTime.now(),
      answersByQuestionId: Map<String, int>.from(_answersByQuestionId),
    );
    _draftsByAssessmentId[definition.id] = draft;
    await _dbService.saveData(_draftKey(definition.id), draft.toMap());
    return true;
  }

  void _resumeAssessmentFromDraft(
    MentalAssessmentDefinition definition,
    _AssessmentProgressDraft draft,
  ) {
    final restoredAnswers = Map<String, int>.from(draft.answersByQuestionId);
    final visible = definition.visibleQuestions(restoredAnswers);
    final maxStep = visible.isEmpty ? 0 : visible.length - 1;
    final restoredStep = draft.currentStep.clamp(0, maxStep);

    setState(() {
      _selectedAssessment = definition;
      _currentStep = restoredStep;
      _answersByQuestionId
        ..clear()
        ..addAll(restoredAnswers);
    });
  }

  String _formatDraftTime(DateTime time) {
    return '${time.month}月${time.day}日 '
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Future<_DraftResumeAction?> _showDraftResumeDialog(
    MentalAssessmentDefinition definition,
    _AssessmentProgressDraft draft,
  ) async {
    final visibleCount = draft.visibleQuestionCount > 0
        ? draft.visibleQuestionCount
        : definition.visibleQuestions(draft.answersByQuestionId).length;
    final answeredCount = draft.answeredCount;
    final safeTotal = visibleCount > 0
        ? visibleCount
        : definition.questions.length;
    final safeAnswered = answeredCount > safeTotal ? safeTotal : answeredCount;

    return showDialog<_DraftResumeAction>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('检测到未完成测试'),
          content: Text(
            '「${definition.name}」已答 $safeAnswered/$safeTotal 题\n'
            '保存时间：${_formatDraftTime(draft.updatedAt)}\n\n'
            '请选择继续作答，或重新开始。',
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(_DraftResumeAction.restart),
              child: const Text('重新开始'),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.of(context).pop(_DraftResumeAction.resume),
              child: const Text('继续作答'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveProgressManually() async {
    final saved = await _persistCurrentProgress(allowEmpty: false);
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(saved ? '进度已保存' : '请先回答至少 1 题再保存')));
  }

  Future<void> _startAssessment(MentalAssessmentDefinition definition) async {
    final existingDraft = _draftsByAssessmentId[definition.id];
    if (existingDraft != null && existingDraft.answersByQuestionId.isNotEmpty) {
      final action = await _showDraftResumeDialog(definition, existingDraft);
      if (!mounted || action == null) return;
      if (action == _DraftResumeAction.resume) {
        _resumeAssessmentFromDraft(definition, existingDraft);
        return;
      }
      await _clearAssessmentDraft(definition.id);
      if (!mounted) return;
    }

    setState(() {
      _selectedAssessment = definition;
      _currentStep = 0;
      _answersByQuestionId.clear();
    });
  }

  void _backToAssessmentList({bool saveDraft = true}) {
    if (saveDraft) {
      _persistCurrentProgress();
    }
    if (widget.initialAssessmentId != null) {
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _selectedAssessment = null;
      _currentStep = 0;
      _answersByQuestionId.clear();
    });
    _loadPastResults();
  }

  void _choose(AssessmentOption option) {
    final definition = _selectedAssessment;
    if (definition == null) return;
    final visibleBefore = definition.visibleQuestions(_answersByQuestionId);
    if (_currentStep >= visibleBefore.length) return;

    final currentQuestion = visibleBefore[_currentStep];
    var shouldShowResult = false;
    setState(() {
      _answersByQuestionId[currentQuestion.id] = option.score;
      final visibleAfter = definition.visibleQuestions(_answersByQuestionId);
      if (_currentStep < visibleAfter.length - 1) {
        _currentStep++;
      } else {
        shouldShowResult = true;
      }
    });
    if (shouldShowResult) {
      _showResult();
    } else {
      _persistCurrentProgress();
    }
  }

  Future<void> _showResult() async {
    final definition = _selectedAssessment;
    if (definition == null) return;

    final orderedAnswers = definition
        .visibleQuestions(_answersByQuestionId)
        .map((question) => _answersByQuestionId[question.id] ?? 0)
        .toList(growable: false);
    final result = definition.evaluateByQuestionId(
      _answersByQuestionId,
      answersInDisplayOrder: orderedAnswers,
    );
    await _clearAssessmentDraft(definition.id);
    await _dbService.addTestResult(result.toMap());

    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TestResultDetailPage(record: result.toMap()),
      ),
    );
    if (!mounted) return;
    _backToAssessmentList(saveDraft: false);
  }

  Future<void> _confirmDeleteAssessmentResult(AssessmentResult result) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('删除评测记录'),
          content: Text('确定删除「${result.assessmentName}」这条记录吗？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: AppTheme.errorColor),
              child: const Text('删除'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) return;

    await _dbService.deleteTestResult(
      assessmentId: result.assessmentId,
      createdAt: result.createdAt,
    );
    await _loadPastResults();
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('评测记录已删除')));
  }

  @override
  Widget build(BuildContext context) {
    final isDoingAssessment = _selectedAssessment != null;
    final showingAssessmentList = _showAssessmentEntry;
    final canPopToParent = !isDoingAssessment && showingAssessmentList;

    return PopScope(
      canPop: canPopToParent,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) return;
        if (isDoingAssessment) {
          _backToAssessmentList();
        } else if (!showingAssessmentList) {
          setState(() => _showAssessmentEntry = true);
        }
      },
      child: isDoingAssessment
          ? _buildQuestionScaffold()
          : _buildAssessmentListScaffold(),
    );
  }

  Widget _buildAssessmentListScaffold() {
    final hasRecords = _pastResults.isNotEmpty;
    final showingRecords = hasRecords && !_showAssessmentEntry;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.textPrimary),
          onPressed: () {
            if (showingRecords) {
              setState(() => _showAssessmentEntry = true);
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        title: Text(
          widget.entryMode == AssessmentEntryMode.personalityOnly
              ? '性格评测'
              : '心理评测',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        actions: [
          if (hasRecords && _showAssessmentEntry)
            TextButton(
              onPressed: () => setState(() => _showAssessmentEntry = false),
              child: const Text('记录'),
            ),
        ],
      ),
      body: SafeArea(
        child: showingRecords ? _buildRecordListView() : _buildAssessmentList(),
      ),
    );
  }

  Widget _buildAssessmentList() {
    if (widget.entryMode == AssessmentEntryMode.personalityOnly) {
      return ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.pageHorizontalPadding,
          vertical: 16,
        ),
        children: [
          const SizedBox(height: 8),
          const Text(
            '性格探索',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '包含 MBTI（快速/完整/进阶/专业）与 SBTI 风格探索，并整合依恋风格 / 大五 / 九型等测评。',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textHint,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          _buildUnfinishedDraftReminderCard(),
          const SizedBox(height: 24),
          if (AssessmentCatalog.personalityAssessments.isNotEmpty)
            _buildPersonalityAssessmentGroup(),
          const SizedBox(height: 24),
          _buildSelfReflectionAssessmentGroup(includeOtherAssessments: false),
        ],
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.pageHorizontalPadding,
        vertical: 16,
      ),
      children: [
        const SizedBox(height: 8),
        const Text(
          '先做筛查，再做自我探索',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '标准化筛查适合判断风险层级；性格探索包含 SBTI、MBTI 与依恋风格/大五/九型等测评。所有结果仅供参考，不代替诊断。',
          style: TextStyle(fontSize: 14, color: AppTheme.textHint, height: 1.5),
        ),
        const SizedBox(height: 16),
        _buildUnfinishedDraftReminderCard(),
        const SizedBox(height: 24),
        _buildStandardizedAssessmentGroup(),
        if (AssessmentCatalog.personalityAssessments.isNotEmpty) ...[
          const SizedBox(height: 24),
          _buildPersonalityAssessmentGroup(),
        ],
        const SizedBox(height: 24),
        _buildSelfReflectionAssessmentGroup(),
      ],
    );
  }

  Widget _buildUnfinishedDraftReminderCard() {
    if (_draftsByAssessmentId.isEmpty) return const SizedBox.shrink();

    final drafts = _draftsByAssessmentId.values.toList(growable: false)
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    final draftItems =
        <MapEntry<_AssessmentProgressDraft, MentalAssessmentDefinition>>[];
    for (final item in drafts) {
      if (!_shouldShowDraftInCurrentEntry(item.assessmentId)) continue;
      final found = AssessmentCatalog.findById(item.assessmentId);
      if (found == null) continue;
      draftItems.add(MapEntry(item, found));
    }
    if (draftItems.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2C88E), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '你有未完成的测试',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '共 ${draftItems.length} 个未完成进度，可分别继续或重开。',
            style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 10),
          ...draftItems.asMap().entries.map((entry) {
            final index = entry.key;
            final draft = entry.value.key;
            final definition = entry.value.value;
            final total = draft.visibleQuestionCount > 0
                ? draft.visibleQuestionCount
                : definition.visibleQuestions(draft.answersByQuestionId).length;
            final safeTotal = total > 0 ? total : definition.questions.length;
            final answered = draft.answeredCount > safeTotal
                ? safeTotal
                : draft.answeredCount;

            return Padding(
              padding: EdgeInsets.only(
                bottom: index == draftItems.length - 1 ? 0 : 10,
              ),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.78),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE8D6A9), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      definition.name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '已答 $answered/$safeTotal 题 · 上次保存：${_formatDraftTime(draft.updatedAt)}',
                      style: TextStyle(fontSize: 12, color: AppTheme.textHint),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              await _clearAssessmentDraft(definition.id);
                              if (!mounted) return;
                              await _startAssessment(definition);
                            },
                            child: const Text('重新开始'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FilledButton(
                            onPressed: () =>
                                _resumeAssessmentFromDraft(definition, draft),
                            child: const Text('继续作答'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStandardizedAssessmentGroup() {
    final standardized = AssessmentCatalog.standardizedScreeners;
    final phqAssessments = standardized
        .where((assessment) => assessment.id.startsWith('phq'))
        .toList(growable: false);
    final gadAssessments = standardized
        .where((assessment) => assessment.id.startsWith('gad'))
        .toList(growable: false);
    final adhdAssessments = standardized
        .where((assessment) => assessment.id.startsWith('adhd_'))
        .toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '标准化筛查',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '按问题类型选择筛查，再决定快速版或完整版',
          style: TextStyle(fontSize: 13, color: AppTheme.textHint, height: 1.4),
        ),
        const SizedBox(height: 12),
        if (phqAssessments.isNotEmpty)
          _buildTierEntryCard(
            emoji: '🌧',
            title: '抑郁筛查',
            subtitle: '近两周低落、兴趣下降、精力变化',
            recommendedTag: '推荐 PHQ-9',
            tierCountLabel: '2 个版本',
            assessments: phqAssessments,
            recommendedAssessmentId: 'phq9',
            pickerTitle: '选择抑郁筛查版本',
            pickerSubtitle: '不确定时直接做 PHQ-9，信息更完整。',
            tierTagResolver: _phqTierTag,
          ),
        if (gadAssessments.isNotEmpty)
          _buildTierEntryCard(
            emoji: '🫧',
            title: '焦虑筛查',
            subtitle: '近两周紧张、担忧、难以放松',
            recommendedTag: '推荐 GAD-7',
            tierCountLabel: '2 个版本',
            assessments: gadAssessments,
            recommendedAssessmentId: 'gad7',
            pickerTitle: '选择焦虑筛查版本',
            pickerSubtitle: '不确定时直接做 GAD-7，信息更完整。',
            tierTagResolver: _gadTierTag,
          ),
        if (adhdAssessments.isNotEmpty)
          _buildTierEntryCard(
            emoji: '🧠',
            title: 'ADHD 筛查',
            subtitle: '注意力、执行力、冲动控制相关风险',
            recommendedTag: '推荐完整版',
            tierCountLabel: '2 个版本',
            assessments: adhdAssessments,
            recommendedAssessmentId: 'adhd_full_18',
            pickerTitle: '选择 ADHD 筛查版本',
            pickerSubtitle: '快速版适合先看方向，完整版更适合认真确认。',
            tierTagResolver: _adhdTierTag,
          ),
      ],
    );
  }

  Widget _buildSelfReflectionAssessmentGroup({
    bool includeOtherAssessments = true,
  }) {
    final assessments = AssessmentCatalog.selfReflectionAssessments;
    final attachmentAssessments = assessments
        .where((assessment) => assessment.id.startsWith('attachment_'))
        .toList(growable: false);
    final bigFiveAssessments = assessments
        .where((assessment) => assessment.id.startsWith('big5_'))
        .toList(growable: false);
    final enneagramAssessments = assessments
        .where((assessment) => assessment.id.startsWith('enneagram_'))
        .toList(growable: false);
    final otherAssessments = assessments
        .where(
          (assessment) =>
              !assessment.id.startsWith('attachment_') &&
              !assessment.id.startsWith('big5_') &&
              !assessment.id.startsWith('enneagram_'),
        )
        .toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          includeOtherAssessments ? '自我了解' : '风格探索',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          includeOtherAssessments
              ? '用于快速回看近期状态，不等于专业筛查'
              : '补充性格维度：依恋风格 / 大五 / 九型',
          style: TextStyle(fontSize: 13, color: AppTheme.textHint, height: 1.4),
        ),
        const SizedBox(height: 12),
        if (attachmentAssessments.isNotEmpty)
          _buildTierEntryCard(
            emoji: '🫶',
            title: '依恋风格入口',
            subtitle: '先选档位再开始：快速版 / 完整版 / 进阶版',
            recommendedTag: '推荐',
            tierCountLabel: '3 档可选',
            assessments: attachmentAssessments,
            recommendedAssessmentId: 'attachment_advanced_80',
            pickerTitle: '选择依恋风格档位',
            pickerSubtitle: '默认展示最完整版本，你也可按需求切换题量。',
            tierTagResolver: _attachmentTierTag,
          ),
        if (bigFiveAssessments.isNotEmpty)
          _buildTierEntryCard(
            emoji: '🌊',
            title: '大五人格入口',
            subtitle: '先选档位再开始：快速版 / 完整版 / 进阶版',
            recommendedTag: '推荐',
            tierCountLabel: '3 档可选',
            assessments: bigFiveAssessments,
            recommendedAssessmentId: 'big5_advanced_120',
            pickerTitle: '选择大五人格档位',
            pickerSubtitle: '默认展示最完整版本，你也可按需求切换题量。',
            tierTagResolver: _bigFiveTierTag,
          ),
        if (enneagramAssessments.isNotEmpty)
          _buildTierEntryCard(
            emoji: '🧩',
            title: '九型人格入口',
            subtitle: '先选档位再开始：快速版 / 完整版',
            recommendedTag: '推荐',
            tierCountLabel: '2 档可选',
            assessments: enneagramAssessments,
            recommendedAssessmentId: 'enneagram_full_108',
            pickerTitle: '选择九型人格档位',
            pickerSubtitle: '建议首次先做完整版，结果更稳定。',
            tierTagResolver: _enneagramTierTag,
          ),
        if (includeOtherAssessments)
          ...otherAssessments.map(_buildAssessmentTile),
      ],
    );
  }

  Widget _buildPersonalityAssessmentGroup() {
    final personalityAssessments = AssessmentCatalog.personalityAssessments;
    final mbtiAssessments = personalityAssessments
        .where((assessment) => assessment.id.startsWith('mbti_'))
        .toList(growable: false);
    final otherAssessments = personalityAssessments
        .where((assessment) => !assessment.id.startsWith('mbti_'))
        .toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '性格探索',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'SBTI / MBTI 四档可选（MBTI 默认 93 题）',
          style: TextStyle(fontSize: 13, color: AppTheme.textHint, height: 1.4),
        ),
        const SizedBox(height: 12),
        if (mbtiAssessments.isNotEmpty) _buildMbtiTierEntry(mbtiAssessments),
        ...otherAssessments.map(_buildAssessmentTile),
      ],
    );
  }

  Widget _buildMbtiTierEntry(List<MentalAssessmentDefinition> mbtiAssessments) {
    final orderedAssessments = List<MentalAssessmentDefinition>.from(
      mbtiAssessments,
    )..sort((a, b) => b.questions.length.compareTo(a.questions.length));
    final recommended = orderedAssessments.firstWhere(
      (assessment) => assessment.id == 'mbti_advanced_93',
      orElse: () => orderedAssessments.first,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => _showMbtiTierPicker(orderedAssessments),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.primaryColor.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('🧩', style: TextStyle(fontSize: 22)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'MBTI 四档入口',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '先选档位再开始：快速版 / 完整版 / 进阶版 / 专业版',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.textHint,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _tagChip('推荐', emphasized: true),
                          _tagChip('4 档可选', emphasized: false),
                          _miniChip(recommended.durationLabel),
                          _miniChip(recommended.periodLabel),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, color: AppTheme.textHint),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showMbtiTierPicker(
    List<MentalAssessmentDefinition> mbtiAssessments,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return SafeArea(
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '选择 MBTI 档位',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '建议先做 93 题进阶版，后续再按需求切换题量。',
                  style: TextStyle(fontSize: 13, color: AppTheme.textHint),
                ),
                const SizedBox(height: 12),
                ...mbtiAssessments.map((definition) {
                  final isRecommended = definition.id == 'mbti_advanced_93';
                  final tierTag = _personalityTierTag(definition.id);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Material(
                      color: AppTheme.surfaceColor.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () {
                          Navigator.of(sheetContext).pop();
                          _startAssessment(definition);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(definition.emoji),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      definition.name,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      definition.shortDescription,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.textSecondary,
                                        height: 1.3,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: [
                                        if (tierTag != null)
                                          _tagChip(tierTag, emphasized: false),
                                        if (isRecommended)
                                          _tagChip('推荐', emphasized: true),
                                        _miniChip(definition.durationLabel),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 14,
                                color: AppTheme.textHint,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTierEntryCard({
    required String emoji,
    required String title,
    required String subtitle,
    required String recommendedTag,
    required String tierCountLabel,
    required List<MentalAssessmentDefinition> assessments,
    required String recommendedAssessmentId,
    required String pickerTitle,
    required String pickerSubtitle,
    required String? Function(String assessmentId) tierTagResolver,
  }) {
    final orderedAssessments = List<MentalAssessmentDefinition>.from(
      assessments,
    )..sort((a, b) => b.questions.length.compareTo(a.questions.length));
    final recommended = orderedAssessments.firstWhere(
      (assessment) => assessment.id == recommendedAssessmentId,
      orElse: () => orderedAssessments.first,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => _showTierPicker(
            assessments: orderedAssessments,
            pickerTitle: pickerTitle,
            pickerSubtitle: pickerSubtitle,
            tierTagResolver: tierTagResolver,
            recommendedAssessmentId: recommendedAssessmentId,
          ),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.primaryColor.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.textHint,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _tagChip(recommendedTag, emphasized: true),
                          _tagChip(tierCountLabel, emphasized: false),
                          _miniChip(recommended.durationLabel),
                          _miniChip(recommended.periodLabel),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, color: AppTheme.textHint),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showTierPicker({
    required List<MentalAssessmentDefinition> assessments,
    required String pickerTitle,
    required String pickerSubtitle,
    required String? Function(String assessmentId) tierTagResolver,
    required String recommendedAssessmentId,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return SafeArea(
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pickerTitle,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  pickerSubtitle,
                  style: TextStyle(fontSize: 13, color: AppTheme.textHint),
                ),
                const SizedBox(height: 12),
                ...assessments.map((definition) {
                  final isRecommended =
                      definition.id == recommendedAssessmentId;
                  final tierTag = tierTagResolver(definition.id);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Material(
                      color: AppTheme.surfaceColor.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () {
                          Navigator.of(sheetContext).pop();
                          _startAssessment(definition);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(definition.emoji),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      definition.name,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      definition.shortDescription,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.textSecondary,
                                        height: 1.3,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: [
                                        if (tierTag != null)
                                          _tagChip(tierTag, emphasized: false),
                                        if (isRecommended)
                                          _tagChip('推荐', emphasized: true),
                                        _miniChip(definition.durationLabel),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 14,
                                color: AppTheme.textHint,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAssessmentTile(MentalAssessmentDefinition definition) {
    final isPersonality = _isPersonalityAssessmentDefinition(definition.id);
    final tierTag = _personalityTierTag(definition.id);
    final isRecommended = definition.id == 'mbti_advanced_93';
    final hasDraft =
        _draftsByAssessmentId.containsKey(definition.id) &&
        _shouldShowDraftInCurrentEntry(definition.id);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => _startAssessment(definition),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.primaryColor.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(definition.emoji, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        definition.name,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        definition.shortDescription,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.textHint,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if (hasDraft) _tagChip('未完成', emphasized: true),
                          if (isPersonality && tierTag != null)
                            _tagChip(tierTag, emphasized: false),
                          if (isRecommended) _tagChip('推荐', emphasized: true),
                          _miniChip(definition.category.label),
                          _miniChip(definition.durationLabel),
                          _miniChip(definition.periodLabel),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, color: AppTheme.textHint),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecordListView() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      children: [
        const SizedBox(height: 8),
        const Text(
          '我的评测记录',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '仅在此处查看，与心情记录分开',
          style: TextStyle(fontSize: 12, color: AppTheme.textHint),
        ),
        const SizedBox(height: 16),
        ..._pastResults.take(20).map((result) {
          final dateStr =
              '${result.createdAt.month}月${result.createdAt.day}日 ${result.createdAt.hour.toString().padLeft(2, '0')}:${result.createdAt.minute.toString().padLeft(2, '0')}';
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          TestResultDetailPage(record: result.toMap()),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Text(result.emoji, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              result.assessmentName,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${result.resultTitle} · ${result.totalScore}/${result.maxScore}',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        dateStr,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textHint,
                        ),
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        tooltip: '删除记录',
                        icon: const Icon(
                          Icons.delete_outline,
                          size: 20,
                          color: AppTheme.errorColor,
                        ),
                        onPressed: () => _confirmDeleteAssessmentResult(result),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildQuestionScaffold() {
    final assessment = _selectedAssessment!;
    final visibleQuestions = assessment.visibleQuestions(_answersByQuestionId);
    if (visibleQuestions.isEmpty) {
      return const SizedBox.shrink();
    }
    final currentStep = _currentStep.clamp(0, visibleQuestions.length - 1);
    final question = visibleQuestions[currentStep];

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.textPrimary),
          onPressed: _backToAssessmentList,
        ),
        title: Text(
          assessment.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            tooltip: '保存进度',
            icon: const Icon(Icons.save_outlined, color: AppTheme.textPrimary),
            onPressed: _saveProgressManually,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.pageHorizontalPadding,
          ),
          child: ListView(
            children: [
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      assessment.intro,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${assessment.category.label} · ${assessment.periodLabel} · ${assessment.durationLabel}',
                      style: TextStyle(fontSize: 12, color: AppTheme.textHint),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              LinearProgressIndicator(
                value: (currentStep + 1) / visibleQuestions.length,
                backgroundColor: AppTheme.surfaceColor,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppTheme.primaryColor,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 8),
              Text(
                '${currentStep + 1} / ${visibleQuestions.length}',
                style: TextStyle(fontSize: 13, color: AppTheme.textHint),
              ),
              const SizedBox(height: 32),
              Text(
                question.prompt,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 28),
              ...question.options.map((option) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      onTap: () => _choose(option),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppTheme.primaryColor.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          option.label,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppTheme.textPrimary,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
              if (assessment.isStandardized) ...[
                const SizedBox(height: 8),
                Text(
                  '筛查结果只用于初步判断，不代替诊断。',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textHint,
                    height: 1.4,
                  ),
                ),
              ],
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _miniChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
      ),
    );
  }

  bool _isPersonalityAssessmentDefinition(String assessmentId) {
    return assessmentId.startsWith('sbti_') || assessmentId.startsWith('mbti_');
  }

  bool _isPersonalityTrackAssessmentId(String assessmentId) {
    return assessmentId.startsWith('sbti_') ||
        assessmentId.startsWith('mbti_') ||
        assessmentId.startsWith('attachment_') ||
        assessmentId.startsWith('big5_') ||
        assessmentId.startsWith('enneagram_');
  }

  bool _shouldShowDraftInCurrentEntry(String assessmentId) {
    final isPersonalityTrack = _isPersonalityTrackAssessmentId(assessmentId);
    return switch (widget.entryMode) {
      AssessmentEntryMode.personalityOnly => isPersonalityTrack,
      AssessmentEntryMode.all => !isPersonalityTrack,
    };
  }

  String? _personalityTierTag(String assessmentId) {
    return switch (assessmentId) {
      'mbti_personality_compass' => '快速版',
      'mbti_full_60' => '完整版',
      'mbti_advanced_93' => '进阶版',
      'mbti_pro_200' => '专业版',
      'sbti_style_compass' => 'SBTI',
      _ => null,
    };
  }

  String? _attachmentTierTag(String assessmentId) {
    return switch (assessmentId) {
      'attachment_quick_16' => '快速版',
      'attachment_full_40' => '完整版',
      'attachment_advanced_80' => '进阶版',
      _ => null,
    };
  }

  String? _bigFiveTierTag(String assessmentId) {
    return switch (assessmentId) {
      'big5_quick_20' => '快速版',
      'big5_full_50' => '完整版',
      'big5_advanced_120' => '进阶版',
      _ => null,
    };
  }

  String? _enneagramTierTag(String assessmentId) {
    return switch (assessmentId) {
      'enneagram_quick_36' => '快速版',
      'enneagram_full_108' => '完整版',
      _ => null,
    };
  }

  String? _phqTierTag(String assessmentId) {
    return switch (assessmentId) {
      'phq2' => '快速版',
      'phq9' => '完整版',
      _ => null,
    };
  }

  String? _gadTierTag(String assessmentId) {
    return switch (assessmentId) {
      'gad2' => '快速版',
      'gad7' => '完整版',
      _ => null,
    };
  }

  String? _adhdTierTag(String assessmentId) {
    return switch (assessmentId) {
      'adhd_quick_6' => '快速版',
      'adhd_full_18' => '完整版',
      _ => null,
    };
  }

  Widget _tagChip(String label, {required bool emphasized}) {
    final background = emphasized
        ? AppTheme.primaryColor.withValues(alpha: 0.16)
        : const Color(0xFFE8F0EA);
    final textColor = emphasized
        ? AppTheme.primaryColor
        : AppTheme.textSecondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: textColor,
          fontWeight: emphasized ? FontWeight.w700 : FontWeight.w600,
        ),
      ),
    );
  }
}

// 统计页 - 优化版
enum StatsPageMode { inner, moodStats }

enum _MoodDistributionRange { month, last30Days, all, custom }

class StatsPage extends StatefulWidget {
  final StatsPageMode mode;
  final ValueNotifier<int>? refreshTrigger;

  const StatsPage({
    super.key,
    this.mode = StatsPageMode.inner,
    this.refreshTrigger,
  });

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  final DatabaseService _dbService = DatabaseService();
  static const String _assessmentDraftKeyPrefix = 'assessment_draft_v1_';
  static const String _cycleMoodPromptDismissedKey =
      'cycle_mood_prompt_dismissed_v1';

  bool _isLoading = true;
  List<EmotionRecord> _rangeRecords = [];
  List<AssessmentResult> _assessmentResults = [];
  List<_SupportPlanSnapshot> _supportPlans = [];
  List<_RetestReminderInfo> _retestReminders = [];
  List<_AssessmentProgressDraft> _assessmentDrafts = [];
  Map<String, int> _moodCounts = {};
  Map<DateTime, double> _dailyAvgIntensity = {};
  Map<String, int> _wordFrequency = {};
  bool _cycleMoodAnalysisEnabled = false;
  bool _cycleMoodPromptDismissed = false;
  late DateTime _calendarMonth;
  _MoodDistributionRange _distributionRange = _MoodDistributionRange.month;
  DateTime? _customDistributionStart;
  DateTime? _customDistributionEnd;

  // 新增数据维度
  Map<String, int> _timeOfDayCounts = {};
  Map<String, int> _intensityBuckets = {};

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _calendarMonth = DateTime(now.year, now.month);
    _loadStats();
    widget.refreshTrigger?.addListener(_loadStats);
  }

  @override
  void dispose() {
    widget.refreshTrigger?.removeListener(_loadStats);
    super.dispose();
  }

  Future<void> _loadStats() async {
    setState(() => _isLoading = true);
    try {
      final recordsData = await _dbService.getEmotionRecords();
      final settingsData = await _dbService.getSettings();
      final assessmentResultsData = await _dbService.getTestResults();
      final supportPlanData = await _dbService.getDataEntriesByPrefix(
        'support_plan_progress_',
      );
      final retestReminderData = await _dbService.getDataEntriesByPrefix(
        'retest_reminder_',
      );
      final assessmentDraftData = await _dbService.getDataEntriesByPrefix(
        _assessmentDraftKeyPrefix,
      );
      final all = <EmotionRecord>[];
      for (final item in recordsData) {
        try {
          all.add(EmotionRecord.fromMap(item));
        } catch (_) {
          // 跳过单条异常记录，避免统计页整页无数据。
        }
      }
      final parsedAssessments = <AssessmentResult>[];
      for (final item in assessmentResultsData) {
        try {
          parsedAssessments.add(AssessmentResult.fromMap(item));
        } catch (_) {
          // 跳过单条异常评测结果，心情统计仍应正常展示。
        }
      }
      parsedAssessments.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      final supportPlans = _buildSupportPlanSnapshots(
        supportPlanData,
        parsedAssessments,
      );
      final retestReminders = _buildRetestReminderInfos(retestReminderData);
      final assessmentDrafts = _buildAssessmentDrafts(assessmentDraftData);
      final appSettings = settingsData == null
          ? AppSettings()
          : AppSettings.fromMap(settingsData);
      final prefs = await _dbService.prefs;
      final cyclePromptDismissed =
          prefs.getBool(_cycleMoodPromptDismissedKey) ?? false;

      setState(() {
        _rangeRecords = all;
        _assessmentResults = parsedAssessments;
        _supportPlans = supportPlans;
        _retestReminders = retestReminders;
        _assessmentDrafts = assessmentDrafts;
        _cycleMoodAnalysisEnabled = appSettings.cycleMoodAnalysisEnabled;
        _cycleMoodPromptDismissed = cyclePromptDismissed;
        _applyDistributionRange(all);
        _dailyAvgIntensity = _calcDailyAvgIntensity(all);
        _wordFrequency = _calcWordFrequency(all);
        _timeOfDayCounts = _calcTimeOfDayCounts(all);
        _intensityBuckets = _calcIntensityBuckets(all);
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading stats: \$e');
      setState(() {
        _rangeRecords = [];
        _assessmentResults = [];
        _supportPlans = [];
        _retestReminders = [];
        _assessmentDrafts = [];
        _moodCounts = {};
        _dailyAvgIntensity = {};
        _wordFrequency = {};
        _cycleMoodAnalysisEnabled = false;
        _cycleMoodPromptDismissed = false;
        _timeOfDayCounts = {};
        _intensityBuckets = {};
        _isLoading = false;
      });
    }
  }

  Future<void> _dismissCycleMoodPrompt() async {
    final prefs = await _dbService.prefs;
    await prefs.setBool(_cycleMoodPromptDismissedKey, true);
    if (!mounted) return;
    setState(() => _cycleMoodPromptDismissed = true);
  }

  Future<void> _enableCycleMoodAnalysisFromPrompt() async {
    final settingsData = await _dbService.getSettings();
    final settings = settingsData == null
        ? AppSettings()
        : AppSettings.fromMap(settingsData);
    await _dbService.updateSettings(
      settings.copyWith(cycleMoodAnalysisEnabled: true).toMap(),
    );
    final prefs = await _dbService.prefs;
    await prefs.setBool(_cycleMoodPromptDismissedKey, true);
    if (!mounted) return;
    setState(() {
      _cycleMoodAnalysisEnabled = true;
      _cycleMoodPromptDismissed = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('已开启周期情绪分析，记录心情时可补充周期线索'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Map<String, int> _calcMoodCounts(List<EmotionRecord> records) {
    final Map<String, int> counts = {};
    for (final r in records) {
      counts[r.mood] = (counts[r.mood] ?? 0) + 1;
    }
    return counts;
  }

  void _applyDistributionRange(List<EmotionRecord> all) {
    final filtered = _filterRecordsForCurrentRange(all);
    _moodCounts = _calcMoodCounts(filtered);
  }

  List<EmotionRecord> _filterRecordsForCurrentRange(List<EmotionRecord> all) {
    final now = DateTime.now();
    switch (_distributionRange) {
      case _MoodDistributionRange.month:
        final monthStart = DateTime(_calendarMonth.year, _calendarMonth.month);
        final monthEnd = DateTime(
          _calendarMonth.year,
          _calendarMonth.month + 1,
        );
        return all.where((r) {
          return !r.createdAt.isBefore(monthStart) &&
              r.createdAt.isBefore(monthEnd);
        }).toList();
      case _MoodDistributionRange.last30Days:
        final today = DateTime(now.year, now.month, now.day);
        final start = today.subtract(const Duration(days: 29));
        return all.where((r) => !r.createdAt.isBefore(start)).toList();
      case _MoodDistributionRange.all:
        return all;
      case _MoodDistributionRange.custom:
        final start = _customDistributionStart;
        final end = _customDistributionEnd;
        if (start == null || end == null) return all;
        final endExclusive = DateTime(end.year, end.month, end.day + 1);
        return all.where((r) {
          return !r.createdAt.isBefore(start) &&
              r.createdAt.isBefore(endExclusive);
        }).toList();
    }
  }

  void _setDistributionRange(_MoodDistributionRange range) {
    setState(() {
      _distributionRange = range;
      _applyDistributionRange(_rangeRecords);
    });
  }

  Future<void> _pickCustomDistributionRange() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    var initialStart =
        _customDistributionStart ?? today.subtract(const Duration(days: 29));
    var initialEnd = _customDistributionEnd ?? today;
    if (initialEnd.isAfter(today)) initialEnd = today;
    if (initialStart.isAfter(initialEnd)) initialStart = initialEnd;
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: today,
      initialDateRange: DateTimeRange(start: initialStart, end: initialEnd),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
    if (picked == null) return;
    setState(() {
      _distributionRange = _MoodDistributionRange.custom;
      _customDistributionStart = DateTime(
        picked.start.year,
        picked.start.month,
        picked.start.day,
      );
      _customDistributionEnd = DateTime(
        picked.end.year,
        picked.end.month,
        picked.end.day,
      );
      _applyDistributionRange(_rangeRecords);
    });
  }

  Map<DateTime, double> _calcDailyAvgIntensity(List<EmotionRecord> records) {
    final Map<DateTime, List<double>> buckets = {};
    for (final r in records) {
      final d = DateTime(r.createdAt.year, r.createdAt.month, r.createdAt.day);
      (buckets[d] ??= []).add(r.intensity);
    }
    final Map<DateTime, double> avg = {};
    buckets.forEach((d, list) {
      final sum = list.fold<double>(0, (a, b) => a + b);
      avg[d] = sum / list.length;
    });
    return avg;
  }

  Map<String, int> _calcWordFrequency(List<EmotionRecord> records) {
    final Map<String, int> freq = {};
    final stopWords = <String>{
      '的',
      '了',
      '在',
      '是',
      '我',
      '有',
      '和',
      '就',
      '不',
      '人',
      '都',
      '一',
      '一个',
      '上',
      '也',
      '很',
      '到',
      '要',
      '去',
      '你',
      '会',
      '着',
      '没有',
      '看',
      '好',
      '自己',
      '这',
      '那',
      '里',
      '后',
      '以',
      '时候',
      '把',
      '她',
      '他',
      '它',
      '们',
      '但是',
      '因为',
      '所以',
      '如果',
      '虽然',
      '然后',
      '还是',
      '或者',
      '而且',
      '不过',
      '昨天',
      '明天',
      '现在',
      '以前',
      '以后',
      '时间',
      '地方',
      '东西',
      '事情',
      '问题',
      '方法',
      '结果',
      '开始',
      '最后',
      '可能',
      '应该',
      '需要',
      '希望',
      '觉得',
      '知道', '认为', '发现', '变成', '成为', '出现', '发生', '进行', '继续', '完成',
      '什么', '怎么', '如何', '为什么', '多少', '哪个', '哪些', '怎样', '为啥',
      // 灵感/提示语被 2 字切分后的无意义片段（如「此刻最想对谁说句话」→ 刻最、最想、想对…）
      '刻最', '最想', '想对', '对谁', '谁说', '说句', '句话',
    };

    for (final r in records) {
      final text = r.note.trim();
      if (text.isEmpty) continue;
      final words = _extractWords(text);
      for (final w in words) {
        if (w.length >= 2 && !stopWords.contains(w)) {
          freq[w] = (freq[w] ?? 0) + 1;
        }
      }
    }
    return freq;
  }

  /// 只提取 2 字中文词 + 英文整词，避免滑动窗口产生「刻最」「最想」等碎片
  List<String> _extractWords(String text) {
    final words = <String>[];
    final clean = text.replaceAll(RegExp(r'[^\u4e00-\u9fa5a-zA-Z0-9]'), ' ');

    // 只做 2 字切分，避免 3/4 字滑动产生大量无意义组合
    for (int i = 0; i < clean.length - 1; i++) {
      final w = clean.substring(i, i + 2);
      if (RegExp(r'^[\u4e00-\u9fa5]+$').hasMatch(w)) {
        words.add(w);
      }
    }

    final englishWords = clean
        .split(RegExp(r'\s+'))
        .where((w) => RegExp(r'^[a-zA-Z]+$').hasMatch(w) && w.length >= 2)
        .map((w) => w.toLowerCase());
    words.addAll(englishWords);
    return words;
  }

  // --- 新增计算方法 ---

  Map<String, int> _calcTimeOfDayCounts(List<EmotionRecord> records) {
    int morning = 0; // 06:00 - 11:59
    int afternoon = 0; // 12:00 - 17:59
    int evening = 0; // 18:00 - 23:59
    int night = 0; // 00:00 - 05:59

    for (final r in records) {
      final hour = r.createdAt.hour;
      if (hour >= 6 && hour < 12)
        morning++;
      else if (hour >= 12 && hour < 18)
        afternoon++;
      else if (hour >= 18 && hour < 24)
        evening++;
      else
        night++;
    }
    return {
      '晨间 (06-12)': morning,
      '午后 (12-18)': afternoon,
      '晚间 (18-24)': evening,
      '深夜 (00-06)': night,
    };
  }

  Map<String, int> _calcIntensityBuckets(List<EmotionRecord> records) {
    int mild = 0; // 0-30
    int moderate = 0; // 31-70
    int intense = 0; // 71-100

    for (final r in records) {
      if (r.intensity <= 30)
        mild++;
      else if (r.intensity <= 70)
        moderate++;
      else
        intense++;
    }
    return {'温和 (0-30)': mild, '中等 (31-70)': moderate, '强烈 (71-100)': intense};
  }

  // ========== 识别辅助相关计算 ==========

  /// 计算识别建议与用户选择的一致率
  double _calcAiMatchRate(List<EmotionRecord> records) {
    final aiRecords = records.where((r) => r.hasAiAnalysis).toList();
    if (aiRecords.isEmpty) return 0.0;
    final matched = aiRecords.where((r) => r.isAiMatch).length;
    return matched / aiRecords.length;
  }

  /// 计算情绪来源分布
  Map<String, int> _calcAiSourceDistribution(List<EmotionRecord> records) {
    return {
      '手动选择': records.where((r) => r.aiSource == null).length,
      '文字识别': records.where((r) => r.aiSource == 'text').length,
      '语音识别': records.where((r) => r.aiSource == 'voice').length,
      '表情识别': records.where((r) => r.aiSource == 'face').length,
    };
  }

  /// 计算识别建议与用户选择的差异
  Map<String, Map<String, int>> _calcMoodConfusion(List<EmotionRecord> records) {
    final confusion = <String, Map<String, int>>{};
    for (final r in records) {
      if (r.aiDetectedMood != null && r.mood != r.aiDetectedMood) {
        final aiMood = r.aiDetectedMood!;
        final userMood = r.mood;
        confusion[aiMood] ??= {};
        confusion[aiMood]![userMood] = (confusion[aiMood]![userMood] ?? 0) + 1;
      }
    }
    return confusion;
  }

  /// 获取有识别辅助的记录
  List<EmotionRecord> _getAiRecords() {
    return _rangeRecords.where((r) => r.hasAiAnalysis).toList();
  }

  List<_SupportPlanSnapshot> _buildSupportPlanSnapshots(
    Map<String, dynamic> rawEntries,
    List<AssessmentResult> results,
  ) {
    const prefix = 'support_plan_progress_';
    final resultMap = <String, AssessmentResult>{
      for (final result in results)
        '${result.assessmentId}_${result.createdAt.millisecondsSinceEpoch}':
            result,
    };
    final snapshots = <_SupportPlanSnapshot>[];

    rawEntries.forEach((key, value) {
      if (!key.startsWith(prefix)) return;
      final suffix = key.substring(prefix.length);
      final separatorIndex = suffix.lastIndexOf('_');
      if (separatorIndex <= 0 || separatorIndex == suffix.length - 1) return;

      final assessmentId = suffix.substring(0, separatorIndex);
      final timestamp = int.tryParse(suffix.substring(separatorIndex + 1));
      if (timestamp == null) return;

      var completedTasks = 0;
      if (value is Map) {
        completedTasks = value.values.where((item) => item == true).length;
      }

      snapshots.add(
        _SupportPlanSnapshot(
          key: key,
          assessmentId: assessmentId,
          startedAt: DateTime.fromMillisecondsSinceEpoch(timestamp),
          completedTasks: completedTasks,
          totalTasks: kSupportPlanTotalTasks,
          result: resultMap['${assessmentId}_$timestamp'],
        ),
      );
    });

    snapshots.sort((a, b) => b.startedAt.compareTo(a.startedAt));
    return snapshots;
  }

  List<_RetestReminderInfo> _buildRetestReminderInfos(
    Map<String, dynamic> rawEntries,
  ) {
    final reminders = <_RetestReminderInfo>[];
    for (final entry in rawEntries.entries) {
      final value = entry.value;
      if (value is! Map) continue;
      final reminder = _RetestReminderInfo.fromMap(
        Map<String, dynamic>.from(value),
      );
      if (reminder.scheduledAt.isAfter(DateTime.now())) {
        reminders.add(reminder);
      }
    }
    reminders.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
    return reminders;
  }

  List<_AssessmentProgressDraft> _buildAssessmentDrafts(
    Map<String, dynamic> rawEntries,
  ) {
    final drafts = <_AssessmentProgressDraft>[];
    for (final value in rawEntries.values) {
      if (value is! Map) continue;
      final draft = _AssessmentProgressDraft.fromMap(
        Map<String, dynamic>.from(value),
      );
      if (draft == null || draft.answersByQuestionId.isEmpty) continue;
      drafts.add(draft);
    }
    drafts.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return drafts;
  }

  @override
  Widget build(BuildContext context) {
    final isMoodStats = widget.mode == StatsPageMode.moodStats;
    final safeTop = MediaQuery.of(context).padding.top;
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: const Center(
          child: CircularProgressIndicator(color: AppTheme.primaryColor),
        ),
      );
    }

    if (isMoodStats) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppTheme.backgroundColor,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppTheme.textPrimary,
              size: 20,
            ),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          title: const Text(
            '统计',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
          children: [
            _buildHeatmapSection(),
            const SizedBox(height: 16),
            _buildDistributionSection(),
            if (_cycleMoodAnalysisEnabled) ...[
              const SizedBox(height: 16),
              _buildCycleMoodInsightSection(),
            ],
            if (_getAiRecords().isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildAiInsightSection(),
            ],
            if (_intensityBuckets.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildIntensitySection(),
            ],
            if (_timeOfDayCounts.isNotEmpty &&
                _timeOfDayCounts.values.any((v) => v > 0)) ...[
              const SizedBox(height: 16),
              _buildTimeOfDaySection(),
            ],
            if (_wordFrequency.entries.any((e) => e.value >= 2)) ...[
              const SizedBox(height: 16),
              _buildWordSection(),
            ],
            if (_dailyAvgIntensity.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildTrendChart(),
            ],
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/bg_neixian.png',
              fit: BoxFit.fitWidth,
              alignment: Alignment.topRight,
            ),
          ),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: false,
                pinned: false,
                expandedHeight: safeTop + PrimaryPageLayout.headerHeightOffset,
                toolbarHeight: 0,
                elevation: 0,
                shadowColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                forceMaterialTransparency: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      if (isMoodStats)
                        Positioned(
                          left: 16,
                          top: safeTop + 10,
                          child: Material(
                            color: Colors.white,
                            shape: const CircleBorder(),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: () => Navigator.of(context).maybePop(),
                              child: const SizedBox(
                                width: 44,
                                height: 44,
                                child: Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  size: 18,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: PrimaryPageHeader(
                          safeTop: safeTop,
                          title: isMoodStats ? '统计' : '内现',
                          subtitle: isMoodStats
                              ? '把最近的心情变化放在一起看'
                              : '从评测和记录里看见自己',
                          titleColor: AppTheme.textPrimary,
                          subtitleColor: AppTheme.textSecondary,
                          leadingWidth: isMoodStats ? 52 : 0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Transform.translate(
                  offset: Offset.zero,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (isMoodStats) ...[
                          _buildHeatmapSection(),
                          const SizedBox(height: 16),
                          _buildDistributionSection(),
                          if (_cycleMoodAnalysisEnabled) ...[
                            const SizedBox(height: 16),
                            _buildCycleMoodInsightSection(),
                          ],
                          if (_getAiRecords().isNotEmpty) ...[
                            const SizedBox(height: 16),
                            _buildAiInsightSection(),
                          ],
                          if (_intensityBuckets.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            _buildIntensitySection(),
                          ],
                          if (_timeOfDayCounts.isNotEmpty &&
                              _timeOfDayCounts.values.any((v) => v > 0)) ...[
                            const SizedBox(height: 16),
                            _buildTimeOfDaySection(),
                          ],
                          if (_wordFrequency.entries.any(
                            (e) => e.value >= 2,
                          )) ...[
                            const SizedBox(height: 16),
                            _buildWordSection(),
                          ],
                          if (_dailyAvgIntensity.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            _buildTrendChart(),
                          ],
                        ] else ...[
                          _buildAssessmentQuickEntries(),
                          if (!_cycleMoodAnalysisEnabled &&
                              !_cycleMoodPromptDismissed) ...[
                            const SizedBox(height: 16),
                            _buildCycleMoodPromptCard(),
                          ],
                          if (_cycleMoodAnalysisEnabled) ...[
                            const SizedBox(height: 16),
                            _buildCycleMoodInsightSection(),
                          ],
                          const SizedBox(height: 16),
                          _buildHealingPlanSection(),
                          if (_assessmentResults.any(
                            (result) => result.isStandardized,
                          )) ...[
                            const SizedBox(height: 16),
                            _buildAssessmentTrendSection(),
                          ],
                          if (_assessmentResults.any(
                                (result) => result.isStandardized,
                              ) &&
                              _rangeRecords.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            _buildAssessmentMoodInsightSection(),
                          ],
                          if (_rangeRecords.length >= 3) ...[
                            const SizedBox(height: 16),
                            _buildHealingCard(),
                          ],
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  AssessmentResult? _latestStandardizedAssessment() {
    for (final result in _assessmentResults) {
      if (result.isStandardized) return result;
    }
    return null;
  }

  Widget _buildHealingPlanSection() {
    final latestAssessment = _assessmentResults.isNotEmpty
        ? _assessmentResults.first
        : null;
    final latestStandardized = _latestStandardizedAssessment();
    final latestPlan = _supportPlans.isNotEmpty ? _supportPlans.first : null;
    final latestReminder = _retestReminders.isNotEmpty
        ? _retestReminders.first
        : null;
    final latestDraft = _assessmentDrafts.isNotEmpty
        ? _assessmentDrafts.first
        : null;
    final latestDraftDefinition = latestDraft == null
        ? null
        : AssessmentCatalog.findById(latestDraft.assessmentId);
    final latestActionSource = latestStandardized ?? latestAssessment;
    final latestRecommendations = latestActionSource == null
        ? const <TherapyRecommendation>[]
        : TherapyRecommendationService.recommendationsFor(latestActionSource);
    final latestNextStep = latestActionSource == null
        ? null
        : TherapyRecommendationService.nextStepFor(
            latestActionSource,
            recommendations: latestRecommendations,
          );

    if (latestAssessment == null) {
      return InkWell(
        onTap: () async {
          await Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const EmotionTestPage()));
          if (mounted) _loadStats();
        },
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppTheme.primaryColor.withValues(alpha: 0.18),
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.psychology_outlined,
                size: 40,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(height: 12),
              const Text(
                '获取您的专属疗愈方案',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                '做一个简单的心理评测，我会为您生成针对性的每日行动计划。',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    final repeatAssessment = latestStandardized ?? latestAssessment;
    final latestPlanResult = latestPlan?.result;
    final canContinuePlan =
        latestPlan != null &&
        latestPlanResult != null &&
        latestPlan.completionRate < 1.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '评测与支持',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  '累计评测',
                  _assessmentResults.length.toString(),
                  Icons.psychology_outlined,
                  AppTheme.primaryColor,
                ),
              ),
              if (latestPlan != null) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    '支持计划',
                    '${(latestPlan.completionRate * 100).round()}%',
                    Icons.checklist_rounded,
                    AppTheme.secondaryColor,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          _buildAssessmentInfoTile(
            icon: latestAssessment.emoji,
            title: '最近一次评测',
            primary: latestAssessment.assessmentName,
            secondary:
                '${latestAssessment.resultTitle} · ${latestAssessment.totalScore}/${latestAssessment.maxScore}',
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      TestResultDetailPage(record: latestAssessment.toMap()),
                ),
              );
              if (mounted) _loadStats();
            },
          ),
          if (latestDraft != null && latestDraftDefinition != null) ...[
            const SizedBox(height: 12),
            _buildAssessmentInfoTile(
              materialIcon: Icons.edit_note_rounded,
              title: '未完成评测',
              primary: latestDraftDefinition.name,
              secondary:
                  '已答 ${latestDraft.answeredCount}/${latestDraft.visibleQuestionCount > 0 ? latestDraft.visibleQuestionCount : latestDraftDefinition.questions.length} 题 · ${_formatStatsDateTime(latestDraft.updatedAt)}',
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => EmotionTestPage(
                      initialAssessmentId: latestDraft.assessmentId,
                    ),
                  ),
                );
                if (mounted) _loadStats();
              },
            ),
          ],
          if (latestActionSource != null && latestNextStep != null) ...[
            const SizedBox(height: 16),
            InkWell(
              onTap: () async {
                await _runHealingAction(
                  latestActionSource,
                  latestNextStep.type,
                );
                if (mounted) _loadStats();
              },
              borderRadius: BorderRadius.circular(18),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: AppTheme.primaryColor.withValues(alpha: 0.12),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.flag_outlined,
                        color: AppTheme.primaryColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '建议下一步',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.76),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Text(
                              '根据最近评测生成',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            latestNextStep.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            latestNextStep.description,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppTheme.textSecondary,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: AppTheme.textHint),
                  ],
                ),
              ),
            ),
          ],
          if (latestPlan != null) ...[
            const SizedBox(height: 16),
            _buildSupportPlanProgressCard(latestPlan),
          ],
          if (latestReminder != null) ...[
            const SizedBox(height: 16),
            _buildAssessmentInfoTile(
              materialIcon: Icons.notifications_active_outlined,
              title: '复测提醒',
              primary: latestReminder.assessmentName,
              secondary:
                  '${latestReminder.scheduledAt.month}月${latestReminder.scheduledAt.day}日 '
                  '${latestReminder.scheduledAt.hour.toString().padLeft(2, '0')}:${latestReminder.scheduledAt.minute.toString().padLeft(2, '0')}',
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const RetestRemindersPage(),
                  ),
                );
                if (mounted) _loadStats();
              },
            ),
          ],
          const SizedBox(height: 16),
          if (latestReminder != null) ...[
            _buildOutlinedFullWidthButton(
              label: '管理复测提醒',
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const RetestRemindersPage(),
                  ),
                );
                if (mounted) _loadStats();
              },
            ),
            const SizedBox(height: 12),
          ],
          if (canContinuePlan)
            _buildFullWidthButton(
              label: '继续 7 天支持计划',
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        SevenDaySupportPlanPage(result: latestPlanResult),
                  ),
                );
                if (mounted) _loadStats();
              },
            ),
          if (canContinuePlan) const SizedBox(height: 12),
          _buildOutlinedFullWidthButton(
            label: repeatAssessment.isStandardized ? '重新做最近筛查' : '重新做最近评测',
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => EmotionTestPage(
                    initialAssessmentId: repeatAssessment.assessmentId,
                  ),
                ),
              );
              if (mounted) _loadStats();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _runHealingAction(
    AssessmentResult result,
    HealingActionType type,
  ) async {
    switch (type) {
      case HealingActionType.breathing:
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const BreathingExercisePage()),
        );
        return;
      case HealingActionType.supportPage:
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => MentalSupportPage(result: result)),
        );
        return;
      case HealingActionType.supportPlan:
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => SevenDaySupportPlanPage(result: result),
          ),
        );
        return;
    }
  }

  String _formatStatsDateTime(DateTime time) {
    return '${time.month}月${time.day}日 '
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildAssessmentInfoTile({
    String? icon,
    IconData? materialIcon,
    required String title,
    required String primary,
    required String secondary,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppTheme.surfaceColor,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.86),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: icon != null
                    ? Text(icon, style: const TextStyle(fontSize: 22))
                    : Icon(
                        materialIcon ?? Icons.psychology_outlined,
                        color: AppTheme.primaryColor,
                        size: 22,
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
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      primary,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      secondary,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppTheme.textHint),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSupportPlanProgressCard(_SupportPlanSnapshot plan) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '支持计划进度',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            plan.result?.assessmentName ?? plan.assessmentId,
            style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: plan.completionRate,
            backgroundColor: AppTheme.surfaceColor,
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppTheme.primaryColor,
            ),
            borderRadius: BorderRadius.circular(999),
            minHeight: 8,
          ),
          const SizedBox(height: 8),
          Text(
            '已完成 ${plan.completedTasks}/${plan.totalTasks} 项',
            style: const TextStyle(fontSize: 12, color: AppTheme.textHint),
          ),
        ],
      ),
    );
  }

  Widget _buildAssessmentTrendSection() {
    final latest = _latestStandardizedAssessment();
    if (latest == null) return const SizedBox.shrink();

    final series =
        _assessmentResults
            .where(
              (result) =>
                  result.isStandardized &&
                  result.assessmentId == latest.assessmentId,
            )
            .toList()
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    final recentSeries = series.length > 6
        ? series.sublist(series.length - 6)
        : series;
    final previous = recentSeries.length >= 2
        ? recentSeries[recentSeries.length - 2]
        : null;
    final delta = previous != null
        ? latest.totalScore - previous.totalScore
        : null;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${latest.assessmentName} 趋势',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '只比较同一量表的历史结果，避免不同评测分数混在一起。',
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.textHint,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  '最近一次',
                  '${latest.totalScore}/${latest.maxScore}',
                  Icons.monitor_heart_outlined,
                  AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  '较上次',
                  delta == null ? '首次' : '${delta > 0 ? '+' : ''}$delta',
                  Icons.trending_up_rounded,
                  delta == null
                      ? AppTheme.secondaryColor
                      : (delta <= 0
                            ? AppTheme.primaryColor
                            : AppTheme.secondaryColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (recentSeries.length >= 2)
            SizedBox(
              height: 220,
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: (recentSeries.length - 1).toDouble(),
                  minY: 0,
                  maxY: latest.maxScore.toDouble(),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: latest.maxScore <= 10 ? 2 : 5,
                    getDrawingHorizontalLine: (value) =>
                        FlLine(color: AppTheme.surfaceColor, strokeWidth: 1),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: latest.maxScore <= 10 ? 2 : 5,
                        getTitlesWidget: (value, meta) => Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppTheme.textHint,
                          ),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= recentSeries.length) {
                            return const SizedBox.shrink();
                          }
                          final d = recentSeries[index].createdAt;
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              '${d.month}/${d.day}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppTheme.textHint,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: recentSeries.asMap().entries.map((entry) {
                        return FlSpot(
                          entry.key.toDouble(),
                          entry.value.totalScore.toDouble(),
                        );
                      }).toList(),
                      isCurved: true,
                      color: AppTheme.primaryColor,
                      barWidth: 3,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, bar, index) =>
                            FlDotCirclePainter(
                              radius: 3.5,
                              color: AppTheme.primaryColor,
                              strokeWidth: 2,
                              strokeColor: Colors.white,
                            ),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppTheme.primaryColor.withValues(alpha: 0.10),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                '这份量表目前只有 1 次记录。下次复测后，这里会显示趋势变化。',
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                  height: 1.5,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAssessmentMoodInsightSection() {
    final latest = _latestStandardizedAssessment();
    if (latest == null) return const SizedBox.shrink();
    final comparableSeries =
        _assessmentResults
            .where(
              (result) =>
                  result.isStandardized &&
                  result.assessmentId == latest.assessmentId,
            )
            .toList()
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    final previousAssessment = comparableSeries.length >= 2
        ? comparableSeries[comparableSeries.length - 2]
        : null;

    final start = latest.createdAt.subtract(const Duration(days: 3));
    final end = latest.createdAt.add(const Duration(days: 1));
    final nearbyRecords =
        _rangeRecords
            .where(
              (record) =>
                  !record.createdAt.isBefore(start) &&
                  !record.createdAt.isAfter(end),
            )
            .toList()
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    if (nearbyRecords.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '评测关联洞察',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '最近一次 ${latest.assessmentName} 周围没有足够的心情记录。下次筛查前后多记几笔，这里会更有价值。',
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      );
    }

    final moodCounts = <String, int>{};
    var totalIntensity = 0.0;
    var nightRecords = 0;
    for (final record in nearbyRecords) {
      moodCounts[record.mood] = (moodCounts[record.mood] ?? 0) + 1;
      totalIntensity += record.intensity;
      if (record.createdAt.hour < 6 || record.createdAt.hour >= 23) {
        nightRecords++;
      }
    }
    final dominantMoodEntry = moodCounts.entries.reduce(
      (a, b) => a.value >= b.value ? a : b,
    );
    final averageIntensity = totalIntensity / nearbyRecords.length;
    final previousNearbyRecords = previousAssessment == null
        ? <EmotionRecord>[]
        : _rangeRecords
              .where(
                (record) =>
                    !record.createdAt.isBefore(
                      previousAssessment.createdAt.subtract(
                        const Duration(days: 3),
                      ),
                    ) &&
                    !record.createdAt.isAfter(
                      previousAssessment.createdAt.add(const Duration(days: 1)),
                    ),
              )
              .toList();
    final insights = <String>[
      '最近一次 ${latest.assessmentName} 前后共记录了 ${nearbyRecords.length} 次心情，最常见的是 ${dominantMoodEntry.key} ${_getEmojiForMood(dominantMoodEntry.key)}。',
      '这几天的平均情绪强度约为 ${averageIntensity.toStringAsFixed(0)}/100，说明当时的体验${averageIntensity >= 65
          ? '偏强烈'
          : averageIntensity >= 40
          ? '比较明显'
          : '相对温和'}。',
    ];
    if (previousAssessment != null) {
      final scoreDelta = latest.totalScore - previousAssessment.totalScore;
      insights.add(
        '和上一次 ${previousAssessment.assessmentName} 相比，分数${scoreDelta == 0
            ? '没有变化'
            : scoreDelta > 0
            ? '上升了 $scoreDelta 分'
            : '下降了 ${scoreDelta.abs()} 分'}。',
      );
      if (previousNearbyRecords.isNotEmpty) {
        final previousAverageIntensity =
            previousNearbyRecords.fold<double>(
              0,
              (sum, record) => sum + record.intensity,
            ) /
            previousNearbyRecords.length;
        final intensityDiff = averageIntensity - previousAverageIntensity;
        insights.add(
          '按前后几天的心情记录看，平均强度${intensityDiff.abs() < 3
              ? '基本持平'
              : intensityDiff > 0
              ? '比上次高了 ${intensityDiff.toStringAsFixed(0)} 分'
              : '比上次低了 ${intensityDiff.abs().toStringAsFixed(0)} 分'}。',
        );
      }
    }
    if (nightRecords > 0) {
      insights.add('其中有 $nightRecords 次出现在深夜或临近午夜，说明那段时间的睡眠/夜间状态值得一起观察。');
    }
    if (latest.severity.index >= AssessmentSeverity.moderate.index) {
      insights.add('这次筛查已经到了需要认真关注的层级，后续复测时可以重点看睡眠、深夜记录和高强度情绪有没有一起下降。');
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '评测关联洞察',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '把最近一次标准化筛查，和前后几天的心情记录放在一起看。',
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.textHint,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          ...insights.map(
            (text) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '• ',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                  Expanded(
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<EmotionRecord> _cycleAnalysisRecords() {
    final now = DateTime.now();
    final start = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(const Duration(days: 183));
    return _rangeRecords.where((record) {
      final hasCycleData =
          record.menstrualStatus.isNotEmpty ||
          record.cycleSymptoms.isNotEmpty ||
          record.cycleFunctionImpact.isNotEmpty;
      return hasCycleData && !record.createdAt.isBefore(start);
    }).toList();
  }

  bool _isPremenstrualWindow(String status) {
    return status == '黄体期' || status == '经前7天';
  }

  Widget _buildCycleMoodPromptCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.insights_rounded,
                  color: AppTheme.primaryColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '看见情绪背后的规律',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '你也可以选择补充周期线索，观察焦虑、易怒、低落是否常在经前或特定阶段出现。',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _dismissCycleMoodPrompt,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.textSecondary,
                    side: BorderSide(
                      color: AppTheme.textHint.withValues(alpha: 0.25),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('暂不开启'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: _enableCycleMoodAnalysisFromPrompt,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('开启分析'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCycleMoodInsightSection() {
    final cycleRecords = _cycleAnalysisRecords();
    if (cycleRecords.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppTheme.primaryColor.withValues(alpha: 0.12),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.insights_rounded,
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    '周期情绪分析',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    '已开启',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Text(
              '还没有可分析的周期线索。点底部 + 记录心情时，补充周期阶段、身体症状或生活影响，这里就会开始整理规律。',
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    '周期记录',
                    '0',
                    Icons.calendar_month_outlined,
                    AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    '黄体/经前',
                    '待记录',
                    Icons.trending_up_rounded,
                    AppTheme.secondaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Text(
              '记录积累后，会观察焦虑、易怒、低落是否更常出现在黄体期或经前 7 天。仅用于自我观察，不替代医学诊断。',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textHint,
                height: 1.4,
              ),
            ),
          ],
        ),
      );
    }

    const negativeMoods = {'焦虑', '生气', '难过', '疲惫'};
    final negativeRecords = cycleRecords.where((record) {
      return negativeMoods.contains(record.mood) ||
          record.additionalMoods.any(negativeMoods.contains);
    }).toList();
    final premenstrualRecords = cycleRecords
        .where((record) => _isPremenstrualWindow(record.menstrualStatus))
        .toList();
    final premenstrualNegativeRecords = negativeRecords
        .where((record) => _isPremenstrualWindow(record.menstrualStatus))
        .toList();
    final impactedRecords = cycleRecords.where((record) {
      return record.cycleFunctionImpact.isNotEmpty &&
          record.cycleFunctionImpact != '无明显影响';
    }).toList();

    final symptomCounts = <String, int>{};
    for (final record in cycleRecords) {
      for (final symptom in record.cycleSymptoms) {
        symptomCounts[symptom] = (symptomCounts[symptom] ?? 0) + 1;
      }
    }
    final topSymptoms = symptomCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final statusCounts = <String, int>{};
    for (final record in negativeRecords) {
      final status = record.menstrualStatus;
      if (status.isEmpty || status == '不确定') continue;
      statusCounts[status] = (statusCounts[status] ?? 0) + 1;
    }
    final dominantStatus = statusCounts.entries.isEmpty
        ? null
        : (statusCounts.entries.toList()
                ..sort((a, b) => b.value.compareTo(a.value)))
              .first;
    final premenstrualRatio = negativeRecords.isEmpty
        ? 0
        : (premenstrualNegativeRecords.length / negativeRecords.length * 100)
              .round();

    final insights = <String>['近 6 个月有 ${cycleRecords.length} 条记录包含周期线索。'];
    if (negativeRecords.isNotEmpty) {
      insights.add('$premenstrualRatio% 的负面情绪记录出现在黄体期或经前 7 天。');
    }
    if (dominantStatus != null) {
      insights.add(
        '负面情绪目前最常出现在「${dominantStatus.key}」，共 ${dominantStatus.value} 次。',
      );
    }
    if (topSymptoms.isNotEmpty) {
      final symptomText = topSymptoms
          .take(3)
          .map((entry) => '${entry.key} ${entry.value}次')
          .join('、');
      insights.add('最常一起出现的身体症状是：$symptomText。');
    }
    if (impactedRecords.isNotEmpty) {
      insights.add('已有 ${impactedRecords.length} 条记录提到工作、学习、人际或日常活动受影响。');
    }
    if (premenstrualNegativeRecords.length >= 2 && impactedRecords.isNotEmpty) {
      insights.add(
        '经前负面情绪伴随生活影响，呈现值得继续观察的 PMDD 风险线索；建议至少连续记录 2 个周期，必要时咨询专业医生。',
      );
    } else if (premenstrualRecords.length < 2) {
      insights.add('经前记录还偏少，继续记录后才能更可靠地判断是否存在重复模式。');
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.insights_rounded,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  '周期情绪分析',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  '周期记录',
                  '${cycleRecords.length}',
                  Icons.calendar_month_outlined,
                  AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  '黄体/经前',
                  negativeRecords.isEmpty ? '暂无' : '$premenstrualRatio%',
                  Icons.trending_up_rounded,
                  AppTheme.secondaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...insights.map(
            (text) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '• ',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                  Expanded(
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            '仅用于自我观察和就医沟通参考，不能替代医学诊断。',
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textHint,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // --- 新增图表 Widget ---

  Widget _buildAiInsightSection() {
    final aiRecords = _getAiRecords();
    if (aiRecords.isEmpty) return const SizedBox.shrink();

    final matchRate = _calcAiMatchRate(_rangeRecords);
    final sourceDistribution = _calcAiSourceDistribution(_rangeRecords);
    final moodConfusion = _calcMoodConfusion(_rangeRecords);

    final totalAiRecords = aiRecords.length;
    final matchedCount = aiRecords.where((r) => r.isAiMatch).length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.auto_awesome,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '识别辅助复盘',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 识别一致率
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '识别与选择一致率',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${(matchRate * 100).toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      Text(
                        '$matchedCount / $totalAiRecords 条有识别辅助的记录一致',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textHint,
                        ),
                      ),
                    ],
                  ),
                ),
                // 圆形进度指示器
                SizedBox(
                  width: 64,
                  height: 64,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 64,
                        height: 64,
                        child: CircularProgressIndicator(
                          value: matchRate,
                          strokeWidth: 6,
                          backgroundColor: AppTheme.primaryColor.withValues(
                            alpha: 0.1,
                          ),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.primaryColor,
                          ),
                        ),
                      ),
                      Icon(
                        matchRate >= 0.7 ? Icons.thumb_up : Icons.psychology,
                        color: AppTheme.primaryColor,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 情绪来源分布
          const Text(
            '情绪来源分布',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: sourceDistribution.entries.map((e) {
              final isActive = e.value > 0;
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppTheme.primaryColor.withValues(alpha: 0.1)
                      : AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isActive
                        ? AppTheme.primaryColor.withValues(alpha: 0.3)
                        : Colors.transparent,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getSourceIcon(e.key),
                      size: 16,
                      color: isActive
                          ? AppTheme.primaryColor
                          : AppTheme.textHint,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      e.key,
                      style: TextStyle(
                        fontSize: 13,
                        color: isActive
                            ? AppTheme.textPrimary
                            : AppTheme.textHint,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${e.value}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isActive
                            ? AppTheme.primaryColor
                            : AppTheme.textHint,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

          // 识别差异提示
          if (moodConfusion.isNotEmpty) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: const Color(0xFFFFA000),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '识别差异提示',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFE65100),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...moodConfusion.entries.take(3).map((e) {
                    final aiMood = e.key;
                    final userMoods = e.value.entries.toList()
                      ..sort((a, b) => b.value.compareTo(a.value));
                    final topUserMood = userMoods.first;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Text(
                            '识别到',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            EmotionMapping.getEmoji(aiMood),
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            aiMood,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward,
                            size: 14,
                            color: AppTheme.textHint,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '你选择',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            EmotionMapping.getEmoji(topUserMood.key),
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            topUserMood.key,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${topUserMood.value}次)',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppTheme.textHint,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getSourceIcon(String source) {
    switch (source) {
      case '手动选择':
        return Icons.touch_app;
      case '文字识别':
        return Icons.text_fields;
      case '语音识别':
        return Icons.mic;
      case '表情识别':
        return Icons.camera_alt;
      default:
        return Icons.psychology;
    }
  }

  Widget _buildIntensitySection() {
    final values = _intensityBuckets.values.toList();
    if (values.every((v) => v == 0)) return const SizedBox.shrink();

    final total = values.fold<int>(0, (a, b) => a + b);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '情绪强度分布',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          // 使用简单的横向堆积条形图体现
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Row(
              children: [
                if (_intensityBuckets['温和 (0-30)']! > 0)
                  Expanded(
                    flex: _intensityBuckets['温和 (0-30)']!,
                    child: Container(
                      height: 24,
                      color: AppTheme.primaryLight,
                      alignment: Alignment.center,
                      child: Text(
                        '${(_intensityBuckets['温和 (0-30)']! / total * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                if (_intensityBuckets['中等 (31-70)']! > 0)
                  Expanded(
                    flex: _intensityBuckets['中等 (31-70)']!,
                    child: Container(
                      height: 24,
                      color: AppTheme.primaryColor,
                      alignment: Alignment.center,
                      child: Text(
                        '${(_intensityBuckets['中等 (31-70)']! / total * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                if (_intensityBuckets['强烈 (71-100)']! > 0)
                  Expanded(
                    flex: _intensityBuckets['强烈 (71-100)']!,
                    child: Container(
                      height: 24,
                      color: AppTheme.primaryDark,
                      alignment: Alignment.center,
                      child: Text(
                        '${(_intensityBuckets['强烈 (71-100)']! / total * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildIndicator(AppTheme.primaryLight, '温和'),
              _buildIndicator(AppTheme.primaryColor, '中等'),
              _buildIndicator(AppTheme.primaryDark, '强烈'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeOfDaySection() {
    final values = _timeOfDayCounts.values.toList();
    if (values.every((v) => v == 0)) return const SizedBox.shrink();

    final maxVal = values.reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '时段情绪规律',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          _buildPlainMetricBar(
            label: '晨间',
            value: _timeOfDayCounts['晨间 (06-12)'] ?? 0,
            maxValue: maxVal,
            color: AppTheme.primaryLight,
          ),
          _buildPlainMetricBar(
            label: '午后',
            value: _timeOfDayCounts['午后 (12-18)'] ?? 0,
            maxValue: maxVal,
            color: AppTheme.primaryColor,
          ),
          _buildPlainMetricBar(
            label: '晚间',
            value: _timeOfDayCounts['晚间 (18-24)'] ?? 0,
            maxValue: maxVal,
            color: AppTheme.secondaryColor,
          ),
          _buildPlainMetricBar(
            label: '深夜',
            value: _timeOfDayCounts['深夜 (00-06)'] ?? 0,
            maxValue: maxVal,
            color: AppTheme.primaryDark,
          ),
        ],
      ),
    );
  }

  Widget _buildPlainMetricBar({
    required String label,
    required int value,
    required int maxValue,
    required Color color,
  }) {
    final progress = maxValue <= 0 ? 0.0 : value / maxValue;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 44,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 12,
                color: color,
                backgroundColor: color.withValues(alpha: 0.12),
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 28,
            child: Text(
              '$value',
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
        ),
      ],
    );
  }

  Widget _buildHeatmapSection() {
    return _buildHeatMap();
  }

  Widget _buildDistributionSection() {
    if (_moodCounts.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDistributionHeader(),
            const SizedBox(height: 16),
            _buildDistributionRangeChips(),
            const SizedBox(height: 18),
            const Text(
              '这个范围里还没有记录',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              '切换到全部或选择其他日期范围，可以查看已有记录的情绪分布。',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textHint,
                height: 1.4,
              ),
            ),
          ],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDistributionHeader(),
              const SizedBox(height: 14),
              _buildDistributionRangeChips(),
              const SizedBox(height: 16),
              _buildMoodDistributionBars(),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '详细数据',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              ..._buildLegend(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDistributionHeader() {
    final total = _moodCounts.values.fold<int>(0, (sum, value) => sum + value);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: Text(
            '情绪分布',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _distributionRangeLabel(),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              total > 0 ? '$total 条记录' : '暂无记录',
              style: const TextStyle(fontSize: 11, color: AppTheme.textHint),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMoodDistributionBars() {
    final sortedEntries = _moodCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final total = _moodCounts.values.fold<int>(0, (sum, value) => sum + value);
    if (total == 0) return const SizedBox.shrink();

    return Column(
      children: sortedEntries.map((entry) {
        final color = AppTheme.moodColors[entry.key] ?? AppTheme.primaryColor;
        final percent = entry.value / total;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    _getEmojiForMood(entry.key),
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      entry.key,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                  Text(
                    '${entry.value}次 ${(percent * 100).round()}%',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 7),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: percent,
                  minHeight: 10,
                  color: color,
                  backgroundColor: color.withValues(alpha: 0.12),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDistributionRangeChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildDistributionChip('本月', _MoodDistributionRange.month),
        _buildDistributionChip('近30天', _MoodDistributionRange.last30Days),
        _buildDistributionChip('全部', _MoodDistributionRange.all),
        _buildCustomDistributionChip(),
      ],
    );
  }

  Widget _buildDistributionChip(String label, _MoodDistributionRange range) {
    final selected = _distributionRange == range;
    return InkWell(
      onTap: () => _setDistributionRange(range),
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.primaryColor
              : AppTheme.surfaceColor.withValues(alpha: 0.82),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildCustomDistributionChip() {
    final selected = _distributionRange == _MoodDistributionRange.custom;
    return InkWell(
      onTap: _pickCustomDistributionRange,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.primaryColor
              : AppTheme.surfaceColor.withValues(alpha: 0.82),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.date_range_rounded,
              size: 14,
              color: selected ? Colors.white : AppTheme.textSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              selected ? '自定义' : '选日期',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _distributionRangeLabel() {
    switch (_distributionRange) {
      case _MoodDistributionRange.month:
        return '${_calendarMonth.year}.${_calendarMonth.month.toString().padLeft(2, '0')}';
      case _MoodDistributionRange.last30Days:
        return '近30天';
      case _MoodDistributionRange.all:
        return '全部记录';
      case _MoodDistributionRange.custom:
        final start = _customDistributionStart;
        final end = _customDistributionEnd;
        if (start == null || end == null) return '自定义';
        return '${start.month}.${start.day}-${end.month}.${end.day}';
    }
  }

  Widget _buildWordSection() {
    final sorted =
        _wordFrequency.entries
            .where((e) => e.value >= 2) // 至少出现 2 次才展示，过滤单次粘贴的提示语
            .toList()
          ..sort((a, b) => b.value.compareTo(a.value));
    final topWords = sorted.take(30).toList();
    if (topWords.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '高频词汇',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: topWords.map((e) {
              final weight = (e.value / (topWords.first.value)).clamp(0.2, 1.0);
              // 控制词云字号不要超过小标题
              final size = (11 + 3 * weight).toDouble();
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(
                    alpha: 0.08 + 0.12 * weight,
                  ),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${e.key} ${e.value}',
                  style: TextStyle(
                    fontSize: size,
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHealingCard() {
    if (_rangeRecords.length < 3) return const SizedBox.shrink();

    final synthesized = _synthesizeHealingAssessment();
    final recommendations = TherapyRecommendationService.recommendationsFor(
      synthesized,
    );
    if (recommendations.isEmpty) return const SizedBox.shrink();
    final primary = recommendations.first;
    final others = recommendations.skip(1).toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.favorite_border_rounded,
                  color: AppTheme.primaryColor,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                '恢复方向',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppTheme.primaryColor.withValues(alpha: 0.12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '根据近期记录生成 · 适合从 ${primary.approach.shortLabel} 开始',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  primary.approach.label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  primary.rationale,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textPrimary,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '先做什么：${primary.approach.firstStep}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          if (others.isNotEmpty) ...[
            const SizedBox(height: 14),
            ...others.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '• ',
                      style: TextStyle(color: AppTheme.textSecondary),
                    ),
                    Expanded(
                      child: Text(
                        '${item.approach.shortLabel}：${item.rationale}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  AssessmentResult _synthesizeHealingAssessment() {
    final counts = _moodCounts;
    final anxious = counts['焦虑'] ?? 0;
    final sad = counts['难过'] ?? 0;
    final angry = counts['生气'] ?? 0;
    final tired = counts['疲惫'] ?? 0;
    final happy = counts['开心'] ?? 0;
    final love = counts['幸福'] ?? 0;

    final stressLoad = anxious + sad + angry + tired;
    final positiveLoad = happy + love;
    final total = _rangeRecords.length;

    final intensityAverage = total == 0
        ? 0.0
        : _rangeRecords.fold<double>(
                0,
                (sum, record) => sum + record.intensity,
              ) /
              total;

    final severity = switch ((stressLoad, intensityAverage)) {
      (_, >= 75) => AssessmentSeverity.elevated,
      (>= 6, _) => AssessmentSeverity.elevated,
      (_, >= 58) => AssessmentSeverity.moderate,
      (>= 4, _) => AssessmentSeverity.moderate,
      (>= 2, _) => AssessmentSeverity.mild,
      _ => AssessmentSeverity.low,
    };

    final dominantNegative = {
      '焦虑': anxious,
      '难过': sad,
      '生气': angry,
      '疲惫': tired,
    }.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    final dominantMood =
        dominantNegative.isNotEmpty && dominantNegative.first.value > 0
        ? dominantNegative.first.key
        : '开心';

    final assessmentId = switch (dominantMood) {
      '焦虑' => 'gad_daily_healing',
      '疲惫' => 'gad_daily_healing',
      '难过' => 'phq_daily_healing',
      '生气' => 'stress_daily_healing',
      _ => 'general_daily_healing',
    };

    final guidance = positiveLoad >= stressLoad
        ? '最近也有不少稳定或积极的时刻，重点不是纠正自己，而是把这些有帮助的动作继续做下去。'
        : '最近负担感更明显，先找一个最能稳住你的方向，比同时想做很多事更有效。';

    return AssessmentResult(
      assessmentId: assessmentId,
      assessmentName: '近期恢复建议',
      category: AssessmentCategory.selfReflection,
      resultTitle: '当前更适合先稳住自己',
      summary: '这是根据你最近的情绪记录生成的恢复方向提示，不代替专业评估。',
      guidance: guidance,
      emoji: _getEmojiForMood(dominantMood),
      totalScore: stressLoad,
      maxScore: 10,
      severity: severity,
      recommendProfessionalSupport:
          severity.index >= AssessmentSeverity.moderate.index,
      urgentSafetyReview: false,
      isStandardized: false,
      createdAt: DateTime.now(),
    );
  }

  Widget _buildAssessmentQuickEntries() {
    return Row(
      children: [
        Expanded(
          child: _buildCompactAssessmentEntry(
            title: '性格评测',
            icon: Icons.psychology_alt_outlined,
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const EmotionTestPage(
                    entryMode: AssessmentEntryMode.personalityOnly,
                  ),
                ),
              );
              if (mounted) _loadStats();
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildCompactAssessmentEntry(
            title: '心理评测',
            icon: Icons.psychology_outlined,
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const EmotionTestPage(),
                ),
              );
              if (mounted) _loadStats();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCompactAssessmentEntry({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 88),
          padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withValues(alpha: 0.045),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppTheme.primaryColor, size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.2,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: AppTheme.textHint,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrendChart() {
    if (_dailyAvgIntensity.isEmpty) {
      return _emptyInlineCard(title: '情绪趋势', subtitle: '暂无可用的趋势数据。');
    }

    final sorted = _dailyAvgIntensity.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    final visible = sorted.length > 14
        ? sorted.sublist(sorted.length - 14)
        : sorted;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '强度趋势',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Column(
            children: visible.map((entry) {
              final date = entry.key;
              final value = entry.value.clamp(0, 100).toDouble();
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    SizedBox(
                      width: 48,
                      child: Text(
                        '${date.month}/${date.day}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textHint,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          value: value / 100,
                          minHeight: 10,
                          color: AppTheme.primaryColor,
                          backgroundColor: AppTheme.primaryColor.withValues(
                            alpha: 0.12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 34,
                      child: Text(
                        value.toStringAsFixed(0),
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _emptyInlineCard({required String title, required String subtitle}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
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
          const SizedBox(height: 6),
          Text(subtitle, style: const TextStyle(color: AppTheme.textSecondary)),
        ],
      ),
    );
  }

  // 获取旧版热力图数据：日期 -> 记录数
  Map<DateTime, int> _getHeatMapData() {
    final Map<DateTime, int> data = {};
    for (var record in _rangeRecords) {
      final date = DateTime(
        record.createdAt.year,
        record.createdAt.month,
        record.createdAt.day,
      );
      data[date] = (data[date] ?? 0) + 1;
    }
    return data;
  }

  Widget _buildHeatMap() {
    final data = _getHeatMapData();
    final now = DateTime.now();
    final endDate = DateTime(now.year, now.month, now.day);
    const weeksCount = 13;
    final startDate = endDate.subtract(const Duration(days: weeksCount * 7));

    final weeks = <List<DateTime>>[];
    var current = startDate;
    while (current.weekday != 7) {
      current = current.subtract(const Duration(days: 1));
    }
    for (var i = 0; i < weeksCount + 1; i++) {
      final week = <DateTime>[];
      for (var j = 0; j < 7; j++) {
        week.add(current);
        current = current.add(const Duration(days: 1));
      }
      weeks.add(week);
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '心情热力图',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            '近 13 周记录越密集，颜色越深。',
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true,
            child: Row(
              children: weeks.map((week) {
                return Container(
                  margin: const EdgeInsets.only(right: 4),
                  child: Column(
                    children: week.map((date) {
                      final count = data[date] ?? 0;
                      var color = AppTheme.surfaceColor;
                      if (date.isAfter(endDate)) {
                        color = Colors.transparent;
                      } else if (count == 1) {
                        color = AppTheme.primaryColor.withValues(alpha: 0.36);
                      } else if (count == 2) {
                        color = AppTheme.primaryColor.withValues(alpha: 0.64);
                      } else if (count > 2) {
                        color = AppTheme.primaryColor;
                      }

                      final cell = Container(
                        width: 13,
                        height: 13,
                        margin: const EdgeInsets.only(bottom: 4),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );

                      if (count <= 0 || date.isAfter(endDate)) return cell;
                      final dayRecords = _rangeRecords.where((record) {
                        final d = DateTime(
                          record.createdAt.year,
                          record.createdAt.month,
                          record.createdAt.day,
                        );
                        return d == date;
                      }).toList();
                      return GestureDetector(
                        onTap: () => _showDayRecords(context, date, dayRecords),
                        child: cell,
                      );
                    }).toList(),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                '少',
                style: TextStyle(fontSize: 10, color: AppTheme.textHint),
              ),
              const SizedBox(width: 4),
              Container(width: 10, height: 10, color: AppTheme.surfaceColor),
              const SizedBox(width: 2),
              Container(
                width: 10,
                height: 10,
                color: AppTheme.primaryColor.withValues(alpha: 0.36),
              ),
              const SizedBox(width: 2),
              Container(
                width: 10,
                height: 10,
                color: AppTheme.primaryColor.withValues(alpha: 0.64),
              ),
              const SizedBox(width: 2),
              const SizedBox(
                width: 10,
                height: 10,
                child: ColoredBox(color: AppTheme.primaryColor),
              ),
              const SizedBox(width: 4),
              const Text(
                '多',
                style: TextStyle(fontSize: 10, color: AppTheme.textHint),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDayRecords(
    BuildContext context,
    DateTime date,
    List<EmotionRecord> records,
  ) {
    final dayRecords = List<EmotionRecord>.from(records)
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    if (dayRecords.isEmpty) return;

    final dateStr =
        date.month == DateTime.now().month && date.day == DateTime.now().day
        ? '今天'
        : '${date.month}月${date.day}日';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(ctx).size.height * 0.6,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Text(
              '$dateStr · ${dayRecords.length} 条情绪',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 24),
                itemCount: dayRecords.length,
                itemBuilder: (context, index) {
                  final r = dayRecords[index];
                  final timeStr =
                      '${r.createdAt.hour.toString().padLeft(2, '0')}:${r.createdAt.minute.toString().padLeft(2, '0')}';
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        Navigator.pop(ctx);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (c) => RecordDetailPage(record: r),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color:
                              AppTheme.moodColors[r.mood]?.withValues(
                                alpha: 0.08,
                              ) ??
                              AppTheme.surfaceColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Text(r.emoji, style: const TextStyle(fontSize: 22)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    r.mood,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                  if (r.note.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      r.note,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            Text(
                              timeStr,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.textHint,
                              ),
                            ),
                          ],
                        ),
                      ),
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

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildFullWidthButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
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
        child: Text(label),
      ),
    );
  }

  Widget _buildOutlinedFullWidthButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.primaryColor,
          side: const BorderSide(color: AppTheme.primaryColor),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(label),
      ),
    );
  }

  String _getEmojiForMood(String mood) {
    final moodEmojis = {
      '开心': '😊',
      '幸福': '🥰',
      '平静': '🫧',
      '难过': '😢',
      '生气': '😠',
      '焦虑': '😰',
      '疲惫': '😴',
    };
    return moodEmojis[mood] ?? '😐';
  }

  List<Widget> _buildLegend() {
    final sortedEntries = _moodCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final total = _moodCounts.values.reduce((a, b) => a + b);

    return sortedEntries.map((entry) {
      final color = AppTheme.moodColors[entry.key] ?? Colors.grey;
      final percentage = (entry.value / total * 100).round();

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              _getEmojiForMood(entry.key),
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                entry.key,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
            Text(
              '${entry.value}次',
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$percentage%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}

class _SupportPlanSnapshot {
  final String key;
  final String assessmentId;
  final DateTime startedAt;
  final int completedTasks;
  final int totalTasks;
  final AssessmentResult? result;

  const _SupportPlanSnapshot({
    required this.key,
    required this.assessmentId,
    required this.startedAt,
    required this.completedTasks,
    required this.totalTasks,
    this.result,
  });

  double get completionRate =>
      totalTasks == 0 ? 0.0 : completedTasks / totalTasks;
}

class _RetestReminderInfo {
  final String key;
  final String assessmentId;
  final String assessmentName;
  final DateTime scheduledAt;
  final int notificationId;

  const _RetestReminderInfo({
    required this.key,
    required this.assessmentId,
    required this.assessmentName,
    required this.scheduledAt,
    required this.notificationId,
  });

  factory _RetestReminderInfo.fromMap(Map<String, dynamic> map) {
    return _RetestReminderInfo(
      key: map['key']?.toString() ?? '',
      assessmentId: map['assessmentId']?.toString() ?? '',
      assessmentName: map['assessmentName']?.toString() ?? '',
      scheduledAt:
          DateTime.tryParse(map['scheduledAt']?.toString() ?? '') ??
          DateTime.now(),
      notificationId:
          int.tryParse(map['notificationId']?.toString() ?? '') ?? 0,
    );
  }
}

// 设置页 - 优化版
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final DatabaseService _dbService = DatabaseService();
  AppSettings _settings = AppSettings();
  bool _isLoading = true;
  String _version = '1.1.9';
  String _buildNumber = '8';

  List<Map<String, dynamic>> _systemReminders = [];

  @override
  void initState() {
    super.initState();
    _loadVersion();
    _loadSettings();
    _loadSystemReminders();
  }

  Future<void> _loadSystemReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonStr = prefs.getString('system_reminders_list');
    if (jsonStr != null) {
      try {
        final List<dynamic> list = jsonDecode(jsonStr);
        if (mounted) {
          setState(() {
            _systemReminders = List<Map<String, dynamic>>.from(list);
          });
        }
      } catch (e) {
        print('Error parsing system reminders: $e');
      }
    }
  }

  Future<void> _saveSystemReminders() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('system_reminders_list', jsonEncode(_systemReminders));
    await DailyReminderService.syncAndroidReminders(_systemReminders);
  }

  Future<void> _loadVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() {
          _version = packageInfo.version;
          _buildNumber = packageInfo.buildNumber;
        });
      }
    } catch (e) {
      print('Error loading version: $e');
    }
  }

  Future<bool> _scheduleOrCancelReminder(
    AppSettings s, {
    bool requestPermission = false,
  }) async {
    try {
      if (s.notificationsEnabled) {
        await DailyReminderService.init();
        final hasPermission = requestPermission
            ? await DailyReminderService.checkAndRequestPermissions()
            : await DailyReminderService.hasPermission();
        if (!hasPermission) return false;
        return DailyReminderService.scheduleDaily(
          s.reminderHour,
          s.reminderMinute,
        );
      } else {
        await DailyReminderService.cancelDaily();
        return true;
      }
    } catch (e) {
      print('Daily reminder schedule error: $e');
      return false;
    }
  }

  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);
    try {
      final settings = await _dbService.getSettings();
      if (settings != null) {
        setState(() {
          _settings = AppSettings.fromMap(settings);
          _isLoading = false;
        });
        await _scheduleOrCancelReminder(_settings);
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Error loading settings: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateSettings(AppSettings newSettings) async {
    final reminderReady = await _scheduleOrCancelReminder(
      newSettings,
      requestPermission: true,
    );
    if (newSettings.notificationsEnabled && !reminderReady) {
      throw Exception('提醒调度失败，请确认通知权限已开启后重试');
    }
    await _dbService.updateSettings(newSettings.toMap());
    if (mounted) _loadSettings();
  }

  // 设置密码对话框（首次开启应用锁）
  Future<void> _showSetPinDialog() async {
    final newPinController = TextEditingController();
    final confirmPinController = TextEditingController();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('设置应用锁密码'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: newPinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 4,
                decoration: const InputDecoration(
                  labelText: '设置 4 位数字密码',
                  counterText: '',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirmPinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 4,
                decoration: const InputDecoration(
                  labelText: '确认密码',
                  counterText: '',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () async {
                final next = newPinController.text.trim();
                final confirm = confirmPinController.text.trim();

                if (next.length != 4 || int.tryParse(next) == null) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('请输入 4 位数字密码')));
                  return;
                }
                if (next != confirm) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('两次输入的密码不一致')));
                  return;
                }

                await _updateSettings(
                  _settings.copyWith(
                    appLockEnabled: true,
                    appLockPin: next,
                    lockTimeoutSeconds: 300,
                  ),
                );
                if (mounted) Navigator.of(context).pop();
              },
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
  }

  // 修改密码对话框
  Future<void> _showChangePinDialog() async {
    final currentPinController = TextEditingController();
    final newPinController = TextEditingController();
    final confirmPinController = TextEditingController();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('修改密码'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 4,
                decoration: const InputDecoration(
                  labelText: '当前密码',
                  counterText: '',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: newPinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 4,
                decoration: const InputDecoration(
                  labelText: '新密码',
                  counterText: '',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirmPinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 4,
                decoration: const InputDecoration(
                  labelText: '确认新密码',
                  counterText: '',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () async {
                final current = currentPinController.text.trim();
                final next = newPinController.text.trim();
                final confirm = confirmPinController.text.trim();

                if (current != _settings.appLockPin) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('当前密码不正确')));
                  return;
                }

                if (next.length != 4 || int.tryParse(next) == null) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('请输入 4 位数字密码')));
                  return;
                }
                if (next != confirm) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('两次输入的密码不一致')));
                  return;
                }

                await _updateSettings(_settings.copyWith(appLockPin: next));
                if (mounted) Navigator.of(context).pop();
              },
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
  }

  // 关闭应用锁对话框（需要验证密码）
  Future<void> _showDisableLockDialog() async {
    final currentPinController = TextEditingController();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('关闭应用锁'),
          content: TextField(
            controller: currentPinController,
            obscureText: true,
            keyboardType: TextInputType.number,
            maxLength: 4,
            decoration: const InputDecoration(
              labelText: '输入当前密码以关闭',
              counterText: '',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () async {
                final current = currentPinController.text.trim();

                if (current != _settings.appLockPin) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('密码不正确')));
                  return;
                }

                await _updateSettings(
                  _settings.copyWith(
                    appLockEnabled: false,
                    appLockPin: '',
                    lockTimeoutSeconds: 300,
                  ),
                );
                if (mounted) Navigator.of(context).pop();
              },
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
  }

  String _formatLockTimeoutLabel(int seconds) {
    if (seconds == 0) return '立即锁定';
    if (seconds == 60) return '1 分钟';
    if (seconds == 120) return '2 分钟';
    if (seconds == 300) return '5 分钟';
    if (seconds > 0 && seconds % 60 == 0) return '${seconds ~/ 60} 分钟';
    return '${seconds ~/ 60} 分钟';
  }

  Future<void> _showLockTimeoutPicker() async {
    final options = [
      (0, '立即锁定'),
      (60, '1 分钟'),
      (120, '2 分钟'),
      (300, '5 分钟'),
      (-1, '自定义时间'),
    ];

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    '离开后锁屏',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
                ...options.map((e) {
                  final (value, label) = e;
                  final isCustom = value == -1;
                  final isSelected = isCustom
                      ? _settings.lockTimeoutSeconds != 0 &&
                            _settings.lockTimeoutSeconds != 60 &&
                            _settings.lockTimeoutSeconds != 120 &&
                            _settings.lockTimeoutSeconds != 300
                      : _settings.lockTimeoutSeconds == value;

                  return ListTile(
                    title: Text(
                      isCustom ? label : _formatLockTimeoutLabel(value),
                      style: TextStyle(
                        color: isSelected
                            ? AppTheme.primaryColor
                            : AppTheme.textPrimary,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check, color: AppTheme.primaryColor)
                        : null,
                    onTap: () async {
                      Navigator.of(context).pop();
                      if (isCustom) {
                        final ctrl = TextEditingController();
                        await showDialog<void>(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              title: const Text('自定义时间'),
                              content: TextField(
                                controller: ctrl,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: '输入分钟数',
                                  suffixText: '分钟',
                                ),
                                autofocus: true,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(),
                                  child: const Text('取消'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    final mins = int.tryParse(ctrl.text.trim());
                                    if (mins != null &&
                                        mins > 0 &&
                                        mins <= 1440) {
                                      Navigator.of(ctx).pop();
                                      _updateSettings(
                                        _settings.copyWith(
                                          lockTimeoutSeconds: mins * 60,
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('请输入 1–1440 之间的分钟数'),
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text('确定'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        _updateSettings(
                          _settings.copyWith(lockTimeoutSeconds: value),
                        );
                      }
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _exportData() async {
    try {
      final records = await _dbService.getEmotionRecords();
      final data = {
        'exportedAt': DateTime.now().toIso8601String(),
        'version': _version,
        'records': records,
      };

      final jsonStr = const JsonEncoder.withIndent('  ').convert(data);
      final dir = await getApplicationDocumentsDirectory();
      final ts = DateTime.now()
          .toIso8601String()
          .replaceAll(':', '-')
          .replaceAll('.', '-')
          .replaceAll(' ', '_');
      final fileName = 'emoon_export_$ts.json';
      final file = File('${dir.path}/$fileName');
      await file.writeAsString(jsonStr, flush: true);

      if (OhosNativeService.isOhos) {
        final success = await OhosNativeService.saveDocument(fileName, jsonStr);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(success ? '数据已导出成功' : '导出失败，请重试')),
          );
        }
      } else {
        final xFile = XFile(
          file.path,
          mimeType: 'application/json',
          name: fileName,
        );

        try {
          await Share.shareXFiles([xFile], text: 'FOMO情绪 · 数据导出');
        } catch (shareErr) {
          await Share.share(jsonStr, subject: 'FOMO情绪 · 数据导出');
        }
      }
    } catch (e) {
      if (!mounted) return;
      final errorMsg =
          e.toString().contains('MissingPluginException') ||
              e.toString().contains('UnimplementedError')
          ? '当前系统暂不支持数据导出功能'
          : '导出失败：$e';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMsg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final safeTop = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/bg_wode.png',
              fit: BoxFit.fitWidth,
              alignment: Alignment.topRight,
            ),
          ),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: false,
                pinned: false,
                expandedHeight: safeTop + PrimaryPageLayout.headerHeightOffset,
                toolbarHeight: 0,
                elevation: 0,
                shadowColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                forceMaterialTransparency: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: PrimaryPageHeader(
                    safeTop: safeTop,
                    title: '我的',
                    subtitle: '管理提醒、隐私和应用设置',
                    titleColor: AppTheme.textPrimary,
                    subtitleColor: AppTheme.textSecondary,
                  ),
                ),
              ),
              if (_isLoading)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryColor,
                    ),
                  ),
                )
              else
                SliverToBoxAdapter(
                  child: Transform.translate(
                    offset: Offset.zero,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 提醒设置
                          _buildSectionTitle('提醒', Icons.notifications_active),
                          const SizedBox(height: 12),
                          _buildSettingsGroup(
                            child: Column(
                              children: [
                                ListTile(
                                  minVerticalPadding: 14,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 6,
                                  ),
                                  leading: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryColor.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.notifications_active,
                                      color: AppTheme.primaryColor,
                                      size: 20,
                                    ),
                                  ),
                                  title: const Text('系统提醒'),
                                  trailing: Switch(
                                    value: _settings.notificationsEnabled,
                                    onChanged: (value) {
                                      _updateSettings(
                                        _settings.copyWith(
                                          notificationsEnabled: value,
                                        ),
                                      );
                                    },
                                    activeThumbColor: AppTheme.primaryColor,
                                  ),
                                ),
                                _buildSettingDivider(),
                                if (_systemReminders.isNotEmpty) _buildSettingDivider(),
                                ..._systemReminders.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final reminder = entry.value;
                                  final hourStr = reminder['hour'].toString().padLeft(2, '0');
                                  final minuteStr = reminder['minute'].toString().padLeft(2, '0');
                                  return ListTile(
                                    minVerticalPadding: 14,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 6,
                                    ),
                                    leading: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryColor.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.access_time,
                                        color: AppTheme.primaryColor,
                                        size: 20,
                                      ),
                                    ),
                                    title: Text('$hourStr:$minuteStr', style: const TextStyle(fontWeight: FontWeight.bold)),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                                      onPressed: () async {
                                        final id = reminder['id'];
                                        await DailyReminderService.cancelDaily(id: id);
                                        setState(() {
                                          _systemReminders.removeAt(index);
                                        });
                                        await _saveSystemReminders();
                                      },
                                    ),
                                  );
                                }),
                                if (_systemReminders.isNotEmpty) _buildSettingDivider(),
                                ListTile(
                                  minVerticalPadding: 14,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 6,
                                  ),
                                  leading: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryColor.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.add_alert,
                                      color: AppTheme.primaryColor,
                                      size: 20,
                                    ),
                                  ),
                                  title: const Text('添加提醒时间', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
                                  onTap: () async {
                                    final time = await showModalBottomSheet<TimeOfDay>(
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      builder: (BuildContext builder) {
                                        TimeOfDay selectedTime = const TimeOfDay(hour: 20, minute: 0);
                                        return Container(
                                          height: 300,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                            ),
                                          ),
                                          child: SafeArea(
                                            top: false,
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      TextButton(
                                                        child: const Text('取消', style: TextStyle(color: Colors.grey, fontSize: 16)),
                                                        onPressed: () => Navigator.of(context).pop(),
                                                      ),
                                                      const Text('添加提醒时间', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textPrimary)),
                                                      TextButton(
                                                        child: const Text('确定', style: TextStyle(color: AppTheme.primaryColor, fontSize: 16, fontWeight: FontWeight.bold)),
                                                        onPressed: () => Navigator.of(context).pop(selectedTime),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const Divider(height: 1),
                                                Expanded(
                                                  child: CupertinoDatePicker(
                                                    mode: CupertinoDatePickerMode.time,
                                                    use24hFormat: true,
                                                    initialDateTime: DateTime(2000, 1, 1, 20, 0),
                                                    onDateTimeChanged: (DateTime newDateTime) {
                                                      selectedTime = TimeOfDay.fromDateTime(newDateTime);
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                    if (time != null) {
                                      final id = time.hour * 100 + time.minute; // simple unique id based on time
                                      if (_systemReminders.any((r) => r['id'] == id)) {
                                        if (mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('该时间已存在')));
                                        }
                                        return;
                                      }
                                      
                                      const reminderTitles = [
                                        '今天的心情怎么样？',
                                        '记录一下今天的心情吧！',
                                        '今天过得怎么样？',
                                        '别忘了记录今天的感受～',
                                        '此刻的心情值得被记录',
                                        '你今天感觉如何？',
                                      ];
                                      final randomTitle = reminderTitles[math.Random().nextInt(reminderTitles.length)];
                                      
                                      if (_settings.notificationsEnabled) {
                                        await DailyReminderService.scheduleDaily(
                                          time.hour,
                                          time.minute,
                                          id: id,
                                          title: randomTitle,
                                        );
                                      }
                                      
                                      setState(() {
                                        _systemReminders.add({
                                          'id': id,
                                          'hour': time.hour,
                                          'minute': time.minute,
                                        });
                                        _systemReminders.sort((a, b) {
                                          if (a['hour'] != b['hour']) return a['hour'].compareTo(b['hour']);
                                          return a['minute'].compareTo(b['minute']);
                                        });
                                      });
                                      await _saveSystemReminders();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          if (Theme.of(context).platform == TargetPlatform.android) ...[
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                '为确保定时提醒在离线时准确送达，请前往手机设置赋予应用“允许自启动”权限，并在电池选项中设置为“无限制/不优化省电”。',
                                style: TextStyle(fontSize: 12, color: AppTheme.textHint),
                              ),
                            ),
                          ],
                          const SizedBox(height: 30),
                          _buildSectionTitle('周期', Icons.insights_outlined),
                          const SizedBox(height: 12),
                          _buildSettingsGroup(
                            child: ListTile(
                              minVerticalPadding: 14,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              leading: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.insights_rounded,
                                  color: AppTheme.primaryColor,
                                  size: 20,
                                ),
                              ),
                              title: const Text('周期情绪分析'),
                              subtitle: const Text(
                                '记录周期线索，发现情绪波动和生理周期的可能关联',
                                style: TextStyle(fontSize: 12),
                              ),
                              trailing: Switch(
                                value: _settings.cycleMoodAnalysisEnabled,
                                onChanged: (value) {
                                  _updateSettings(
                                    _settings.copyWith(
                                      cycleMoodAnalysisEnabled: value,
                                    ),
                                  );
                                },
                                activeThumbColor: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          _buildSectionTitle('数据', Icons.folder_outlined),
                          const SizedBox(height: 12),
                          _buildSettingsGroup(
                            child: Column(
                              children: [
                                _buildSettingItem(
                                  Icons.lock_clock_outlined,
                                  '我的时光胶囊',
                                  '',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const TimePage(),
                                      ),
                                    );
                                  },
                                ),
                                _buildSettingDivider(),
                                _buildSettingItem(
                                  Icons.psychology,
                                  '个人情绪词库',
                                  '',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const CustomEmotionsPage(),
                                      ),
                                    );
                                  },
                                ),
                                _buildSettingDivider(),
                                _buildSettingItem(
                                  Icons.file_download,
                                  '导出数据',
                                  'JSON 文件',
                                  onTap: _exportData,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          _buildSectionTitle('隐私安全', Icons.lock),
                          const SizedBox(height: 12),
                          _buildSettingsGroup(
                            child: Column(
                              children: [
                                // 应用锁开关
                                ListTile(
                                  minVerticalPadding: 14,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 6,
                                  ),
                                  leading: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryColor.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.lock_outline,
                                      color: AppTheme.primaryColor,
                                      size: 20,
                                    ),
                                  ),
                                  title: const Text('应用锁'),
                                  subtitle: const Text('保护记录隐私'),
                                  trailing: Switch(
                                    value:
                                        _settings.appLockEnabled &&
                                        _settings.appLockPin.isNotEmpty,
                                    onChanged: (value) async {
                                      if (value) {
                                        // 开启应用锁，需要先设置密码
                                        await _showSetPinDialog();
                                      } else {
                                        // 关闭应用锁，需要验证密码
                                        await _showDisableLockDialog();
                                      }
                                    },
                                    activeThumbColor: AppTheme.primaryColor,
                                  ),
                                ),
                                // 密码设置（仅当应用锁开启时显示）
                                if (_settings.appLockEnabled &&
                                    _settings.appLockPin.isNotEmpty) ...[
                                  _buildSettingDivider(),
                                  _buildSettingItem(
                                    Icons.key,
                                    '密码设置',
                                    '修改解锁密码',
                                    onTap: _showChangePinDialog,
                                  ),
                                  // 离开后锁屏
                                  _buildSettingDivider(),
                                  ListTile(
                                    minVerticalPadding: 14,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 6,
                                    ),
                                    leading: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryColor.withValues(
                                          alpha: 0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.timer_outlined,
                                        color: AppTheme.primaryColor,
                                        size: 20,
                                      ),
                                    ),
                                    title: const Text(
                                      '离开后锁屏',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppTheme.textPrimary,
                                      ),
                                    ),
                                    subtitle: Text(
                                      _formatLockTimeoutLabel(
                                        _settings.lockTimeoutSeconds,
                                      ),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                    trailing: const Icon(
                                      Icons.arrow_drop_down,
                                      color: AppTheme.textHint,
                                    ),
                                    onTap: _showLockTimeoutPicker,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          _buildSectionTitle('关于', Icons.info),
                          const SizedBox(height: 12),
                          _buildSettingsGroup(
                            child: Column(
                              children: [
                                ListTile(
                                  minVerticalPadding: 14,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 6,
                                  ),
                                  leading: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryColor.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.support_agent,
                                      color: AppTheme.primaryColor,
                                      size: 20,
                                    ),
                                  ),
                                  title: const Text('意见反馈'),
                                  trailing: const Text(
                                    'novcat11',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                  onTap: () async {
                                    if (!context.mounted) return;
                                    await showDialog<void>(
                                      context: context,
                                      builder: (dialogContext) {
                                        return AlertDialog(
                                          title: const Text('意见反馈'),
                                          content: const Text(
                                            '微信号：novcat11\n请手动复制后在微信中搜索添加。',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.of(
                                                dialogContext,
                                              ).pop(),
                                              child: const Text('知道了'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                                _buildSettingDivider(),
                                _buildSettingItem(
                                  Icons.privacy_tip,
                                  '隐私政策',
                                  '',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const PrivacyPolicyPage(),
                                      ),
                                    );
                                  },
                                ),
                                _buildSettingDivider(),
                                _buildSettingItem(
                                  Icons.description,
                                  '用户协议',
                                  '',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const UserAgreementPage(),
                                      ),
                                    );
                                  },
                                ),
                                _buildSettingDivider(),
                                ListTile(
                                  minVerticalPadding: 14,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 6,
                                  ),
                                  leading: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryColor.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.eco,
                                      color: AppTheme.primaryColor,
                                      size: 20,
                                    ),
                                  ),
                                  title: const Text('版本信息'),
                                  trailing: Text(
                                    'v$_version ($_buildNumber)',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppTheme.textSecondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppTheme.primaryColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsGroup({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSettingDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 72, right: 18),
      child: Divider(
        height: 1,
        thickness: 1,
        color: AppTheme.surfaceColor.withValues(alpha: 0.8),
      ),
    );
  }

  Widget _buildSettingItem(
    IconData icon,
    String title,
    String subtitle, {
    VoidCallback? onTap,
  }) {
    final hasSubtitle = subtitle.isNotEmpty;
    return ListTile(
      minVerticalPadding: hasSubtitle ? 14 : 16,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: hasSubtitle ? 6 : 10,
      ),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppTheme.primaryColor, size: 20),
      ),
      title: Text(title),
      subtitle: hasSubtitle
          ? Text(subtitle, style: const TextStyle(fontSize: 12))
          : null,
      trailing: const Icon(Icons.chevron_right, color: AppTheme.textHint),
      onTap: onTap,
    );
  }
}

// 数据模型

class AppSettings {
  final bool darkMode;
  final bool notificationsEnabled;
  final int reminderHour;
  final int reminderMinute;
  final bool appLockEnabled;
  final String appLockPin;
  final int lockTimeoutSeconds;
  final bool cycleMoodAnalysisEnabled;

  AppSettings({
    this.darkMode = false,
    this.notificationsEnabled = false,
    this.reminderHour = 20,
    this.reminderMinute = 0,
    this.appLockEnabled = false,
    this.appLockPin = '',
    this.lockTimeoutSeconds = 300,
    this.cycleMoodAnalysisEnabled = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'darkMode': darkMode ? 1 : 0,
      'notificationsEnabled': notificationsEnabled ? 1 : 0,
      'reminderHour': reminderHour,
      'reminderMinute': reminderMinute,
      'appLockEnabled': appLockEnabled ? 1 : 0,
      'appLockPin': appLockPin,
      'lockTimeoutSeconds': lockTimeoutSeconds,
      'cycleMoodAnalysisEnabled': cycleMoodAnalysisEnabled ? 1 : 0,
    };
  }

  factory AppSettings.fromMap(Map<String, dynamic> map) {
    return AppSettings(
      darkMode: map['darkMode'] == 1,
      notificationsEnabled: map['notificationsEnabled'] == 1,
      reminderHour: map['reminderHour'] ?? 20,
      reminderMinute: map['reminderMinute'] ?? 0,
      appLockEnabled: map['appLockEnabled'] == 1,
      appLockPin: map['appLockPin'] ?? '',
      lockTimeoutSeconds: map['lockTimeoutSeconds'] ?? 300,
      cycleMoodAnalysisEnabled: map['cycleMoodAnalysisEnabled'] == 1,
    );
  }

  AppSettings copyWith({
    bool? darkMode,
    bool? notificationsEnabled,
    int? reminderHour,
    int? reminderMinute,
    bool? appLockEnabled,
    String? appLockPin,
    int? lockTimeoutSeconds,
    bool? cycleMoodAnalysisEnabled,
  }) {
    return AppSettings(
      darkMode: darkMode ?? this.darkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
      appLockEnabled: appLockEnabled ?? this.appLockEnabled,
      appLockPin: appLockPin ?? this.appLockPin,
      lockTimeoutSeconds: lockTimeoutSeconds ?? this.lockTimeoutSeconds,
      cycleMoodAnalysisEnabled:
          cycleMoodAnalysisEnabled ?? this.cycleMoodAnalysisEnabled,
    );
  }
}
