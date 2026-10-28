class User {
  final String id;
  final String? name;
  final String? avatar;
  final String? email;
  final String? phone;
  final DateTime? birthday;
  final String? gender;
  final double? height; // 身高(cm)
  final double? weight; // 体重(kg)
  final UserPreferences preferences;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    this.name,
    this.avatar,
    this.email,
    this.phone,
    this.birthday,
    this.gender,
    this.height,
    this.weight,
    required this.preferences,
    required this.createdAt,
    required this.updatedAt,
  });

  // 从Map创建User对象
  factory User.fromMap(Map<String, dynamic> map) {
    final createdAtRaw = map['createdAt'] ?? map['created_at'];
    final updatedAtRaw = map['updatedAt'] ?? map['updated_at'];

    return User(
      id: map['id'] ?? '',
      name: map['name'],
      avatar: map['avatar'],
      email: map['email'],
      phone: map['phone'],
      birthday: map['birthday'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['birthday'])
          : null,
      gender: map['gender'],
      height: map['height']?.toDouble(),
      weight: map['weight']?.toDouble(),
      preferences: UserPreferences.fromMap(map['preferences'] ?? {}),
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        createdAtRaw is int
            ? createdAtRaw
            : DateTime.now().millisecondsSinceEpoch,
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        updatedAtRaw is int
            ? updatedAtRaw
            : DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  // 转换为Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'email': email,
      'phone': phone,
      'birthday': birthday?.millisecondsSinceEpoch,
      'gender': gender,
      'height': height,
      'weight': weight,
      'preferences': preferences.toMap(),
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  // 用于数据库存储（snake_case）
  Map<String, dynamic> toDbMap() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'email': email,
      'phone': phone,
      'birthday': birthday?.millisecondsSinceEpoch,
      'gender': gender,
      'height': height,
      'weight': weight,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
    };
  }

  // 转换为JSON
  Map<String, dynamic> toJson() => toMap();

  // 从JSON创建对象
  factory User.fromJson(Map<String, dynamic> json) => User.fromMap(json);

  // 从数据库记录创建对象（snake_case）
  factory User.fromDbMap(Map<String, dynamic> map) => User.fromMap(map);

  // 复制对象并修改部分属性
  User copyWith({
    String? id,
    String? name,
    String? avatar,
    String? email,
    String? phone,
    DateTime? birthday,
    String? gender,
    double? height,
    double? weight,
    UserPreferences? preferences,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      birthday: birthday ?? this.birthday,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      preferences: preferences ?? this.preferences,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email}';
  }
}

// 用户偏好设置
class UserPreferences {
  final double dailyWaterGoal; // 每日饮水目标(ml)
  final double maxDailySugar; // 每日最大糖分摄入(g)
  final double maxDailyCaffeine; // 每日最大咖啡因摄入(mg)
  final bool enableReminders; // 是否启用提醒
  final List<ReminderTime> reminderTimes; // 提醒时间列表
  final bool enableHealthWarnings; // 是否启用健康警告
  final String theme; // 主题设置
  final String language; // 语言设置
  final bool enableDataSync; // 是否启用数据同步
  final bool enableAnalytics; // 是否启用数据分析
  final String themeColor; // 主题色(十六进制色值码，例如 #000000)
  final String displayPreference; // 数据展示偏好(both, chart, number)
  final String? backgroundImage; // 背景图片路径或渐变配置
  final double backgroundOpacity; // 背景图片不透明度
  final double monthlyBudget; // 每月预算
  final String declaration; // 每日宣言
  final String declarationTextColor; // 宣言文字颜色
  final String declarationBgColor; // 宣言背景颜色
  final double weeklyWaterGoal; // 每周饮水目标(ml)
  final double maxWeeklySugar; // 每周最大糖分摄入(g)
  final double maxWeeklyCaffeine; // 每周最大咖啡因摄入(mg)

  UserPreferences({
    this.dailyWaterGoal = 2000.0,
    this.maxDailySugar = 50.0,
    this.maxDailyCaffeine = 400.0,
    this.enableReminders = true,
    this.reminderTimes = const [],
    this.enableHealthWarnings = true,
    this.theme = 'system',
    this.language = 'zh_CN',
    this.enableDataSync = false,
    this.enableAnalytics = true,
    this.themeColor = '#000000',
    this.displayPreference = 'both',
    this.backgroundImage,
    this.backgroundOpacity = 0.3,
    this.monthlyBudget = 0.0,
    this.declaration = '今天也要好好喝水',
    this.declarationTextColor = '#D97706',
    this.declarationBgColor = '#FEF3C7',
    this.weeklyWaterGoal = 14000.0,
    this.maxWeeklySugar = 350.0,
    this.maxWeeklyCaffeine = 2800.0,
  });

  // 从Map创建UserPreferences对象
  factory UserPreferences.fromMap(Map<String, dynamic> map) {
    bool toBool(dynamic value, {required bool fallback}) {
      if (value is bool) return value;
      if (value is num) return value != 0;
      return fallback;
    }

    return UserPreferences(
      dailyWaterGoal:
          (map['dailyWaterGoal'] ?? map['daily_water_goal'])?.toDouble() ??
          2000.0,
      maxDailySugar:
          (map['maxDailySugar'] ?? map['max_daily_sugar'])?.toDouble() ?? 50.0,
      maxDailyCaffeine:
          (map['maxDailyCaffeine'] ?? map['max_daily_caffeine'])?.toDouble() ??
          400.0,
      enableReminders: toBool(
        map['enableReminders'] ?? map['enable_reminders'],
        fallback: true,
      ),
      reminderTimes:
          (map['reminderTimes'] as List<dynamic>?)
              ?.map((x) => ReminderTime.fromMap(x))
              .toList() ??
          [],
      enableHealthWarnings: toBool(
        map['enableHealthWarnings'] ?? map['enable_health_warnings'],
        fallback: true,
      ),
      theme: map['theme'] ?? 'system',
      language: map['language'] ?? 'zh_CN',
      enableDataSync: toBool(
        map['enableDataSync'] ?? map['enable_data_sync'],
        fallback: false,
      ),
      enableAnalytics: toBool(
        map['enableAnalytics'] ?? map['enable_analytics'],
        fallback: true,
      ),
      themeColor: map['themeColor'] ?? map['theme_color'] ?? '#000000',
      displayPreference:
          map['displayPreference'] ?? map['display_preference'] ?? 'both',
      backgroundImage: map['backgroundImage'] ?? map['background_image'],
      backgroundOpacity:
          (map['backgroundOpacity'] ?? map['background_opacity'])?.toDouble() ??
          0.3,
      monthlyBudget:
          (map['monthlyBudget'] ?? map['monthly_budget'])?.toDouble() ?? 0.0,
      declaration: map['declaration']?.toString() ?? '今天也要好好喝水',
      declarationTextColor:
          map['declarationTextColor'] ??
          map['declaration_text_color'] ??
          '#D97706',
      declarationBgColor:
          map['declarationBgColor'] ?? map['declaration_bg_color'] ?? '#FEF3C7',
      weeklyWaterGoal:
          (map['weeklyWaterGoal'] ?? map['weekly_water_goal'])?.toDouble() ??
          14000.0,
      maxWeeklySugar:
          (map['maxWeeklySugar'] ?? map['max_weekly_sugar'])?.toDouble() ??
          350.0,
      maxWeeklyCaffeine:
          (map['maxWeeklyCaffeine'] ?? map['max_weekly_caffeine'])
              ?.toDouble() ??
          2800.0,
    );
  }

  // 转换为Map
  Map<String, dynamic> toMap() {
    return {
      'dailyWaterGoal': dailyWaterGoal,
      'maxDailySugar': maxDailySugar,
      'maxDailyCaffeine': maxDailyCaffeine,
      'enableReminders': enableReminders,
      'reminderTimes': reminderTimes.map((x) => x.toMap()).toList(),
      'enableHealthWarnings': enableHealthWarnings,
      'theme': theme,
      'language': language,
      'enableDataSync': enableDataSync,
      'enableAnalytics': enableAnalytics,
      'themeColor': themeColor,
      'displayPreference': displayPreference,
      'backgroundImage': backgroundImage,
      'backgroundOpacity': backgroundOpacity,
      'monthlyBudget': monthlyBudget,
      'declaration': declaration,
      'declarationTextColor': declarationTextColor,
      'declarationBgColor': declarationBgColor,
      'weeklyWaterGoal': weeklyWaterGoal,
      'maxWeeklySugar': maxWeeklySugar,
      'maxWeeklyCaffeine': maxWeeklyCaffeine,
    };
  }

  // 用于数据库存储（snake_case，提醒时间单独表存储）
  Map<String, dynamic> toDbMap() {
    return {
      'daily_water_goal': dailyWaterGoal,
      'max_daily_sugar': maxDailySugar,
      'max_daily_caffeine': maxDailyCaffeine,
      'enable_reminders': enableReminders ? 1 : 0,
      'enable_health_warnings': enableHealthWarnings ? 1 : 0,
      'theme': theme,
      'language': language,
      'enable_data_sync': enableDataSync ? 1 : 0,
      'enable_analytics': enableAnalytics ? 1 : 0,
      'theme_color': themeColor,
      'display_preference': displayPreference,
      'background_image': backgroundImage,
      'background_opacity': backgroundOpacity,
      'monthly_budget': monthlyBudget,
      'declaration': declaration,
      'declaration_text_color': declarationTextColor,
      'declaration_bg_color': declarationBgColor,
      'weekly_water_goal': weeklyWaterGoal,
      'max_weekly_sugar': maxWeeklySugar,
      'max_weekly_caffeine': maxWeeklyCaffeine,
    };
  }

  factory UserPreferences.fromDbMap(Map<String, dynamic> map) =>
      UserPreferences.fromMap(map);

  // 复制对象并修改部分属性
  UserPreferences copyWith({
    double? dailyWaterGoal,
    double? maxDailySugar,
    double? maxDailyCaffeine,
    bool? enableReminders,
    List<ReminderTime>? reminderTimes,
    bool? enableHealthWarnings,
    String? theme,
    String? language,
    bool? enableDataSync,
    bool? enableAnalytics,
    String? themeColor,
    String? displayPreference,
    String? backgroundImage,
    double? backgroundOpacity,
    double? monthlyBudget,
    String? declaration,
    String? declarationTextColor,
    String? declarationBgColor,
    double? weeklyWaterGoal,
    double? maxWeeklySugar,
    double? maxWeeklyCaffeine,
  }) {
    return UserPreferences(
      dailyWaterGoal: dailyWaterGoal ?? this.dailyWaterGoal,
      maxDailySugar: maxDailySugar ?? this.maxDailySugar,
      maxDailyCaffeine: maxDailyCaffeine ?? this.maxDailyCaffeine,
      enableReminders: enableReminders ?? this.enableReminders,
      reminderTimes: reminderTimes ?? this.reminderTimes,
      enableHealthWarnings: enableHealthWarnings ?? this.enableHealthWarnings,
      theme: theme ?? this.theme,
      language: language ?? this.language,
      enableDataSync: enableDataSync ?? this.enableDataSync,
      enableAnalytics: enableAnalytics ?? this.enableAnalytics,
      themeColor: themeColor ?? this.themeColor,
      displayPreference: displayPreference ?? this.displayPreference,
      backgroundImage: backgroundImage ?? this.backgroundImage,
      backgroundOpacity: backgroundOpacity ?? this.backgroundOpacity,
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
      declaration: declaration ?? this.declaration,
      declarationTextColor: declarationTextColor ?? this.declarationTextColor,
      declarationBgColor: declarationBgColor ?? this.declarationBgColor,
      weeklyWaterGoal: weeklyWaterGoal ?? this.weeklyWaterGoal,
      maxWeeklySugar: maxWeeklySugar ?? this.maxWeeklySugar,
      maxWeeklyCaffeine: maxWeeklyCaffeine ?? this.maxWeeklyCaffeine,
    );
  }
}

// 提醒时间
class ReminderTime {
  final int? id;
  final int hour; // 小时(0-23)
  final int minute; // 分钟(0-59)
  final bool enabled; // 是否启用
  final String? message; // 提醒消息
  final int? calendarEventId; // 系统日历事件ID

  const ReminderTime({
    this.id,
    required this.hour,
    required this.minute,
    this.enabled = true,
    this.message,
    this.calendarEventId,
  });

  // 从Map创建ReminderTime对象
  factory ReminderTime.fromMap(Map<String, dynamic> map) {
    bool toBool(dynamic value, {required bool fallback}) {
      if (value is bool) return value;
      if (value is num) return value != 0;
      return fallback;
    }

    return ReminderTime(
      id: map['id']?.toInt(),
      hour: map['hour']?.toInt() ?? 0,
      minute: map['minute']?.toInt() ?? 0,
      enabled: toBool(map['enabled'], fallback: true),
      message: map['message'],
      calendarEventId: (map['calendarEventId'] ?? map['calendar_event_id'])
          ?.toInt(),
    );
  }

  // 转换为Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'hour': hour,
      'minute': minute,
      'enabled': enabled,
      'message': message,
      'calendarEventId': calendarEventId,
    };
  }

  Map<String, dynamic> toDbMap() {
    return {
      'hour': hour,
      'minute': minute,
      'enabled': enabled ? 1 : 0,
      'message': message,
      'calendar_event_id': calendarEventId,
    };
  }

  // 获取时间字符串
  String get timeString {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  // 复制对象并修改部分属性
  ReminderTime copyWith({
    int? id,
    int? hour,
    int? minute,
    bool? enabled,
    String? message,
    int? calendarEventId,
  }) {
    return ReminderTime(
      id: id ?? this.id,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      enabled: enabled ?? this.enabled,
      message: message ?? this.message,
      calendarEventId: calendarEventId ?? this.calendarEventId,
    );
  }

  @override
  String toString() {
    return 'ReminderTime{hour: $hour, minute: $minute, enabled: $enabled, calendarEventId: $calendarEventId}';
  }
}
