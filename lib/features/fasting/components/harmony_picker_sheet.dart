import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HarmonyPickerSheet extends StatelessWidget {
  const HarmonyPickerSheet({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.onCancel,
    this.onConfirm,
    this.confirmText = '确定',
    this.heightFactor = 0.58,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;
  final String confirmText;
  final double heightFactor;

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget child,
    String? subtitle,
    VoidCallback? onConfirm,
    String confirmText = '确定',
    double heightFactor = 0.58,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.28),
      builder: (sheetContext) {
        return HarmonyPickerSheet(
          title: title,
          subtitle: subtitle,
          confirmText: confirmText,
          heightFactor: heightFactor,
          onCancel: () => Navigator.pop(sheetContext),
          onConfirm: onConfirm,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * heightFactor;
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            height: height.clamp(360.0, 620.0),
            decoration: const BoxDecoration(
              color: Color(0xFFFBFBF8),
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 8),
                Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9DBD5),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 6),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 72,
                        child: TextButton(
                          onPressed: onCancel ?? () => Navigator.pop(context),
                          child: const Text('取消'),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFF182B23),
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            if (subtitle != null) ...[
                              const SizedBox(height: 3),
                              Text(
                                subtitle!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Color(0xFF6F7B73),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 72,
                        child: TextButton(
                          onPressed: onConfirm,
                          child: Text(confirmText),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: Color(0xFFE8E9E4)),
                Expanded(child: child),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HarmonyWheelPicker<T> extends StatelessWidget {
  const HarmonyWheelPicker({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelectedItemChanged,
    this.itemExtent = 42,
    this.labelBuilder,
  });

  final List<T> items;
  final int selectedIndex;
  final ValueChanged<int> onSelectedItemChanged;
  final double itemExtent;
  final String Function(T item)? labelBuilder;

  @override
  Widget build(BuildContext context) {
    return CupertinoPicker.builder(
      scrollController: FixedExtentScrollController(initialItem: selectedIndex),
      itemExtent: itemExtent,
      diameterRatio: 1.35,
      squeeze: 1.04,
      magnification: 1.08,
      useMagnifier: true,
      selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(
        background: Color(0x1A2DA66D),
      ),
      onSelectedItemChanged: onSelectedItemChanged,
      childCount: items.length,
      itemBuilder: (context, index) {
        final text =
            labelBuilder?.call(items[index]) ?? items[index].toString();
        return Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF182B23),
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ),
          ),
        );
      },
    );
  }
}

class HarmonyOptionChip extends StatelessWidget {
  const HarmonyOptionChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFF2DA66D) : const Color(0xFFF0F1EC),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 17,
                  color: selected ? Colors.white : const Color(0xFF516057),
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : const Color(0xFF28362F),
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
