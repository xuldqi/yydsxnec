// 心情标签管理 (MoodTagManageActivity)
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';

class MoodTagScreen extends StatefulWidget {
  const MoodTagScreen({super.key});
  @override
  State<MoodTagScreen> createState() => _MoodTagScreenState();
}

class _MoodTagScreenState extends State<MoodTagScreen> {
  final _tags = <String>['工作', '家庭', '运动', '朋友', '睡眠', '美食', '学习', '娱乐', '健康', '旅行'];
  final _inputCtrl = TextEditingController();

  @override
  void dispose() {
    _inputCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('标签管理')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppDimens.spacingMd),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _inputCtrl,
                    decoration: InputDecoration(
                      hintText: '新标签',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(onPressed: _add, child: const Text('添加')),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(AppDimens.spacingMd),
              itemCount: _tags.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (c, i) {
                final t = _tags[i];
                return ListTile(
                  leading: const Icon(Icons.tag_rounded, color: AppColors.primary),
                  title: Text(t),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, color: AppColors.textHint),
                    onPressed: () => setState(() => _tags.removeAt(i)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _add() {
    final t = _inputCtrl.text.trim();
    if (t.isEmpty || _tags.contains(t)) return;
    setState(() {
      _tags.add(t);
      _inputCtrl.clear();
    });
  }
}
