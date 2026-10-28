import 'dart:convert';
import '../models/emotion_record.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<File> _getRecordsFile() async {
  final dir = await getApplicationDocumentsDirectory();
  return File('${dir.path}/mood_records.json');
}

Future<void> writeEmotionRecords(List<Map<String, dynamic>> records) async {
  final file = await _getRecordsFile();
  await file.writeAsString(jsonEncode(records), flush: true);
}

Future<List<Map<String, dynamic>>> readEmotionRecords() async {
  try {
    final file = await _getRecordsFile();
    if (!await file.exists()) return [];
    final data = await file.readAsString();
    if (data.isEmpty) return [];
    final decoded = jsonDecode(data);
    if (decoded is! List) return [];
    final list = <Map<String, dynamic>>[];
    for (final e in decoded) {
      if (e is Map<String, dynamic>) {
        list.add(Map<String, dynamic>.from(e));
      } else if (e is Map) {
        list.add(Map<String, dynamic>.from(e));
      }
    }
    return list;
  } catch (e) {
    assert(() {
      // ignore: avoid_print
      print('readEmotionRecords error: $e');
      return true;
    }());
    return [];
  }
}
