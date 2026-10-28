import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import 'mood_provider.dart';

class MoodHomeScreen extends ConsumerStatefulWidget {
  const MoodHomeScreen({super.key});
  @override
  ConsumerState<MoodHomeScreen> createState() => _MoodHomeScreenState();
}

class _MoodHomeScreenState extends ConsumerState<MoodHomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(moodProvider.notifier).load());
  }

  String _getTodayMoodText(List<EmotionRecord> records) {
    final now = DateTime.now();
    final todayRecord = records.where((r) =>
        r.createdAt.year == now.year &&
        r.createdAt.month == now.month &&
        r.createdAt.day == now.day).firstOrNull;

    if (todayRecord == null) {
      return '未记录';
    }
    return ['难过', '焦虑/生气', '平静/疲惫', '开心', '幸福'][todayRecord.mood.clamp(0, 4)];
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(moodProvider);
    final state = asyncState.valueOrNull ?? const MoodState();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('心情记录', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart_rounded, color: AppColors.primary, size: 24),
            tooltip: '情绪统计',
            onPressed: () => context.push('/mood/stats'),
          ),
          IconButton(
            icon: const Icon(Icons.local_offer_outlined, color: AppColors.textSecondary, size: 22),
            tooltip: '标签管理',
            onPressed: () => context.push('/mood/tags'),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 今日心情显示 & 统计分析按钮
          Container(
            padding: const EdgeInsets.all(20),
            color: const Color(0xFFF5F5F5),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '今日心情：${_getTodayMoodText(state.records)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => context.push('/mood/stats'),
                  icon: const Icon(Icons.pie_chart_outline_rounded, size: 16),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    foregroundColor: AppColors.primary,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    minimumSize: const Size(0, 36),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                  label: const Text('统计分析', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          
          // 历史记录标题
          const Padding(
            padding: EdgeInsets.only(left: 20, top: 10, bottom: 5),
            child: Text(
              '历史记录',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),

          // 历史记录列表
          Expanded(
            child: state.records.isEmpty
                ? const Center(
                    child: Text('暂无记录', style: TextStyle(color: Color(0xFF999999), fontSize: 14)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 5, bottom: 80),
                    itemCount: state.records.length,
                    itemBuilder: (context, index) {
                      final record = state.records[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          leading: Text(record.emoji, style: const TextStyle(fontSize: 28)),
                          title: Text(
                            ['难过', '焦虑/生气', '平静/疲惫', '开心', '幸福'][record.mood.clamp(0, 4)],
                            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(DateFormat('MM-dd HH:mm').format(record.createdAt), style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
                              if (record.note.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(record.note, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/mood/record'),
        backgroundColor: const Color(0xFFE0E0E0),
        elevation: 8,
        child: const Icon(Icons.add_rounded, color: Color(0xFF666666), size: 32),
      ),
    );
  }
}
