import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../core/database/app_database.dart';
import '../../core/services/health_providers.dart';
import '../../core/services/database_provider.dart';
import '../../core/theme/app_colors.dart';

class WaterScreen extends ConsumerStatefulWidget {
  const WaterScreen({super.key});

  @override
  ConsumerState<WaterScreen> createState() => _WaterScreenState();
}

class _WaterScreenState extends ConsumerState<WaterScreen> {
  
  @override
  Widget build(BuildContext context) {
    final waterAsync = ref.watch(waterProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          '喝水打卡',
          style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month_rounded, color: AppColors.textPrimary),
            onPressed: () {
              context.push('/water-history');
            },
          )
        ],
      ),
      body: waterAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, st) => Center(child: Text('Error: $e')),
        data: (waterState) {
          final total = waterState.todayTotal;
          final goal = waterState.goal;
          final percent = (goal > 0) ? (total / goal).clamp(0.0, 1.0) : 0.0;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              children: [
                _buildHeroCard(total, goal, percent),
                _buildQuickAddCard(),
                _buildRecordsCard(waterState.records),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeroCard(int total, int goal, double percent) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.only(top: 12, bottom: 40),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 260,
                height: 260,
                child: CircularPercentIndicator(
                  radius: 120.0,
                  lineWidth: 18.0,
                  animation: true,
                  percent: percent,
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: AppColors.primary,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Edit Target
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.divider,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Text(
                        '设置目标',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '$total',
                        style: const TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '/$goal ml',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _showWaterLogSheet(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(200, 52),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26),
              ),
            ),
            child: const Text(
              '+ 喝水打卡',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAddCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '快速补水',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildQuickAddBtn(200),
              const SizedBox(width: 8),
              _buildQuickAddBtn(300),
              const SizedBox(width: 8),
              _buildQuickAddBtn(500),
              const SizedBox(width: 8),
              _buildQuickAddBtn(750),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAddBtn(int amount) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          ref.read(waterProvider.notifier).addWater(amount);
        },
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Text(
            '+$amount 毫升',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecordsCard(List<WaterRecord> records) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '今日喝水记录',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                GestureDetector(
                  onTap: () => context.push('/water-history'),
                  child: const Text(
                    '更多 >',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          if (records.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Icon(Icons.water_drop_outlined, size: 60, color: AppColors.divider),
                    const SizedBox(height: 10),
                    const Text(
                      '暂无数据记录',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              itemCount: records.length,
              itemBuilder: (context, index) {
                final r = records[index];
                return ListTile(
                  leading: const Icon(Icons.water_drop_rounded, color: AppColors.primary),
                  title: Text(
                    '${r.amount} ml',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  trailing: Text(
                    DateFormat('HH:mm').format(r.time),
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  ),
                  onTap: () => _showWaterLogSheet(context, existingRecord: r),
                );
              },
            ),
        ],
      ),
    );
  }

  void _showWaterLogSheet(BuildContext context, {WaterRecord? existingRecord}) {
    int amount = existingRecord?.amount ?? 200;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                top: 24, left: 24, right: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(existingRecord != null ? '修改记录' : '记录饮水', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_rounded, size: 36),
                        color: AppColors.textHint,
                        onPressed: amount > 50 ? () => setState(() => amount -= 50) : null,
                      ),
                      Container(
                        width: 100, padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(child: Text('$amount ml',
                          style: const TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold))),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_rounded, size: 36),
                        color: AppColors.primary,
                        onPressed: () => setState(() => amount += 50),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      if (existingRecord != null) ...[
                        OutlinedButton(
                          onPressed: () async {
                            final db = ref.read(databaseProvider);
                            await db.deleteWaterRecord(existingRecord.id);
                            ref.invalidate(waterProvider);
                            if (mounted) Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.redAccent),
                            padding: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: const Icon(Icons.delete_outline, color: Colors.redAccent),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            final notifier = ref.read(waterProvider.notifier);
                            if (existingRecord != null) {
                              notifier.updateWater(existingRecord.copyWith(amount: amount));
                            } else {
                              notifier.addWater(amount);
                            }
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                          ),
                          child: const Text('保存', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
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
