import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/food.dart';

class FoodRepository {
  FoodDataset? _cache;

  Future<FoodDataset> loadDataset() async {
    if (_cache != null) return _cache!;
    try {
      final raw = await rootBundle.loadString('assets/data/foods.json');
      final map = jsonDecode(raw) as Map<String, dynamic>;
      _cache = FoodDataset.fromJson(map);
      return _cache!;
    } catch (_) {
      return FoodDataset.empty();
    }
  }

  Future<List<FoodItem>> searchFoods(
    String keyword, {
    String? categoryId,
  }) async {
    final data = await loadDataset();
    final lower = keyword.trim().toLowerCase();
    Iterable<FoodItem> result = data.foods.where(
      (f) => f.name.toLowerCase().contains(lower),
    );
    if (categoryId != null && categoryId.isNotEmpty) {
      result = result.where((f) => f.categoryId == categoryId);
    }
    return result.take(100).toList();
  }

  Future<List<FoodCategory>> getRootCategories() async {
    final data = await loadDataset();
    return data.categories.where((c) => c.parentId == null).toList();
  }

  Future<List<FoodCategory>> getChildren(String parentId) async {
    final data = await loadDataset();
    return data.categories.where((c) => c.parentId == parentId).toList();
  }
}
