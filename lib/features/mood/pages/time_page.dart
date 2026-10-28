import 'package:flutter/material.dart';
import '../models/emotion_record.dart';
import '../theme/app_theme.dart';

import '../emoon_entry.dart' show EmotionRecord;
import 'record_detail_page.dart';
import '../services/database_service.dart';

class TimePage extends StatefulWidget {
  const TimePage({super.key});

  @override
  State<TimePage> createState() => _TimePageState();
}

class _TimePageState extends State<TimePage> {
  final DatabaseService _dbService = DatabaseService();
  List<EmotionRecord> _allCapsules = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCapsules();
  }

  Future<void> _loadCapsules() async {
    setState(() => _isLoading = true);
    try {
      final allRecordsData = await _dbService.getEmotionRecords();
      final allRecords = allRecordsData
          .map((m) => EmotionRecord.fromMap(m))
          .toList();
      final capsules = allRecords
          .where((r) => r.isTimeCapsule && r.unlockAt != null)
          .toList();
      capsules.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      setState(() {
        _allCapsules = capsules;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading capsules: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final locked = _allCapsules
        .where((r) => r.unlockAt != null && r.unlockAt!.isAfter(now))
        .toList();
    locked.sort((a, b) => a.unlockAt!.compareTo(b.unlockAt!));
    final unlocked = _allCapsules
        .where((r) => r.unlockAt != null && !r.unlockAt!.isAfter(now))
        .toList();
    unlocked.sort((a, b) => b.unlockAt!.compareTo(a.unlockAt!));

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('我的时光胶囊'),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            )
          : _allCapsules.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppTheme.pageHorizontalPadding,
                  24,
                  AppTheme.pageHorizontalPadding,
                  24,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock_clock_outlined,
                        size: 48,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      '还没有时光胶囊',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '在记录心情时开启「时光胶囊」，\n为未来的自己留下惊喜。',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: AppTheme.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(
                AppTheme.pageHorizontalPadding,
                20,
                AppTheme.pageHorizontalPadding,
                20,
              ),
              children: [
                if (locked.isNotEmpty) ...[
                  _buildSectionHeader('等待解锁', '这些心情正在被你封存，等待未来的某一天再打开。'),
                  const SizedBox(height: 12),
                  ...locked.map((r) => _buildCapsuleCard(r, true)),
                  const SizedBox(height: 24),
                ],
                if (unlocked.isNotEmpty) ...[
                  _buildSectionHeader('已经解锁', '这些是你已经回看的时刻，随时可以再次翻阅。'),
                  const SizedBox(height: 12),
                  ...unlocked.map((r) => _buildCapsuleCard(r, false)),
                ],
              ],
            ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
        ),
      ],
    );
  }

  Widget _buildCapsuleCard(EmotionRecord record, bool isLocked) {
    final unlockAt = record.unlockAt!;
    final unlockStr =
        '${unlockAt.year}年${unlockAt.month}月${unlockAt.day}日 ${unlockAt.hour.toString().padLeft(2, '0')}:${unlockAt.minute.toString().padLeft(2, '0')}';
    final createdStr =
        '${record.createdAt.year}年${record.createdAt.month}月${record.createdAt.day}日 ${record.createdAt.hour.toString().padLeft(2, '0')}:${record.createdAt.minute.toString().padLeft(2, '0')}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isLocked
            ? Border.all(
                color: AppTheme.primaryColor.withValues(alpha: 0.3),
                width: 1,
              )
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: isLocked
              ? () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('时光胶囊尚未解锁'),
                      content: Text(
                        '这个时光胶囊将在 $unlockStr 解锁。\n\n请耐心等待，为未来的自己保留这份惊喜。',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('知道了'),
                        ),
                      ],
                    ),
                  );
                }
              : () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecordDetailPage(
                        record: record,
                        onDeleted: _loadCapsules,
                      ),
                    ),
                  );
                  _loadCapsules();
                },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isLocked
                        ? AppTheme.primaryColor.withValues(alpha: 0.1)
                        : AppTheme.primaryLight.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isLocked ? Icons.lock_clock : Icons.lock_open,
                    color: isLocked
                        ? AppTheme.primaryColor
                        : AppTheme.primaryLight,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            record.emoji,
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              record.mood,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '创建于：$createdStr',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isLocked ? '解锁时间：$unlockStr' : '已于 $unlockStr 解锁',
                        style: TextStyle(
                          fontSize: 12,
                          color: isLocked
                              ? AppTheme.primaryColor
                              : AppTheme.textSecondary,
                          fontWeight: isLocked
                              ? FontWeight.w500
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppTheme.textHint),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
