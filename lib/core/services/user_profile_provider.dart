// 共享 UserProfile provider (从 user_info_screen.dart 提取)

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile {
  final String nickname;
  final String gender;
  final int heightCm;
  final int weightKg;
  final DateTime? birthday;
  UserProfile({
    this.nickname = '微刻用户',
    this.gender = 'male',
    this.heightCm = 170,
    this.weightKg = 65,
    this.birthday,
  });
  UserProfile copyWith({String? nickname, String? gender, int? heightCm, int? weightKg, DateTime? birthday}) =>
    UserProfile(
      nickname: nickname ?? this.nickname,
      gender: gender ?? this.gender,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      birthday: birthday ?? this.birthday,
    );
}

class UserProfileNotifier extends Notifier<UserProfile> {
  @override
  UserProfile build() => UserProfile();

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    final s = p.getString('user_profile');
    if (s != null) {
      final parts = s.split('|');
      if (parts.length >= 5) {
        state = UserProfile(
          nickname: parts[0],
          gender: parts[1],
          heightCm: int.tryParse(parts[2]) ?? 170,
          weightKg: int.tryParse(parts[3]) ?? 65,
          birthday: parts[4].isEmpty ? null : DateTime.tryParse(parts[4]),
        );
      }
    }
  }

  Future<void> save() async {
    final p = await SharedPreferences.getInstance();
    final s = '${state.nickname}|${state.gender}|${state.heightCm}|${state.weightKg}|${state.birthday?.toIso8601String() ?? ''}';
    await p.setString('user_profile', s);
  }

  void update(UserProfile p) {
    state = p;
    save();
  }
}

final userProfileProvider = NotifierProvider<UserProfileNotifier, UserProfile>(UserProfileNotifier.new);
