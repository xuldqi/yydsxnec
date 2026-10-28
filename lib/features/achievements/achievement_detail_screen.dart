// 成就详情页 (对应 Android AchievementsActivity 中的详情 + dialog_achievement_unlock)

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/app_l10n_ext.dart';

class AchievementUnlockDialog extends StatelessWidget {
  final String name, description;
  final IconData icon;
  final Color color;
  const AchievementUnlockDialog({
    super.key, required this.name, required this.description,
    required this.icon, required this.color,
  });

  static Future<void> show(BuildContext ctx, {
    required String name, required String description, required IconData icon, required Color color,
  }) {
    HapticFeedback.heavyImpact();
    return showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (_) => AchievementUnlockDialog(name: name, description: description, icon: icon, color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [color, color.withValues(alpha: 0.7)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🏆', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 8),
            const Text('成就解锁！', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Container(
              width: 90, height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.white.withValues(alpha: 0.5), blurRadius: 24, spreadRadius: 2),
                ],
              ),
              child: Icon(icon, color: color, size: 48),
            ),
            const SizedBox(height: 14),
            Text(name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(description, textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13, height: 1.5)),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity, height: 44,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: color),
                child: const Text('继续', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AchievementDetailScreen extends StatelessWidget {
  final String id, name, description, category;
  final IconData icon;
  final Color color;
  final bool unlocked;
  final double progress;
  const AchievementDetailScreen({
    super.key, required this.id, required this.name, required this.description,
    required this.category, required this.icon, required this.color,
    required this.unlocked, required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context).s;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(name),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimens.spacingMd),
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimens.spacingXl),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [color, color.withValues(alpha: 0.7)],
              ),
              borderRadius: BorderRadius.circular(AppDimens.radiusCard),
            ),
            child: Column(
              children: [
                Container(
                  width: 120, height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.white.withValues(alpha: 0.5), blurRadius: 20),
                    ],
                  ),
                  child: Icon(icon, color: color, size: 60),
                ),
                const SizedBox(height: 12),
                Text(name, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(category, style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 13)),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(unlocked ? l.unlocked : '${(progress * 100).toInt()}% ${l.unlockProgress}',
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(AppDimens.spacingMd),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimens.radiusCard),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.unlockCondition, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Text(description, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.6)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l.unlockProgress, style: const TextStyle(color: AppColors.textHint, fontSize: 12)),
                        const SizedBox(height: 4),
                        Text('${(progress * 100).toInt()}%',
                          style: const TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
                      ],
                    )),
                    SizedBox(
                      width: 80, height: 80,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 80, height: 80,
                            child: CircularProgressIndicator(
                              value: progress, strokeWidth: 6,
                              backgroundColor: AppColors.border,
                              valueColor: AlwaysStoppedAnimation(color),
                            ),
                          ),
                          Icon(unlocked ? Icons.check_rounded : icon, color: color, size: 28),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress, minHeight: 8,
                    backgroundColor: AppColors.border,
                    valueColor: AlwaysStoppedAnimation(color),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (unlocked) Container(
            padding: const EdgeInsets.all(AppDimens.spacingMd),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: AppColors.success),
                const SizedBox(width: 8),
                Expanded(child: Text(l.unlockedOn,
                  style: const TextStyle(color: AppColors.success, fontSize: 14))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
