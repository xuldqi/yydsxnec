import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../emoon_entry.dart';

/// 隐私政策版本
const String kPrivacyPolicyVersion = '2026-04-17';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('隐私政策')),
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
              '隐私政策',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '最后更新日期：$kPrivacyPolicyVersion',
              style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
            ),
            SizedBox(height: 24),
            _buildSection(
              '引言与适用范围',
              '欢迎您使用“FOMO情绪”（以下简称“本应用”）。本应用由安徽通拓电子商务有限公司（以下简称“我们”或“公司”）提供，通过提供记录心情与情绪管理服务，协助您更好地管理个人情绪。本隐私政策适用于您通过本应用产生的全部数据和使用行为，请您在使用前仔细阅读。',
            ),
            _buildSection(
              '1. 信息收集范围',
              '本应用主要在本地运行。我们仅在实现核心功能所必需的范围内处理信息，目前不接入广告、统计或埋点 SDK。\n\n'
                  '• 心情记录：当您通过文字、图片、语音记录心情时，这些内容仅存储在您的设备本地。\n'
                  '• 设备基础信息：为了兼容适配与稳定性分析，我们可能处理设备机型、系统版本、应用崩溃日志等非直接身份识别信息。\n'
                  '• 我们不主动收集：通讯录、通话记录、短信、日历、精确位置信息、已安装应用列表，以及 IMEI、IMSI、MEID、OAID、Android ID、ICCID、SN、MAC 地址等设备标识信息。',
            ),
            _buildSection(
              '2. 权限使用说明',
              '• 相机权限：仅在您主动点击拍照功能时申请与使用。\n'
                  '• 相册/媒体访问：仅在您主动选择图片时，通过系统选择器读取您选中的文件。\n'
                  '• 麦克风权限：仅在您主动录制语音时申请与使用。\n'
                  '• 通知权限：仅在您开启每日提醒后申请与使用。\n'
                  '• 精确闹钟权限：仅用于您已开启的提醒定时功能。\n\n'
                  '*您可以随时在系统设置中撤回这些授权。',
            ),
            _buildSection(
              '3. 剪贴板信息说明',
              '• 使用目的：在输入框场景下，为您提供“粘贴”能力与输入体验。\n'
                  '• 处理方式：在部分系统中，输入框聚焦时系统组件可能检查剪贴板是否有文本；或您主动执行粘贴操作时读取剪贴板内容。\n'
                  '• 处理范围：仅限当前粘贴所需文本内容，不用于画像或广告，不上传服务器，不在本地长期存储。\n'
                  '• 触发时机：仅限您使用输入框相关功能时，不会在后台持续读取剪贴板。',
            ),
            _buildSection(
              '4. 信息使用与共享',
              '我们不会将会员提供的任何个人信息用于第三方平台、公司及个人。除非为了执行法律规定的行政或司法机关正式程序的要求。',
            ),
            _buildSection(
              '5. 数据存储与安全策略',
              '您的所有心情记录数据绝大部分存储在您的手机本地。我们极少可能收集您的非敏感、经过加密和非唯一识别的统计信息。建议您定期通过应用的备份或导出功能来进行数据备份，从而保证数据安全。',
            ),
            _buildSection(
              '6. 信息安全',
              '我们会通过加密手段保证您的数据传输（如果在未来有云备份的情形）、存储安全。但您也要妥善保护您的设备不被他人非法使用，以免引起数据泄露。',
            ),
            _buildSection(
              '7. 您的权利',
              '您对您的个人信息拥有绝对的权利。\n\n'
                  '• 请求查看：您可以访问应用内查看您已经公开的所有记录。\n'
                  '• 修改和删除：您可以随时手动修改或删除每一条隐私。\n'
                  '• 导出数据：您可以将您的数据备份后直接通过手机发送到其他设备（如电脑或云空间）进行存储。\n\n'
                  '本隐私政策涵盖的内容在更新后依然有效。后续若有重大的政策更新，会同步在应用内通知。',
            ),
            _buildSection(
              '8. 未成年人保护',
              '我们非常重视未成年人的个人信息保护。如果您是未成年人（未满18周岁），应在监护人的监护指导下阅读本隐私政策并取得监护人的同意后，方可使用。对于经监护人同意而收集的个人信息，我们只会由法律规定、法律允许且为了保障未成年人安全的情况下进行使用或暴露。',
            ),
            _buildSection(
              '9. 第三方 SDK',
              '本应用当前不接入广告、统计或埋点类第三方 SDK，也不会在启动时初始化此类 SDK。若未来因业务需要接入第三方 SDK，我们会重新更新本政策，明确说明其收集的个人信息类型、使用目的、共享对象及退出方式，并在法律要求范围内重新征得您的同意。',
            ),
            _buildSection(
              '10. 政策更新',
              '我们会适时更新本隐私政策。若政策有重大变更，我们会同步在应用内以通知栏或弹窗的形式对您发布。',
            ),
            _buildSection(
              '11. 联系我们',
              '如果您对本政策有任何疑问、意见或反馈，建议直接在本应用中反馈页中进行联系。我们会在受理后的 15 个自然日内进行反馈。我们也欢迎通过应用商店提供的开发者反馈方式联系。',
            ),
            SizedBox(height: 40),
            Center(
              child: Text(
                '© 2026 安徽通拓电子商务有限公司 版权所有',
                style: TextStyle(fontSize: 12, color: AppTheme.textHint),
              ),
            ),
            SizedBox(height: 20),
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
