import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PickerUtils {
  static Future<DateTime?> showCupertinoDateTimePicker(
    BuildContext context, {
    required DateTime initialDateTime,
    CupertinoDatePickerMode mode = CupertinoDatePickerMode.dateAndTime,
    DateTime? minimumDate,
    DateTime? maximumDate,
    bool use24hFormat = true,
  }) async {
    DateTime selectedDate = initialDateTime;

    // Ensure the initialDateTime is within min/max bounds to prevent crash
    if (minimumDate != null && selectedDate.isBefore(minimumDate)) {
      selectedDate = minimumDate;
    }
    if (maximumDate != null && selectedDate.isAfter(maximumDate)) {
      selectedDate = maximumDate;
    }

    final result = await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                height: 56,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(
                        context,
                      ).dividerColor.withValues(alpha: 0.1),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        '取消',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, selectedDate),
                      child: const Text(
                        '确定',
                        style: TextStyle(
                          color: Color(0xFF2DA66D),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  initialDateTime: selectedDate,
                  mode: mode,
                  use24hFormat: use24hFormat,
                  minimumDate: minimumDate,
                  maximumDate: maximumDate,
                  onDateTimeChanged: (DateTime newDateTime) {
                    selectedDate = newDateTime;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    return result;
  }
}
