import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';

class SleepRecordScreen extends ConsumerStatefulWidget {
  const SleepRecordScreen({super.key});

  @override
  ConsumerState<SleepRecordScreen> createState() => _SleepRecordScreenState();
}

class _SleepRecordScreenState extends ConsumerState<SleepRecordScreen> {
  DateTime _sleepTime = DateTime.now().subtract(const Duration(hours: 8));
  DateTime _wakeTime = DateTime.now();
  int _quality = 3; // 1-5
  final Set<String> _factors = {};
  final TextEditingController _noteCtrl = TextEditingController();

  final List<String> _allFactors = ['咖啡因', '头痛', '压力', '禁食', '加班', '疼痛'];
  
  final List<Map<String, dynamic>> _qualities = [
    {'icon': '😖', 'label': '很差', 'val': 1},
    {'icon': '☹️', 'label': '较差', 'val': 2},
    {'icon': '😐', 'label': '一般', 'val': 3},
    {'icon': '😊', 'label': '较好', 'val': 4},
    {'icon': '😁', 'label': '很好', 'val': 5},
  ];

  String _formatDuration() {
    final diff = _wakeTime.difference(_sleepTime);
    if (diff.isNegative) return '时间错误';
    final h = diff.inHours;
    final m = diff.inMinutes % 60;
    return '${h}小时 ${m}分钟';
  }

  void _pickTime(bool isSleep) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        DateTime temp = isSleep ? _sleepTime : _wakeTime;
        return Container(
          height: 300,
          color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        if (isSleep) _sleepTime = temp;
                        else _wakeTime = temp;
                      });
                      Navigator.pop(context);
                    }, 
                    child: const Text('确定'),
                  ),
                ],
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: temp,
                  onDateTimeChanged: (val) => temp = val,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leadingWidth: 70,
        leading: TextButton(
          onPressed: () => context.pop(),
          child: const Text('取消', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
        ),
        title: const Text('添加睡眠', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('保存', style: TextStyle(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTimePickerCard(),
            const SizedBox(height: 12),
            _buildDurationCard(),
            const SizedBox(height: 12),
            _buildQualityCard(),
            const SizedBox(height: 12),
            _buildFactorsCard(),
            const SizedBox(height: 12),
            _buildNoteCard(),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                elevation: 0,
              ),
              child: const Text('保存', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePickerCard() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _pickTime(true),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.bedtime_rounded, color: Colors.indigo[400], size: 16),
                      const SizedBox(width: 6),
                      const Text('入睡时间', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${_sleepTime.hour.toString().padLeft(2,'0')} : ${_sleepTime.minute.toString().padLeft(2,'0')}',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => _pickTime(false),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wb_sunny_rounded, color: Colors.amber[400], size: 16),
                      const SizedBox(width: 6),
                      const Text('起床时间', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${_wakeTime.hour.toString().padLeft(2,'0')} : ${_wakeTime.minute.toString().padLeft(2,'0')}',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationCard() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('睡眠时长', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          Text(_formatDuration(), style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildQualityCard() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('睡眠质量', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _qualities.map((q) {
              final isSel = _quality == q['val'];
              return GestureDetector(
                onTap: () => setState(() => _quality = q['val'] as int),
                child: Column(
                  children: [
                    Text(q['icon'] as String, style: const TextStyle(fontSize: 24)),
                    const SizedBox(height: 4),
                    Text(
                      q['label'] as String,
                      style: TextStyle(fontSize: 12, color: isSel ? AppColors.primary : AppColors.textSecondary, fontWeight: isSel ? FontWeight.bold : FontWeight.normal),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFactorsCard() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('了解自己', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          const Text('昨晚有什么事影响了你的睡眠？', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _allFactors.map((f) {
              final isSel = _factors.contains(f);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSel) _factors.remove(f);
                    else _factors.add(f);
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSel ? AppColors.primary : Colors.white,
                    border: Border.all(color: isSel ? AppColors.primary : AppColors.divider),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    f,
                    style: TextStyle(
                      color: isSel ? Colors.white : AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteCard() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('备注 (选填)', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          Container(
            height: 100,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: _noteCtrl,
              maxLines: null,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: '记录一下影响你睡眠的情况...',
                hintStyle: TextStyle(color: AppColors.textHint, fontSize: 14),
              ),
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  void _save() {
    // Save functionality
    context.pop();
  }
}
