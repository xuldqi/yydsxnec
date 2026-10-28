enum AchievementCategory {
  record('记录'),
  streak('连续达标'),
  explore('饮品探索'),
  goal('补水习惯');

  const AchievementCategory(this.displayName);
  final String displayName;
}

class Achievement {
  final String id;
  final String name;
  final String description;
  final String icon; // Emoji or asset path
  final int target;
  final int current;
  final bool completed;
  final DateTime? completedAt;
  final AchievementCategory category;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.target,
    required this.current,
    required this.completed,
    this.completedAt,
    required this.category,
  });

  // 从Map构建对象
  factory Achievement.fromMap(Map<String, dynamic> map) {
    final completedVal = map['completed'];
    final completedBool = completedVal is bool
        ? completedVal
        : (completedVal is num ? completedVal != 0 : false);

    final completedAtRaw = map['completed_at'] ?? map['completedAt'];
    DateTime? completedAt;
    if (completedAtRaw != null && completedAtRaw.toString().isNotEmpty) {
      if (completedAtRaw is int) {
        completedAt = DateTime.fromMillisecondsSinceEpoch(completedAtRaw);
      } else {
        completedAt = DateTime.tryParse(completedAtRaw.toString());
      }
    }

    final catStr = map['category'] ?? '';
    AchievementCategory category = AchievementCategory.record;
    for (var val in AchievementCategory.values) {
      if (val.name == catStr) {
        category = val;
        break;
      }
    }

    return Achievement(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      icon: map['icon'] ?? '',
      target: map['target']?.toInt() ?? 0,
      current: map['current']?.toInt() ?? 0,
      completed: completedBool,
      completedAt: completedAt,
      category: category,
    );
  }

  // 转换为Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'target': target,
      'current': current,
      'completed': completed,
      'completedAt': completedAt?.toIso8601String(),
      'category': category.name,
    };
  }

  // 转换为数据库存储形式
  Map<String, dynamic> toDbMap(String userId) {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'target': target,
      'current': current,
      'completed': completed ? 1 : 0,
      'completed_at': completedAt?.millisecondsSinceEpoch,
      'category': category.name,
      'user_id': userId,
    };
  }

  // copyWith
  Achievement copyWith({
    String? id,
    String? name,
    String? description,
    String? icon,
    int? target,
    int? current,
    bool? completed,
    DateTime? completedAt,
    AchievementCategory? category,
  }) {
    return Achievement(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      target: target ?? this.target,
      current: current ?? this.current,
      completed: completed ?? this.completed,
      completedAt: completedAt ?? this.completedAt,
      category: category ?? this.category,
    );
  }
}
