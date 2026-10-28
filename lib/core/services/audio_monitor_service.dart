import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class SnoreSnippet {
  final String path;
  final DateTime time;
  final String type;
  final int durationSeconds;

  SnoreSnippet({
    required this.path,
    required this.time,
    required this.type,
    required this.durationSeconds,
  });
}

abstract class SnoreSnippetSource {
  List<SnoreSnippet> get snippets;
}

class AudioMonitorService extends ChangeNotifier implements SnoreSnippetSource {
  final AudioRecorder _audioRecorder = AudioRecorder();
  StreamSubscription<Uint8List>? _audioStreamSub;

  bool _isRunning = false;
  bool get isRunning => _isRunning;

  int _currentDb = 0;
  int get currentDb => _currentDb;

  bool _isSnoring = false;
  bool get isSnoring => _isSnoring;

  bool _isRecordingSnippet = false;
  int _snippetCount = 0;
  final int _maxSnippets = 5;

  final List<SnoreSnippet> _snippets = [];
  @override
  List<SnoreSnippet> get snippets => _snippets;

  final List<int> _snoreBuffer = [];
  static const int _snoreBufferSize = 10; // 10 points * 0.5s = 5 seconds

  // Used for chunking the stream
  final List<int> _pcmBuffer = [];
  DateTime _lastCalcTime = DateTime.now();

  Future<void> start() async {
    if (_isRunning) return;

    if (!await _audioRecorder.hasPermission()) {
      debugPrint("Microphone permission not granted");
      return;
    }

    _isRunning = true;
    _snippets.clear();
    _snippetCount = 0;
    _snoreBuffer.clear();
    notifyListeners();

    await _startListeningStream();
  }

  Future<void> _startListeningStream() async {
    if (!_isRunning) return;
    try {
      final stream = await _audioRecorder.startStream(
        const RecordConfig(
          encoder: AudioEncoder.pcm16bits,
          sampleRate: 8000,
          numChannels: 1,
        ),
      );

      _audioStreamSub = stream.listen((data) {
        _pcmBuffer.addAll(data);

        final now = DateTime.now();
        if (now.difference(_lastCalcTime).inMilliseconds >= 500) {
          _calculateDb();
          _lastCalcTime = now;
        }
      });
    } catch (e) {
      debugPrint("Error starting audio stream: $e");
    }
  }

  void _calculateDb() {
    if (_pcmBuffer.isEmpty) return;

    // Ensure even number of bytes for 16-bit PCM
    if (_pcmBuffer.length % 2 != 0) {
      _pcmBuffer.removeLast();
    }
    final bytes = Uint8List.fromList(_pcmBuffer);
    final data16 = bytes.buffer.asInt16List();

    double sum = 0.0;
    for (int i = 0; i < data16.length; i++) {
      sum += data16[i] * data16[i];
    }

    final rms = sqrt(sum / data16.length);
    _pcmBuffer.clear(); // reset buffer

    if (rms > 0) {
      final db = 20 * (log(rms) / ln10);
      _currentDb = (db + 20).toInt().clamp(0, 100);
      _updateSnoreDetection(_currentDb);
    } else {
      _currentDb = 0;
      _isSnoring = false;
    }
    notifyListeners();
  }

  Future<void> _updateSnoreDetection(int db) async {
    _snoreBuffer.add(db);
    if (_snoreBuffer.length > _snoreBufferSize) {
      _snoreBuffer.removeAt(0);
    }

    if (_snoreBuffer.length >= _snoreBufferSize) {
      final avg = _snoreBuffer.reduce((a, b) => a + b) / _snoreBuffer.length;
      final maxDb = _snoreBuffer.reduce(max);
      final minDb = _snoreBuffer.reduce(min);

      _isSnoring = avg > 40 && (maxDb - minDb) > 15;

      if (_isSnoring && !_isRecordingSnippet && _snippetCount < _maxSnippets) {
        await _captureSnippet();
      }
    }
  }

  Future<void> _captureSnippet() async {
    _isRecordingSnippet = true;
    notifyListeners();

    try {
      // Pause streaming to record to a file
      await _audioStreamSub?.cancel();
      await _audioRecorder.stop();

      final dir = await getApplicationDocumentsDirectory();
      final filePath =
          '${dir.path}/snore_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await _audioRecorder.start(
        const RecordConfig(encoder: AudioEncoder.aacLc),
        path: filePath,
      );

      // Record for 5 seconds
      await Future.delayed(const Duration(seconds: 5));

      await _audioRecorder.stop();

      _snippets.add(
        SnoreSnippet(
          path: filePath,
          time: DateTime.now(),
          type: '环境音/鼾声', // Honest classification without deep learning
          durationSeconds: 5,
        ),
      );
      _snippetCount++;
    } catch (e) {
      debugPrint("Failed to capture snippet: $e");
    } finally {
      _isRecordingSnippet = false;
      // Resume streaming
      if (_isRunning) {
        await _startListeningStream();
      }
      notifyListeners();
    }
  }

  Future<void> stop() async {
    _isRunning = false;
    await _audioStreamSub?.cancel();
    await _audioRecorder.stop();
    _currentDb = 0;
    _isSnoring = false;
    notifyListeners();
  }

  @override
  void dispose() {
    stop();
    _audioRecorder.dispose();
    super.dispose();
  }
}
