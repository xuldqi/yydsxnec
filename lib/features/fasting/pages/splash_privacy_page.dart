import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/user_settings_provider.dart';
import 'package:steps_webu_flutter/core/theme/app_colors.dart';
import 'legal/privacy_policy_page.dart';
import 'legal/user_agreement_page.dart';

class SplashPrivacyPage extends ConsumerStatefulWidget {
  const SplashPrivacyPage({super.key});

  @override
  ConsumerState<SplashPrivacyPage> createState() => _SplashPrivacyPageState();
}

class _SplashPrivacyPageState extends ConsumerState<SplashPrivacyPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showPrivacyDialog();
    });
  }

  void _showPrivacyDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) => const _PrivacyDialogContent(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.eco, size: 100, color: AppColors.primary),
            const SizedBox(height: 24),
            Text(
              '小鹿轻断食',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrivacyDialogContent extends ConsumerWidget {
  const _PrivacyDialogContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.only(left: 24, right: 24, top: 32, bottom: 40),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '服务协议和隐私政策',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            const Text(
              '欢迎使用小鹿轻断食！',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text.rich(
              TextSpan(
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
                children: [
                  const TextSpan(text: '为了更好地保护您的个人信息，请在使用前仔细阅读并同意'),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const UserAgreementPage(),
                        ),
                      ),
                      child: const Text(
                        '《用户协议》',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const TextSpan(text: '和'),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const PrivacyPolicyPage(),
                        ),
                      ),
                      child: const Text(
                        '《隐私政策》',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const TextSpan(
                    text:
                        '。\n\n我们将严格按照政策要求使用和保护您的个人信息，为您提供断食计划推荐和数据统计服务。未经您的授权，我们不会将您的信息提供给任何第三方。',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ref.read(hasAgreedPrivacyProvider.notifier).agreePrivacy();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                elevation: 0,
              ),
              child: const Text(
                '同意并继续',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('不同意并退出', style: TextStyle(fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }
}
