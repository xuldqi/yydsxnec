import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:steps_webu_flutter/core/theme/app_colors.dart';

class ThirdPartySdkPage extends StatelessWidget {
  const ThirdPartySdkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('第三方 SDK 共享清单'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(32.0),
        child: Text(
          '''为保障本应用相关功能的实现与应用的安全稳定运行，我们可能会接入第三方提供的软件开发包（SDK）。目前我们接入的第三方 SDK 详情如下：

1. 极光推送 SDK (可选)
- 涉及个人信息：设备标识符（IMEI/MAC/Android ID/IDFA/OpenUDID/GUID/SIM卡IMSI信息等）、网络状态。
- 使用目的：为用户提供定时断食提醒和目标完成通知推送。
- 隐私政策链接：https://www.jiguang.cn/license/privacy

2. 友盟统计 SDK (可选)
- 涉及个人信息：设备标识符、网络设备硬件地址（MAC）、设备型号、操作系统及应用崩溃日志。
- 使用目的：用于统计应用使用情况、分析崩溃原因并改善应用稳定性。
- 隐私政策链接：https://www.umeng.com/page/policy

3. 微信开放平台 SDK (可选)
- 涉及个人信息：网络状态、设备信息。
- 使用目的：用于支持微信快捷登录以及分享打卡记录至微信朋友圈/好友。
- 隐私政策链接：https://open.weixin.qq.com/cgi-bin/frame?t=news/protocol_developer_tmpl

(注：以上 SDK 仅在实际接入使用时才会生效。如果当前版本为纯本地版本，则未向任何第三方共享您的数据。)''',
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
