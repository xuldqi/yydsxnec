enum GoalFrequency {
  daily,
  weekly,
  monthly;

  String get label {
    switch (this) {
      case GoalFrequency.daily:
        return '每日';
      case GoalFrequency.weekly:
        return '每周';
      case GoalFrequency.monthly:
        return '每月';
    }
  }

  static GoalFrequency fromString(String value) {
    return GoalFrequency.values.firstWhere(
      (freq) => freq.name == value,
      orElse: () => GoalFrequency.daily,
    );
  }
}

enum GoalStatus {
  notStarted,
  inProgress,
  completed,
  onHold;

  String get label {
    switch (this) {
      case GoalStatus.notStarted:
        return '未开始';
      case GoalStatus.inProgress:
        return '进行中';
      case GoalStatus.completed:
        return '已完成';
      case GoalStatus.onHold:
        return '暂停';
    }
  }

  static GoalStatus fromString(String value) {
    return GoalStatus.values.firstWhere(
      (status) => status.name == value,
      orElse: () => GoalStatus.notStarted,
    );
  }
}

class Goal {
  final String id;
  final String title;
  final String? description;
  final GoalFrequency frequency;
  final GoalStatus status;
  final DateTime createdAt;
  final DateTime? completedAt;
  final DateTime? targetDate;
  final List<DateTime> checkIns;

  const Goal({
    required this.id,
    required this.title,
    this.description,
    required this.frequency,
    required this.status,
    required this.createdAt,
    this.completedAt,
    this.targetDate,
    this.checkIns = const [],
  });

  Goal copyWith({
    String? id,
    String? title,
    String? description,
    GoalFrequency? frequency,
    GoalStatus? status,
    DateTime? createdAt,
    DateTime? completedAt,
    DateTime? targetDate,
    List<DateTime>? checkIns,
  }) {
    return Goal(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      frequency: frequency ?? this.frequency,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      targetDate: targetDate ?? this.targetDate,
      checkIns: checkIns ?? this.checkIns,
    );
  }

  double get completionRate {
    if (targetDate == null) return 0;
    final now = DateTime.now();
    if (now.isAfter(targetDate!)) {
      return checkIns.length.toDouble();
    }
    final totalDays = targetDate!.difference(createdAt).inDays;
    if (totalDays <= 0) return 0;
    final expectedCheckIns =
        (frequency.index + 1) *
        (now.difference(createdAt).inDays / (frequency.index + 1)).ceil();
    if (expectedCheckIns <= 0) return 0;
    return (checkIns.length / expectedCheckIns).clamp(0.0, 1.0);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'frequency': frequency.name,
      'status': status.name,
      'created_at': createdAt.millisecondsSinceEpoch,
      'completed_at': completedAt?.millisecondsSinceEpoch,
      'target_date': targetDate?.millisecondsSinceEpoch,
      'check_ins': checkIns.map((d) => d.millisecondsSinceEpoch).join(','),
    };
  }

  factory Goal.fromMap(Map<String, dynamic> map) {
    final checkInsStr = map['check_ins'] as String?;
    final checkIns = checkInsStr != null && checkInsStr.isNotEmpty
        ? checkInsStr
              .split(',')
              .map((s) => DateTime.fromMillisecondsSinceEpoch(int.parse(s)))
              .toList()
        : <DateTime>[];

    return Goal(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      frequency: GoalFrequency.fromString(
        map['frequency'] as String? ?? 'daily',
      ),
      status: GoalStatus.fromString(map['status'] as String? ?? 'notStarted'),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      completedAt: map['completed_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['completed_at'] as int)
          : null,
      targetDate: map['target_date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['target_date'] as int)
          : null,
      checkIns: checkIns,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Goal && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Goal(id: $id, title: $title, status: $status)';
  }
}
