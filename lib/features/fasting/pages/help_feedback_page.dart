import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'package:flutter/services.dart';

import '../components/modern_card.dart';
import 'package:steps_webu_flutter/core/theme/app_colors.dart';
import '../utils/app_toast.dart';

/// 帮助与反馈页面
class HelpFeedbackPage extends StatelessWidget {
  const HelpFeedbackPage({super.key});

  static const String _supportEmail = 'support@lightfasting.app';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('帮助与反馈'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '常见问题',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            _buildFaqCard(
              context,
              title: '为什么断食计时会有轻微误差？',
              content:
                  '应用会在前后台之间切换时根据系统时间进行校对，但在某些极端情况下仍可能出现 1-2 分钟的轻微差异，'
                  '这不会影响整体断食效果，请以大致时长为主。',
            ),
            const SizedBox(height: 8.0),
            _buildFaqCard(
              context,
              title: '数据会上传到服务器吗？',
              content:
                  '目前所有断食记录和健康数据都仅保存在您的设备本地，不会上传到云端。'
                  '您可以在“数据管理”中随时清除本地数据。',
            ),
            const SizedBox(height: 8.0),
            _buildFaqCard(
              context,
              title: '如何安全地开始轻断食？',
              content:
                  '轻断食并不适合所有人。如果您有慢性疾病、孕期/哺乳期或正在服药，请务必先咨询医生。'
                  '应用提供的是日常习惯管理工具，不能替代专业医疗建议。',
            ),
            const SizedBox(height: 32.0),
            Text(
              '联系与反馈',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            ModernCard(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(
                              alpha: 0.08,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: const Icon(
                            Icons.mail_outline,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 24.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '邮件反馈',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 16.0),
                              Text(
                                '如果您在使用过程中遇到问题或有功能建议，欢迎通过邮件联系我们。',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _supportEmail,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () async {
                            await Clipboard.setData(
                              const ClipboardData(text: _supportEmail),
                            );
                            if (context.mounted) {
                              showAppToast(
                                context,
                                '邮箱地址已复制',
                                type: AppToastType.success,
                              );
                            }
                          },
                          icon: const Icon(Icons.copy, size: 18),
                          label: const Text('复制邮箱'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqCard(
    BuildContext context, {
    required String title,
    required String content,
  }) {
    return ModernCard(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8.0),
            Text(
              content,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
