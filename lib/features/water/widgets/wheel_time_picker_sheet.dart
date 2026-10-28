import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

Future<TimeOfDay?> showWheelTimePickerSheet({
  required BuildContext context,
  required TimeOfDay initialTime,
  String title = '选择时间',
}) {
  return showModalBottomSheet<TimeOfDay>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return _WheelTimePickerSheet(initialTime: initialTime, title: title);
    },
  );
}

class _WheelTimePickerSheet extends StatefulWidget {
  final TimeOfDay initialTime;
  final String title;

  const _WheelTimePickerSheet({required this.initialTime, required this.title});

  @override
  State<_WheelTimePickerSheet> createState() => _WheelTimePickerSheetState();
}

class _WheelTimePickerSheetState extends State<_WheelTimePickerSheet> {
  late int _hour;
  late int _minute;
  late final FixedExtentScrollController _hourController;
  late final FixedExtentScrollController _minuteController;

  @override
  void initState() {
    super.initState();
    _hour = widget.initialTime.hour;
    _minute = widget.initialTime.minute;
    _hourController = FixedExtentScrollController(initialItem: _hour);
    _minuteController = FixedExtentScrollController(initialItem: _minute);
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Color(0x1A3F251A),
              blurRadius: 28,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 42,
              height: 4,
              margin: const EdgeInsets.only(bottom: 18),
              decoration: BoxDecoration(
                color: const Color(0xFFE8DDD4),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('取消'),
                ),
                const SizedBox(width: 4),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).pop(TimeOfDay(hour: _hour, minute: _minute));
                  },
                  child: const Text('确定'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 220,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF6F0),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFF2E4DA)),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _buildWheel(
                          controller: _hourController,
                          itemCount: 24,
                          onSelectedItemChanged: (value) {
                            setState(() => _hour = value);
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 32,
                        child: Center(
                          child: Text(
                            ':',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: _buildWheel(
                          controller: _minuteController,
                          itemCount: 60,
                          onSelectedItemChanged: (value) {
                            setState(() => _minute = value);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWheel({
    required FixedExtentScrollController controller,
    required int itemCount,
    required ValueChanged<int> onSelectedItemChanged,
  }) {
    return CupertinoPicker.builder(
      scrollController: controller,
      itemExtent: 44,
      diameterRatio: 1.45,
      squeeze: 1.05,
      magnification: 1.08,
      useMagnifier: true,
      backgroundColor: Colors.transparent,
      selectionOverlay: const SizedBox.shrink(),
      onSelectedItemChanged: onSelectedItemChanged,
      childCount: itemCount,
      itemBuilder: (context, index) {
        return Center(
          child: Text(
            index.toString().padLeft(2, '0'),
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
        );
      },
    );
  }
}
