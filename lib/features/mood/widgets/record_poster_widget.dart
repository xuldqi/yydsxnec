import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/emotion_record.dart';


class RecordPosterWidget extends StatelessWidget {
  final EmotionRecord record;

  const RecordPosterWidget({super.key, required this.record});

  String _formatFullDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateToCheck = DateTime(date.year, date.month, date.day);

    if (dateToCheck == today) {
      return '今天 ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (dateToCheck == today.subtract(const Duration(days: 1))) {
      return '昨天 ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.year}年${date.month}月${date.day}日 ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor =
        AppTheme.moodColors[record.mood] ?? AppTheme.primaryColor;

    return Container(
      width: 375, // 固定宽度保证生成的图片清晰度
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            themeColor.withValues(alpha: 0.1),
            AppTheme.backgroundColor,
            themeColor.withValues(alpha: 0.05),
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 顶部：日期和时间
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 40, 24, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatFullDate(record.createdAt),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textHint,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '星期${_getWeekday(record.createdAt.weekday)}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textHint,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(record.emoji, style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 6),
                      Text(
                        record.mood,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: themeColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 中间：心情内容或者时光胶囊提示文字
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: themeColor.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: _buildContent(),
            ),
          ),

          const SizedBox(height: 40),

          // 底部：品牌标识 (FOMO情绪)
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppTheme.primaryColor, AppTheme.primaryColor],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.nature,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'FOMO情绪',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                        letterSpacing: 1.5,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '记录心情 · 温暖相伴',
                      style: TextStyle(fontSize: 12, color: AppTheme.textHint),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (record.isTimeCapsule &&
        record.unlockAt != null &&
        record.unlockAt!.isAfter(DateTime.now())) {
      return Column(
        children: [
          Icon(Icons.lock_clock, size: 48, color: AppTheme.primaryColor),
          const SizedBox(height: 16),
          const Text(
            '一份寄给未来的时光胶囊',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            '在这之前，\n秘密被完美封存。',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    if (record.note.trim().isEmpty) {
      // 没有文字内容
      return Column(
        children: [
          Text(record.emoji, style: const TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text(
            '此刻的心情：${record.mood}',
            style: const TextStyle(fontSize: 16, color: AppTheme.textSecondary),
          ),
        ],
      );
    }

    // 正常显示文字内容
    return Text(
      record.note.trim(),
      style: const TextStyle(
        fontSize: 16,
        color: AppTheme.textPrimary,
        height: 1.8,
        letterSpacing: 0.5,
      ),
      textAlign: TextAlign.justify,
    );
  }

  String _getWeekday(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return '一';
      case DateTime.tuesday:
        return '二';
      case DateTime.wednesday:
        return '三';
      case DateTime.thursday:
        return '四';
      case DateTime.friday:
        return '五';
      case DateTime.saturday:
        return '六';
      case DateTime.sunday:
        return '日';
      default:
        return '';
    }
  }
}
