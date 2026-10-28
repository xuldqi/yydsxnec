import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Brand Colors
  static const primary = Color(0xFF0CC291);      // Main green theme
  static const primaryLight = Color(0xFF34D399); // Lighter green
  static const primaryDark = Color(0xFF065F46);  // Darker green

  // Semantic Colors
  static const success = Color(0xFF10B981);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFEF4444);
  static const info = Color(0xFF3B82F6);

  // Surface & Background Colors
  static const background = Color(0xFFF2F3F5); // Native surface_page
  static const surface = Color(0xFFFFFFFF);
  static const surfaceVariant = Color(0xFFF1F5F9);

  // Text Colors
  static const textPrimary = Color(0xFF222222); // Native text_primary
  static const textSecondary = Color(0xFF666666); // Native text_secondary
  static const textHint = Color(0xFF94A3B8);
  static const textInverse = Color(0xFFFFFFFF);

  // Border & Divider
  static const border = Color(0xFFE2E8F0);
  static const divider = Color(0xFFF1F5F9);

  // Sport Category Colors (Business specific but cleaned up)
  static const sportWalk = Color(0xFF059669);
  static const sportRun = Color(0xFFE11D48);
  static const sportRide = Color(0xFF7C3AED);
  static const sportOther = Color(0xFF64748B);
}
