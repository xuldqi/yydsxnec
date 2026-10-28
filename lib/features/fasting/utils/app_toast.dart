import 'package:flutter/material.dart';

enum AppToastType { success, error, info }

void showAppToast(
  BuildContext context,
  String message, {
  AppToastType type = AppToastType.info,
  Duration duration = const Duration(seconds: 2),
}) {
  final overlay = Overlay.maybeOf(context, rootOverlay: true);
  if (overlay == null) return;

  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => _AppToastOverlay(message: message, type: type),
  );

  overlay.insert(entry);
  Future.delayed(duration, () {
    if (entry.mounted) {
      entry.remove();
    }
  });
}

class _AppToastOverlay extends StatelessWidget {
  const _AppToastOverlay({required this.message, required this.type});

  final String message;
  final AppToastType type;

  @override
  Widget build(BuildContext context) {
    final color = switch (type) {
      AppToastType.success => const Color(0xFF137B55),
      AppToastType.error => const Color(0xFFC2410C),
      AppToastType.info => const Color(0xFF17372B),
    };
    final icon = switch (type) {
      AppToastType.success => Icons.check_circle_rounded,
      AppToastType.error => Icons.error_rounded,
      AppToastType.info => Icons.info_rounded,
    };

    return IgnorePointer(
      child: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, -10 * (1 - value)),
                child: Opacity(opacity: value, child: child),
              );
            },
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              constraints: const BoxConstraints(maxWidth: 420),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(999),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.14),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
