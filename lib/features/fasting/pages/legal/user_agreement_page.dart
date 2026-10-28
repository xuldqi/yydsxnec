import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:steps_webu_flutter/core/theme/app_colors.dart';

class UserAgreementPage extends StatelessWidget {
  const UserAgreementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('用户协议'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(32.0),
        child: Text(
          '''欢迎使用小鹿轻断食。在您使用本应用前，请仔细阅读本《用户协议》。

1. 服务说明
- 小鹿轻断食是一款提供轻断食计划记录与身体数据追踪的工具类应用。
- 本应用提供的所有建议和断食方案仅供参考，不能替代专业的医疗建议。在开始任何断食计划前，请确保您的身体状况适合，必要时请咨询医生。

2. 账号与数据
- 您的数据将优先存储在本地，以最大程度保护您的隐私。
- 请妥善保管您的设备，避免数据遗失。当前版本不提供账号登录和云端同步，您可以在“数据管理”中主动复制备份内容。

3. 用户行为规范
- 您不得利用本应用从事任何违反当地法律法规的行为。
- 对于违规使用、破解或恶意攻击本应用的行为，我们将保留追究法律责任的权利。

4. 协议修改
- 我们可能随时更新本协议。更新后的版本将在应用内公布。若您继续使用本应用，即表示接受修改后的协议。

5. 责任限制
- 本应用不保证提供的所有方案都能达到预期的减重或健康效果。因个人体质差异，用户应根据自身情况灵活调整。
- 因不可抗力或非应用自身原因导致的各类损失，本应用不承担任何赔偿责任。''',
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
