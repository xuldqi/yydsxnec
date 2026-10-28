import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../emoon_entry.dart';

class UserAgreementPage extends StatelessWidget {
  const UserAgreementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('用户协议')),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          AppTheme.pageHorizontalPadding,
          24,
          AppTheme.pageHorizontalPadding,
          24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '用户协议',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '生效日期：2026年2月15日',
              style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
            ),
            SizedBox(height: 24),
            _buildSection(
              '一、接受与适用范围',
              '欢迎您使用“FOMO情绪”（以下简称“本应用”）。本应用由安徽通拓电子商务有限公司（以下简称“我们”或“公司”）提供。您下载、安装、打开或使用本应用，即表示您已阅读、理解并同意接受本用户协议的全部内容。',
            ),
            _buildSection(
              '二、服务内容',
              '“FOMO情绪”是一款专注于心情记录与情绪管理的应用，主要功能包括：心情打卡、历史回顾、简单统计、多媒体记录等。具体功能以实际提供为准。',
            ),
            _buildSection(
              '三、知识产权',
              '本应用及相关内容的知识产权归安徽通拓电子商务有限公司所有。未经授权，不得擅自修改、复制或分发。',
            ),
            _buildSection('四、其他', '详细内容请参阅我们的隐私政策。如有疑问，请通过官方渠道联系。'),
            SizedBox(height: 40),
            Center(
              child: Text(
                '© 2026 安徽通拓电子商务有限公司 版权所有',
                style: TextStyle(fontSize: 12, color: AppTheme.textHint),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: AppTheme.textPrimary.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
