// 通用 stub 页面 - 用于 P0 后续页面占位
// 真实实现时替换 body 部分

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';

class StubScreen extends StatelessWidget {
  final String titleKey;
  final IconData icon;
  final Color color;
  final String? subtitleKey;
  final List<Widget>? actions;
  final Widget? body;
  final bool showAppBar;

  const StubScreen({
    super.key,
    required this.titleKey,
    required this.icon,
    this.color = AppColors.primary,
    this.subtitleKey,
    this.actions,
    this.body,
    this.showAppBar = true,
  });

  String _lookup(BuildContext context, String key) {
    final l = AppL10n.of(context);
    try {
      final dyn = l as dynamic;
      return dyn[key] as String? ?? key;
    } catch (_) {
      return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: showAppBar
          ? AppBar(
              title: Text(_lookup(context, titleKey)),
              backgroundColor: AppColors.surface,
              elevation: 0,
              actions: actions,
            )
          : null,
      body: body ?? _defaultBody(context),
    );
  }

  Widget _defaultBody(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100, height: 100,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 50),
            ),
            const SizedBox(height: 20),
            Text(_lookup(context, titleKey),
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
            if (subtitleKey != null) ...[
              const SizedBox(height: 8),
              Text(_lookup(context, subtitleKey!),
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.5)),
            ],
            const SizedBox(height: 24),
            const Text('（此页面待具体业务实现）',
              style: TextStyle(color: AppColors.textHint, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
