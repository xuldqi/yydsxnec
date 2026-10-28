import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/user_profile_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F8),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEFEBFA), Color(0xFFF3F4F8), Color(0xFFEBEFF9)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 4, bottom: 16),
                  child: Text(
                    '个人中心',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1E1B4B),
                    ),
                  ),
                ),
                _buildUserCard(context, userProfile),
                const SizedBox(height: 14),
                _buildWeekSportReportCard(context),
                const SizedBox(height: 14),
                _buildTwinCards(context),
                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.only(left: 4, bottom: 12),
                  child: Text(
                    '常用工具',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
                _buildToolsCard(context),
                const SizedBox(height: 14),
                _buildSettingsCard(context),
                const SizedBox(height: 32),
                const Center(
                  child: Text(
                    '微刻运动 v1.3.0 · 守护您的健康每一天',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, UserProfile profile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF818CF8)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              profile.gender == 'female'
                  ? Icons.face_3_rounded
                  : Icons.face_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.nickname,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1B4B),
                  ),
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () => context.push('/user-info'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '编辑个人资料',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.chevron_right,
                            size: 12, color: Color(0xFF64748B)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekSportReportCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF6366F1).withValues(alpha: 0.1),
            const Color(0xFF0EA5E9).withValues(alpha: 0.05),
          ],
        ),
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.insights, size: 18, color: Color(0xFF6366F1)),
                  SizedBox(width: 6),
                  Text(
                    '运动周报',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6366F1),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => context.push('/achievement-poster'),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '生成海报',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '查看数据分析',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E1B4B),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '点击查看本周步数、热量与习惯对比分析',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTwinCards(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => context.push('/daily'),
            child: Container(
              padding: const EdgeInsets.all(16),
              height: 112,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 14,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '健康周报',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1B4B),
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '查看本周睡眠、心情与身体指标洞察',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF64748B),
                      height: 1.3,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () => context.push('/goal'),
            child: Container(
              padding: const EdgeInsets.all(16),
              height: 112,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 14,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '目标管理',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1B4B),
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '管理步数、饮水、睡眠等健康目标',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF64748B),
                      height: 1.3,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToolsCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildNavRow(context, '权限中心',
              icon: Icons.shield_outlined, route: '/permission'),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          _buildNavRow(context, '数据导出与管理',
              icon: Icons.download_rounded, route: '/data-export'),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          _buildNavRow(context, '勋章成就库',
              icon: Icons.emoji_events_outlined, route: '/achievements'),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: _buildNavRow(context, '设置与隐私协议',
          icon: Icons.settings_outlined, route: '/setting'),
    );
  }

  Widget _buildNavRow(BuildContext context, String title,
      {required IconData icon, String? route}) {
    return InkWell(
      onTap: route != null ? () => context.push(route) : null,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Icon(icon, size: 20, color: const Color(0xFF6366F1)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E1B4B),
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFFCBD5E1),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
