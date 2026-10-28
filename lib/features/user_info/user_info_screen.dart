import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/user_profile_provider.dart';
import '../../core/theme/app_colors.dart';

class UserInfoScreen extends ConsumerStatefulWidget {
  const UserInfoScreen({super.key});
  @override
  ConsumerState<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends ConsumerState<UserInfoScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(userProfileProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final p = ref.watch(userProfileProvider);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Android F5F5F5 background
      appBar: AppBar(
        title: const Text('个人信息', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            color: Colors.white,
            child: Column(
              children: [
                _buildAvatarItem('头像', p.gender),
                const Divider(height: 1, indent: 15, color: Color(0xFFEEEEEE)),
                _buildTextItem('昵称', p.nickname, onTap: () => _editField('nickname', '昵称', p.nickname, isName: true)),
                const Divider(height: 1, indent: 15, color: Color(0xFFEEEEEE)),
                _buildTextItem('账号', '用户001'),
                const Divider(height: 1, indent: 15, color: Color(0xFFEEEEEE)),
                _buildTextItem('我的邀请码', '000000'),
                const Divider(height: 1, indent: 15, color: Color(0xFFEEEEEE)),
                _buildTextItem('性别', p.gender == 'female' ? '女' : '男', onTap: () => _pickGender(p)),
                const Divider(height: 1, indent: 15, color: Color(0xFFEEEEEE)),
                _buildTextItem('地区', '未设置'),
                const Divider(height: 1, indent: 15, color: Color(0xFFEEEEEE)),
                _buildTextItem('手机', '未绑定'),
              ],
            ),
          ),
          const Spacer(),
          // 退出按钮
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
            child: SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                onPressed: () {},
                child: const Text('退出', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAvatarItem(String label, String gender) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Row(
          children: [
            Expanded(child: Text(label, style: const TextStyle(color: Colors.black, fontSize: 15))),
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Icon(gender == 'female' ? Icons.face_3 : Icons.face, color: Colors.grey),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTextItem(String label, String value, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Row(
          children: [
            Text(label, style: const TextStyle(color: Colors.black, fontSize: 15)),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: const TextStyle(color: Colors.black54, fontSize: 14),
              ),
            ),
            if (onTap != null) ...[
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
            ] else ...[
              const SizedBox(width: 28), // 占位，对齐有箭头的行
            ]
          ],
        ),
      ),
    );
  }

  void _editField(String field, String label, String value, {bool isName = false}) async {
    final ctrl = TextEditingController(text: value);
    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text('修改$label'),
        content: TextField(
          controller: ctrl, autofocus: true,
          decoration: InputDecoration(hintText: '请输入$label'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, ctrl.text.trim()),
            child: const Text('保存'),
          ),
        ],
      ),
    );
    if (result != null && (isName ? result.isNotEmpty : true)) {
      final p = ref.read(userProfileProvider);
      final newP = p.copyWith(nickname: result);
      ref.read(userProfileProvider.notifier).update(newP);
    }
  }

  void _pickGender(UserProfile p) async {
    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('选择性别'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('男'),
              onTap: () => Navigator.pop(context, 'male'),
            ),
            ListTile(
              title: const Text('女'),
              onTap: () => Navigator.pop(context, 'female'),
            ),
          ],
        ),
      ),
    );
    if (result != null) {
      ref.read(userProfileProvider.notifier).update(p.copyWith(gender: result));
    }
  }
}
