import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:steps_webu_flutter/core/theme/app_colors.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('隐私政策'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(32.0),
        child: Text(
          '''我们非常重视您的隐私保护。本隐私政策说明了我们如何收集、使用和保护您的个人信息。

1. 信息收集
- 健康记录数据：当您主动使用本应用记录时，我们会在本机保存您的断食时间、体重、饮水、运动、饮食等数据。
- 个人资料数据：当您主动填写时，我们会在本机保存昵称、头像、身高、目标体重、出生年份等信息。

2. 信息使用
- 我们收集的信息仅用于在本地为您提供健康统计图表、趋势分析、提醒和备份恢复功能。
- 我们不会将您的个人隐私数据出售给任何第三方。

3. 信息存储与安全
- 您的数据默认存储在本地设备中。您可以在“数据管理”中主动复制备份 JSON 或 CSV 报表。
- 当前版本不提供账号登录和云端同步服务。如您自行复制、发送或保存备份内容，请妥善保管。

4. 您的权利
- 您有权随时查看、修改、删除您在应用内的个人数据。
- 您可以通过应用内的“数据管理”或相关设置清空所有数据。

5. 未成年人保护
我们不主动收集未成年人的个人信息。如果您未满18周岁，请在监护人陪同下阅读本政策，并确保获得监护人同意后使用我们的服务。''',
          style: TextStyle(
            fontSize: 15,
            color: AppColors.textPrimary,
            height: 1.6,
          ),
        ),
      ),
    );
  }
}
