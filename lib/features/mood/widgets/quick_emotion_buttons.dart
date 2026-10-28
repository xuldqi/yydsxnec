import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../theme/app_theme.dart';
import '../models/ai_emotion_result.dart';
import '../services/ai/ai_emotion_service.dart';
import '../services/ohos_native_service.dart';
import '../services/ai/text_emotion_analyzer.dart';
import '../services/ai/voice_emotion_analyzer_stub.dart'
    if (dart.library.io) '../services/ai/voice_emotion_analyzer.dart';
import '../services/ai/face_emotion_analyzer_stub.dart'
    if (dart.library.io) '../services/ai/face_emotion_analyzer.dart';

/// 快捷情绪识别按钮组件
class QuickEmotionButtons extends StatefulWidget {
  /// 文本控制器（用于文本分析）
  final TextEditingController? textController;

  /// AI 分析结果回调
  final void Function(AiEmotionResult result, String? mediaPath)? onResult;

  /// 开始录音/拍照时的回调
  final VoidCallback? onStart;

  /// 结束时的回调
  final VoidCallback? onEnd;
  final bool showTextButton;

  const QuickEmotionButtons({
    super.key,
    this.textController,
    this.onResult,
    this.onStart,
    this.onEnd,
    this.showTextButton = true,
  });

  @override
  State<QuickEmotionButtons> createState() => _QuickEmotionButtonsState();
}

class _QuickEmotionButtonsState extends State<QuickEmotionButtons> {
  final AiEmotionService _aiService = AiEmotionService();
  final ImagePicker _imagePicker = ImagePicker();
  final AudioRecorder _audioRecorder = AudioRecorder();

  bool _isRecording = false;
  bool _isAnalyzing = false;
  bool _textReady = false;
  bool _voiceReady = false;
  bool _faceReady = false;
  String? _currentAudioPath;
  DateTime? _recordingStartedAt;
  StreamSubscription<Amplitude>? _amplitudeSubscription;
  final List<double> _amplitudeSamples = [];

  // 分析器实例
  late final TextEmotionAnalyzer _textAnalyzer;
  late final VoiceEmotionAnalyzer _voiceAnalyzer;
  late final FaceEmotionAnalyzer _faceAnalyzer;

  @override
  void initState() {
    super.initState();
    _initAnalyzers();
  }

  Future<void> _initAnalyzers() async {
    _textAnalyzer = SimpleTextEmotionAnalyzer();
    _voiceAnalyzer = HeuristicVoiceEmotionAnalyzer();
    _faceAnalyzer = SimpleFaceEmotionAnalyzer();

    _aiService.registerTextAnalyzer(_textAnalyzer);
    _aiService.registerVoiceAnalyzer(_voiceAnalyzer);
    _aiService.registerFaceAnalyzer(_faceAnalyzer);

    await _aiService.initializeAll();

    if (!mounted) return;
    setState(() {
      _textReady = _textAnalyzer.isInitialized;
      _voiceReady = _voiceAnalyzer.isInitialized;
      _faceReady = _faceAnalyzer.isInitialized;
    });
  }

  @override
  void dispose() {
    _amplitudeSubscription?.cancel();
    _audioRecorder.dispose();
    _aiService.disposeAll();
    super.dispose();
  }

  /// 分析文本情绪
  Future<void> _analyzeText() async {
    if (!_textReady) {
      _showSnackBar('文字分析暂时不可用');
      return;
    }

    final text = widget.textController?.text.trim() ?? '';
    if (text.isEmpty) {
      _showSnackBar('请先输入一些文字');
      return;
    }

    setState(() => _isAnalyzing = true);
    widget.onStart?.call();

    try {
      final result = await _aiService.analyzeText(text);
      if (result != null && mounted) {
        widget.onResult?.call(result, null);
      } else if (mounted) {
        _showSnackBar('分析失败，请重试');
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('分析出错：$e');
      }
    } finally {
      if (mounted) {
        setState(() => _isAnalyzing = false);
        widget.onEnd?.call();
      }
    }
  }

  /// 开始/停止录音
  Future<void> _toggleRecording() async {
    if (!_voiceReady && !_isRecording) {
      _showSnackBar('语音情绪分析暂未开放');
      return;
    }

    if (_isRecording) {
      await _stopRecording();
    } else {
      await _startRecording();
    }
  }

  Future<void> _startRecording() async {
    if (OhosNativeService.isOhos) {
      try {
        final path = await OhosNativeService.startRecording();
        if (path != null) {
          _currentAudioPath = path;
          _recordingStartedAt = DateTime.now();
          _amplitudeSamples.clear();
          setState(() => _isRecording = true);
          widget.onStart?.call();
          _showSnackBar('正在录音，点击停止...');
        } else {
          _showSnackBar('录音失败，请授予麦克风权限');
        }
      } catch (e) {
        _showSnackBar('录音失败：$e');
      }
      return;
    }
    try {
      if (await _audioRecorder.hasPermission()) {
        final directory = await getApplicationDocumentsDirectory();
        final fileName =
            'ai_record_${DateTime.now().millisecondsSinceEpoch}.wav';
        _currentAudioPath = p.join(directory.path, fileName);

        await _audioRecorder.start(
          const RecordConfig(
            encoder: AudioEncoder.wav,
            sampleRate: 16000,
            numChannels: 1,
          ),
          path: _currentAudioPath!,
        );

        _recordingStartedAt = DateTime.now();
        _amplitudeSamples.clear();
        await _amplitudeSubscription?.cancel();
        _amplitudeSubscription = _audioRecorder
            .onAmplitudeChanged(const Duration(milliseconds: 160))
            .listen((amplitude) {
              _amplitudeSamples.add(amplitude.current);
              if (_amplitudeSamples.length > 600) {
                _amplitudeSamples.removeAt(0);
              }
            });

        setState(() => _isRecording = true);
        widget.onStart?.call();
        _showSnackBar('正在录音，点击停止...');
      } else {
        _showSnackBar('需要麦克风权限');
      }
    } catch (e) {
      _showSnackBar('录音失败：$e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      String? path;
      if (OhosNativeService.isOhos) {
        path = await OhosNativeService.stopRecording();
      } else {
        path = await _audioRecorder.stop();
        await _amplitudeSubscription?.cancel();
        _amplitudeSubscription = null;
      }
      setState(() {
        _isRecording = false;
        _isAnalyzing = true;
      });

      if (path != null && mounted) {
        final result = await _aiService.analyzeVoice(
          path,
          context: _buildVoiceAnalysisContext(),
        );
        if (result != null && mounted) {
          widget.onResult?.call(result, path);
        } else if (mounted) {
          _showSnackBar('语音情绪分析失败，请手动选择情绪');
          widget.onEnd?.call();
        }
      }
    } catch (e) {
      _showSnackBar('停止录音失败：$e');
    } finally {
      if (mounted) {
        setState(() => _isAnalyzing = false);
      }
      _recordingStartedAt = null;
      _amplitudeSamples.clear();
    }
  }

  Map<String, dynamic> _buildVoiceAnalysisContext() {
    final startedAt = _recordingStartedAt;
    final durationMs = startedAt == null
        ? 0
        : DateTime.now().difference(startedAt).inMilliseconds;
    return {
      'durationMs': durationMs,
      'amplitudeSamples': List<double>.from(_amplitudeSamples),
    };
  }

  /// 拍照并分析
  Future<void> _takePhotoAndAnalyze() async {
    if (!_faceReady) {
      _showSnackBar('拍照情绪识别暂未开放');
      return;
    }

    try {
      widget.onStart?.call();

      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 85,
      );

      if (image != null && mounted) {
        setState(() => _isAnalyzing = true);

        // 分析人脸情绪
        final result = await _aiService.analyzeFace(image.path);
        if (result != null && mounted) {
          widget.onResult?.call(result, image.path);
        } else if (mounted) {
          // 人脸分析暂未实现，提示用户
          _showSnackBar('人脸情绪分析功能开发中，请手动选择情绪');
          widget.onEnd?.call();
        }
      } else {
        widget.onEnd?.call();
      }
    } catch (e) {
      _showSnackBar('拍照失败：$e');
      widget.onEnd?.call();
    } finally {
      if (mounted) {
        setState(() => _isAnalyzing = false);
      }
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (widget.showTextButton)
            _buildButton(
              icon: Icons.text_fields,
              label: '分析文字',
              onTap: _isAnalyzing || !_textReady ? null : _analyzeText,
              isLoading: _isAnalyzing && !_isRecording,
              enabled:
                  _textReady &&
                  (widget.textController?.text.isNotEmpty ?? false),
            ),

          // 录音分析按钮
          _buildButton(
            icon: _isRecording ? Icons.stop : Icons.mic,
            label: _isRecording ? '停止录音' : (OhosNativeService.isOhos || _voiceReady ? '录音识别' : '录音开发中'),
            onTap: _isAnalyzing && !_isRecording
                ? null
                : (OhosNativeService.isOhos || _voiceReady || _isRecording ? _toggleRecording : null),
            isActive: _isRecording,
            isLoading: _isAnalyzing && _isRecording,
            enabled: OhosNativeService.isOhos || _voiceReady || _isRecording,
          ),

          // 拍照分析按钮
          _buildButton(
            icon: Icons.camera_alt,
            label: _faceReady ? '拍照识别' : '拍照开发中',
            onTap: _isAnalyzing || !_faceReady ? null : _takePhotoAndAnalyze,
            isLoading: _isAnalyzing && !_isRecording,
            enabled: _faceReady,
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
    bool isLoading = false,
    bool isActive = false,
    bool enabled = true,
  }) {
    final color = isActive
        ? Colors.red
        : (enabled ? AppTheme.primaryColor : AppTheme.textHint);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isActive
              ? color.withValues(alpha: 0.1)
              : AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive ? color : AppTheme.borderColor,
            width: isActive ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading)
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              )
            else
              Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: enabled ? AppTheme.textPrimary : AppTheme.textHint,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
