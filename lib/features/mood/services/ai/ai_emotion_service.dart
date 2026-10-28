import '../../models/ai_emotion_result.dart';

/// AI 情绪分析器抽象接口
abstract class EmotionAnalyzer {
  /// 分析器名称
  String get name;

  /// 分析来源类型
  String get source;

  /// 是否已初始化
  bool get isInitialized;

  /// 初始化分析器（加载模型等）
  Future<bool> initialize();

  /// 释放资源
  Future<void> dispose();
}

/// 文本情绪分析器接口
abstract class TextEmotionAnalyzer extends EmotionAnalyzer {
  @override
  String get source => 'text';

  /// 分析文本情绪
  Future<AiEmotionResult?> analyze(String text);
}

/// 语音情绪分析器接口
abstract class VoiceEmotionAnalyzer extends EmotionAnalyzer {
  @override
  String get source => 'voice';

  /// 分析语音文件情绪
  /// [audioPath] 音频文件路径
  Future<AiEmotionResult?> analyze(String audioPath);

  /// 带上下文的语音情绪分析。
  /// 默认回退到仅使用音频路径分析，便于旧实现继续工作。
  Future<AiEmotionResult?> analyzeWithContext(
    String audioPath, {
    Map<String, dynamic>? context,
  }) async {
    return analyze(audioPath);
  }
}

/// 人脸情绪分析器接口
abstract class FaceEmotionAnalyzer extends EmotionAnalyzer {
  @override
  String get source => 'face';

  /// 分析人脸图片情绪
  /// [imagePath] 图片文件路径
  Future<AiEmotionResult?> analyze(String imagePath);
}

/// AI 情绪服务 - 统一入口
class AiEmotionService {
  static final AiEmotionService _instance = AiEmotionService._internal();
  factory AiEmotionService() => _instance;
  AiEmotionService._internal();

  TextEmotionAnalyzer? _textAnalyzer;
  VoiceEmotionAnalyzer? _voiceAnalyzer;
  FaceEmotionAnalyzer? _faceAnalyzer;

  bool _isInitialized = false;

  /// 是否已初始化
  bool get isInitialized => _isInitialized;

  /// 注册文本分析器
  void registerTextAnalyzer(TextEmotionAnalyzer analyzer) {
    _textAnalyzer = analyzer;
  }

  /// 注册语音分析器
  void registerVoiceAnalyzer(VoiceEmotionAnalyzer analyzer) {
    _voiceAnalyzer = analyzer;
  }

  /// 注册人脸分析器
  void registerFaceAnalyzer(FaceEmotionAnalyzer analyzer) {
    _faceAnalyzer = analyzer;
  }

  /// 初始化所有已注册的分析器
  Future<void> initializeAll() async {
    final results = await Future.wait([
      _textAnalyzer?.initialize() ?? Future.value(false),
      _voiceAnalyzer?.initialize() ?? Future.value(false),
      _faceAnalyzer?.initialize() ?? Future.value(false),
    ]);

    _isInitialized = results.any((r) => r);
  }

  /// 分析文本情绪
  Future<AiEmotionResult?> analyzeText(String text) async {
    if (_textAnalyzer == null || !_textAnalyzer!.isInitialized) {
      return null;
    }
    return _textAnalyzer!.analyze(text);
  }

  /// 分析语音情绪
  Future<AiEmotionResult?> analyzeVoice(
    String audioPath, {
    Map<String, dynamic>? context,
  }) async {
    if (_voiceAnalyzer == null || !_voiceAnalyzer!.isInitialized) {
      return null;
    }
    return _voiceAnalyzer!.analyzeWithContext(audioPath, context: context);
  }

  /// 分析人脸情绪
  Future<AiEmotionResult?> analyzeFace(String imagePath) async {
    if (_faceAnalyzer == null || !_faceAnalyzer!.isInitialized) {
      return null;
    }
    return _faceAnalyzer!.analyze(imagePath);
  }

  /// 释放所有资源
  Future<void> disposeAll() async {
    await _textAnalyzer?.dispose();
    await _voiceAnalyzer?.dispose();
    await _faceAnalyzer?.dispose();
    _isInitialized = false;
  }

  /// 获取可用的分析器列表
  List<String> get availableAnalyzers {
    final list = <String>[];
    if (_textAnalyzer?.isInitialized == true) list.add('text');
    if (_voiceAnalyzer?.isInitialized == true) list.add('voice');
    if (_faceAnalyzer?.isInitialized == true) list.add('face');
    return list;
  }
}
