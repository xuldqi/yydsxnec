import 'package:hive_flutter/hive_flutter.dart';
import '../models/suggestion.dart';
import '../core/constants/app_constants.dart';

class SuggestionRepository {
  late Box<Suggestion> _box;
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    _box = await Hive.openBox<Suggestion>(AppConstants.suggestionBox);
    _isInitialized = true;
  }

  List<Suggestion> getAll() {
    if (!_isInitialized) return [];
    return _box.values.toList();
  }

  Future<void> save(Suggestion suggestion) async {
    if (!_isInitialized) return;
    await _box.put(suggestion.id, suggestion);
  }

  Future<void> saveAll(List<Suggestion> suggestions) async {
    if (!_isInitialized) return;
    for (final suggestion in suggestions) {
      await _box.put(suggestion.id, suggestion);
    }
  }

  Future<void> delete(String id) async {
    if (!_isInitialized) return;
    await _box.delete(id);
  }

  Future<void> clear() async {
    if (!_isInitialized) return;
    await _box.clear();
  }

  bool get isInitialized => _isInitialized;
}
