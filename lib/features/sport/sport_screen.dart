import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';

class SportScreen extends ConsumerStatefulWidget {
  const SportScreen({super.key});

  @override
  ConsumerState<SportScreen> createState() => _SportScreenState();
}

class _SportScreenState extends ConsumerState<SportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildBannerSection(),
              _buildQuickSportSection(),
              _buildTrainingRecommendSection(),
              _buildSportChallengeCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '运动',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.calendar_month_rounded,
              color: AppColors.textPrimary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerSection() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      height: 120, // Placeholder height
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text('Banner Placeholder', style: TextStyle(color: AppColors.textHint)),
        ),
      ),
    );
  }

  Widget _buildQuickSportSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '常用运动',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Row(
                children: [
                  const Text(
                    '全部运动',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 14,
                    color: AppColors.textSecondary.withValues(alpha: 0.8),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Wrap(
            spacing: 0,
            runSpacing: 12,
            children: [
              _buildQuickSportIcon(Icons.directions_run_rounded, '户外跑', const Color(0xFFE9A056)),
              _buildQuickSportIcon(Icons.directions_run_rounded, '室内跑', const Color(0xFFE9A056).withValues(alpha: 0.8)),
              _buildQuickSportIcon(Icons.directions_walk_rounded, '健走', const Color(0xFF5BA772)),
              _buildQuickSportIcon(Icons.directions_bike_rounded, '骑行', const Color(0xFF6B8BCC)),
              _buildQuickSportIcon(Icons.fitness_center_rounded, '力量', const Color(0xFF676E96)),
              _buildQuickSportIcon(Icons.self_improvement_rounded, '瑜伽', const Color(0xFFE58763)),
              _buildQuickSportIcon(Icons.sports_tennis_rounded, '羽毛球', const Color(0xFF8672B1)), // using tennis icon as badminton placeholder
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickSportIcon(IconData icon, String label, Color bgColor) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 40) / 4, // 4 items per row
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainingRecommendSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Text(
            '为您推荐',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        SizedBox(
          height: 140,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return Container(
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text('Recommend $index', style: const TextStyle(color: AppColors.textHint)),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(12),
            child: const Icon(Icons.emoji_events_rounded, color: Color(0xFF4CAF50), size: 30),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '运动挑战',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  '每日完成 3 次运动目标',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text(
                      '0/3 次',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: const LinearProgressIndicator(
                          value: 0.0,
                          minHeight: 4,
                          backgroundColor: Color(0xFFEEEEEE),
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
