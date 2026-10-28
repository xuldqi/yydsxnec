import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 应用色彩常量
class AppColors {
  // 主色调 - 自然系绿色
  static const Color primary = Color(0xFF2DA66D);
  static const Color primaryLight = Color(0xFF57B97C);
  static const Color primaryDark = Color(0xFF137B55);
  static const Color secondary = Color(0xFF86D3A2);
  static const Color accent = Color(0xFFEFF9F1);

  // 渐变色彩
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2DA66D), Color(0xFF57B97C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFFBFCFA)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFFFDFDFC), Color(0xFFF7F8F5)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // 功能色彩
  static const Color success = Color(0xFF2DA66D);
  static const Color warning = Color(0xFFE19B32);
  static const Color error = Color(0xFFD96A4A);
  static const Color info = Color(0xFF3C8DD9);

  // 中性色彩 - 优化明度对比
  static const Color background = Color(0xFFFDFDFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF17372B);
  static const Color textSecondary = Color(0xFF6B7D72);
  static const Color textDisabled = Color(0xFFA8B4AA);
  static const Color divider = Color(0xFFE4E4DE);
  static const Color border = Color(0xFFE4E4DE);

  // 深色模式色彩
  static const Color darkPrimary = Color(0xFF86D3A2);
  static const Color darkBackground = Color(0xFF111815);
  static const Color darkSurface = Color(0xFF1C2320);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB8C0B7);

  // 透明度变体
  static Color primaryWithOpacity(double opacity) =>
      primary.withValues(alpha: opacity);
  static Color surfaceWithOpacity(double opacity) =>
      surface.withValues(alpha: opacity);
}

/// 应用主题配置
class AppTheme {
  // 主色调 - 自然系绿色
  static const Color primaryGreen = Color(0xFF2DA66D);
  static const Color primaryGreenLight = Color(0xFF57B97C);
  static const Color primaryGreenDark = Color(0xFF137B55);
  static const Color secondaryGreen = Color(0xFF86D3A2);
  static const Color lightGreen = Color(0xFFEFF9F1);
  static const Color darkGreen = Color(0xFF0E5D42);

  // 渐变色彩
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2DA66D), Color(0xFF57B97C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFFBFCFA)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // 功能色彩
  static const Color successColor = Color(0xFF2DA66D);
  static const Color warningColor = Color(0xFFE19B32);
  static const Color errorColor = Color(0xFFD96A4A);
  static const Color infoColor = Color(0xFF3C8DD9);

  // 中性色彩 - 优化明度对比
  static const Color primaryTextColor = Color(0xFF17372B);
  static const Color secondaryTextColor = Color(0xFF6B7D72);
  static const Color disabledTextColor = Color(0xFFA8B4AA);
  static const Color dividerColor = Color(0xFFE4E4DE);
  static const Color backgroundColor = Color(0xFFFDFDFC);
  static const Color backgroundTopColor = Color(0xFFFEFEFC);
  static const Color backgroundBottomColor = Color(0xFFF7F8F5);
  static const Color cardBackgroundColor = Color(0xFFFFFFFF);
  static const Color softSurfaceColor = Color(0xFFF4F5EF);
  static const Color warmSurfaceColor = Color(0xFFFFF8F1);
  static const Color warmBorderColor = Color(0xFFF4E2CF);
  static const Color warningTextColor = Color(0xFF8C3F27);
  static const Color warningMutedTextColor = Color(0xFFB65A35);
  static const Color pageShadowColor = Color(0x0D1B2B22);

  // 别名颜色（为了兼容性）
  static const Color textPrimary = primaryTextColor;
  static const Color textSecondary = secondaryTextColor;
  static const Color surfaceVariant = Color(0xFFF4F4F1);
  static const Color accentBlue = Color(0xFF5E87D6);
  static const Color waterBlue = Color(0xFF2B8EDB);
  static const Color waterSurfaceColor = Color(0xFFEBF4FA);
  static const Color waterFillColor = Color(0xFFD6EAF8);
  static const Color accentPurple = Color(0xFF7B68D8);
  static const Color accentOrange = Color(0xFFB87920);
  static const Color accentRose = Color(0xFFD15F4C);
  static const Color accentPink = Color(0xFFD15F82);
  static const Color accentTeal = Color(0xFF4D8CA8);
  static const Color accentFire = Color(0xFFD84A3B);
  static const Color accentDeepPurple = Color(0xFF8634A1);
  static const Color stageNeutral = Color(0xFF777B73);

  static const LinearGradient pageGradient = LinearGradient(
    colors: [backgroundTopColor, backgroundBottomColor],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // 深色模式色彩
  static const Color darkBackgroundColor = Color(0xFF111815);
  static const Color darkSurfaceColor = Color(0xFF1C2320);
  static const Color darkPrimaryTextColor = Color(0xFFFFFFFF);
  static const Color darkSecondaryTextColor = Color(0xFFB8C0B7);
  static const Color darkPrimaryGreen = Color(0xFF86D3A2);

  /// 浅色主题
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primarySwatch: _createMaterialColor(primaryGreen),
      primaryColor: primaryGreen,
      scaffoldBackgroundColor: backgroundColor,
      cardColor: cardBackgroundColor,
      dividerColor: dividerColor,

      // 颜色方案
      colorScheme: const ColorScheme.light(
        primary: primaryGreen,
        secondary: secondaryGreen,
        surface: cardBackgroundColor,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: primaryTextColor,
        onError: Colors.white,
        tertiary: primaryGreenLight,
        onTertiary: Colors.white,
      ),

      // 应用栏主题
      appBarTheme: const AppBarTheme(
        backgroundColor: cardBackgroundColor,
        foregroundColor: primaryTextColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        titleTextStyle: TextStyle(
          color: primaryTextColor,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),

      // 卡片主题
      cardTheme: const CardThemeData(
        color: cardBackgroundColor,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        margin: EdgeInsets.all(8),
      ),

      // 按钮主题
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          minimumSize: const Size(double.infinity, 48),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryGreen,
          side: const BorderSide(color: primaryGreen),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          minimumSize: const Size(double.infinity, 48),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryGreen,
          minimumSize: const Size(double.infinity, 48),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),

      // 输入框主题
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: dividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryGreen, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor),
        ),
        contentPadding: const EdgeInsets.all(12),
        hintStyle: const TextStyle(color: disabledTextColor),
      ),

      // 进度条主题
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryGreen,
        linearTrackColor: dividerColor,
      ),

      // 底部导航栏主题
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: cardBackgroundColor,
        selectedItemColor: primaryGreen,
        unselectedItemColor: secondaryTextColor,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // 文字主题
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: primaryTextColor,
        ),
        displayMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: primaryTextColor,
        ),
        displaySmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: primaryTextColor,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: primaryTextColor,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: secondaryTextColor,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: secondaryTextColor,
        ),
      ),
    );
  }

  /// 深色主题
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primarySwatch: _createMaterialColor(darkPrimaryGreen),
      primaryColor: darkPrimaryGreen,
      scaffoldBackgroundColor: darkBackgroundColor,
      cardColor: darkSurfaceColor,
      dividerColor: dividerColor,

      // 颜色方案
      colorScheme: const ColorScheme.dark(
        primary: darkPrimaryGreen,
        secondary: secondaryGreen,
        surface: darkSurfaceColor,
        error: errorColor,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: darkPrimaryTextColor,
        onError: Colors.white,
        tertiary: primaryGreenLight,
        onTertiary: Colors.black,
      ),

      // 应用栏主题
      appBarTheme: const AppBarTheme(
        backgroundColor: darkSurfaceColor,
        foregroundColor: darkPrimaryTextColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        titleTextStyle: TextStyle(
          color: darkPrimaryTextColor,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),

      // 卡片主题
      cardTheme: const CardThemeData(
        color: darkSurfaceColor,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        margin: EdgeInsets.all(8),
      ),

      // 按钮主题
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkPrimaryGreen,
          foregroundColor: Colors.black,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          minimumSize: const Size(double.infinity, 48),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkPrimaryGreen,
          side: const BorderSide(color: darkPrimaryGreen),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          minimumSize: const Size(double.infinity, 48),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: darkPrimaryGreen,
          minimumSize: const Size(double.infinity, 48),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),

      // 输入框主题
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: dividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkPrimaryGreen, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor),
        ),
        contentPadding: const EdgeInsets.all(12),
        hintStyle: const TextStyle(color: darkSecondaryTextColor),
      ),

      // 进度条主题
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: darkPrimaryGreen,
        linearTrackColor: dividerColor,
      ),

      // 底部导航栏主题
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: darkSurfaceColor,
        selectedItemColor: darkPrimaryGreen,
        unselectedItemColor: darkSecondaryTextColor,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // 文字主题
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: darkPrimaryTextColor,
        ),
        displayMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: darkPrimaryTextColor,
        ),
        displaySmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: darkPrimaryTextColor,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: darkPrimaryTextColor,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: darkSecondaryTextColor,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: darkSecondaryTextColor,
        ),
      ),
    );
  }

  /// 创建MaterialColor
  static MaterialColor _createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = (color.r * 255.0).round().clamp(0, 255);
    final int g = (color.g * 255.0).round().clamp(0, 255);
    final int b = (color.b * 255.0).round().clamp(0, 255);

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.toARGB32(), swatch);
  }
}

/// 应用间距常量
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
}

/// 应用圆角常量
class AppRadius {
  static const double sm = 4.0;
  static const double md = 8.0;
  static const double lg = 12.0;
  static const double xl = 16.0;
  static const double control = 18.0;
  static const double tile = 20.0;
  static const double card = 24.0;
  static const double panel = 26.0;
  static const double hero = 28.0;
  static const double pill = 999.0;
}

/// 应用阴影常量
class AppShadows {
  static const List<BoxShadow> card = [
    BoxShadow(color: Color(0x0D000000), blurRadius: 4, offset: Offset(0, 2)),
  ];

  static const List<BoxShadow> panel = [
    BoxShadow(
      color: AppColors.primary,
      blurRadius: 24,
      offset: Offset(0, 12),
    ),
  ];

  static const List<BoxShadow> button = [
    BoxShadow(color: Color(0x1A000000), blurRadius: 8, offset: Offset(0, 4)),
  ];
}
