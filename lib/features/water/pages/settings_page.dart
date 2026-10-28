import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../utils/navigation_helper.dart';
import '../utils/policy_texts.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('设置'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => goBackOr(context, '/profile'),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            _SettingsList(
              children: [
                _SettingsItem(
                  title: '用户协议',
                  onTap: () {
                    _showTextDialog(
                      context,
                      title: '用户协议',
                      content: PolicyTexts.userAgreement,
                    );
                  },
                ),
                _SettingsItem(
                  title: '隐私政策',
                  onTap: () {
                    _showTextDialog(
                      context,
                      title: '隐私政策',
                      content: PolicyTexts.privacyPolicy,
                    );
                  },
                ),
                _SettingsItem(
                  title: '个人信息收集清单',
                  onTap: () {
                    _showTextDialog(
                      context,
                      title: '个人信息收集清单',
                      content: '本应用为纯本地工具应用：\n\n1. 我们仅在您的设备本地记录您的昵称、性别、体重、饮水数据、饮品照片等信息。\n2. 所有数据均经过加密并仅保存在您的手机中。\n3. 我们绝不会将您的任何个人信息上传至云端服务器或出售给他人。',
                    );
                  },
                ),
                _SettingsItem(
                  title: '第三方共享与 SDK 清单',
                  onTap: () {
                    _showTextDialog(
                      context,
                      title: '第三方共享与 SDK 清单',
                      content: '当前版本郑重承诺：\n\n1. 未接入任何第三方广告 SDK。\n2. 未接入任何第三方云端数据统计分析 SDK（如友盟、神策等）。\n3. 您的所有数据只属于您自己，我们坚决不与任何第三方进行共享。',
                    );
                  },
                ),
                const _SettingsItem(
                  title: '版本信息',
                  trailingText: 'v1.0.3',
                  onTap: null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showTextDialog(
    BuildContext context, {
    required String title,
    required String content,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(content, style: const TextStyle(height: 1.55)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('我知道了'),
          ),
        ],
      ),
    );
  }
}

class _SettingsList extends StatelessWidget {
  final List<Widget> children;

  const _SettingsList({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF2E4D8)),
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final String? trailingText;

  const _SettingsItem({required this.title, this.onTap, this.trailingText});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            if (trailingText != null)
              Text(
                trailingText!,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              )
            else if (onTap != null)
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
