class DrinkRecord {
  final int? id;
  final String name;
  final String category;
  final double volume; // 容量(ml)
  final String size; // 规格(大杯、中杯、小杯)
  final double sugar; // 糖分(g)
  final double fat; // 脂肪(g)
  final double protein; // 蛋白质(g)
  final double caffeine; // 咖啡因(mg)
  final double calories; // 热量(kcal)
  final String? imagePath; // 图片路径
  final DateTime recordTime; // 记录时间
  final String? notes; // 备注
  final String userId; // 用户ID
  final String? brand; // 品牌
  final double? price; // 价格

  DrinkRecord({
    this.id,
    required this.name,
    required this.category,
    required this.volume,
    required this.size,
    required this.sugar,
    required this.fat,
    required this.protein,
    required this.caffeine,
    required this.calories,
    this.imagePath,
    required this.recordTime,
    this.notes,
    required this.userId,
    this.brand,
    this.price,
  });

  // 从Map创建DrinkRecord对象
  factory DrinkRecord.fromMap(Map<String, dynamic> map) {
    final imagePath = map['imagePath'] ?? map['image_path'];
    final recordTimeRaw = map['recordTime'] ?? map['record_time'];
    final userId = map['userId'] ?? map['user_id'];

    return DrinkRecord(
      id: map['id']?.toInt(),
      name: map['name'] == '白开水' ? '水' : map['name'] ?? '',
      category: map['category'] ?? '',
      volume: map['volume']?.toDouble() ?? 0.0,
      size: map['size'] ?? '',
      sugar: map['sugar']?.toDouble() ?? 0.0,
      fat: map['fat']?.toDouble() ?? 0.0,
      protein: map['protein']?.toDouble() ?? 0.0,
      caffeine: map['caffeine']?.toDouble() ?? 0.0,
      calories: map['calories']?.toDouble() ?? 0.0,
      imagePath: imagePath,
      recordTime: DateTime.fromMillisecondsSinceEpoch(
        recordTimeRaw is int
            ? recordTimeRaw
            : DateTime.now().millisecondsSinceEpoch,
      ),
      notes: map['notes'],
      userId: userId ?? '',
      brand: map['brand'],
      price: map['price']?.toDouble(),
    );
  }

  // 转换为Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'volume': volume,
      'size': size,
      'sugar': sugar,
      'fat': fat,
      'protein': protein,
      'caffeine': caffeine,
      'calories': calories,
      'imagePath': imagePath,
      'recordTime': recordTime.millisecondsSinceEpoch,
      'notes': notes,
      'userId': userId,
      'brand': brand,
      'price': price,
    };
  }

  // 用于数据库存储（snake_case）
  Map<String, dynamic> toDbMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'volume': volume,
      'size': size,
      'sugar': sugar,
      'fat': fat,
      'protein': protein,
      'caffeine': caffeine,
      'calories': calories,
      'image_path': imagePath,
      'record_time': recordTime.millisecondsSinceEpoch,
      'notes': notes,
      'user_id': userId,
      'brand': brand,
      'price': price,
    };
  }

  // 转换为JSON
  Map<String, dynamic> toJson() => toMap();

  // 从JSON创建对象
  factory DrinkRecord.fromJson(Map<String, dynamic> json) =>
      DrinkRecord.fromMap(json);

  // 从数据库记录创建对象（snake_case）
  factory DrinkRecord.fromDbMap(Map<String, dynamic> map) =>
      DrinkRecord.fromMap(map);

  // 复制对象并修改部分属性
  DrinkRecord copyWith({
    int? id,
    String? name,
    String? category,
    double? volume,
    String? size,
    double? sugar,
    double? fat,
    double? protein,
    double? caffeine,
    double? calories,
    String? imagePath,
    bool clearImagePath = false,
    DateTime? recordTime,
    String? notes,
    String? userId,
    String? brand,
    double? price,
  }) {
    return DrinkRecord(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      volume: volume ?? this.volume,
      size: size ?? this.size,
      sugar: sugar ?? this.sugar,
      fat: fat ?? this.fat,
      protein: protein ?? this.protein,
      caffeine: caffeine ?? this.caffeine,
      calories: calories ?? this.calories,
      imagePath: clearImagePath ? null : imagePath ?? this.imagePath,
      recordTime: recordTime ?? this.recordTime,
      notes: notes ?? this.notes,
      userId: userId ?? this.userId,
      brand: brand ?? this.brand,
      price: price ?? this.price,
    );
  }

  @override
  String toString() {
    return 'DrinkRecord{id: $id, name: $name, category: $category, volume: $volume, recordTime: $recordTime, brand: $brand, price: $price}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DrinkRecord &&
        other.id == id &&
        other.name == name &&
        other.category == category &&
        other.volume == volume &&
        other.recordTime == recordTime &&
        other.userId == userId &&
        other.brand == brand &&
        other.price == price;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        category.hashCode ^
        volume.hashCode ^
        recordTime.hashCode ^
        userId.hashCode ^
        brand.hashCode ^
        price.hashCode;
  }
}

// 饮品类别枚举
enum DrinkCategory {
  milkTea('奶茶'),
  coffee('咖啡'),
  juice('果汁'),
  smoothie('奶昔'),
  tea('茶类'),
  soda('汽水'),
  water('水'),
  other('其他');

  const DrinkCategory(this.displayName);
  final String displayName;
}

// 饮品规格枚举
enum DrinkSize {
  small('小杯', 300),
  medium('中杯', 500),
  large('大杯', 700),
  extraLarge('超大杯', 900);

  const DrinkSize(this.displayName, this.volume);
  final String displayName;
  final int volume; // 默认容量(ml)
}
