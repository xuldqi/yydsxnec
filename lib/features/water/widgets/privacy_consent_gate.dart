import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../utils/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../utils/policy_texts.dart';

class PrivacyConsentGate extends StatefulWidget {
  final Widget child;
  final Future<void> Function()? onConsentReady;

  const PrivacyConsentGate({
    super.key,
    required this.child,
    this.onConsentReady,
  });

  @override
  State<PrivacyConsentGate> createState() => _PrivacyConsentGateState();
}

class _PrivacyConsentGateState extends State<PrivacyConsentGate> {
  static const _acceptedKey = 'privacy_consent_accepted_v1';

  bool _checking = true;
  bool _dialogShown = false;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _checkConsent();
  }

  Future<void> _checkConsent() async {
    final prefs = await SharedPreferences.getInstance();
    final accepted = prefs.getBool(_acceptedKey) ?? false;
    if (!mounted) return;
    if (accepted) {
      await _prepareAfterConsent();
    } else {
      setState(() => _checking = false);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showConsentDialog();
      });
    }
  }

  Future<void> _accept() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_acceptedKey, true);
    await _prepareAfterConsent();
    if (!mounted) return;
    Navigator.of(AppRouter.rootNavigatorKey.currentContext ?? context,
            rootNavigator: true)
        .pop();
  }

  Future<void> _prepareAfterConsent() async {
    if (_ready) return;
    await widget.onConsentReady?.call();
    if (!mounted) return;
    setState(() {
      _checking = false;
      _ready = true;
    });
  }

  void _showConsentDialog() {
    if (_dialogShown) return;
    _dialogShown = true;
    showDialog<void>(
      context: AppRouter.rootNavigatorKey.currentContext ?? context,
      barrierDismissible: false,
      builder: (dialogContext) => PopScope(
        canPop: false,
        child: AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 28),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            '隐私保护提示',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '欢迎使用小鹿喝水。我们会在本地保存你的饮水记录、饮品信息、昵称、目标和偏好，用于记录展示、统计和个性化设置。',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    height: 1.55,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '相机、相册和系统日历能力只会在你主动拍照、选择图片或添加日历提醒时使用。我们不会主动上传你的记录、照片或健康偏好。',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    height: 1.55,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 0,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text(
                      '查看并同意',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                    _PolicyLink(
                      text: '用户协议',
                      onTap: () {
                        final parentContext = AppRouter.rootNavigatorKey.currentContext ?? context;
                        Navigator.of(parentContext, rootNavigator: true).pop();
                        _dialogShown = false;
                        _showTextDialog(parentContext, title: '用户协议', content: PolicyTexts.userAgreement);
                      },
                    ),
                    const Text(
                      '和',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                    _PolicyLink(
                      text: '隐私政策',
                      onTap: () {
                        final parentContext = AppRouter.rootNavigatorKey.currentContext ?? context;
                        Navigator.of(parentContext, rootNavigator: true).pop();
                        _dialogShown = false;
                        _showTextDialog(parentContext, title: '隐私政策', content: PolicyTexts.privacyPolicy);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => _showRefuseConfirmDialog(dialogContext),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text('拒绝'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _accept,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text('同意'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _showRefuseConfirmDialog(BuildContext dialogContext) {
    showDialog<void>(
      context: AppRouter.rootNavigatorKey.currentContext ?? dialogContext,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('提示'),
        content: const Text('需要确认退出吗？'),
        actionsPadding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: SystemNavigator.pop,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('退出应用'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('返回'),
                ),
              ),
            ],
          )
        ],
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
            onPressed: () {
              Navigator.of(context).pop();
              if (mounted) _showConsentDialog();
            },
            child: const Text('我知道了'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_checking || !_ready) {
      return const ColoredBox(color: AppColors.background);
    }
    return widget.child;
  }
}

class _PolicyLink extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _PolicyLink({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(
          '《$text》',
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
