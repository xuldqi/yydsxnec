import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:flutter/services.dart';
import '../services/database_service.dart';
import '../emoon_entry.dart' show HomePage;

class AppLockPage extends StatefulWidget {
  final String expectedPin;

  const AppLockPage({super.key, required this.expectedPin});

  @override
  State<AppLockPage> createState() => _AppLockPageState();
}

class _AppLockPageState extends State<AppLockPage> {
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();
  bool _error = false;

  void _onPinChanged() => setState(() {});

  @override
  void initState() {
    super.initState();
    _pinController.addListener(_onPinChanged);
  }

  @override
  void dispose() {
    _pinController.removeListener(_onPinChanged);
    _pinController.dispose();
    _pinFocusNode.dispose();
    super.dispose();
  }

  Future<void> _unlock() async {
    final pin = _pinController.text.trim();
    if (pin == widget.expectedPin) {
      // 保存解锁时间
      final prefs = await DatabaseService().prefs;
      await prefs.setInt(
        'last_unlock_time',
        DateTime.now().millisecondsSinceEpoch,
      );

      if (!mounted) return;
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
    } else {
      setState(() {
        _error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppTheme.pageHorizontalPadding,
            32,
            AppTheme.pageHorizontalPadding,
            32,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.lock_outline,
                  size: 40,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                '输入解锁密码',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '为了保护你的记录，需要先解锁应用',
                style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 24),
              Center(
                child: _PinDotsInput(
                  controller: _pinController,
                  focusNode: _pinFocusNode,
                  error: _error,
                  onComplete: _unlock,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _unlock,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    '解锁',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              if (_error)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    '密码错误，请重试',
                    style: TextStyle(fontSize: 13, color: Colors.red.shade400),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 4 位数字密码输入：居中显示，未输入为 · ，输入后显示数字
class _PinDotsInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool error;
  final VoidCallback onComplete;

  const _PinDotsInput({
    required this.controller,
    required this.focusNode,
    required this.error,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => focusNode.requestFocus(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (i) {
              final len = controller.text.length;
              final hasDigit = i < len;
              final char = hasDigit ? controller.text[i] : '·';
              return Container(
                width: 48,
                height: 56,
                margin: EdgeInsets.only(left: i > 0 ? 12 : 0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: error ? Colors.red.shade400 : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Text(
                  char,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: hasDigit ? AppTheme.textPrimary : AppTheme.textHint,
                  ),
                ),
              );
            }),
          ),
          SizedBox(
            width: 0,
            height: 0,
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              keyboardType: TextInputType.number,
              maxLength: 4,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              obscureText: true,
              decoration: const InputDecoration(
                counterText: '',
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (_) {
                if (controller.text.length == 4) {
                  onComplete();
                }
              },
              onSubmitted: (_) => onComplete(),
            ),
          ),
        ],
      ),
    );
  }
}
