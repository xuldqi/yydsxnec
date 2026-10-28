import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_colors.dart';

class SettingScreen extends ConsumerStatefulWidget {
  const SettingScreen({super.key});
  @override
  ConsumerState<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
  bool _personalizedAds = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _personalizedAds = p.getBool('personalized_ads') ?? true;
    });
  }

  Future<void> _saveBool(String k, bool v) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(k, v);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('设置', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        children: [
          // 第一组设置
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('关闭个性化推荐', style: TextStyle(fontSize: 16, color: Colors.black)),
                    Switch(
                      value: !_personalizedAds,
                      activeColor: AppColors.primary,
                      onChanged: (v) {
                        setState(() => _personalizedAds = !v);
                        _saveBool('personalized_ads', _personalizedAds);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  '关闭后会减少广告相关推荐，但不影响产品数据',
                  style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 12),

          // 第二组设置
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                _buildRow('用户协议', isArrow: true),
                _buildRow('隐私说明', isArrow: true),
                _buildRow('版本信息', value: '1.1.9'),
                _buildRow('联系我们', value: '公众号micro-target'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String title, {String? value, bool isArrow = false}) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 54,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 16, color: Colors.black)),
            if (value != null)
              Text(value, style: const TextStyle(fontSize: 15, color: Color(0xFF999999))),
            if (isArrow)
              const Icon(Icons.chevron_right, color: Color(0xFFCCCCCC), size: 20),
          ],
        ),
      ),
    );
  }
}
