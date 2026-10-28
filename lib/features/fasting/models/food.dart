import 'dart:convert';

class FoodItem {
  final String id;
  final String name;
  final String categoryId;
  final Map<String, dynamic>? nutrition;

  const FoodItem({
    required this.id,
    required this.name,
    required this.categoryId,
    this.nutrition,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'] as String,
      name: json['name'] as String,
      categoryId: json['categoryId'] as String,
      nutrition: json['nutrition'] == null
          ? null
          : Map<String, dynamic>.from(json['nutrition'] as Map),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'categoryId': categoryId,
      'nutrition': nutrition,
    };
  }
}

class FoodCategory {
  final String id;
  final String name;
  final String? parentId;

  const FoodCategory({required this.id, required this.name, this.parentId});

  factory FoodCategory.fromJson(Map<String, dynamic> json) {
    return FoodCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      parentId: json['parentId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'parentId': parentId};
  }
}

class FoodDataset {
  final List<FoodCategory> categories;
  final List<FoodItem> foods;

  const FoodDataset({required this.categories, required this.foods});

  factory FoodDataset.empty() => const FoodDataset(categories: [], foods: []);

  factory FoodDataset.fromJson(Map<String, dynamic> json) {
    final categoriesJson = json['categories'] as List<dynamic>? ?? [];
    final foodsJson = json['foods'] as List<dynamic>? ?? [];

    return FoodDataset(
      categories: categoriesJson
          .map((e) => FoodCategory.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      foods: foodsJson
          .map((e) => FoodItem.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categories': categories.map((e) => e.toJson()).toList(),
      'foods': foods.map((e) => e.toJson()).toList(),
    };
  }

  String toPrettyJson() => const JsonEncoder.withIndent('  ').convert(toJson());
}
