import 'package:flutter/material.dart';
import 'package:steps_webu_flutter/core/theme/app_colors.dart';

/// 现代化卡片组件
class ModernCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final bool useGradient;
  final bool showShadow;
  final double borderRadius;
  final Color? backgroundColor;
  final Gradient? gradient;
  final Border? border;
  final double elevation;

  const ModernCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.onTap,
    this.useGradient = false,
    this.showShadow = true,
    this.borderRadius = 10.0,
    this.backgroundColor,
    this.gradient,
    this.border,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 默认背景色
    Color defaultBackgroundColor =
        backgroundColor ?? (isDark ? Color(0xFF1E293B) : AppColors.surface);

    // 默认渐变
    Gradient defaultGradient = useGradient
        ? (isDark
              ? LinearGradient(
                  colors: [
                    Color(0xFF1E293B),
                    Color(0xFF1E293B).withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : LinearGradient(colors: [AppColors.surface, AppColors.surfaceVariant]))
        : LinearGradient(
            colors: [defaultBackgroundColor, defaultBackgroundColor],
          );

    // 阴影效果 - 更加锐利清晰
    List<BoxShadow> shadows = showShadow
        ? [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.25)
                  : AppColors.primary.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: -2,
            ),
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.1)
                  : AppColors.primary.withValues(alpha: 0.03),
              blurRadius: 4,
              offset: const Offset(0, 1),
              spreadRadius: 0,
            ),
          ]
        : [];

    Widget cardContent = Container(
      width: width,
      height: height,
      margin: margin ?? const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        gradient: gradient ?? defaultGradient,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: shadows,
        border: border,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            padding: padding ?? const EdgeInsets.all(16.0),
            child: child,
          ),
        ),
      ),
    );

    // 如果有elevation，使用Card包装
    if (elevation > 0) {
      return Card(
        elevation: elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        margin: margin ?? const EdgeInsets.all(8.0),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            gradient: gradient ?? defaultGradient,
            borderRadius: BorderRadius.circular(borderRadius),
            border: border,
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(borderRadius),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(borderRadius),
              child: Container(
                padding: padding ?? const EdgeInsets.all(16.0),
                child: child,
              ),
            ),
          ),
        ),
      );
    }

    return cardContent;
  }
}

/// 渐变卡片组件
class GradientCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final Gradient? gradient;
  final double borderRadius;
  final bool showShadow;

  const GradientCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.onTap,
    this.gradient,
    this.borderRadius = 10.0,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return ModernCard(
      padding: padding,
      margin: margin,
      width: width,
      height: height,
      onTap: onTap,
      useGradient: true,
      gradient: gradient ?? LinearGradient(colors: [AppColors.primary, AppColors.primaryDark]),
      borderRadius: borderRadius,
      showShadow: showShadow,
      child: child,
    );
  }
}

/// 玻璃态卡片组件
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final double borderRadius;
  final double opacity;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.onTap,
    this.borderRadius = 10.0,
    this.opacity = 0.1,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ModernCard(
      padding: padding,
      margin: margin,
      width: width,
      height: height,
      onTap: onTap,
      borderRadius: borderRadius,
      showShadow: false,
      backgroundColor: isDark
          ? Colors.white.withValues(alpha: opacity)
          : AppColors.primary.withValues(alpha: opacity),
      border: Border.all(
        color: isDark
            ? Colors.white.withValues(alpha: 0.2)
            : AppColors.primary.withValues(alpha: 0.2),
        width: 1,
      ),
      child: child,
    );
  }
}
