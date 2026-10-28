import '../../../core/theme/app_colors.dart';
import '../theme/app_theme.dart';
import 'package:flutter/material.dart';
import '../models/emotion_type.dart';

class AppTheme {
  // 主色调 - 奶白、雾紫、淡蓝
  static const Color milkyWhite = AppColors.background;
  static const Color primaryColor = AppColors.primary;
  static const Color mistyPurple = Color(0xFFE8D5E8);
  static const Color lightBlue = Color(0xFFE3F2FD);
  static const Color softPurple = Color(0xFFF3E5F5);
  static const Color paleBlue = Color(0xFFE1F5FE);

  // 情绪颜色
  static const Color veryHappyColor = Color(0xFFFFE082); // 明亮黄色
  static const Color happyColor = Color(0xFFA5D6A7); // 温和绿色
  static const Color neutralColor = Color(0xFFB0BEC5); // 中性灰蓝
  static const Color sadColor = Color(0xFFFFAB91); // 温和橙色
  static const Color verySadColor = Color(0xFFEF9A9A); // 温和红色
  static const Color calmColor = Color(0xFFB3E5FC);
  static const Color errorColor = Color(0xFFE57373);
  static const Color successColor = Color(0xFF81C784); // 成功绿色
  static const Color warningColor = Color(0xFFFFB74D); // 警告橙色

  static const Map<String, Color> moodColors = {
    '开心': Color(0xFFFFD93D),
    '难过': Color(0xFF6B8CCE),
    '生气': Color(0xFFE57373),
    '焦虑': Color(0xFFFFB74D),
    '疲惫': Color(0xFF90A4AE),
    '幸福': Color(0xFFF48FB1),
    '平静': Color(0xFF8DC8B8),
  };

  // 文本颜色
  static const Color primaryText = AppColors.textPrimary;
  static const Color secondaryText = AppColors.textSecondary;
  static const Color lightText = AppColors.textHint;

  // 兼容别名（与 main.dart 中的 AppTheme 保持一致）
  static const Color textPrimary = primaryText;
  static const Color textSecondary = secondaryText;
  static const Color textHint = lightText;

  // 背景颜色
  static const Color backgroundColor = milkyWhite;
  static const Color cardBackground = Color(0xFFFFFFFE);
  static const Color surfaceColor = Color(0xFFF7FAFC);
  static const double pageHorizontalPadding = 14;

  // 阴影颜色
  static const Color shadowColor = Color(0x1A000000);
  static const Color lightShadow = Color(0x0D000000);

  // 边框颜色
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color dividerColor = Color(0xFFEDF2F7);

  // 兼容 constants
  static const Color primaryLight = Color(0xFF8FBC8F);
  static const Color primaryDark = Color(0xFF2D5A3D);
  static const Color secondaryColor = Color(0xFFB8956F);
  static const Color secondaryLight = Color(0xFFD4B896);
  static const Color cardColor = Colors.white;

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: cardColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimary,
      ),
      scaffoldBackgroundColor: backgroundColor,
      iconTheme: const IconThemeData(color: textPrimary),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: cardColor,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: backgroundColor,
        foregroundColor: textPrimary,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: cardColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: textHint,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  // 获取情绪对应的颜色
  static Color getEmotionColor(EmotionType emotion) {
    return Color(emotion.color);
  }

  // 主题数据
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: mistyPurple,
        brightness: Brightness.light,
        surface: cardBackground,
        primary: mistyPurple,
        secondary: lightBlue,
      ),
      scaffoldBackgroundColor: backgroundColor,
      fontFamily: 'SF Pro Display',

      // AppBar主题
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        foregroundColor: primaryText,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: primaryText,
        ),
      ),

      // Card主题
      cardTheme: const CardThemeData(
        color: cardBackground,
        elevation: 2,
        shadowColor: shadowColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // 按钮主题
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: mistyPurple,
          foregroundColor: primaryText,
          elevation: 2,
          shadowColor: shadowColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),

      // 文本按钮主题
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: mistyPurple,
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),

      // 输入框主题
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: mistyPurple, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        hintStyle: const TextStyle(color: lightText, fontSize: 14),
      ),

      // 分割线主题
      dividerTheme: const DividerThemeData(
        color: dividerColor,
        thickness: 1,
        space: 1,
      ),

      // 底部导航栏主题
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: cardBackground,
        selectedItemColor: mistyPurple,
        unselectedItemColor: lightText,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),

      // 浮动操作按钮主题
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: mistyPurple,
        foregroundColor: primaryText,
        elevation: 4,
        shape: CircleBorder(),
      ),
    );
  }

  // 文本样式
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: primaryText,
    height: 1.2,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: primaryText,
    height: 1.3,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: primaryText,
    height: 1.3,
  );

  static const TextStyle titleLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: primaryText,
    height: 1.4,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: primaryText,
    height: 1.4,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: primaryText,
    height: 1.4,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: primaryText,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: primaryText,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: secondaryText,
    height: 1.5,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: lightText,
    height: 1.4,
  );

  // 动画持续时间
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // 边距和间距
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;

  // 圆角半径
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;

  // 阴影
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: shadowColor,
      offset: Offset(0, 2),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> lightCardShadow = [
    BoxShadow(
      color: lightShadow,
      offset: Offset(0, 1),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];
}
