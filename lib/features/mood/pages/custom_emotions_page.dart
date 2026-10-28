import 'package:flutter/material.dart';
import '../theme/app_theme.dart';


import '../services/database_service.dart';

class CustomEmotionsPage extends StatefulWidget {
  const CustomEmotionsPage({super.key});

  @override
  State<CustomEmotionsPage> createState() => _CustomEmotionsPageState();
}

class _CustomEmotionsPageState extends State<CustomEmotionsPage> {
  final DatabaseService _db = DatabaseService();
  List<String> _emotions = [];
  final TextEditingController _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final list = await _db.getCustomEmotions();
    if (mounted) setState(() => _emotions = list);
  }

  Future<void> _add() async {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    if (_emotions.contains(text)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('已存在该情绪词')));
      return;
    }
    _emotions = [..._emotions, text];
    await _db.saveCustomEmotions(_emotions);
    _inputController.clear();
    if (mounted) setState(() {});
  }

  Future<void> _remove(String item) async {
    _emotions = _emotions.where((e) => e != item).toList();
    await _db.saveCustomEmotions(_emotions);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '个人情绪词库',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppTheme.pageHorizontalPadding,
          20,
          AppTheme.pageHorizontalPadding,
          20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '添加自定义情绪词，记录心情时可在「此刻心情」中选择使用。',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    decoration: InputDecoration(
                      hintText: '输入情绪词，如：心累、上头',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => _add(),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton.filled(
                  onPressed: _add,
                  icon: const Icon(Icons.add),
                  style: IconButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              '已添加',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _emotions.isEmpty
                  ? Center(
                      child: Text(
                        '暂无自定义情绪词',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textHint,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _emotions.length,
                      itemBuilder: (context, i) {
                        final e = _emotions[i];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Text(
                                e,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.close, size: 20),
                                onPressed: () => _remove(e),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
