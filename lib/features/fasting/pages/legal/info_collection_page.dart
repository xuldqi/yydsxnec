import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:steps_webu_flutter/core/theme/app_colors.dart';

class InfoCollectionPage extends StatelessWidget {
  const InfoCollectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('个人信息收集清单'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(32.0),
        child: Text(
          '''为了向您提供轻断食记录及健康管理服务，我们需要收集以下个人信息：

1. 个人资料信息
- 收集场景：当您主动完善个人资料时。
- 收集内容：昵称、头像、本地头像路径、性别、出生年份、身高、目标体重。
- 收集目的：用于个人展示、BMI 参考、饮水量建议和计划推荐。

2. 健康记录数据
- 收集场景：当您主动记录断食、体重、饮水、运动或饮食时。
- 收集内容：断食开始/结束时间、体重数据、饮水记录、运动记录、饮食记录、周计划。
- 收集目的：为您生成健康分析图表、提供个性化建议和断食历程统计。

3. 本地备份数据
- 收集场景：当您主动使用“数据管理”的导出或恢复功能时。
- 收集内容：您选择导出的健康记录 JSON 或 CSV 文本。
- 收集目的：用于本机数据备份、迁移和恢复。

4. 权限使用说明
- 相机/相册权限：用于设置个人头像。
- 通知权限：用于在断食目标达成时向您发送提醒（需您主动授权）。

以上信息均以本地保存为主。当前版本不提供账号登录和云端同步服务。''',
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
