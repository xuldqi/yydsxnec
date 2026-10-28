import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import '../../models/ai_emotion_result.dart';
import 'ai_emotion_service.dart';

/// 人脸情绪分析器 - 使用 TFLite MobileNetV2-FER 模型
class SimpleFaceEmotionAnalyzer extends FaceEmotionAnalyzer {
  @override
  String get name => 'TFLiteFaceEmotionAnalyzer';

  bool _isInitialized = false;
  Interpreter? _interpreter;

  /// FER 模型输出对应的情绪标签（FER2013 标准顺序）
  static const List<String> _emotionLabels = [
    'angry', // 生气
    'disgust', // 厌恶
    'fear', // 恐惧
    'happy', // 开心
    'sad', // 难过
    'surprise', // 惊讶
    'neutral', // 中性
  ];

  /// FER 输出到应用情绪的映射
  static const Map<String, String> _ferToMood = {
    'angry': '生气',
    'disgust': '生气',
    'fear': '焦虑',
    'happy': '开心',
    'sad': '难过',
    'surprise': '开心',
    'neutral': '开心',
  };

  @override
  bool get isInitialized => _isInitialized;

  @override
  Future<bool> initialize() async {
    if (!(Platform.isAndroid || Platform.isIOS)) {
      debugPrint('Face emotion analyzer is disabled on this platform');
      _isInitialized = false;
      return false;
    }

    try {
      // 加载 TFLite 模型
      _interpreter = await Interpreter.fromAsset(
        'assets/emoon/models/emotion_model.tflite',
      );

      // 打印模型信息
      final inputShape = _interpreter!.getInputTensor(0).shape;
      final outputShape = _interpreter!.getOutputTensor(0).shape;
      debugPrint(
        'Emotion model loaded. Input: $inputShape, Output: $outputShape',
      );

      _isInitialized = true;
      return true;
    } catch (e) {
      debugPrint('Failed to load emotion model: $e');
      _isInitialized = false;
      return false;
    }
  }

  @override
  Future<void> dispose() async {
    _interpreter?.close();
    _interpreter = null;
    _isInitialized = false;
  }

  @override
  Future<AiEmotionResult?> analyze(String imagePath) async {
    if (!_isInitialized || _interpreter == null) {
      debugPrint('Emotion analyzer not initialized');
      return null;
    }

    try {
      final file = File(imagePath);
      if (!await file.exists()) {
        debugPrint('Image file not found: $imagePath');
        return null;
      }

      // 读取并预处理图片
      final input = await _preprocessImage(imagePath);
      if (input == null) {
        debugPrint('Failed to preprocess image');
        return null;
      }

      // 运行推理
      final output = List.filled(7, 0.0).reshape([1, 7]);
      _interpreter!.run(input, output);

      // 解析结果
      return _parseOutput(output[0]);
    } catch (e) {
      debugPrint('Face emotion analysis error: $e');
      return null;
    }
  }

  /// 预处理图片：调整为 64x64，归一化
  Future<List<List<List<List<double>>>>?> _preprocessImage(
    String imagePath,
  ) async {
    try {
      final bytes = await File(imagePath).readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final image = frame.image;

      // 获取图片数据
      final byteData = await image.toByteData(
        format: ui.ImageByteFormat.rawRgba,
      );
      if (byteData == null) return null;

      final pixels = byteData.buffer.asUint8List();

      // 使用 image 包调整大小
      final imgImage = img.Image(width: image.width, height: image.height);
      for (int y = 0; y < image.height; y++) {
        for (int x = 0; x < image.width; x++) {
          final idx = (y * image.width + x) * 4;
          imgImage.setPixelRgba(
            x,
            y,
            pixels[idx], // R
            pixels[idx + 1], // G
            pixels[idx + 2], // B
            pixels[idx + 3], // A
          );
        }
      }

      // 调整大小为 64x64
      final resized = img.copyResize(imgImage, width: 64, height: 64);

      // 转换为模型输入格式 [1, 64, 64, 3]
      final input = List.generate(
        1,
        (_) => List.generate(
          64,
          (y) => List.generate(64, (x) {
            final pixel = resized.getPixel(x, y);
            return [
              (pixel.r as int) / 255.0,
              (pixel.g as int) / 255.0,
              (pixel.b as int) / 255.0,
            ];
          }),
        ),
      );

      image.dispose();
      codec.dispose();

      return input;
    } catch (e) {
      debugPrint('Image preprocessing error: $e');
      return null;
    }
  }

  /// 解析模型输出
  AiEmotionResult _parseOutput(List<double> probabilities) {
    // 找出最高概率的情绪
    int maxIndex = 0;
    double maxProb = 0;
    for (int i = 0; i < probabilities.length; i++) {
      if (probabilities[i] > maxProb) {
        maxProb = probabilities[i];
        maxIndex = i;
      }
    }

    final ferLabel = _emotionLabels[maxIndex];
    final mood = _ferToMood[ferLabel] ?? '开心';
    final confidence = maxProb.clamp(0.3, 0.95);

    // 构建所有概率的 map
    final allProbs = <String, double>{};
    for (int i = 0; i < _emotionLabels.length; i++) {
      allProbs[_emotionLabels[i]] = probabilities[i];
    }

    return AiEmotionResult(
      mood: mood,
      emoji: EmotionMapping.getEmoji(mood),
      confidence: confidence,
      source: source,
      rawLabel: ferLabel,
      extra: {'allProbabilities': allProbs},
    );
  }
}

/// 人脸情绪分析占位符
class PlaceholderFaceEmotionAnalyzer extends FaceEmotionAnalyzer {
  @override
  String get name => 'PlaceholderFaceEmotionAnalyzer';

  @override
  bool get isInitialized => false;

  @override
  Future<bool> initialize() async => false;

  @override
  Future<void> dispose() async {}

  @override
  Future<AiEmotionResult?> analyze(String imagePath) async => null;
}
