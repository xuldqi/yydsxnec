import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../core/database/app_database.dart';
import '../../core/services/health_providers.dart';
import '../../core/services/user_profile_provider.dart';

class WaterScreen extends ConsumerStatefulWidget {
  const WaterScreen({super.key});

  @override
  ConsumerState<WaterScreen> createState() => _WaterScreenState();
}

class _WaterScreenState extends ConsumerState<WaterScreen> {
  // 当前选中的饮品类型
  _BeverageType _selectedDrink = _beverageTypes[0];

  static final List<_BeverageType> _beverageTypes = [
    const _BeverageType(
      name: '白开水',
      icon: Icons.water_drop_rounded,
      color: Color(0xFF0EA5E9),
      hydrationRate: 1.0,
      desc: '100% 补水 · 纯净零卡',
    ),
    const _BeverageType(
      name: '黑咖啡',
      icon: Icons.coffee_rounded,
      color: Color(0xFF854D0E),
      hydrationRate: 0.85,
      desc: '85% 补水 · 提神醒脑',
    ),
    const _BeverageType(
      name: '绿茶/红茶',
      icon: Icons.emoji_food_beverage_rounded,
      color: Color(0xFF16A34A),
      hydrationRate: 0.90,
      desc: '90% 补水 · 清香解腻',
    ),
    const _BeverageType(
      name: '牛奶/豆浆',
      icon: Icons.local_drink_rounded,
      color: Color(0xFF6366F1),
      hydrationRate: 0.88,
      desc: '88% 补水 · 补充优质蛋白',
    ),
    const _BeverageType(
      name: '电解质水',
      icon: Icons.bolt_rounded,
      color: Color(0xFFF59E0B),
      hydrationRate: 1.0,
      desc: '100% 补水 · 迅速补充流失电解质',
    ),
    const _BeverageType(
      name: '柠檬气泡',
      icon: Icons.bubble_chart_rounded,
      color: Color(0xFF06B6D4),
      hydrationRate: 0.95,
      desc: '95% 补水 · 清爽生津',
    ),
  ];

  static const List<_CupPreset> _cupPresets = [
    _CupPreset(name: '小水杯', amount: 150, icon: Icons.coffee_rounded),
    _CupPreset(name: '马克杯', amount: 250, icon: Icons.local_cafe_rounded),
    _CupPreset(name: '玻璃杯', amount: 350, icon: Icons.local_drink_rounded),
    _CupPreset(name: '运动瓶', amount: 500, icon: Icons.sports_tennis_rounded),
    _CupPreset(name: '大保温杯', amount: 750, icon: Icons.filter_vintage_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final waterAsync = ref.watch(waterProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1E1B4B), size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          '饮水管理与打卡',
          style: TextStyle(
            color: Color(0xFF1E1B4B),
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded, color: Color(0xFF6366F1)),
            tooltip: '设置目标',
            onPressed: () => _showGoalSettingSheet(context),
          ),
          IconButton(
            icon: const Icon(Icons.history_rounded, color: Color(0xFF64748B)),
            tooltip: '历史记录',
            onPressed: () => context.push('/water-history'),
          ),
        ],
      ),
      body: waterAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF0EA5E9))),
        error: (e, st) => Center(child: Text('加载失败: $e')),
        data: (waterState) {
          final total = waterState.todayTotal;
          final goal = waterState.goal > 0 ? waterState.goal : 2000;
          final percent = (total / goal).clamp(0.0, 1.0);

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12).copyWith(bottom: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroProgressCard(total, goal, percent, waterState.records.length),
                const SizedBox(height: 16),
                _buildBeverageLibrarySection(),
                const SizedBox(height: 16),
                _buildQuickCupSection(context),
                const SizedBox(height: 16),
                _buildTodayLogSection(context, waterState.records),
                const SizedBox(height: 16),
                _buildHydrationTipsSection(),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── 1. Hero Progress Wave Card ──────────────────────────────────────────────
  Widget _buildHeroProgressCard(int total, int goal, double percent, int logCount) {
    final remaining = (goal - total).clamp(0, goal);
    final isDone = total >= goal;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0EA5E9).withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.water_drop_rounded, size: 18, color: Color(0xFF0EA5E9)),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '今日补水进度',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E1B4B),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => _showGoalSettingSheet(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: const [
                      Text('目标设置', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                      SizedBox(width: 2),
                      Icon(Icons.chevron_right_rounded, size: 14, color: Color(0xFF475569)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          CircularPercentIndicator(
            radius: 95.0,
            lineWidth: 16.0,
            animation: true,
            animateFromLastPercent: true,
            percent: percent,
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: isDone ? const Color(0xFF10B981) : const Color(0xFF0EA5E9),
            backgroundColor: const Color(0xFFE2E8F0),
            center: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isDone ? '🎉 达标' : '${(percent * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: isDone ? const Color(0xFF10B981) : const Color(0xFF1E1B4B),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '$total',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0284C7),
                      ),
                    ),
                    Text(
                      ' / $goal ml',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildHeroSubStat(
                  label: '还需补充',
                  value: isDone ? '已超额达成' : '$remaining ml',
                  color: isDone ? const Color(0xFF10B981) : const Color(0xFFEA580C),
                ),
                Container(width: 1, height: 26, color: const Color(0xFFE2E8F0)),
                _buildHeroSubStat(
                  label: '打卡次数',
                  value: '$logCount 次',
                  color: const Color(0xFF0284C7),
                ),
                Container(width: 1, height: 26, color: const Color(0xFFE2E8F0)),
                _buildHeroSubStat(
                  label: '达标状态',
                  value: isDone ? '极佳 🏆' : '进行中',
                  color: isDone ? const Color(0xFF10B981) : const Color(0xFF64748B),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSubStat({required String label, required String value, required Color color}) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: color)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500)),
      ],
    );
  }

  // ── 2. Beverage Library (饮品库选择器) ──────────────────────────────────────
  Widget _buildBeverageLibrarySection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 14,
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
              const Text(
                '选择饮品种类',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E1B4B),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _selectedDrink.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _selectedDrink.desc,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: _selectedDrink.color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 76,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _beverageTypes.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final drink = _beverageTypes[index];
                final isSelected = drink.name == _selectedDrink.name;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDrink = drink;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 74,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? drink.color.withValues(alpha: 0.15) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? drink.color : const Color(0xFFE2E8F0),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(drink.icon, color: drink.color, size: 22),
                        const SizedBox(height: 6),
                        Text(
                          drink.name,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                            color: isSelected ? drink.color : const Color(0xFF475569),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── 3. Quick Cup Sizes Presets ──────────────────────────────────────────────
  Widget _buildQuickCupSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 14,
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
                  const Text(
                    '快捷容器打卡',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E1B4B),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '(${_selectedDrink.name})',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _selectedDrink.color,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => _showCustomLogSheet(context),
                child: const Text(
                  '+ 自定义容量',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0EA5E9),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: _cupPresets.map((preset) {
              return Expanded(
                child: GestureDetector(
                  onTap: () => _recordWater(preset.amount),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      children: [
                        Icon(preset.icon, size: 20, color: _selectedDrink.color),
                        const SizedBox(height: 6),
                        Text(
                          '${preset.amount}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1E1B4B),
                          ),
                        ),
                        const Text(
                          'ml',
                          style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ── 4. Today Timeline Water Log ─────────────────────────────────────────────
  Widget _buildTodayLogSection(BuildContext context, List<WaterRecord> records) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 14,
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
              const Text(
                '今日饮水时间轴',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E1B4B),
                ),
              ),
              if (records.isNotEmpty)
                Text(
                  '共 ${records.length} 笔记录',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (records.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                children: const [
                  Text('🦦', style: TextStyle(fontSize: 48)),
                  SizedBox(height: 10),
                  Text(
                    '今天还没有饮水打卡哦',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '点击上方杯子规格，一键记录补水吧！',
                    style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                  ),
                ],
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: records.length,
              separatorBuilder: (_, _) => const Divider(height: 16, color: Color(0xFFF1F5F9)),
              itemBuilder: (context, index) {
                // Latest first
                final r = records[records.length - 1 - index];
                final effectiveMl = (r.amount * _selectedDrink.hydrationRate).round();

                return Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0EA5E9).withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.water_drop_rounded, color: Color(0xFF0284C7), size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                r.waterType,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1E1B4B),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '+${r.amount} ml',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF0284C7),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '有效补水约 $effectiveMl ml',
                            style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      DateFormat('HH:mm').format(r.time),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(width: 6),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Color(0xFFCBD5E1)),
                      onPressed: () => _deleteRecord(r.id),
                    ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }

  // ── 5. Scientific Hydration Tips ────────────────────────────────────────────
  Widget _buildHydrationTipsSection() {
    final tips = [
      {'time': '07:00 晨起温水', 'desc': '唤醒肠道与代谢，降低血液黏稠度', 'icon': Icons.wb_sunny_rounded},
      {'time': '10:30 上午工间', 'desc': '及时补充脑力代谢水分，预防疲劳', 'icon': Icons.work_outline_rounded},
      {'time': '14:30 午后活力', 'desc': '来杯清茶或柠檬水，提神促消化', 'icon': Icons.local_cafe_outlined},
      {'time': '20:00 晚间小饮', 'desc': '分次小口微量补水，避免起夜', 'icon': Icons.nightlight_outlined},
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '💡 科学饮水黄金时段',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E1B4B),
            ),
          ),
          const SizedBox(height: 12),
          Column(
            children: tips.map((t) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Icon(t['icon'] as IconData, size: 16, color: const Color(0xFF0EA5E9)),
                    const SizedBox(width: 8),
                    Text(
                      t['time'] as String,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1B4B),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        t['desc'] as String,
                        style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ── Actions: Record Water ───────────────────────────────────────────────────
  void _recordWater(int amount) {
    final effective = (amount * _selectedDrink.hydrationRate).round();
    ref.read(waterProvider.notifier).addWater(amount, type: _selectedDrink.name);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '已记录：$amount ml ${_selectedDrink.name} (有效补水 $effective ml) 💧',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF0284C7),
      ),
    );
  }

  void _deleteRecord(int id) {
    ref.read(waterProvider.notifier).deleteWater(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('已删除该条饮水记录'),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ── BottomSheet: Goal Setting ───────────────────────────────────────────────
  void _showGoalSettingSheet(BuildContext context) {
    final userProfile = ref.read(userProfileProvider);
    final weightKg = userProfile.weightKg > 0 ? userProfile.weightKg : 60.0;
    final recommendedGoal = (weightKg * 35 / 50).round() * 50; // 近似取整到50ml

    int currentGoal = ref.read(waterProvider).valueOrNull?.goal ?? 2000;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(26))),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '设置每日饮水目标',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1B4B)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0EA5E9).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.auto_awesome_rounded, color: Color(0xFF0284C7), size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '科学建议：基于您的体重 (${weightKg.toInt()}kg × 35ml)，推荐每日摄入 $recommendedGoal ml',
                            style: const TextStyle(fontSize: 12, color: Color(0xFF0284C7), fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline_rounded, size: 36, color: Color(0xFF0EA5E9)),
                        onPressed: currentGoal > 1000
                            ? () => setModalState(() => currentGoal -= 100)
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '$currentGoal ml',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1E1B4B),
                        ),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline_rounded, size: 36, color: Color(0xFF0EA5E9)),
                        onPressed: currentGoal < 5000
                            ? () => setModalState(() => currentGoal += 100)
                            : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(waterProvider.notifier).setGoal(currentGoal);
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('每日饮水目标已更新为 $currentGoal ml 🎯'),
                            duration: const Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0EA5E9),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: const Text('保存设定', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ── BottomSheet: Custom Log ─────────────────────────────────────────────────
  void _showCustomLogSheet(BuildContext context) {
    int customAmount = 300;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(26))),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '自定义记录 ${_selectedDrink.name}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E1B4B)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline_rounded, size: 36, color: Color(0xFF0EA5E9)),
                        onPressed: customAmount > 50
                            ? () => setModalState(() => customAmount -= 50)
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '$customAmount ml',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1E1B4B),
                        ),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline_rounded, size: 36, color: Color(0xFF0EA5E9)),
                        onPressed: customAmount < 2000
                            ? () => setModalState(() => customAmount += 50)
                            : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _recordWater(customAmount);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0EA5E9),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: const Text('立即打卡', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _BeverageType {
  final String name;
  final IconData icon;
  final Color color;
  final double hydrationRate;
  final String desc;

  const _BeverageType({
    required this.name,
    required this.icon,
    required this.color,
    required this.hydrationRate,
    required this.desc,
  });
}

class _CupPreset {
  final String name;
  final int amount;
  final IconData icon;

  const _CupPreset({
    required this.name,
    required this.amount,
    required this.icon,
  });
}
