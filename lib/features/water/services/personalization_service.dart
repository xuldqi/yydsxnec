import 'package:flutter/material.dart';
import '../models/user.dart';
import 'database_service.dart';
import 'session_service.dart';

class PersonalizationProvider extends ChangeNotifier {
  static final PersonalizationProvider _instance =
      PersonalizationProvider._internal();
  factory PersonalizationProvider() => _instance;
  PersonalizationProvider._internal();

  final DatabaseService _db = DatabaseService();
  UserPreferences _preferences = UserPreferences();
  String? _userId;
  bool _isLoaded = false;

  UserPreferences get preferences => _preferences;
  bool get isLoaded => _isLoaded;
  String? get userId => _userId;

  // 初始化加载偏好设置
  Future<void> loadPreferences() async {
    try {
      _userId = await SessionService.getCurrentUserId();
      _userId ??= (await SessionService.ensureLocalUser()).id;

      if (_userId != null) {
        _preferences = await _db.getUserPreferences(_userId!);
        _isLoaded = true;
        notifyListeners();
      }
    } catch (_) {
      // 降级处理，使用默认设置
      _isLoaded = true;
      notifyListeners();
    }
  }

  // 更新设置
  Future<void> updatePreferences(UserPreferences newPrefs) async {
    _preferences = newPrefs;
    notifyListeners();

    if (_userId != null) {
      await _db.updateUserPreferences(_userId!, newPrefs);
      await _db.replaceReminderTimes(_userId!, newPrefs.reminderTimes);
    }
  }

  // 快捷更新主题色
  Future<void> updateThemeColor(String hexColor) async {
    final newPrefs = _preferences.copyWith(themeColor: hexColor);
    await updatePreferences(newPrefs);
  }

  // 快捷更新显示类型
  Future<void> updateDisplayPreference(String preference) async {
    final newPrefs = _preferences.copyWith(displayPreference: preference);
    await updatePreferences(newPrefs);
  }

  // 快捷更新背景透明度
  Future<void> updateBackgroundOpacity(double opacity) async {
    final newPrefs = _preferences.copyWith(backgroundOpacity: opacity);
    await updatePreferences(newPrefs);
  }

  // 快捷更新壁纸图片或渐变
  Future<void> updateBackgroundImage(String? imagePath) async {
    final newPrefs = _preferences.copyWith(backgroundImage: imagePath);
    await updatePreferences(newPrefs);
  }

  // 快捷更新月度预算
  Future<void> updateMonthlyBudget(double budget) async {
    final newPrefs = _preferences.copyWith(monthlyBudget: budget);
    await updatePreferences(newPrefs);
  }

  // 快捷更新每日宣言
  Future<void> updateDeclaration(
    String text,
    String textColor,
    String bgColor,
  ) async {
    final newPrefs = _preferences.copyWith(
      declaration: text,
      declarationTextColor: textColor,
      declarationBgColor: bgColor,
    );
    await updatePreferences(newPrefs);
  }
}
