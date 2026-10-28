import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import 'mood_provider.dart';

class MoodRecordScreen extends ConsumerStatefulWidget {
  const MoodRecordScreen({super.key});

  @override
  ConsumerState<MoodRecordScreen> createState() => _MoodRecordScreenState();
}

class _MoodRecordScreenState extends ConsumerState<MoodRecordScreen> {
  int _selectedMood = 3; // 默认开心
  String _selectedEmoji = '😊';
  final TextEditingController _noteController = TextEditingController();

  final List<Map<String, dynamic>> _moodOptions = [
    {'index': 0, 'emoji': '😭', 'label': '难过', 'color': Color(0xFF64748B)},
    {'index': 1, 'emoji': '😤', 'label': '焦虑/生气', 'color': Color(0xFFEF4444)},
    {'index': 2, 'emoji': '😐', 'label': '平静/疲惫', 'color': Color(0xFFF59E0B)},
    {'index': 3, 'emoji': '😊', 'label': '开心', 'color': Color(0xFF3B82F6)},
    {'index': 4, 'emoji': '🥰', 'label': '幸福', 'color': Color(0xFF10B981)},
  ];

  final List<String> _quickTags = ['工作', '家庭', '运动', '朋友', '睡眠', '美食', '学习', '娱乐', '健康', '旅行'];

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _onSave() async {
    await ref.read(moodProvider.notifier).addRecord(
      mood: _selectedMood,
      emoji: _selectedEmoji,
      note: _noteController.text.trim(),
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('情绪记录已添加！'), duration: Duration(seconds: 1)),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('记录心情', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '你现在心情如何？',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 20),
            // 心情选择
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _moodOptions.map((opt) {
                final idx = opt['index'] as int;
                final isSelected = _selectedMood == idx;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedMood = idx;
                      _selectedEmoji = opt['emoji'] as String;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? (opt['color'] as Color).withValues(alpha: 0.15) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? (opt['color'] as Color) : Colors.transparent,
                        width: 2,
                      ),
                      boxShadow: isSelected
                          ? [BoxShadow(color: (opt['color'] as Color).withValues(alpha: 0.2), blurRadius: 8)]
                          : [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4, offset: const Offset(0, 2))],
                    ),
                    width: 64,
                    child: Column(
                      children: [
                        Text(opt['emoji'] as String, style: const TextStyle(fontSize: 32)),
                        const SizedBox(height: 6),
                        Text(
                          opt['label'] as String,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? (opt['color'] as Color) : AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 28),
            const Text(
              '添加想法或感受（可选）',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                controller: _noteController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: '记录这一刻的原因或想法...',
                  hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 14),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '快捷标签',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _quickTags.map((tag) {
                return ActionChip(
                  label: Text('# $tag', style: const TextStyle(fontSize: 12, color: AppColors.primary)),
                  backgroundColor: AppColors.primary.withValues(alpha: 0.08),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide.none),
                  onPressed: () {
                    final current = _noteController.text;
                    if (current.isEmpty) {
                      _noteController.text = '#$tag ';
                    } else {
                      _noteController.text = '$current #$tag ';
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  elevation: 2,
                ),
                child: const Text('保存心情记录', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
