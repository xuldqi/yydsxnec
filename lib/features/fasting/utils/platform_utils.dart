import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

/// 平台工具类
class PlatformUtils {
  /// 获取当前平台名称
  static String get platformName {
    if (kIsWeb) {
      return 'Web';
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return 'Android';
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return 'iOS';
    } else if (defaultTargetPlatform == TargetPlatform.macOS) {
      return 'macOS';
    } else if (defaultTargetPlatform == TargetPlatform.windows) {
      return 'Windows';
    } else if (defaultTargetPlatform == TargetPlatform.linux) {
      return 'Linux';
    }
    return 'Unknown';
  }

  /// 是否为移动平台
  static bool get isMobile {
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  /// 是否为桌面平台
  static bool get isDesktop {
    return defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux;
  }

  /// 是否为Web平台
  static bool get isWeb => kIsWeb;

  /// 获取平台特定的安全区域内边距
  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    if (isMobile) {
      return EdgeInsets.only(
        top: mediaQuery.padding.top,
        bottom: mediaQuery.padding.bottom,
      );
    }
    return EdgeInsets.zero;
  }

  /// 获取平台特定的应用栏高度
  static double getAppBarHeight() {
    if (isMobile) {
      return kToolbarHeight;
    }
    return 56.0; // 桌面和Web平台使用固定高度
  }

  /// 获取平台特定的底部导航栏高度
  static double getBottomNavigationBarHeight() {
    if (isMobile) {
      return kBottomNavigationBarHeight;
    }
    return 60.0; // 桌面和Web平台使用稍高的导航栏
  }

  /// 获取平台特定的最小点击区域大小
  static double getMinTouchTargetSize() {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return 44.0; // iOS Human Interface Guidelines
    }
    return 48.0; // Material Design Guidelines
  }

  /// 获取平台特定的字体系列
  static String? getFontFamily() {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return 'SF Pro Display';
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return 'Roboto';
    }
    return null; // 使用系统默认字体
  }

  /// 获取平台特定的滚动行为
  static ScrollBehavior getScrollBehavior() {
    if (isWeb) {
      return const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown,
        },
      );
    }
    return const MaterialScrollBehavior();
  }

  /// 显示平台信息对话框
  static void showPlatformInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('平台信息'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('当前平台: $platformName'),
            Text('是否为移动设备: ${isMobile ? "是" : "否"}'),
            Text('是否为桌面设备: ${isDesktop ? "是" : "否"}'),
            Text('是否为Web: ${isWeb ? "是" : "否"}'),
            Text('最小点击区域: ${getMinTouchTargetSize()}dp'),
            if (getFontFamily() != null) Text('推荐字体: ${getFontFamily()}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}
