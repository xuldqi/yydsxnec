class Reminder {
  final String id;
  final String title;
  final String? description;
  final DateTime? reminderTime;
  final bool isEnabled;
  final DateTime createdAt;
  final bool isCompleted;

  const Reminder({
    required this.id,
    required this.title,
    this.description,
    this.reminderTime,
    this.isEnabled = true,
    required this.createdAt,
    this.isCompleted = false,
  });

  Reminder copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? reminderTime,
    bool? isEnabled,
    DateTime? createdAt,
    bool? isCompleted,
  }) {
    return Reminder(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      reminderTime: reminderTime ?? this.reminderTime,
      isEnabled: isEnabled ?? this.isEnabled,
      createdAt: createdAt ?? this.createdAt,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'reminder_time': reminderTime?.millisecondsSinceEpoch,
      'is_enabled': isEnabled ? 1 : 0,
      'created_at': createdAt.millisecondsSinceEpoch,
      'is_completed': isCompleted ? 1 : 0,
    };
  }

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      reminderTime: map['reminder_time'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['reminder_time'] as int)
          : null,
      isEnabled: (map['is_enabled'] as int) == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      isCompleted: (map['is_completed'] as int) == 1,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Reminder && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Reminder(id: $id, title: $title)';
  }
}

enum ReminderFrequency {
  oneTime,
  daily,
  weekly;

  String get label {
    switch (this) {
      case ReminderFrequency.oneTime:
        return '一次性';
      case ReminderFrequency.daily:
        return '每天';
      case ReminderFrequency.weekly:
        return '每周';
    }
  }

  static ReminderFrequency fromString(String value) {
    return ReminderFrequency.values.firstWhere(
      (freq) => freq.name == value,
      orElse: () => ReminderFrequency.oneTime,
    );
  }
}
