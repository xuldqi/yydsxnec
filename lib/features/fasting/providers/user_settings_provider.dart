import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_profile.dart';
import '../repositories/settings_repository.dart';

/// 设置仓库 Provider
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository();
});

/// 用户个人信息 Provider（带加载状态）
final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, AsyncValue<UserProfile?>>((ref) {
      final repository = ref.read(settingsRepositoryProvider);
      return UserProfileNotifier(repository)..loadUserProfile();
    });

class UserProfileNotifier extends StateNotifier<AsyncValue<UserProfile?>> {
  UserProfileNotifier(this._repository)
    : super(const AsyncValue<UserProfile?>.loading());

  final SettingsRepository _repository;

  Future<void> loadUserProfile() async {
    try {
      state = const AsyncValue.loading();
      final profile = await _repository.loadUserProfile();
      state = AsyncValue.data(profile);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateUserProfile(UserProfile profile) async {
    try {
      state = AsyncValue.data(profile);
      await _repository.saveUserProfile(profile);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }
}

/// 主题模式 Provider（支持跟随系统 / 浅色 / 深色）
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((
  ref,
) {
  final repository = ref.read(settingsRepositoryProvider);
  return ThemeModeNotifier(repository)..loadThemeMode();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier(this._repository) : super(ThemeMode.system);

  final SettingsRepository _repository;

  Future<void> loadThemeMode() async {
    try {
      final stored = await _repository.loadThemeMode();
      if (stored == 'light') {
        state = ThemeMode.light;
      } else if (stored == 'dark') {
        state = ThemeMode.dark;
      } else {
        state = ThemeMode.system;
      }
    } catch (_) {
      state = ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    try {
      String value = 'system';
      if (mode == ThemeMode.light) {
        value = 'light';
      } else if (mode == ThemeMode.dark) {
        value = 'dark';
      }
      await _repository.saveThemeMode(value);
    } catch (_) {
      // 持久化失败时保留内存状态，不中断用户体验
    }
  }
}

/// 新手引导状态 Provider
final hasCompletedOnboardingProvider =
    StateNotifierProvider<OnboardingNotifier, AsyncValue<bool>>((ref) {
      final repository = ref.read(settingsRepositoryProvider);
      return OnboardingNotifier(repository)..loadOnboardingState();
    });

class OnboardingNotifier extends StateNotifier<AsyncValue<bool>> {
  OnboardingNotifier(this._repository) : super(const AsyncValue.loading());

  final SettingsRepository _repository;

  Future<void> loadOnboardingState() async {
    try {
      state = const AsyncValue.loading();
      final completed = await _repository.loadHasCompletedOnboarding();
      state = AsyncValue.data(completed);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> completeOnboarding() async {
    try {
      await _repository.saveHasCompletedOnboarding(true);
      state = const AsyncValue.data(true);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// 隐私协议同意状态 Provider
final hasAgreedPrivacyProvider =
    StateNotifierProvider<PrivacyNotifier, AsyncValue<bool>>((ref) {
      final repository = ref.read(settingsRepositoryProvider);
      return PrivacyNotifier(repository)..loadPrivacyState();
    });

class PrivacyNotifier extends StateNotifier<AsyncValue<bool>> {
  PrivacyNotifier(this._repository) : super(const AsyncValue.loading());

  final SettingsRepository _repository;

  Future<void> loadPrivacyState() async {
    try {
      state = const AsyncValue.loading();
      final agreed = await _repository.loadHasAgreedPrivacy();
      state = AsyncValue.data(agreed);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> agreePrivacy() async {
    try {
      await _repository.saveHasAgreedPrivacy(true);
      state = const AsyncValue.data(true);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
