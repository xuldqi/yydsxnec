import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

import '../core/constants/app_constants.dart' as constants;
import '../providers/fasting_provider.dart';
import '../providers/user_settings_provider.dart';
import 'package:steps_webu_flutter/core/theme/app_colors.dart';
import 'about_app_page.dart';
import 'data_management_page.dart';
import 'help_feedback_page.dart';
import 'notification_settings_page.dart';
import 'user_profile_edit_page.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  static const _bgTop = AppColors.background;
  static const _ink = AppColors.textPrimary;
  static const _muted = AppColors.textSecondary;
  static const _leaf = AppColors.primary;
  static const _leafDark = AppColors.primaryDark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgTop,
      body: Container(
        decoration: const BoxDecoration(gradient: const LinearGradient(colors: [AppColors.background, AppColors.surface])),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              32.0,
              16.0,
              32.0,
              40.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHero(),
                const SizedBox(height: 40.0),
                _sectionTitle('设置与功能'),
                const SizedBox(height: 24.0),
                _buildMenuSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHero() {
    final sessionsAsync = ref.watch(fastingSessionsProvider);
    final userProfileAsync = ref.watch(userProfileProvider);

    return sessionsAsync.when(
      data: (sessions) {
        final profile = userProfileAsync.asData?.value;
        final completed = sessions
            .where((s) => s.status == constants.FastingStatus.completed)
            .toList();

        final name = profile?.nickname?.trim().isNotEmpty == true
            ? profile!.nickname!.trim()
            : '轻断食用户';
        final level = completed.length >= 12
            ? '森林守护者'
            : completed.length >= 5
            ? '稳定生长期'
            : completed.isNotEmpty
            ? '新芽练习者'
            : '准备发芽';

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.divider),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF1B2B22,
                          ).withValues(alpha: 0.04),
                          blurRadius: 18,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: profile?.avatarPath != null
                          ? Image.file(File(profile!.avatarPath!))
                          : const Icon(
                              Icons.eco_rounded,
                              color: _leaf,
                              size: 42,
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: _ink,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          level,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: _leafDark,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24.0),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _openProfileEdit,
                  icon: const Icon(Icons.edit_rounded),
                  label: const Text('完善个人信息'),
                  style: FilledButton.styleFrom(
                    backgroundColor: _leaf,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    textStyle: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => _loadingPanel(),
      error: (_, __) => _profileFallback(),
    );
  }

  Widget _buildMenuSection() {
    final items = [
      _ProfileMenuItem(
        icon: Icons.notifications_outlined,
        title: '通知设置',
        color: AppColors.error,
        onTap: () => _push(const NotificationSettingsPage()),
      ),
      _ProfileMenuItem(
        icon: Icons.storage_rounded,
        title: '数据管理',
        color: AppColors.primary,
        onTap: () => _push(const DataManagementPage()),
      ),
      _ProfileMenuItem(
        icon: Icons.help_outline_rounded,
        title: '帮助与反馈',
        color: AppColors.info,
        onTap: () => _push(const HelpFeedbackPage()),
      ),
      _ProfileMenuItem(
        icon: Icons.info_outline_rounded,
        title: '关于应用',
        color: _muted,
        onTap: () => _push(const AboutAppPage()),
      ),
    ];

    return Column(
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _buildMenuItem(item),
            ),
          )
          .toList(),
    );
  }

  Widget _buildMenuItem(_ProfileMenuItem item) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(24.0),
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(24.0),
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.0),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Icon(item.icon, color: item.color, size: 23),
              ),
              const SizedBox(width: 24.0),
              Expanded(
                child: Text(
                  item.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: _ink,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              Icon(
                Icons.chevron_right_rounded,
                color: _muted.withValues(alpha: 0.72),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: _ink,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _loadingPanel() {
    return Container(
      height: 260,
      decoration: _panelDecoration(),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _profileFallback() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: Column(
        children: [
          const Icon(Icons.eco_rounded, color: _leaf, size: 44),
          const SizedBox(height: 10),
          Text(
            '轻断食用户',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: _ink,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '档案加载失败，可以稍后重试或编辑个人信息。',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: _muted,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _panelDecoration() {
    return BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16.0),
      border: Border.all(color: AppColors.divider),
      boxShadow: [BoxShadow(color: Color(0x1A000000), blurRadius: 10, offset: Offset(0, 4))],
    );
  }

  void _openProfileEdit() {
    _push(const UserProfileEditPage());
  }

  void _push(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}

class _ProfileMenuItem {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });
}
