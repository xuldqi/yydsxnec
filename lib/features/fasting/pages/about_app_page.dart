import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../core/constants/app_constants.dart';
import 'package:steps_webu_flutter/core/theme/app_colors.dart';
import 'legal/user_agreement_page.dart';
import 'legal/privacy_policy_page.dart';
import 'legal/info_collection_page.dart';
import 'legal/third_party_sdk_page.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('关于应用'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.eco_rounded,
                  size: 50,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '小鹿轻断食',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Version ${AppConstants.appVersion}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 60),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 32.0),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24.0),
                border: Border.all(color: AppColors.divider),
              ),
              child: Column(
                children: [
                  _buildListTile(
                    context,
                    title: '用户协议',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const UserAgreementPage(),
                      ),
                    ),
                  ),
                  _buildDivider(),
                  _buildListTile(
                    context,
                    title: '隐私政策',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PrivacyPolicyPage(),
                      ),
                    ),
                  ),
                  _buildDivider(),
                  _buildListTile(
                    context,
                    title: '个人信息收集清单',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const InfoCollectionPage(),
                      ),
                    ),
                  ),
                  _buildDivider(),
                  _buildListTile(
                    context,
                    title: '第三方 SDK 共享清单',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ThirdPartySdkPage(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.textSecondary,
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 32.0,
      endIndent: 32.0,
      color: AppColors.divider,
    );
  }
}
