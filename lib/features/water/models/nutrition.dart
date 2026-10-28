// 营养信息模型
class Nutrition {
  final double sugar; // 糖分(g)
  final double fat; // 脂肪(g)
  final double protein; // 蛋白质(g)
  final double caffeine; // 咖啡因(mg)
  final double calories; // 热量(kcal)
  final double carbohydrates; // 碳水化合物(g)
  final double fiber; // 纤维(g)
  final double sodium; // 钠(mg)
  final double calcium; // 钙(mg)
  final double vitaminC; // 维生素C(mg)

  Nutrition({
    this.sugar = 0.0,
    this.fat = 0.0,
    this.protein = 0.0,
    this.caffeine = 0.0,
    this.calories = 0.0,
    this.carbohydrates = 0.0,
    this.fiber = 0.0,
    this.sodium = 0.0,
    this.calcium = 0.0,
    this.vitaminC = 0.0,
  });

  // 从Map创建Nutrition对象
  factory Nutrition.fromMap(Map<String, dynamic> map) {
    return Nutrition(
      sugar: map['sugar']?.toDouble() ?? 0.0,
      fat: map['fat']?.toDouble() ?? 0.0,
      protein: map['protein']?.toDouble() ?? 0.0,
      caffeine: map['caffeine']?.toDouble() ?? 0.0,
      calories: map['calories']?.toDouble() ?? 0.0,
      carbohydrates: map['carbohydrates']?.toDouble() ?? 0.0,
      fiber: map['fiber']?.toDouble() ?? 0.0,
      sodium: map['sodium']?.toDouble() ?? 0.0,
      calcium: map['calcium']?.toDouble() ?? 0.0,
      vitaminC: map['vitaminC']?.toDouble() ?? 0.0,
    );
  }

  // 转换为Map
  Map<String, dynamic> toMap() {
    return {
      'sugar': sugar,
      'fat': fat,
      'protein': protein,
      'caffeine': caffeine,
      'calories': calories,
      'carbohydrates': carbohydrates,
      'fiber': fiber,
      'sodium': sodium,
      'calcium': calcium,
      'vitaminC': vitaminC,
    };
  }

  // 转换为JSON
  Map<String, dynamic> toJson() => toMap();

  // 从JSON创建对象
  factory Nutrition.fromJson(Map<String, dynamic> json) =>
      Nutrition.fromMap(json);

  // 复制对象并修改部分属性
  Nutrition copyWith({
    double? sugar,
    double? fat,
    double? protein,
    double? caffeine,
    double? calories,
    double? carbohydrates,
    double? fiber,
    double? sodium,
    double? calcium,
    double? vitaminC,
  }) {
    return Nutrition(
      sugar: sugar ?? this.sugar,
      fat: fat ?? this.fat,
      protein: protein ?? this.protein,
      caffeine: caffeine ?? this.caffeine,
      calories: calories ?? this.calories,
      carbohydrates: carbohydrates ?? this.carbohydrates,
      fiber: fiber ?? this.fiber,
      sodium: sodium ?? this.sodium,
      calcium: calcium ?? this.calcium,
      vitaminC: vitaminC ?? this.vitaminC,
    );
  }

  // 营养成分相加
  Nutrition operator +(Nutrition other) {
    return Nutrition(
      sugar: sugar + other.sugar,
      fat: fat + other.fat,
      protein: protein + other.protein,
      caffeine: caffeine + other.caffeine,
      calories: calories + other.calories,
      carbohydrates: carbohydrates + other.carbohydrates,
      fiber: fiber + other.fiber,
      sodium: sodium + other.sodium,
      calcium: calcium + other.calcium,
      vitaminC: vitaminC + other.vitaminC,
    );
  }

  // 营养成分按比例缩放
  Nutrition operator *(double factor) {
    return Nutrition(
      sugar: sugar * factor,
      fat: fat * factor,
      protein: protein * factor,
      caffeine: caffeine * factor,
      calories: calories * factor,
      carbohydrates: carbohydrates * factor,
      fiber: fiber * factor,
      sodium: sodium * factor,
      calcium: calcium * factor,
      vitaminC: vitaminC * factor,
    );
  }

  @override
  String toString() {
    return 'Nutrition{calories: $calories, sugar: $sugar, caffeine: $caffeine}';
  }
}

// 每日营养统计
class DailyNutritionStats {
  final DateTime date;
  final Nutrition totalNutrition;
  final int drinkCount; // 饮品数量
  final double totalVolume; // 总容量(ml)
  final List<String> categories; // 饮品类别

  DailyNutritionStats({
    required this.date,
    required this.totalNutrition,
    required this.drinkCount,
    required this.totalVolume,
    required this.categories,
  });

  // 从Map创建DailyNutritionStats对象
  factory DailyNutritionStats.fromMap(Map<String, dynamic> map) {
    return DailyNutritionStats(
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      totalNutrition: Nutrition.fromMap(map['totalNutrition'] ?? {}),
      drinkCount: map['drinkCount']?.toInt() ?? 0,
      totalVolume: map['totalVolume']?.toDouble() ?? 0.0,
      categories: List<String>.from(map['categories'] ?? []),
    );
  }

  // 转换为Map
  Map<String, dynamic> toMap() {
    return {
      'date': date.millisecondsSinceEpoch,
      'totalNutrition': totalNutrition.toMap(),
      'drinkCount': drinkCount,
      'totalVolume': totalVolume,
      'categories': categories,
    };
  }

  // 获取日期字符串
  String get dateString {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

// 营养健康评估
class HealthAssessment {
  final double sugarLevel; // 糖分水平 (0-1, 0为健康, 1为超标)
  final double caffeineLevel; // 咖啡因水平 (0-1)
  final double calorieLevel; // 热量水平 (0-1)
  final double hydrationLevel; // 水分补充水平 (0-1, 1为达标)
  final List<HealthWarning> warnings; // 健康警告
  final List<HealthSuggestion> suggestions; // 健康建议

  HealthAssessment({
    required this.sugarLevel,
    required this.caffeineLevel,
    required this.calorieLevel,
    required this.hydrationLevel,
    required this.warnings,
    required this.suggestions,
  });

  // 获取总体健康评分 (0-100)
  int get overallScore {
    double score = 100.0;
    score -= sugarLevel * 30; // 糖分影响30分
    score -= caffeineLevel * 20; // 咖啡因影响20分
    score -= calorieLevel * 20; // 热量影响20分
    score += hydrationLevel * 30; // 水分补充加30分
    return score.clamp(0, 100).round();
  }

  // 获取健康等级
  HealthGrade get healthGrade {
    if (overallScore >= 90) return HealthGrade.excellent;
    if (overallScore >= 80) return HealthGrade.good;
    if (overallScore >= 70) return HealthGrade.fair;
    if (overallScore >= 60) return HealthGrade.poor;
    return HealthGrade.veryPoor;
  }
}

// 健康警告
class HealthWarning {
  final WarningType type;
  final String message;
  final WarningLevel level;

  HealthWarning({
    required this.type,
    required this.message,
    required this.level,
  });
}

// 健康建议
class HealthSuggestion {
  final String title;
  final String description;
  final SuggestionType type;

  HealthSuggestion({
    required this.title,
    required this.description,
    required this.type,
  });
}

// 枚举定义
enum HealthGrade {
  excellent('优秀'),
  good('良好'),
  fair('一般'),
  poor('较差'),
  veryPoor('很差');

  const HealthGrade(this.displayName);
  final String displayName;
}

enum WarningType {
  highSugar('糖分过高'),
  highCaffeine('咖啡因过量'),
  highCalorie('热量过高'),
  lowHydration('水分不足');

  const WarningType(this.displayName);
  final String displayName;
}

enum WarningLevel {
  low('轻微'),
  medium('中等'),
  high('严重');

  const WarningLevel(this.displayName);
  final String displayName;
}

enum SuggestionType {
  nutrition('营养建议'),
  hydration('补水建议'),
  exercise('运动建议'),
  lifestyle('生活方式建议');

  const SuggestionType(this.displayName);
  final String displayName;
}
