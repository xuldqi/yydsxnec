import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'breathing_exercise_page.dart';
import 'relax_tools_page.dart';
import '../widgets/primary_page_header.dart';

class RelaxPage extends StatefulWidget {
  const RelaxPage({super.key});

  @override
  State<RelaxPage> createState() => _RelaxPageState();
}

class _RelaxPageState extends State<RelaxPage> {
  @override
  Widget build(BuildContext context) {
    final safeTop = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/emoon/images/bg_fangkong.png',
              fit: BoxFit.fitWidth,
              alignment: Alignment.topRight,
            ),
          ),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: false,
                pinned: false,
                expandedHeight: safeTop + PrimaryPageLayout.headerHeightOffset,
                toolbarHeight: 0,
                elevation: 0,
                shadowColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                forceMaterialTransparency: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: PrimaryPageHeader(
                    safeTop: safeTop,
                    title: '放空',
                    subtitle: '留一点空白，先把自己放回来',
                    titleColor: AppTheme.textPrimary,
                    subtitleColor: AppTheme.textSecondary,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppTheme.pageHorizontalPadding,
                    0,
                    AppTheme.pageHorizontalPadding,
                    18,
                  ),
                  child: _buildPrimaryBreathingCard(context),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.pageHorizontalPadding,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const _RelaxSectionLabel('轻工具'),
                    const SizedBox(height: 10),
                    _buildToolTile(
                      context: context,
                      title: '白噪音空间',
                      subtitle: '海浪、森林、风声和白噪音，离线循环播放。',
                      icon: Icons.headphones_rounded,
                      iconColor: const Color(0xFF6A9A8B),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const WhiteNoisePage(),
                          ),
                        );
                      },
                    ),
                    _buildToolTile(
                      context: context,
                      title: '正念练习',
                      subtitle: '把注意力慢慢带回现在。',
                      icon: Icons.self_improvement_rounded,
                      iconColor: const Color(0xFFD0A66F),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const GuidedRelaxPage(
                              title: '正念练习',
                              subtitle: '把注意力带回现在',
                              icon: Icons.self_improvement_rounded,
                              color: Color(0xFFD0A66F),
                              durationMinutes: 5,
                              steps: RelaxGuides.mindfulness,
                            ),
                          ),
                        );
                      },
                    ),
                    _buildToolTile(
                      context: context,
                      title: '身体扫描',
                      subtitle: '从额头到脚底松开紧绷。',
                      icon: Icons.accessibility_new_rounded,
                      iconColor: const Color(0xFF8E9F6D),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const GuidedRelaxPage(
                              title: '身体扫描',
                              subtitle: '把身体慢慢放松下来',
                              icon: Icons.accessibility_new_rounded,
                              color: Color(0xFF8E9F6D),
                              durationMinutes: 5,
                              steps: RelaxGuides.bodyScan,
                            ),
                          ),
                        );
                      },
                    ),
                    _buildToolTile(
                      context: context,
                      title: '睡前放松',
                      subtitle: '把今天先放到一边。',
                      icon: Icons.bedtime_rounded,
                      iconColor: const Color(0xFF7A74A8),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const GuidedRelaxPage(
                              title: '睡前放松',
                              subtitle: '不用努力睡着，先休息',
                              icon: Icons.bedtime_rounded,
                              color: Color(0xFF7A74A8),
                              durationMinutes: 4,
                              steps: RelaxGuides.sleep,
                            ),
                          ),
                        );
                      },
                    ),
                    _buildToolTile(
                      context: context,
                      title: '轻拉伸',
                      subtitle: '肩颈、胸口和眼睛轻轻舒展。',
                      icon: Icons.spa_rounded,
                      iconColor: const Color(0xFFB8896B),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const GuidedRelaxPage(
                              title: '轻拉伸',
                              subtitle: '把身体从紧绷里带出来',
                              icon: Icons.spa_rounded,
                              color: Color(0xFFB8896B),
                              durationMinutes: 3,
                              steps: RelaxGuides.stretch,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 18),
                    const _RelaxSectionLabel('卸下心事'),
                    const SizedBox(height: 10),
                    _buildFeatureCard(
                      context: context,
                      title: '情绪卸载纸条',
                      subtitle: '把暂时放不下的事写下来，它不会进入心情统计。',
                      icon: Icons.sticky_note_2_rounded,
                      iconColor: const Color(0xFFBD8B4E),
                      tags: ['烦心事', '想放下', '不想记录'],
                      buttonText: '写一张纸条',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const EmotionalReleasePage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                  ]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryBreathingCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor.withValues(alpha: 0.16),
            AppTheme.primaryColor.withValues(alpha: 0.06),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.18),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const BreathingExercisePage()),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.72),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.air_rounded,
                      color: AppTheme.primaryColor,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '情绪急救：呼吸练习',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '只需 1 分钟，跟着光晕的指引，在一呼一吸间找回平静。',
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.5,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '开始练习',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToolTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white.withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 13, 12, 13),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppTheme.textHint,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required List<String> tags,
    required String buttonText,
    required VoidCallback onTap,
  }) {
    final isAvailable = buttonText != '即将推出';

    return Container(
      padding: const EdgeInsets.all(22),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [iconColor.withAlpha(12), iconColor.withAlpha(38)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: iconColor.withAlpha(51), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
          onTap: isAvailable ? onTap : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: iconColor.withAlpha(51),
                      shape: BoxShape.circle,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: iconColor.withAlpha(51),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Icon(icon, color: iconColor, size: 28),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            fontSize: 13,
                            height: 1.5,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(178),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Text(
                      '适合：${tags.join("、")}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: isAvailable
                      ? iconColor
                      : AppTheme.textHint.withAlpha(76),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      buttonText,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    if (isAvailable) ...[
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RelaxSectionLabel extends StatelessWidget {
  final String text;

  const _RelaxSectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w800,
        color: AppTheme.primaryColor,
      ),
    );
  }
}
