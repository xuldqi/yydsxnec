import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/fasting_session.dart';
import '../providers/fasting_provider.dart';
import 'package:steps_webu_flutter/core/theme/app_colors.dart';

class FastingCelebrationPage extends ConsumerStatefulWidget {
  final FastingSession session;

  const FastingCelebrationPage({super.key, required this.session});

  @override
  ConsumerState<FastingCelebrationPage> createState() =>
      _FastingCelebrationPageState();
}

class _FastingCelebrationPageState
    extends ConsumerState<FastingCelebrationPage> {
  String? _selectedMood;

  final List<Map<String, String>> _moods = [
    {'icon': '🥳', 'label': '开心'},
    {'icon': '😌', 'label': '平静'},
    {'icon': '🥱', 'label': '疲惫'},
    {'icon': '🤤', 'label': '饿了'},
    {'icon': '😵', 'label': '头晕'},
  ];

  @override
  Widget build(BuildContext context) {
    final session = widget.session;
    final hours = session.actualFastingDurationHours.toStringAsFixed(1);
    final isSuccess =
        session.actualFastingDurationMinutes >=
        session.plannedFastingDurationMinutes;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // 庆祝图标
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSuccess
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : AppColors.warning.withValues(alpha: 0.1),
                ),
                child: Center(
                  child: Text(
                    isSuccess ? '🏆' : '💪',
                    style: const TextStyle(fontSize: 60),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // 标题
              Text(
                isSuccess ? '恭喜完成目标！' : '提前结束了？没关系！',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '本次断食时长: $hours 小时',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 48),

              // 心情选择区
              const Text(
                '现在感觉怎么样？',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _moods.map((mood) {
                  final isSelected = _selectedMood == mood['label'];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedMood = mood['label'];
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.15)
                            : Colors.transparent,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.divider,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      child: Column(
                        children: [
                          Text(
                            mood['icon']!,
                            style: const TextStyle(fontSize: 28),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            mood['label']!,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.w800
                                  : FontWeight.w600,
                              color: isSelected
                                  ? AppColors.primaryDark
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

              const Spacer(),

              // 底部按钮
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  onPressed: _saveRecord,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  child: const Text(
                    '保存记录',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _saveRecord() {
    ref
        .read(fastingSessionsProvider.notifier)
        .endFasting(widget.session.id, mood: _selectedMood);
    Navigator.of(context).pop();
  }
}
