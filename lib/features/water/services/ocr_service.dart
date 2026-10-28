import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../models/nutrition.dart';

// OCR识别结果
class OCRResult {
  final bool success;
  final String? drinkName;
  final String? category;
  final double? volume;
  final String? size;
  final Nutrition? nutrition;
  final double confidence; // 识别置信度 (0-1)
  final String? errorMessage;
  final List<String> detectedTexts; // 检测到的所有文本

  OCRResult({
    required this.success,
    this.drinkName,
    this.category,
    this.volume,
    this.size,
    this.nutrition,
    this.confidence = 0.0,
    this.errorMessage,
    this.detectedTexts = const [],
  });

  factory OCRResult.success({
    String? drinkName,
    String? category,
    double? volume,
    String? size,
    Nutrition? nutrition,
    double confidence = 0.0,
    List<String> detectedTexts = const [],
  }) {
    return OCRResult(
      success: true,
      drinkName: drinkName,
      category: category,
      volume: volume,
      size: size,
      nutrition: nutrition,
      confidence: confidence,
      detectedTexts: detectedTexts,
    );
  }

  factory OCRResult.failure(String errorMessage) {
    return OCRResult(success: false, errorMessage: errorMessage);
  }

  Map<String, dynamic> toMap() {
    return {
      'success': success,
      'drinkName': drinkName,
      'category': category,
      'volume': volume,
      'size': size,
      'nutrition': nutrition?.toMap(),
      'confidence': confidence,
      'errorMessage': errorMessage,
      'detectedTexts': detectedTexts,
    };
  }
}

// OCR服务配置
class OCRConfig {
  final String apiKey;
  final String baseUrl;
  final int timeout; // 超时时间(秒)
  final String language; // 识别语言
  final bool enableNutritionExtraction; // 是否启用营养成分提取

  OCRConfig({
    required this.apiKey,
    required this.baseUrl,
    this.timeout = 30,
    this.language = 'zh-cn',
    this.enableNutritionExtraction = true,
  });
}

class OCRService {
  static final OCRService _instance = OCRService._internal();
  static const MethodChannel _ohosOcrChannel = MethodChannel(
    'xiaolu_water/ohos_ocr',
  );

  factory OCRService() => _instance;
  OCRService._internal();

  OCRConfig? _config;
  bool _isInitialized = false;
  TextRecognizer? _textRecognizer;

  // 初始化OCR服务
  Future<void> initialize(OCRConfig config) async {
    _config = config;
    if (_supportsOnDeviceOcr()) {
      _textRecognizer ??= TextRecognizer(script: TextRecognitionScript.chinese);
    }
    _isInitialized = true;
  }

  // 检查是否已初始化
  bool get isInitialized => _isInitialized;

  bool _supportsOnDeviceOcr() {
    if (kIsWeb) return false;
    try {
      return Platform.isAndroid || Platform.isIOS;
    } catch (_) {
      return false;
    }
  }

  bool _supportsOhosOcr() {
    if (kIsWeb) return false;
    try {
      return Platform.operatingSystem == 'ohos' ||
          Platform.operatingSystem == 'harmonyos';
    } catch (_) {
      return false;
    }
  }

  // 从图片文件识别饮品信息
  Future<OCRResult> recognizeFromFile(File imageFile) async {
    if (!_isInitialized || _config == null) {
      return OCRResult.failure('OCR服务未初始化');
    }

    try {
      if (!await imageFile.exists()) {
        return OCRResult.failure('图片文件不存在');
      }

      if (!isValidImageFormat(imageFile.path)) {
        return OCRResult.failure('不支持的图片格式');
      }

      if (_supportsOhosOcr()) {
        return _recognizeFromOhos(imageFile.path);
      }

      if (!_supportsOnDeviceOcr()) {
        return OCRResult.failure('当前平台不支持本地OCR，请在手机端使用');
      }

      _textRecognizer ??= TextRecognizer(script: TextRecognitionScript.chinese);
      final inputImage = InputImage.fromFilePath(imageFile.path);
      final recognizedText = await _textRecognizer!.processImage(inputImage);

      return _parseRecognizedText(recognizedText);
    } catch (e) {
      return OCRResult.failure('OCR识别失败: $e');
    }
  }

  Future<OCRResult> _recognizeFromOhos(String imagePath) async {
    try {
      final text = await _ohosOcrChannel.invokeMethod<String>('recognizeText', {
        'path': imagePath,
      });
      if (text == null || text.trim().isEmpty) {
        return OCRResult.failure('未识别到文本，请确保图片清晰且包含文字');
      }
      return _parsePlainText(text);
    } on MissingPluginException {
      return OCRResult.failure('鸿蒙OCR底层未接入');
    } catch (e) {
      return OCRResult.failure('鸿蒙OCR识别失败: $e');
    }
  }

  // 从图片字节数据识别饮品信息
  Future<OCRResult> recognizeFromBytes(Uint8List imageBytes) async {
    if (!_isInitialized || _config == null) {
      return OCRResult.failure('OCR服务未初始化');
    }

    File? tempFile;
    try {
      final tempPath =
          '${Directory.systemTemp.path}/xiaolu_water_ocr_${DateTime.now().microsecondsSinceEpoch}.jpg';
      tempFile = File(tempPath);
      await tempFile.writeAsBytes(imageBytes, flush: true);
      return recognizeFromFile(tempFile);
    } catch (e) {
      return OCRResult.failure('OCR识别失败: $e');
    } finally {
      if (tempFile != null && await tempFile.exists()) {
        await tempFile.delete();
      }
    }
  }

  OCRResult _parseRecognizedText(RecognizedText recognizedText) {
    final detectedLines = recognizedText.blocks
        .expand((block) => block.lines.map((line) => line.text.trim()))
        .where((line) => line.isNotEmpty)
        .toList();

    return _parseDetectedLines(detectedLines);
  }

  OCRResult _parsePlainText(String text) {
    final detectedLines = text
        .split(RegExp(r'[\r\n]+'))
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    return _parseDetectedLines(detectedLines);
  }

  OCRResult _parseDetectedLines(List<String> detectedLines) {
    if (detectedLines.isEmpty) {
      return OCRResult.failure('未识别到文本，请确保图片清晰且包含文字');
    }

    final fullText = detectedLines.join('\n');
    final drinkName = _extractDrinkName(detectedLines) ?? detectedLines.first;
    final category = matchDrinkCategory(drinkName);
    final volume = _extractVolume(fullText);
    final size = _extractSize(fullText) ?? estimateDrinkSize(volume);
    final nutrition = _config!.enableNutritionExtraction
        ? _extractNutritionFromTextSync(fullText)
        : null;

    final confidence = _estimateConfidence(
      drinkName: drinkName,
      volume: volume,
      nutrition: nutrition,
      detectedTextCount: detectedLines.length,
    );

    return OCRResult.success(
      drinkName: drinkName,
      category: category,
      volume: volume,
      size: size,
      nutrition: nutrition,
      confidence: confidence,
      detectedTexts: detectedLines,
    );
  }

  String? _extractDrinkName(List<String> lines) {
    const keywords = [
      '奶茶',
      '咖啡',
      '果茶',
      '果汁',
      '茶',
      '可乐',
      '汽水',
      '拿铁',
      '美式',
      '乌龙',
      '柠檬',
      '珍珠',
      '燕麦奶',
      '白开水',
      '矿泉水',
    ];

    for (final line in lines) {
      if (line.length > 1 &&
          line.length <= 24 &&
          keywords.any((word) => line.contains(word))) {
        return line;
      }
    }
    return null;
  }

  String? _extractSize(String text) {
    final match = RegExp(
      r'(超大杯|大杯|中杯|小杯|large|medium|small)',
      caseSensitive: false,
    ).firstMatch(text);
    if (match == null) return null;
    final raw = match.group(1)!.toLowerCase();
    if (raw.contains('small') || raw == '小杯') return '小杯';
    if (raw.contains('medium') || raw == '中杯') return '中杯';
    if (raw.contains('large') || raw == '大杯') return '大杯';
    return '超大杯';
  }

  double? _extractVolume(String text) {
    final match = RegExp(
      r'(\d{1,4}(?:\.\d+)?)\s*(ml|mL|ML|毫升|l|L|升)',
    ).firstMatch(text);
    if (match == null) return null;

    final value = double.tryParse(match.group(1)!);
    if (value == null) return null;

    final unit = match.group(2)!.toLowerCase();
    if (unit == 'l' || unit == '升') {
      return value * 1000;
    }
    return value;
  }

  Nutrition? _extractNutritionFromTextSync(String text) {
    double? extract(String pattern) {
      final match = RegExp(pattern, caseSensitive: false).firstMatch(text);
      if (match == null || match.group(1) == null) return null;
      return double.tryParse(match.group(1)!);
    }

    final sugar = extract(r'糖(?:分)?[：: ]?\s*(\d+(?:\.\d+)?)\s*(?:g|克)');
    final fat = extract(r'脂肪[：: ]?\s*(\d+(?:\.\d+)?)\s*(?:g|克)');
    final protein = extract(r'蛋白质[：: ]?\s*(\d+(?:\.\d+)?)\s*(?:g|克)');
    final caffeine = extract(r'咖啡因[：: ]?\s*(\d+(?:\.\d+)?)\s*(?:mg|毫克)');
    final calories = extract(r'热量[：: ]?\s*(\d+(?:\.\d+)?)\s*(?:kcal|卡|千卡)?');

    if (sugar == null &&
        fat == null &&
        protein == null &&
        caffeine == null &&
        calories == null) {
      return null;
    }

    return Nutrition(
      sugar: sugar ?? 0,
      fat: fat ?? 0,
      protein: protein ?? 0,
      caffeine: caffeine ?? 0,
      calories: calories ?? 0,
    );
  }

  double _estimateConfidence({
    required String drinkName,
    required double? volume,
    required Nutrition? nutrition,
    required int detectedTextCount,
  }) {
    var score = 0.35;
    if (drinkName.trim().isNotEmpty) score += 0.3;
    if (volume != null && volume > 0) score += 0.15;
    if (nutrition != null) score += 0.15;
    if (detectedTextCount >= 3) score += 0.05;
    return score.clamp(0.0, 0.98);
  }

  // 从文本中提取营养信息（对外接口，兼容旧调用）
  Future<Nutrition?> extractNutritionFromText(String text) async {
    try {
      return _extractNutritionFromTextSync(text);
    } catch (_) {
      return null;
    }
  }

  // 智能匹配饮品类别（与页面分类保持一致）
  String matchDrinkCategory(String drinkName) {
    final name = drinkName.toLowerCase();

    if (name.contains('奶茶') || name.contains('珍珠') || name.contains('布丁')) {
      return '奶茶';
    }
    if (name.contains('咖啡') ||
        name.contains('拿铁') ||
        name.contains('卡布奇诺') ||
        name.contains('美式')) {
      return '咖啡';
    }
    if (name.contains('果茶') ||
        name.contains('果汁') ||
        name.contains('柠檬') ||
        name.contains('葡萄') ||
        name.contains('橙')) {
      return '果茶';
    }
    if (name.contains('可乐') ||
        name.contains('雪碧') ||
        name.contains('芬达') ||
        name.contains('汽水') ||
        name.contains('瓶装')) {
      return '瓶装饮品';
    }
    if (name.contains('水') || name.contains('矿泉水') || name.contains('纯净水')) {
      return '白开水';
    }

    return '其他';
  }

  // 估算饮品规格
  String? estimateDrinkSize(double? volume) {
    if (volume == null) return null;

    if (volume <= 350) {
      return '小杯';
    } else if (volume <= 500) {
      return '中杯';
    } else if (volume <= 700) {
      return '大杯';
    } else {
      return '超大杯';
    }
  }

  // 批量识别图片
  Future<List<OCRResult>> recognizeMultipleImages(List<File> imageFiles) async {
    final results = <OCRResult>[];

    for (final file in imageFiles) {
      final result = await recognizeFromFile(file);
      results.add(result);
      await Future.delayed(const Duration(milliseconds: 150));
    }

    return results;
  }

  // 获取支持的图片格式
  List<String> getSupportedImageFormats() {
    return ['jpg', 'jpeg', 'png', 'bmp', 'webp'];
  }

  // 验证图片格式
  bool isValidImageFormat(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    return getSupportedImageFormats().contains(extension);
  }

  // 获取服务状态
  Map<String, dynamic> getServiceStatus() {
    return {
      'initialized': _isInitialized,
      'hasConfig': _config != null,
      'supportsOnDeviceOCR': _supportsOnDeviceOcr(),
      'supportedFormats': getSupportedImageFormats(),
      'configInfo': _config != null
          ? {
              'baseUrl': _config!.baseUrl,
              'language': _config!.language,
              'timeout': _config!.timeout,
              'nutritionExtraction': _config!.enableNutritionExtraction,
            }
          : null,
    };
  }

  // 重置服务
  void reset() {
    _textRecognizer?.close();
    _textRecognizer = null;
    _config = null;
    _isInitialized = false;
  }
}
