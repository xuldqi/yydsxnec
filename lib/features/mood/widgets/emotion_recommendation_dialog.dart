import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/ai_emotion_result.dart';

/// 情绪推荐弹窗
/// 当 AI 分析出情绪后，询问用户是否采纳
class EmotionRecommendationDialog extends StatelessWidget {
  final AiEmotionResult result;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const EmotionRecommendationDialog({
    super.key,
    required this.result,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // AI 标识
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.auto_awesome,
                    size: 16,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'AI 识别结果',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 情绪显示
            Text(result.emoji, style: const TextStyle(fontSize: 64)),
            const SizedBox(height: 12),
            Text(
              result.mood,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),

            // 置信度
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: _getConfidenceColor(
                  result.confidence,
                ).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '置信度：${(result.confidence * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 13,
                  color: _getConfidenceColor(result.confidence),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // 来源说明
            Text(
              _getSourceText(result.source),
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 24),

            // 按钮
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onReject,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      side: BorderSide(
                        color: AppTheme.textHint.withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Text(
                      '自己选择',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onAccept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      '就用这个',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.7) return const Color(0xFF4CAF50);
    if (confidence >= 0.5) return const Color(0xFFFF9800);
    return const Color(0xFFFF5722);
  }

  String _getSourceText(String source) {
    switch (source) {
      case 'text':
        return '基于文字内容分析';
      case 'voice':
        return '基于语音语调分析';
      case 'face':
        return '基于面部表情分析';
      default:
        return '基于智能分析';
    }
  }
}

/// 显示情绪推荐弹窗的辅助函数
Future<bool> showEmotionRecommendation(
  BuildContext context, {
  required AiEmotionResult result,
}) async {
  final accepted = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => EmotionRecommendationDialog(
      result: result,
      onAccept: () => Navigator.pop(context, true),
      onReject: () => Navigator.pop(context, false),
    ),
  );
  return accepted ?? false;
}
