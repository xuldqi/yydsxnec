import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/settings/privacy_policy_page.dart';
import '../pages/settings/user_agreement_page.dart';

/// 隐私政策同意弹窗
/// 首次启动应用时显示，用户必须同意后才能进入应用
class PrivacyConsentDialog extends StatelessWidget {
  const PrivacyConsentDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF5D8C64).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.privacy_tip_outlined,
                      color: Color(0xFF5D8C64),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      '隐私政策与用户协议',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E2D),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 内容区域
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '欢迎使用FOMO情绪！',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C3E2D),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '在使用本应用之前，请您仔细阅读并同意我们的隐私政策和用户协议。我们非常重视您的隐私保护，将按照法律法规的要求收集、使用和保护您的个人信息。',
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.6,
                          color: Color(0xFF6B7B6C),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 主要条款
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F6F1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTermItem(
                              '信息收集',
                              '我们仅处理实现功能必需的信息，主要为本地情绪记录和基础设备兼容信息。',
                            ),
                            const SizedBox(height: 12),
                            _buildTermItem(
                              '数据存储',
                              '您的数据主要存储在本地设备上，我们不会将您的个人信息出售给第三方。',
                            ),
                            const SizedBox(height: 12),
                            _buildTermItem(
                              '第三方 SDK',
                              '本应用当前不接入广告、统计或埋点类第三方 SDK，也不会在您同意前初始化此类能力。',
                            ),
                            const SizedBox(height: 12),
                            _buildTermItem(
                              '剪贴板说明',
                              '仅在输入框相关场景用于粘贴能力，不会在后台持续读取，不上传服务器。',
                            ),
                            const SizedBox(height: 12),
                            _buildTermItem('用户权利', '您有权访问、更正、删除您的个人信息，随时撤回同意。'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 链接区域
                      Row(
                        children: [
                          _buildLinkButton(
                            context,
                            '隐私政策',
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PrivacyPolicyPage(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          _buildLinkButton(
                            context,
                            '用户协议',
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const UserAgreementPage(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 按钮区域
              Column(
                children: [
                  // 同意按钮
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5D8C64),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        '同意并继续',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // 拒绝按钮
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () => _showRejectDialog(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF6B7B6C),
                        side: BorderSide(
                          color: const Color(0xFF6B7B6C).withValues(alpha: 0.3),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        '不同意',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTermItem(String title, String content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(top: 6),
          decoration: const BoxDecoration(
            color: Color(0xFF5D8C64),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E2D),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: Color(0xFF6B7B6C),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLinkButton(
    BuildContext context,
    String text,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF5D8C64).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF5D8C64),
          ),
        ),
      ),
    );
  }

  /// 显示拒绝后的提示弹窗
  void _showRejectDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.orange[400], size: 28),
            const SizedBox(width: 12),
            const Text('无法继续使用'),
          ],
        ),
        content: const Text(
          '很抱歉，根据相关法律法规要求，您需要同意隐私政策和用户协议才能使用本应用。\n\n如果您不同意，我们将无法为您提供服务。您可以点击"查看详情"了解更多信息。',
          style: TextStyle(fontSize: 14, height: 1.6, color: Color(0xFF6B7B6C)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('返回', style: TextStyle(color: Color(0xFF6B7B6C))),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // 退出应用
              _exitApp();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5D8C64),
              foregroundColor: Colors.white,
            ),
            child: const Text('退出应用'),
          ),
        ],
      ),
    );
  }

  /// 退出应用
  void _exitApp() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
  }
}

/// 隐私政策管理类
class PrivacyConsentManager {
  static const String _keyPrivacyConsent = 'privacy_consent_accepted';
  static const String _keyPrivacyConsentTime = 'privacy_consent_time';
  static const String _keyPrivacyPolicyVersion = 'privacy_policy_version';

  /// 检查是否已同意隐私政策
  static Future<bool> hasAccepted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyPrivacyConsent) ?? false;
  }

  /// 设置同意隐私政策。[policyVersion] 为当前同意的政策版本，政策重大更新时需重新征得同意。
  static Future<void> setAccepted(
    bool accepted, {
    String? policyVersion,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyPrivacyConsent, accepted);
    if (accepted) {
      await prefs.setString(
        _keyPrivacyConsentTime,
        DateTime.now().toIso8601String(),
      );
      if (policyVersion != null) {
        await prefs.setString(_keyPrivacyPolicyVersion, policyVersion);
      }
    } else {
      await prefs.remove(_keyPrivacyPolicyVersion);
    }
  }

  /// 获取同意时间
  static Future<String?> getConsentTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPrivacyConsentTime);
  }

  /// 获取用户已同意的隐私政策版本
  static Future<String?> getAcceptedPolicyVersion() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPrivacyPolicyVersion);
  }

  /// 当前政策版本已更新，需要用户重新同意（已同意过但版本与 [currentVersion] 不一致时返回 true）
  static Future<bool> needsReConsent(String currentVersion) async {
    if (!await hasAccepted()) return false;
    final acceptedVersion = await getAcceptedPolicyVersion();
    return acceptedVersion != currentVersion;
  }

  /// 重置同意状态（用于测试）
  static Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyPrivacyConsent);
    await prefs.remove(_keyPrivacyConsentTime);
    await prefs.remove(_keyPrivacyPolicyVersion);
  }
}
