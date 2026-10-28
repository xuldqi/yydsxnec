import 'package:flutter/material.dart';

class GlassmorphicWrapper extends StatelessWidget {
  final Widget child;

  const GlassmorphicWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class GlassmorphicCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final double borderRadius;
  final Color? borderColor;

  const GlassmorphicCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color,
    this.borderRadius = 22,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? const Color(0xFFFFFEFC),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor ?? const Color(0xFFF5E6D8),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F8B5E3C),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}
