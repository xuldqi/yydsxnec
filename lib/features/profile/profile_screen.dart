import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/user_profile_provider.dart';
import '../capybara/providers/capybara_provider.dart';
import '../capybara/models/capybara_state.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);
    final capyState = ref.watch(capybaraProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F8),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 顶部大标题 + 设置入口
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '我的',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF2D2522),
                      letterSpacing: -0.5,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.push('/setting'),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x087A533E),
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.settings_outlined,
                        color: Color(0xFF8D5B4C),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 主滚动内容区
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 110),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 用户资料卡片 (去框化轻盈设计)
                    _buildUserCard(context, userProfile, capyState),
                    const SizedBox(height: 14),

                    // 运动周报海报卡片 (无框温润浮动卡)
                    _buildWeekSportReportCard(context),
                    const SizedBox(height: 14),

                    // 双子卡片：健康周报 & 目标管理 (无框化)
                    _buildTwinCards(context),
                    const SizedBox(height: 24),

                    // 常用工具
                    const Padding(
                      padding: EdgeInsets.only(left: 4, bottom: 12),
                      child: Text(
                        '常用工具',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF2D2522),
                        ),
                      ),
                    ),
                    _buildToolsCard(context),
                    const SizedBox(height: 14),

                    // 系统设置卡片 (无框化)
                    _buildSettingsCard(context),
                    const SizedBox(height: 32),

                    // 底部品牌文字
                    const Center(
                      child: Text(
                        '微刻运动 · 守护您的健康每一天',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFB8ACA4),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── 1. 用户资料卡片 ────────────────────────────────────────────────────
  Widget _buildUserCard(
      BuildContext context, UserProfile profile, CapybaraState capyState) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x067A533E),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // 治愈圆形头像 (水豚伴侣或人物)
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: Color(0xFFFAF3EE),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x0A8D5B4C),
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/capybara_mascot.png',
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Icon(
                  profile.gender == 'female'
                      ? Icons.face_3_rounded
                      : Icons.face_rounded,
                  color: const Color(0xFF8D5B4C),
                  size: 32,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      profile.nickname.isEmpty ? '微刻旅人' : profile.nickname,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF2D2522),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => context.push('/user-info'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAF3EE),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              '编辑',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF8D5B4C),
                              ),
                            ),
                            SizedBox(width: 1),
                            Icon(
                              Icons.chevron_right_rounded,
                              size: 13,
                              color: Color(0xFF8D5B4C),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // 陪伴徽章胶囊 (无边框，采用温润浅底)
                GestureDetector(
                  onTap: () => context.push('/capybara'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAF3EE),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '陪伴水豚 ${capyState.companionshipDays} 天',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF8D5B4C),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          '·',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFC7B8AF),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '💛 ${capyState.hearts}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF8D5B4C),
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Icon(
                          Icons.chevron_right_rounded,
                          size: 13,
                          color: Color(0xFF8D5B4C),
                        ),
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

  // ── 2. 运动周报海报卡片 (无框温润浮动卡) ──────────────────────────────────
  Widget _buildWeekSportReportCard(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/achievement-poster'),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Color(0x067A533E),
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
                Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8D5B4C).withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.insights_rounded,
                        size: 16,
                        color: Color(0xFF8D5B4C),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '运动周报',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF8D5B4C),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8D5B4C),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x188D5B4C),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Text(
                    '生成海报',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Text(
              '数据洞察与趋势',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
                color: Color(0xFF2D2522),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              '本周步数、消耗与生活习惯对比',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF8C7E77),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── 3. 双子卡片：健康周报 & 目标管理 (无框化) ────────────────────────────
  Widget _buildTwinCards(BuildContext context) {
    return Row(
      children: [
        // 健康周报
        Expanded(
          child: GestureDetector(
            onTap: () => context.push('/daily'),
            child: Container(
              padding: const EdgeInsets.all(16),
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x067A533E),
                    blurRadius: 14,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981)
                              .withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.auto_graph_rounded,
                          size: 17,
                          color: Color(0xFF10B981),
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        size: 18,
                        color: Color(0xFFC7B8AF),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        '健康周报',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF2D2522),
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        '睡眠、心情与身体洞察',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF8C7E77),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // 目标管理
        Expanded(
          child: GestureDetector(
            onTap: () => context.push('/goal'),
            child: Container(
              padding: const EdgeInsets.all(16),
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x067A533E),
                    blurRadius: 14,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFF8D5B4C)
                              .withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.track_changes_rounded,
                          size: 17,
                          color: Color(0xFF8D5B4C),
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        size: 18,
                        color: Color(0xFFC7B8AF),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        '目标管理',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF2D2522),
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        '管理步数、饮水与睡眠',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF8C7E77),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── 4. 常用工具卡片 (移除所有内部硬分割线，由呼吸留白自然分隔) ──────────
  Widget _buildToolsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x067A533E),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildNavRow(
            context,
            '水豚小窝与装扮',
            subtitle: '专属宠物装扮与治愈互动',
            icon: Icons.home_rounded,
            iconColor: const Color(0xFF8D5B4C),
            route: '/capybara',
          ),
          _buildNavRow(
            context,
            '勋章成就库',
            subtitle: '收集运动徽章与里程碑荣誉',
            icon: Icons.military_tech_rounded,
            iconColor: const Color(0xFFF59E0B),
            route: '/achievements',
          ),
          _buildNavRow(
            context,
            '数据导出与管理',
            subtitle: '个人健康与运动数据安全备份',
            icon: Icons.file_download_outlined,
            iconColor: const Color(0xFF0EA5E9),
            route: '/data-export',
          ),
          _buildNavRow(
            context,
            '权限与后台守护',
            subtitle: '计步自启动与传感器保活设置',
            icon: Icons.shield_outlined,
            iconColor: const Color(0xFF10B981),
            route: '/permission',
          ),
        ],
      ),
    );
  }

  // ── 5. 设置卡片 (无框化) ────────────────────────────────────────────────
  Widget _buildSettingsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x067A533E),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: _buildNavRow(
        context,
        '设置与隐私协议',
        subtitle: '偏好设置、账户安全与关于我们',
        icon: Icons.settings_outlined,
        iconColor: const Color(0xFF7D726D),
        route: '/setting',
      ),
    );
  }

  // ── 统一暖色无界导航行组件 ─────────────────────────────────────────────
  Widget _buildNavRow(
    BuildContext context,
    String title, {
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    String? route,
  }) {
    return InkWell(
      onTap: route != null ? () => context.push(route) : null,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2D2522),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF8C7E77),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFFC7B8AF),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
