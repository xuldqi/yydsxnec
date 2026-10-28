import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // 主要颜色 (Cute Warm Style)
  static const Color primaryColor = Color(0xFFFF7B93); // Strawberry Pink
  static const Color primaryDark = Color(0xFFE95173); // Deeper strawberry
  static const Color primaryLight = Color(0xFFFFDDE5); // Blush pink

  // Backward compatibility aliases
  static const Color primaryGreen = primaryColor;
  static const Color primaryBrown = primaryDark;
  static const Color lightGreen = primaryLight;
  static const Color darkGreen = primaryDark;
  static const Color lightBrown = primaryLight;
  static const Color darkBrown = primaryDark;

  // 背景颜色
  static const Color backgroundColor = Color(
    0xFFFFFBF6,
  ); // warm milk background
  static const Color cardColor = Color(0xFFFFFEFC);
  static const Color surfaceColor = Color(0xFFFFFAF4);

  // 文字颜色
  static const Color textPrimary = Color(0xFF3F251A); // deep cocoa
  static const Color textSecondary = Color(0xFF8E7568); // warm taupe
  static const Color textHint = Color(0xFFCBB8AA);

  // 状态颜色
  static const Color successColor = Color(0xFFA7F3D0); // Mint green
  static const Color warningColor = Color(0xFFFEF08A); // Lemon cream
  static const Color errorColor = Color(0xFFFF7B93); // Strawberry pink
  static const Color infoColor = Color(0xFFBAE6FD); // Sky blue

  static ThemeData get lightTheme => themeForColor('#FF7B93');

  static Color parseHexColor(String hex) {
    final cleanHex = hex.replaceAll('#', '');
    if (cleanHex.length == 6) {
      return Color(int.parse('FF$cleanHex', radix: 16));
    } else if (cleanHex.length == 8) {
      return Color(int.parse(cleanHex, radix: 16));
    }
    return primaryColor;
  }

  static ThemeData themeForColor(String hexColor) {
    Color primary = primaryColor;
    if (hexColor != '#000000' && hexColor.isNotEmpty) {
      primary = parseHexColor(hexColor);
    }

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
        primary: primary,
        secondary: primaryLight,
        surface: backgroundColor,
        error: errorColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor: backgroundColor,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),
      cardTheme: const CardThemeData(
        color: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(22)),
          side: BorderSide(color: Color(0xFFF5E6D8), width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(22)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFF3E1D2), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFF3E1D2), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: primary, width: 2.0),
        ),
        labelStyle: const TextStyle(color: textSecondary),
        hintStyle: const TextStyle(color: textHint),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primary,
        unselectedItemColor: textHint,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
