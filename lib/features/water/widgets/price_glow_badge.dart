import 'package:flutter/material.dart';

class PriceGlowBadge extends StatelessWidget {
  final double? price;
  final bool compact;

  const PriceGlowBadge({super.key, required this.price, this.compact = false});

  bool get _hasPrice => price != null && price! > 0;

  @override
  Widget build(BuildContext context) {
    if (!_hasPrice) {
      return const SizedBox.shrink();
    }

    const color = Color(0xFFD97706);
    final label = '¥${price!.toStringAsFixed(compact ? 0 : 1)}';

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.78)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.32),
            blurRadius: compact ? 14 : 20,
            spreadRadius: compact ? 1 : 2,
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.86),
            blurRadius: compact ? 8 : 12,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: compact ? 13 : 18,
          fontWeight: FontWeight.w900,
          color: color,
        ),
      ),
    );
  }
}
