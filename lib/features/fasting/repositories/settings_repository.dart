import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_profile.dart';

/// 应用设置与用户配置仓库
class SettingsRepository {
  static const _userProfileKey = 'user_profile';
  static const _themeModeKey = 'theme_mode';
  static const _onboardingKey = 'has_completed_onboarding';
  static const _privacyKey = 'has_agreed_privacy';

  /// 加载用户个人信息（如果还未设置则返回 null）
  Future<UserProfile?> loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_userProfileKey);
    if (stored == null || stored.isEmpty) {
      return null;
    }

    try {
      return UserProfile.fromStorageString(stored);
    } catch (_) {
      // 数据损坏时忽略并清空，避免阻塞应用
      await prefs.remove(_userProfileKey);
      return null;
    }
  }

  /// 保存用户个人信息
  Future<void> saveUserProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userProfileKey, profile.toStorageString());
  }

  /// 加载主题模式（返回 'system' / 'light' / 'dark' 字符串，未设置时返回 null）
  Future<String?> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_themeModeKey);
  }

  /// 保存主题模式（值为 'system' / 'light' / 'dark'）
  Future<void> saveThemeMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, mode);
  }

  /// 加载是否已完成新手引导
  Future<bool> loadHasCompletedOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }

  /// 保存是否已完成新手引导
  Future<void> saveHasCompletedOnboarding(bool completed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, completed);
  }

  /// 加载是否已同意隐私协议
  Future<bool> loadHasAgreedPrivacy() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_privacyKey) ?? false;
  }

  /// 保存是否已同意隐私协议
  Future<void> saveHasAgreedPrivacy(bool agreed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_privacyKey, agreed);
  }
}
