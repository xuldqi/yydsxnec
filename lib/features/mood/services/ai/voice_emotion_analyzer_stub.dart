import '../../models/ai_emotion_result.dart';
import 'ai_emotion_service.dart';

class SimpleVoiceEmotionAnalyzer extends VoiceEmotionAnalyzer {
  @override
  String get name => 'SimpleVoiceEmotionAnalyzerStub';

  @override
  bool get isInitialized => false;

  @override
  Future<bool> initialize() async => false;

  @override
  Future<void> dispose() async {}

  @override
  Future<AiEmotionResult?> analyze(String audioPath) async => null;
}

class HeuristicVoiceEmotionAnalyzer extends SimpleVoiceEmotionAnalyzer {
  @override
  String get name => 'HeuristicVoiceEmotionAnalyzerStub';
}

class SenseVoiceVoiceEmotionAnalyzer extends HeuristicVoiceEmotionAnalyzer {
  @override
  String get name => 'SenseVoiceVoiceEmotionAnalyzerStub';
}

class PlaceholderVoiceEmotionAnalyzer extends SimpleVoiceEmotionAnalyzer {
  @override
  String get name => 'PlaceholderVoiceEmotionAnalyzerStub';
}

class MockVoiceEmotionAnalyzer extends HeuristicVoiceEmotionAnalyzer {
  @override
  String get name => 'MockVoiceEmotionAnalyzerStub';
}
