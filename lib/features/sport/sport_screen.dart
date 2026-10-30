import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SportScreen extends ConsumerStatefulWidget {
  const SportScreen({super.key});

  @override
  ConsumerState<SportScreen> createState() => _SportScreenState();
}

class _SportScreenState extends ConsumerState<SportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F8),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 110),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildQuickSportSection(),
                    _buildTrainingRecommendSection(),
                    _buildSportChallengeCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '运动',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Color(0xFF2D2522),
              letterSpacing: -0.5,
            ),
          ),
          GestureDetector(
            onTap: () => context.push('/reports'),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
                border: Border.all(color: Colors.white.withValues(alpha: 0.9), width: 1.5),
              ),
              child: const Icon(
                Icons.insert_chart_outlined_rounded,
                color: Color(0xFF8D5B4C),
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickSportSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '快捷运动',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2D2522),
                ),
              ),
              GestureDetector(
                onTap: () => context.push('/movement-library'),
                child: Row(
                  children: const [
                    Text(
                      '全部运动库',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF8D5B4C),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 16,
                      color: Color(0xFF8D5B4C),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFECE4D8), width: 1.0),
            boxShadow: const [
              BoxShadow(
                color: Color(0x087A533E),
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildQuickSportIcon(Icons.directions_run_rounded, '户外跑', const Color(0xFFF97316)),
                  _buildQuickSportIcon(Icons.directions_walk_rounded, '健走', const Color(0xFF10B981)),
                  _buildQuickSportIcon(Icons.directions_bike_rounded, '骑行', const Color(0xFF0EA5E9)),
                  _buildQuickSportIcon(Icons.fitness_center_rounded, '力量训练', const Color(0xFF6366F1)),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildQuickSportIcon(Icons.straighten_rounded, '跳绳', const Color(0xFFEC4899)),
                  _buildQuickSportIcon(Icons.self_improvement_rounded, '瑜伽', const Color(0xFF8B5CF6)),
                  _buildQuickSportIcon(Icons.terrain_rounded, '登山', const Color(0xFFEAB308)),
                  _buildQuickSportIcon(Icons.apps_rounded, '更多运动', const Color(0xFF64748B), isMore: true),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickSportIcon(IconData icon, String label, Color bgColor, {bool isMore = false}) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (isMore) {
            context.push('/movement-library');
          } else {
            context.push('/count-time?type=$label');
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: bgColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: bgColor, size: 26),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2D2522),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainingRecommendSection() {
    final recommends = [
      {'title': '减脂全身激活', 'time': '20分钟', 'cal': '160 kcal', 'tag': '燃脂塑形', 'color': const Color(0xFFF97316)},
      {'title': '核心力量强化', 'time': '15分钟', 'cal': '120 kcal', 'tag': '腹部核心', 'color': const Color(0xFF8D5B4C)},
      {'title': '全身放松拉伸', 'time': '10分钟', 'cal': '50 kcal', 'tag': '运动后恢复', 'color': const Color(0xFF10B981)},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '推荐训练计划',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2D2522),
                ),
              ),
              GestureDetector(
                onTap: () => context.push('/training-plan'),
                child: Row(
                  children: const [
                    Text(
                      '查看全部',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF8D5B4C),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 16,
                      color: Color(0xFF8D5B4C),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 140,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: recommends.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final r = recommends[index];
              final color = r['color'] as Color;
              return GestureDetector(
                onTap: () => context.push('/training-plan'),
                child: Container(
                  width: 220,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFECE4D8), width: 1.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x087A533E),
                        blurRadius: 12,
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
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              r['tag'] as String,
                              style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Colors.grey.shade400),
                        ],
                      ),
                      Text(
                        r['title'] as String,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF2D2522),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.timer_outlined, size: 14, color: const Color(0xFF7D726D)),
                          const SizedBox(width: 4),
                          Text(r['time'] as String, style: const TextStyle(fontSize: 12, color: Color(0xFF7D726D))),
                          const SizedBox(width: 12),
                          Icon(Icons.local_fire_department_outlined, size: 14, color: const Color(0xFF7D726D)),
                          const SizedBox(width: 4),
                          Text(r['cal'] as String, style: const TextStyle(fontSize: 12, color: Color(0xFF7D726D))),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSportChallengeCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFECE4D8), width: 1.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0x087A533E),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.emoji_events_rounded, color: Color(0xFF10B981), size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '运动成就挑战',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2D2522),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '完成今日运动打卡，解锁专属徽章',
                  style: TextStyle(fontSize: 12, color: Color(0xFF7D726D)),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: const LinearProgressIndicator(
                    value: 0.5,
                    minHeight: 6,
                    backgroundColor: Color(0xFFE5DDD5),
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => context.push('/achievements'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFAF7F5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFECE4D8)),
              ),
              child: const Text('勋章馆', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF8D5B4C))),
            ),
          ),
        ],
      ),
    );
  }
}
