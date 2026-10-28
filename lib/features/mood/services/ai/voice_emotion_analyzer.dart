import 'dart:math' as math;
import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import '../../models/ai_emotion_result.dart';
import 'ai_emotion_service.dart';

/// 语音情绪分析器。
/// 当前版本只做本地轻量情绪打分，不再依赖大体积语音模型。
class SimpleVoiceEmotionAnalyzer extends HeuristicVoiceEmotionAnalyzer {
  @override
  String get name => 'SimpleVoiceEmotionAnalyzer';
}

/// 语音情绪分析占位符
/// 用于在 UI 中显示「功能开发中」提示
class PlaceholderVoiceEmotionAnalyzer extends VoiceEmotionAnalyzer {
  @override
  String get name => 'PlaceholderVoiceEmotionAnalyzer';

  @override
  bool get isInitialized => false;

  @override
  Future<bool> initialize() async => false;

  @override
  Future<void> dispose() async {}

  @override
  Future<AiEmotionResult?> analyze(String audioPath) async => null;
}

/// 兼容旧命名，保留原调用点。
/// 现在内部直接使用本地启发式分析，不再尝试加载 SenseVoice/ONNX。
class SenseVoiceVoiceEmotionAnalyzer extends HeuristicVoiceEmotionAnalyzer {
  @override
  String get name => 'SenseVoiceVoiceEmotionAnalyzer';

  bool get isUsingSenseVoice => false;
}

/// 基于录音振幅特征的本地启发式语音情绪分析。
/// 说明：当前仓库内没有语音情绪模型文件，因此这里先用本地特征分析替代随机结果。
class HeuristicVoiceEmotionAnalyzer extends VoiceEmotionAnalyzer {
  @override
  String get name => 'HeuristicVoiceEmotionAnalyzer';

  bool _isInitialized = false;

  @override
  bool get isInitialized => _isInitialized;

  @override
  Future<bool> initialize() async {
    _isInitialized = true;
    return true;
  }

  @override
  Future<void> dispose() async {
    _isInitialized = false;
  }

  @override
  Future<AiEmotionResult?> analyze(String audioPath) async {
    return analyzeWithContext(audioPath);
  }

  @override
  Future<AiEmotionResult?> analyzeWithContext(
    String audioPath, {
    Map<String, dynamic>? context,
  }) async {
    if (!_isInitialized) return null;

    try {
      final file = io.File(audioPath);
      if (!await file.exists()) return null;

      final fileSize = await file.length();
      var samples = _parseAmplitudeSamples(context?['amplitudeSamples']);
      var durationMs = _toDouble(context?['durationMs']);
      var featureSource = 'recorder_amplitude';

      if (samples.length < 8) {
        final wavData = await _extractWavEnvelope(file);
        if (wavData != null) {
          samples = wavData.samples;
          if (durationMs <= 0) {
            durationMs = wavData.durationMs;
          }
          featureSource = 'wav_envelope';
        } else {
          featureSource = 'file_size_fallback';
        }
      }

      final features = _extractFeatures(
        samples: samples,
        durationMs: durationMs,
        fileSize: fileSize,
      );
      final scores = _scoreMoods(features);
      final mood = _pickMood(scores);
      final confidence = _confidenceForMood(mood, features);

      return AiEmotionResult(
        mood: mood,
        emoji: EmotionMapping.getEmoji(mood),
        confidence: confidence,
        source: source,
        rawLabel: 'heuristic_voice_$mood',
        extra: {
          'note': '基于录音响度、波动和节奏特征的本地启发式分析',
          'featureSource': featureSource,
          'scores': scores,
          ...features,
        },
      );
    } catch (e) {
      debugPrint('Heuristic voice emotion analysis error: $e');
      return null;
    }
  }

  List<double> _parseAmplitudeSamples(dynamic raw) {
    if (raw is! List) return const [];
    return raw
        .map((value) => _normalizeDbfs(_toDouble(value)))
        .where((value) => value.isFinite)
        .toList();
  }

  double _normalizeDbfs(double value) {
    if (!value.isFinite) return 0;
    if (value >= 0) return (value / 60).clamp(0.0, 1.0);
    final clamped = value.clamp(-60.0, 0.0).toDouble();
    return ((clamped + 60.0) / 60.0).clamp(0.0, 1.0);
  }

  double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  Future<_WavEnvelopeData?> _extractWavEnvelope(io.File file) async {
    try {
      final bytes = await file.readAsBytes();
      if (bytes.length < 44) return null;

      final dataOffset = _findDataChunkOffset(bytes);
      if (dataOffset == null) return null;

      final samples = <double>[];
      final sampleWindow = 320;
      var windowPeak = 0.0;
      var windowCount = 0;

      for (var i = dataOffset; i + 1 < bytes.length; i += 2) {
        final lo = bytes[i];
        final hi = bytes[i + 1];
        var sample = (hi << 8) | lo;
        if (sample & 0x8000 != 0) {
          sample -= 0x10000;
        }

        final normalized = sample.abs() / 32768.0;
        if (normalized > windowPeak) {
          windowPeak = normalized;
        }

        windowCount++;
        if (windowCount >= sampleWindow) {
          samples.add(windowPeak.clamp(0.0, 1.0));
          windowPeak = 0.0;
          windowCount = 0;
        }
      }

      if (windowCount > 0) {
        samples.add(windowPeak.clamp(0.0, 1.0));
      }

      final pcmBytes = bytes.length - dataOffset;
      final durationMs = pcmBytes / 2 / 16000 * 1000;
      return _WavEnvelopeData(samples: samples, durationMs: durationMs);
    } catch (_) {
      return null;
    }
  }

  int? _findDataChunkOffset(List<int> bytes) {
    for (var i = 12; i + 8 < bytes.length;) {
      final chunkId = String.fromCharCodes(bytes.sublist(i, i + 4));
      final chunkSize =
          bytes[i + 4] |
          (bytes[i + 5] << 8) |
          (bytes[i + 6] << 16) |
          (bytes[i + 7] << 24);
      final next = i + 8 + chunkSize;
      if (chunkId == 'data') {
        return i + 8;
      }
      if (next <= i) {
        return null;
      }
      i = next;
    }
    return null;
  }

  Map<String, double> _extractFeatures({
    required List<double> samples,
    required double durationMs,
    required int fileSize,
  }) {
    if (samples.isEmpty) {
      final fallbackActivity = (fileSize / 64000).clamp(0.0, 1.0);
      return {
        'durationMs': durationMs,
        'sampleCount': 0,
        'mean': fallbackActivity * 0.3,
        'peak': fallbackActivity * 0.45,
        'min': 0,
        'variance': 0,
        'volatility': 0,
        'speechRatio': fallbackActivity,
        'trend': 0,
        'dynamicRange': fallbackActivity * 0.45,
        'burstiness': fallbackActivity * 0.2,
        'activity': fallbackActivity,
      };
    }

    final mean = samples.reduce((a, b) => a + b) / samples.length;
    final peak = samples.reduce(math.max);
    final minValue = samples.reduce(math.min);
    final variance =
        samples
            .map((sample) => math.pow(sample - mean, 2).toDouble())
            .reduce((a, b) => a + b) /
        samples.length;
    final volatility = math.sqrt(variance);
    final speechRatio =
        samples.where((sample) => sample > 0.18).length / samples.length;

    final third = math.max(1, samples.length ~/ 3);
    final firstSlice = samples.take(third).toList();
    final lastSlice = samples.skip(samples.length - third).toList();
    final firstMean =
        firstSlice.reduce((a, b) => a + b) / math.max(1, firstSlice.length);
    final lastMean =
        lastSlice.reduce((a, b) => a + b) / math.max(1, lastSlice.length);
    final dynamicRange = (peak - minValue).clamp(0.0, 1.0);
    var burstCount = 0;
    for (var i = 1; i < samples.length; i++) {
      final delta = (samples[i] - samples[i - 1]).abs();
      if (delta > 0.22) {
        burstCount++;
      }
    }
    final burstiness = samples.length > 1
        ? burstCount / (samples.length - 1)
        : 0.0;
    final activity = (mean * 0.55 + speechRatio * 0.45).clamp(0.0, 1.0);

    return {
      'durationMs': durationMs,
      'sampleCount': samples.length.toDouble(),
      'mean': mean,
      'peak': peak,
      'min': minValue,
      'variance': variance,
      'volatility': volatility,
      'speechRatio': speechRatio,
      'trend': lastMean - firstMean,
      'dynamicRange': dynamicRange,
      'burstiness': burstiness,
      'activity': activity,
    };
  }

  Map<String, double> _scoreMoods(Map<String, double> features) {
    final mean = features['mean'] ?? 0;
    final peak = features['peak'] ?? 0;
    final volatility = features['volatility'] ?? 0;
    final speechRatio = features['speechRatio'] ?? 0;
    final trend = features['trend'] ?? 0;
    final durationMs = features['durationMs'] ?? 0;
    final dynamicRange = features['dynamicRange'] ?? 0;
    final burstiness = features['burstiness'] ?? 0;
    final activity = features['activity'] ?? 0;
    final durationFactor = (durationMs / 5000).clamp(0.0, 1.0);

    return {
      '生气':
          (0.28 +
                  peak * 0.28 +
                  volatility * 0.24 +
                  dynamicRange * 0.16 +
                  burstiness * 0.12 +
                  math.max(0.0, trend) * 0.08)
              .clamp(0.0, 1.0),
      '焦虑':
          (0.26 +
                  speechRatio * 0.2 +
                  volatility * 0.22 +
                  burstiness * 0.18 +
                  activity * 0.12 +
                  durationFactor * 0.08 +
                  math.max(0.0, -trend) * 0.1)
              .clamp(0.0, 1.0),
      '幸福':
          (0.24 +
                  mean * 0.24 +
                  speechRatio * 0.14 +
                  (1 - volatility) * 0.18 +
                  (1 - burstiness) * 0.1 +
                  math.max(0.0, trend) * 0.12 +
                  durationFactor * 0.08)
              .clamp(0.0, 1.0),
      '开心':
          (0.24 +
                  activity * 0.24 +
                  peak * 0.16 +
                  dynamicRange * 0.14 +
                  volatility * 0.08 +
                  math.max(0.0, trend) * 0.08)
              .clamp(0.0, 1.0),
      '难过':
          (0.26 +
                  (1 - activity) * 0.2 +
                  (1 - speechRatio) * 0.16 +
                  math.max(0.0, -trend) * 0.18 +
                  durationFactor * 0.1 +
                  (1 - peak) * 0.08)
              .clamp(0.0, 1.0),
      '疲惫':
          (0.28 +
                  (1 - mean) * 0.18 +
                  (1 - volatility) * 0.16 +
                  (1 - speechRatio) * 0.14 +
                  (1 - dynamicRange) * 0.12 +
                  (1 - burstiness) * 0.1 +
                  (1 - durationFactor) * 0.08)
              .clamp(0.0, 1.0),
    };
  }

  String _pickMood(Map<String, double> scores) {
    return scores.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  double _confidenceForMood(String mood, Map<String, double> features) {
    final scores = _scoreMoods(features).values.toList()..sort();
    final best = scores.isEmpty ? 0.0 : scores.last;
    final secondBest = scores.length > 1 ? scores[scores.length - 2] : 0.0;
    final separation = (best - secondBest).clamp(0.0, 0.35);
    final sampleCount = features['sampleCount'] ?? 0;
    final dataQuality = (sampleCount / 24).clamp(0.0, 1.0);
    final activity = features['activity'] ?? 0;
    final volatility = features['volatility'] ?? 0;

    final score =
        0.36 +
        separation * 0.9 +
        dataQuality * 0.16 +
        activity * 0.08 +
        volatility * 0.05;
    return score.clamp(0.4, 0.84);
  }
}

class _WavEnvelopeData {
  const _WavEnvelopeData({required this.samples, required this.durationMs});

  final List<double> samples;
  final double durationMs;
}

/// 兼容旧命名，保留原调用点。
class MockVoiceEmotionAnalyzer extends HeuristicVoiceEmotionAnalyzer {
  @override
  String get name => 'MockVoiceEmotionAnalyzer';
}
