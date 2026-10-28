import 'dart:convert';

/// 用户个人信息与健康目标
class UserProfile {
  /// 昵称 / 展示名称
  final String? nickname;

  /// 性别：'M' / 'F' / 'other'
  final String? gender;

  /// 头像本地路径
  final String? avatarPath;

  /// 出生日期
  final DateTime? birthDate;

  /// 身高（厘米）
  final double? heightCm;

  /// 目标体重（公斤）
  final double? targetWeightKg;

  const UserProfile({
    this.nickname,
    this.gender,
    this.birthDate,
    this.heightCm,
    this.targetWeightKg,
    this.avatarPath,
  });

  UserProfile copyWith({
    String? nickname,
    String? gender,
    DateTime? birthDate,
    double? heightCm,
    double? targetWeightKg,
    String? avatarPath,
  }) {
    return UserProfile(
      nickname: nickname ?? this.nickname,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      heightCm: heightCm ?? this.heightCm,
      targetWeightKg: targetWeightKg ?? this.targetWeightKg,
      avatarPath: avatarPath ?? this.avatarPath,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname,
      'gender': gender,
      'birthDate': birthDate?.toIso8601String(),
      'heightCm': heightCm,
      'targetWeightKg': targetWeightKg,
      'avatarPath': avatarPath,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      nickname: json['nickname'] as String?,
      gender: json['gender'] as String?,
      birthDate: json['birthDate'] != null
          ? DateTime.tryParse(json['birthDate'] as String)
          : null,
      heightCm: (json['heightCm'] as num?)?.toDouble(),
      targetWeightKg: (json['targetWeightKg'] as num?)?.toDouble(),
      avatarPath: json['avatarPath'] as String?,
    );
  }

  /// 将配置编码为可存储的字符串
  String toStorageString() => jsonEncode(toJson());

  /// 从存储字符串解析
  factory UserProfile.fromStorageString(String value) {
    final decoded = jsonDecode(value) as Map<String, dynamic>;
    return UserProfile.fromJson(decoded);
  }
}
