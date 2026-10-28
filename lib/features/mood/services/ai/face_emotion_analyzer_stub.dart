import '../../models/ai_emotion_result.dart';
import 'ai_emotion_service.dart';

class SimpleFaceEmotionAnalyzer extends FaceEmotionAnalyzer {
  @override
  String get name => 'SimpleFaceEmotionAnalyzerStub';

  @override
  bool get isInitialized => false;

  @override
  Future<bool> initialize() async => false;

  @override
  Future<void> dispose() async {}

  @override
  Future<AiEmotionResult?> analyze(String imagePath) async => null;
}

class PlaceholderFaceEmotionAnalyzer extends SimpleFaceEmotionAnalyzer {
  @override
  String get name => 'PlaceholderFaceEmotionAnalyzerStub';
}
