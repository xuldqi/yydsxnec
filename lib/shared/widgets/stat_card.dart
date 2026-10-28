import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String unit;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.unit,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.surfaceVariant, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 16),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(value, style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  height: 1,
                )),
                const SizedBox(width: 2),
                Padding(
                  padding: const EdgeInsets.only(bottom: 1),
                  child: Text(unit, style: const TextStyle(
                    color: AppColors.textHint, fontSize: 10,
                  )),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(
              color: AppColors.textHint, fontSize: 11,
            )),
          ],
        ),
      ),
    );
  }
}
