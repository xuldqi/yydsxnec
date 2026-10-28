import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class CapWordsStickerStage extends StatelessWidget {
  final String imagePath;
  final String title;
  final double? price;
  final double height;
  final bool showCaption;
  final Color backgroundColor;

  const CapWordsStickerStage({
    super.key,
    required this.imagePath,
    required this.title,
    this.price,
    this.height = 220,
    this.showCaption = false,
    this.backgroundColor = const Color(0xFFE8E5DF),
  });

  bool get _hasPrice => price != null && price! > 0;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Container(
        height: height,
        width: double.infinity,
        color: backgroundColor,
        child: CustomPaint(
          painter: const _StickerStagePainter(),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                top: 18,
                bottom: showCaption ? 50 : 18,
                left: 22,
                right: 22,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Transform.translate(
                      offset: const Offset(0, 4),
                      child: ImageFiltered(
                        imageFilter: ui.ImageFilter.blur(
                          sigmaX: 3.5,
                          sigmaY: 3.5,
                        ),
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            const Color(0xFF3D3028).withValues(alpha: 0.22),
                            BlendMode.srcIn,
                          ),
                          child: Image.file(
                            File(imagePath),
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.high,
                            errorBuilder: (context, error, stackTrace) =>
                                const SizedBox.shrink(),
                          ),
                        ),
                      ),
                    ),
                    Image.file(
                      File(imagePath),
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: AppColors.textSecondary,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              if (showCaption)
                Positioned(
                  left: 18,
                  right: 18,
                  bottom: 14,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.78),
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.95),
                              blurRadius: 12,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: Text(
                          title.trim(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF1F1A17),
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                      if (_hasPrice) ...[
                        const SizedBox(height: 3),
                        Text(
                          '¥${price!.toStringAsFixed(1)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFFD97706),
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StickerStagePainter extends CustomPainter {
  const _StickerStagePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final glowPaint = Paint()
      ..shader = ui.Gradient.radial(
        Offset(size.width * 0.5, size.height * 0.48),
        size.shortestSide * 0.58,
        [
          const Color(0xFFF3F0EA).withValues(alpha: 0.88),
          const Color(0xFFE8E5DF).withValues(alpha: 0),
        ],
      );
    canvas.drawRect(Offset.zero & size, glowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
