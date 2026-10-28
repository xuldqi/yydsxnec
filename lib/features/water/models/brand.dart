class ProductPreset {
  final String name;
  final double calories;
  final double volume;
  final double caffeine;
  final String? description;

  const ProductPreset({
    required this.name,
    required this.calories,
    required this.volume,
    required this.caffeine,
    this.description,
  });

  factory ProductPreset.fromMap(Map<String, dynamic> map) {
    return ProductPreset(
      name: map['name'] ?? '',
      calories: map['calories']?.toDouble() ?? 0.0,
      volume: map['volume']?.toDouble() ?? 0.0,
      caffeine: map['caffeine']?.toDouble() ?? 0.0,
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'calories': calories,
      'volume': volume,
      'caffeine': caffeine,
      'description': description,
    };
  }
}

class BrandPreset {
  final String id;
  final String name;
  final String logo; // Can be an emoji or base64/local image path
  final List<ProductPreset> products;
  final bool isCustom;

  const BrandPreset({
    required this.id,
    required this.name,
    required this.logo,
    required this.products,
    this.isCustom = false,
  });

  factory BrandPreset.fromMap(
    Map<String, dynamic> map, {
    bool isCustom = false,
  }) {
    var rawProducts = map['products'] as List<dynamic>? ?? [];
    List<ProductPreset> products = rawProducts
        .map((p) => ProductPreset.fromMap(Map<String, dynamic>.from(p)))
        .toList();

    return BrandPreset(
      id: map['id']?.toString() ?? '',
      name: map['name'] ?? '',
      logo: map['logo'] ?? '🥤',
      products: products,
      isCustom: isCustom,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
      'products': products.map((p) => p.toMap()).toList(),
      'isCustom': isCustom,
    };
  }
}
