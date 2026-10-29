import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/capybara_provider.dart';
import '../models/capybara_state.dart';
import '../widgets/capybara_pet_widget.dart';

class CapybaraSanctuaryScreen extends ConsumerStatefulWidget {
  const CapybaraSanctuaryScreen({super.key});

  @override
  ConsumerState<CapybaraSanctuaryScreen> createState() =>
      _CapybaraSanctuaryScreenState();
}

class _CapybaraSanctuaryScreenState
    extends ConsumerState<CapybaraSanctuaryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const List<CapybaraAccessory> _allAccessories = [
    CapybaraAccessory(
      id: 'orange',
      name: '蜜汁甜橘',
      description: '心如止水，专注顶橘',
      cost: 0,
      icon: Icons.brightness_1_rounded,
    ),
    CapybaraAccessory(
      id: 'duck',
      name: '温泉小黄鸭',
      description: '泡澡最佳浮水搭档',
      cost: 100,
      icon: Icons.cruelty_free_rounded,
    ),
    CapybaraAccessory(
      id: 'sakura',
      name: '春日樱花',
      description: '落英缤纷温柔香气',
      cost: 150,
      icon: Icons.filter_vintage_rounded,
    ),
    CapybaraAccessory(
      id: 'glasses',
      name: '酷黑墨镜',
      description: '超酷自律墨镜豚',
      cost: 200,
      icon: Icons.visibility_rounded,
    ),
    CapybaraAccessory(
      id: 'towel',
      name: '泡汤头巾',
      description: '日式折叠热敷毛巾',
      cost: 250,
      icon: Icons.dry_cleaning_rounded,
    ),
  ];

  static const List<CapybaraScene> _allScenes = [
    CapybaraScene(
      id: 'onsen',
      name: '日式暖汤',
      description: '雾气氤氲，温水滋养',
      cost: 0,
      gradientColors: [Color(0xFFFAF7F2), Color(0xFFF1EAE0)],
      icon: Icons.hot_tub_rounded,
    ),
    CapybaraScene(
      id: 'grassland',
      name: '绿意草原',
      description: '微风轻抚，青草香气',
      cost: 180,
      gradientColors: [Color(0xFFF4FAF5), Color(0xFFE8F4EC)],
      icon: Icons.park_rounded,
    ),
    CapybaraScene(
      id: 'bedroom',
      name: '静谧卧室',
      description: '柔和夜灯，安心沉睡',
      cost: 260,
      gradientColors: [Color(0xFFFAF7F5), Color(0xFFF2ECE6)],
      icon: Icons.bedtime_rounded,
    ),
    CapybaraScene(
      id: 'autumn',
      name: '枫叶小径',
      description: '暖金秋阳，悠然散步',
      cost: 350,
      gradientColors: [Color(0xFFFDF7F0), Color(0xFFF7ECDF)],
      icon: Icons.eco_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final capyState = ref.watch(capybaraProvider);

    // Current Scene Gradient
    final currentScene = _allScenes.firstWhere(
      (s) => s.id == capyState.currentSceneId,
      orElse: () => _allScenes.first,
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              currentScene.gradientColors.first,
              currentScene.gradientColors.last,
              const Color(0xFFFBF9F5),
            ],
            stops: const [0.0, 0.45, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 1. Navigation Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          size: 20, color: Color(0xFF2D2522)),
                    ),
                    const Text(
                      '水豚小窝',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF2D2522),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFECE4D8)),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x087A533E),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Text('💛', style: TextStyle(fontSize: 14)),
                          const SizedBox(width: 4),
                          Text(
                            '${capyState.hearts}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF2D2522),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Interactive Capybara Sanctuary Stage
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  children: [
                    // Speech Bubble
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 36),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0A000000),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              capyState.activeDialogue,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2D2522),
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Big Interactive Capybara Pet
                    CapybaraPetWidget(
                      mood: capyState.mood,
                      accessoryId: capyState.currentAccessoryId,
                      size: 180,
                      onPet: () => ref.read(capybaraProvider.notifier).pet(),
                    ),

                    const SizedBox(height: 6),

                    // Status Pill
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: capyState.mood.badgeBg,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: capyState.mood.badgeColor.withValues(alpha: 0.25)),
                          ),
                          child: Text(
                            '状态：${capyState.mood.label} · ${capyState.mood.statusDesc}',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                              color: capyState.mood.badgeColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFECE4D8)),
                          ),
                          child: Text(
                            '陪伴第 ${capyState.companionshipDays} 天',
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF7D726D),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 3. Segmented Control Tabs (衣橱 / 场景 / 任务)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFE8DE),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0A000000),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  labelColor: const Color(0xFF2D2522),
                  unselectedLabelColor: const Color(0xFF8C7E77),
                  labelStyle:
                      const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                  unselectedLabelStyle:
                      const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: '小衣橱'),
                    Tab(text: '治愈场景'),
                    Tab(text: '健康任务'),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // 4. Tab Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildAccessoriesTab(context, capyState),
                    _buildScenesTab(context, capyState),
                    _buildHealthTasksTab(context, capyState),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Tab 1: Accessories (小衣橱) ──────────────────────────────────────────────
  Widget _buildAccessoriesTab(BuildContext context, CapybaraState capyState) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: _allAccessories.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final item = _allAccessories[index];
        final isUnlocked = capyState.unlockedAccessories.contains(item.id);
        final isEquipped = capyState.currentAccessoryId == item.id;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: isEquipped
                ? Border.all(color: const Color(0xFF6366F1), width: 1.5)
                : null,
            boxShadow: const [
              BoxShadow(
                color: Color(0x06000000),
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isEquipped
                      ? const Color(0xFFEEF2FF)
                      : const Color(0xFFF8FAFC),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  item.icon,
                  color: isEquipped
                      ? const Color(0xFF6366F1)
                      : const Color(0xFF64748B),
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E1B4B),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.description,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
              _buildActionButton(
                isEquipped: isEquipped,
                isUnlocked: isUnlocked,
                cost: item.cost,
                userHearts: capyState.hearts,
                onEquip: () =>
                    ref.read(capybaraProvider.notifier).equipAccessory(item.id),
                onUnlock: () {
                  final ok = ref
                      .read(capybaraProvider.notifier)
                      .unlockAccessory(item.id, item.cost);
                  if (!ok) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('💛 爱心不足，去完成每日健康任务收集爱心吧~'),
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Tab 2: Scenes (场景) ───────────────────────────────────────────────────
  Widget _buildScenesTab(BuildContext context, CapybaraState capyState) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: _allScenes.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final scene = _allScenes[index];
        final isUnlocked = capyState.unlockedScenes.contains(scene.id);
        final isEquipped = capyState.currentSceneId == scene.id;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: isEquipped
                ? Border.all(color: const Color(0xFF6366F1), width: 1.5)
                : null,
            boxShadow: const [
              BoxShadow(
                color: Color(0x06000000),
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: scene.gradientColors,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(scene.icon, color: const Color(0xFF4338CA), size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      scene.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E1B4B),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      scene.description,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
              _buildActionButton(
                isEquipped: isEquipped,
                isUnlocked: isUnlocked,
                cost: scene.cost,
                userHearts: capyState.hearts,
                onEquip: () =>
                    ref.read(capybaraProvider.notifier).equipScene(scene.id),
                onUnlock: () {
                  final ok = ref
                      .read(capybaraProvider.notifier)
                      .unlockScene(scene.id, scene.cost);
                  if (!ok) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('💛 爱心不足，去完成每日健康任务收集爱心吧~'),
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Tab 3: Health Tasks (健康任务愿望单) ──────────────────────────────────────
  Widget _buildHealthTasksTab(BuildContext context, CapybaraState capyState) {
    final tasks = [
      _HealthTask(
        title: '每日健康补水',
        desc: '打卡饮水 +250ml 保持水润',
        rewardHearts: 10,
        icon: Icons.water_drop_rounded,
        iconColor: const Color(0xFF0EA5E9),
        targetRoute: '/water',
      ),
      _HealthTask(
        title: '日常漫步 2,000 步',
        desc: '活动身心，告别久坐疲劳',
        rewardHearts: 20,
        icon: Icons.directions_walk_rounded,
        iconColor: const Color(0xFF10B981),
        targetRoute: '/sport',
      ),
      _HealthTask(
        title: '记录今日餐饮',
        desc: '规律饮食，把控热量营养',
        rewardHearts: 15,
        icon: Icons.restaurant_rounded,
        iconColor: const Color(0xFFEF4444),
        targetRoute: '/diet',
      ),
      _HealthTask(
        title: '开启/完成轻断食',
        desc: '给肠胃放假，进入燃脂代谢',
        rewardHearts: 50,
        icon: Icons.timer_outlined,
        iconColor: const Color(0xFFF97316),
        targetRoute: '/fasting',
      ),
      _HealthTask(
        title: '睡前助眠白噪音',
        desc: '伴随雨声潮汐安稳入梦',
        rewardHearts: 15,
        icon: Icons.nightlight_round,
        iconColor: const Color(0xFF6366F1),
        targetRoute: '/white-noise',
      ),
    ];

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: tasks.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final t = tasks[index];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Color(0x06000000),
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: t.iconColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(t.icon, color: t.iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          t.title,
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1E1B4B),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '+${t.rewardHearts} 💛',
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFFD97706),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      t.desc,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  ref.read(capybaraProvider.notifier).rewardHealthTask(t.title, t.rewardHearts);
                  context.push(t.targetRoute);
                },
                child: Container(
                  height: 32,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text(
                      '去完成',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF6366F1),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required bool isEquipped,
    required bool isUnlocked,
    required int cost,
    required int userHearts,
    required VoidCallback onEquip,
    required VoidCallback onUnlock,
  }) {
    if (isEquipped) {
      return Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF6366F1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            '使用中',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    if (isUnlocked) {
      return GestureDetector(
        onTap: onEquip,
        child: Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: Text(
              '装扮',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Color(0xFF475569),
              ),
            ),
          ),
        ),
      );
    }

    final canAfford = userHearts >= cost;
    return GestureDetector(
      onTap: onUnlock,
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: canAfford ? const Color(0xFFFEF3C7) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(16),
          border: canAfford
              ? Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.4))
              : null,
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$cost',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: canAfford
                      ? const Color(0xFFB45309)
                      : const Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(width: 2),
              const Text('💛', style: TextStyle(fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }
}

class _HealthTask {
  final String title;
  final String desc;
  final int rewardHearts;
  final IconData icon;
  final Color iconColor;
  final String targetRoute;

  const _HealthTask({
    required this.title,
    required this.desc,
    required this.rewardHearts,
    required this.icon,
    required this.iconColor,
    required this.targetRoute,
  });
}
